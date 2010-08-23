Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0HWUWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:22:12 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41754 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab0HWUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:22:06 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] tty: Remove __GFP_NOFAIL from tty_add_file()
Date: Mon, 23 Aug 2010 23:21:55 +0300
Message-Id: <1282594915-2480-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes __GFP_NOFAIL use from tty_add_file() and adds proper error
handling to the call-sites of the function.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/char/pty.c    |    4 +++-
 drivers/char/tty_io.c |   15 +++++++++++----
 include/linux/tty.h   |    2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c350d01..bc577ac 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -676,7 +676,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 
-	tty_add_file(tty, filp);
+	retval = tty_add_file(tty, filp);
+	if (retval)
+		goto out1;
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 949067a..1587f93 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -194,12 +194,13 @@ static inline struct tty_struct *file_tty(struct file *file)
 }
 
 /* Associate a new file with the tty structure */
-void tty_add_file(struct tty_struct *tty, struct file *file)
+int tty_add_file(struct tty_struct *tty, struct file *file)
 {
 	struct tty_file_private *priv;
 
-	/* XXX: must implement proper error handling in callers */
-	priv = kmalloc(sizeof(*priv), GFP_KERNEL|__GFP_NOFAIL);
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
 	priv->tty = tty;
 	priv->file = file;
@@ -208,6 +209,8 @@ void tty_add_file(struct tty_struct *tty, struct file *file)
 	spin_lock(&tty_files_lock);
 	list_add(&priv->list, &tty->tty_files);
 	spin_unlock(&tty_files_lock);
+
+	return 0;
 }
 
 /* Delete file from its tty */
@@ -1875,7 +1878,11 @@ got_driver:
 		return PTR_ERR(tty);
 	}
 
-	tty_add_file(tty, filp);
+	retval = tty_add_file(tty, filp);
+	if (retval) {
+		tty_unlock();
+		return retval;
+	}
 
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 67d64e6..a3f4388 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -465,7 +465,7 @@ extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
-extern void tty_add_file(struct tty_struct *tty, struct file *file);
+extern int tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
-- 
1.6.3.3

