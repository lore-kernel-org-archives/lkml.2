Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0KLNbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:31:03 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21871 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0KLNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:30:51 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 12 Nov 2010 14:29:28 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 1/2] usb: gadget: FunctionFS: fix typos and coding style
In-reply-to: <20101111135957.GA21388@kroah.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <6516fbf233ddd5a134dc2852ce3128dda3c81ef7.1289566508.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.2.3
References: <20101111135957.GA21388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit changes FunctionFS as to make it more compliant
with coding style as well as fixes several typos.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c  |  325 ++++++++++++++++++++++----------------------
 drivers/usb/gadget/g_ffs.c |   39 +++---
 2 files changed, 186 insertions(+), 178 deletions(-)

On Thu, 11 Nov 2010 14:59:57 +0100, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 28, 2010 at 05:31:24PM +0200, Michal Nazarewicz wrote:
> This patch no longer applies.  Care to rediff it and resend it against
> the next linux-next tree?

Sure thing.  Also adding one patch more since we're at it. :P


diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 4a830df..2880e52 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1,10 +1,10 @@
 /*
- * f_fs.c -- user mode filesystem api for usb composite funtcion controllers
+ * f_fs.c -- user mode file system API for USB composite function controllers
  *
  * Copyright (C) 2010 Samsung Electronics
  * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
  *
- * Based on inode.c (GadgetFS):
+ * Based on inode.c (GadgetFS) which was:
  * Copyright (C) 2003-2004 David Brownell
  * Copyright (C) 2003 Agilent Technologies
  *
@@ -39,7 +39,7 @@
 #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
 
 
-/* Debuging *****************************************************************/
+/* Debugging ****************************************************************/
 
 #define ffs_printk(level, fmt, args...) printk(level "f_fs: " fmt "\n", ## args)
 
@@ -71,30 +71,39 @@
 /* The data structure and setup file ****************************************/
 
 enum ffs_state {
-	/* Waiting for descriptors and strings. */
-	/* In this state no open(2), read(2) or write(2) on epfiles
+	/*
+	 * Waiting for descriptors and strings.
+	 *
+	 * In this state no open(2), read(2) or write(2) on epfiles
 	 * may succeed (which should not be the problem as there
-	 * should be no such files opened in the firts place). */
+	 * should be no such files opened in the first place).
+	 */
 	FFS_READ_DESCRIPTORS,
 	FFS_READ_STRINGS,
 
-	/* We've got descriptors and strings.  We are or have called
+	/*
+	 * We've got descriptors and strings.  We are or have called
 	 * functionfs_ready_callback().  functionfs_bind() may have
-	 * been called but we don't know. */
-	/* This is the only state in which operations on epfiles may
-	 * succeed. */
+	 * been called but we don't know.
+	 *
+	 * This is the only state in which operations on epfiles may
+	 * succeed.
+	 */
 	FFS_ACTIVE,
 
-	/* All endpoints have been closed.  This state is also set if
+	/*
+	 * All endpoints have been closed.  This state is also set if
 	 * we encounter an unrecoverable error.  The only
 	 * unrecoverable error is situation when after reading strings
-	 * from user space we fail to initialise EP files or
-	 * functionfs_ready_callback() returns with error (<0). */
-	/* In this state no open(2), read(2) or write(2) (both on ep0
+	 * from user space we fail to initialise epfiles or
+	 * functionfs_ready_callback() returns with error (<0).
+	 *
+	 * In this state no open(2), read(2) or write(2) (both on ep0
 	 * as well as epfile) may succeed (at this point epfiles are
 	 * unlinked and all closed so this is not a problem; ep0 is
 	 * also closed but ep0 file exists and so open(2) on ep0 must
-	 * fail). */
+	 * fail).
+	 */
 	FFS_CLOSING
 };
 
@@ -102,14 +111,18 @@ enum ffs_state {
 enum ffs_setup_state {
 	/* There is no setup request pending. */
 	FFS_NO_SETUP,
-	/* User has read events and there was a setup request event
+	/*
+	 * User has read events and there was a setup request event
 	 * there.  The next read/write on ep0 will handle the
-	 * request. */
+	 * request.
+	 */
 	FFS_SETUP_PENDING,
-	/* There was event pending but before user space handled it
+	/*
+	 * There was event pending but before user space handled it
 	 * some other event was introduced which canceled existing
 	 * setup.  If this state is set read/write on ep0 return
-	 * -EIDRM.  This state is only set when adding event. */
+	 * -EIDRM.  This state is only set when adding event.
+	 */
 	FFS_SETUP_CANCELED
 };
 
@@ -121,23 +134,29 @@ struct ffs_function;
 struct ffs_data {
 	struct usb_gadget		*gadget;
 
-	/* Protect access read/write operations, only one read/write
+	/*
+	 * Protect access read/write operations, only one read/write
 	 * at a time.  As a consequence protects ep0req and company.
 	 * While setup request is being processed (queued) this is
-	 * held. */
+	 * held.
+	 */
 	struct mutex			mutex;
 
-	/* Protect access to enpoint related structures (basically
+	/*
+	 * Protect access to endpoint related structures (basically
 	 * usb_ep_queue(), usb_ep_dequeue(), etc. calls) except for
-	 * endpint zero. */
+	 * endpoint zero.
+	 */
 	spinlock_t			eps_lock;
 
-	/* XXX REVISIT do we need our own request? Since we are not
-	 * handling setup requests immidiatelly user space may be so
+	/*
+	 * XXX REVISIT do we need our own request? Since we are not
+	 * handling setup requests immediately user space may be so
 	 * slow that another setup will be sent to the gadget but this
 	 * time not to us but another function and then there could be
 	 * a race.  Is that the case? Or maybe we can use cdev->req
-	 * after all, maybe we just need some spinlock for that? */
+	 * after all, maybe we just need some spinlock for that?
+	 */
 	struct usb_request		*ep0req;		/* P: mutex */
 	struct completion		ep0req_completion;	/* P: mutex */
 	int				ep0req_status;		/* P: mutex */
@@ -151,7 +170,7 @@ struct ffs_data {
 	enum ffs_state			state;
 
 	/*
-	 * Possible transations:
+	 * Possible transitions:
 	 * + FFS_NO_SETUP       -> FFS_SETUP_PENDING  -- P: ev.waitq.lock
 	 *               happens only in ep0 read which is P: mutex
 	 * + FFS_SETUP_PENDING  -> FFS_NO_SETUP       -- P: ev.waitq.lock
@@ -184,18 +203,21 @@ struct ffs_data {
 	/* Active function */
 	struct ffs_function		*func;
 
-	/* Device name, write once when file system is mounted.
-	 * Intendet for user to read if she wants. */
+	/*
+	 * Device name, write once when file system is mounted.
+	 * Intended for user to read if she wants.
+	 */
 	const char			*dev_name;
-	/* Private data for our user (ie. gadget).  Managed by
-	 * user. */
+	/* Private data for our user (ie. gadget).  Managed by user. */
 	void				*private_data;
 
 	/* filled by __ffs_data_got_descs() */
-	/* real descriptors are 16 bytes after raw_descs (so you need
+	/*
+	 * Real descriptors are 16 bytes after raw_descs (so you need
 	 * to skip 16 bytes (ie. ffs->raw_descs + 16) to get to the
 	 * first full speed descriptor).  raw_descs_length and
-	 * raw_fs_descs_length do not have those 16 bytes added. */
+	 * raw_fs_descs_length do not have those 16 bytes added.
+	 */
 	const void			*raw_descs;
 	unsigned			raw_descs_length;
 	unsigned			raw_fs_descs_length;
@@ -212,18 +234,23 @@ struct ffs_data {
 	const void			*raw_strings;
 	struct usb_gadget_strings	**stringtabs;
 
-	/* File system's super block, write once when file system is mounted. */
+	/*
+	 * File system's super block, write once when file system is
+	 * mounted.
+	 */
 	struct super_block		*sb;
 
-	/* File permissions, written once when fs is mounted*/
+	/* File permissions, written once when fs is mounted */
 	struct ffs_file_perms {
 		umode_t				mode;
 		uid_t				uid;
 		gid_t				gid;
 	}				file_perms;
 
-	/* The endpoint files, filled by ffs_epfiles_create(),
-	 * destroyed by ffs_epfiles_destroy(). */
+	/*
+	 * The endpoint files, filled by ffs_epfiles_create(),
+	 * destroyed by ffs_epfiles_destroy().
+	 */
 	struct ffs_epfile		*epfiles;
 };
 
@@ -237,7 +264,7 @@ static struct ffs_data *__must_check ffs_data_new(void) __attribute__((malloc));
 static void ffs_data_opened(struct ffs_data *ffs);
 static void ffs_data_closed(struct ffs_data *ffs);
 
-/* Called with ffs->mutex held; take over ownerrship of data. */
+/* Called with ffs->mutex held; take over ownership of data. */
 static int __must_check
 __ffs_data_got_descs(struct ffs_data *ffs, char *data, size_t len);
 static int __must_check
@@ -268,11 +295,9 @@ static struct ffs_function *ffs_func_from_usb(struct usb_function *f)
 
 static void ffs_func_free(struct ffs_function *func);
 
-
 static void ffs_func_eps_disable(struct ffs_function *func);
 static int __must_check ffs_func_eps_enable(struct ffs_function *func);
 
-
 static int ffs_func_bind(struct usb_configuration *,
 			 struct usb_function *);
 static void ffs_func_unbind(struct usb_configuration *,
@@ -289,7 +314,6 @@ static int ffs_func_revmap_ep(struct ffs_function *func, u8 num);
 static int ffs_func_revmap_intf(struct ffs_function *func, u8 intf);
 
 
-
 /* The endpoints structures *************************************************/
 
 struct ffs_ep {
@@ -322,7 +346,6 @@ struct ffs_epfile {
 	unsigned char			_pad;
 };
 
-
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
 
@@ -349,7 +372,6 @@ static void ffs_ep0_complete(struct usb_ep *ep, struct usb_request *req)
 	complete_all(&ffs->ep0req_completion);
 }
 
-
 static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 {
 	struct usb_request *req = ffs->ep0req;
@@ -391,7 +413,6 @@ static int __ffs_ep0_stall(struct ffs_data *ffs)
 	}
 }
 
-
 static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 			     size_t len, loff_t *ptr)
 {
@@ -410,7 +431,6 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 	if (unlikely(ret < 0))
 		return ret;
 
-
 	/* Check state */
 	switch (ffs->state) {
 	case FFS_READ_DESCRIPTORS:
@@ -462,11 +482,12 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		}
 		break;
 
-
 	case FFS_ACTIVE:
 		data = NULL;
-		/* We're called from user space, we can use _irq
-		 * rather then _irqsave */
+		/*
+		 * We're called from user space, we can use _irq
+		 * rather then _irqsave
+		 */
 		spin_lock_irq(&ffs->ev.waitq.lock);
 		switch (FFS_SETUP_STATE(ffs)) {
 		case FFS_SETUP_CANCELED:
@@ -501,16 +522,18 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 
 		spin_lock_irq(&ffs->ev.waitq.lock);
 
-		/* We are guaranteed to be still in FFS_ACTIVE state
+		/*
+		 * We are guaranteed to be still in FFS_ACTIVE state
 		 * but the state of setup could have changed from
 		 * FFS_SETUP_PENDING to FFS_SETUP_CANCELED so we need
 		 * to check for that.  If that happened we copied data
-		 * from user space in vain but it's unlikely. */
-		/* For sure we are not in FFS_NO_SETUP since this is
+		 * from user space in vain but it's unlikely.
+		 *
+		 * For sure we are not in FFS_NO_SETUP since this is
 		 * the only place FFS_SETUP_PENDING -> FFS_NO_SETUP
 		 * transition can be performed and it's protected by
-		 * mutex. */
-
+		 * mutex.
+		 */
 		if (FFS_SETUP_STATE(ffs) == FFS_SETUP_CANCELED) {
 			ret = -EIDRM;
 done_spin:
@@ -522,25 +545,22 @@ done_spin:
 		kfree(data);
 		break;
 
-
 	default:
 		ret = -EBADFD;
 		break;
 	}
 
-
 	mutex_unlock(&ffs->mutex);
 	return ret;
 }
 
-
-
 static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 				     size_t n)
 {
-	/* We are holding ffs->ev.waitq.lock and ffs->mutex and we need
-	 * to release them. */
-
+	/*
+	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
+	 * to release them.
+	 */
 	struct usb_functionfs_event events[n];
 	unsigned i = 0;
 
@@ -569,7 +589,6 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 		? -EFAULT : sizeof events;
 }
 
-
 static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 			    size_t len, loff_t *ptr)
 {
@@ -589,16 +608,16 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 	if (unlikely(ret < 0))
 		return ret;
 
-
 	/* Check state */
 	if (ffs->state != FFS_ACTIVE) {
 		ret = -EBADFD;
 		goto done_mutex;
 	}
 
-
-	/* We're called from user space, we can use _irq rather then
-	 * _irqsave */
+	/*
+	 * We're called from user space, we can use _irq rather then
+	 * _irqsave
+	 */
 	spin_lock_irq(&ffs->ev.waitq.lock);
 
 	switch (FFS_SETUP_STATE(ffs)) {
@@ -618,7 +637,8 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 			break;
 		}
 
-		if (unlikely(wait_event_interruptible_exclusive_locked_irq(ffs->ev.waitq, ffs->ev.count))) {
+		if (wait_event_interruptible_exclusive_locked_irq(ffs->ev.waitq,
+							ffs->ev.count)) {
 			ret = -EINTR;
 			break;
 		}
@@ -626,7 +646,6 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 		return __ffs_ep0_read_events(ffs, buf,
 					     min(n, (size_t)ffs->ev.count));
 
-
 	case FFS_SETUP_PENDING:
 		if (ffs->ev.setup.bRequestType & USB_DIR_IN) {
 			spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -672,8 +691,6 @@ done_mutex:
 	return ret;
 }
 
-
-
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
 	struct ffs_data *ffs = inode->i_private;
@@ -689,7 +706,6 @@ static int ffs_ep0_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-
 static int ffs_ep0_release(struct inode *inode, struct file *file)
 {
 	struct ffs_data *ffs = file->private_data;
@@ -701,7 +717,6 @@ static int ffs_ep0_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-
 static long ffs_ep0_ioctl(struct file *file, unsigned code, unsigned long value)
 {
 	struct ffs_data *ffs = file->private_data;
@@ -722,7 +737,6 @@ static long ffs_ep0_ioctl(struct file *file, unsigned code, unsigned long value)
 	return ret;
 }
 
-
 static const struct file_operations ffs_ep0_operations = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
@@ -737,7 +751,6 @@ static const struct file_operations ffs_ep0_operations = {
 
 /* "Normal" endpoints operations ********************************************/
 
-
 static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
 {
 	ENTER();
@@ -748,7 +761,6 @@ static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
 	}
 }
 
-
 static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
@@ -778,8 +790,8 @@ first_try:
 				goto error;
 			}
 
-			if (unlikely(wait_event_interruptible
-				     (epfile->wait, (ep = epfile->ep)))) {
+			if (wait_event_interruptible(epfile->wait,
+						     (ep = epfile->ep))) {
 				ret = -EINTR;
 				goto error;
 			}
@@ -811,12 +823,16 @@ first_try:
 		if (unlikely(ret))
 			goto error;
 
-		/* We're called from user space, we can use _irq rather then
-		 * _irqsave */
+		/*
+		 * We're called from user space, we can use _irq rather then
+		 * _irqsave
+		 */
 		spin_lock_irq(&epfile->ffs->eps_lock);
 
-		/* While we were acquiring mutex endpoint got disabled
-		 * or changed? */
+		/*
+		 * While we were acquiring mutex endpoint got disabled
+		 * or changed?
+		 */
 	} while (unlikely(epfile->ep != ep));
 
 	/* Halt */
@@ -858,7 +874,6 @@ error:
 	return ret;
 }
 
-
 static ssize_t
 ffs_epfile_write(struct file *file, const char __user *buf, size_t len,
 		 loff_t *ptr)
@@ -904,7 +919,6 @@ ffs_epfile_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-
 static long ffs_epfile_ioctl(struct file *file, unsigned code,
 			     unsigned long value)
 {
@@ -943,7 +957,6 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	return ret;
 }
 
-
 static const struct file_operations ffs_epfile_operations = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
@@ -956,15 +969,13 @@ static const struct file_operations ffs_epfile_operations = {
 };
 
 
-
 /* File system and super block operations ***********************************/
 
 /*
- * Mounting the filesystem creates a controller file, used first for
+ * Mounting the file system creates a controller file, used first for
  * function configuration then later for event monitoring.
  */
 
-
 static struct inode *__must_check
 ffs_sb_make_inode(struct super_block *sb, void *data,
 		  const struct file_operations *fops,
@@ -997,9 +1008,7 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
 	return inode;
 }
 
-
 /* Create "regular" file */
-
 static struct inode *ffs_sb_create_file(struct super_block *sb,
 					const char *name, void *data,
 					const struct file_operations *fops,
@@ -1028,9 +1037,7 @@ static struct inode *ffs_sb_create_file(struct super_block *sb,
 	return inode;
 }
 
-
 /* Super block */
-
 static const struct super_operations ffs_sb_operations = {
 	.statfs =	simple_statfs,
 	.drop_inode =	generic_delete_inode,
@@ -1051,7 +1058,7 @@ static int ffs_sb_fill(struct super_block *sb, void *_data, int silent)
 
 	ENTER();
 
-	/* Initialize data */
+	/* Initialise data */
 	ffs = ffs_data_new();
 	if (unlikely(!ffs))
 		goto enomem0;
@@ -1097,7 +1104,6 @@ enomem0:
 	return -ENOMEM;
 }
 
-
 static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 {
 	ENTER();
@@ -1173,7 +1179,6 @@ invalid:
 	return 0;
 }
 
-
 /* "mount -t functionfs dev_name /dev/function" ends up here */
 
 static struct dentry *
@@ -1225,10 +1230,8 @@ static struct file_system_type ffs_fs_type = {
 };
 
 
-
 /* Driver's main init/cleanup functions *************************************/
 
-
 static int functionfs_init(void)
 {
 	int ret;
@@ -1253,13 +1256,11 @@ static void functionfs_cleanup(void)
 }
 
 
-
 /* ffs_data and ffs_function construction and destruction code **************/
 
 static void ffs_data_clear(struct ffs_data *ffs);
 static void ffs_data_reset(struct ffs_data *ffs);
 
-
 static void ffs_data_get(struct ffs_data *ffs)
 {
 	ENTER();
@@ -1290,8 +1291,6 @@ static void ffs_data_put(struct ffs_data *ffs)
 	}
 }
 
-
-
 static void ffs_data_closed(struct ffs_data *ffs)
 {
 	ENTER();
@@ -1304,7 +1303,6 @@ static void ffs_data_closed(struct ffs_data *ffs)
 	ffs_data_put(ffs);
 }
 
-
 static struct ffs_data *ffs_data_new(void)
 {
 	struct ffs_data *ffs = kzalloc(sizeof *ffs, GFP_KERNEL);
@@ -1327,7 +1325,6 @@ static struct ffs_data *ffs_data_new(void)
 	return ffs;
 }
 
-
 static void ffs_data_clear(struct ffs_data *ffs)
 {
 	ENTER();
@@ -1345,7 +1342,6 @@ static void ffs_data_clear(struct ffs_data *ffs)
 	kfree(ffs->stringtabs);
 }
 
-
 static void ffs_data_reset(struct ffs_data *ffs)
 {
 	ENTER();
@@ -1408,7 +1404,6 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 	return 0;
 }
 
-
 static void functionfs_unbind(struct ffs_data *ffs)
 {
 	ENTER();
@@ -1421,7 +1416,6 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	}
 }
 
-
 static int ffs_epfiles_create(struct ffs_data *ffs)
 {
 	struct ffs_epfile *epfile, *epfiles;
@@ -1452,7 +1446,6 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
-
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
@@ -1472,7 +1465,6 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	kfree(epfiles);
 }
 
-
 static int functionfs_bind_config(struct usb_composite_dev *cdev,
 				  struct usb_configuration *c,
 				  struct ffs_data *ffs)
@@ -1492,7 +1484,6 @@ static int functionfs_bind_config(struct usb_composite_dev *cdev,
 	func->function.bind    = ffs_func_bind;
 	func->function.unbind  = ffs_func_unbind;
 	func->function.set_alt = ffs_func_set_alt;
-	/*func->function.get_alt = ffs_func_get_alt;*/
 	func->function.disable = ffs_func_disable;
 	func->function.setup   = ffs_func_setup;
 	func->function.suspend = ffs_func_suspend;
@@ -1517,14 +1508,15 @@ static void ffs_func_free(struct ffs_function *func)
 	ffs_data_put(func->ffs);
 
 	kfree(func->eps);
-	/* eps and interfaces_nums are allocated in the same chunk so
+	/*
+	 * eps and interfaces_nums are allocated in the same chunk so
 	 * only one free is required.  Descriptors are also allocated
-	 * in the same chunk. */
+	 * in the same chunk.
+	 */
 
 	kfree(func);
 }
 
-
 static void ffs_func_eps_disable(struct ffs_function *func)
 {
 	struct ffs_ep *ep         = func->eps;
@@ -1582,11 +1574,12 @@ static int ffs_func_eps_enable(struct ffs_function *func)
 
 /* Parsing and building descriptors and strings *****************************/
 
-
-/* This validates if data pointed by data is a valid USB descriptor as
+/*
+ * This validates if data pointed by data is a valid USB descriptor as
  * well as record how many interfaces, endpoints and strings are
- * required by given configuration.  Returns address afther the
- * descriptor or NULL if data is invalid. */
+ * required by given configuration.  Returns address after the
+ * descriptor or NULL if data is invalid.
+ */
 
 enum ffs_entity_type {
 	FFS_DESCRIPTOR, FFS_INTERFACE, FFS_STRING, FFS_ENDPOINT
@@ -1643,7 +1636,8 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	case USB_DT_STRING:
 	case USB_DT_DEVICE_QUALIFIER:
 		/* function can't have any of those */
-		FVDBG("descriptor reserved for gadget: %d", _ds->bDescriptorType);
+		FVDBG("descriptor reserved for gadget: %d",
+		      _ds->bDescriptorType);
 		return -EINVAL;
 
 	case USB_DT_INTERFACE: {
@@ -1697,7 +1691,7 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 		FVDBG("unknown descriptor: %d", _ds->bDescriptorType);
 		return -EINVAL;
 
-	inv_length:
+inv_length:
 		FVDBG("invalid length: %d (descriptor %d)",
 		      _ds->bLength, _ds->bDescriptorType);
 		return -EINVAL;
@@ -1712,7 +1706,6 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	return length;
 }
 
-
 static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 				     ffs_entity_callback entity, void *priv)
 {
@@ -1727,7 +1720,7 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 		if (num == count)
 			data = NULL;
 
-		/* Record "descriptor" entitny */
+		/* Record "descriptor" entity */
 		ret = entity(FFS_DESCRIPTOR, (u8 *)num, (void *)data, priv);
 		if (unlikely(ret < 0)) {
 			FDBG("entity DESCRIPTOR(%02lx); ret = %d", num, ret);
@@ -1749,7 +1742,6 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 	}
 }
 
-
 static int __ffs_data_do_entity(enum ffs_entity_type type,
 				u8 *valuep, struct usb_descriptor_header *desc,
 				void *priv)
@@ -1763,16 +1755,20 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 		break;
 
 	case FFS_INTERFACE:
-		/* Interfaces are indexed from zero so if we
+		/*
+		 * Interfaces are indexed from zero so if we
 		 * encountered interface "n" then there are at least
-		 * "n+1" interfaces. */
+		 * "n+1" interfaces.
+		 */
 		if (*valuep >= ffs->interfaces_count)
 			ffs->interfaces_count = *valuep + 1;
 		break;
 
 	case FFS_STRING:
-		/* Strings are indexed from 1 (0 is magic ;) reserved
-		 * for languages list or some such) */
+		/*
+		 * Strings are indexed from 1 (0 is magic ;) reserved
+		 * for languages list or some such)
+		 */
 		if (*valuep > ffs->strings_count)
 			ffs->strings_count = *valuep;
 		break;
@@ -1787,7 +1783,6 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 	return 0;
 }
 
-
 static int __ffs_data_got_descs(struct ffs_data *ffs,
 				char *const _data, size_t len)
 {
@@ -1850,8 +1845,6 @@ error:
 	return ret;
 }
 
-
-
 static int __ffs_data_got_strings(struct ffs_data *ffs,
 				  char *const _data, size_t len)
 {
@@ -1877,17 +1870,17 @@ static int __ffs_data_got_strings(struct ffs_data *ffs,
 	if (unlikely(str_count < needed_count))
 		goto error;
 
-	/* If we don't need any strings just return and free all
-	 * memory */
+	/*
+	 * If we don't need any strings just return and free all
+	 * memory.
+	 */
 	if (!needed_count) {
 		kfree(_data);
 		return 0;
 	}
 
-	/* Allocate */
+	/* Allocate everything in one chunk so there's less maintenance. */
 	{
-		/* Allocate everything in one chunk so there's less
-		 * maintanance. */
 		struct {
 			struct usb_gadget_strings *stringtabs[lang_count + 1];
 			struct usb_gadget_strings stringtab[lang_count];
@@ -1938,13 +1931,17 @@ static int __ffs_data_got_strings(struct ffs_data *ffs,
 			if (unlikely(length == len))
 				goto error_free;
 
-			/* user may provide more strings then we need,
-			 * if that's the case we simply ingore the
-			 * rest */
+			/*
+			 * User may provide more strings then we need,
+			 * if that's the case we simply ignore the
+			 * rest
+			 */
 			if (likely(needed)) {
-				/* s->id will be set while adding
+				/*
+				 * s->id will be set while adding
 				 * function to configuration so for
-				 * now just leave garbage here. */
+				 * now just leave garbage here.
+				 */
 				s->s = data;
 				--needed;
 				++s;
@@ -1978,8 +1975,6 @@ error:
 }
 
 
-
-
 /* Events handling and management *******************************************/
 
 static void __ffs_event_add(struct ffs_data *ffs,
@@ -1988,29 +1983,32 @@ static void __ffs_event_add(struct ffs_data *ffs,
 	enum usb_functionfs_event_type rem_type1, rem_type2 = type;
 	int neg = 0;
 
-	/* Abort any unhandled setup */
-	/* We do not need to worry about some cmpxchg() changing value
+	/*
+	 * Abort any unhandled setup
+	 *
+	 * We do not need to worry about some cmpxchg() changing value
 	 * of ffs->setup_state without holding the lock because when
 	 * state is FFS_SETUP_PENDING cmpxchg() in several places in
-	 * the source does nothing. */
+	 * the source does nothing.
+	 */
 	if (ffs->setup_state == FFS_SETUP_PENDING)
 		ffs->setup_state = FFS_SETUP_CANCELED;
 
 	switch (type) {
 	case FUNCTIONFS_RESUME:
 		rem_type2 = FUNCTIONFS_SUSPEND;
-		/* FALL THGOUTH */
+		/* FALL THROUGH */
 	case FUNCTIONFS_SUSPEND:
 	case FUNCTIONFS_SETUP:
 		rem_type1 = type;
-		/* discard all similar events */
+		/* Discard all similar events */
 		break;
 
 	case FUNCTIONFS_BIND:
 	case FUNCTIONFS_UNBIND:
 	case FUNCTIONFS_DISABLE:
 	case FUNCTIONFS_ENABLE:
-		/* discard everything other then power management. */
+		/* Discard everything other then power management. */
 		rem_type1 = FUNCTIONFS_SUSPEND;
 		rem_type2 = FUNCTIONFS_RESUME;
 		neg = 1;
@@ -2056,8 +2054,10 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	struct ffs_function *func = priv;
 	struct ffs_ep *ffs_ep;
 
-	/* If hs_descriptors is not NULL then we are reading hs
-	 * descriptors now */
+	/*
+	 * If hs_descriptors is not NULL then we are reading hs
+	 * descriptors now
+	 */
 	const int isHS = func->function.hs_descriptors != NULL;
 	unsigned idx;
 
@@ -2112,7 +2112,6 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	return 0;
 }
 
-
 static int __ffs_func_bind_do_nums(enum ffs_entity_type type, u8 *valuep,
 				   struct usb_descriptor_header *desc,
 				   void *priv)
@@ -2144,8 +2143,10 @@ static int __ffs_func_bind_do_nums(enum ffs_entity_type type, u8 *valuep,
 		break;
 
 	case FFS_ENDPOINT:
-		/* USB_DT_ENDPOINT are handled in
-		 * __ffs_func_bind_do_descs(). */
+		/*
+		 * USB_DT_ENDPOINT are handled in
+		 * __ffs_func_bind_do_descs().
+		 */
 		if (desc->bDescriptorType == USB_DT_ENDPOINT)
 			return 0;
 
@@ -2212,9 +2213,11 @@ static int ffs_func_bind(struct usb_configuration *c,
 	func->eps             = data->eps;
 	func->interfaces_nums = data->inums;
 
-	/* Go throught all the endpoint descriptors and allocate
+	/*
+	 * Go through all the endpoint descriptors and allocate
 	 * endpoints first, so that later we can rewrite the endpoint
-	 * numbers without worying that it may be described later on. */
+	 * numbers without worrying that it may be described later on.
+	 */
 	if (likely(full)) {
 		func->function.descriptors = data->fs_descs;
 		ret = ffs_do_descs(ffs->fs_descs_count,
@@ -2235,9 +2238,11 @@ static int ffs_func_bind(struct usb_configuration *c,
 				   __ffs_func_bind_do_descs, func);
 	}
 
-	/* Now handle interface numbers allocation and interface and
-	 * enpoint numbers rewritting.  We can do that in one go
-	 * now. */
+	/*
+	 * Now handle interface numbers allocation and interface and
+	 * endpoint numbers rewriting.  We can do that in one go
+	 * now.
+	 */
 	ret = ffs_do_descs(ffs->fs_descs_count +
 			   (high ? ffs->hs_descs_count : 0),
 			   data->raw_descs, sizeof data->raw_descs,
@@ -2275,7 +2280,6 @@ static void ffs_func_unbind(struct usb_configuration *c,
 	ffs_func_free(func);
 }
 
-
 static int ffs_func_set_alt(struct usb_function *f,
 			    unsigned interface, unsigned alt)
 {
@@ -2329,14 +2333,15 @@ static int ffs_func_setup(struct usb_function *f,
 	FVDBG("creq->wIndex       = %04x", le16_to_cpu(creq->wIndex));
 	FVDBG("creq->wLength      = %04x", le16_to_cpu(creq->wLength));
 
-	/* Most requests directed to interface go throught here
+	/*
+	 * Most requests directed to interface go through here
 	 * (notable exceptions are set/get interface) so we need to
 	 * handle them.  All other either handled by composite or
 	 * passed to usb_configuration->setup() (if one is set).  No
 	 * matter, we will handle requests directed to endpoint here
 	 * as well (as it's straightforward) but what to do with any
-	 * other request? */
-
+	 * other request?
+	 */
 	if (ffs->state != FFS_ACTIVE)
 		return -ENODEV;
 
@@ -2379,8 +2384,7 @@ static void ffs_func_resume(struct usb_function *f)
 }
 
 
-
-/* Enpoint and interface numbers reverse mapping ****************************/
+/* Endpoint and interface numbers reverse mapping ***************************/
 
 static int ffs_func_revmap_ep(struct ffs_function *func, u8 num)
 {
@@ -2411,7 +2415,6 @@ static int ffs_mutex_lock(struct mutex *mutex, unsigned nonblock)
 		: mutex_lock_interruptible(mutex);
 }
 
-
 static char *ffs_prepare_buffer(const char * __user buf, size_t len)
 {
 	char *data;
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index af75e36..3dc1989 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -1,7 +1,27 @@
+/*
+ * g_ffs.c -- user mode file system API for USB composite function controllers
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
 #include <linux/module.h>
 #include <linux/utsname.h>
 
-
 /*
  * kbuild is not very cooperative with respect to linking separately
  * compiled library objects into one module.  So for now we won't use
@@ -43,7 +63,6 @@ static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN]);
 
 #include "f_fs.c"
 
-
 #define DRIVER_NAME	"g_ffs"
 #define DRIVER_DESC	"USB Function Filesystem"
 #define DRIVER_VERSION	"24 Aug 2004"
@@ -73,8 +92,6 @@ MODULE_PARM_DESC(bDeviceSubClass, "USB Device subclass");
 module_param_named(bDeviceProtocol, gfs_dev_desc.bDeviceProtocol, byte,   0644);
 MODULE_PARM_DESC(bDeviceProtocol, "USB Device protocol");
 
-
-
 static const struct usb_descriptor_header *gfs_otg_desc[] = {
 	(const struct usb_descriptor_header *)
 	&(const struct usb_otg_descriptor) {
@@ -91,8 +108,7 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 	NULL
 };
 
-/* string IDs are assigned dynamically */
-
+/* String IDs are assigned dynamically */
 static struct usb_string gfs_strings[] = {
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	{ .s = "FunctionFS + RNDIS" },
@@ -114,8 +130,6 @@ static struct usb_gadget_strings *gfs_dev_strings[] = {
 	NULL,
 };
 
-
-
 struct gfs_configuration {
 	struct usb_configuration c;
 	int (*eth)(struct usb_configuration *c, u8 *ethaddr);
@@ -138,7 +152,6 @@ struct gfs_configuration {
 #endif
 };
 
-
 static int gfs_bind(struct usb_composite_dev *cdev);
 static int gfs_unbind(struct usb_composite_dev *cdev);
 static int gfs_do_config(struct usb_configuration *c);
@@ -151,11 +164,9 @@ static struct usb_composite_driver gfs_driver = {
 	.iProduct	= DRIVER_DESC,
 };
 
-
 static struct ffs_data *gfs_ffs_data;
 static unsigned long gfs_registered;
 
-
 static int  gfs_init(void)
 {
 	ENTER();
@@ -175,7 +186,6 @@ static void  gfs_exit(void)
 }
 module_exit(gfs_exit);
 
-
 static int functionfs_ready_callback(struct ffs_data *ffs)
 {
 	int ret;
@@ -200,14 +210,11 @@ static void functionfs_closed_callback(struct ffs_data *ffs)
 		usb_composite_unregister(&gfs_driver);
 }
 
-
 static int functionfs_check_dev_callback(const char *dev_name)
 {
 	return 0;
 }
 
-
-
 static int gfs_bind(struct usb_composite_dev *cdev)
 {
 	int ret, i;
@@ -274,7 +281,6 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
 	return 0;
 }
 
-
 static int gfs_do_config(struct usb_configuration *c)
 {
 	struct gfs_configuration *gc =
@@ -315,7 +321,6 @@ static int gfs_do_config(struct usb_configuration *c)
 	return 0;
 }
 
-
 #ifdef CONFIG_USB_FUNCTIONFS_ETH
 
 static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
-- 
1.7.2.3

