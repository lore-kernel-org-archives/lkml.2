Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab1J3QiE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 12:38:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934217Ab1J3QiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 12:38:02 -0400
Date: Sun, 30 Oct 2011 09:40:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tty: make several fops functions non-static so that the
 pty code can use them
Message-ID: <20111030094038.7046d529@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 7e5c44c1d42a1e66ea5df069f3f8ee50a5c46168 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 29 Oct 2011 10:41:19 -0700
Subject: [PATCH 1/3] tty: make several fops functions non-static so that the pty code can use them

The pty code currently does a partial function-pointer copy to fill its
struct file_operations; this patch makes the functions it copies non-static
in preparation of switching the pty code over to using proper prototypes.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/tty/tty_io.c |   19 ++++---------------
 include/linux/tty.h  |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4f1fc81..1f79760 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -138,21 +138,10 @@ EXPORT_SYMBOL(tty_mutex);
 /* Spinlock to protect the tty->tty_files list */
 DEFINE_SPINLOCK(tty_files_lock);
 
-static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
-static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
 ssize_t redirected_tty_write(struct file *, const char __user *,
 							size_t, loff_t *);
-static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
-long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-#ifdef CONFIG_COMPAT
-static long tty_compat_ioctl(struct file *file, unsigned int cmd,
-				unsigned long arg);
-#else
-#define tty_compat_ioctl NULL
-#endif
 static int __tty_fasync(int fd, struct file *filp, int on);
-static int tty_fasync(int fd, struct file *filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
@@ -936,7 +925,7 @@ EXPORT_SYMBOL(start_tty);
  *	read calls may be outstanding in parallel.
  */
 
-static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
+ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
 	int i;
@@ -1113,7 +1102,7 @@ void tty_write_message(struct tty_struct *tty, char *msg)
  *	write method will not be invoked in parallel for each device.
  */
 
-static ssize_t tty_write(struct file *file, const char __user *buf,
+ssize_t tty_write(struct file *file, const char __user *buf,
 						size_t count, loff_t *ppos)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1968,7 +1957,7 @@ got_driver:
  *	may be re-entered freely by other callers.
  */
 
-static unsigned int tty_poll(struct file *filp, poll_table *wait)
+unsigned int tty_poll(struct file *filp, poll_table *wait)
 {
 	struct tty_struct *tty = file_tty(filp);
 	struct tty_ldisc *ld;
@@ -2025,7 +2014,7 @@ out:
 	return retval;
 }
 
-static int tty_fasync(int fd, struct file *filp, int on)
+int tty_fasync(int fd, struct file *filp, int on)
 {
 	int retval;
 	tty_lock();
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5f2ede8..f1ba6c1 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -43,6 +43,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>
 
 #include <asm/system.h>
 
@@ -481,6 +482,19 @@ extern void deinitialize_tty_struct(struct tty_struct *tty);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 								int first_ok);
 extern int tty_release(struct inode *inode, struct file *filp);
+extern ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
+extern ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
+extern unsigned int tty_poll(struct file *, poll_table *);
+
+#ifdef CONFIG_COMPAT
+extern long tty_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg);
+#else
+#define tty_compat_ioctl NULL
+#endif
+extern int tty_fasync(int fd, struct file *filp, int on);
+
+
 extern int tty_init_termios(struct tty_struct *tty);
 
 extern struct tty_struct *tty_pair_get_tty(struct tty_struct *tty);
-- 
1.7.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
