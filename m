Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0ITHVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:21:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51180 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0ITHVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:21:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
Date: Mon, 20 Sep 2010 00:21:07 -0700
In-Reply-To: <m139t451b4.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 20 Sep 2010 00:19:59 -0700")
Message-ID: <m1wrqg3mos.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: [PATCH 1/5] uio: Simplify the lifetime logic of struct uio_device.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Embed struct device into struct uio_device, and use
the refcounting and the release method of struct device
to control struct uio_device.

This allows device_create and device_destroy to be replaced
with the more standard device_register and device_unregister,
and allows the struct device reference count to act as a
reference count on struct idev as well.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 6285afb..565559c 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -30,7 +30,7 @@
 
 struct uio_device {
 	struct module		*owner;
-	struct device		*dev;
+	struct device		device;
 	int			minor;
 	atomic_t		event;
 	struct fasync_struct	*async_queue;
@@ -279,7 +279,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		if (!map_found) {
 			map_found = 1;
 			idev->map_dir = kobject_create_and_add("maps",
-							&idev->dev->kobj);
+							&idev->device.kobj);
 			if (!idev->map_dir)
 				goto err_map;
 		}
@@ -304,7 +304,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		if (!portio_found) {
 			portio_found = 1;
 			idev->portio_dir = kobject_create_and_add("portio",
-							&idev->dev->kobj);
+							&idev->device.kobj);
 			if (!idev->portio_dir)
 				goto err_portio;
 		}
@@ -339,7 +339,7 @@ err_map:
 		kobject_put(&map->kobj);
 	}
 	kobject_put(idev->map_dir);
-	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
+	dev_err(&idev->device, "error creating sysfs files (%d)\n", ret);
 	return ret;
 }
 
@@ -789,6 +789,13 @@ static void release_uio_class(void)
 	uio_major_cleanup();
 }
 
+static void uio_device_release(struct device *dev)
+{
+	struct uio_device *idev = dev_get_drvdata(dev);
+
+	kfree(idev);
+}
+
 /**
  * uio_register_device - register a new userspace IO device
  * @owner:	module that creates the new device
@@ -824,14 +831,19 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_get_minor;
 
-	idev->dev = device_create(&uio_class, parent,
-				  MKDEV(uio_major, idev->minor), idev,
-				  "uio%d", idev->minor);
-	if (IS_ERR(idev->dev)) {
-		printk(KERN_ERR "UIO: device register failed\n");
-		ret = PTR_ERR(idev->dev);
+	idev->device.devt = MKDEV(uio_major, idev->minor);
+	idev->device.class = &uio_class;
+	idev->device.parent = parent;
+	idev->device.release = uio_device_release;
+	dev_set_drvdata(&idev->device, idev);
+
+	ret = kobject_set_name(&idev->device.kobj, "uio%d", idev->minor);
+	if (ret)
+		goto err_device_create;
+
+	ret = device_register(&idev->device);
+	if (ret)
 		goto err_device_create;
-	}
 
 	ret = uio_dev_add_attributes(idev);
 	if (ret)
@@ -851,7 +863,10 @@ int __uio_register_device(struct module *owner,
 err_request_irq:
 	uio_dev_del_attributes(idev);
 err_uio_dev_add_attributes:
-	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
+	uio_free_minor(idev);
+	device_unregister(&idev->device);
+	return ret;
+
 err_device_create:
 	uio_free_minor(idev);
 err_get_minor:
@@ -882,8 +897,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_dev_del_attributes(idev);
 
-	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
-	kfree(idev);
+	device_unregister(&idev->device);
 
 	return;
 }
-- 
1.7.2.2

