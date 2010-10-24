Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0JXWLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:11:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31617 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab0JXWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:11:53 -0400
Message-ID: <4CC4AEAB.4030505@kernel.org>
Date: Sun, 24 Oct 2010 15:09:47 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Disabling x2apic if nox2apic is specified
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-16-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1010241204470.2466@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010241204470.2466@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 03:15 AM, Thomas Gleixner wrote:
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index d286db1..ebb13e8 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -138,15 +138,14 @@ int x2apic_mode;
>>  #ifdef CONFIG_X86_X2APIC
>>  /* x2apic enabled before OS handover */
>>  static int x2apic_preenabled;
>> +int nox2apic;
>>  static __init int setup_nox2apic(char *str)
>>  {
>> -	if (x2apic_enabled()) {
>> -		pr_warning("Bios already enabled x2apic, "
>> -			   "can't enforce nox2apic");
>> -		return 0;
>> -	}
>> +	if (x2apic_enabled())
>> +		pr_warning("Bios already enabled x2apic, will disable it");
>> +
>> +	nox2apic = 1;
>>  
>> -	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
> 
> Why is this removed ?
> 

need to check that bit with disable_x2apic.

+static void disable_x2apic(void)
+{
+       int msr, msr2;
+
+       if (!cpu_has_x2apic)
+               return;

other concern should be addressed. please check -v2.

Thanks

	Yinghai

[PATCH -v2] x86: Disable x2apic if nox2apic is specified

For
1. x2apic preenabled system
2. first kernel have x2apic enabled, and try to kexec second kernel with "nox2apic"

Will put back cpu with apic id < 255 into xapic mode, instead of panic.

-v2: use x2apic_disabled instead of nox2apic, Suggested by Thomas
     update x2apic_supported with x2apic_disabled, Suggested by Thomas

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apic.h    |    6 +++--
 arch/x86/include/asm/apicdef.h |    1 
 arch/x86/kernel/acpi/boot.c    |   10 +++++++-
 arch/x86/kernel/apic/apic.c    |   46 ++++++++++++++++++++++++++++++++++-------
 arch/x86/mm/srat_64.c          |    7 +++++-
 5 files changed, 58 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read
 }
 
 extern int x2apic_phys;
+extern int x2apic_disabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -183,7 +184,7 @@ static inline int x2apic_enabled(void)
 {
 	int msr, msr2;
 
-	if (!cpu_has_x2apic)
+	if (!cpu_has_x2apic || x2apic_disabled)
 		return 0;
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
@@ -192,7 +193,7 @@ static inline int x2apic_enabled(void)
 	return 0;
 }
 
-#define x2apic_supported()	(cpu_has_x2apic)
+#define x2apic_supported()	(cpu_has_x2apic && !x2apic_disabled)
 static inline void x2apic_force_phys(void)
 {
 	x2apic_phys = 1;
@@ -214,6 +215,7 @@ static inline void x2apic_force_phys(voi
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
+#define	x2apic_disabled	1
 #endif
 
 extern void enable_IR_x2apic(void);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -213,6 +213,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -221,6 +223,8 @@ acpi_parse_x2apic(struct acpi_subtable_h
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -229,8 +233,10 @@ acpi_parse_x2apic(struct acpi_subtable_h
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
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -138,15 +138,14 @@ int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
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
+
+	x2apic_disabled = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1393,8 +1392,33 @@ void __cpuinit end_local_APIC_setup(void
 }
 
 #ifdef CONFIG_X86_X2APIC
+
+static void disable_x2apic(void)
+{
+	int msr, msr2;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (msr & X2APIC_ENABLE) {
+		pr_info("Disabling x2apic\n");
+		/*
+		 * Need to disable xapic and x2apic at the same time at first
+		 *  then enable xapic
+		 */
+		wrmsr(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE),
+			 0);
+		wrmsr(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE, 0);
+	}
+}
 void check_x2apic(void)
 {
+	if (x2apic_disabled) {
+		disable_x2apic();
+		return;
+	}
+
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
 		x2apic_preenabled = x2apic_mode = 1;
@@ -1405,6 +1429,11 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
+	if (x2apic_disabled) {
+		disable_x2apic();
+		return;
+	}
+
 	if (!x2apic_mode)
 		return;
 
@@ -1473,6 +1502,9 @@ void __init enable_IR_x2apic(void)
 	else
 		ret = enable_IR();
 
+	if (x2apic_disabled)
+		goto nox2apic;
+
 	if (!ret) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
@@ -1509,7 +1541,7 @@ out:
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
+	else if (cpu_has_x2apic && !x2apic_disabled)
 		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
 }
 
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -126,6 +126,12 @@ acpi_numa_x2apic_affinity_init(struct ac
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
@@ -133,7 +139,6 @@ acpi_numa_x2apic_affinity_init(struct ac
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
Index: linux-2.6/arch/x86/include/asm/apicdef.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6/arch/x86/include/asm/apicdef.h
@@ -141,6 +141,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
