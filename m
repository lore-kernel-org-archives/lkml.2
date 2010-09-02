Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0IBQSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:18:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0IBQSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:18:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tty: getting rid of __GFP_NOFAIL in tty_add_file
Date: Thu,  2 Sep 2010 18:17:56 +0200
Message-Id: <1283444276-19355-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

added error handling for struct tty_file_private allocation,
Fixed error paths in tty_open and ptmx_open.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/char/pty.c    |    9 ++++++++-
 drivers/char/tty_io.c |   26 +++++++++++++++++++-------
 include/linux/tty.h   |    4 +++-
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c350d01..cc4f861 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -652,6 +652,7 @@ static const struct tty_operations pty_unix98_ops = {
 static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
+	struct tty_file_private *priv;
 	int retval;
 	int index;
 
@@ -664,6 +665,12 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	if (index < 0)
 		return index;
 
+	priv = alloc_tty_priv();
+	if (!priv)
+		return -ENOMEM;
+
+	filp->private_data = priv;
+
 	mutex_lock(&tty_mutex);
 	tty_lock();
 	tty = tty_init_dev(ptm_driver, index, 1);
@@ -676,7 +683,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 
-	tty_add_file(tty, filp);
+	tty_set_priv(priv, tty, filp);
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 949067a..99d8bcb 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -193,17 +193,19 @@ static inline struct tty_struct *file_tty(struct file *file)
 	return ((struct tty_file_private *)file->private_data)->tty;
 }
 
-/* Associate a new file with the tty structure */
-void tty_add_file(struct tty_struct *tty, struct file *file)
+
+struct tty_file_private *alloc_tty_priv(void)
 {
-	struct tty_file_private *priv;
+	return kzalloc(sizeof(struct tty_file_private), GFP_KERNEL);
+}
 
-	/* XXX: must implement proper error handling in callers */
-	priv = kmalloc(sizeof(*priv), GFP_KERNEL|__GFP_NOFAIL);
 
+/* Associate a new file with the tty structure */
+void tty_set_priv(struct tty_file_private *priv, struct tty_struct *tty,
+		  struct file *file)
+{
 	priv->tty = tty;
 	priv->file = file;
-	file->private_data = priv;
 
 	spin_lock(&tty_files_lock);
 	list_add(&priv->list, &tty->tty_files);
@@ -1787,6 +1789,7 @@ int tty_release(struct inode *inode, struct file *filp)
 static int tty_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty = NULL;
+	struct tty_file_private *priv;
 	int noctty, retval;
 	struct tty_driver *driver;
 	int index;
@@ -1861,6 +1864,15 @@ got_driver:
 		}
 	}
 
+	priv = alloc_tty_priv();
+	if (!priv) {
+		tty_unlock();
+		mutex_unlock(&tty_mutex);
+		return -ENOMEM;
+	}
+
+	filp->private_data = priv;
+
 	if (tty) {
 		retval = tty_reopen(tty);
 		if (retval)
@@ -1875,7 +1887,7 @@ got_driver:
 		return PTR_ERR(tty);
 	}
 
-	tty_add_file(tty, filp);
+	tty_set_priv(priv, tty, filp);
 
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 67d64e6..48705aa 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -465,7 +465,9 @@ extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
-extern void tty_add_file(struct tty_struct *tty, struct file *file);
+struct tty_file_private *alloc_tty_priv(void);
+void tty_set_priv(struct tty_file_private *priv, struct tty_struct *tty,
+		struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
-- 
1.7.1

