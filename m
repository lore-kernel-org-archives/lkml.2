Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab1CaO4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:56:32 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57408 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 09/21] staging:iio: Push interrupt setup down into the drivers for event lines.
Date: Thu, 31 Mar 2011 15:54:03 +0100
Message-Id: <1301583255-28468-10-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is much easier to do in driver, and the core does not add much.
Note all drivers will have to be updated with this patch.
None currently are.
---
 drivers/staging/iio/iio.h               |    3 +++
 drivers/staging/iio/industrialio-core.c |   17 +++--------------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 1496f0b..341724f 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -12,6 +12,7 @@
 
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/irq.h>
 #include "sysfs.h"
 #include "chrdev.h"
 
@@ -328,6 +329,8 @@ void iio_unregister_interrupt_line(struct iio_dev *dev_info,
 				   int line_number);
 
 
+/* temporarily exported to allow moving of interrupt requesting into drivers */
+irqreturn_t iio_interrupt_handler(int irq, void *_int_info);
 
 /**
  * iio_push_event() - try to add event to the list for userspace reading
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 5b7b5df..7cee697 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -118,7 +118,7 @@ int iio_push_event(struct iio_dev *dev_info,
 EXPORT_SYMBOL(iio_push_event);
 
 /* Generic interrupt line interrupt handler */
-static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
+irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
 {
 	struct iio_interrupt *int_info = _int_info;
 	struct iio_dev *dev_info = int_info->dev_info;
@@ -141,6 +141,7 @@ static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL(iio_interrupt_handler);
 
 static struct iio_interrupt *iio_allocate_interrupt(void)
 {
@@ -159,7 +160,7 @@ int iio_register_interrupt_line(unsigned int irq,
 				unsigned long type,
 				const char *name)
 {
-	int ret;
+	int ret = 0;
 
 	dev_info->interrupts[line_number] = iio_allocate_interrupt();
 	if (dev_info->interrupts[line_number] == NULL) {
@@ -170,16 +171,6 @@ int iio_register_interrupt_line(unsigned int irq,
 	dev_info->interrupts[line_number]->irq = irq;
 	dev_info->interrupts[line_number]->dev_info = dev_info;
 
-	/* Possibly only request on demand?
-	 * Can see this may complicate the handling of interrupts.
-	 * However, with this approach we might end up handling lots of
-	 * events no-one cares about.*/
-	ret = request_irq(irq,
-			  &iio_interrupt_handler,
-			  type,
-			  name,
-			  dev_info->interrupts[line_number]);
-
 error_ret:
 	return ret;
 }
@@ -199,8 +190,6 @@ void iio_unregister_interrupt_line(struct iio_dev *dev_info, int line_number)
 {
 	/* make sure the interrupt handlers are all done */
 	flush_scheduled_work();
-	free_irq(dev_info->interrupts[line_number]->irq,
-		 dev_info->interrupts[line_number]);
 	kfree(dev_info->interrupts[line_number]);
 }
 EXPORT_SYMBOL(iio_unregister_interrupt_line);
-- 
1.7.3.4

