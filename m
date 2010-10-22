Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0JVS3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:29:34 -0400
Received: from kroah.org ([198.145.64.141]:37816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932Ab0JVSZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/31] uio: Cleanup irq handling.
Date: Fri, 22 Oct 2010 11:25:01 -0700
Message-Id: <1287771916-15016-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

Change the value of UIO_IRQ_NONE -2 to 0.  0 is well defined in the rest
of the kernel as the value to indicate an irq has not been assigned.

Update the calls to request_irq and free_irq to only ignore UIO_IRQ_NONE
and UIO_IRQ_CUSTOM allowing the rest of the kernel's possible irq
numbers to be used.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c          |   14 +++++++-------
 include/linux/uio_driver.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 8132288..0fd2cda 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -512,7 +512,7 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
 
-	if (idev->info->irq == UIO_IRQ_NONE)
+	if (!idev->info->irq)
 		return -EIO;
 
 	poll_wait(filep, &idev->wait, wait);
@@ -530,7 +530,7 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	ssize_t retval;
 	s32 event_count;
 
-	if (idev->info->irq == UIO_IRQ_NONE)
+	if (!idev->info->irq)
 		return -EIO;
 
 	if (count != sizeof(s32))
@@ -578,7 +578,7 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 	ssize_t retval;
 	s32 irq_on;
 
-	if (idev->info->irq == UIO_IRQ_NONE)
+	if (!idev->info->irq)
 		return -EIO;
 
 	if (count != sizeof(s32))
@@ -825,9 +825,9 @@ int __uio_register_device(struct module *owner,
 
 	info->uio_dev = idev;
 
-	if (idev->info->irq >= 0) {
-		ret = request_irq(idev->info->irq, uio_interrupt,
-				  idev->info->irq_flags, idev->info->name, idev);
+	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
+		ret = request_irq(info->irq, uio_interrupt,
+				  info->irq_flags, info->name, idev);
 		if (ret)
 			goto err_request_irq;
 	}
@@ -863,7 +863,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_free_minor(idev);
 
-	if (info->irq >= 0)
+	if (info->irq && (info->irq != UIO_IRQ_CUSTOM))
 		free_irq(info->irq, idev);
 
 	uio_dev_del_attributes(idev);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 5dcc9ff..d6188e5 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -108,7 +108,7 @@ extern void uio_event_notify(struct uio_info *info);
 
 /* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM	-1
-#define UIO_IRQ_NONE	-2
+#define UIO_IRQ_NONE	0
 
 /* defines for uio_mem->memtype */
 #define UIO_MEM_NONE	0
-- 
1.7.2

