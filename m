Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1IUJ3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:29:22 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:49741 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1IUJ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:29:19 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Maulik Mankad <x0082077@ti.com>, Robert Morell <rmorell@nvidia.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 01/57] usb/hcd: Remove tricky code dealing with IRQF_DISABLED && IRQF_SHARED
Date: Wed, 21 Sep 2011 17:28:02 +0800
Message-Id: <1316597339-29861-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, genirq keep irqs disabled when calling the action handler,
we don't need to disable irq by ourselves anymore.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/usb/core/hcd.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index c1dabf0..8d0cd99 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2124,15 +2124,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
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
 	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd))) {
 		rc = IRQ_NONE;
 	} else if (hcd->driver->irq(hcd) == IRQ_NONE) {
@@ -2144,7 +2137,6 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 		rc = IRQ_HANDLED;
 	}
 
-	local_irq_restore(flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_irq);
@@ -2333,13 +2325,6 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 
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
-- 
1.7.4.1

