Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0FUPCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:02:48 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48097 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab0FUPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:02:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, "Craig W. Nadler" <craig@nadler.us>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] USB: gadget/printer, fix sleep inside atomic
Date: Mon, 21 Jun 2010 17:02:40 +0200
Message-Id: <1277132560-14284-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that sleep is called inside atomic context created by
lock_printer_io spinlock in several functions. It's used in process
context only and some functions sleep inside its critical section. As
this is not allowed for spinlocks, switch it to mutex.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Craig W. Nadler <craig@nadler.us>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/printer.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 43abf55..4c3ac5c 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -82,7 +82,7 @@ static struct class *usb_gadget_class;
 struct printer_dev {
 	spinlock_t		lock;		/* lock this structure */
 	/* lock buffer lists during read/write calls */
-	spinlock_t		lock_printer_io;
+	struct mutex		lock_printer_io;
 	struct usb_gadget	*gadget;
 	struct usb_request	*req;		/* for control responses */
 	u8			config;
@@ -567,7 +567,7 @@ printer_read(struct file *fd, char __user *buf, size_t len, loff_t *ptr)
 
 	DBG(dev, "printer_read trying to read %d bytes\n", (int)len);
 
-	spin_lock(&dev->lock_printer_io);
+	mutex_lock(&dev->lock_printer_io);
 	spin_lock_irqsave(&dev->lock, flags);
 
 	/* We will use this flag later to check if a printer reset happened
@@ -601,7 +601,7 @@ printer_read(struct file *fd, char __user *buf, size_t len, loff_t *ptr)
 		 * call or not.
 		 */
 		if (fd->f_flags & (O_NONBLOCK|O_NDELAY)) {
-			spin_unlock(&dev->lock_printer_io);
+			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
 
@@ -648,7 +648,7 @@ printer_read(struct file *fd, char __user *buf, size_t len, loff_t *ptr)
 		if (dev->reset_printer) {
 			list_add(&current_rx_req->list, &dev->rx_reqs);
 			spin_unlock_irqrestore(&dev->lock, flags);
-			spin_unlock(&dev->lock_printer_io);
+			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
 
@@ -673,7 +673,7 @@ printer_read(struct file *fd, char __user *buf, size_t len, loff_t *ptr)
 	dev->current_rx_buf = current_rx_buf;
 
 	spin_unlock_irqrestore(&dev->lock, flags);
-	spin_unlock(&dev->lock_printer_io);
+	mutex_unlock(&dev->lock_printer_io);
 
 	DBG(dev, "printer_read returned %d bytes\n", (int)bytes_copied);
 
@@ -697,7 +697,7 @@ printer_write(struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	if (len == 0)
 		return -EINVAL;
 
-	spin_lock(&dev->lock_printer_io);
+	mutex_lock(&dev->lock_printer_io);
 	spin_lock_irqsave(&dev->lock, flags);
 
 	/* Check if a printer reset happens while we have interrupts on */
@@ -713,7 +713,7 @@ printer_write(struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		 * a NON-Blocking call or not.
 		 */
 		if (fd->f_flags & (O_NONBLOCK|O_NDELAY)) {
-			spin_unlock(&dev->lock_printer_io);
+			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
 
@@ -752,7 +752,7 @@ printer_write(struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 		if (copy_from_user(req->buf, buf, size)) {
 			list_add(&req->list, &dev->tx_reqs);
-			spin_unlock(&dev->lock_printer_io);
+			mutex_unlock(&dev->lock_printer_io);
 			return bytes_copied;
 		}
 
@@ -766,14 +766,14 @@ printer_write(struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 		if (dev->reset_printer) {
 			list_add(&req->list, &dev->tx_reqs);
 			spin_unlock_irqrestore(&dev->lock, flags);
-			spin_unlock(&dev->lock_printer_io);
+			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
 
 		if (usb_ep_queue(dev->in_ep, req, GFP_ATOMIC)) {
 			list_add(&req->list, &dev->tx_reqs);
 			spin_unlock_irqrestore(&dev->lock, flags);
-			spin_unlock(&dev->lock_printer_io);
+			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
 
@@ -782,7 +782,7 @@ printer_write(struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	}
 
 	spin_unlock_irqrestore(&dev->lock, flags);
-	spin_unlock(&dev->lock_printer_io);
+	mutex_unlock(&dev->lock_printer_io);
 
 	DBG(dev, "printer_write sent %d bytes\n", (int)bytes_copied);
 
@@ -820,11 +820,11 @@ printer_poll(struct file *fd, poll_table *wait)
 	unsigned long		flags;
 	int			status = 0;
 
-	spin_lock(&dev->lock_printer_io);
+	mutex_lock(&dev->lock_printer_io);
 	spin_lock_irqsave(&dev->lock, flags);
 	setup_rx_reqs(dev);
 	spin_unlock_irqrestore(&dev->lock, flags);
-	spin_unlock(&dev->lock_printer_io);
+	mutex_unlock(&dev->lock_printer_io);
 
 	poll_wait(fd, &dev->rx_wait, wait);
 	poll_wait(fd, &dev->tx_wait, wait);
@@ -1461,7 +1461,7 @@ autoconf_fail:
 	}
 
 	spin_lock_init(&dev->lock);
-	spin_lock_init(&dev->lock_printer_io);
+	mutex_init(&dev->lock_printer_io);
 	INIT_LIST_HEAD(&dev->tx_reqs);
 	INIT_LIST_HEAD(&dev->tx_reqs_active);
 	INIT_LIST_HEAD(&dev->rx_reqs);
@@ -1594,7 +1594,7 @@ cleanup(void)
 {
 	int status;
 
-	spin_lock(&usb_printer_gadget.lock_printer_io);
+	mutex_lock(&usb_printer_gadget.lock_printer_io);
 	class_destroy(usb_gadget_class);
 	unregister_chrdev_region(g_printer_devno, 2);
 
@@ -1602,6 +1602,6 @@ cleanup(void)
 	if (status)
 		ERROR(dev, "usb_gadget_unregister_driver %x\n", status);
 
-	spin_unlock(&usb_printer_gadget.lock_printer_io);
+	mutex_unlock(&usb_printer_gadget.lock_printer_io);
 }
 module_exit(cleanup);
-- 
1.7.1


