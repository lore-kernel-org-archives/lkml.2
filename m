Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab0JVSVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:21:36 -0400
Received: from kroah.org ([198.145.64.141]:41847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0JVSVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/49] tty: Remove __GFP_NOFAIL from tty_add_file()
Date: Fri, 22 Oct 2010 11:20:44 -0700
Message-Id: <1287771688-14805-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

This patch removes __GFP_NOFAIL use from tty_add_file() and adds proper error
handling to the call-sites of the function.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/pty.c    |    4 +++-
 drivers/char/tty_io.c |   15 +++++++++++----
 include/linux/tty.h   |    2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c350d01..923a485 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -676,7 +676,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 
-	tty_add_file(tty, filp);
+	retval = tty_add_file(tty, filp);
+	if (retval)
+		goto out;
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index dc184d4..d6c659f 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -196,12 +196,13 @@ static inline struct tty_struct *file_tty(struct file *file)
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
@@ -210,6 +211,8 @@ void tty_add_file(struct tty_struct *tty, struct file *file)
 	spin_lock(&tty_files_lock);
 	list_add(&priv->list, &tty->tty_files);
 	spin_unlock(&tty_files_lock);
+
+	return 0;
 }
 
 /* Delete file from its tty */
@@ -1877,7 +1880,11 @@ got_driver:
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
index d94eb86..86be0cd 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -466,7 +466,7 @@ extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
-extern void tty_add_file(struct tty_struct *tty, struct file *file);
+extern int tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
-- 
1.7.2

