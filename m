Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab0FJHU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:20:58 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:39766 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758171Ab0FJHUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:20:47 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: [PATCH 5/5] fsfreeze: move emergency thaw code to fs/super.c
Date: Thu, 10 Jun 2010 17:19:54 +1000
Message-Id: <1276154395-24766-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276154395-24766-1-git-send-email-david@fromorbit.com>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It makes no sense having the emergency thaw code in fs/buffer.c when all of
it's operations are one superblocks and the code it executes is all in
fs/super.c. Move the code there and clean it up.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/buffer.c        |   31 -------------------------------
 fs/super.c         |   37 +++++++++++++++++++++++++++++++++----
 include/linux/fs.h |    1 -
 3 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b095fc1..61bd994 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -561,37 +561,6 @@ repeat:
 	return err;
 }
 
-static void do_thaw_one(struct super_block *sb, void *unused)
-{
-	char b[BDEVNAME_SIZE];
-	while (sb->s_bdev && !thaw_super_emergency(sb))
-		printk(KERN_WARNING "Emergency Thaw on %s\n",
-		       bdevname(sb->s_bdev, b));
-}
-
-static void do_thaw_all(struct work_struct *work)
-{
-	iterate_supers(do_thaw_one, NULL);
-	kfree(work);
-	printk(KERN_WARNING "Emergency Thaw complete\n");
-}
-
-/**
- * emergency_thaw_all -- forcibly thaw every frozen filesystem
- *
- * Used for emergency unfreeze of all filesystems via SysRq
- */
-void emergency_thaw_all(void)
-{
-	struct work_struct *work;
-
-	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work) {
-		INIT_WORK(work, do_thaw_all);
-		schedule_work(work);
-	}
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
diff --git a/fs/super.c b/fs/super.c
index 81a4034..680b8d5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1059,7 +1059,7 @@ out_unlock:
 }
 
 /**
- * thaw_super -- unlock filesystem
+ * __thaw_super -- unlock filesystem
  * @sb: the super to thaw
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
@@ -1075,11 +1075,40 @@ EXPORT_SYMBOL(thaw_super);
  * @sb: the super to thaw
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
- * This avoids taking the s_umount lock if it is already held.
+ * This avoids taking the s_umount lock because it is already held.
+ */
+static void thaw_super_emergency(struct super_block *sb, void *unused)
+{
+
+	if (sb->s_bdev) {
+		char b[BDEVNAME_SIZE];
+		printk(KERN_WARNING "Emergency Thaw on %s.\n",
+						bdevname(sb->s_bdev, b));
+	}
+	while (!__thaw_super(sb, 1));
+}
+
+static void do_thaw_all(struct work_struct *work)
+{
+	iterate_supers(thaw_super_emergency, NULL);
+	kfree(work);
+	printk(KERN_WARNING "Emergency Thaw complete\n");
+}
+
+/**
+ * emergency_thaw_all -- forcibly thaw every frozen filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
  */
-int thaw_super_emergency(struct super_block *sb)
+void emergency_thaw_all(void)
 {
-	return __thaw_super(sb, 1);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_thaw_all);
+		schedule_work(work);
+	}
 }
 
 static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39bf4ac..a704062 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1801,7 +1801,6 @@ extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
-extern int thaw_super_emergency(struct super_block *super);
 
 extern int current_umask(void);
 
-- 
1.7.1

