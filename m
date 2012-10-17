Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab2JQBMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:12:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:56855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab2JQBM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="234806125"
Subject: [PATCH] x86/ioapic: fix the irq_2_pin mem leak when destroy_irq
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, suresh.b.siddha@intel.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 18:11:46 +0800
Message-ID: <1350468706.15558.26.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When destroying the irq, before free cfg, need to check
cfg->irq_2_pin and free it when it is not NULL.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..a976ee3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -201,6 +201,15 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
+static void free_irq_pin_list(struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry, *next;
+
+	for (entry = cfg->irq_2_pin; entry; entry = next) {
+		next = entry->next;
+		kfree(entry);
+	}
+}
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
@@ -276,6 +285,7 @@ static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
 	irq_set_chip_data(at, NULL);
 	free_cpumask_var(cfg->domain);
 	free_cpumask_var(cfg->old_domain);
+	free_irq_pin_list(cfg);
 	kfree(cfg);
 }
 
-- 
1.7.0.4



