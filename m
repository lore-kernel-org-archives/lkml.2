Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1CLKTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 05:19:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:38046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab1CLKTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 05:19:30 -0500
Date: Sat, 12 Mar 2011 10:18:49 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        adharmap@codeaurora.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adharmap@codeaurora.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.1103112112310.2787@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103112112310.2787@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add chip flag to force mask on suspend
Message-ID: <tip-d209a699a0b975ad47f399d70ddc3791f1b84496@git.kernel.org>
Git-Commit-ID: d209a699a0b975ad47f399d70ddc3791f1b84496
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Mar 2011 10:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d209a699a0b975ad47f399d70ddc3791f1b84496
Gitweb:     http://git.kernel.org/tip/d209a699a0b975ad47f399d70ddc3791f1b84496
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 11 Mar 2011 21:22:14 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 12 Mar 2011 11:12:58 +0100

genirq: Add chip flag to force mask on suspend

On suspend we disable all interrupts in the core code, but this does
not mask the interrupt line in the default implementation as we use a
lazy disable approach. That means we mark the interrupt disabled, but
leave the hardware unmasked. That's an optimization because we avoid
the hardware access for the common case where no interrupt happens
after we marked it disabled. If an interrupt happens, then the
interrupt flow handler masks the line at the hardware level and marks
it pending.

Suspend makes use of this delayed disable as it "disables" all
interrupts when preparing the suspend transition. Right before the
system goes into hardware suspend state it checks whether one of the
interrupts which is marked as a wakeup interrupt came in after
disabling it.

Most interrupt chips have a separate register which selects the
interrupts which can wake up the system from suspend, so we don't have
to mask any on the non wakeup interrupts.

But now we have to deal with brilliant designed hardware which lacks
such a wakeup configuration facility. For such hardware it's necessary
to mask all non wakeup interrupts before going into suspend in order
to avoid the wakeup from random interrupts.

Rather than working around this in the affected interrupt chip
implementations we can solve this elegant in the core code itself.

Add a flag IRQCHIP_MASK_ON_SUSPEND which can be set by the irq chip
implementation to indicate, that the interrupts which are not selected
as wakeup sources must be masked in the suspend path. Mask them in the
loop which checks the wakeup interrupts pending flag.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
LKML-Reference: <alpine.LFD.2.00.1103112112310.2787@localhost6.localdomain6>

---
 include/linux/irq.h |    2 ++
 kernel/irq/pm.c     |   22 ++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index ff62d01..1d3577f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -330,10 +330,12 @@ struct irq_chip {
  *
  * IRQCHIP_SET_TYPE_MASKED:	Mask before calling chip.irq_set_type()
  * IRQCHIP_EOI_IF_HANDLED:	Only issue irq_eoi() when irq was handled
+ * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
 	IRQCHIP_EOI_IF_HANDLED		= (1 <<  1),
+	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 1329f0e..f76fc00 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -68,10 +68,24 @@ int check_wakeup_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
-	for_each_irq_desc(irq, desc)
-		if (irqd_is_wakeup_set(&desc->irq_data) &&
-		    (desc->istate & IRQS_PENDING))
-			return -EBUSY;
+	for_each_irq_desc(irq, desc) {
+		if (irqd_is_wakeup_set(&desc->irq_data)) {
+			if (desc->istate & IRQS_PENDING)
+				return -EBUSY;
+			continue;
+		}
+		/*
+		 * Check the non wakeup interrupts whether they need
+		 * to be masked before finally going into suspend
+		 * state. That's for hardware which has no wakeup
+		 * source configuration facility. The chip
+		 * implementation indicates that with
+		 * IRQCHIP_MASK_ON_SUSPEND.
+		 */
+		if (desc->istate & IRQS_SUSPENDED &&
+		    irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
+			mask_irq(desc);
+	}
 
 	return 0;
 }
