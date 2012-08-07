Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2HGDiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59604 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260Ab2HGDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:07 -0400
Message-Id: <20120807032756.747314608@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:27:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jarod Wilson <jarod@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 04/70] [media] lirc_sir: make device registration work
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 4b71ca6bce8fab3d08c61bf330e781f957934ae1 upstream.

For one, the driver device pointer needs to be filled in, or the lirc core
will refuse to load the driver. And we really need to wire up all the
platform_device bits. This has been tested via the lirc sourceforge tree
and verified to work, been sitting there for months, finally getting
around to sending it. :\

CC: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_sir.c |   60 +++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 945d962..4afc3b4 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -52,6 +52,7 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/fcntl.h>
+#include <linux/platform_device.h>
 #ifdef LIRC_ON_SA1100
 #include <asm/hardware.h>
 #ifdef CONFIG_SA1100_COLLIE
@@ -487,9 +488,11 @@ static struct lirc_driver driver = {
 	.owner		= THIS_MODULE,
 };
 
+static struct platform_device *lirc_sir_dev;
 
 static int init_chrdev(void)
 {
+	driver.dev = &lirc_sir_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
 		printk(KERN_ERR LIRC_DRIVER_NAME ": init_chrdev() failed.\n");
@@ -1215,20 +1218,71 @@ static int init_lirc_sir(void)
 	return 0;
 }
 
+static int __devinit lirc_sir_probe(struct platform_device *dev)
+{
+	return 0;
+}
+
+static int __devexit lirc_sir_remove(struct platform_device *dev)
+{
+	return 0;
+}
+
+static struct platform_driver lirc_sir_driver = {
+	.probe		= lirc_sir_probe,
+	.remove		= __devexit_p(lirc_sir_remove),
+	.driver		= {
+		.name	= "lirc_sir",
+		.owner	= THIS_MODULE,
+	},
+};
 
 static int __init lirc_sir_init(void)
 {
 	int retval;
 
+	retval = platform_driver_register(&lirc_sir_driver);
+	if (retval) {
+		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform driver register "
+		       "failed!\n");
+		return -ENODEV;
+	}
+
+	lirc_sir_dev = platform_device_alloc("lirc_dev", 0);
+	if (!lirc_sir_dev) {
+		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform device alloc "
+		       "failed!\n");
+		retval = -ENOMEM;
+		goto pdev_alloc_fail;
+	}
+
+	retval = platform_device_add(lirc_sir_dev);
+	if (retval) {
+		printk(KERN_ERR LIRC_DRIVER_NAME ": Platform device add "
+		       "failed!\n");
+		retval = -ENODEV;
+		goto pdev_add_fail;
+	}
+
 	retval = init_chrdev();
 	if (retval < 0)
-		return retval;
+		goto fail;
+
 	retval = init_lirc_sir();
 	if (retval) {
 		drop_chrdev();
-		return retval;
+		goto fail;
 	}
+
 	return 0;
+
+fail:
+	platform_device_del(lirc_sir_dev);
+pdev_add_fail:
+	platform_device_put(lirc_sir_dev);
+pdev_alloc_fail:
+	platform_driver_unregister(&lirc_sir_driver);
+	return retval;
 }
 
 static void __exit lirc_sir_exit(void)
@@ -1236,6 +1290,8 @@ static void __exit lirc_sir_exit(void)
 	drop_hardware();
 	drop_chrdev();
 	drop_port();
+	platform_device_unregister(lirc_sir_dev);
+	platform_driver_unregister(&lirc_sir_driver);
 	printk(KERN_INFO LIRC_DRIVER_NAME ": Uninstalled.\n");
 }
 


