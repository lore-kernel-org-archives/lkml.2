Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613Ab2FVPcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:32:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762562Ab2FVPcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:32:03 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/12] tty: move the handling of the tty release logic
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:47:58 +0100
Message-ID: <20120622154645.1405.7749.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we don't have tty->termios tied to drivers->tty we can untangle
the logic here. In addition we can push the removal logic out of the
destructor path.

At that point we can think about sorting out tty_port and console and all
the other ugly hangovers.

An important other property we now have is that the tty mutex does now cover
the drivers array. An assumption other bits of the code made and which is
necessary for the tty lock patch.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/pty.c               |    8 --------
 drivers/tty/tty_io.c            |   16 +++++-----------
 drivers/tty/vt/vt.c             |    1 -
 drivers/usb/serial/usb-serial.c |    3 +--
 include/linux/tty.h             |    1 -
 include/linux/tty_driver.h      |   11 +++--------
 6 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 56dcef4..f1ba793 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -497,12 +497,6 @@ static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver,
 	return tty;
 }
 
-static void pty_unix98_shutdown(struct tty_struct *tty)
-{
-	tty_driver_remove_tty(tty->driver, tty);
-	/* We have our own method as we don't use the tty index */
-}
-
 /* We have no need to install and remove our tty objects as devpts does all
    the work for us */
 
@@ -563,7 +557,6 @@ static const struct tty_operations ptm_unix98_ops = {
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
 	.ioctl = pty_unix98_ioctl,
-	.shutdown = pty_unix98_shutdown,
 	.resize = pty_resize
 };
 
@@ -579,7 +572,6 @@ static const struct tty_operations pty_unix98_ops = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
-	.shutdown = pty_unix98_shutdown
 };
 
 /**
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 14db2a8..e062c1b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1443,12 +1443,6 @@ void tty_free_termios(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_free_termios);
 
-void tty_shutdown(struct tty_struct *tty)
-{
-	tty_driver_remove_tty(tty->driver, tty);
-	tty_free_termios(tty);
-}
-EXPORT_SYMBOL(tty_shutdown);
 
 /**
  *	release_one_tty		-	release tty structure memory
@@ -1492,11 +1486,6 @@ static void queue_release_one_tty(struct kref *kref)
 {
 	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
 
-	if (tty->ops->shutdown)
-		tty->ops->shutdown(tty);
-	else
-		tty_shutdown(tty);
-
 	/* The hangup queue is now free so we can reuse it rather than
 	   waste a chunk of memory for each port */
 	INIT_WORK(&tty->hangup_work, release_one_tty);
@@ -1536,6 +1525,11 @@ static void release_tty(struct tty_struct *tty, int idx)
 	/* This should always be true but check for the moment */
 	WARN_ON(tty->index != idx);
 
+	if (tty->ops->shutdown)
+		tty->ops->shutdown(tty);
+	tty_free_termios(tty);
+	tty_driver_remove_tty(tty->driver, tty);
+
 	if (tty->link)
 		tty_kref_put(tty->link);
 	tty_kref_put(tty);
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 02c7cdd..2c9af9c 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2839,7 +2839,6 @@ static void con_shutdown(struct tty_struct *tty)
 	console_lock();
 	vc->port.tty = NULL;
 	console_unlock();
-	tty_shutdown(tty);
 }
 
 static int default_italic_color    = 2; // green (ASCII)
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 003b191..3bca1ea 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -305,8 +305,7 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
  * Do the resource freeing and refcount dropping for the port.
  * Avoid freeing the console.
  *
- * Called asynchronously after the last tty kref is dropped,
- * and the tty layer has already done the tty_shutdown(tty);
+ * Called asynchronously after the last tty kref is dropped.
  */
 static void serial_cleanup(struct tty_struct *tty)
 {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 86fce83..4132d9e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -423,7 +423,6 @@ extern void tty_unthrottle(struct tty_struct *tty);
 extern int tty_do_resize(struct tty_struct *tty, struct winsize *ws);
 extern void tty_driver_remove_tty(struct tty_driver *driver,
 				  struct tty_struct *tty);
-extern void tty_shutdown(struct tty_struct *tty);
 extern void tty_free_termios(struct tty_struct *tty);
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 6e6dbb7..2bcf2a9 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -45,14 +45,9 @@
  *
  * void (*shutdown)(struct tty_struct * tty);
  *
- * 	This routine is called synchronously when a particular tty device
- *	is closed for the last time freeing up the resources.
- *	Note that tty_shutdown() is not called if ops->shutdown is defined.
- *	This means one is responsible to take care of calling ops->remove (e.g.
- *	via tty_driver_remove_tty) and releasing tty->termios.
- *	Note that this hook may be called from *all* the contexts where one
- *	uses tty refcounting (e.g. tty_port_tty_get).
- *
+ * 	This routine is called under the tty lock when a particular tty device
+ *	is closed for the last time. It executes before the tty resources
+ *	are freed so may execute while another function holds a tty kref.
  *
  * void (*cleanup)(struct tty_struct * tty);
  *

