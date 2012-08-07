Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2HGUDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:03:05 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36548 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2HGT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 21/41] TTY: move cdev_add to tty_register_device
Date: Tue,  7 Aug 2012 21:47:46 +0200
Message-Id: <1344368886-24033-22-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the /dev/ node not to be available before we call
tty_register_device. Otherwise we might race with open and
tty_struct->port might not be available at that time.

This is not an issue now, but would be a problem after "TTY: use
tty_port_register_device" is applied.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c       |   48 +++++++++++++++++++++++++++++++++++++-------
 include/linux/tty_driver.h |    2 +-
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 135e0e4..35a24e6 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2991,6 +2991,15 @@ EXPORT_SYMBOL_GPL(tty_put_char);
 
 struct class *tty_class;
 
+static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
+		unsigned int index, unsigned int count)
+{
+	/* init here, since reused cdevs cause crashes */
+	cdev_init(&driver->cdevs[index], &tty_fops);
+	driver->cdevs[index].owner = driver->owner;
+	return cdev_add(&driver->cdevs[index], dev, count);
+}
+
 /**
  *	tty_register_device - register a tty device
  *	@driver: the tty driver that describes the tty device
@@ -3013,8 +3022,10 @@ struct class *tty_class;
 struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 				   struct device *device)
 {
+	struct device *ret;
 	char name[64];
 	dev_t dev = MKDEV(driver->major, driver->minor_start) + index;
+	bool cdev = false;
 
 	if (index >= driver->num) {
 		printk(KERN_ERR "Attempt to register invalid tty line number "
@@ -3027,7 +3038,18 @@ struct device *tty_register_device(struct tty_driver *driver, unsigned index,
 	else
 		tty_line_name(driver, index, name);
 
-	return device_create(tty_class, device, dev, NULL, name);
+	if (!(driver->flags & TTY_DRIVER_EXCESSIVE_LINES)) {
+		int error = tty_cdev_add(driver, dev, index, 1);
+		if (error)
+			return ERR_PTR(error);
+		cdev = true;
+	}
+
+	ret = device_create(tty_class, device, dev, NULL, name);
+	if (IS_ERR(ret) && cdev)
+		cdev_del(&driver->cdevs[index]);
+
+	return ret;
 }
 EXPORT_SYMBOL(tty_register_device);
 
@@ -3046,6 +3068,8 @@ void tty_unregister_device(struct tty_driver *driver, unsigned index)
 {
 	device_destroy(tty_class,
 		MKDEV(driver->major, driver->minor_start) + index);
+	if (!(driver->flags & TTY_DRIVER_EXCESSIVE_LINES))
+		cdev_del(&driver->cdevs[index]);
 }
 EXPORT_SYMBOL(tty_unregister_device);
 
@@ -3062,6 +3086,7 @@ struct tty_driver *__tty_alloc_driver(unsigned int lines, struct module *owner,
 		unsigned long flags)
 {
 	struct tty_driver *driver;
+	unsigned int cdevs = 1;
 	int err;
 
 	if (!lines || (flags & TTY_DRIVER_UNNUMBERED_NODE && lines > 1))
@@ -3095,6 +3120,13 @@ struct tty_driver *__tty_alloc_driver(unsigned int lines, struct module *owner,
 			err = -ENOMEM;
 			goto err_free_all;
 		}
+		cdevs = lines;
+	}
+
+	driver->cdevs = kcalloc(cdevs, sizeof(*driver->cdevs), GFP_KERNEL);
+	if (!driver->cdevs) {
+		err = -ENOMEM;
+		goto err_free_all;
 	}
 
 	return driver;
@@ -3129,8 +3161,10 @@ static void destruct_tty_driver(struct kref *kref)
 				tty_unregister_device(driver, i);
 		}
 		proc_tty_unregister_driver(driver);
-		cdev_del(&driver->cdev);
+		if (driver->flags & TTY_DRIVER_EXCESSIVE_LINES)
+			cdev_del(&driver->cdevs[0]);
 	}
+	kfree(driver->cdevs);
 	kfree(driver->ports);
 	kfree(driver->termios);
 	kfree(driver->ttys);
@@ -3180,11 +3214,11 @@ int tty_register_driver(struct tty_driver *driver)
 	if (error < 0)
 		goto err;
 
-	cdev_init(&driver->cdev, &tty_fops);
-	driver->cdev.owner = driver->owner;
-	error = cdev_add(&driver->cdev, dev, driver->num);
-	if (error)
-		goto err_unreg_char;
+	if (driver->flags & TTY_DRIVER_EXCESSIVE_LINES) {
+		error = tty_cdev_add(driver, dev, 0, driver->num);
+		if (error)
+			goto err_unreg_char;
+	}
 
 	mutex_lock(&tty_mutex);
 	list_add(&driver->tty_drivers, &tty_drivers);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index ca8eb54..d2ba0e4 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -289,7 +289,7 @@ struct tty_operations {
 struct tty_driver {
 	int	magic;		/* magic number for this structure */
 	struct kref kref;	/* Reference management */
-	struct cdev cdev;
+	struct cdev *cdevs;
 	struct module	*owner;
 	const char	*driver_name;
 	const char	*name;
-- 
1.7.10.4


