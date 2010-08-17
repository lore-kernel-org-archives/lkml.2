Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab0HQStd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:49:33 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56286 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab0HQStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:49:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0GAE51akx5Ld90/2dsb2JhbACUI4wbcsEqhTcEiWc
Message-Id: <20100817184121.610655219@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 18 Aug 2010 04:37:36 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/10] tty: fix fu_list abuse
References: <20100817183729.613117146@kernel.dk>
Content-Disposition: inline; filename=fs-tty-files_list-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty: fix fu_list abuse

tty code abuses fu_list, which causes a bug in remount,ro handling.

If a tty device node is opened on a filesystem, then the last link to the inode
removed, the filesystem will be allowed to be remounted readonly. This is
because fs_may_remount_ro does not find the 0 link tty inode on the file sb
list (because the tty code incorrectly removed it to use for its own purpose).
This can result in a filesystem with errors after it is marked "clean".

Taking idea from Christoph's initial patch, allocate a tty private struct
at file->private_data and put our required list fields in there, linking
file and tty. This makes tty nodes behave the same way as other device nodes
and avoid meddling with the vfs, and avoids this bug.

The error handling is not trivial in the tty code, so for this bugfix, I take
the simple approach of using __GFP_NOFAIL and don't worry about memory errors.
This is not a problem because our allocator doesn't fail small allocs as a rule
anyway. So proper error handling is left as an exercise for tty hackers.

[ Arguably filesystem's device inode would ideally be divorced from the
driver's pseudo inode when it is opened, but in practice it's not clear whether
that will ever be worth implementing. ]

Cc: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 drivers/char/pty.c       |    6 ---
 drivers/char/tty_io.c    |   84 ++++++++++++++++++++++++++++++-----------------
 fs/internal.h            |    2 +
 include/linux/fs.h       |    2 -
 include/linux/tty.h      |    8 ++++
 security/selinux/hooks.c |    5 ++
 6 files changed, 69 insertions(+), 38 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/include/linux/fs.h	2010-08-18 04:05:09.000000000 +1000
@@ -2194,8 +2194,6 @@ static inline void insert_inode_hash(str
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
-extern void file_sb_list_add(struct file *f, struct super_block *sb);
-extern void file_sb_list_del(struct file *f);
 #ifdef CONFIG_BLOCK
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
Index: linux-2.6/drivers/char/pty.c
===================================================================
--- linux-2.6.orig/drivers/char/pty.c	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/drivers/char/pty.c	2010-08-18 04:04:29.000000000 +1000
@@ -675,12 +675,8 @@ static int ptmx_open(struct inode *inode
 	}
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
-	filp->private_data = tty;
 
-	file_sb_list_del(filp); /* __dentry_open has put it on the sb list */
-	spin_lock(&tty_files_lock);
-	list_add(&filp->f_u.fu_list, &tty->tty_files);
-	spin_unlock(&tty_files_lock);
+	tty_add_file(tty, filp);
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/drivers/char/tty_io.c	2010-08-18 04:04:29.000000000 +1000
@@ -188,6 +188,41 @@ void free_tty_struct(struct tty_struct *
 	kfree(tty);
 }
 
+static inline struct tty_struct *file_tty(struct file *file)
+{
+	return ((struct tty_file_private *)file->private_data)->tty;
+}
+
+/* Associate a new file with the tty structure */
+void tty_add_file(struct tty_struct *tty, struct file *file)
+{
+	struct tty_file_private *priv;
+
+	/* XXX: must implement proper error handling in callers */
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL|__GFP_NOFAIL);
+
+	priv->tty = tty;
+	priv->file = file;
+	file->private_data = priv;
+
+	spin_lock(&tty_files_lock);
+	list_add(&priv->list, &tty->tty_files);
+	spin_unlock(&tty_files_lock);
+}
+
+/* Delete file from its tty */
+void tty_del_file(struct file *file)
+{
+	struct tty_file_private *priv = file->private_data;
+
+	spin_lock(&tty_files_lock);
+	list_del(&priv->list);
+	spin_unlock(&tty_files_lock);
+	file->private_data = NULL;
+	kfree(priv);
+}
+
+
 #define TTY_NUMBER(tty) ((tty)->index + (tty)->driver->name_base)
 
 /**
@@ -500,6 +535,7 @@ void __tty_hangup(struct tty_struct *tty
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
 	struct task_struct *p;
+	struct tty_file_private *priv;
 	int    closecount = 0, n;
 	unsigned long flags;
 	int refs = 0;
@@ -509,7 +545,7 @@ void __tty_hangup(struct tty_struct *tty
 
 
 	spin_lock(&redirect_lock);
-	if (redirect && redirect->private_data == tty) {
+	if (redirect && file_tty(redirect) == tty) {
 		f = redirect;
 		redirect = NULL;
 	}
@@ -524,7 +560,8 @@ void __tty_hangup(struct tty_struct *tty
 
 	spin_lock(&tty_files_lock);
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
-	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
+	list_for_each_entry(priv, &tty->tty_files, list) {
+		filp = priv->file;
 		if (filp->f_op->write == redirected_tty_write)
 			cons_filp = filp;
 		if (filp->f_op->write != tty_write)
@@ -892,12 +929,10 @@ static ssize_t tty_read(struct file *fil
 			loff_t *ppos)
 {
 	int i;
-	struct tty_struct *tty;
-	struct inode *inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct tty_struct *tty = file_tty(file);
 	struct tty_ldisc *ld;
 
-	tty = file->private_data;
-	inode = file->f_path.dentry->d_inode;
 	if (tty_paranoia_check(tty, inode, "tty_read"))
 		return -EIO;
 	if (!tty || (test_bit(TTY_IO_ERROR, &tty->flags)))
@@ -1068,12 +1103,11 @@ void tty_write_message(struct tty_struct
 static ssize_t tty_write(struct file *file, const char __user *buf,
 						size_t count, loff_t *ppos)
 {
-	struct tty_struct *tty;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct tty_struct *tty = file_tty(file);
+ 	struct tty_ldisc *ld;
 	ssize_t ret;
-	struct tty_ldisc *ld;
 
-	tty = file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_write"))
 		return -EIO;
 	if (!tty || !tty->ops->write ||
@@ -1510,13 +1544,13 @@ static void release_tty(struct tty_struc
 
 int tty_release(struct inode *inode, struct file *filp)
 {
-	struct tty_struct *tty, *o_tty;
+	struct tty_struct *tty = file_tty(filp);
+	struct tty_struct *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	devpts;
 	int	idx;
 	char	buf[64];
 
-	tty = filp->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
 
@@ -1674,11 +1708,7 @@ int tty_release(struct inode *inode, str
 	 *  - do_tty_hangup no longer sees this file descriptor as
 	 *    something that needs to be handled for hangups.
 	 */
-	spin_lock(&tty_files_lock);
-	BUG_ON(list_empty(&filp->f_u.fu_list));
-	list_del_init(&filp->f_u.fu_list);
-	spin_unlock(&tty_files_lock);
-	filp->private_data = NULL;
+	tty_del_file(filp);
 
 	/*
 	 * Perform some housekeeping before deciding whether to return.
@@ -1845,12 +1875,8 @@ got_driver:
 		return PTR_ERR(tty);
 	}
 
-	filp->private_data = tty;
-	BUG_ON(list_empty(&filp->f_u.fu_list));
-	file_sb_list_del(filp); /* __dentry_open has put it on the sb list */
-	spin_lock(&tty_files_lock);
-	list_add(&filp->f_u.fu_list, &tty->tty_files);
-	spin_unlock(&tty_files_lock);
+	tty_add_file(tty, filp);
+
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -1926,11 +1952,10 @@ got_driver:
 
 static unsigned int tty_poll(struct file *filp, poll_table *wait)
 {
-	struct tty_struct *tty;
+	struct tty_struct *tty = file_tty(filp);
 	struct tty_ldisc *ld;
 	int ret = 0;
 
-	tty = filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_poll"))
 		return 0;
 
@@ -1943,11 +1968,10 @@ static unsigned int tty_poll(struct file
 
 static int __tty_fasync(int fd, struct file *filp, int on)
 {
-	struct tty_struct *tty;
+	struct tty_struct *tty = file_tty(filp);
 	unsigned long flags;
 	int retval = 0;
 
-	tty = filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		goto out;
 
@@ -2501,13 +2525,13 @@ EXPORT_SYMBOL(tty_pair_get_pty);
  */
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct tty_struct *tty, *real_tty;
+	struct tty_struct *tty = file_tty(file);
+	struct tty_struct *real_tty;
 	void __user *p = (void __user *)arg;
 	int retval;
 	struct tty_ldisc *ld;
 	struct inode *inode = file->f_dentry->d_inode;
 
-	tty = file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
@@ -2629,7 +2653,7 @@ static long tty_compat_ioctl(struct file
 				unsigned long arg)
 {
 	struct inode *inode = file->f_dentry->d_inode;
-	struct tty_struct *tty = file->private_data;
+	struct tty_struct *tty = file_tty(file);
 	struct tty_ldisc *ld;
 	int retval = -ENOIOCTLCMD;
 
@@ -2721,7 +2745,7 @@ void __do_SAK(struct tty_struct *tty)
 				if (!filp)
 					continue;
 				if (filp->f_op->read == tty_read &&
-				    filp->private_data == tty) {
+				    file_tty(filp) == tty) {
 					printk(KERN_NOTICE "SAK: killed process %d"
 					    " (%s): fd#%d opened to the tty\n",
 					    task_pid_nr(p), p->comm, i);
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/security/selinux/hooks.c	2010-08-18 04:04:29.000000000 +1000
@@ -2172,6 +2172,7 @@ static inline void flush_unauthorized_fi
 	if (tty) {
 		spin_lock(&tty_files_lock);
 		if (!list_empty(&tty->tty_files)) {
+			struct tty_file_private *file_priv;
 			struct inode *inode;
 
 			/* Revalidate access to controlling tty.
@@ -2179,7 +2180,9 @@ static inline void flush_unauthorized_fi
 			   than using file_has_perm, as this particular open
 			   file may belong to another process and we are only
 			   interested in the inode-based check here. */
-			file = list_first_entry(&tty->tty_files, struct file, f_u.fu_list);
+			file_priv = list_first_entry(&tty->tty_files,
+						struct tty_file_private, list);
+			file = file_priv->file;
 			inode = file->f_path.dentry->d_inode;
 			if (inode_has_perm(cred, inode,
 					   FILE__READ | FILE__WRITE, NULL)) {
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-08-18 04:04:01.000000000 +1000
+++ linux-2.6/fs/internal.h	2010-08-18 04:05:07.000000000 +1000
@@ -80,6 +80,8 @@ extern void chroot_fs_refs(struct path *
 /*
  * file_table.c
  */
+extern void file_sb_list_add(struct file *f, struct super_block *sb);
+extern void file_sb_list_del(struct file *f);
 extern void mark_files_ro(struct super_block *);
 extern struct file *get_empty_filp(void);
 
Index: linux-2.6/include/linux/tty.h
===================================================================
--- linux-2.6.orig/include/linux/tty.h	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/include/linux/tty.h	2010-08-18 04:04:29.000000000 +1000
@@ -329,6 +329,13 @@ struct tty_struct {
 	struct tty_port *port;
 };
 
+/* Each of a tty's open files has private_data pointing to tty_file_private */
+struct tty_file_private {
+	struct tty_struct *tty;
+	struct file *file;
+	struct list_head list;
+};
+
 /* tty magic number */
 #define TTY_MAGIC		0x5401
 
@@ -458,6 +465,7 @@ extern void proc_clear_tty(struct task_s
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
+extern void tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);


