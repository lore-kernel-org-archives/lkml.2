Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2I1Uv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:51:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36421 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161009Ab2I1Usp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:45 -0400
X-Sasl-enc: zqtl3Bnt7m6jyQ14xjfVDsICu+14dWhH6mb8bCr78jJC 1348865324
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 106/127] media: lirc_sir: make device registration work
Date: Fri, 28 Sep 2012 13:34:39 -0700
Message-Id: <20120928203058.266169802@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 4b71ca6bce8fab3d08c61bf330e781f957934ae1 upstream.

For one, the driver device pointer needs to be filled in, or the lirc core
will refuse to load the driver. And we really need to wire up all the
platform_device bits. This has been tested via the lirc sourceforge tree
and verified to work, been sitting there for months, finally getting
around to sending it. :\

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/lirc/lirc_sir.c |   60 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

--- a/drivers/staging/lirc/lirc_sir.c
+++ b/drivers/staging/lirc/lirc_sir.c
@@ -53,6 +53,7 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/fcntl.h>
+#include <linux/platform_device.h>
 #ifdef LIRC_ON_SA1100
 #include <asm/hardware.h>
 #ifdef CONFIG_SA1100_COLLIE
@@ -488,9 +489,11 @@ static struct lirc_driver driver = {
 	.owner		= THIS_MODULE,
 };
 
+static struct platform_device *lirc_sir_dev;
 
 static int init_chrdev(void)
 {
+	driver.dev = &lirc_sir_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
 		printk(KERN_ERR LIRC_DRIVER_NAME ": init_chrdev() failed.\n");
@@ -1216,20 +1219,71 @@ static int init_lirc_sir(void)
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
@@ -1237,6 +1291,8 @@ static void __exit lirc_sir_exit(void)
 	drop_hardware();
 	drop_chrdev();
 	drop_port();
+	platform_device_unregister(lirc_sir_dev);
+	platform_driver_unregister(&lirc_sir_driver);
 	printk(KERN_INFO LIRC_DRIVER_NAME ": Uninstalled.\n");
 }
 


