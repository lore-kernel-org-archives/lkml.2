Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0INSir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:38:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39588 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0INSil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:38:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>
References: <m1y6b48973.fsf@fess.ebiederm.org>
Date: Tue, 14 Sep 2010 11:38:06 -0700
In-Reply-To: <m1y6b48973.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Tue, 14 Sep 2010 11:35:28 -0700")
Message-ID: <m1eicw892p.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


register_chrdev limits uio devices to 256 minor numbers which causes
problems on one system I have with 384+ uio devices.  So instead set
UIO_MAX_DEVICES to the maximum number of minors and use
alloc_chrdev_region to reserve the uio minors.

The final result is that the code works the same but the uio driver now
supports any minor the idr allocator comes up with.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 0fd2cda..3d4d65b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -23,9 +23,10 @@
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kobject.h>
+#include <linux/cdev.h>
 #include <linux/uio_driver.h>
 
-#define UIO_MAX_DEVICES 255
+#define UIO_MAX_DEVICES		(1U << MINORBITS)
 
 struct uio_device {
 	struct module		*owner;
@@ -41,6 +42,7 @@ struct uio_device {
 };
 
 static int uio_major;
+static struct cdev *uio_cdev;
 static DEFINE_IDR(uio_idr);
 static const struct file_operations uio_fops;
 
@@ -731,15 +733,44 @@ static const struct file_operations uio_fops = {
 
 static int uio_major_init(void)
 {
-	uio_major = register_chrdev(0, "uio", &uio_fops);
-	if (uio_major < 0)
-		return uio_major;
-	return 0;
+	static const char name[] = "uio";
+	struct cdev *cdev = NULL;
+	dev_t uio_dev = 0;
+	int result;
+
+	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
+	if (result)
+		goto out;
+
+	result = -ENOMEM;
+	cdev = cdev_alloc();
+	if (!cdev)
+		goto out_unregister;
+
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &uio_fops;
+	kobject_set_name(&cdev->kobj, "%s", name);
+
+	result = cdev_add(cdev, uio_dev, UIO_MAX_DEVICES);
+	if (result)
+		goto out_put;
+
+	uio_major = MAJOR(uio_dev);
+	uio_cdev = cdev;
+	result = 0;
+out:
+	return result;
+out_put:
+	kobject_put(&cdev->kobj);
+out_unregister:
+	unregister_chrdev_region(uio_dev, UIO_MAX_DEVICES);
+	goto out;
 }
 
 static void uio_major_cleanup(void)
 {
-	unregister_chrdev(uio_major, "uio");
+	unregister_chrdev_region(MKDEV(uio_major, 0), UIO_MAX_DEVICES);
+	cdev_del(uio_cdev);
 }
 
 static int init_uio_class(void)
-- 
1.7.2.2

