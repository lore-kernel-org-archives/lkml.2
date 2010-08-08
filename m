Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0HHPyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:54:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab0HHPyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:54:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 03/39] VFS: Add read-only users count to superblock
Date: Sun,  8 Aug 2010 11:52:20 -0400
Message-Id: <1281282776-5447-4-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we can check if a file system is currently read-only, we can't
guarantee that it will stay read-only.  The file system can be
remounted read-write at any time; it's also conceivable that a file
system can be mounted a second time and converted to read-write if the
underlying fs allows it.  This is a problem for union mounts, which
require the underlying file system be read-only.  Add a read-only
users count and don't allow remounts to change the file system to
read-write or read-write mounts if there are any read-only users.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c     |   13 +++++++++++++
 fs/super.c         |   23 +++++++++++++++++++++++
 include/linux/fs.h |    8 ++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index b8a66db..984c331 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -200,6 +200,19 @@ int __mnt_is_readonly(struct vfsmount *mnt)
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
+static void inc_hard_readonly_users(struct vfsmount *mnt)
+{
+	BUG_ON(!__mnt_is_readonly(mnt));
+	mnt->mnt_sb->s_hard_readonly_users++;
+}
+
+static void dec_hard_readonly_users(struct vfsmount *mnt)
+{
+	BUG_ON(!__mnt_is_readonly(mnt));
+	BUG_ON(mnt->mnt_sb->s_hard_readonly_users == 0);
+	mnt->mnt_sb->s_hard_readonly_users--;
+}
+
 static inline void inc_mnt_writers(struct vfsmount *mnt)
 {
 #ifdef CONFIG_SMP
diff --git a/fs/super.c b/fs/super.c
index 938119a..86bdf1f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -108,6 +108,7 @@ out:
  */
 static inline void destroy_super(struct super_block *s)
 {
+	BUG_ON(s->s_hard_readonly_users);
 	security_sb_free(s);
 	kfree(s->s_subtype);
 	kfree(s->s_options);
@@ -512,6 +513,21 @@ rescan:
 	return NULL;
 }
 
+/*
+ * Some uses of file systems require that they never be mounted
+ * read-write anywhere (e.g., the lower layers of union mounts must
+ * always be read-only).  If there are any of these "hard" read-only
+ * mounts, don't permit a transition to read-write.
+ *
+ * Must be called while holding the namespace lock.
+ */
+
+int sb_is_hard_readonly(struct super_block *sb)
+{
+	return sb->s_hard_readonly_users ? 1 : 0;
+}
+EXPORT_SYMBOL(sb_is_hard_readonly);
+
 /**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
@@ -550,6 +566,9 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			return -EBUSY;
 	}
 
+	if (!(flags & MS_RDONLY) && sb_is_hard_readonly(sb))
+		return -EROFS;
+
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		if (retval)
@@ -924,6 +943,10 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	WARN((mnt->mnt_sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
 		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
 
+	error = -EROFS;
+	if (!(flags & MS_RDONLY) && sb_is_hard_readonly(mnt->mnt_sb))
+		goto out_sb;
+
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..eeb49d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1382,6 +1382,13 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * Some mounts require that the underlying file system never
+	 * transition to read-write.  They mark the sb itself as
+	 * read-only.
+	 */
+	int s_hard_readonly_users;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
@@ -1768,6 +1775,7 @@ extern int get_sb_nodev(struct file_system_type *fs_type,
 	int (*fill_super)(struct super_block *, void *, int),
 	struct vfsmount *mnt);
 void generic_shutdown_super(struct super_block *sb);
+int sb_is_hard_readonly(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
 void kill_anon_super(struct super_block *sb);
 void kill_litter_super(struct super_block *sb);
-- 
1.6.3.3

