Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab2HWKlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:41:49 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:33417 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933842Ab2HWKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:43 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 13/23] serial: omap: don't save IRQ flags on hardirq
Date: Thu, 23 Aug 2012 13:32:53 +0300
Message-Id: <1345717983-18179-14-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're running our hardirq handler, there's
not need to disable IRQs with spin_lock_irqsave()
because IRQs are already disabled. It also makes
no difference if we save or not IRQ flags.

Switch over to simple spin_lock/spin_unlock and
drop the "flags" variable.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 2df725b..8a60212 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -350,11 +350,10 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	struct tty_struct *tty = up->port.state->port.tty;
 	unsigned int iir, lsr;
 	unsigned int type;
-	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 	int max_count = 256;
 
-	spin_lock_irqsave(&up->port.lock, flags);
+	spin_lock(&up->port.lock);
 	pm_runtime_get_sync(up->dev);
 
 	do {
@@ -393,7 +392,7 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 		}
 	} while (!(iir & UART_IIR_NO_INT) && max_count--);
 
-	spin_unlock_irqrestore(&up->port.lock, flags);
+	spin_unlock(&up->port.lock);
 
 	tty_flip_buffer_push(tty);
 
-- 
1.7.12.rc3

