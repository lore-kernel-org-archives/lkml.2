Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0IFAv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0IFAvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:54 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 07/10] ovl: add initial revalidate support
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005029.20775.80833.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dentry_revalidate method and fail validation of either the
upper or lower dentry has been renamed or unlinked directly in the
otherlying filesystem.
This allows such changes to appear promptly in the overlay providing
the file isn't currently in use.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 656cad7..cdeafa7 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -409,9 +409,64 @@ static void ovl_dentry_iput(struct dentry *dentry, struct inode *inode)
 	iput(inode);
 }
 
+static int ovl_still_valid(struct dentry *dentry,
+			     struct dentry *parent, struct dentry *child)
+{
+	/* dentry is in the overlay filesystem
+	 * child is the corresponding dentry in the upper or lower layer
+	 * parent is the corresponding dentry of dentry's parent in the same layer
+	 *
+	 * If child is NULL, the parent must be NULL or negative.
+	 * Otherwise child must be hashed, have parent as the d_parent, and
+	 * have the same name as dentry
+	 *
+	 */
+	struct qstr *qstr;
+	int rv;
+
+	if (child == NULL)
+		return (parent == NULL || parent->d_inode == NULL);
+
+	if (child->d_parent != parent)
+		return 0;
+	if (d_unhashed(child))
+		return 0;
+
+	/* Unfortunately we need d_lock to compare names */
+	spin_lock(&dentry->d_lock);
+	spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+	qstr = &child->d_name;
+	if (parent->d_op && parent->d_op->d_compare)
+		rv = ! (parent->d_op->d_compare(parent, qstr, &dentry->d_name));
+	else
+		rv =  (qstr->len == dentry->d_name.len &&
+		       memcmp(qstr->name, dentry->d_name.name, qstr->len) == 0);
+
+	spin_unlock(&child->d_lock);
+	spin_unlock(&dentry->d_lock);
+	return rv;
+}
+
+static int ovl_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	/* We need to invalidate this dentry if the either upperpath or lowerpath
+	 * has been changed
+	 */
+	struct dentry *parent = dget_parent(dentry);
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue = parent->d_fsdata;
+	int rv;
+
+	rv = (ovl_still_valid(dentry, pue->upperpath.dentry, ue->upperpath.dentry) &&
+	      ovl_still_valid(dentry, pue->lowerpath.dentry, ue->lowerpath.dentry));
+	dput(parent);
+	return rv;
+}
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_iput = ovl_dentry_iput,
+	.d_revalidate = ovl_dentry_revalidate,
 };
 
 static struct inode *ovl_new_inode(struct super_block *sb, umode_t mode)


