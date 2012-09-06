Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2IFLbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:31:46 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59693 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2IFLbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:31:42 -0400
X-AuditID: b753bd60-928c4ba0000047ca-1e-504888e25896
X-AuditID: b753bd60-928c4ba0000047ca-1e-504888e25896
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 13/21] x86/apic: IRQ vector remapping on slave for
 slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:27 +0900
Message-ID: <20120906112827.13320.30551.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a facility to use IRQ vector different from online CPUs on slave CPUs.

When alternative vector for IRQ is registered by remap_slave_vector_irq()
and the IRQ affinity is set only to slave CPUs, the device is configured
to use the alternative vector.

Current patch only supports MSI and Intel CPU with IRQ remapper of IOMMU.

This is intended to be used to routing interrupts directly to KVM guest
which is running on slave CPUs which do not cause VM EXIT by external
interrupts.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/irq.h          |   15 ++++++++
 arch/x86/kernel/apic/io_apic.c      |   68 ++++++++++++++++++++++++++++++++++-
 drivers/iommu/intel_irq_remapping.c |    2 +
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..84756f7 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -41,4 +41,19 @@ extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
 
+#ifdef CONFIG_SLAVE_CPU
+extern void remap_slave_vector_irq(int irq, int vector,
+				   const struct cpumask *mask);
+extern void revert_slave_vector_irq(int irq, const struct cpumask *mask);
+extern u8 get_remapped_slave_vector(u8 vector, unsigned int irq,
+				    const struct cpumask *mask);
+#else
+static inline u8 get_remapped_slave_vector(u8 vector, unsigned int irq,
+					   const struct cpumask *mask)
+{
+	return vector;
+}
+#endif
+
+
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0cd2682..167b001 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1266,6 +1266,69 @@ void __setup_vector_irq(int cpu)
 	raw_spin_unlock(&vector_lock);
 }
 
+#ifdef CONFIG_SLAVE_CPU
+
+/* vector table remapped on slave cpus, indexed by IRQ */
+static DEFINE_PER_CPU(u8[NR_IRQS], slave_vector_remap_tbl) = {
+	[0 ... NR_IRQS - 1] = 0,
+};
+
+void remap_slave_vector_irq(int irq, int vector, const struct cpumask *mask)
+{
+	int cpu;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	for_each_cpu(cpu, mask) {
+		BUG_ON(!cpu_slave(cpu));
+		per_cpu(slave_vector_remap_tbl, cpu)[irq] = vector;
+		per_cpu(vector_irq, cpu)[vector] = irq;
+	}
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+}
+EXPORT_SYMBOL_GPL(remap_slave_vector_irq);
+
+void revert_slave_vector_irq(int irq, const struct cpumask *mask)
+{
+	int cpu;
+	u8 vector;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	for_each_cpu(cpu, mask) {
+		BUG_ON(!cpu_slave(cpu));
+		vector = per_cpu(slave_vector_remap_tbl, cpu)[irq];
+		if (vector) {
+			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(slave_vector_remap_tbl, cpu)[irq] = 0;
+		}
+	}
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+}
+EXPORT_SYMBOL_GPL(revert_slave_vector_irq);
+
+/* If all targets CPUs are slave, returns remapped vector */
+u8 get_remapped_slave_vector(u8 vector, unsigned int irq,
+			     const struct cpumask *mask)
+{
+	u8 slave_vector;
+
+	if (vector < FIRST_EXTERNAL_VECTOR ||
+	    cpumask_intersects(mask, cpu_online_mask))
+		return vector;
+
+	slave_vector = per_cpu(slave_vector_remap_tbl,
+			       cpumask_first(mask))[irq];
+	if (slave_vector >= FIRST_EXTERNAL_VECTOR)
+		vector = slave_vector;
+
+	pr_info("slave vector remap: irq: %d => vector: %d\n", irq, vector);
+
+	return vector;
+}
+
+#endif
+
 static struct irq_chip ioapic_chip;
 
 #ifdef CONFIG_X86_32
@@ -3133,6 +3196,7 @@ static int
 msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
 	struct irq_cfg *cfg = data->chip_data;
+	int vector = cfg->vector;
 	struct msi_msg msg;
 	unsigned int dest;
 
@@ -3141,8 +3205,10 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	__get_cached_msi_msg(data->msi_desc, &msg);
 
+	vector = get_remapped_slave_vector(vector, data->irq, mask);
+
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.data |= MSI_DATA_VECTOR(vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index df38334..471d23f 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -970,7 +970,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		goto error;
 	}
 
-	irte.vector = cfg->vector;
+	irte.vector = get_remapped_slave_vector(cfg->vector, irq, mask);
 	irte.dest_id = IRTE_DEST(dest);
 
 	/*


