Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446Ab0CPF5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:57:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:63536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935167Ab0CPF5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,648,1262592000"; 
   d="scan'208";a="500945808"
Subject: Re: [patch] x86: handle legacy PIC interrupts on all the cpu's
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100316053717.GA10765@elte.hu>
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
	 <4B9EABE8.1020203@kernel.org>
	 <1268693771.3296.49.camel@sbs-t61.sc.intel.com>
	 <4B9EB185.3010400@kernel.org>  <20100316053717.GA10765@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 15 Mar 2010 22:54:26 -0800
Message-Id: <1268722471.2948.3.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 22:37 -0700, Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > On 03/15/2010 03:56 PM, Suresh Siddha wrote:
> > > On Mon, 2010-03-15 at 14:51 -0700, Yinghai Lu wrote:
> > >>> +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> > >>> +		if (!IO_APIC_IRQ(irq))
> > >>> +			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> > >>
> > >> seems those three lines are not needed...
> > > 
> > > Those are needed for !CONFIG_X86_IO_APIC case.
> > > 
> > then we can have
> > 
> > +#ifndef CONFIG_X86_IO_APIC
> > +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> > +		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> > +#endif
> > 
> > then we don't punish most setup with ioapic controller.
> 
> Ok - i've simplified the code with the above and have added your Acked-by - is 
> that is fine by you?

Ingo, Probably appended one is a better version. Yinghai can you please
Ack if it is ok. Thanks.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: handle legacy PIC interrupts on all the cpu's

Ingo Molnar reported that with the recent changes of not statically blocking
IRQ0_VECTOR..IRQ15_VECTOR's on all the cpu's, broke an AMD platform
(with Nvidia chipset) boot when "noapic" boot option is used.

On this platform, legacy PIC interrupts are getting delivered to all the
cpu's instead of just the boot cpu. Thus not initializing the vector to irq
mapping for the legacy irq's resulted in not handling certain interrupts
causing boot hang.

Fix this by initializing the vector to irq mapping on all the logical cpu's,
if the legacy IRQ is handled by the legacy PIC.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

 arch/x86/include/asm/hw_irq.h  |    3 +--
 arch/x86/kernel/apic/io_apic.c |    9 +++++++++
 arch/x86/kernel/irqinit.c      |   20 ++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a929c9e..564a7a1 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -133,15 +133,14 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
+extern void __setup_vector_irq(int cpu);
 
 #ifdef CONFIG_X86_IO_APIC
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
-extern void __setup_vector_irq(int cpu);
 #else
 static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
-static inline void __setup_vector_irq(int cpu) {}
 #endif
 
 #endif /* !ASSEMBLY_ */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4e0ddc..fd3cecd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1268,6 +1268,15 @@ void __setup_vector_irq(int cpu)
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
+
+		/*
+		 * If it is a legacy IRQ handled by the legacy PIC, be ready
+		 * to handle it on any CPU, as the PIC interrupts are delivered
+		 * to multiple cpu's on some platforms.
+		 */
+		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
+			cpumask_set_cpu(cpu, cfg->domain);
+
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index ef257fc..afc3b31 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -141,6 +141,26 @@ void __init init_IRQ(void)
 	x86_init.irqs.intr_init();
 }
 
+#ifndef CONFIG_X86_IO_APIC
+/*
+ * Setup the vector to irq mappings.
+ */
+void __setup_vector_irq(int cpu)
+{
+	int irq;
+
+	/*
+	 * On most of the platforms, legacy PIC delivers the interrupts on the
+	 * boot cpu. But there are certain platforms where PIC interrupts are
+	 * delivered to multiple cpu's. For the new cpu that is coming online,
+	 * setup the static legacy vector to irq mapping.
+	 */
+	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
+		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
+
+}
+#endif
+
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP


