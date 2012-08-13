Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2HMUfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:35:55 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48193 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab2HMUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:44 -0400
Date: Mon, 13 Aug 2012 22:23:33 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20120813202304.GA3529@breakpoint.cc>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <20120806073811.GA3261@breakpoint.cc>
 <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The former conversion to irq_domain_add_legacy() did not fully work
since we miss the irq decs for NR_IRQS_LEGACY+.
Ideally we could use irq_domain_add_simple() or the no-map variant (and
program the virq <-> line mapping directly into ioapic) but this would
require a different irq lookup in "do_IRQ()" and won't work with ACPI
without changes. So this is probably easiest for everyone.

Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1..v2: - added tested tag from Thierry
	- moved argument ioapic_irq_domain_ops of irq_domain_add_linear() one
	  line up
	- removed one extra space "remaining" and "irqs"
	- use IRQs and IRQ instead of irq and irqs in printks.
	  
 arch/x86/kernel/devicetree.c |   51 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3ae2ced..8bd7a2e 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -342,6 +342,47 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
 	.xlate = ioapic_xlate,
 };
 
+static void dt_add_ioapic_domain(unsigned int ioapic_num,
+		struct device_node *np)
+{
+	struct irq_domain *id;
+	struct mp_ioapic_gsi *gsi_cfg;
+	int ret;
+	int num;
+
+	gsi_cfg = mp_ioapic_gsi_routing(ioapic_num);
+	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+
+	id = irq_domain_add_linear(np, num, &ioapic_irq_domain_ops,
+			(void *)ioapic_num);
+	BUG_ON(!id);
+	if (gsi_cfg->gsi_base == 0) {
+		/*
+		 * The first NR_IRQS_LEGACY irq descs are allocated in
+		 * early_irq_init() and need just a mapping. The
+		 * remaining irqs need both. All of them are preallocated
+		 * and assigned so we can keep the 1:1 mapping which the ioapic
+		 * is having.
+		 */
+		ret = irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
+		if (ret)
+			pr_err("Error mapping legacy IRQs: %d\n", ret);
+
+		if (num > NR_IRQS_LEGACY) {
+			ret = irq_create_strict_mappings(id, NR_IRQS_LEGACY,
+					NR_IRQS_LEGACY, num - NR_IRQS_LEGACY);
+			if (ret)
+				pr_err("Error creating mapping for the "
+						"remaining IRQs: %d\n", ret);
+		}
+		irq_set_default_host(id);
+	} else {
+		ret = irq_create_strict_mappings(id, gsi_cfg->gsi_base, 0, num);
+		if (ret)
+			pr_err("Error creating IRQ mapping: %d\n", ret);
+	}
+}
+
 static void __init ioapic_add_ofnode(struct device_node *np)
 {
 	struct resource r;
@@ -356,15 +397,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 
 	for (i = 0; i < nr_ioapics; i++) {
 		if (r.start == mpc_ioapic_addr(i)) {
-			struct irq_domain *id;
-			struct mp_ioapic_gsi *gsi_cfg;
-
-			gsi_cfg = mp_ioapic_gsi_routing(i);
-
-			id = irq_domain_add_legacy(np, 32, gsi_cfg->gsi_base, 0,
-						   &ioapic_irq_domain_ops,
-						   (void*)i);
-			BUG_ON(!id);
+			dt_add_ioapic_domain(i, np);
 			return;
 		}
 	}
-- 
1.7.10.4

