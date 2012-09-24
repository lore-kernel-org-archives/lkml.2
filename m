Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2IXRpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:45:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2IXRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:45:41 -0400
Message-ID: <50609C43.1070702@canonical.com>
Date: Mon, 24 Sep 2012 19:45:39 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

My thread about the regression seemed to have been ignored, so I can only
conclude nobody objects against a full revert of this patch.

My testcase is simply booting through netboot with / and ~/nfs as separate
nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a gnome-terminal
window, then I get:

ls: cannot access nfs: Device or resource busy

Similar things seem to happen with ls /, /dev /proc and /sys will no longer work.

Reverting this patch seems to make things work again.

---

diff --git a/fs/dcache.c b/fs/dcache.c
index 16521a9..711f421 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2387,13 +2387,14 @@ static struct dentry *__d_unalias(struct inode *inode,
 		struct dentry *dentry, struct dentry *alias)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
-	struct dentry *ret = ERR_PTR(-EBUSY);
+	struct dentry *ret;
 
 	/* If alias and dentry share a parent, then no extra locks required */
 	if (alias->d_parent == dentry->d_parent)
 		goto out_unalias;
 
 	/* See lock_rename() */
+	ret = ERR_PTR(-EBUSY);
 	if (!mutex_trylock(&dentry->d_sb->s_vfs_rename_mutex))
 		goto out_err;
 	m1 = &dentry->d_sb->s_vfs_rename_mutex;
@@ -2401,10 +2402,8 @@ static struct dentry *__d_unalias(struct inode *inode,
 		goto out_err;
 	m2 = &alias->d_parent->d_inode->i_mutex;
 out_unalias:
-	if (likely(!d_mountpoint(alias))) {
-		__d_move(alias, dentry);
-		ret = alias;
-	}
+	__d_move(alias, dentry);
+	ret = alias;
 out_err:
 	spin_unlock(&inode->i_lock);
 	if (m2)

