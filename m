Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2KHTzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:55:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41824 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab2KHTzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:55:15 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use pr_ printks in lirc/lirc_serial.c
Date: Fri,  9 Nov 2012 04:55:09 +0900
Message-Id: <1352404509-7769-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_serial.c |   70 +++++++++++++-----------------
 1 file changed, 29 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 97ef670..89e2820 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -48,6 +48,8 @@
  * Steve Davies <steve@daviesfam.org>  July 2001
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
@@ -667,8 +669,7 @@ static irqreturn_t irq_handler(int i, void *blah)
 		counter++;
 		status = sinp(UART_MSR);
 		if (counter > RS_ISR_PASS_LIMIT) {
-			printk(KERN_WARNING LIRC_DRIVER_NAME ": AIEEEE: "
-			       "We're caught!\n");
+			pr_warn("AIEEEE: We're caught!\n");
 			break;
 		}
 		if ((status & hardware[type].signal_pin_change)
@@ -703,11 +704,10 @@ static irqreturn_t irq_handler(int i, void *blah)
 			dcd = (status & hardware[type].signal_pin) ? 1 : 0;
 
 			if (dcd == last_dcd) {
-				printk(KERN_WARNING LIRC_DRIVER_NAME
-				": ignoring spike: %d %d %lx %lx %lx %lx\n",
-				dcd, sense,
-				tv.tv_sec, lasttv.tv_sec,
-				tv.tv_usec, lasttv.tv_usec);
+				pr_warn("ignoring spike: %d %d %lx %lx %lx %lx\n",
+					dcd, sense,
+					tv.tv_sec, lasttv.tv_sec,
+					tv.tv_usec, lasttv.tv_usec);
 				continue;
 			}
 
@@ -715,25 +715,20 @@ static irqreturn_t irq_handler(int i, void *blah)
 			if (tv.tv_sec < lasttv.tv_sec ||
 			    (tv.tv_sec == lasttv.tv_sec &&
 			     tv.tv_usec < lasttv.tv_usec)) {
-				printk(KERN_WARNING LIRC_DRIVER_NAME
-				       ": AIEEEE: your clock just jumped "
-				       "backwards\n");
-				printk(KERN_WARNING LIRC_DRIVER_NAME
-				       ": %d %d %lx %lx %lx %lx\n",
-				       dcd, sense,
-				       tv.tv_sec, lasttv.tv_sec,
-				       tv.tv_usec, lasttv.tv_usec);
+				pr_warn("AIEEEE: your clock just jumped backwards\n");
+				pr_warn("%d %d %lx %lx %lx %lx\n",
+					dcd, sense,
+					tv.tv_sec, lasttv.tv_sec,
+					tv.tv_usec, lasttv.tv_usec);
 				data = PULSE_MASK;
 			} else if (deltv > 15) {
 				data = PULSE_MASK; /* really long time */
 				if (!(dcd^sense)) {
 					/* sanity check */
-					printk(KERN_WARNING LIRC_DRIVER_NAME
-					       ": AIEEEE: "
-					       "%d %d %lx %lx %lx %lx\n",
-					       dcd, sense,
-					       tv.tv_sec, lasttv.tv_sec,
-					       tv.tv_usec, lasttv.tv_usec);
+					pr_warn("AIEEEE: %d %d %lx %lx %lx %lx\n",
+						dcd, sense,
+						tv.tv_sec, lasttv.tv_sec,
+						tv.tv_usec, lasttv.tv_usec);
 					/*
 					 * detecting pulse while this
 					 * MUST be a space!
@@ -776,8 +771,7 @@ static int hardware_init_port(void)
 	soutp(UART_IER, scratch);
 	if (scratch2 != 0 || scratch3 != 0x0f) {
 		/* we fail, there's nothing here */
-		printk(KERN_ERR LIRC_DRIVER_NAME ": port existence test "
-		       "failed, cannot continue\n");
+		pr_err("port existence test failed, cannot continue\n");
 		return -ENODEV;
 	}
 
@@ -850,11 +844,9 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 			     LIRC_DRIVER_NAME, (void *)&hardware);
 	if (result < 0) {
 		if (result == -EBUSY)
-			printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n",
-			       irq);
+			dev_err(&dev->dev, "IRQ %d busy\n", irq);
 		else if (result == -EINVAL)
-			printk(KERN_ERR LIRC_DRIVER_NAME
-			       ": Bad irq number or handler\n");
+			dev_err(&dev->dev, "Bad irq number or handler\n");
 		return result;
 	}
 
@@ -869,14 +861,11 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 				    LIRC_DRIVER_NAME) == NULL))
 	   || ((iommap == 0)
 	       && (request_region(io, 8, LIRC_DRIVER_NAME) == NULL))) {
-		printk(KERN_ERR  LIRC_DRIVER_NAME
-		       ": port %04x already in use\n", io);
-		printk(KERN_WARNING LIRC_DRIVER_NAME
-		       ": use 'setserial /dev/ttySX uart none'\n");
-		printk(KERN_WARNING LIRC_DRIVER_NAME
-		       ": or compile the serial port driver as module and\n");
-		printk(KERN_WARNING LIRC_DRIVER_NAME
-		       ": make sure this module is loaded first\n");
+		dev_err(&dev->dev, "port %04x already in use\n", io);
+		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
+		dev_warn(&dev->dev,
+			 "or compile the serial port driver as module and\n");
+		dev_warn(&dev->dev, "make sure this module is loaded first\n");
 		result = -EBUSY;
 		goto exit_free_irq;
 	}
@@ -907,11 +896,11 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 			msleep(40);
 		}
 		sense = (nlow >= nhigh ? 1 : 0);
-		printk(KERN_INFO LIRC_DRIVER_NAME  ": auto-detected active "
-		       "%s receiver\n", sense ? "low" : "high");
+		dev_info(&dev->dev, "auto-detected active %s receiver\n",
+			 sense ? "low" : "high");
 	} else
-		printk(KERN_INFO LIRC_DRIVER_NAME  ": Manually using active "
-		       "%s receiver\n", sense ? "low" : "high");
+		dev_info(&dev->dev, "Manually using active %s receiver\n",
+			 sense ? "low" : "high");
 
 	dprintk("Interrupt %d, port %04x obtained\n", irq, io);
 	return 0;
@@ -1247,8 +1236,7 @@ static int __init lirc_serial_init_module(void)
 	driver.dev = &lirc_serial_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
-		printk(KERN_ERR  LIRC_DRIVER_NAME
-		       ": register_chrdev failed!\n");
+		pr_err("register_chrdev failed!\n");
 		lirc_serial_exit();
 		return driver.minor;
 	}
-- 
1.7.9.5

