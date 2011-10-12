Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1JLJlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:41:47 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56994 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1JLJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:41:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, stable@kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/4] TTY: make tty_add_file non-failing
Date: Wed, 12 Oct 2011 11:32:43 +0200
Message-Id: <1318411965-23917-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318411965-23917-1-git-send-email-jslaby@suse.cz>
References: <4E8C6836.1090601@suse.cz>
 <1318411965-23917-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tty_add_file fails at the point it is now, we have to revert all
the changes we did to the tty. It means either decrease all refcounts
if this was a tty reopen or delete the tty if it was newly allocated.

There was a try to fix this in v3.0-rc2 using tty_release in 0259894c7
(TTY: fix fail path in tty_open). But instead it introduced a NULL
dereference. It's because tty_release dereferences
filp->private_data, but that one is set even in our tty_add_file. And
when tty_add_file fails, it's still NULL/garbage. Hence tty_release
cannot be called there.

To circumvent the original leak (and the current NULL deref) we split
tty_add_file into two functions, making the latter non-failing. In
that case we may do the former early in open, where handling failures
is easy. The latter stays as it is now. So there is no change in
functionality.

The original bug (leak) was introduced by f573bd176 (tty: Remove
__GFP_NOFAIL from tty_add_file()). Thanks Dan for reporting this.

Later, we may split tty_release into more functions and call only some
of them in this fail path instead. (If at all possible.)

Introduced-in: v2.6.37-rc2
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
---
 drivers/tty/pty.c    |   16 +++++++++++-----
 drivers/tty/tty_io.c |   47 +++++++++++++++++++++++++++++++++++------------
 include/linux/tty.h  |    4 +++-
 3 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index e809e9d..696e851 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -670,12 +670,18 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	nonseekable_open(inode, filp);
 
+	retval = tty_alloc_file(filp);
+	if (retval)
+		return retval;
+
 	/* find a device that is not in use. */
 	tty_lock();
 	index = devpts_new_index(inode);
 	tty_unlock();
-	if (index < 0)
-		return index;
+	if (index < 0) {
+		retval = index;
+		goto err_file;
+	}
 
 	mutex_lock(&tty_mutex);
 	tty_lock();
@@ -689,9 +695,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 
-	retval = tty_add_file(tty, filp);
-	if (retval)
-		goto out;
+	tty_add_file(tty, filp);
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
@@ -710,6 +714,8 @@ out2:
 out:
 	devpts_kill_index(inode, index);
 	tty_unlock();
+err_file:
+	tty_free_file(filp);
 	return retval;
 }
 
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 54b3cc4..1a890e2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -194,8 +194,7 @@ static inline struct tty_struct *file_tty(struct file *file)
 	return ((struct tty_file_private *)file->private_data)->tty;
 }
 
-/* Associate a new file with the tty structure */
-int tty_add_file(struct tty_struct *tty, struct file *file)
+int tty_alloc_file(struct file *file)
 {
 	struct tty_file_private *priv;
 
@@ -203,15 +202,36 @@ int tty_add_file(struct tty_struct *tty, struct file *file)
 	if (!priv)
 		return -ENOMEM;
 
+	file->private_data = priv;
+
+	return 0;
+}
+
+/* Associate a new file with the tty structure */
+void tty_add_file(struct tty_struct *tty, struct file *file)
+{
+	struct tty_file_private *priv = file->private_data;
+
 	priv->tty = tty;
 	priv->file = file;
-	file->private_data = priv;
 
 	spin_lock(&tty_files_lock);
 	list_add(&priv->list, &tty->tty_files);
 	spin_unlock(&tty_files_lock);
+}
 
-	return 0;
+/**
+ * tty_free_file - free file->private_data
+ *
+ * This shall be used only for fail path handling when tty_add_file was not
+ * called yet.
+ */
+void tty_free_file(struct file *file)
+{
+	struct tty_file_private *priv = file->private_data;
+
+	file->private_data = NULL;
+	kfree(priv);
 }
 
 /* Delete file from its tty */
@@ -222,8 +242,7 @@ void tty_del_file(struct file *file)
 	spin_lock(&tty_files_lock);
 	list_del(&priv->list);
 	spin_unlock(&tty_files_lock);
-	file->private_data = NULL;
-	kfree(priv);
+	tty_free_file(file);
 }
 
 
@@ -1811,6 +1830,10 @@ static int tty_open(struct inode *inode, struct file *filp)
 	nonseekable_open(inode, filp);
 
 retry_open:
+	retval = tty_alloc_file(filp);
+	if (retval)
+		return -ENOMEM;
+
 	noctty = filp->f_flags & O_NOCTTY;
 	index  = -1;
 	retval = 0;
@@ -1823,6 +1846,7 @@ retry_open:
 		if (!tty) {
 			tty_unlock();
 			mutex_unlock(&tty_mutex);
+			tty_free_file(filp);
 			return -ENXIO;
 		}
 		driver = tty_driver_kref_get(tty->driver);
@@ -1855,6 +1879,7 @@ retry_open:
 		}
 		tty_unlock();
 		mutex_unlock(&tty_mutex);
+		tty_free_file(filp);
 		return -ENODEV;
 	}
 
@@ -1862,6 +1887,7 @@ retry_open:
 	if (!driver) {
 		tty_unlock();
 		mutex_unlock(&tty_mutex);
+		tty_free_file(filp);
 		return -ENODEV;
 	}
 got_driver:
@@ -1873,6 +1899,7 @@ got_driver:
 			tty_unlock();
 			mutex_unlock(&tty_mutex);
 			tty_driver_kref_put(driver);
+			tty_free_file(filp);
 			return PTR_ERR(tty);
 		}
 	}
@@ -1888,15 +1915,11 @@ got_driver:
 	tty_driver_kref_put(driver);
 	if (IS_ERR(tty)) {
 		tty_unlock();
+		tty_free_file(filp);
 		return PTR_ERR(tty);
 	}
 
-	retval = tty_add_file(tty, filp);
-	if (retval) {
-		tty_unlock();
-		tty_release(inode, filp);
-		return retval;
-	}
+	tty_add_file(tty, filp);
 
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6af44ab..ac275c2 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -479,7 +479,9 @@ extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
-extern int tty_add_file(struct tty_struct *tty, struct file *file);
+extern int tty_alloc_file(struct file *file);
+extern void tty_add_file(struct tty_struct *tty, struct file *file);
+extern void tty_free_file(struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
-- 
1.7.7


