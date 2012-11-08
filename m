Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2KHTym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:54:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55083 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2KHTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:39 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use pr_ printks in lirc/lirc_parallel.c
Date: Fri,  9 Nov 2012 04:54:33 +0900
Message-Id: <1352404473-7701-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then pr_notice(...  to printk(KERN_NOTICE ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_parallel.c |   49 +++++++++++-----------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index dd2bca7..139920c 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -22,6 +22,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /*** Includes ***/
 
 #include <linux/module.h>
@@ -115,8 +117,7 @@ static void out(int offset, int value)
 		parport_write_control(pport, value);
 		break;
 	case LIRC_LP_STATUS:
-		printk(KERN_INFO "%s: attempt to write to status register\n",
-		       LIRC_DRIVER_NAME);
+		pr_info("attempt to write to status register\n");
 		break;
 	}
 }
@@ -166,27 +167,23 @@ static unsigned int init_lirc_timer(void)
 		if (default_timer == 0) {
 			/* autodetect timer */
 			newtimer = (1000000*count)/timeelapsed;
-			printk(KERN_INFO "%s: %u Hz timer detected\n",
-			       LIRC_DRIVER_NAME, newtimer);
+			pr_info("%u Hz timer detected\n", newtimer);
 			return newtimer;
 		}  else {
 			newtimer = (1000000*count)/timeelapsed;
 			if (abs(newtimer - default_timer) > default_timer/10) {
 				/* bad timer */
-				printk(KERN_NOTICE "%s: bad timer: %u Hz\n",
-				       LIRC_DRIVER_NAME, newtimer);
-				printk(KERN_NOTICE "%s: using default timer: "
-				       "%u Hz\n",
-				       LIRC_DRIVER_NAME, default_timer);
+				pr_notice("bad timer: %u Hz\n", newtimer);
+				pr_notice("using default timer: %u Hz\n",
+					  default_timer);
 				return default_timer;
 			} else {
-				printk(KERN_INFO "%s: %u Hz timer detected\n",
-				       LIRC_DRIVER_NAME, newtimer);
+				pr_info("%u Hz timer detected\n", newtimer);
 				return newtimer; /* use detected value */
 			}
 		}
 	} else {
-		printk(KERN_NOTICE "%s: no timer detected\n", LIRC_DRIVER_NAME);
+		pr_notice("no timer detected\n");
 		return 0;
 	}
 }
@@ -194,13 +191,10 @@ static unsigned int init_lirc_timer(void)
 static int lirc_claim(void)
 {
 	if (parport_claim(ppdevice) != 0) {
-		printk(KERN_WARNING "%s: could not claim port\n",
-		       LIRC_DRIVER_NAME);
-		printk(KERN_WARNING "%s: waiting for port becoming available"
-		       "\n", LIRC_DRIVER_NAME);
+		pr_warn("could not claim port\n");
+		pr_warn("waiting for port becoming available\n");
 		if (parport_claim_or_block(ppdevice) < 0) {
-			printk(KERN_NOTICE "%s: could not claim port, giving"
-			       " up\n", LIRC_DRIVER_NAME);
+			pr_notice("could not claim port, giving up\n");
 			return 0;
 		}
 	}
@@ -219,7 +213,7 @@ static void rbuf_write(int signal)
 	if (nwptr == rptr) {
 		/* no new signals will be accepted */
 		lost_irqs++;
-		printk(KERN_NOTICE "%s: buffer overrun\n", LIRC_DRIVER_NAME);
+		pr_notice("buffer overrun\n");
 		return;
 	}
 	rbuf[wptr] = signal;
@@ -290,7 +284,7 @@ static void irq_handler(void *blah)
 		if (signal > timeout
 		    || (check_pselecd && (in(1) & LP_PSELECD))) {
 			signal = 0;
-			printk(KERN_NOTICE "%s: timeout\n", LIRC_DRIVER_NAME);
+			pr_notice("timeout\n");
 			break;
 		}
 	} while (lirc_get_signal());
@@ -644,8 +638,7 @@ static int __init lirc_parallel_init(void)
 
 	result = platform_driver_register(&lirc_parallel_driver);
 	if (result) {
-		printk(KERN_NOTICE "platform_driver_register"
-					" returned %d\n", result);
+		pr_notice("platform_driver_register returned %d\n", result);
 		return result;
 	}
 
@@ -661,8 +654,7 @@ static int __init lirc_parallel_init(void)
 
 	pport = parport_find_base(io);
 	if (pport == NULL) {
-		printk(KERN_NOTICE "%s: no port at %x found\n",
-		       LIRC_DRIVER_NAME, io);
+		pr_notice("no port at %x found\n", io);
 		result = -ENXIO;
 		goto exit_device_put;
 	}
@@ -670,8 +662,7 @@ static int __init lirc_parallel_init(void)
 					   pf, kf, irq_handler, 0, NULL);
 	parport_put_port(pport);
 	if (ppdevice == NULL) {
-		printk(KERN_NOTICE "%s: parport_register_device() failed\n",
-		       LIRC_DRIVER_NAME);
+		pr_notice("parport_register_device() failed\n");
 		result = -ENXIO;
 		goto exit_device_put;
 	}
@@ -706,14 +697,12 @@ static int __init lirc_parallel_init(void)
 	driver.dev = &lirc_parallel_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
-		printk(KERN_NOTICE "%s: register_chrdev() failed\n",
-		       LIRC_DRIVER_NAME);
+		pr_notice("register_chrdev() failed\n");
 		parport_unregister_device(ppdevice);
 		result = -EIO;
 		goto exit_device_put;
 	}
-	printk(KERN_INFO "%s: installed using port 0x%04x irq %d\n",
-	       LIRC_DRIVER_NAME, io, irq);
+	pr_info("installed using port 0x%04x irq %d\n", io, irq);
 	return 0;
 
 exit_device_put:
-- 
1.7.9.5

