Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2KPEPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:15:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2KPEP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:15:28 -0500
From: Ian Kent <ikent@redhat.com>
Subject: [PATCH] autofs4 - use simple_empty() for empty directory check
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Fri, 16 Nov 2012 12:15:23 +0800
Message-ID: <20121116041523.18624.46918.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <raven@themaw.net>

For direct (and offset) mounts, if an automounted mount is manually
umounted the trigger mount dentry can appear non-empty causing it to
not trigger mounts. This can also happen if there is a file handle
leak in a user space automounting application.

It happens because, when the ioctl control file handle is opened
on the mount, a cursor dentry is created which causes list_empty()
to see the dentry as non-empty. Since there is a case where listing
the directory of these dentrys is needed, the use of dcache_dir_*()
functions for .open() and .release() is needed.

Consequently simple_empty() must be used instead of list_empty()
when checking for an empty directory.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h |   18 ++++++++++++++++++
 fs/autofs4/root.c     |   16 ++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 908e184..4c3f589 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -301,6 +301,24 @@ static inline int simple_positive(struct dentry *dentry)
 	return dentry->d_inode && !d_unhashed(dentry);
 }
 
+static inline int __simple_empty(struct dentry *dentry)
+{
+	struct dentry *child;
+	int ret = 0;
+
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+		if (simple_positive(child)) {
+			spin_unlock(&child->d_lock);
+			goto out;
+		}
+		spin_unlock(&child->d_lock);
+	}
+	ret = 1;
+out:
+	return ret;
+}
+
 static inline void __autofs4_add_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 91b1165..f39bf4b 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -124,13 +124,10 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&dentry->d_lock);
-	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+	if (!d_mountpoint(dentry) && simple_empty(dentry)) {
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
 	}
-	spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 out:
@@ -382,12 +379,8 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 			if (have_submounts(dentry))
 				goto done;
 		} else {
-			spin_lock(&dentry->d_lock);
-			if (!list_empty(&dentry->d_subdirs)) {
-				spin_unlock(&dentry->d_lock);
+			if (!simple_empty(dentry))
 				goto done;
-			}
-			spin_unlock(&dentry->d_lock);
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
@@ -413,8 +406,7 @@ done:
 		 * the follow.
 		 */
 		spin_lock(&dentry->d_lock);
-		if ((!d_mountpoint(dentry) &&
-		    !list_empty(&dentry->d_subdirs)) ||
+		if ((!d_mountpoint(dentry) && !__simple_empty(dentry)) ||
 		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
 			__managed_dentry_clear_automount(dentry);
 		spin_unlock(&dentry->d_lock);
@@ -673,7 +665,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	spin_lock(&sbi->lookup_lock);
 	spin_lock(&dentry->d_lock);
-	if (!list_empty(&dentry->d_subdirs)) {
+	if (!__simple_empty(dentry)) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOTEMPTY;

