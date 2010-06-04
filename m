Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0FDH2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:28:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0FDH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:28:33 -0400
Message-Id: <20100604072618.227745945@suse.de>
User-Agent: quilt/0.48-4.4
Date: Fri, 04 Jun 2010 16:43:08 +1000
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 1/4] fs: cleanup files_lock
References: <20100604064307.737085373@suse.de>
Content-Disposition: inline; filename=fs-files_list-improve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lock tty_files with a new spinlock, tty_files_lock; provide helpers to
manipulate the per-sb files list; unexport the files_lock spinlock.

Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Frank Mayhar <fmayhar@google.com>,
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>,
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 drivers/char/pty.c       |    6 +++++-
 drivers/char/tty_io.c    |   26 ++++++++++++++++++--------
 fs/file_table.c          |   42 ++++++++++++++++++------------------------
 fs/open.c                |    4 ++--
 include/linux/fs.h       |    7 ++-----
 include/linux/tty.h      |    1 +
 security/selinux/hooks.c |    4 ++--
 7 files changed, 48 insertions(+), 42 deletions(-)

Index: linux-2.6/drivers/char/pty.c
===================================================================
--- linux-2.6.orig/drivers/char/pty.c
+++ linux-2.6/drivers/char/pty.c
@@ -650,7 +650,11 @@ static int __ptmx_open(struct inode *ino
 
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
--- linux-2.6.orig/drivers/char/tty_io.c
+++ linux-2.6/drivers/char/tty_io.c
@@ -136,6 +136,9 @@ LIST_HEAD(tty_drivers);			/* linked list
 DEFINE_MUTEX(tty_mutex);
 EXPORT_SYMBOL(tty_mutex);
 
+/* Spinlock to protect the tty->tty_files list */
+DEFINE_SPINLOCK(tty_files_lock);
+
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
 ssize_t redirected_tty_write(struct file *, const char __user *,
@@ -234,11 +237,11 @@ static int check_tty_count(struct tty_st
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
@@ -517,7 +520,7 @@ static void do_tty_hangup(struct work_st
 	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
 
-	file_list_lock();
+	spin_lock(&tty_files_lock);
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
 		if (filp->f_op->write == redirected_tty_write)
@@ -528,7 +531,7 @@ static void do_tty_hangup(struct work_st
 		tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
-	file_list_unlock();
+	spin_unlock(&tty_files_lock);
 
 	tty_ldisc_hangup(tty);
 
@@ -1419,9 +1422,9 @@ static void release_one_tty(struct work_
 	tty_driver_kref_put(driver);
 	module_put(driver->owner);
 
-	file_list_lock();
+	spin_lock(&tty_files_lock);
 	list_del_init(&tty->tty_files);
-	file_list_unlock();
+	spin_unlock(&tty_files_lock);
 
 	put_pid(tty->pgrp);
 	put_pid(tty->session);
@@ -1666,7 +1669,10 @@ int tty_release(struct inode *inode, str
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
@@ -1835,7 +1841,11 @@ got_driver:
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
--- linux-2.6.orig/fs/file_table.c
+++ linux-2.6/fs/file_table.c
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
@@ -319,31 +318,29 @@ struct file *fget_light(unsigned int fd,
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
 
@@ -352,7 +349,7 @@ int fs_may_remount_ro(struct super_block
 	struct file *file;
 
 	/* Check that no files are currently opened for writing. */
-	file_list_lock();
+	spin_lock(&files_lock);
 	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
@@ -364,10 +361,10 @@ int fs_may_remount_ro(struct super_block
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
 
@@ -383,7 +380,7 @@ void mark_files_ro(struct super_block *s
 	struct file *f;
 
 retry:
-	file_list_lock();
+	spin_lock(&files_lock);
 	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
@@ -399,16 +396,13 @@ retry:
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
--- linux-2.6.orig/fs/open.c
+++ linux-2.6/fs/open.c
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
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -949,9 +949,6 @@ struct file {
 	unsigned long f_mnt_write_state;
 #endif
 };
-extern spinlock_t files_lock;
-#define file_list_lock() spin_lock(&files_lock);
-#define file_list_unlock() spin_unlock(&files_lock);
 
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
@@ -2182,8 +2179,8 @@ static inline void insert_inode_hash(str
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
-extern void file_move(struct file *f, struct list_head *list);
-extern void file_kill(struct file *f);
+extern void file_sb_list_add(struct file *f, struct super_block *sb);
+extern void file_sb_list_del(struct file *f);
 #ifdef CONFIG_BLOCK
 struct bio;
 extern void submit_bio(int, struct bio *);
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2219,7 +2219,7 @@ static inline void flush_unauthorized_fi
 
 	tty = get_current_tty();
 	if (tty) {
-		file_list_lock();
+		spin_lock(&tty_files_lock);
 		if (!list_empty(&tty->tty_files)) {
 			struct inode *inode;
 
@@ -2235,7 +2235,7 @@ static inline void flush_unauthorized_fi
 				drop_tty = 1;
 			}
 		}
-		file_list_unlock();
+		spin_unlock(&tty_files_lock);
 		tty_kref_put(tty);
 	}
 	/* Reset controlling tty. */
Index: linux-2.6/include/linux/tty.h
===================================================================
--- linux-2.6.orig/include/linux/tty.h
+++ linux-2.6/include/linux/tty.h
@@ -467,6 +467,7 @@ extern struct tty_struct *tty_pair_get_t
 extern struct tty_struct *tty_pair_get_pty(struct tty_struct *tty);
 
 extern struct mutex tty_mutex;
+extern spinlock_t tty_files_lock;
 
 extern void tty_write_unlock(struct tty_struct *tty);
 extern int tty_write_lock(struct tty_struct *tty, int ndelay);


