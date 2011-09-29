Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1I2PIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:08:13 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41110 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1I2PIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:08:11 -0400
Subject: [RFC PATCH v2 04/10] fadump: Initialize elfcore header and add
	PT_LOAD program headers.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 29 Sep 2011 20:36:01 +0530
Message-ID: <20110929150601.26689.46642.stgit@mars.in.ibm.com>
In-Reply-To: <20110929150117.26689.62053.stgit@mars.in.ibm.com>
References: <20110929150117.26689.62053.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Build the crash memory range list by traversing through system memory during
the first kernel before we register for firmware-assisted dump. After the
successful dump registration, initialize the elfcore header and populate
PT_LOAD program headers with crash memory ranges. The elfcore header is
saved in the scratch area within the reserved memory. The scratch area starts
at the end of the memory reserved for saving RMR region contents. The
scratch area contains fadump crash info structure that contains magic number
for fadump validation and physical address where the eflcore header can be
found. This structure will also be used to pass some important crash info
data to the second kernel which will help second kernel to populate ELF core
header with correct data before it gets exported through /proc/vmcore. Since
the firmware preserves the entire partition memory at the time of crash the
contents of the scratch area will be preserved till second kernel boot.

NOTE: The current design implementation does not address a possibility of
introducing additional fields (in future) to this structure without affecting
compatibility. It's on TODO list to come up with better approach to
address this.

Reserved dump area start => +-------------------------------------+
                            |  CPU state dump data                |
                            +-------------------------------------+
                            |  HPTE region data                   |
                            +-------------------------------------+
                            |  RMR region data                    |
Scratch area start       => +-------------------------------------+
                            |  fadump crash info structure {      |
                            |     magic nummber                   |
                     +------|---- elfcorehdr_addr                 |
                     |      |  }                                  |
                     +----> +-------------------------------------+
                            |  ELF core header                    |
Reserved dump area end   => +-------------------------------------+

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/fadump.h |   37 +++++++
 arch/powerpc/kernel/fadump.c      |  210 +++++++++++++++++++++++++++++++++++++
 include/linux/crash_dump.h        |    1 
 include/linux/memblock.h          |    1 
 kernel/crash_dump.c               |   33 ++++++
 5 files changed, 280 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
index 1728718..b8e175c 100644
--- a/arch/powerpc/include/asm/fadump.h
+++ b/arch/powerpc/include/asm/fadump.h
@@ -50,6 +50,9 @@
 #define FADUMP_UNREGISTER	2
 #define FADUMP_INVALIDATE	3
 
+/* Dump status flag */
+#define FADUMP_ERROR_FLAG	0x2000
+
 /* Kernel Dump section info */
 struct fadump_section {
 	u32	request_flag;
@@ -103,6 +106,7 @@ struct fw_dump {
 	/* cmd line option during boot */
 	unsigned long	reserve_bootvar;
 
+	unsigned long	fadumphdr_addr;
 	int		ibm_configure_kernel_dump;
 
 	unsigned long	fadump_enabled:1;
@@ -111,6 +115,39 @@ struct fw_dump {
 	unsigned long	dump_registered:1;
 };
 
+/*
+ * Copy the ascii values for first 8 characters from a string into u64
+ * variable at their respective indexes.
+ * e.g.
+ *  The string "FADMPINF" will be converted into 0x4641444d50494e46
+ */
+static inline u64 str_to_u64(const char *str)
+{
+	u64 val = 0;
+	int i;
+
+	for (i = 0; i < sizeof(val); i++)
+		val = (*str) ? (val << 8) | *str++ : val << 8;
+	return val;
+}
+#define STR_TO_HEX(x)	str_to_u64(x)
+
+#define FADUMP_CRASH_INFO_MAGIC		STR_TO_HEX("FADMPINF")
+
+/* fadump crash info structure */
+struct fadump_crash_info_header {
+	u64		magic_number;
+	u64		elfcorehdr_addr;
+};
+
+/* Crash memory ranges */
+#define INIT_CRASHMEM_RANGES	(INIT_MEMBLOCK_REGIONS + 2)
+
+struct fad_crash_memory_ranges {
+	unsigned long long	base;
+	unsigned long long	size;
+};
+
 extern int early_init_dt_scan_fw_dump(unsigned long node,
 		const char *uname, int depth, void *data);
 extern int fadump_reserve_mem(void);
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 5a1b304..9650e23 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/crash_dump.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -52,6 +53,9 @@ static struct fw_dump fw_dump;
 static struct fadump_mem_struct fdm;
 static const struct fadump_mem_struct *fdm_active;
 
+struct fad_crash_memory_ranges crash_memory_ranges[INIT_CRASHMEM_RANGES];
+int crash_mem_ranges;
+
 /* Scan the Firmware Assisted dump configuration details. */
 int __init early_init_dt_scan_fw_dump(unsigned long node,
 			const char *uname, int depth, void *data)
@@ -237,6 +241,10 @@ static unsigned long get_dump_area_size(void)
 	size += fw_dump.cpu_state_data_size;
 	size += fw_dump.hpte_region_size;
 	size += fw_dump.boot_memory_size;
+	size += sizeof(struct fadump_crash_info_header);
+	size += sizeof(struct elfhdr); /* ELF core header.*/
+	/* Program headers for crash memory regions. */
+	size += sizeof(struct elf_phdr) * (memblock_num_regions(memory) + 2);
 
 	size = PAGE_ALIGN(size);
 	return size;
@@ -302,6 +310,12 @@ int __init fadump_reserve_mem(void)
 				"for saving crash dump\n",
 				(unsigned long)(size >> 20),
 				(unsigned long)(base >> 20));
+
+		fw_dump.fadumphdr_addr =
+				fdm_active->rmr_region.destination_address +
+				fdm_active->rmr_region.source_len;
+		pr_debug("fadumphdr_addr = %p\n",
+				(void *) fw_dump.fadumphdr_addr);
 	} else {
 		/* Reserve the memory at the top of memory. */
 		size = get_dump_area_size();
@@ -382,8 +396,181 @@ static void register_fw_dump(struct fadump_mem_struct *fdm)
 	}
 }
 
+/*
+ * Validate and process the dump data stored by firmware before exporting
+ * it through '/proc/vmcore'.
+ */
+static int __init process_fadump(const struct fadump_mem_struct *fdm_active)
+{
+	struct fadump_crash_info_header *fdh;
+
+	if (!fdm_active || !fw_dump.fadumphdr_addr)
+		return -EINVAL;
+
+	/* Check if the dump data is valid. */
+	if ((fdm_active->header.dump_status_flag == FADUMP_ERROR_FLAG) ||
+			(fdm_active->rmr_region.error_flags != 0)) {
+		printk(KERN_ERR "Dump taken by platform is not valid\n");
+		return -EINVAL;
+	}
+	if (fdm_active->rmr_region.bytes_dumped !=
+			fdm_active->rmr_region.source_len) {
+		printk(KERN_ERR "Dump taken by platform is incomplete\n");
+		return -EINVAL;
+	}
+
+	/* Validate the fadump crash info header */
+	fdh = __va(fw_dump.fadumphdr_addr);
+	if (fdh->magic_number != FADUMP_CRASH_INFO_MAGIC) {
+		printk(KERN_ERR "Crash info header is not valid.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * We are done validating dump info and elfcore header is now ready
+	 * to be exported. set elfcorehdr_addr so that vmcore module will
+	 * export the elfcore header through '/proc/vmcore'.
+	 */
+	elfcorehdr_addr = fdh->elfcorehdr_addr;
+
+	return 0;
+}
+
+static inline void add_crash_memory(unsigned long long base,
+					unsigned long long end)
+{
+	if (base == end)
+		return;
+
+	pr_debug("crash_memory_range[%d] [%#016llx-%#016llx], %#llx bytes\n",
+		crash_mem_ranges, base, end - 1, (end - base));
+	crash_memory_ranges[crash_mem_ranges].base = base;
+	crash_memory_ranges[crash_mem_ranges].size = end - base;
+	crash_mem_ranges++;
+}
+
+static void exclude_reserved_area(unsigned long long start,
+					unsigned long long end)
+{
+	unsigned long long ra_start, ra_end;
+
+	ra_start = fw_dump.reserve_dump_area_start;
+	ra_end = ra_start + fw_dump.reserve_dump_area_size;
+
+	if ((ra_start < end) && (ra_end > start)) {
+		if ((start < ra_start) && (end > ra_end)) {
+			add_crash_memory(start, ra_start);
+			add_crash_memory(ra_end, end);
+		} else if (start < ra_start) {
+			add_crash_memory(start, ra_start);
+		} else if (ra_end < end) {
+			add_crash_memory(ra_end, end);
+		}
+	} else
+		add_crash_memory(start, end);
+}
+
+/*
+ * Traverse through memblock structure and setup crash memory ranges. These
+ * ranges will be used create PT_LOAD program headers in elfcore header.
+ */
+static void setup_crash_memory_ranges(void)
+{
+	struct memblock_region *reg;
+	unsigned long long start, end;
+
+	pr_debug("Setup crash memory ranges.\n");
+	crash_mem_ranges = 0;
+	/*
+	 * add the first memory chunk (RMR_START through boot_memory_size) as
+	 * a separate memory chunk. The reason is, at the time crash firmware
+	 * will move the content of this memory chunk to different location
+	 * specified during fadump registration. We need to create a separate
+	 * program header for this chunk with the correct offset.
+	 */
+	add_crash_memory(RMR_START, fw_dump.boot_memory_size);
+
+	for_each_memblock(memory, reg) {
+		start = (unsigned long long)reg->base;
+		end = start + (unsigned long long)reg->size;
+		if (start == RMR_START && end >= fw_dump.boot_memory_size)
+			start = fw_dump.boot_memory_size;
+
+		/* add this range excluding the reserved dump area. */
+		exclude_reserved_area(start, end);
+	}
+}
+
+static int create_elfcore_headers(char *bufp)
+{
+	struct elfhdr *elf;
+	struct elf_phdr *phdr;
+	int i;
+
+	init_elfcore_header(bufp);
+	elf = (struct elfhdr *)bufp;
+	bufp += sizeof(struct elfhdr);
+
+	/* setup PT_LOAD sections. */
+
+	for (i = 0; i < crash_mem_ranges; i++) {
+		unsigned long long mbase, msize;
+		mbase = crash_memory_ranges[i].base;
+		msize = crash_memory_ranges[i].size;
+
+		if (!msize)
+			continue;
+
+		phdr = (struct elf_phdr *)bufp;
+		bufp += sizeof(struct elf_phdr);
+		phdr->p_type	= PT_LOAD;
+		phdr->p_flags	= PF_R|PF_W|PF_X;
+		phdr->p_offset	= mbase;
+
+		if (mbase == RMR_START) {
+			/*
+			 * The entire RMR region will be moved by firmware
+			 * to the specified destination_address. Hence set
+			 * the correct offset.
+			 */
+			phdr->p_offset = fdm.rmr_region.destination_address;
+		}
+
+		phdr->p_paddr = mbase;
+		phdr->p_vaddr = (unsigned long)__va(mbase);
+		phdr->p_filesz = msize;
+		phdr->p_memsz = msize;
+		phdr->p_align = 0;
+
+		/* Increment number of program headers. */
+		(elf->e_phnum)++;
+	}
+	return 0;
+}
+
+static unsigned long init_fadump_header(unsigned long addr)
+{
+	struct fadump_crash_info_header *fdh;
+
+	if (!addr)
+		return 0;
+
+	fw_dump.fadumphdr_addr = addr;
+	fdh = __va(addr);
+	addr += sizeof(struct fadump_crash_info_header);
+
+	memset(fdh, 0, sizeof(struct fadump_crash_info_header));
+	fdh->magic_number = FADUMP_CRASH_INFO_MAGIC;
+	fdh->elfcorehdr_addr = addr;
+
+	return addr;
+}
+
 static void register_fadump(void)
 {
+	unsigned long addr;
+	void *vaddr;
+
 	/*
 	 * If no memory is reserved then we can not register for firmware-
 	 * assisted dump.
@@ -391,8 +578,17 @@ static void register_fadump(void)
 	if (!fw_dump.reserve_dump_area_size)
 		return;
 
+	setup_crash_memory_ranges();
+
 	/* Initialize the kernel dump memory structure for FAD registration. */
-	init_fadump_mem_struct(&fdm, fw_dump.reserve_dump_area_start);
+	addr = init_fadump_mem_struct(&fdm, fw_dump.reserve_dump_area_start);
+
+	/* Initialize fadump crash info header. */
+	addr = init_fadump_header(addr);
+	vaddr = __va(addr);
+
+	pr_debug("Creating ELF core headers at %#016lx\n", addr);
+	create_elfcore_headers(vaddr);
 
 	/* register the future kernel dump with firmware. */
 	register_fw_dump(&fdm);
@@ -507,9 +703,19 @@ int __init setup_fadump(void)
 	}
 
 	fadump_show_config();
+
+	/*
+	 * If dump data is available then see if it is valid and prepare for
+	 * saving it to the disk.
+	 */
+	if (fw_dump.dump_active) {
+		process_fadump(fdm_active);
+		goto out;
+	}
+
 	register_fadump();
+out:
 	fadump_init_files();
-
 	return 1;
 }
 subsys_initcall(setup_fadump);
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 7405407..14627d4 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -13,6 +13,7 @@ extern unsigned long long elfcorehdr_addr;
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+extern int init_elfcore_header(char *);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 7525e38..63ae7a0 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -152,6 +152,7 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
 	     region++)
 
+#define memblock_num_regions(memblock_type)	(memblock.memblock_type.cnt)
 
 #ifdef ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __init
diff --git a/kernel/crash_dump.c b/kernel/crash_dump.c
index 5f85690..ce93529 100644
--- a/kernel/crash_dump.c
+++ b/kernel/crash_dump.c
@@ -4,6 +4,10 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 
+#ifndef ELF_CORE_EFLAGS
+#define ELF_CORE_EFLAGS 0
+#endif
+
 /*
  * If we have booted due to a crash, max_pfn will be a very low value. We need
  * to know the amount of memory that the previous kernel used.
@@ -32,3 +36,32 @@ static int __init setup_elfcorehdr(char *arg)
 	return end > arg ? 0 : -EINVAL;
 }
 early_param("elfcorehdr", setup_elfcorehdr);
+
+int init_elfcore_header(char *bufp)
+{
+	struct elfhdr *elf;
+
+	elf = (struct elfhdr *) bufp;
+	bufp += sizeof(struct elfhdr);
+	memcpy(elf->e_ident, ELFMAG, SELFMAG);
+	elf->e_ident[EI_CLASS]	= ELF_CLASS;
+	elf->e_ident[EI_DATA]	= ELF_DATA;
+	elf->e_ident[EI_VERSION] = EV_CURRENT;
+	elf->e_ident[EI_OSABI] = ELF_OSABI;
+	memset(elf->e_ident+EI_PAD, 0, EI_NIDENT-EI_PAD);
+	elf->e_type	= ET_CORE;
+	elf->e_machine	= ELF_ARCH;
+	elf->e_version	= EV_CURRENT;
+	elf->e_entry	= 0;
+	elf->e_phoff	= sizeof(struct elfhdr);
+	elf->e_shoff	= 0;
+	elf->e_flags	= ELF_CORE_EFLAGS;
+	elf->e_ehsize	= sizeof(struct elfhdr);
+	elf->e_phentsize = sizeof(struct elf_phdr);
+	elf->e_phnum	= 0;
+	elf->e_shentsize = 0;
+	elf->e_shnum	= 0;
+	elf->e_shstrndx	= 0;
+
+	return 0;
+}

