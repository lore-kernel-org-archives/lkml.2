Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1AEAlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:41:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52642 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1AEAlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:41:53 -0500
Message-ID: <4D23BD9C.3070102@kernel.org>
Date: Tue, 04 Jan 2011 16:38:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, 64bit: Always make MAX_APICS to 32768
References: <4D1D2C4D.4090806@kernel.org> <20110104084847.GB26209@elte.hu>
In-Reply-To: <20110104084847.GB26209@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 12:48 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> Found one x2apic pre-enabled system, x2apic_mode suddenly get corrupted
>> after register some cpus. when compiled CONFIG_NR_CPUS=255 instead of 512
>>
>> It turns out that generic_processor_info() ==> phyid_set(apicid, phys_cpu_present_map) cause the problem.
>>
>> phys_cpu_present_map is with MAX_APICS bits. and pre-enabled system some cpus apic id > 255.
>>
>> the variable after phys_cpu_present_map may get corrupted.... siliently...
>>
>> ffffffff828e8420 B phys_cpu_present_map
>> ffffffff828e8440 B apic_verbosity
>> ffffffff828e8444 B local_apic_timer_c2_ok
>> ffffffff828e8448 B disable_apic
>> ffffffff828e844c B x2apic_mode
>> ffffffff828e8450 B x2apic_disabled
>> ffffffff828e8454 B num_processors
>> ...
>>
>> Actually phys_cpu_present_map is referenced via apic id, instead index. we should use
>> MAX_LOCAL_APIC instead MAX_APICIS. but that is another header.
>>
>> So just let MAX_APICS equal to MAX_LOCAL_APIC at this point.
>> esp for 64 bit will be 32768 in all cases.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/mpspec_def.h |    6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/mpspec_def.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/mpspec_def.h
>> +++ linux-2.6/arch/x86/include/asm/mpspec_def.h
>> @@ -17,11 +17,7 @@
>>  # define MAX_MPC_ENTRY 1024
>>  # define MAX_APICS      256
>>  #else
>> -# if NR_CPUS <= 255
>> -#  define MAX_APICS     255
>> -# else
>> -#  define MAX_APICS   32768
>> -# endif
>> +# define MAX_APICS    32768
>>  #endif
>>  
>>  /* Intel MP Floating Pointer Structure */
> 
> Please fix the real bug first: the lack of boundary checks when we set 
> phys_cpu_present_map!
real bug is that MAX_APICS and MAX_LOCAL_APIC using is messed up.

could be MAX_APICS is from 32bit, and MAX_LOCAL_APIC is from 64bit.

> 
> Then, once that bitmap op is not corrupting nearby variables silently but triggers a 
> fail-safe logic instead (ignoring apics that go outside the supported range? 
> printk-ing a warning?) can we think about upping the limit.

Using MAX_APICS and MAX_LOCAL_APIC at same time cause confusing.

We should just use MAX_LOCAL_APIC instead.

If MAX_APICS is not just for apic entries number, we don't need it. NR_CPUS or nr_cpu_ids will do the
check for us.

> 
> But even with the limit upping, please show (in the changelog) a before/after 'size 
> vmlinux' comparison, to make sure that this rather drastic change of the limit does 
> not waste unreasonable amounts of memory.

about 4k for 64bit when NR_CPUS=255.

please check if you like following patch instead. or just keep MAX_APICS == MAX_LOCAL_APIC

[PATCH] x86: Remove MAX_APICS

Found one x2apic pre-enabled system, x2apic_mode suddenly get corrupted
after register some cpus. when compiled CONFIG_NR_CPUS=255 instead of 512

It turns out that generic_processor_info() ==> phyid_set(apicid, phys_cpu_present_map) cause the problem.

phys_cpu_present_map is with MAX_APICS bits. and pre-enabled system some cpus apic id > 255.

the variable after phys_cpu_present_map may get corrupted.... siliently...

ffffffff828e8420 B phys_cpu_present_map
ffffffff828e8440 B apic_verbosity
ffffffff828e8444 B local_apic_timer_c2_ok
ffffffff828e8448 B disable_apic
ffffffff828e844c B x2apic_mode
ffffffff828e8450 B x2apic_disabled
ffffffff828e8454 B num_processors
...

Actually phys_cpu_present_map is referenced via apic id, instead index. We should use
MAX_LOCAL_APIC instead MAX_APICS.

For 64 bit will be 32768 in all cases.

   text	   data	    bss	    dec	    hex	filename
21696943	4193748	12791808	38682499	24e3f83	vmlinux.after
21696943	4193748	12787712	38678403	24e2f83	vmlinux.before

bss will increase 4k bytes

no change for 32bit.

Finally could remove MAX_APCIS that causes confusing.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h          |   29 +++++++++++------------------
 arch/x86/include/asm/mpspec_def.h      |    7 -------
 arch/x86/kernel/acpi/boot.c            |    6 +++---
 arch/x86/kernel/apic/io_apic.c         |    3 ++-
 arch/x86/platform/sfi/sfi.c            |    4 ++--
 arch/x86/platform/visws/visws_quirks.c |    2 +-
 6 files changed, 19 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -5,6 +5,7 @@
 
 #include <asm/mpspec_def.h>
 #include <asm/x86_init.h>
+#include <asm/apicdef.h>
 
 extern int apic_version[];
 extern int pic_mode;
@@ -107,7 +108,7 @@ extern int mp_register_gsi(struct device
 				 int active_high_low);
 #endif /* CONFIG_ACPI */
 
-#define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
+#define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_LOCAL_APIC)
 
 struct physid_mask {
 	unsigned long mask[PHYSID_ARRAY_SIZE];
@@ -122,31 +123,31 @@ typedef struct physid_mask physid_mask_t
 	test_and_set_bit(physid, (map).mask)
 
 #define physids_and(dst, src1, src2)					\
-	bitmap_and((dst).mask, (src1).mask, (src2).mask, MAX_APICS)
+	bitmap_and((dst).mask, (src1).mask, (src2).mask, MAX_LOCAL_APIC)
 
 #define physids_or(dst, src1, src2)					\
-	bitmap_or((dst).mask, (src1).mask, (src2).mask, MAX_APICS)
+	bitmap_or((dst).mask, (src1).mask, (src2).mask, MAX_LOCAL_APIC)
 
 #define physids_clear(map)					\
-	bitmap_zero((map).mask, MAX_APICS)
+	bitmap_zero((map).mask, MAX_LOCAL_APIC)
 
 #define physids_complement(dst, src)				\
-	bitmap_complement((dst).mask, (src).mask, MAX_APICS)
+	bitmap_complement((dst).mask, (src).mask, MAX_LOCAL_APIC)
 
 #define physids_empty(map)					\
-	bitmap_empty((map).mask, MAX_APICS)
+	bitmap_empty((map).mask, MAX_LOCAL_APIC)
 
 #define physids_equal(map1, map2)				\
-	bitmap_equal((map1).mask, (map2).mask, MAX_APICS)
+	bitmap_equal((map1).mask, (map2).mask, MAX_LOCAL_APIC)
 
 #define physids_weight(map)					\
-	bitmap_weight((map).mask, MAX_APICS)
+	bitmap_weight((map).mask, MAX_LOCAL_APIC)
 
 #define physids_shift_right(d, s, n)				\
-	bitmap_shift_right((d).mask, (s).mask, n, MAX_APICS)
+	bitmap_shift_right((d).mask, (s).mask, n, MAX_LOCAL_APIC)
 
 #define physids_shift_left(d, s, n)				\
-	bitmap_shift_left((d).mask, (s).mask, n, MAX_APICS)
+	bitmap_shift_left((d).mask, (s).mask, n, MAX_LOCAL_APIC)
 
 static inline unsigned long physids_coerce(physid_mask_t *map)
 {
@@ -159,14 +160,6 @@ static inline void physids_promote(unsig
 	map->mask[0] = physids;
 }
 
-/* Note: will create very large stack frames if physid_mask_t is big */
-#define physid_mask_of_physid(physid)					\
-	({								\
-		physid_mask_t __physid_mask = PHYSID_MASK_NONE;		\
-		physid_set(physid, __physid_mask);			\
-		__physid_mask;						\
-	})
-
 static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 {
 	physids_clear(*map);
Index: linux-2.6/arch/x86/include/asm/mpspec_def.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec_def.h
+++ linux-2.6/arch/x86/include/asm/mpspec_def.h
@@ -15,13 +15,6 @@
 
 #ifdef CONFIG_X86_32
 # define MAX_MPC_ENTRY 1024
-# define MAX_APICS      256
-#else
-# if NR_CPUS <= 255
-#  define MAX_APICS     255
-# else
-#  define MAX_APICS   32768
-# endif
 #endif
 
 /* Intel MP Floating Pointer Structure */
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -903,13 +903,13 @@ static int __init acpi_parse_madt_lapic_
 	register_lapic_address(acpi_lapic_addr);
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
-				      acpi_parse_sapic, MAX_APICS);
+				      acpi_parse_sapic, MAX_LOCAL_APIC);
 
 	if (!count) {
 		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
-						acpi_parse_x2apic, MAX_APICS);
+					acpi_parse_x2apic, MAX_LOCAL_APIC);
 		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
-					      acpi_parse_lapic, MAX_APICS);
+					acpi_parse_lapic, MAX_LOCAL_APIC);
 	}
 	if (!count && !x2count) {
 		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -4087,7 +4087,8 @@ void __init pre_init_apic_IRQ0(void)
 
 	printk(KERN_INFO "Early APIC setup for system timer0\n");
 #ifndef CONFIG_SMP
-	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+	physid_set_mask_of_physid(boot_cpu_physical_apicid,
+					 &phys_cpu_present_map);
 #endif
 	/* Make sure the irq descriptor is set up */
 	cfg = alloc_irq_and_cfg_at(0, 0);
Index: linux-2.6/arch/x86/platform/sfi/sfi.c
===================================================================
--- linux-2.6.orig/arch/x86/platform/sfi/sfi.c
+++ linux-2.6/arch/x86/platform/sfi/sfi.c
@@ -37,9 +37,9 @@ static unsigned long sfi_lapic_addr __in
 /* All CPUs enumerated by SFI must be present and enabled */
 static void __cpuinit mp_sfi_register_lapic(u8 id)
 {
-	if (MAX_APICS - id <= 0) {
+	if (MAX_LOCAL_APIC - id <= 0) {
 		pr_warning("Processor #%d invalid (max %d)\n",
-			id, MAX_APICS);
+			id, MAX_LOCAL_APIC);
 		return;
 	}
 
Index: linux-2.6/arch/x86/platform/visws/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/platform/visws/visws_quirks.c
+++ linux-2.6/arch/x86/platform/visws/visws_quirks.c
@@ -171,7 +171,7 @@ static void __init MP_processor_info(str
 	ver = m->apicver;
 	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {
 		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
-			m->apicid, MAX_APICS);
+			m->apicid, MAX_LOCAL_APIC);
 		return;
 	}
 
