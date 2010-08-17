Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab0HQSwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:52:00 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56298 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759262Ab0HQStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:49:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0GAE51akx5Ld90/2dsb2JhbACUI4wbcsEqhTcEiWc
Message-Id: <20100817184121.363425312@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 18 Aug 2010 04:37:35 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/10] fs: cleanup files_lock locking
References: <20100817183729.613117146@kernel.dk>
Content-Disposition: inline; filename=fs-files_list-improve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs: cleanup files_lock locking

Lock tty_files with a new spinlock, tty_files_lock; provide helpers to
manipulate the per-sb files list; unexport the files_lock spinlock.

Cc: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 drivers/char/pty.c       |    6 +++++-
 drivers/char/tty_io.c    |   26 ++++++++++++++++++--------
 fs/file_table.c          |   42 ++++++++++++++++++------------------------
 fs/open.c                |    4 ++--
 include/linux/fs.h       |    7 ++-----
 include/linux/tty.h      |    1 +
 security/selinux/hooks.c |    4 ++--
 7 files changed, 48 insertions(+), 42 deletions(-)

Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/security/selinux/hooks.c	2010-08-18 04:05:10.000000000 +1000
@@ -2170,7 +2170,7 @@ static inline void flush_unauthorized_fi
 
 	tty = get_current_tty();
 	if (tty) {
-		file_list_lock();
+		spin_lock(&tty_files_lock);
 		if (!list_empty(&tty->tty_files)) {
 			struct inode *inode;
 
@@ -2186,7 +2186,7 @@ static inline void flush_unauthorized_fi
 				drop_tty = 1;
 			}
 		}
-		file_list_unlock();
+		spin_unlock(&tty_files_lock);
 		tty_kref_put(tty);
 	}
 	/* Reset controlling tty. */
Index: linux-2.6/drivers/char/pty.c
===================================================================
--- linux-2.6.orig/drivers/char/pty.c	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/drivers/char/pty.c	2010-08-18 04:05:10.000000000 +1000
@@ -676,7 +676,11 @@ static int ptmx_open(struct inode *inode
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
+
+	file_sb_list_del(filp); /* __dentry_open has put it on the sb list */
+	spin_lock(&tty_files_lock);
+	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	spin_unlock(&tty_files_lock);
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/drivers/char/tty_io.c	2010-08-18 04:05:10.000000000 +1000
@@ -136,6 +136,9 @@ LIST_HEAD(tty_drivers);			/* linked list
 DEFINE_MUTEX(tty_mutex);
 EXPORT_SYMBOL(tty_mutex);
 
+/* Spinlock to protect the tty->tty_files list */
+DEFINE_SPINLOCK(tty_files_lock);
+
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
 ssize_t redirected_tty_write(struct file *, const char __user *,
@@ -235,11 +238,11 @@ static int check_tty_count(struct tty_st
 	struct list_head *p;
 	int count = 0;
 
-	file_list_lock();
+	spin_lock(&tty_files_lock);
 	list_for_each(p, &tty->tty_files) {
 		count++;
 	}
-	file_list_unlock();
+	spin_unlock(&tty_files_lock);
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_SLAVE &&
 	    tty->link && tty->link->count)
@@ -519,7 +522,7 @@ void __tty_hangup(struct tty_struct *tty
 	   workqueue with the lock held */
 	check_tty_count(tty, "tty_hangup");
 
-	file_list_lock();
+	spin_lock(&tty_files_lock);
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
 		if (filp->f_op->write == redirected_tty_write)
@@ -530,7 +533,7 @@ void __tty_hangup(struct tty_struct *tty
 		__tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
-	file_list_unlock();
+	spin_unlock(&tty_files_lock);
 
 	tty_ldisc_hangup(tty);
 
@@ -1424,9 +1427,9 @@ static void release_one_tty(struct work_
 	tty_driver_kref_put(driver);
 	module_put(driver->owner);
 
-	file_list_lock();
+	spin_lock(&tty_files_lock);
 	list_del_init(&tty->tty_files);
-	file_list_unlock();
+	spin_unlock(&tty_files_lock);
 
 	put_pid(tty->pgrp);
 	put_pid(tty->session);
@@ -1671,7 +1674,10 @@ int tty_release(struct inode *inode, str
 	 *  - do_tty_hangup no longer sees this file descriptor as
 	 *    something that needs to be handled for hangups.
 	 */
-	file_kill(filp);
+	spin_lock(&tty_files_lock);
+	BUG_ON(list_empty(&filp->f_u.fu_list));
+	list_del_init(&filp->f_u.fu_list);
+	spin_unlock(&tty_files_lock);
 	filp->private_data = NULL;
 
 	/*
@@ -1840,7 +1846,11 @@ got_driver:
 	}
 
 	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
+	BUG_ON(list_empty(&filp->f_u.fu_list));
+	file_sb_list_del(filp); /* __dentry_open has put it on the sb list */
+	spin_lock(&tty_files_lock);
+	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	spin_unlock(&tty_files_lock);
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/fs/file_table.c	2010-08-18 04:05:09.000000000 +1000
@@ -32,8 +32,7 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-/* public. Not pretty! */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
@@ -249,7 +248,7 @@ static void __fput(struct file *file)
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
-	file_kill(file);
+	file_sb_list_del(file);
 	if (file->f_mode & FMODE_WRITE)
 		drop_file_write_access(file);
 	file->f_path.dentry = NULL;
@@ -328,31 +327,29 @@ struct file *fget_light(unsigned int fd,
 	return file;
 }
 
-
 void put_filp(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		security_file_free(file);
-		file_kill(file);
+		file_sb_list_del(file);
 		file_free(file);
 	}
 }
 
-void file_move(struct file *file, struct list_head *list)
+void file_sb_list_add(struct file *file, struct super_block *sb)
 {
-	if (!list)
-		return;
-	file_list_lock();
-	list_move(&file->f_u.fu_list, list);
-	file_list_unlock();
+	spin_lock(&files_lock);
+	BUG_ON(!list_empty(&file->f_u.fu_list));
+	list_add(&file->f_u.fu_list, &sb->s_files);
+	spin_unlock(&files_lock);
 }
 
-void file_kill(struct file *file)
+void file_sb_list_del(struct file *file)
 {
 	if (!list_empty(&file->f_u.fu_list)) {
-		file_list_lock();
+		spin_lock(&files_lock);
 		list_del_init(&file->f_u.fu_list);
-		file_list_unlock();
+		spin_unlock(&files_lock);
 	}
 }
 
@@ -361,7 +358,7 @@ int fs_may_remount_ro(struct super_block
 	struct file *file;
 
 	/* Check that no files are currently opened for writing. */
-	file_list_lock();
+	spin_lock(&files_lock);
 	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
@@ -373,10 +370,10 @@ int fs_may_remount_ro(struct super_block
 		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
 			goto too_bad;
 	}
-	file_list_unlock();
+	spin_unlock(&files_lock);
 	return 1; /* Tis' cool bro. */
 too_bad:
-	file_list_unlock();
+	spin_unlock(&files_lock);
 	return 0;
 }
 
@@ -392,7 +389,7 @@ void mark_files_ro(struct super_block *s
 	struct file *f;
 
 retry:
-	file_list_lock();
+	spin_lock(&files_lock);
 	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
@@ -408,16 +405,13 @@ retry:
 			continue;
 		file_release_write(f);
 		mnt = mntget(f->f_path.mnt);
-		file_list_unlock();
-		/*
-		 * This can sleep, so we can't hold
-		 * the file_list_lock() spinlock.
-		 */
+		/* This can sleep, so we can't hold the spinlock. */
+		spin_unlock(&files_lock);
 		mnt_drop_write(mnt);
 		mntput(mnt);
 		goto retry;
 	}
-	file_list_unlock();
+	spin_unlock(&files_lock);
 }
 
 void __init files_init(unsigned long mempages)
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/fs/open.c	2010-08-18 04:04:29.000000000 +1000
@@ -675,7 +675,7 @@ static struct file *__dentry_open(struct
 	f->f_path.mnt = mnt;
 	f->f_pos = 0;
 	f->f_op = fops_get(inode->i_fop);
-	file_move(f, &inode->i_sb->s_files);
+	file_sb_list_add(f, inode->i_sb);
 
 	error = security_dentry_open(f, cred);
 	if (error)
@@ -721,7 +721,7 @@ cleanup_all:
 			mnt_drop_write(mnt);
 		}
 	}
-	file_kill(f);
+	file_sb_list_del(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
 cleanup_file:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/include/linux/fs.h	2010-08-18 04:05:10.000000000 +1000
@@ -953,9 +953,6 @@ struct file {
 	unsigned long f_mnt_write_state;
 #endif
 };
-extern spinlock_t files_lock;
-#define file_list_lock() spin_lock(&files_lock);
-#define file_list_unlock() spin_unlock(&files_lock);
 
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
@@ -2197,8 +2194,8 @@ static inline void insert_inode_hash(str
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
-extern void file_move(struct file *f, struct list_head *list);
-extern void file_kill(struct file *f);
+extern void file_sb_list_add(struct file *f, struct super_block *sb);
+extern void file_sb_list_del(struct file *f);
 #ifdef CONFIG_BLOCK
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
Index: linux-2.6/include/linux/tty.h
===================================================================
--- linux-2.6.orig/include/linux/tty.h	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/include/linux/tty.h	2010-08-18 04:05:10.000000000 +1000
@@ -470,6 +470,7 @@ extern struct tty_struct *tty_pair_get_t
 extern struct tty_struct *tty_pair_get_pty(struct tty_struct *tty);
 
 extern struct mutex tty_mutex;
+extern spinlock_t tty_files_lock;
 
 extern void tty_write_unlock(struct tty_struct *tty);
 extern int tty_write_lock(struct tty_struct *tty, int ndelay);


