Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2ATWf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:35:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33964 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2ATWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:35:47 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        Cong Wang <xiyou.wangcong@gmail.com>, Li Wang <liwang@nudt.edu.cn>
Subject: [PATCH 2/3] eCryptfs: Check inode changes in setattr
Date: Fri, 20 Jan 2012 16:35:06 -0600
Message-Id: <1327098907-28963-3-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most filesystems call inode_change_ok() very early in ->setattr(), but
eCryptfs didn't call it at all. It allowed the lower filesystem to make
the call in its ->setattr() function. Then, eCryptfs would copy the
appropriate inode attributes from the lower inode to the eCryptfs inode.

This patch changes that and actually calls inode_change_ok() on the
eCryptfs inode, fairly early in ecryptfs_setattr(). Ideally, the call
would happen earlier in ecryptfs_setattr(), but there is some possible
inode initialization that must happen first.

Since the call was already being made on the lower inode, the change in
functionality should be minimal, except for the case of a file extending
truncate call. In that case, inode_newsize_ok() was never being
called on the eCryptfs inode. Rather than inode_newsize_ok() catching
errors early on, eCryptfs would encrypt zeroed pages and write them to
the lower filesystem until the lower filesystem's write path caught the
error in generic_write_checks().

In summary this change prevents eCryptfs truncate operations (and the
resulting page encryptions), which would exceed the lower filesystem
limits or FSIZE rlimits, from ever starting.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: <stable@vger.kernel.org>
---
 fs/ecryptfs/inode.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 19a8ca4..e025697 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -822,18 +822,6 @@ static int truncate_upper(struct dentry *dentry, struct iattr *ia,
 		size_t num_zeros = (PAGE_CACHE_SIZE
 				    - (ia->ia_size & ~PAGE_CACHE_MASK));
 
-
-		/*
-		 * XXX(truncate) this should really happen at the begginning
-		 * of ->setattr.  But the code is too messy to that as part
-		 * of a larger patch.  ecryptfs is also totally missing out
-		 * on the inode_change_ok check at the beginning of
-		 * ->setattr while would include this.
-		 */
-		rc = inode_newsize_ok(inode, ia->ia_size);
-		if (rc)
-			goto out;
-
 		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
 			truncate_setsize(inode, ia->ia_size);
 			lower_ia->ia_size = ia->ia_size;
@@ -899,6 +887,10 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 	struct iattr lower_ia = { .ia_valid = 0 };
 	int rc;
 
+	rc = inode_newsize_ok(dentry->d_inode, new_length);
+	if (rc)
+		return rc;
+
 	rc = truncate_upper(dentry, &ia, &lower_ia);
 	if (!rc && lower_ia.ia_valid & ATTR_SIZE) {
 		struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
@@ -978,6 +970,11 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
+
+	rc = inode_change_ok(inode, ia);
+	if (rc)
+		goto out;
+
 	if (S_ISREG(inode->i_mode)) {
 		rc = filemap_write_and_wait(inode->i_mapping);
 		if (rc)
-- 
1.7.8.3

