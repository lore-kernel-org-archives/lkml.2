Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0FDSji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:39:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53487 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0FDSjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:39:36 -0400
Date: Fri, 4 Jun 2010 14:39:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH, RFC] tty: stop abusing file->f_u.fu_list
Message-ID: <20100604183934.GA2309@infradead.org>
References: <20100604064307.737085373@suse.de> <20100604072618.227745945@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604072618.227745945@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ttry code currently abuses the file anchor for the per-sb file list
to track instances of a given tty.  But there's no good reason for
that, we can just install a proxy object in file->private that gets
added to the list and points to the tty and keep the list away from
VFS internals.

Note that I've just if 0'd the selinux mess poking into it.  While we
could trivially port it to the new code by making the tty_private
structure public this code is just too revolting to be kept around.
It would never have been there anyway if a person with some amount of
clue had ever reviewed the selinux code.  And no, it's not just the
tty portion, the rest of that function is just as bad.

Index: linux-2.6/drivers/char/pty.c
===================================================================
--- linux-2.6.orig/drivers/char/pty.c	2010-06-04 17:36:40.370024374 +0200
+++ linux-2.6/drivers/char/pty.c	2010-06-04 20:10:11.115254505 +0200
@@ -649,8 +649,10 @@ static int __ptmx_open(struct inode *ino
 	}
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
-	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
+
+	retval = tty_add_file(tty, filp);
+	if (retval)
+		goto out;
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2010-06-04 17:22:38.056253946 +0200
+++ linux-2.6/drivers/char/tty_io.c	2010-06-04 20:11:36.872254644 +0200
@@ -112,6 +112,12 @@
 #define TTY_PARANOIA_CHECK 1
 #define CHECK_TTY_COUNT 1
 
+struct tty_private {
+	struct tty_struct *tty;
+	struct file *file;
+	struct list_head list;
+};
+
 struct ktermios tty_std_termios = {	/* for the benefit of tty drivers  */
 	.c_iflag = ICRNL | IXON,
 	.c_oflag = OPOST | ONLCR,
@@ -184,6 +190,26 @@ void free_tty_struct(struct tty_struct *
 	kfree(tty);
 }
 
+int tty_add_file(struct tty_struct *tty, struct file *file)
+{
+	struct tty_private *priv;
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->tty = tty;
+	priv->file = file;
+
+	spin_lock(&tty->tty_files_lock);
+	list_add(&priv->list, &tty->tty_files);
+	spin_unlock(&tty->tty_files_lock);
+
+	file->private_data = priv;
+	return 0;
+}
+
+
 #define TTY_NUMBER(tty) ((tty)->index + (tty)->driver->name_base)
 
 /**
@@ -234,11 +260,11 @@ static int check_tty_count(struct tty_st
 	struct list_head *p;
 	int count = 0;
 
-	file_list_lock();
+	spin_lock(&tty->tty_files_lock);
 	list_for_each(p, &tty->tty_files) {
 		count++;
 	}
-	file_list_unlock();
+	spin_unlock(&tty->tty_files_lock);
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_SLAVE &&
 	    tty->link && tty->link->count)
@@ -495,6 +521,7 @@ static void do_tty_hangup(struct work_st
 {
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
+	struct tty_private *priv;
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
 	struct task_struct *p;
@@ -507,9 +534,12 @@ static void do_tty_hangup(struct work_st
 
 
 	spin_lock(&redirect_lock);
-	if (redirect && redirect->private_data == tty) {
-		f = redirect;
-		redirect = NULL;
+	if (redirect) {
+		struct tty_private *priv = redirect->private_data;
+		if (priv->tty == tty) {
+			f = redirect;
+			redirect = NULL;
+		}
 	}
 	spin_unlock(&redirect_lock);
 
@@ -517,9 +547,11 @@ static void do_tty_hangup(struct work_st
 	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
 
-	file_list_lock();
+	spin_lock(&tty->tty_files_lock);
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
-	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
+	list_for_each_entry(priv, &tty->tty_files, list) {
+		filp = priv->file;
+
 		if (filp->f_op->write == redirected_tty_write)
 			cons_filp = filp;
 		if (filp->f_op->write != tty_write)
@@ -528,7 +560,7 @@ static void do_tty_hangup(struct work_st
 		tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
-	file_list_unlock();
+	spin_unlock(&tty->tty_files_lock);
 
 	tty_ldisc_hangup(tty);
 
@@ -874,13 +906,12 @@ EXPORT_SYMBOL(start_tty);
 static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
-	int i;
-	struct tty_struct *tty;
-	struct inode *inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct tty_private *priv = file->private_data;
+	struct tty_struct *tty = priv->tty;
 	struct tty_ldisc *ld;
+	int i;
 
-	tty = (struct tty_struct *)file->private_data;
-	inode = file->f_path.dentry->d_inode;
 	if (tty_paranoia_check(tty, inode, "tty_read"))
 		return -EIO;
 	if (!tty || (test_bit(TTY_IO_ERROR, &tty->flags)))
@@ -1051,12 +1082,12 @@ void tty_write_message(struct tty_struct
 static ssize_t tty_write(struct file *file, const char __user *buf,
 						size_t count, loff_t *ppos)
 {
-	struct tty_struct *tty;
 	struct inode *inode = file->f_path.dentry->d_inode;
-	ssize_t ret;
+	struct tty_private *priv = file->private_data;
+	struct tty_struct *tty = priv->tty;
 	struct tty_ldisc *ld;
+	ssize_t ret;
 
-	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_write"))
 		return -EIO;
 	if (!tty || !tty->ops->write ||
@@ -1419,9 +1450,9 @@ static void release_one_tty(struct work_
 	tty_driver_kref_put(driver);
 	module_put(driver->owner);
 
-	file_list_lock();
+	spin_lock(&tty->tty_files_lock);
 	list_del_init(&tty->tty_files);
-	file_list_unlock();
+	spin_unlock(&tty->tty_files_lock);
 
 	put_pid(tty->pgrp);
 	put_pid(tty->session);
@@ -1502,13 +1533,14 @@ static void release_tty(struct tty_struc
 
 int tty_release(struct inode *inode, struct file *filp)
 {
-	struct tty_struct *tty, *o_tty;
+	struct tty_private *priv = filp->private_data;
+	struct tty_struct *tty = priv->tty;
+	struct tty_struct *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	devpts;
 	int	idx;
 	char	buf[64];
 
-	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
 
@@ -1666,7 +1698,10 @@ int tty_release(struct inode *inode, str
 	 *  - do_tty_hangup no longer sees this file descriptor as
 	 *    something that needs to be handled for hangups.
 	 */
-	file_kill(filp);
+	spin_lock(&tty->tty_files_lock);
+	list_del(&priv->list);
+	spin_unlock(&tty->tty_files_lock);
+	kfree(priv);
 	filp->private_data = NULL;
 
 	/*
@@ -1834,8 +1869,12 @@ got_driver:
 		return PTR_ERR(tty);
 	}
 
-	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
+	retval = tty_add_file(tty, filp);
+	if (retval) {
+		unlock_kernel();
+		return retval;
+	}
+
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -1911,11 +1950,11 @@ got_driver:
 
 static unsigned int tty_poll(struct file *filp, poll_table *wait)
 {
-	struct tty_struct *tty;
+	struct tty_private *priv = filp->private_data;
+	struct tty_struct *tty = priv->tty;
 	struct tty_ldisc *ld;
 	int ret = 0;
 
-	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_poll"))
 		return 0;
 
@@ -1928,12 +1967,12 @@ static unsigned int tty_poll(struct file
 
 static int tty_fasync(int fd, struct file *filp, int on)
 {
-	struct tty_struct *tty;
+	struct tty_private *priv = filp->private_data;
+	struct tty_struct *tty = priv->tty;
 	unsigned long flags;
 	int retval = 0;
 
 	lock_kernel();
-	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		goto out;
 
@@ -2479,13 +2518,14 @@ EXPORT_SYMBOL(tty_pair_get_pty);
  */
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct tty_struct *tty, *real_tty;
+	struct tty_private *priv = file->private_data;
+	struct tty_struct *tty = priv->tty;
+	struct tty_struct *real_tty;
 	void __user *p = (void __user *)arg;
 	int retval;
 	struct tty_ldisc *ld;
 	struct inode *inode = file->f_dentry->d_inode;
 
-	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
@@ -2607,7 +2647,8 @@ static long tty_compat_ioctl(struct file
 				unsigned long arg)
 {
 	struct inode *inode = file->f_dentry->d_inode;
-	struct tty_struct *tty = file->private_data;
+	struct tty_private *priv = file->private_data;
+	struct tty_struct *tty = priv->tty;
 	struct tty_ldisc *ld;
 	int retval = -ENOIOCTLCMD;
 
@@ -2658,6 +2699,7 @@ void __do_SAK(struct tty_struct *tty)
 	int		i;
 	struct file	*filp;
 	struct fdtable *fdt;
+	struct tty_private *priv;
 
 	if (!tty)
 		return;
@@ -2698,8 +2740,9 @@ void __do_SAK(struct tty_struct *tty)
 				filp = fcheck_files(p->files, i);
 				if (!filp)
 					continue;
+				priv = filp->private_data;
 				if (filp->f_op->read == tty_read &&
-				    filp->private_data == tty) {
+				    priv->tty == tty) {
 					printk(KERN_NOTICE "SAK: killed process %d"
 					    " (%s): fd#%d opened to the tty\n",
 					    task_pid_nr(p), p->comm, i);
@@ -2771,6 +2814,7 @@ void initialize_tty_struct(struct tty_st
 	spin_lock_init(&tty->read_lock);
 	spin_lock_init(&tty->ctrl_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
+	spin_lock_init(&tty->tty_files_lock);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 
 	tty->driver = driver;
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2010-06-04 19:55:53.440253458 +0200
+++ linux-2.6/security/selinux/hooks.c	2010-06-04 19:56:39.370253946 +0200
@@ -2212,11 +2212,13 @@ static inline void flush_unauthorized_fi
 {
 	struct common_audit_data ad;
 	struct file *file, *devnull = NULL;
-	struct tty_struct *tty;
 	struct fdtable *fdt;
 	long j = -1;
 	int drop_tty = 0;
 
+#ifdef SANITIY /* selinux on crack */
+	struct tty_struct *tty;
+
 	tty = get_current_tty();
 	if (tty) {
 		file_list_lock();
@@ -2238,6 +2240,7 @@ static inline void flush_unauthorized_fi
 		file_list_unlock();
 		tty_kref_put(tty);
 	}
+#endif
 	/* Reset controlling tty. */
 	if (drop_tty)
 		no_tty();
Index: linux-2.6/include/linux/tty.h
===================================================================
--- linux-2.6.orig/include/linux/tty.h	2010-06-04 20:04:37.892254224 +0200
+++ linux-2.6/include/linux/tty.h	2010-06-04 20:08:42.715254434 +0200
@@ -288,6 +288,7 @@ struct tty_struct {
 	void *disc_data;
 	void *driver_data;
 	struct list_head tty_files;
+	spinlock_t tty_files_lock;
 
 #define N_TTY_BUF_SIZE 4096
 
@@ -455,6 +456,7 @@ extern void proc_clear_tty(struct task_s
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
+extern int tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2010-06-04 20:02:52.120024444 +0200
+++ linux-2.6/fs/file_table.c	2010-06-04 20:16:43.857005797 +0200
@@ -32,8 +32,9 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-/* public. Not pretty! */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+#define file_list_lock() spin_lock(&files_lock);
+#define file_list_unlock() spin_unlock(&files_lock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-06-04 20:16:14.958274130 +0200
+++ linux-2.6/include/linux/fs.h	2010-06-04 20:19:37.075254924 +0200
@@ -949,9 +949,6 @@ struct file {
 	unsigned long f_mnt_write_state;
 #endif
 };
-extern spinlock_t files_lock;
-#define file_list_lock() spin_lock(&files_lock);
-#define file_list_unlock() spin_unlock(&files_lock);
 
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
@@ -2182,8 +2179,6 @@ static inline void insert_inode_hash(str
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
-extern void file_move(struct file *f, struct list_head *list);
-extern void file_kill(struct file *f);
 #ifdef CONFIG_BLOCK
 struct bio;
 extern void submit_bio(int, struct bio *);
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-06-04 20:19:32.144254643 +0200
+++ linux-2.6/fs/internal.h	2010-06-04 20:19:49.453254853 +0200
@@ -80,6 +80,8 @@ extern void chroot_fs_refs(struct path *
 /*
  * file_table.c
  */
+extern void file_move(struct file *f, struct list_head *list);
+extern void file_kill(struct file *f);
 extern void mark_files_ro(struct super_block *);
 extern struct file *get_empty_filp(void);
 
