Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2HUU0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:26:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2HUU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:26:14 -0400
Date: Tue, 21 Aug 2012 13:25:34 -0700
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <tip-ece3234a77ebcd5bbeea6b829c9798328d290cae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, sebastian@breakpoint.cc,
        bigeasy@linutronix.de, thierry.reding@avionic-design.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        sebastian@breakpoint.cc, tglx@linutronix.de,
        thierry.reding@avionic-design.de
In-Reply-To: <20120813202304.GA3529@breakpoint.cc>
References: <20120813202304.GA3529@breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: dt: Use linear irq domain for ioapic(s)
Git-Commit-ID: ece3234a77ebcd5bbeea6b829c9798328d290cae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 13:25:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ece3234a77ebcd5bbeea6b829c9798328d290cae
Gitweb:     http://git.kernel.org/tip/ece3234a77ebcd5bbeea6b829c9798328d290cae
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Mon, 13 Aug 2012 22:23:33 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 21 Aug 2012 22:16:57 +0200

x86: dt: Use linear irq domain for ioapic(s)

The former conversion to irq_domain_add_legacy() did not fully work
since we miss the irq decs for NR_IRQS_LEGACY+.

Ideally we could use irq_domain_add_simple() or the no-map variant (and
program the virq <-> line mapping directly into ioapic) but this would
require a different irq lookup in "do_IRQ()" and won't work with ACPI
without changes. So this is probably easiest for everyone.

Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Link: http://lkml.kernel.org/r/20120813202304.GA3529@breakpoint.cc
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/devicetree.c |   51 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3ae2ced..b158152 100644
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
