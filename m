Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2BXDuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:50:08 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37394 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2BXDt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:57 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 01/13] x86, irq: Convert irq_2_pin list to generic list
Date: Thu, 23 Feb 2012 19:48:47 -0800
Message-Id: <1330055339-11662-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F4708C3.0039,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can use generic list helper function.

Also make free_irq_cfg() free irq_2_pin list.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/hw_irq.h  |    2 +-
 arch/x86/kernel/apic/io_apic.c |   22 ++++++++++++----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..7c2c92a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -114,7 +114,7 @@ struct irq_2_iommu {
  * Most irqs are mapped 1:1 with pins.
  */
 struct irq_cfg {
-	struct irq_pin_list	*irq_2_pin;
+	struct list_head	irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
 	u8			vector;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..4c008ac 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -65,7 +65,7 @@
 
 #define __apicdebuginit(type) static type __init
 #define for_each_irq_pin(entry, head) \
-	for (entry = head; entry; entry = entry->next)
+	list_for_each_entry(entry, &head, list)
 
 /*
  *      Is the SiS APIC rmw bug present ?
@@ -175,8 +175,8 @@ void mp_save_irq(struct mpc_intsrc *m)
 }
 
 struct irq_pin_list {
+	struct list_head list;
 	int apic, pin;
-	struct irq_pin_list *next;
 };
 
 static struct irq_pin_list *alloc_irq_pin_list(int node)
@@ -212,6 +212,7 @@ int __init arch_early_irq_init(void)
 	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
 
 	for (i = 0; i < count; i++) {
+		INIT_LIST_HEAD(&cfg[i].irq_2_pin);
 		irq_set_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
@@ -244,6 +245,7 @@ static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
 		goto out_cfg;
 	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
 		goto out_domain;
+	INIT_LIST_HEAD(&cfg->irq_2_pin);
 	return cfg;
 out_domain:
 	free_cpumask_var(cfg->domain);
@@ -254,11 +256,15 @@ out_cfg:
 
 static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
 {
+	struct irq_pin_list *entry, *tmp;
+
 	if (!cfg)
 		return;
 	irq_set_chip_data(at, NULL);
 	free_cpumask_var(cfg->domain);
 	free_cpumask_var(cfg->old_domain);
+	list_for_each_entry_safe(entry, tmp, &cfg->irq_2_pin, list)
+		kfree(entry);
 	kfree(cfg);
 }
 
@@ -438,15 +444,12 @@ static void ioapic_mask_entry(int apic, int pin)
 static int
 __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	struct irq_pin_list **last, *entry;
+	struct irq_pin_list *entry;
 
 	/* don't allow duplicates */
-	last = &cfg->irq_2_pin;
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
+	for_each_irq_pin(entry, cfg->irq_2_pin)
 		if (entry->apic == apic && entry->pin == pin)
 			return 0;
-		last = &entry->next;
-	}
 
 	entry = alloc_irq_pin_list(node);
 	if (!entry) {
@@ -457,7 +460,7 @@ __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 	entry->apic = apic;
 	entry->pin = pin;
 
-	*last = entry;
+	list_add_tail(&entry->list, &cfg->irq_2_pin);
 	return 0;
 }
 
@@ -1722,8 +1725,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
-		entry = cfg->irq_2_pin;
-		if (!entry)
+		if (list_empty(&cfg->irq_2_pin))
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
 		for_each_irq_pin(entry, cfg->irq_2_pin)
-- 
1.7.7

