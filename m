Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2HPKGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:06:50 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33599 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2HPKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:06:20 -0400
Message-ID: <502CC499.4030109@gmail.com>
Date: Thu, 16 Aug 2012 11:59:53 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/8] vfs: remove lock and unlock functions for super block
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Remove lock_super and unlock_super from VFS.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-3.6-rc1-orig/fs/super.c linux-3.6-rc1/fs/super.c
--- linux-3.6-rc1-orig/fs/super.c	2012-08-16 09:37:35.000000000 +0200
+++ linux-3.6-rc1/fs/super.c	2012-08-16 09:43:46.000000000 +0200
@@ -186,15 +186,8 @@ static struct super_block *alloc_super(s
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
@@ -400,22 +393,6 @@ bool grab_super_passive(struct super_blo
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

diff -Nurp linux-3.6-rc1-orig/include/linux/fs.h linux-3.6-rc1/include/linux/fs.h
--- linux-3.6-rc1-orig/include/linux/fs.h	2012-08-16 11:38:42.000000000 +0200
+++ linux-3.6-rc1/include/linux/fs.h	2012-08-16 09:45:18.000000000 +0200
@@ -1504,7 +1504,6 @@ struct super_block {
 	unsigned long		s_magic;
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
-	struct mutex		s_lock;
 	int			s_count;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY
