Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1G0M6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:58:49 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:50234 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1G0M6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:58:19 -0400
Message-Id: <20110727125808.974305666@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jul 2011 14:55:14 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 10/10] kexec-tools: Add s390 kdump support
References: <20110727125504.491183728@linux.vnet.ibm.com>
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
 include/elf.h                        |    8 +++-
 kexec/arch/s390/Makefile             |    1 
 kexec/arch/s390/crashdump-s390.c     |   59 +++++++++++++++++++++++++++++++
 kexec/arch/s390/kexec-elf-rel-s390.c |   66 ++++++++++++++++++++++++++++++-----
 kexec/arch/s390/kexec-image.c        |   61 ++++++++++++++++++++++----------
 kexec/arch/s390/kexec-s390.c         |   66 ++++++++++++++++++++++++-----------
 kexec/arch/s390/kexec-s390.h         |    7 +++
 purgatory/arch/s390/Makefile         |    4 +-
 purgatory/arch/s390/console-s390.c   |   14 +++++++
 purgatory/arch/s390/purgatory-s390.c |   17 +++++++++
 purgatory/arch/s390/setup-s390.S     |   35 ++++++++++++++++++
 11 files changed, 290 insertions(+), 48 deletions(-)

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
@@ -0,0 +1,59 @@
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
+	unsigned long bufsz, elfcorehdr, elfcorehdr_size, addr, crash_size;
+	static struct memory_range crash_memory_range[MAX_MEMORY_RANGES];
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
+		    return -1;
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
+			   purgatory_size, 0, ULONG_MAX, -1, 0);
+	addr = crash_base + 0x10010;
+	elf_rel_set_symbol(&info->rhdr, "kdump_psw_addr", &addr, sizeof(addr));
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
@@ -18,20 +18,34 @@
 #include <unistd.h>
 #include <getopt.h>
 #include "../../kexec.h"
+#include "../../kexec-syscall.h"
+#include "../../kexec/crashdump.h"
 #include "kexec-s390.h"
+#include "elf.h"
 #include <arch/options.h>
 
+static char command_line[COMMAND_LINESIZE];
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
+	uint64_t crash_base, crash_end;
 	int opt;
 
 	static const struct option options[] =
@@ -44,9 +58,9 @@ image_s390_load(int argc, char **argv, c
 	static const char short_options[] = KEXEC_OPT_STR "";
 
 	ramdisk = NULL;
-	command_line = NULL;
 	ramdisk_len = 0;
 	ramdisk_origin = 0;
+	crash_base = 0;
 
 	while ((opt = getopt_long(argc,argv,short_options,options,0)) != -1) {
 		switch(opt) {
@@ -55,7 +69,8 @@ image_s390_load(int argc, char **argv, c
 			return -1;
 			break;
 		case OPT_APPEND:
-			command_line = optarg;
+			if (command_line_add(optarg))
+				return -1;
 			break;
 		case OPT_RAMDISK:
 			ramdisk = optarg;
@@ -63,18 +78,16 @@ image_s390_load(int argc, char **argv, c
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
 	add_segment(info, kernel_buf + IMAGE_READ_OFFSET,
-		    kernel_size - IMAGE_READ_OFFSET, IMAGE_READ_OFFSET,
+		    kernel_size - IMAGE_READ_OFFSET,
+		    crash_base + IMAGE_READ_OFFSET,
 		    kernel_size - IMAGE_READ_OFFSET);
 
 	/* We do want to change the kernel image */
@@ -88,10 +101,18 @@ image_s390_load(int argc, char **argv, c
 			return -1;
 		}
 		ramdisk_origin = RAMDISK_ORIGIN_ADDR;
-		add_segment(info, rd_buffer, ramdisk_len, RAMDISK_ORIGIN_ADDR, ramdisk_len);
+		add_segment(info, rd_buffer, ramdisk_len,
+			    crash_base + RAMDISK_ORIGIN_ADDR, ramdisk_len);
 	}
 	
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
 
@@ -100,19 +121,23 @@ image_s390_load(int argc, char **argv, c
 
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
+		if((memcmp(str,sys_ram,strlen(sys_ram)) == 0) ||
+		   (with_crashk &&
+		    memcmp(str,crash_kernel,strlen(crash_kernel)) == 0)) {
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
+
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
 
+int get_memory_ranges(struct memory_range **range, int *ranges,
+		      unsigned long flags)
+{
+	uint64_t start, end;
+
+	if (get_memory_ranges_s390(memory_range, ranges,
+				   flags & KEXEC_ON_CRASH))
+	    	return -1;
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
@@ -15,11 +15,18 @@
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
+extern int load_crashdump_segments(struct kexec_info *info, unsigned long crash_base, unsigned long crash_end);
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
@@ -0,0 +1,17 @@
+/*
+ * S390 purgatory
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+unsigned long kdump_psw_addr = 0;
+
+void setup_arch(void)
+{
+}
+
+void post_verification_setup_arch(void)
+{
+}
--- /dev/null
+++ b/purgatory/arch/s390/setup-s390.S
@@ -0,0 +1,35 @@
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
+	larl	%r15,lstack
+	brasl	%r14,purgatory
+	larl    %r14,kdump_psw_addr
+	lg	%r4,0(%r14)
+	larl    %r14,kdump_psw
+	stg	%r4,8(%r14)
+	lpswe	0(%r14)
+
+	.section ".data"
+	.balign 16
+kdump_psw:
+	.quad 0x0000000180000000
+	.quad 0x0000000000000000
+
+	.bss
+	.balign 4096
+lstack:
+	.skip 4096
+lstack_end:
+#else
+0:	j	0
+#endif

