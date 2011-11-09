Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1KIUde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:34 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37366 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1KIUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/7] TTY: extract /dev/tty handling from tty_open
Date: Wed,  9 Nov 2011 21:33:19 +0100
Message-Id: <1320870804-23687-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
References: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is special to others (done in the next patch). We have the
tty directly, not its driver and index. So this will reside in a
separation function. In the next patch, the rest will be moved to
another function.

So now we set neither driver nor index. Hence we need to init driver
and check whether we are supposed to put a ref of that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/tty_io.c |   57 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 391cec3..1b90c98 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1797,6 +1797,33 @@ int tty_release(struct inode *inode, struct file *filp)
 }
 
 /**
+ *	tty_open_current_tty - get tty of current task for open
+ *	@device: device number
+ *	@filp: file pointer to tty
+ *	@return: tty of the current task iff @device is /dev/tty
+ *
+ *	We cannot return driver and index like for the other nodes because
+ *	devpts will not work then. It expects inodes to be from devpts FS.
+ */
+static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
+{
+	struct tty_struct *tty;
+
+	if (device != MKDEV(TTYAUX_MAJOR, 0))
+		return NULL;
+
+	tty = get_current_tty();
+	if (!tty)
+		return ERR_PTR(-ENXIO);
+
+	filp->f_flags |= O_NONBLOCK; /* Don't let /dev/tty block */
+	/* noctty = 1; */
+	tty_kref_put(tty);
+	/* FIXME: we put a reference and return a TTY! */
+	return tty;
+}
+
+/**
  *	tty_open		-	open a tty device
  *	@inode: inode of device file
  *	@filp: file pointer to tty
@@ -1819,9 +1846,9 @@ int tty_release(struct inode *inode, struct file *filp)
 
 static int tty_open(struct inode *inode, struct file *filp)
 {
-	struct tty_struct *tty = NULL;
+	struct tty_struct *tty;
 	int noctty, retval;
-	struct tty_driver *driver;
+	struct tty_driver *driver = NULL;
 	int index;
 	dev_t device = inode->i_rdev;
 	unsigned saved_flags = filp->f_flags;
@@ -1840,22 +1867,15 @@ retry_open:
 	mutex_lock(&tty_mutex);
 	tty_lock();
 
-	if (device == MKDEV(TTYAUX_MAJOR, 0)) {
-		tty = get_current_tty();
-		if (!tty) {
-			tty_unlock();
-			mutex_unlock(&tty_mutex);
-			tty_free_file(filp);
-			return -ENXIO;
-		}
-		driver = tty_driver_kref_get(tty->driver);
-		index = tty->index;
-		filp->f_flags |= O_NONBLOCK; /* Don't let /dev/tty block */
-		/* noctty = 1; */
-		/* FIXME: Should we take a driver reference ? */
-		tty_kref_put(tty);
+	tty = tty_open_current_tty(device, filp);
+	if (IS_ERR(tty)) {
+		tty_unlock();
+		mutex_unlock(&tty_mutex);
+		tty_free_file(filp);
+		return PTR_ERR(tty);
+	} else if (tty)
 		goto got_driver;
-	}
+
 #ifdef CONFIG_VT
 	if (device == MKDEV(TTY_MAJOR, 0)) {
 		extern struct tty_driver *console_driver;
@@ -1911,7 +1931,8 @@ got_driver:
 		tty = tty_init_dev(driver, index, 0);
 
 	mutex_unlock(&tty_mutex);
-	tty_driver_kref_put(driver);
+	if (driver)
+		tty_driver_kref_put(driver);
 	if (IS_ERR(tty)) {
 		tty_unlock();
 		tty_free_file(filp);
-- 
1.7.7


