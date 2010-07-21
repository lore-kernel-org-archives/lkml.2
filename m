Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab0GUTOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:14:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58010 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab0GUTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ITM+pK2nikQHXI4lgio6EMa5sOE4p7xvxiK03OQ0GheUIoxfBb8gVzrH5s+E+kNP84
         mJJUefR0kVAuqf6CRtBUuq6AsYSpK5m/XfAVtu5V7go1tnQcZ/PoqZAGCE9PrbBmu8ve
         8znOMI7BI+kQFPLfvLVQ9c9VeGmXCCEni65t8=
Date: Wed, 21 Jul 2010 23:14:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721191433.GA24749@lenovo>
References: <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <4C472123.1090900@zytor.com> <20100721165211.GD8009@lenovo> <20100721170124.GE8009@lenovo> <4C472A5C.50004@zytor.com> <20100721171718.GF8009@lenovo> <20100721172428.GS26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721172428.GS26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 07:24:28PM +0200, Robert Richter wrote:
> On 21.07.10 13:17:18, Cyrill Gorcunov wrote:
> > On Wed, Jul 21, 2010 at 10:11:56AM -0700, H. Peter Anvin wrote:
> > > On 07/21/2010 10:01 AM, Cyrill Gorcunov wrote:
> > > > 
> > > > Peter, also I think such tuning must be done at merge window time only,
> > > > just to not break other's patch queues.
> > > > 
> > > 
> > > Realistically it should be done right after the merge window for the
> > > *next* merge window.
> > > 
> > > 	-hpa
> > >
> > 
> > ok, which means Robert should use old conventional test at the moment
> > instead of introducing is_boot_cpu I suppose.
> 
> Yes, I am just using:
> 
> if (!smp_processor_id())
> 	...
> 
> Cyrill, if you like, I will leave it up to you to introduce the
> is_boot_cpu() macro.
> 
> I still have patch 7/7 in my new posting in that removes the
> boot_cpu_id. If your patch comes soon this will be obsolete as all
> places will have the macro then.
> 
> Thanks,
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 

Robert, Peter, it might be something like the patch
below. I've compile-tested it only. On top of current
-tip with Robert's patch applied. If you find it convenient
we could queue it somewhere and give it a shot. Complains
are welcome. Initially I thought about kepping boot_cpu_id
as macro too (to be consistent with say IA-64) but not sure
so I drop this idea.

	-- Cyrill
---
x86: Introduce is_boot_cpu() helper

This allow us to make clear the code snippets where we
test for cpu being bootstrap one instead of open coded test
with zero.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Robert Richter <robert.richter@amd.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/apb_timer.h |    2 ++
 arch/x86/include/asm/cpu.h       |    1 -
 arch/x86/include/asm/smp.h       |    2 ++
 arch/x86/kernel/apb_timer.c      |    2 +-
 arch/x86/kernel/apic/apic.c      |    6 +++---
 arch/x86/kernel/apic/nmi.c       |    2 +-
 arch/x86/kernel/apm_32.c         |    2 +-
 arch/x86/kernel/cpu/amd.c        |    2 +-
 arch/x86/kernel/cpu/common.c     |    2 +-
 arch/x86/kernel/cpu/intel.c      |    2 +-
 arch/x86/kernel/i387.c           |    2 +-
 arch/x86/kernel/setup_percpu.c   |    2 +-
 arch/x86/kernel/smpboot.c        |    4 ++--
 arch/x86/kernel/traps.c          |    2 +-
 arch/x86/xen/smp.c               |    4 ++--
 arch/x86/xen/suspend.c           |    2 +-
 16 files changed, 21 insertions(+), 18 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apb_timer.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apb_timer.h
+++ linux-2.6.git/arch/x86/include/asm/apb_timer.h
@@ -59,6 +59,8 @@ extern struct sfi_timer_table_entry *sfi
 extern void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr);
 extern int sfi_mtimer_num;
 
+#define is_boot_cpu(cpu)	((cpu) == 0)
+
 #else /* CONFIG_APB_TIMER */
 
 static inline unsigned long apbt_quick_calibrate(void) {return 0; }
Index: linux-2.6.git/arch/x86/include/asm/cpu.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/cpu.h
+++ linux-2.6.git/arch/x86/include/asm/cpu.h
@@ -32,5 +32,4 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-
 #endif /* _ASM_X86_CPU_H */
Index: linux-2.6.git/arch/x86/include/asm/smp.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/smp.h
+++ linux-2.6.git/arch/x86/include/asm/smp.h
@@ -203,5 +203,7 @@ extern int hard_smp_processor_id(void);
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+#define is_boot_cpu(cpu) ((cpu) == 0)
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
Index: linux-2.6.git/arch/x86/kernel/apb_timer.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apb_timer.c
+++ linux-2.6.git/arch/x86/kernel/apb_timer.c
@@ -343,7 +343,7 @@ void apbt_setup_secondary_clock(void)
 
 	/* Don't register boot CPU clockevent */
 	cpu = smp_processor_id();
-	if (!cpu)
+	if (is_boot_cpu(cpu))
 		return;
 	/*
 	 * We need to calculate the scaled math multiplication factor for
Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -1293,7 +1293,7 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && (pic_mode || !value)) {
+	if (is_boot_cpu(smp_processor_id()) && (pic_mode || !value)) {
 		value = APIC_DM_EXTINT;
 		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
 				smp_processor_id());
@@ -1307,7 +1307,7 @@ void __cpuinit setup_local_APIC(void)
 	/*
 	 * only the BP should see the LINT1 NMI signal, obviously.
 	 */
-	if (!smp_processor_id())
+	if (is_boot_cpu(smp_processor_id()))
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
@@ -1319,7 +1319,7 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_MCE_INTEL
 	/* Recheck CMCI information after local APIC is up on CPU #0 */
-	if (smp_processor_id() == 0)
+	if (is_boot_cpu(smp_processor_id()))
 		cmci_recheck();
 #endif
 }
Index: linux-2.6.git/arch/x86/kernel/apic/nmi.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/nmi.c
+++ linux-2.6.git/arch/x86/kernel/apic/nmi.c
@@ -316,7 +316,7 @@ void setup_apic_nmi_watchdog(void *unuse
 
 	/* cheap hack to support suspend/resume */
 	/* if cpu0 is not active neither should the other cpus */
-	if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
+	if (!is_boot_cpu(smp_processor_id()) && atomic_read(&nmi_active) <= 0)
 		return;
 
 	switch (nmi_watchdog) {
Index: linux-2.6.git/arch/x86/kernel/apm_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6.git/arch/x86/kernel/apm_32.c
@@ -1746,7 +1746,7 @@ static int apm(void *unused)
 	 * Method suggested by Ingo Molnar.
 	 */
 	set_cpus_allowed_ptr(current, cpumask_of(0));
-	BUG_ON(smp_processor_id() != 0);
+	BUG_ON(!is_boot_cpu(smp_processor_id());
 
 	if (apm_info.connection_version == 0) {
 		apm_info.connection_version = apm_info.bios.version;
Index: linux-2.6.git/arch/x86/kernel/cpu/amd.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.git/arch/x86/kernel/cpu/amd.c
@@ -148,7 +148,7 @@ static void __cpuinit amd_k7_smp_check(s
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (!c->cpu_index)
+	if (is_boot_cpu(c->cpu_index))
 		return;
 
 	/*
Index: linux-2.6.git/arch/x86/kernel/cpu/common.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6.git/arch/x86/kernel/cpu/common.c
@@ -1273,7 +1273,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (smp_processor_id() == boot_cpu_id)
+	if (is_boot_cpu(smp_processor_id())
 		init_thread_xstate();
 
 	xsave_init();
Index: linux-2.6.git/arch/x86/kernel/cpu/intel.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/intel.c
@@ -169,7 +169,7 @@ static void __cpuinit intel_smp_check(st
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (!c->cpu_index)
+	if (is_boot_cpu(c->cpu_index))
 		return;
 
 	/*
Index: linux-2.6.git/arch/x86/kernel/i387.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/i387.c
+++ linux-2.6.git/arch/x86/kernel/i387.c
@@ -96,7 +96,7 @@ void __cpuinit fpu_init(void)
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (!smp_processor_id())
+	if (is_boot_cpu(smp_processor_id()))
 		init_thread_xstate();
 	xsave_init();
 
Index: linux-2.6.git/arch/x86/kernel/setup_percpu.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.git/arch/x86/kernel/setup_percpu.c
@@ -244,7 +244,7 @@ void __init setup_per_cpu_areas(void)
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
 		 */
-		if (!cpu)
+		if (is_boot_cpu(cpu))
 			switch_to_new_gdt(cpu);
 	}
 
Index: linux-2.6.git/arch/x86/kernel/smpboot.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.git/arch/x86/kernel/smpboot.c
@@ -369,7 +369,7 @@ void __cpuinit smp_store_cpu_info(int id
 
 	copy_cpuinfo_x86(c, &boot_cpu_data);
 	c->cpu_index = id;
-	if (id != 0)
+	if (!is_boot_cpu(id))
 		identify_secondary_cpu(c);
 }
 
@@ -1319,7 +1319,7 @@ int native_cpu_disable(void)
 	 * interrupts only being able to be serviced by the BSP.
 	 * Especially so if we're not using an IOAPIC	-zwane
 	 */
-	if (cpu == 0)
+	if (is_boot_cpu(cpu))
 		return -EBUSY;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
Index: linux-2.6.git/arch/x86/kernel/traps.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps.c
+++ linux-2.6.git/arch/x86/kernel/traps.c
@@ -385,7 +385,7 @@ static notrace __kprobes void default_do
 	cpu = smp_processor_id();
 
 	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
+	if (is_boot_cpu(cpu))
 		reason = get_nmi_reason();
 
 	if (!(reason & 0xc0)) {
Index: linux-2.6.git/arch/x86/xen/smp.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/xen/smp.c
+++ linux-2.6.git/arch/x86/xen/smp.c
@@ -167,7 +167,7 @@ static void __init xen_fill_possible_map
 
 static void __init xen_smp_prepare_boot_cpu(void)
 {
-	BUG_ON(smp_processor_id() != 0);
+	BUG_ON(!is_boot_cpu(smp_processor_id()));
 	native_smp_prepare_boot_cpu();
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
@@ -336,7 +336,7 @@ static void xen_smp_cpus_done(unsigned i
 static int xen_cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
-	if (cpu == 0)
+	if (is_boot_cpu(cpu))
 		return -EBUSY;
 
 	cpu_disable_common();
Index: linux-2.6.git/arch/x86/xen/suspend.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/xen/suspend.c
+++ linux-2.6.git/arch/x86/xen/suspend.c
@@ -52,7 +52,7 @@ static void xen_vcpu_notify_restore(void
 	unsigned long reason = (unsigned long)data;
 
 	/* Boot processor notified via generic timekeeping_resume() */
-	if ( smp_processor_id() == 0)
+	if (is_boot_cpu(smp_processor_id()))
 		return;
 
 	clockevents_notify(reason, NULL);
