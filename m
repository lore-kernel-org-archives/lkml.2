Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1LTGwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:52:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:29241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1LTGvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:51:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104097803"
Subject: Re: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or
 intr-remap can not be enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
References: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Mon, 19 Dec 2011 22:51:22 -0800
Message-ID: <1324363882.2286.23.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai, Here is the detailed review of your patch:

On Fri, 2011-12-16 at 16:59 -0800, Yinghai Lu wrote:
> Index: linux-2.6/arch/x86/include/asm/apic.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/apic.h
> +++ linux-2.6/arch/x86/include/asm/apic.h
> @@ -176,6 +176,8 @@ static inline u64 native_x2apic_icr_read
>  }
>  
>  extern int x2apic_phys;
> +extern int x2apic_preenabled;
> +extern int x2apic_disabled;
>  extern void check_x2apic(void);
>  extern void enable_x2apic(void);
>  extern void x2apic_icr_write(u32 low, u32 id);
> @@ -183,7 +185,7 @@ static inline int x2apic_enabled(void)
>  {
>  	u64 msr;
>  
> -	if (!cpu_has_x2apic)
> +	if (!cpu_has_x2apic || x2apic_disabled)
>  		return 0;
>  
>  	rdmsrl(MSR_IA32_APICBASE, msr);

Not sure why we need x2apic_disabled check here.

> @@ -192,12 +194,15 @@ static inline int x2apic_enabled(void)
>  	return 0;
>  }
>  
> -#define x2apic_supported()	(cpu_has_x2apic)
> +#define x2apic_supported()	(cpu_has_x2apic && !x2apic_disabled)

Here also not sure why we need this. Right thing is to clear the x2apic
capability from the cpuid features when the user selects nox2apic. 

> @@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_h
>  	 * to not preallocating memory for all NR_CPUS
>  	 * when we use CPU hotplug.
>  	 */
> -	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
> -			    processor->lapic_flags & ACPI_MADT_ENABLED);
> +	if (x2apic_disabled && (apic_id >= 0xff) && enabled)
> +		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");

x2apic MADT entries are specifically for apic-id's >= 255. So no need to
check for the value again. We can ignore all the x2apic entries. Also
print once indicating why all x2apic entries are being ignored should be
enough.

Also when we disable x2apic in the case not initiated by the user (like
no dmar tables etc), we would have already parsed the MADT entries but
we need to skip those entries with id >= 255 duing smp boot. I don't
think I see that code in this patch.


>  static __init int setup_nox2apic(char *str)
>  {
> -	if (x2apic_enabled()) {
> -		pr_warning("Bios already enabled x2apic, "
> -			   "can't enforce nox2apic");
> -		return 0;
> -	}
> +	if (x2apic_enabled())
> +		pr_warning("Bios already enabled x2apic, will disable it");
> +
> +	x2apic_disabled = 1;
>  
> -	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
>  	return 0;
>  }

Not sure why you removed this clear_cpu_cap here. Right thing to do here
is to delay the clearing when x2apic is pre-enabled by the bios and
clear it here when x2apic is not pre-enabled by the bios.

> +
> +static void disable_x2apic(void)
> +{
> +	int msr, msr2;
> +
> +	if (!cpu_has_x2apic)
> +		return;
> +
> +	rdmsr(MSR_IA32_APICBASE, msr, msr2);
> +	if (msr & X2APIC_ENABLE) {
> +		u32 x2apic_id = x2apic_cpuid_initial_apicid();

I think we should be able to do read_apic_id() here and thus avoid the
need for getting apicid from cpuid.

> +
> +		if (x2apic_id > 255)
> +			panic("Can not disable x2apic, id: %08x\n", x2apic_id);
> +
> +		pr_info("Disabling x2apic\n");
> +		/*
> +		 * Need to disable xapic and x2apic at the same time at first
> +		 *  then enable xapic
> +		 */
> +		wrmsr(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE),
> +			 0);
> +		wrmsr(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE, 0);
> +
> +		x2apic_disabled = 1;
> +	}
> +}
>  void check_x2apic(void)
>  {
> +	if (x2apic_disabled) {
> +		disable_x2apic();
> +		return;
> +	}

We shouldn't call disable_x2apic() from here. We should be following the
same sequence, like masking interrupts at the cpu, pic, io-apic level
before we disable x2apic and re-enable xapic. So the right place to do
this disable is at enable_IR_x2apic(). 

> @@ -1449,6 +1480,11 @@ void enable_x2apic(void)
>  {
>  	int msr, msr2;
>  
> +	if (x2apic_disabled) {
> +		disable_x2apic();

enable_x2apic() gets called from both BP and AP. AP's need not do the
apic-id being >= 255 checks etc. As that is done during smp bringup
(which is missing currently from the current patch) or during MADT
parsing. So all we need to do is a simple x2apic->xapic conversion.

>  
>  #ifdef CONFIG_X86_64
> Index: linux-2.6/arch/x86/mm/srat.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/srat.c
> +++ linux-2.6/arch/x86/mm/srat.c
> @@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct ac
>  	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
>  		return;
>  	pxm = pa->proximity_domain;
> +	apic_id = pa->apic_id;
> +	if (x2apic_disabled && (apic_id >= 0xff)) {

Same comments like in the above MADT parsing.

>  
> Index: linux-2.6/arch/x86/kernel/cpu/topology.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/topology.c
> +++ linux-2.6/arch/x86/kernel/cpu/topology.c
> @@ -21,6 +21,27 @@
>  #define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
>  #define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
>  
> +u32 x2apic_cpuid_initial_apicid(void)
> +{

I think we can do with out this function.

While reviewing the code, I ended up doing some of this cleanup of your
patch. I have appended the modified version. Can you please incorporate
the smpboot checks before the AP bringup (apic-id should be less than
255 in !x2apic_mode etc) and split the patch into couple of patches
(apic_probe etc) along with other needed cleanups.

Thanks.
---
 arch/x86/include/asm/apic.h         |    6 ++
 arch/x86/include/asm/apicdef.h      |    1 +
 arch/x86/kernel/acpi/boot.c         |   10 +++-
 arch/x86/kernel/apic/apic.c         |   92 ++++++++++++++++++++++++++---------
 arch/x86/kernel/apic/apic_flat_64.c |    7 ++-
 arch/x86/kernel/apic/io_apic.c      |    4 ++
 arch/x86/mm/srat.c                  |    7 ++-
 7 files changed, 99 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a0f541a..5d43993 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -176,6 +176,8 @@ static inline u64 native_x2apic_icr_read(void)
 }
 
 extern int x2apic_phys;
+extern int x2apic_preenabled;
+extern int x2apic_disabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -198,6 +200,9 @@ static inline void x2apic_force_phys(void)
 	x2apic_phys = 1;
 }
 #else
+static inline void disable_x2apic(void)
+{
+}
 static inline void check_x2apic(void)
 {
 }
@@ -214,6 +219,7 @@ static inline void x2apic_force_phys(void)
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
+#define	x2apic_disabled	1
 #endif
 
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 3925d80..134bba0 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -144,6 +144,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4558f0d..1c54a9e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -219,6 +219,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -227,6 +229,8 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
-			    processor->lapic_flags & ACPI_MADT_ENABLED);
+	if (x2apic_disabled && (apic_id >= 0xff) && enabled)
+		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+	else
+		acpi_register_lapic(apic_id, enabled);
 #else
 	printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6acd05a..a8a0094 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -146,16 +146,16 @@ __setup("apicpmtimer", setup_apicpmtimer);
 int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
-static int x2apic_preenabled;
+int x2apic_preenabled;
+int x2apic_disabled;
 static __init int setup_nox2apic(char *str)
 {
-	if (x2apic_enabled()) {
-		pr_warning("Bios already enabled x2apic, "
-			   "can't enforce nox2apic");
-		return 0;
-	}
+	if (x2apic_enabled())
+		pr_warning("Bios already enabled x2apic, will disable it");
+	else
+		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+	x2apic_disabled = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1432,6 +1432,45 @@ void __init bsp_end_local_APIC_setup(void)
 }
 
 #ifdef CONFIG_X86_X2APIC
+
+static inline void __disable_x2apic(u64 msr)
+{
+	wrmsrl(MSR_IA32_APICBASE,
+	       msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
+	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
+}
+
+static void disable_x2apic(void)
+{
+	u64 msr;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (msr & X2APIC_ENABLE) {
+		u32 x2apic_id = read_apic_id();
+
+		if (x2apic_id > 255)
+			panic("Can not disable x2apic, id: %08x\n", x2apic_id);
+
+		pr_info("Disabling x2apic\n");
+		/*
+		 * Need to disable xapic and x2apic at the same time at first
+		 *  then enable xapic
+		 */
+		__disable_x2apic(msr);
+
+		if (x2apic_disabled)
+			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+
+		x2apic_disabled = 1;
+		x2apic_mode = 0;
+
+		register_lapic_address(mp_lapic_addr);
+	}
+}
+
 void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
@@ -1442,15 +1481,20 @@ void check_x2apic(void)
 
 void enable_x2apic(void)
 {
-	int msr, msr2;
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (x2apic_disabled) {
+		__disable_x2apic(msr);
+		return;
+	}
 
 	if (!x2apic_mode)
 		return;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
+		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
@@ -1487,25 +1531,34 @@ void __init enable_IR_x2apic(void)
 	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto out;
+		return;
 	}
 
 	local_irq_save(flags);
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
+	if (x2apic_disabled)
+		disable_x2apic();
+
 	if (dmar_table_init_ret)
 		ret = -1;
 	else
 		ret = enable_IR();
 
+	if (!x2apic_supported())
+		goto nox2apic;
+
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available())
+		    !hypervisor_x2apic_available()) {
+			if (x2apic_preenabled && !x2apic_disabled)
+				disable_x2apic();
 			goto nox2apic;
+		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1513,8 +1566,10 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	if (ret == IRQ_REMAP_XAPIC_MODE)
+	if (ret == IRQ_REMAP_XAPIC_MODE) {
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
 		goto nox2apic;
+	}
 
 	x2apic_enabled = 1;
 
@@ -1529,17 +1584,6 @@ nox2apic:
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-
-out:
-	if (x2apic_enabled || !x2apic_supported())
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (ret == IRQ_REMAP_XAPIC_MODE)
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-	else if (ret < 0)
-		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 57c1f41..8c3cdde 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -171,9 +171,14 @@ static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
+static int flat_probe(void)
+{
+	return 1;
+}
+
 static struct apic apic_flat =  {
 	.name				= "flat",
-	.probe				= NULL,
+	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8980555..f2977a2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2948,6 +2948,10 @@ static inline void __init check_timer(void)
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	if (x2apic_preenabled && !x2apic_mode)
+		pr_info("Your system has x2apic pre-enabled, but kernel can not enable intr-remapping.\n"
+			"So kernel try to disable x2apic, but interrupt still have problem.\n"
+			"You could disable x2apic from BIOS setup\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
 out:
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 81dbfde..6dd2b09 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
+	apic_id = pa->apic_id;
+	if (x2apic_disabled && (apic_id >= 0xff)) {
+		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+			 pxm, apic_id);
+		return;
+	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -76,7 +82,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;


