Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1BGSbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:31:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1BGSbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:31:42 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] tty,vcs removing con_buf/conf_buf_mtx
Date: Mon,  7 Feb 2011 19:31:25 +0100
Message-Id: <1297103485-8319-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
References: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

seems there's no longer need for using con_buf/conf_buf_mtx
as vcs_read/vcs_write buffer for user's data.

The do_con_write function, that was the other user of this,
is currently using its own kmalloc-ed buffer.

Not sure when this got changed, as I was able to find this code
in 2.6.9, but it's already gone as far as current git history
goes - 2.6.12-rc2.

AFAICS there's a behaviour change with the current change.
The lseek is not completely mutually exclusive with the
vcs_read/vcs_write - the file->f_pos might get updated
via lseek callback during the vcs_read/vcs_write processing.

I tried to find out if the prefered behaviour is to keep
this in sync within read/write/lseek functions, but I did
not find any pattern on different places.

I guess if user end up calling write/lseek from different
threads she should know what she's doing. If needed we
could use dedicated fd mutex/buffer.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/tty/vt/vc_screen.c |   98 +++++++++++++++++++++++--------------------
 drivers/tty/vt/vt.c        |   12 -----
 include/linux/vt_kern.h    |    8 ----
 3 files changed, 52 insertions(+), 66 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 3c27c4b..7b3bfbe 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -28,7 +28,6 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/mutex.h>
 #include <linux/vt_kern.h>
 #include <linux/selection.h>
 #include <linux/kbd_kern.h>
@@ -51,6 +50,8 @@
 #undef addr
 #define HEADER_SIZE	4
 
+#define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
+
 struct vcs_poll_data {
 	struct notifier_block notifier;
 	unsigned int cons_num;
@@ -131,21 +132,45 @@ vcs_poll_data_get(struct file *file)
 	return poll;
 }
 
+/*
+ * Returns VC for inode.
+ * Must be called with console_lock.
+ */
+static struct vc_data*
+vcs_vc(struct inode *inode, int *viewed)
+{
+	unsigned int currcons = iminor(inode) & 127;
+
+	WARN_CONSOLE_UNLOCKED();
+
+	if (currcons == 0) {
+		currcons = fg_console;
+		if (viewed)
+			*viewed = 1;
+	} else {
+		currcons--;
+		if (viewed)
+			*viewed = 0;
+	}
+	return vc_cons[currcons].d;
+}
+
+/*
+ * Returns size for VC carried by inode.
+ * Must be called with console_lock.
+ */
 static int
 vcs_size(struct inode *inode)
 {
 	int size;
 	int minor = iminor(inode);
-	int currcons = minor & 127;
 	struct vc_data *vc;
 
-	if (currcons == 0)
-		currcons = fg_console;
-	else
-		currcons--;
-	if (!vc_cons_allocated(currcons))
+	WARN_CONSOLE_UNLOCKED();
+
+	vc = vcs_vc(inode, NULL);
+	if (!vc)
 		return -ENXIO;
-	vc = vc_cons[currcons].d;
 
 	size = vc->vc_rows * vc->vc_cols;
 
@@ -158,17 +183,13 @@ static loff_t vcs_lseek(struct file *file, loff_t offset, int orig)
 {
 	int size;
 
-	mutex_lock(&con_buf_mtx);
 	console_lock();
 	size = vcs_size(file->f_path.dentry->d_inode);
 	console_unlock();
-	if (size < 0) {
-		mutex_unlock(&con_buf_mtx);
+	if (size < 0)
 		return size;
-	}
 	switch (orig) {
 		default:
-			mutex_unlock(&con_buf_mtx);
 			return -EINVAL;
 		case 2:
 			offset += size;
@@ -179,11 +200,9 @@ static loff_t vcs_lseek(struct file *file, loff_t offset, int orig)
 			break;
 	}
 	if (offset < 0 || offset > size) {
-		mutex_unlock(&con_buf_mtx);
 		return -EINVAL;
 	}
 	file->f_pos = offset;
-	mutex_unlock(&con_buf_mtx);
 	return file->f_pos;
 }
 
@@ -196,12 +215,15 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct vc_data *vc;
 	struct vcs_poll_data *poll;
 	long pos;
-	long viewed, attr, read;
-	int col, maxcol;
+	long attr, read;
+	int col, maxcol, viewed;
 	unsigned short *org = NULL;
 	ssize_t ret;
+	char *con_buf;
 
-	mutex_lock(&con_buf_mtx);
+	con_buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!con_buf)
+		return -ENOMEM;
 
 	pos = *ppos;
 
@@ -211,18 +233,10 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	console_lock();
 
 	attr = (currcons & 128);
-	currcons = (currcons & 127);
-	if (currcons == 0) {
-		currcons = fg_console;
-		viewed = 1;
-	} else {
-		currcons--;
-		viewed = 0;
-	}
 	ret = -ENXIO;
-	if (!vc_cons_allocated(currcons))
+	vc = vcs_vc(inode, &viewed);
+	if (!vc)
 		goto unlock_out;
-	vc = vc_cons[currcons].d;
 
 	ret = -EINVAL;
 	if (pos < 0)
@@ -367,7 +381,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		ret = read;
 unlock_out:
 	console_unlock();
-	mutex_unlock(&con_buf_mtx);
+	free_page((unsigned long) con_buf);
 	return ret;
 }
 
@@ -378,13 +392,16 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	unsigned int currcons = iminor(inode);
 	struct vc_data *vc;
 	long pos;
-	long viewed, attr, size, written;
+	long attr, size, written;
 	char *con_buf0;
-	int col, maxcol;
+	int col, maxcol, viewed;
 	u16 *org0 = NULL, *org = NULL;
 	size_t ret;
+	char *con_buf;
 
-	mutex_lock(&con_buf_mtx);
+	con_buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!con_buf)
+		return -ENOMEM;
 
 	pos = *ppos;
 
@@ -394,19 +411,10 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	console_lock();
 
 	attr = (currcons & 128);
-	currcons = (currcons & 127);
-
-	if (currcons == 0) {
-		currcons = fg_console;
-		viewed = 1;
-	} else {
-		currcons--;
-		viewed = 0;
-	}
 	ret = -ENXIO;
-	if (!vc_cons_allocated(currcons))
+	vc = vcs_vc(inode, &viewed);
+	if (!vc)
 		goto unlock_out;
-	vc = vc_cons[currcons].d;
 
 	size = vcs_size(inode);
 	ret = -EINVAL;
@@ -561,9 +569,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 unlock_out:
 	console_unlock();
-
-	mutex_unlock(&con_buf_mtx);
-
+	free_page((unsigned long) con_buf);
 	return ret;
 }
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 147ede3..0fd6df5 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2068,18 +2068,6 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 	}
 }
 
-/* This is a temporary buffer used to prepare a tty console write
- * so that we can easily avoid touching user space while holding the
- * console spinlock.  It is allocated in con_init and is shared by
- * this code and the vc_screen read/write tty calls.
- *
- * We have to allocate this statically in the kernel data section
- * since console_init (and thus con_init) are called before any
- * kernel memory allocation is available.
- */
-char con_buf[CON_BUF_SIZE];
-DEFINE_MUTEX(con_buf_mtx);
-
 /* is_double_width() is based on the wcwidth() implementation by
  * Markus Kuhn -- 2007-05-26 (Unicode 5.0)
  * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 6625cc1..4d05e14 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -142,14 +142,6 @@ static inline bool vt_force_oops_output(struct vc_data *vc)
 	return false;
 }
 
-/*
- * vc_screen.c shares this temporary buffer with the console write code so that
- * we can easily avoid touching user space while holding the console spinlock.
- */
-
-#define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
-extern char con_buf[CON_BUF_SIZE];
-extern struct mutex con_buf_mtx;
 extern char vt_dont_switch;
 extern int default_utf8;
 extern int global_cursor_default;
-- 
1.7.1

