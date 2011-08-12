Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1HLNtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:49:35 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52736 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1HLNtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:49:25 -0400
Message-Id: <20110812134907.971000326@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 12 Aug 2011 15:48:56 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v3 7/8] kexec-tools: Add s390 kdump support
References: <20110812134849.748973593@linux.vnet.ibm.com>
Content-Disposition: inline; filename=kexec-tools-s390-kdump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch adds kdump support for s390 to the kexec tool and enables the
"--load-panic" option. When loading the kdump kernel and ramdisk we add the
address of the crashkernel memory to the normal load address.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/elf.h                        |    8 ++-
 kexec/arch/s390/Makefile             |    1 
 kexec/arch/s390/crashdump-s390.c     |   62 +++++++++++++++++++++++
 kexec/arch/s390/kexec-elf-rel-s390.c |   66 +++++++++++++++++++++---
 kexec/arch/s390/kexec-image.c        |   69 ++++++++++++++++++-------
 kexec/arch/s390/kexec-s390.c         |   66 +++++++++++++++++-------
 kexec/arch/s390/kexec-s390.h         |    9 +++
 purgatory/arch/s390/Makefile         |    4 +
 purgatory/arch/s390/console-s390.c   |   14 +++++
 purgatory/arch/s390/purgatory-s390.c |   93 +++++++++++++++++++++++++++++++++++
 purgatory/arch/s390/setup-s390.S     |   33 ++++++++++++
 11 files changed, 376 insertions(+), 49 deletions(-)

--- a/include/elf.h
+++ b/include/elf.h
@@ -2304,9 +2304,13 @@ typedef Elf32_Addr Elf32_Conflict;
 #define R_390_TLS_DTPOFF	55	/* Offset in TLS block.	 */
 #define R_390_TLS_TPOFF		56	/* Negated offset in static TLS
 					   block.  */
-
+#define R_390_20		57	/* Direct 20 bit.  */
+#define R_390_GOT20		58	/* 20 bit GOT offset.  */
+#define R_390_GOTPLT20		59	/* 20 bit offset to jump slot.  */
+#define R_390_TLS_GOTIE20	60	/* 20 bit GOT offset for static TLS
+					   block offset.  */
 /* Keep this the last entry.  */
-#define R_390_NUM		57
+#define R_390_NUM		61
 
 /* CRIS relocations.  */
 #define R_CRIS_NONE		0
--- a/kexec/arch/s390/Makefile
+++ b/kexec/arch/s390/Makefile
@@ -4,6 +4,7 @@
 s390_KEXEC_SRCS =  kexec/arch/s390/kexec-s390.c
 s390_KEXEC_SRCS += kexec/arch/s390/kexec-image.c
 s390_KEXEC_SRCS += kexec/arch/s390/kexec-elf-rel-s390.c
+s390_KEXEC_SRCS += kexec/arch/s390/crashdump-s390.c
 
 dist += kexec/arch/s390/Makefile $(s390_KEXEC_SRCS)			\
 	kexec/arch/s390/kexec-s390.h					\
--- /dev/null
+++ b/kexec/arch/s390/crashdump-s390.c
@@ -0,0 +1,62 @@
+/*
+ * kexec/arch/s390/crashdump-s390.c
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <elf.h>
+#include <limits.h>
+#include "../../kexec.h"
+#include "../../kexec-syscall.h"
+#include "../../kexec/crashdump.h"
+#include "kexec-s390.h"
+
+/*
+ * Load additional segments for kdump kernel
+ */
+int load_crashdump_segments(struct kexec_info *info, unsigned long crash_base,
+			    unsigned long crash_end)
+{
+	static struct memory_range crash_memory_range[MAX_MEMORY_RANGES];
+	unsigned long bufsz, elfcorehdr, elfcorehdr_size, crash_size;
+	struct crash_elf_info elf_info;
+	char str[COMMAND_LINESIZE];
+	int ranges;
+	void *tmp;
+
+	crash_size = crash_end - crash_base + 1;
+	memset(&elf_info, 0, sizeof(elf_info));
+
+	elf_info.data = ELFDATA2MSB;
+	elf_info.machine = EM_S390;
+	elf_info.class = ELFCLASS64;
+	elf_info.get_note_info = get_crash_notes_per_cpu;
+
+	if (get_memory_ranges_s390(crash_memory_range, &ranges, 0))
+		return -1;
+
+	if (crash_create_elf64_headers(info, &elf_info, crash_memory_range,
+				       ranges, &tmp, &bufsz,
+				       ELF_CORE_HEADER_ALIGN))
+		return -1;
+
+	elfcorehdr = add_buffer(info, tmp, bufsz, bufsz, 1024,
+				crash_base, crash_end, -1);
+	elfcorehdr_size = bufsz;
+	elf_rel_build_load(info, &info->rhdr, (const char *) purgatory,
+			   purgatory_size, crash_base + 0x2000,
+			   crash_base + 0x10000, -1, 0);
+	elf_rel_set_symbol(&info->rhdr, "crash_base", &crash_base,
+			   sizeof(crash_base));
+	elf_rel_set_symbol(&info->rhdr, "crash_size", &crash_size,
+			   sizeof(crash_size));
+	info->entry = (void *) elf_rel_get_addr(&info->rhdr, "purgatory_start");
+	snprintf(str, sizeof(str), " elfcorehdr=%ld@%ldK\n",
+		 elfcorehdr_size, elfcorehdr / 1024);
+	command_line_add(str);
+	return 0;
+}
--- a/kexec/arch/s390/kexec-elf-rel-s390.c
+++ b/kexec/arch/s390/kexec-elf-rel-s390.c
@@ -1,7 +1,7 @@
 /*
  * kexec/arch/s390/kexec-elf-rel-s390.c
  *
- * (C) Copyright IBM Corp. 2005
+ * Copyright IBM Corp. 2005,2011
  *
  * Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
  *
@@ -12,15 +12,65 @@
 #include "../../kexec.h"
 #include "../../kexec-elf.h"
 
-int machine_verify_elf_rel(struct mem_ehdr *UNUSED(ehdr))
+int machine_verify_elf_rel(struct mem_ehdr *ehdr)
 {
-	return 0;
+	if (ehdr->ei_data != ELFDATA2MSB)
+		return 0;
+	if (ehdr->ei_class != ELFCLASS64)
+		return 0;
+	if (ehdr->e_machine != EM_S390)
+		return 0;
+	return 1;
 }
 
-void machine_apply_elf_rel(struct mem_ehdr *UNUSED(ehdr),
-			   unsigned long UNUSED(r_type),
-			   void *UNUSED(location),
-			   unsigned long UNUSED(address),
-			   unsigned long UNUSED(value))
+void machine_apply_elf_rel(struct mem_ehdr *ehdr,
+			   unsigned long r_type,
+			   void *loc,
+			   unsigned long address,
+			   unsigned long val)
 {
+	switch (r_type) {
+	case R_390_8:		/* Direct 8 bit.   */
+	case R_390_12:		/* Direct 12 bit.  */
+	case R_390_16:		/* Direct 16 bit.  */
+	case R_390_20:		/* Direct 20 bit.  */
+	case R_390_32:		/* Direct 32 bit.  */
+	case R_390_64:		/* Direct 64 bit.  */
+		if (r_type == R_390_8)
+			*(unsigned char *) loc = val;
+		else if (r_type == R_390_12)
+			*(unsigned short *) loc = (val & 0xfff) |
+				(*(unsigned short *) loc & 0xf000);
+		else if (r_type == R_390_16)
+			*(unsigned short *) loc = val;
+		else if (r_type == R_390_20)
+			*(unsigned int *) loc =
+				(*(unsigned int *) loc & 0xf00000ff) |
+				(val & 0xfff) << 16 | (val & 0xff000) >> 4;
+		else if (r_type == R_390_32)
+			*(unsigned int *) loc = val;
+		else if (r_type == R_390_64)
+			*(unsigned long *) loc = val;
+		break;
+	case R_390_PC16:	/* PC relative 16 bit.  */
+	case R_390_PC16DBL:	/* PC relative 16 bit shifted by 1.  */
+	case R_390_PC32DBL:	/* PC relative 32 bit shifted by 1.  */
+	case R_390_PC32:	/* PC relative 32 bit.  */
+	case R_390_PC64:	/* PC relative 64 bit.	*/
+		val -= address;
+		if (r_type == R_390_PC16)
+			*(unsigned short *) loc = val;
+		else if (r_type == R_390_PC16DBL)
+			*(unsigned short *) loc = val >> 1;
+		else if (r_type == R_390_PC32DBL)
+			*(unsigned int *) loc = val >> 1;
+		else if (r_type == R_390_PC32)
+			*(unsigned int *) loc = val;
+		else if (r_type == R_390_PC64)
+			*(unsigned long *) loc = val;
+		break;
+	default:
+		die("Unknown rela relocation: 0x%lx 0x%lx\n", r_type, address);
+		break;
+	}
 }
--- a/kexec/arch/s390/kexec-image.c
+++ b/kexec/arch/s390/kexec-image.c
@@ -18,18 +18,41 @@
 #include <unistd.h>
 #include <getopt.h>
 #include "../../kexec.h"
+#include "../../kexec-syscall.h"
+#include "../../kexec/crashdump.h"
 #include "kexec-s390.h"
+#include "elf.h"
 #include <arch/options.h>
 
+static uint64_t crash_base, crash_end;
+static char command_line[COMMAND_LINESIZE];
+
+static void add_segment_check(struct kexec_info *info, const void *buf,
+			      size_t bufsz, unsigned long base, size_t memsz)
+{
+	if (info->kexec_flags & KEXEC_ON_CRASH)
+		if (base + memsz > crash_end - crash_base)
+			die("Not enough crashkernel memory to load segments\n");
+	add_segment(info, buf, bufsz, crash_base + base, memsz);
+}
+
+int command_line_add(const char *str)
+{
+	if (strlen(command_line) + strlen(str) + 1 > COMMAND_LINESIZE) {
+		fprintf(stderr, "Command line too long.\n");
+		return -1;
+	}
+	strcat(command_line, str);
+	return 0;
+}
+
 int
 image_s390_load(int argc, char **argv, const char *kernel_buf,
 		off_t kernel_size, struct kexec_info *info)
 {
 	void *krnl_buffer;
 	char *rd_buffer;
-	const char *command_line;
 	const char *ramdisk;
-	int command_line_len;
 	off_t ramdisk_len;
 	unsigned int ramdisk_origin;
 	int opt;
@@ -44,7 +67,6 @@ image_s390_load(int argc, char **argv, c
 	static const char short_options[] = KEXEC_OPT_STR "";
 
 	ramdisk = NULL;
-	command_line = NULL;
 	ramdisk_len = 0;
 	ramdisk_origin = 0;
 
@@ -55,7 +77,8 @@ image_s390_load(int argc, char **argv, c
 			return -1;
 			break;
 		case OPT_APPEND:
-			command_line = optarg;
+			if (command_line_add(optarg))
+				return -1;
 			break;
 		case OPT_RAMDISK:
 			ramdisk = optarg;
@@ -63,17 +86,14 @@ image_s390_load(int argc, char **argv, c
 		}
 	}
 
-	/* Process a given command_line: */
-	if (command_line) {
-		command_line_len = strlen(command_line) + 1; /* Remember the '\0' */
-		if (command_line_len > COMMAND_LINESIZE) {
-		        fprintf(stderr, "Command line too long.\n");
+	if (info->kexec_flags & KEXEC_ON_CRASH) {
+		if (parse_iomem_single("Crash kernel\n", &crash_base,
+				       &crash_end))
 			return -1;
-		}
 	}
 
 	/* Add kernel segment */
-	add_segment(info, kernel_buf + IMAGE_READ_OFFSET,
+	add_segment_check(info, kernel_buf + IMAGE_READ_OFFSET,
 		    kernel_size - IMAGE_READ_OFFSET, IMAGE_READ_OFFSET,
 		    kernel_size - IMAGE_READ_OFFSET);
 
@@ -88,10 +108,17 @@ image_s390_load(int argc, char **argv, c
 			return -1;
 		}
 		ramdisk_origin = RAMDISK_ORIGIN_ADDR;
-		add_segment(info, rd_buffer, ramdisk_len, RAMDISK_ORIGIN_ADDR, ramdisk_len);
+		add_segment_check(info, rd_buffer, ramdisk_len,
+				  RAMDISK_ORIGIN_ADDR, ramdisk_len);
 	}
-	
-	/* Register the ramdisk in the kernel. */
+	if (info->kexec_flags & KEXEC_ON_CRASH) {
+		if (load_crashdump_segments(info, crash_base, crash_end))
+			return -1;
+	} else {
+		info->entry = (void *) IMAGE_READ_OFFSET;
+	}
+
+	/* Register the ramdisk and crashkernel memory in the kernel. */
 	{
 		unsigned long long *tmp;
 
@@ -100,19 +127,23 @@ image_s390_load(int argc, char **argv, c
 
 		tmp = krnl_buffer + INITRD_SIZE_OFFS;
 		*tmp = (unsigned long long) ramdisk_len;
-	}
 
+		if (info->kexec_flags & KEXEC_ON_CRASH) {
+			tmp = krnl_buffer + OLDMEM_BASE_OFFS;
+			*tmp = crash_base;
+
+			tmp = krnl_buffer + OLDMEM_SIZE_OFFS;
+			*tmp = crash_end - crash_base + 1;
+		}
+	}
 	/*
 	 * We will write a probably given command line.
 	 * First, erase the old area, then setup the new parameters:
 	 */
-	if (command_line) {
+	if (strlen(command_line) != 0) {
 		memset(krnl_buffer + COMMAND_LINE_OFFS, 0, COMMAND_LINESIZE);
 		memcpy(krnl_buffer + COMMAND_LINE_OFFS, command_line, strlen(command_line));
 	}
-
-	info->entry = (void *) IMAGE_READ_OFFSET;
-
 	return 0;
 }
 
--- a/kexec/arch/s390/kexec-s390.c
+++ b/kexec/arch/s390/kexec-s390.c
@@ -1,9 +1,10 @@
 /*
  * kexec/arch/s390/kexec-s390.c
  *
- * (C) Copyright IBM Corp. 2005
+ * Copyright IBM Corp. 2005,2011
  *
  * Author(s): Rolf Adelsberger <adelsberger@de.ibm.com>
+ *            Michael Holzheu <holzheu@linux.vnet.ibm.com>
  *
  */
 
@@ -19,26 +20,16 @@
 #include "kexec-s390.h"
 #include <arch/options.h>
 
-#define MAX_MEMORY_RANGES 64
 static struct memory_range memory_range[MAX_MEMORY_RANGES];
 
 /*
- * get_memory_ranges:
- *  Return a list of memory ranges by parsing the file returned by
- *  proc_iomem()
- *
- * INPUT:
- *  - Pointer to an array of memory_range structures.
- *  - Pointer to an integer with holds the number of memory ranges.
- *
- * RETURN:
- *  - 0 on normal execution.
- *  - (-1) if something went wrong.
+ * Get memory ranges of type "System RAM" from /proc/iomem. If with_crashk=1
+ * then also type "Crash kernel" is added.
  */
-
-int get_memory_ranges(struct memory_range **range, int *ranges,
-		      unsigned long UNUSED(flags))
+int get_memory_ranges_s390(struct memory_range memory_range[], int *ranges,
+			   int with_crashk)
 {
+	char crash_kernel[] = "Crash kernel\n";
 	char sys_ram[] = "System RAM\n";
 	const char *iomem = proc_iomem();
 	FILE *fp;
@@ -62,7 +53,9 @@ int get_memory_ranges(struct memory_rang
 
 		sscanf(line,"%Lx-%Lx : %n", &start, &end, &cons);
 		str = line+cons;
-		if(memcmp(str,sys_ram,strlen(sys_ram)) == 0) {
+		if ((memcmp(str, sys_ram, strlen(sys_ram)) == 0) ||
+		    (memcmp(str, crash_kernel, strlen(crash_kernel)) == 0) &&
+		     with_crashk) {
 			memory_range[current_range].start = start;
 			memory_range[current_range].end = end;
 			memory_range[current_range].type = RANGE_RAM;
@@ -73,9 +66,41 @@ int get_memory_ranges(struct memory_rang
 		}
 	}
 	fclose(fp);
-	*range = memory_range;
 	*ranges = current_range;
+	return 0;
+}
 
+/*
+ * get_memory_ranges:
+ *  Return a list of memory ranges by parsing the file returned by
+ *  proc_iomem()
+ *
+ * INPUT:
+ *  - Pointer to an array of memory_range structures.
+ *  - Pointer to an integer with holds the number of memory ranges.
+ *
+ * RETURN:
+ *  - 0 on normal execution.
+ *  - (-1) if something went wrong.
+ */
+
+int get_memory_ranges(struct memory_range **range, int *ranges,
+		      unsigned long flags)
+{
+	uint64_t start, end;
+
+	if (get_memory_ranges_s390(memory_range, ranges,
+				   flags & KEXEC_ON_CRASH))
+		return -1;
+	*range = memory_range;
+	if ((flags & KEXEC_ON_CRASH) && !(flags & KEXEC_PRESERVE_CONTEXT)) {
+		if (parse_iomem_single("Crash kernel\n", &start, &end))
+			return -1;
+		if (start > mem_min)
+			mem_min = start;
+		if (end < mem_max)
+			mem_max = end;
+	}
 	return 0;
 }
 
@@ -112,5 +137,8 @@ void arch_update_purgatory(struct kexec_
 
 int is_crashkernel_mem_reserved(void)
 {
-	return 0; /* kdump is not supported on this platform (yet) */
+	uint64_t start, end;
+
+	return parse_iomem_single("Crash kernel\n", &start, &end) == 0 ?
+		(start != end) : 0;
 }
--- a/kexec/arch/s390/kexec-s390.h
+++ b/kexec/arch/s390/kexec-s390.h
@@ -15,11 +15,20 @@
 #define RAMDISK_ORIGIN_ADDR   0x800000
 #define INITRD_START_OFFS     0x408
 #define INITRD_SIZE_OFFS      0x410
+#define OLDMEM_BASE_OFFS      0x418
+#define OLDMEM_SIZE_OFFS      0x420
 #define COMMAND_LINE_OFFS     0x480
 #define COMMAND_LINESIZE      896
+#define MAX_MEMORY_RANGES     64
 
 extern int image_s390_load(int, char **, const char *, off_t, struct kexec_info *);
 extern int image_s390_probe(const char *, off_t);
 extern void image_s390_usage(void);
+extern int load_crashdump_segments(struct kexec_info *info,
+				   unsigned long crash_base,
+				   unsigned long crash_end);
+extern int get_memory_ranges_s390(struct memory_range range[], int *ranges,
+				  int with_crashk);
+extern int command_line_add(const char *str);
 
 #endif /* KEXEC_IA64_H */
--- a/purgatory/arch/s390/Makefile
+++ b/purgatory/arch/s390/Makefile
@@ -2,7 +2,9 @@
 # Purgatory s390
 #
 
-s390_PURGATORY_SRCS =
+s390_PURGATORY_SRCS += purgatory/arch/s390/console-s390.c
+s390_PURGATORY_SRCS += purgatory/arch/s390/setup-s390.S
+s390_PURGATORY_SRCS += purgatory/arch/s390/purgatory-s390.c
 
 dist += purgatory/arch/s390/Makefile $(s390_PURGATORY_SRCS)
 
--- /dev/null
+++ b/purgatory/arch/s390/console-s390.c
@@ -0,0 +1,14 @@
+/*
+ * S390 console code (currently not implemented)
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <purgatory.h>
+#include "unused.h"
+
+void putchar(int UNUSED(ch))
+{
+}
--- /dev/null
+++ b/purgatory/arch/s390/purgatory-s390.c
@@ -0,0 +1,93 @@
+/*
+ * S390 purgatory
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <stdint.h>
+#include <stddef.h>
+#include <string.h>
+#include "../../../kexec/kexec-sha256.h"
+
+#define MIN(x, y) ((x) < (y) ? (x) : (y))
+#define MAX(x, y) ((x) > (y) ? (x) : (y))
+
+extern struct sha256_region sha256_regions[SHA256_REGIONS];
+
+unsigned long crash_base = (unsigned long) -1;
+unsigned long crash_size = (unsigned long) -1;
+
+/*
+ * Implement memcpy using the mvcle instruction
+ */
+static void memcpy_fast(void *target, void *src, unsigned long size)
+{
+	register unsigned long __target asm("2") = (unsigned long) target;
+	register unsigned long __size1 asm("3") = size;
+	register unsigned long __src asm("4") = (unsigned long) src;
+	register unsigned long __size2 asm("5") = size;
+
+	asm volatile (
+		"0:	mvcle	%0,%2,0\n"
+		"	jo	0b\n"
+		: "+d" (__target), "+d" (__size1), "+d" (__src), "+d" (__size2)
+		:
+		: "cc", "memory"
+	);
+}
+
+/*
+ * Swap memory areas
+ */
+static void memswap(void *addr1, void *addr2, unsigned long size)
+{
+	unsigned long off, copy_len;
+	static char buf[1024];
+
+	for (off = 0; off < size; off += sizeof(buf)) {
+		copy_len = MIN(size - off, sizeof(buf));
+		memcpy_fast(buf, (void *) addr2 + off, copy_len);
+		memcpy_fast(addr2 + off, addr1 + off, copy_len);
+		memcpy_fast(addr1 + off, buf, copy_len);
+	}
+}
+
+/*
+ * Nothing to do
+ */
+void setup_arch(void)
+{
+}
+
+/*
+ * Do swap of [crash base - crash base + size] with [0 - crash size]
+ *
+ * We swap all kexec segments except of purgatory. The rest is copied
+ * from [0 - crash size] to [crash base - crash base + size].
+ * We use [0x2000 - 0x10000] for purgatory. This area is never used
+ * by s390 Linux kernels.
+ *
+ * This functions assumes that the sha256_regions[] is sorted.
+ */
+void post_verification_setup_arch(void)
+{
+	unsigned long start, len, last = crash_base + 0x10000;
+	struct sha256_region *ptr, *end;
+
+	end = &sha256_regions[sizeof(sha256_regions)/sizeof(sha256_regions[0])];
+	for (ptr = sha256_regions; ptr < end; ptr++) {
+		if (!ptr->start)
+			continue;
+		start = MAX(ptr->start, crash_base + 0x10000);
+		len = ptr->len - (start - ptr->start);
+		memcpy_fast((void *) last, (void *) last - crash_base,
+			    start - last);
+		memswap((void *) start - crash_base, (void *) start, len);
+		last = start + len;
+	}
+	memcpy_fast((void *) last, (void *) last - crash_base,
+		    crash_base + crash_size - last);
+	memcpy_fast((void *) crash_base, (void *) 0, 0x2000);
+}
--- /dev/null
+++ b/purgatory/arch/s390/setup-s390.S
@@ -0,0 +1,33 @@
+/*
+ * Purgatory setup code
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+	.text
+	.globl purgatory_start
+	.balign 16
+purgatory_start:
+#ifdef __s390x__
+	larl	%r15,lstack_end
+	aghi	%r15,-160
+	brasl	%r14,purgatory
+	larl	%r14,kdump_psw
+	lpswe	0(%r14)
+
+	.section ".data"
+	.balign 16
+kdump_psw:
+	.quad 0x0000000180000000
+	.quad 0x0000000000010010
+
+	.bss
+	.balign 4096
+lstack:
+	.skip 4096
+lstack_end:
+#else
+0:	j	0
+#endif

