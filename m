Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2KHTxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:53:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2KHTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:53:43 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use pr_ printks in lirc/lirc_sir.c
Date: Fri,  9 Nov 2012 04:53:37 +0900
Message-Id: <1352404417-7598-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_sir.c |   36 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 4afc3b4..9a88f05 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -33,6 +33,8 @@
  *   parts cut'n'pasted from sa1100_ir.c (C) 2000 Russell King
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
@@ -495,7 +497,7 @@ static int init_chrdev(void)
 	driver.dev = &lirc_sir_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
-		printk(KERN_ERR LIRC_DRIVER_NAME ": init_chrdev() failed.\n");
+		pr_err("init_chrdev() failed.\n");
 		return -EIO;
 	}
 	return 0;
@@ -604,7 +606,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 	}
 
 	if (status & UTSR0_TFS)
-		printk(KERN_ERR "transmit fifo not full, shouldn't happen\n");
+		pr_err("transmit fifo not full, shouldn't happen\n");
 
 	/* We must clear certain bits. */
 	status &= (UTSR0_RID | UTSR0_RBB | UTSR0_REB);
@@ -787,7 +789,7 @@ static int init_hardware(void)
 #ifdef LIRC_ON_SA1100
 #ifdef CONFIG_SA1100_BITSY
 	if (machine_is_bitsy()) {
-		printk(KERN_INFO "Power on IR module\n");
+		pr_info("Power on IR module\n");
 		set_bitsy_egpio(EGPIO_BITSY_IR_ON);
 	}
 #endif
@@ -885,8 +887,7 @@ static int init_hardware(void)
 	udelay(1500);
 
 	/* read previous control byte */
-	printk(KERN_INFO LIRC_DRIVER_NAME
-	       ": 0x%02x\n", sinp(UART_RX));
+	pr_info("0x%02x\n", sinp(UART_RX));
 
 	/* Set DLAB 1. */
 	soutp(UART_LCR, sinp(UART_LCR) | UART_LCR_DLAB);
@@ -964,8 +965,7 @@ static int init_port(void)
 	/* get I/O port access and IRQ line */
 #ifndef LIRC_ON_SA1100
 	if (request_region(io, 8, LIRC_DRIVER_NAME) == NULL) {
-		printk(KERN_ERR LIRC_DRIVER_NAME
-		       ": i/o port 0x%.4x already in use.\n", io);
+		pr_err("i/o port 0x%.4x already in use.\n", io);
 		return -EBUSY;
 	}
 #endif
@@ -975,15 +975,11 @@ static int init_port(void)
 #               ifndef LIRC_ON_SA1100
 		release_region(io, 8);
 #               endif
-		printk(KERN_ERR LIRC_DRIVER_NAME
-			": IRQ %d already in use.\n",
-			irq);
+		pr_err("IRQ %d already in use.\n", irq);
 		return retval;
 	}
 #ifndef LIRC_ON_SA1100
-	printk(KERN_INFO LIRC_DRIVER_NAME
-		": I/O port 0x%.4x, IRQ %d.\n",
-		io, irq);
+	pr_info("I/O port 0x%.4x, IRQ %d.\n", io, irq);
 #endif
 
 	init_timer(&timerlist);
@@ -1213,8 +1209,7 @@ static int init_lirc_sir(void)
 	if (retval < 0)
 		return retval;
 	init_hardware();
-	printk(KERN_INFO LIRC_DRIVER_NAME
-		": Installed.\n");
+	pr_info("Installed.\n");
 	return 0;
 }
 
@@ -1243,23 +1238,20 @@ static int __init lirc_sir_init(void)
 
 	retval = platform_driver_register(&lirc_sir_driver);
 	if (retval) {
-		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform driver register "
-		       "failed!\n");
+		pr_err("Platform driver register failed!\n");
 		return -ENODEV;
 	}
 
 	lirc_sir_dev = platform_device_alloc("lirc_dev", 0);
 	if (!lirc_sir_dev) {
-		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform device alloc "
-		       "failed!\n");
+		pr_err("Platform device alloc failed!\n");
 		retval = -ENOMEM;
 		goto pdev_alloc_fail;
 	}
 
 	retval = platform_device_add(lirc_sir_dev);
 	if (retval) {
-		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform device add "
-		       "failed!\n");
+		pr_err("Platform device add failed!\n");
 		retval = -ENODEV;
 		goto pdev_add_fail;
 	}
@@ -1292,7 +1284,7 @@ static void __exit lirc_sir_exit(void)
 	drop_port();
 	platform_device_unregister(lirc_sir_dev);
 	platform_driver_unregister(&lirc_sir_driver);
-	printk(KERN_INFO LIRC_DRIVER_NAME ": Uninstalled.\n");
+	pr_info("Uninstalled.\n");
 }
 
 module_init(lirc_sir_init);
-- 
1.7.9.5

