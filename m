Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2FHOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:47:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64586 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2FHOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:46:58 -0400
Date: Fri, 8 Jun 2012 16:46:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120608144653.GA21440@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: eeaaa96a3a2134a174100afd129bb0891d05f4b2 x86/nmi: Fix section mismatch warnings on 32-bit

 Thanks,

	Ingo

------------------>
Chen Gong (1):
      x86/mce: Fix the MCE poll timer logic

Cliff Wickman (1):
      x86/uv: Fix UV2 BAU legacy mode

Don Zickus (1):
      x86/nmi: Fix section mismatch warnings on 32-bit

Feng Tang (1):
      x86/reboot: Fix a warning message triggered by stop_other_cpus()

Jordan Justen (1):
      x86, efi stub: Add .reloc section back into image

Sebastian Andrzej Siewior (1):
      x86/intel/moorestown: Change intel_scu_devices_create() to __devinit

Thomas Gleixner (1):
      x86: mce: Add the dropped timer interval init back

Tomoki Sekiyama (1):
      x86/ioapic: Fix NULL pointer dereference on CPU hotplug after disabling irqs

Xiaotian Feng (1):
      x86/gart: Fix kmemleak warning

Yasuaki Ishimatsu (1):
      x86/numa: Set numa_nodes_parsed at acpi_numa_memory_affinity_init()

Yinghai Lu (1):
      x86/mm: Only add extra pages count for the first memory range during pre-allocation early page table space


 arch/x86/boot/header.S           |  42 +++++++---
 arch/x86/boot/tools/build.c      | 172 +++++++++++++++++++++++++--------------
 arch/x86/include/asm/nmi.h       |  14 ++++
 arch/x86/include/asm/uv/uv_bau.h |   1 -
 arch/x86/kernel/aperture_64.c    |   6 --
 arch/x86/kernel/apic/io_apic.c   |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c |   4 +-
 arch/x86/kernel/nmi_selftest.c   |   4 +-
 arch/x86/kernel/reboot.c         |   6 +-
 arch/x86/mm/init.c               |   3 +-
 arch/x86/mm/srat.c               |   2 +
 arch/x86/platform/mrst/mrst.c    |   2 +-
 arch/x86/platform/uv/tlb_uv.c    |   1 -
 13 files changed, 169 insertions(+), 92 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8bbea6a..efe5acf 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -94,10 +94,10 @@ bs_die:
 
 	.section ".bsdata", "a"
 bugger_off_msg:
-	.ascii	"Direct booting from floppy is no longer supported.\r\n"
-	.ascii	"Please use a boot loader program instead.\r\n"
+	.ascii	"Direct floppy boot is not supported. "
+	.ascii	"Use a boot loader program instead.\r\n"
 	.ascii	"\n"
-	.ascii	"Remove disk and press any key to reboot . . .\r\n"
+	.ascii	"Remove disk and press any key to reboot ...\r\n"
 	.byte	0
 
 #ifdef CONFIG_EFI_STUB
@@ -111,7 +111,7 @@ coff_header:
 #else
 	.word	0x8664				# x86-64
 #endif
-	.word	2				# nr_sections
+	.word	3				# nr_sections
 	.long	0 				# TimeDateStamp
 	.long	0				# PointerToSymbolTable
 	.long	1				# NumberOfSymbols
@@ -158,8 +158,8 @@ extra_header_fields:
 #else
 	.quad	0				# ImageBase
 #endif
-	.long	0x1000				# SectionAlignment
-	.long	0x200				# FileAlignment
+	.long	0x20				# SectionAlignment
+	.long	0x20				# FileAlignment
 	.word	0				# MajorOperatingSystemVersion
 	.word	0				# MinorOperatingSystemVersion
 	.word	0				# MajorImageVersion
@@ -200,8 +200,10 @@ extra_header_fields:
 
 	# Section table
 section_table:
-	.ascii	".text"
-	.byte	0
+	#
+	# The offset & size fields are filled in by build.c.
+	#
+	.ascii	".setup"
 	.byte	0
 	.byte	0
 	.long	0
@@ -217,9 +219,8 @@ section_table:
 
 	#
 	# The EFI application loader requires a relocation section
-	# because EFI applications must be relocatable. But since
-	# we don't need the loader to fixup any relocs for us, we
-	# just create an empty (zero-length) .reloc section header.
+	# because EFI applications must be relocatable. The .reloc
+	# offset & size fields are filled in by build.c.
 	#
 	.ascii	".reloc"
 	.byte	0
@@ -233,6 +234,25 @@ section_table:
 	.word	0				# NumberOfRelocations
 	.word	0				# NumberOfLineNumbers
 	.long	0x42100040			# Characteristics (section flags)
+
+	#
+	# The offset & size fields are filled in by build.c.
+	#
+	.ascii	".text"
+	.byte	0
+	.byte	0
+	.byte	0
+	.long	0
+	.long	0x0				# startup_{32,64}
+	.long	0				# Size of initialized data
+						# on disk
+	.long	0x0				# startup_{32,64}
+	.long	0				# PointerToRelocations
+	.long	0				# PointerToLineNumbers
+	.word	0				# NumberOfRelocations
+	.word	0				# NumberOfLineNumbers
+	.long	0x60500020			# Characteristics (section flags)
+
 #endif /* CONFIG_EFI_STUB */
 
 	# Kernel attributes; used by setup.  This is part 1 of the
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 3f61f6e..4b8e165 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -50,6 +50,8 @@ typedef unsigned int   u32;
 u8 buf[SETUP_SECT_MAX*512];
 int is_big_kernel;
 
+#define PECOFF_RELOC_RESERVE 0x20
+
 /*----------------------------------------------------------------------*/
 
 static const u32 crctab32[] = {
@@ -133,11 +135,103 @@ static void usage(void)
 	die("Usage: build setup system [> image]");
 }
 
-int main(int argc, char ** argv)
-{
 #ifdef CONFIG_EFI_STUB
-	unsigned int file_sz, pe_header;
+
+static void update_pecoff_section_header(char *section_name, u32 offset, u32 size)
+{
+	unsigned int pe_header;
+	unsigned short num_sections;
+	u8 *section;
+
+	pe_header = get_unaligned_le32(&buf[0x3c]);
+	num_sections = get_unaligned_le16(&buf[pe_header + 6]);
+
+#ifdef CONFIG_X86_32
+	section = &buf[pe_header + 0xa8];
+#else
+	section = &buf[pe_header + 0xb8];
 #endif
+
+	while (num_sections > 0) {
+		if (strncmp((char*)section, section_name, 8) == 0) {
+			/* section header size field */
+			put_unaligned_le32(size, section + 0x8);
+
+			/* section header vma field */
+			put_unaligned_le32(offset, section + 0xc);
+
+			/* section header 'size of initialised data' field */
+			put_unaligned_le32(size, section + 0x10);
+
+			/* section header 'file offset' field */
+			put_unaligned_le32(offset, section + 0x14);
+
+			break;
+		}
+		section += 0x28;
+		num_sections--;
+	}
+}
+
+static void update_pecoff_setup_and_reloc(unsigned int size)
+{
+	u32 setup_offset = 0x200;
+	u32 reloc_offset = size - PECOFF_RELOC_RESERVE;
+	u32 setup_size = reloc_offset - setup_offset;
+
+	update_pecoff_section_header(".setup", setup_offset, setup_size);
+	update_pecoff_section_header(".reloc", reloc_offset, PECOFF_RELOC_RESERVE);
+
+	/*
+	 * Modify .reloc section contents with a single entry. The
+	 * relocation is applied to offset 10 of the relocation section.
+	 */
+	put_unaligned_le32(reloc_offset + 10, &buf[reloc_offset]);
+	put_unaligned_le32(10, &buf[reloc_offset + 4]);
+}
+
+static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
+{
+	unsigned int pe_header;
+	unsigned int text_sz = file_sz - text_start;
+
+	pe_header = get_unaligned_le32(&buf[0x3c]);
+
+	/* Size of image */
+	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
+
+	/*
+	 * Size of code: Subtract the size of the first sector (512 bytes)
+	 * which includes the header.
+	 */
+	put_unaligned_le32(file_sz - 512, &buf[pe_header + 0x1c]);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Address of entry point.
+	 *
+	 * The EFI stub entry point is +16 bytes from the start of
+	 * the .text section.
+	 */
+	put_unaligned_le32(text_start + 16, &buf[pe_header + 0x28]);
+#else
+	/*
+	 * Address of entry point. startup_32 is at the beginning and
+	 * the 64-bit entry point (startup_64) is always 512 bytes
+	 * after. The EFI stub entry point is 16 bytes after that, as
+	 * the first instruction allows legacy loaders to jump over
+	 * the EFI stub initialisation
+	 */
+	put_unaligned_le32(text_start + 528, &buf[pe_header + 0x28]);
+#endif /* CONFIG_X86_32 */
+
+	update_pecoff_section_header(".text", text_start, text_sz);
+}
+
+#endif /* CONFIG_EFI_STUB */
+
+int main(int argc, char ** argv)
+{
 	unsigned int i, sz, setup_sectors;
 	int c;
 	u32 sys_size;
@@ -163,6 +257,12 @@ int main(int argc, char ** argv)
 		die("Boot block hasn't got boot flag (0xAA55)");
 	fclose(file);
 
+#ifdef CONFIG_EFI_STUB
+	/* Reserve 0x20 bytes for .reloc section */
+	memset(buf+c, 0, PECOFF_RELOC_RESERVE);
+	c += PECOFF_RELOC_RESERVE;
+#endif
+
 	/* Pad unused space with zeros */
 	setup_sectors = (c + 511) / 512;
 	if (setup_sectors < SETUP_SECT_MIN)
@@ -170,6 +270,10 @@ int main(int argc, char ** argv)
 	i = setup_sectors*512;
 	memset(buf+c, 0, i-c);
 
+#ifdef CONFIG_EFI_STUB
+	update_pecoff_setup_and_reloc(i);
+#endif
+
 	/* Set the default root device */
 	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
 
@@ -194,66 +298,8 @@ int main(int argc, char ** argv)
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
 #ifdef CONFIG_EFI_STUB
-	file_sz = sz + i + ((sys_size * 16) - sz);
-
-	pe_header = get_unaligned_le32(&buf[0x3c]);
-
-	/* Size of image */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
-
-	/*
-	 * Subtract the size of the first section (512 bytes) which
-	 * includes the header and .reloc section. The remaining size
-	 * is that of the .text section.
-	 */
-	file_sz -= 512;
-
-	/* Size of code */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0x1c]);
-
-#ifdef CONFIG_X86_32
-	/*
-	 * Address of entry point.
-	 *
-	 * The EFI stub entry point is +16 bytes from the start of
-	 * the .text section.
-	 */
-	put_unaligned_le32(i + 16, &buf[pe_header + 0x28]);
-
-	/* .text size */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0xb0]);
-
-	/* .text vma */
-	put_unaligned_le32(0x200, &buf[pe_header + 0xb4]);
-
-	/* .text size of initialised data */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0xb8]);
-
-	/* .text file offset */
-	put_unaligned_le32(0x200, &buf[pe_header + 0xbc]);
-#else
-	/*
-	 * Address of entry point. startup_32 is at the beginning and
-	 * the 64-bit entry point (startup_64) is always 512 bytes
-	 * after. The EFI stub entry point is 16 bytes after that, as
-	 * the first instruction allows legacy loaders to jump over
-	 * the EFI stub initialisation
-	 */
-	put_unaligned_le32(i + 528, &buf[pe_header + 0x28]);
-
-	/* .text size */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0xc0]);
-
-	/* .text vma */
-	put_unaligned_le32(0x200, &buf[pe_header + 0xc4]);
-
-	/* .text size of initialised data */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0xc8]);
-
-	/* .text file offset */
-	put_unaligned_le32(0x200, &buf[pe_header + 0xcc]);
-#endif /* CONFIG_X86_32 */
-#endif /* CONFIG_EFI_STUB */
+	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
+#endif
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, stdout) != i)
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 0e3793b..dc580c4 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -54,6 +54,20 @@ struct nmiaction {
 	__register_nmi_handler((t), &fn##_na);	\
 })
 
+/*
+ * For special handlers that register/unregister in the
+ * init section only.  This should be considered rare.
+ */
+#define register_nmi_handler_initonly(t, fn, fg, n)		\
+({							\
+	static struct nmiaction fn##_na __initdata = {		\
+		.handler = (fn),			\
+		.name = (n),				\
+		.flags = (fg),				\
+	};						\
+	__register_nmi_handler((t), &fn##_na);	\
+})
+
 int __register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index becf47b..6149b47 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -149,7 +149,6 @@
 /* 4 bits of software ack period */
 #define UV2_ACK_MASK			0x7UL
 #define UV2_ACK_UNITS_SHFT		3
-#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT
 #define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
 
 /*
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 6e76c19..d5fd66f 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/suspend.h>
-#include <linux/kmemleak.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/iommu.h>
@@ -95,11 +94,6 @@ static u32 __init allocate_aperture(void)
 		return 0;
 	}
 	memblock_reserve(addr, aper_size);
-	/*
-	 * Kmemleak should not scan this block as it may not be mapped via the
-	 * kernel direct mapping.
-	 */
-	kmemleak_ignore(phys_to_virt(addr));
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, addr);
 	insert_aperture_resource((u32)addr, aper_size);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ac96561..5f0ff59 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1195,7 +1195,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
-	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
+	for_each_cpu(cpu, cfg->domain)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
@@ -1203,7 +1203,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 
 	if (likely(!cfg->move_in_progress))
 		return;
-	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
+	for_each_cpu(cpu, cfg->old_domain) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0a687fd..da27c5d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1274,7 +1274,7 @@ static void mce_timer_fn(unsigned long data)
 	 */
 	iv = __this_cpu_read(mce_next_interval);
 	if (mce_notify_irq())
-		iv = max(iv, (unsigned long) HZ/100);
+		iv = max(iv / 2, (unsigned long) HZ/100);
 	else
 		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
 	__this_cpu_write(mce_next_interval, iv);
@@ -1557,7 +1557,7 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 static void __mcheck_cpu_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
-	unsigned long iv = __this_cpu_read(mce_next_interval);
+	unsigned long iv = check_interval * HZ;
 
 	setup_timer(t, mce_timer_fn, smp_processor_id());
 
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index e31bf8d..149b8d9 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -42,7 +42,7 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+	register_nmi_handler_initonly(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -64,7 +64,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
+	if (register_nmi_handler_initonly(NMI_LOCAL, test_nmi_ipi_callback,
 				 NMI_FLAG_FIRST, "nmi_selftest")) {
 		nmi_fail = FAILURE;
 		return;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 79c45af..25b48ed 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -639,9 +639,11 @@ void native_machine_shutdown(void)
 	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
 
 	/*
-	 * O.K Now that I'm on the appropriate processor,
-	 * stop all of the others.
+	 * O.K Now that I'm on the appropriate processor, stop all of the
+	 * others. Also disable the local irq to not receive the per-cpu
+	 * timer interrupt which may trigger scheduler's load balance.
 	 */
+	local_irq_disable();
 	stop_other_cpus();
 #endif
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 97141c2..bc4e9d8 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -62,7 +62,8 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 		extra += PMD_SIZE;
 #endif
 		/* The first 2/4M doesn't use large pages. */
-		extra += mr->end - mr->start;
+		if (mr->start < PMD_SIZE)
+			extra += mr->end - mr->start;
 
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 732af3a..4599c3e 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -176,6 +176,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		return;
 	}
 
+	node_set(node, numa_nodes_parsed);
+
 	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
 	       node, pxm,
 	       (unsigned long long) start, (unsigned long long) end - 1);
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e31bcd8..fd41a92 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -782,7 +782,7 @@ BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
 EXPORT_SYMBOL_GPL(intel_scu_notifier);
 
 /* Called by IPC driver */
-void intel_scu_devices_create(void)
+void __devinit intel_scu_devices_create(void)
 {
 	int i;
 
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3ae0e61..59880af 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1295,7 +1295,6 @@ static void __init enable_timeouts(void)
 		 */
 		mmr_image |= (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
-			mmr_image &= ~(1L << UV2_LEG_SHFT);
 			mmr_image |= (1L << UV2_EXT_SHFT);
 		}
 		write_mmr_misc_control(pnode, mmr_image);
