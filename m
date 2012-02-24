Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2BXDun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:50:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21288 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2BXDts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 03/13] x86, irq: Add realloc_irq_and_cfg_at()
Date: Thu, 23 Feb 2012 19:48:49 -0800
Message-Id: <1330055339-11662-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F4708C4.004E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use it to allocate irq that are pre-reserved.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   33 ++++++++++++++++++++++++++++++++-
 include/linux/irq.h            |    5 +++++
 kernel/irq/irqdesc.c           |   26 ++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4c008ac..4d62f0f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -300,6 +300,37 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
+static struct irq_cfg *realloc_irq_and_cfg_at(unsigned int at, int node)
+{
+	struct irq_desc *desc = irq_to_desc(at);
+	struct irq_cfg *cfg;
+	int res;
+
+	if (desc) {
+		if (irq_desc_get_irq_data(desc)->node == node)
+			return alloc_irq_and_cfg_at(at, node);
+
+		cfg = irq_desc_get_chip_data(desc);
+		if (cfg) {
+			/* shared irq */
+			if (!list_empty(&cfg->irq_2_pin))
+				return cfg;
+			free_irq_cfg(at, cfg);
+		}
+	}
+
+	res = irq_realloc_desc_at(at, node);
+	if (res >= 0) {
+		cfg = alloc_irq_cfg(at, node);
+		if (cfg) {
+			irq_set_chip_data(at, cfg);
+			return cfg;
+		}
+	}
+
+	return alloc_irq_and_cfg_at(at, node);
+}
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -3563,7 +3594,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 static int
 io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 {
-	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
+	struct irq_cfg *cfg = realloc_irq_and_cfg_at(irq, node);
 	int ret;
 
 	if (!cfg)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7a9a19b..e15bc35 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -584,6 +584,11 @@ void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 int __irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt);
 
+int __irq_realloc_desc(int at, int node, struct module *owner);
+/* use macros to avoid needing export.h for THIS_MODULE */
+#define irq_realloc_desc_at(at, node)	\
+	__irq_realloc_desc(at, node, THIS_MODULE)
+
 static inline void irq_free_desc(unsigned int irq)
 {
 	irq_free_descs(irq, 1);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 3e23bb9..b1d6e51 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -99,6 +99,11 @@ EXPORT_SYMBOL_GPL(nr_irqs);
 static DEFINE_MUTEX(sparse_irq_lock);
 static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);
 
+static bool __irq_is_reserved(int irq)
+{
+	return !!test_bit(irq, allocated_irqs);
+}
+
 #ifdef CONFIG_SPARSE_IRQ
 
 static RADIX_TREE(irq_desc_tree, GFP_KERNEL);
@@ -400,6 +405,27 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
+ * irq_realloc_desc - allocate irq descriptor for irq that is already reserved
+ * @irq:	Allocate for specific irq number if irq >= 0
+ * @node:	Preferred node on which the irq descriptor should be allocated
+ * @owner:	Owning module (can be NULL)
+ *
+ * Returns the irq number or error code
+ */
+int __ref
+__irq_realloc_desc(int irq, int node, struct module *owner)
+{
+	if (!__irq_is_reserved(irq))
+		return -EINVAL;
+
+	if (irq_to_desc(irq))
+		free_desc(irq);
+
+	return alloc_descs(irq, 1, node, owner);
+}
+EXPORT_SYMBOL_GPL(__irq_realloc_desc);
+
+/**
  * irq_reserve_irqs - mark irqs allocated
  * @from:	mark from irq number
  * @cnt:	number of irqs to mark
-- 
1.7.7

