Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0FTHUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:20:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0FTHUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:20:49 -0400
Subject: [PATCH] drivers/media/IR/imon.c: Use pr_err instead of err
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 00:20:46 -0700
Message-ID: <1277018446.1548.66.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard error logging mechanisms.
Add #define pr_fmt(fmt) KBUILD_MODNAME ":%s" fmt, __func__
Remove __func__ from err calls, add '\n', rename to pr_err

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/IR/imon.c |   73 ++++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 4bbd45f..36fb423 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -26,6 +26,8 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -364,15 +366,14 @@ static int display_open(struct inode *inode, struct file *file)
 	subminor = iminor(inode);
 	interface = usb_find_interface(&imon_driver, subminor);
 	if (!interface) {
-		err("%s: could not find interface for minor %d",
-		    __func__, subminor);
+		pr_err("could not find interface for minor %d\n", subminor);
 		retval = -ENODEV;
 		goto exit;
 	}
 	ictx = usb_get_intfdata(interface);
 
 	if (!ictx) {
-		err("%s: no context found for minor %d", __func__, subminor);
+		pr_err("no context found for minor %d\n", subminor);
 		retval = -ENODEV;
 		goto exit;
 	}
@@ -380,10 +381,10 @@ static int display_open(struct inode *inode, struct file *file)
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->display_supported) {
-		err("%s: display not supported by device", __func__);
+		pr_err("display not supported by device\n");
 		retval = -ENODEV;
 	} else if (ictx->display_isopen) {
-		err("%s: display port is already open", __func__);
+		pr_err("display port is already open\n");
 		retval = -EBUSY;
 	} else {
 		ictx->display_isopen = true;
@@ -410,17 +411,17 @@ static int display_close(struct inode *inode, struct file *file)
 	ictx = (struct imon_context *)file->private_data;
 
 	if (!ictx) {
-		err("%s: no context for device", __func__);
+		pr_err("no context for device\n");
 		return -ENODEV;
 	}
 
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->display_supported) {
-		err("%s: display not supported by device", __func__);
+		pr_err("display not supported by device\n");
 		retval = -ENODEV;
 	} else if (!ictx->display_isopen) {
-		err("%s: display is not open", __func__);
+		pr_err("display is not open\n");
 		retval = -EIO;
 	} else {
 		ictx->display_isopen = false;
@@ -499,19 +500,19 @@ static int send_packet(struct imon_context *ictx)
 	if (retval) {
 		ictx->tx.busy = false;
 		smp_rmb(); /* ensure later readers know we're not busy */
-		err("%s: error submitting urb(%d)", __func__, retval);
+		pr_err("error submitting urb(%d)\n", retval);
 	} else {
 		/* Wait for transmission to complete (or abort) */
 		mutex_unlock(&ictx->lock);
 		retval = wait_for_completion_interruptible(
 				&ictx->tx.finished);
 		if (retval)
-			err("%s: task interrupted", __func__);
+			pr_err("task interrupted\n");
 		mutex_lock(&ictx->lock);
 
 		retval = ictx->tx.status;
 		if (retval)
-			err("%s: packet tx failed (%d)", __func__, retval);
+			pr_err("packet tx failed (%d)\n", retval);
 	}
 
 	kfree(control_req);
@@ -543,12 +544,12 @@ static int send_associate_24g(struct imon_context *ictx)
 					  0x00, 0x00, 0x00, 0x20 };
 
 	if (!ictx) {
-		err("%s: no context for device", __func__);
+		pr_err("no context for device\n");
 		return -ENODEV;
 	}
 
 	if (!ictx->dev_present_intf0) {
-		err("%s: no iMON device present", __func__);
+		pr_err("no iMON device present\n");
 		return -ENODEV;
 	}
 
@@ -576,7 +577,7 @@ static int send_set_imon_clock(struct imon_context *ictx,
 	int i;
 
 	if (!ictx) {
-		err("%s: no context for device", __func__);
+		pr_err("no context for device\n");
 		return -ENODEV;
 	}
 
@@ -637,8 +638,7 @@ static int send_set_imon_clock(struct imon_context *ictx,
 		memcpy(ictx->usb_tx_buf, clock_enable_pkt[i], 8);
 		retval = send_packet(ictx);
 		if (retval) {
-			err("%s: send_packet failed for packet %d",
-			    __func__, i);
+			pr_err("send_packet failed for packet %d\n", i);
 			break;
 		}
 	}
@@ -814,20 +814,20 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 
 	ictx = (struct imon_context *)file->private_data;
 	if (!ictx) {
-		err("%s: no context for device", __func__);
+		pr_err("no context for device\n");
 		return -ENODEV;
 	}
 
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->dev_present_intf0) {
-		err("%s: no iMON device present", __func__);
+		pr_err("no iMON device present\n");
 		retval = -ENODEV;
 		goto exit;
 	}
 
 	if (n_bytes <= 0 || n_bytes > 32) {
-		err("%s: invalid payload size", __func__);
+		pr_err("invalid payload size\n");
 		retval = -EINVAL;
 		goto exit;
 	}
@@ -853,8 +853,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 
 		retval = send_packet(ictx);
 		if (retval) {
-			err("%s: send packet failed for packet #%d",
-					__func__, seq/2);
+			pr_err("send packet failed for packet #%d\n", seq / 2);
 			goto exit;
 		} else {
 			seq += 2;
@@ -868,8 +867,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 	ictx->usb_tx_buf[7] = (unsigned char) seq;
 	retval = send_packet(ictx);
 	if (retval)
-		err("%s: send packet failed for packet #%d",
-		    __func__, seq / 2);
+		pr_err("send packet failed for packet #%d\n", seq / 2);
 
 exit:
 	mutex_unlock(&ictx->lock);
@@ -898,21 +896,20 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 
 	ictx = (struct imon_context *)file->private_data;
 	if (!ictx) {
-		err("%s: no context for device", __func__);
+		pr_err("no context for device\n");
 		return -ENODEV;
 	}
 
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->display_supported) {
-		err("%s: no iMON display present", __func__);
+		pr_err("no iMON display present\n");
 		retval = -ENODEV;
 		goto exit;
 	}
 
 	if (n_bytes != 8) {
-		err("%s: invalid payload size: %d (expecting 8)",
-		    __func__, (int) n_bytes);
+		pr_err("invalid payload size: %d (expected 8)\n", (int)n_bytes);
 		retval = -EINVAL;
 		goto exit;
 	}
@@ -924,7 +921,7 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 
 	retval = send_packet(ictx);
 	if (retval) {
-		err("%s: send packet failed!", __func__);
+		pr_err("send packet failed!\n");
 		goto exit;
 	} else {
 		dev_dbg(ictx->dev, "%s: write %d bytes to LCD\n",
@@ -1863,7 +1860,7 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 
 	/* Input endpoint is mandatory */
 	if (!ir_ep_found)
-		err("%s: no valid input (IR) endpoint found.", __func__);
+		pr_err("no valid input (IR) endpoint found\n");
 
 	ictx->tx_control = tx_control;
 
@@ -1935,8 +1932,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 
 	ret = usb_submit_urb(ictx->rx_urb_intf0, GFP_KERNEL);
 	if (ret) {
-		err("%s: usb_submit_urb failed for intf0 (%d)",
-		    __func__, ret);
+		pr_err("usb_submit_urb failed for intf0 (%d)\n", ret);
 		goto urb_submit_failed;
 	}
 
@@ -1968,7 +1964,7 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rx_urb) {
-		err("%s: usb_alloc_urb failed for IR urb", __func__);
+		pr_err("usb_alloc_urb failed for IR urb\n");
 		goto rx_urb_alloc_failed;
 	}
 
@@ -2006,8 +2002,7 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	ret = usb_submit_urb(ictx->rx_urb_intf1, GFP_KERNEL);
 
 	if (ret) {
-		err("%s: usb_submit_urb failed for intf1 (%d)",
-		    __func__, ret);
+		pr_err("usb_submit_urb failed for intf1 (%d)\n", ret);
 		goto urb_submit_failed;
 	}
 
@@ -2200,7 +2195,7 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	if (ifnum == 0) {
 		ictx = imon_init_intf0(interface);
 		if (!ictx) {
-			err("%s: failed to initialize context!\n", __func__);
+			pr_err("failed to initialize context!\n");
 			ret = -ENODEV;
 			goto fail;
 		}
@@ -2209,7 +2204,7 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	/* this is the secondary interface on the device */
 		ictx = imon_init_intf1(interface, first_if_ctx);
 		if (!ictx) {
-			err("%s: failed to attach to context!\n", __func__);
+			pr_err("failed to attach to context!\n");
 			ret = -ENODEV;
 			goto fail;
 		}
@@ -2236,8 +2231,8 @@ static int __devinit imon_probe(struct usb_interface *interface,
 			sysfs_err = sysfs_create_group(&interface->dev.kobj,
 						       &imon_rf_attribute_group);
 			if (sysfs_err)
-				err("%s: Could not create RF sysfs entries(%d)",
-				    __func__, sysfs_err);
+				pr_err("Could not create RF sysfs entries(%d)\n",
+				       sysfs_err);
 		}
 
 		if (ictx->display_supported)
@@ -2387,7 +2382,7 @@ static int __init imon_init(void)
 
 	rc = usb_register(&imon_driver);
 	if (rc) {
-		err("%s: usb register failed(%d)", __func__, rc);
+		pr_err("usb register failed(%d)\n", rc);
 		rc = -ENODEV;
 	}
 


