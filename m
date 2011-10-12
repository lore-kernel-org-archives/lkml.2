Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1JLSyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:54:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30925 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1JLSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:53:59 -0400
Message-ID: <4E95E21D.6090200@oracle.com>
Date: Wed, 12 Oct 2011 11:53:17 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, irq: Only support sparseirq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090204.4E95E232.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sparseirq is introduced from 2.6.28 and Thomas did huge cleanup around 2.6.38.

We could remove non sparseirq support now.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/irq_vectors.h |   12 ++----------
 arch/x86/kernel/apic/io_apic.c     |   23 -----------------------
 3 files changed, 3 insertions(+), 33 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -64,6 +64,7 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -160,19 +160,11 @@ static inline int invalid_vm86_irq(int i
 #define IO_APIC_VECTOR_LIMIT		( 32 * MAX_IO_APICS )
 
 #ifdef CONFIG_X86_IO_APIC
-# ifdef CONFIG_SPARSE_IRQ
-#  define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
-#  define NR_IRQS					\
+# define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
+# define NR_IRQS					\
 	(CPU_VECTOR_LIMIT > IO_APIC_VECTOR_LIMIT ?	\
 		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
 		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
-# else
-#  define CPU_VECTOR_LIMIT		(32 * NR_CPUS)
-#  define NR_IRQS					\
-	(CPU_VECTOR_LIMIT < IO_APIC_VECTOR_LIMIT ?	\
-		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
-		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
-# endif
 #else /* !CONFIG_X86_IO_APIC: */
 # define NR_IRQS			NR_IRQS_LEGACY
 #endif
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -186,11 +186,7 @@ static struct irq_pin_list *alloc_irq_pi
 
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-#ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
-#else
-static struct irq_cfg irq_cfgx[NR_IRQS];
-#endif
 
 int __init arch_early_irq_init(void)
 {
@@ -234,7 +230,6 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
@@ -269,22 +264,6 @@ static void free_irq_cfg(unsigned int at
 	kfree(cfg);
 }
 
-#else
-
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
-}
-
-static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
-{
-	return irq_cfgx + irq;
-}
-
-static inline void free_irq_cfg(unsigned int at, struct irq_cfg *cfg) { }
-
-#endif
-
 static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 {
 	int res = irq_alloc_desc_at(at, node);
@@ -3636,7 +3615,6 @@ int get_nr_irqs_gsi(void)
 	return nr_irqs_gsi;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 int __init arch_probe_nr_irqs(void)
 {
 	int nr;
@@ -3656,7 +3634,6 @@ int __init arch_probe_nr_irqs(void)
 
 	return NR_IRQS_LEGACY;
 }
-#endif
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
 			    struct io_apic_irq_attr *irq_attr)
