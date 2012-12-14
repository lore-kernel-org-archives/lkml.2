Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2LNCXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:23:30 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33757 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab2LNCX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:23:28 -0500
X-Sasl-enc: DCe+QF8VjyT/vbV+4mjoxGSmRWWDNV6sCWuktnSsBVAF 1355451806
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/2] autofs4 - dont clear DCACHE_NEED_AUTOMOUNT on rootless
 mount
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 14 Dec 2012 10:23:23 +0800
Message-ID: <20121214022323.2969.31644.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DCACHE_NEED_AUTOMOUNT flag is cleared on mount and set on expire
for autofs rootless multi-mount dentrys to prevent unnecessary calls
to ->d_automount().

Since DCACHE_MANAGE_TRANSIT is always set on autofs dentrys ->d_managed()
is always called so the check can be done in ->d_manage() without the
need to change the flag. This still avoids unnecessary calls to
->d_automount(), adds negligible overhead and eliminates a seriously
ugly check in the expire code.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |    9 --------
 fs/autofs4/root.c   |   61 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 842d000..01443ce 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -548,15 +548,6 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		spin_lock(&dentry->d_lock);
-		if (!ret) {
-			if ((IS_ROOT(dentry) ||
-			    (autofs_type_indirect(sbi->type) &&
-			     IS_ROOT(dentry->d_parent))) &&
-			    !(dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
-				__managed_dentry_set_automount(dentry);
-		}
-		spin_unlock(&dentry->d_lock);
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 91b1165..30a6ab66 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -355,7 +355,6 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 		status = autofs4_mount_wait(dentry);
 		if (status)
 			return ERR_PTR(status);
-		spin_lock(&sbi->fs_lock);
 		goto done;
 	}
 
@@ -364,8 +363,11 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	 * having d_mountpoint() true, so there's no need to call back
 	 * to the daemon.
 	 */
-	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode))
+	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+		spin_unlock(&sbi->fs_lock);
 		goto done;
+	}
+
 	if (!d_mountpoint(dentry)) {
 		/*
 		 * It's possible that user space hasn't removed directories
@@ -379,8 +381,10 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 		 * require user space behave.
 		 */
 		if (sbi->version > 4) {
-			if (have_submounts(dentry))
+			if (have_submounts(dentry)) {
+				spin_unlock(&sbi->fs_lock);
 				goto done;
+			}
 		} else {
 			spin_lock(&dentry->d_lock);
 			if (!list_empty(&dentry->d_subdirs)) {
@@ -399,28 +403,8 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 			return ERR_PTR(status);
 		}
 	}
-done:
-	if (!(ino->flags & AUTOFS_INF_EXPIRING)) {
-		/*
-		 * Any needed mounting has been completed and the path
-		 * updated so clear DCACHE_NEED_AUTOMOUNT so we don't
-		 * call ->d_automount() on rootless multi-mounts since
-		 * it can lead to an incorrect ELOOP error return.
-		 *
-		 * Only clear DMANAGED_AUTOMOUNT for rootless multi-mounts and
-		 * symlinks as in all other cases the dentry will be covered by
-		 * an actual mount so ->d_automount() won't be called during
-		 * the follow.
-		 */
-		spin_lock(&dentry->d_lock);
-		if ((!d_mountpoint(dentry) &&
-		    !list_empty(&dentry->d_subdirs)) ||
-		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
-			__managed_dentry_clear_automount(dentry);
-		spin_unlock(&dentry->d_lock);
-	}
 	spin_unlock(&sbi->fs_lock);
-
+done:
 	/* Mount succeeded, check if we ended up with a new dentry */
 	dentry = autofs4_mountpoint_changed(path);
 	if (!dentry)
@@ -432,6 +416,8 @@ done:
 int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	int status;
 
 	DPRINTK("dentry=%p %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
@@ -456,7 +442,32 @@ int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 	 * This dentry may be under construction so wait on mount
 	 * completion.
 	 */
-	return autofs4_mount_wait(dentry);
+	status = autofs4_mount_wait(dentry);
+	if (status)
+		return status;
+
+	spin_lock(&sbi->fs_lock);
+	/*
+	 * If the dentry has been selected for expire while we slept
+	 * on the lock then it might go away. We'll deal with that in
+	 * ->d_automount() and wait on a new mount if the expire
+	 * succeeds or return here if it doesn't (since there's no
+	 * mount to follow with a rootless multi-mount).
+	 */
+	if (!(ino->flags & AUTOFS_INF_EXPIRING)) {
+		/*
+		 * Any needed mounting has been completed and the path
+		 * updated so check if this is a rootless multi-mount so
+		 * we can avoid needless calls ->d_automount() and avoid
+		 * an incorrect ELOOP error return.
+		 */
+		if ((!d_mountpoint(dentry) && !simple_empty(dentry)) ||
+		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
+			status = -EISDIR;
+	}
+	spin_unlock(&sbi->fs_lock);
+
+	return status;
 }
 
 /* Lookups in the root directory */

