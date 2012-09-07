Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2IGAXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:23:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:51889 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab2IGAXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:23:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,382,1344236400"; 
   d="scan'208";a="189863987"
Subject: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 17:19:59 +0800
Message-ID: <1347009599.1119.9.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the IRQF_DISABLED as the flag is now a NOOP and has been
deprecated and in hardirq context the interrupt is disabled.

so in usb/host code:
Removing the usage of flag IRQF_DISABLED;
Removing the calling local_irq save/restore actions in irq
handler usb_hcd_irq();

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hcd.c       |   15 ---------------
 drivers/usb/host/ehci-ls1x.c |    2 +-
 drivers/usb/host/ohci-xls.c  |    2 +-
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bc84106..f84ddea 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2153,15 +2153,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
 	struct usb_hcd		*hcd = __hcd;
-	unsigned long		flags;
 	irqreturn_t		rc;
 
-	/* IRQF_DISABLED doesn't work correctly with shared IRQs
-	 * when the first handler doesn't use it.  So let's just
-	 * assume it's never used.
-	 */
-	local_irq_save(flags);
-
 	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
 		rc = IRQ_NONE;
 	else if (hcd->driver->irq(hcd) == IRQ_NONE)
@@ -2169,7 +2162,6 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	else
 		rc = IRQ_HANDLED;
 
-	local_irq_restore(flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_irq);
@@ -2358,13 +2350,6 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 
 	if (hcd->driver->irq) {
 
-		/* IRQF_DISABLED doesn't work as advertised when used together
-		 * with IRQF_SHARED. As usb_hcd_irq() will always disable
-		 * interrupts we can remove it here.
-		 */
-		if (irqflags & IRQF_SHARED)
-			irqflags &= ~IRQF_DISABLED;
-
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);
 		retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
diff --git a/drivers/usb/host/ehci-ls1x.c b/drivers/usb/host/ehci-ls1x.c
index a283e59..425cb4a 100644
--- a/drivers/usb/host/ehci-ls1x.c
+++ b/drivers/usb/host/ehci-ls1x.c
@@ -119,7 +119,7 @@ static int ehci_hcd_ls1x_probe(struct platform_device *pdev)
 		goto err_release_region;
 	}
 
-	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto err_iounmap;
 
diff --git a/drivers/usb/host/ohci-xls.c b/drivers/usb/host/ohci-xls.c
index 41e378f..84201cd 100644
--- a/drivers/usb/host/ohci-xls.c
+++ b/drivers/usb/host/ohci-xls.c
@@ -56,7 +56,7 @@ static int ohci_xls_probe_internal(const struct hc_driver *driver,
 		goto err3;
 	}
 
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval != 0)
 		goto err4;
 	return retval;
-- 
1.7.0.4



