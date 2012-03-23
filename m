Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2CWTqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:46:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab2CWTqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:46:35 -0400
Date: Fri, 23 Mar 2012 12:46:25 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-4da7072ad6831a35a11341097ce477e18651bedd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20120320141935.GA24806@dhcp-26-207.brq.redhat.com>
References: <20120320141935.GA24806@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/io_apic:
  Move and reenable irq only when CONFIG_GENERIC_PENDING_IRQ=y
Git-Commit-ID: 4da7072ad6831a35a11341097ce477e18651bedd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 12:46:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4da7072ad6831a35a11341097ce477e18651bedd
Gitweb:     http://git.kernel.org/tip/4da7072ad6831a35a11341097ce477e18651bedd
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Tue, 20 Mar 2012 15:19:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 23 Mar 2012 13:47:25 +0100

x86/io_apic: Move and reenable irq only when CONFIG_GENERIC_PENDING_IRQ=y

This patch removes dead code from certain .config variations.

When CONFIG_GENERIC_PENDING_IRQ=n irq move and reenable code is
never get executed, nor do_unmask_irq variable updates its init
value. Move the code under CONFIG_GENERIC_PENDING_IRQ macro.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20120320141935.GA24806@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |  101 ++++++++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d10a66..2c428c5 100644
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
