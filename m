Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2H3PHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:07:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41756 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2H3PHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:07:43 -0400
Message-ID: <503F8031.5030202@gmail.com>
Date: Thu, 30 Aug 2012 17:01:05 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] vfs: drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed s_lock from super_block and removed lock/unlock super.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/super.c         |   23 -----------------------
 include/linux/fs.h |    1 -
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 0902cfa..f25a44a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -186,15 +186,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		spin_lock_init(&s->s_inode_lru_lock);
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
-		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
-		 * The locking rules for s_lock are up to the
-		 * filesystem. For example ext3fs has different
-		 * lock ordering than usbfs:
-		 */
-		lockdep_set_class(&s->s_lock, &type->s_lock_key);
-		/*
 		 * sget() can have s_umount recursion.
 		 *
 		 * When it cannot find a suitable sb, it allocates a new
@@ -400,22 +393,6 @@ bool grab_super_passive(struct super_block *sb)
 	return false;
 }
 
-/*
- * Superblock locking.  We really ought to get rid of these two.
- */
-void lock_super(struct super_block * sb)
-{
-	mutex_lock(&sb->s_lock);
-}
-
-void unlock_super(struct super_block * sb)
-{
-	mutex_unlock(&sb->s_lock);
-}
-
-EXPORT_SYMBOL(lock_super);
-EXPORT_SYMBOL(unlock_super);
-
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
  *	@sb: superblock to kill
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..a3650ae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1503,7 +1503,6 @@ struct super_block {
 	unsigned long		s_magic;
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
-	struct mutex		s_lock;
 	int			s_count;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY
-- 
1.7.3.4
