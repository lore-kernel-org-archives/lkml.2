Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab2CTOT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab2CTOTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:19:55 -0400
Date: Tue, 20 Mar 2012 15:19:36 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2] x86: io_apic: Move and reenable irq only when
 CONFIG_GENERIC_PENDING_IRQ=y
Message-ID: <20120320141935.GA24806@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_GENERIC_PENDING_IRQ=n irq move and reenable code is never
get executed, nor do_unmask_irq variable updates its init value. Move
the code under CONFIG_GENERIC_PENDING_IRQ macro.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |  101 ++++++++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..8cd6360 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2512,21 +2512,73 @@ static void ack_apic_edge(struct irq_data *data)
 
 atomic_t irq_mis_count;
 
-static void ack_apic_level(struct irq_data *data)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	int i, do_unmask_irq = 0, irq = data->irq;
-	unsigned long v;
-
-	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
+static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
+{
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		do_unmask_irq = 1;
 		mask_ioapic(cfg);
+		return true;
 	}
+	return false;
+}
+
+static inline void ioapic_irqd_unmask(struct irq_data *data,
+				      struct irq_cfg *cfg, bool masked)
+{
+	if (unlikely(masked)) {
+		/* Only migrate the irq if the ack has been received.
+		 *
+		 * On rare occasions the broadcast level triggered ack gets
+		 * delayed going to ioapics, and if we reprogram the
+		 * vector while Remote IRR is still set the irq will never
+		 * fire again.
+		 *
+		 * To prevent this scenario we read the Remote IRR bit
+		 * of the ioapic.  This has two effects.
+		 * - On any sane system the read of the ioapic will
+		 *   flush writes (and acks) going to the ioapic from
+		 *   this cpu.
+		 * - We get to see if the ACK has actually been delivered.
+		 *
+		 * Based on failed experiments of reprogramming the
+		 * ioapic entry from outside of irq context starting
+		 * with masking the ioapic entry and then polling until
+		 * Remote IRR was clear before reprogramming the
+		 * ioapic I don't trust the Remote IRR bit to be
+		 * completey accurate.
+		 *
+		 * However there appears to be no other way to plug
+		 * this race, so if the Remote IRR bit is not
+		 * accurate and is causing problems then it is a hardware bug
+		 * and you can go talk to the chipset vendor about it.
+		 */
+		if (!io_apic_level_ack_pending(cfg))
+			irq_move_masked_irq(data);
+		unmask_ioapic(cfg);
+	}
+}
+#else
+static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
+{
+	return false;
+}
+static inline void ioapic_irqd_unmask(struct irq_data *data,
+				      struct irq_cfg *cfg, bool masked)
+{
+}
 #endif
 
+static void ack_apic_level(struct irq_data *data)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	int i, irq = data->irq;
+	unsigned long v;
+	bool masked;
+
+	irq_complete_move(cfg);
+	masked = ioapic_irqd_mask(data, cfg);
+
 	/*
 	 * It appears there is an erratum which affects at least version 0x11
 	 * of I/O APIC (that's the 82093AA and cores integrated into various
@@ -2581,38 +2633,7 @@ static void ack_apic_level(struct irq_data *data)
 		eoi_ioapic_irq(irq, cfg);
 	}
 
-	/* Now we can move and renable the irq */
-	if (unlikely(do_unmask_irq)) {
-		/* Only migrate the irq if the ack has been received.
-		 *
-		 * On rare occasions the broadcast level triggered ack gets
-		 * delayed going to ioapics, and if we reprogram the
-		 * vector while Remote IRR is still set the irq will never
-		 * fire again.
-		 *
-		 * To prevent this scenario we read the Remote IRR bit
-		 * of the ioapic.  This has two effects.
-		 * - On any sane system the read of the ioapic will
-		 *   flush writes (and acks) going to the ioapic from
-		 *   this cpu.
-		 * - We get to see if the ACK has actually been delivered.
-		 *
-		 * Based on failed experiments of reprogramming the
-		 * ioapic entry from outside of irq context starting
-		 * with masking the ioapic entry and then polling until
-		 * Remote IRR was clear before reprogramming the
-		 * ioapic I don't trust the Remote IRR bit to be
-		 * completey accurate.
-		 *
-		 * However there appears to be no other way to plug
-		 * this race, so if the Remote IRR bit is not
-		 * accurate and is causing problems then it is a hardware bug
-		 * and you can go talk to the chipset vendor about it.
-		 */
-		if (!io_apic_level_ack_pending(cfg))
-			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
-	}
+	ioapic_irqd_unmask(data, cfg, masked);
 }
 
 #ifdef CONFIG_IRQ_REMAP
-- 
1.7.7.6

