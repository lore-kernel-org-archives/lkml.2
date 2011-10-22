Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1JVJ5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:57:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1JVJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:57:39 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Subject: [PATCH 01/49] usb/hcd: Remove tricky code dealing with IRQF_DISABLED && IRQF_SHARED
Date: Sat, 22 Oct 2011 17:56:13 +0800
Message-Id: <1319277421-9203-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
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
index c9eb4e5..e98f605 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2125,15 +2125,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
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
@@ -2145,7 +2138,6 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 		rc = IRQ_HANDLED;
 	}
 
-	local_irq_restore(flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_irq);
@@ -2334,13 +2326,6 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 
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
1.7.1

