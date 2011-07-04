Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1GDRMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:12:31 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:58481 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab1GDRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:09:59 -0400
Message-Id: <20110704170959.919268183@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 04 Jul 2011 19:09:30 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, hbabu@us.ibm.com,
        mahesh@linux.vnet.ibm.com
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 8/9] s390: kdump backend code
References: <20110704170922.976299676@linux.vnet.ibm.com>
Content-Disposition: inline; filename=08-s390-kdump-arch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch provides the architecture specific part of the s390 kdump
support. This includes the following changes:
* S390 backend code for kdump/kexec framework
* New restart shutdown trigger and kdump action
* New meminfo interface to allow external kdump triggers

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/Kconfig                 |   10 
 arch/s390/include/asm/checksum.h  |   18 +
 arch/s390/include/asm/ipl.h       |    4 
 arch/s390/include/asm/kexec.h     |    3 
 arch/s390/include/asm/lowcore.h   |   62 +++++
 arch/s390/include/asm/sclp.h      |    1 
 arch/s390/include/asm/setup.h     |    5 
 arch/s390/include/asm/system.h    |    4 
 arch/s390/kernel/Makefile         |    3 
 arch/s390/kernel/asm-offsets.c    |    7 
 arch/s390/kernel/base.S           |   37 +++
 arch/s390/kernel/crash_dump.c     |   76 ++++++
 arch/s390/kernel/crash_dump_elf.c |  434 ++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/early.c          |   12 +
 arch/s390/kernel/entry.S          |   28 ++
 arch/s390/kernel/entry64.S        |   21 +
 arch/s390/kernel/head.S           |   14 +
 arch/s390/kernel/head_kdump.S     |  133 +++++++++++
 arch/s390/kernel/ipl.c            |  201 ++++++++++++++---
 arch/s390/kernel/machine_kexec.c  |  164 ++++++++++++++
 arch/s390/kernel/mem_detect.c     |   70 ++++++
 arch/s390/kernel/meminfo.c        |  132 +++++++++++
 arch/s390/kernel/reipl64.S        |   82 +++++--
 arch/s390/kernel/setup.c          |  210 ++++++++++++++++++
 arch/s390/kernel/smp.c            |   26 ++
 arch/s390/mm/maccess.c            |   83 +++++++
 arch/s390/mm/vmem.c               |    3 
 drivers/s390/char/zcore.c         |   20 -
 28 files changed, 1784 insertions(+), 79 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -567,6 +567,16 @@ config KEXEC
 	  current kernel, and to start another kernel.  It is like a reboot
 	  but is independent of hardware/microcode support.
 
+config CRASH_DUMP
+	bool "kernel crash dumps"
+	depends on 64BIT
+	help
+	  Generate crash dump after being started by kexec.
+	  Crash dump kernels are loaded in the main kernel with kexec-tools
+	  into a specially reserved region and then later executed after
+	  a crash by kdump/kexec.
+	  For more details see Documentation/kdump/kdump.txt
+
 config ZFCPDUMP
 	def_bool n
 	prompt "zfcpdump support"
--- a/arch/s390/include/asm/checksum.h
+++ b/arch/s390/include/asm/checksum.h
@@ -41,6 +41,24 @@ csum_partial(const void *buff, int len,
 }
 
 /*
+ * The same as csum_partial(), but operates on real memory
+ */
+static inline __wsum csum_partial_real(const void *buf, int len, __wsum sum)
+{
+	register unsigned long reg2 asm("2") = (unsigned long) buf;
+	register unsigned long reg3 asm("3") = (unsigned long) len;
+	unsigned long flags;
+
+	flags = __arch_local_irq_stnsm(0xf8UL);
+	asm volatile(
+		"0:	cksm	%0,%1\n"
+		"	jo	0b\n"
+		: "+d" (sum), "+d" (reg2), "+d" (reg3) : : "cc", "memory");
+	arch_local_irq_restore(flags);
+	return sum;
+}
+
+/*
  * the same as csum_partial_copy, but copies from user space.
  *
  * here even more important to align src and dst on a 32-bit (or even
--- a/arch/s390/include/asm/ipl.h
+++ b/arch/s390/include/asm/ipl.h
@@ -167,5 +167,9 @@ enum diag308_rc {
 };
 
 extern int diag308(unsigned long subcode, void *addr);
+void do_reset_diag308(void);
+void do_store_status(void);
+ssize_t crash_read_from_oldmem(void *buf, size_t count, u64 ppos, int userbuf);
+void machine_kdump(void);
 
 #endif /* _ASM_S390_IPL_H */
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -30,6 +30,9 @@
 /* Not more than 2GB */
 #define KEXEC_CONTROL_MEMORY_LIMIT (1UL<<31)
 
+/* Maximum address we can use for the crash control pages */
+#define KEXEC_CRASH_CONTROL_MEMORY_LIMIT (-1UL)
+
 /* Allocate one page for the pdp and the second for the code */
 #define KEXEC_CONTROL_PAGE_SIZE 4096
 
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -18,6 +18,45 @@ void system_call(void);
 void pgm_check_handler(void);
 void mcck_int_handler(void);
 void io_int_handler(void);
+void psw_restart_int_handler(void);
+
+/*
+ * Meminfo types: The defined numbers are ABI and must not be changed
+ */
+enum meminfo_type {
+	MEMINFO_TYPE_IPIB	= 0,
+	MEMINFO_TYPE_VMCOREINFO	= 1,
+	MEMINFO_TYPE_KDUMP_MEM	= 2,
+	MEMINFO_TYPE_KDUMP_SEGM	= 3,
+	MEMINFO_TYPE_LAST	= 4,
+};
+
+/*
+ * Meminfo flags: The flags are ABI and must not be changed
+ */
+#define MEMINFO_FLAG_ELEM_VALID	0x00000001U
+#define MEMINFO_FLAG_ELEM_IND	0x00000002U
+#define MEMINFO_FLAG_CSUM_VALID	0x00000004U
+
+struct meminfo {
+	unsigned long	addr;
+	unsigned long	size;
+	u32		csum;
+	u32		flags;
+} __packed;
+
+extern struct meminfo meminfo_array[MEMINFO_TYPE_LAST];
+
+void meminfo_init(void);
+int meminfo_csum_check(struct meminfo *meminfo, int recursive);
+void meminfo_update(enum meminfo_type type, void *buf, unsigned long size,
+		    u32 flags);
+
+#ifdef CONFIG_CRASH_DUMP
+int meminfo_old_get(enum meminfo_type type, struct meminfo *meminfo);
+extern unsigned long oldmem_base;
+extern unsigned long oldmem_size;
+#endif
 
 #ifdef CONFIG_32BIT
 
@@ -150,7 +189,14 @@ struct _lowcore {
 	 */
 	__u32	ipib;				/* 0x0e00 */
 	__u32	ipib_checksum;			/* 0x0e04 */
-	__u8	pad_0x0e08[0x0f00-0x0e08];	/* 0x0e08 */
+
+	/* 64 bit save area */
+	__u64	save_area_64;			/* 0x0e08 */
+
+	/* meminfo root */
+	struct meminfo	meminfo;		/* 0x0e10 */
+	__u32	meminfo_csum;			/* 0x0e20 */
+	__u8	pad_0x0e24[0x0f00-0x0e24];	/* 0x0e24 */
 
 	/* Extended facility list */
 	__u64	stfle_fac_list[32];		/* 0x0f00 */
@@ -286,7 +332,19 @@ struct _lowcore {
 	 */
 	__u64	ipib;				/* 0x0e00 */
 	__u32	ipib_checksum;			/* 0x0e08 */
-	__u8	pad_0x0e0c[0x0f00-0x0e0c];	/* 0x0e0c */
+
+	/* 64 bit save area */
+	__u64	save_area_64;			/* 0x0e0c */
+
+	/* meminfo root */
+	struct meminfo meminfo;			/* 0x0e14 */
+	__u32	meminfo_csum;			/* 0x0e2c */
+
+	/* oldmem base */
+	__u64	oldmem_base;			/* 0x0e30 */
+	/* oldmem size */
+	__u64	oldmem_size;			/* 0x0e38 */
+	__u8	pad_0x0e40[0x0f00-0x0e40];	/* 0x0e40 */
 
 	/* Extended facility list */
 	__u64	stfle_fac_list[32];		/* 0x0f00 */
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -55,4 +55,5 @@ int sclp_chp_deconfigure(struct chp_id c
 int sclp_chp_read_info(struct sclp_chp_info *info);
 void sclp_get_ipl_info(struct sclp_ipl_info *info);
 
+void _sclp_print_early(const char *);
 #endif /* _ASM_S390_SCLP_H */
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -35,6 +35,8 @@
 
 #define CHUNK_READ_WRITE 0
 #define CHUNK_READ_ONLY  1
+#define CHUNK_OLDMEM     4
+#define CHUNK_CRASHK     5
 
 struct mem_chunk {
 	unsigned long addr;
@@ -48,6 +50,8 @@ extern int memory_end_set;
 extern unsigned long memory_end;
 
 void detect_memory_layout(struct mem_chunk chunk[]);
+void create_mem_hole(struct mem_chunk memory_chunk[], unsigned long addr,
+		     unsigned long size, int type);
 
 #define PRIMARY_SPACE_MODE	0
 #define ACCESS_REGISTER_MODE	1
@@ -106,6 +110,7 @@ extern unsigned int user_mode;
 #endif /* __s390x__ */
 
 #define ZFCPDUMP_HSA_SIZE	(32UL<<20)
+#define ZFCPDUMP_HSA_SIZE_MAX	(64UL<<20)
 
 /*
  * Console mode. Override with conmode=
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -113,6 +113,10 @@ extern void pfault_fini(void);
 
 extern void cmma_init(void);
 extern int memcpy_real(void *, void *, size_t);
+extern int copy_to_user_real(void __user *dest, void *src, size_t count);
+extern int copy_from_user_real(void *dest, void __user *src, size_t count);
+extern void copy_to_absolute_zero(void *dest, void *src, size_t count);
+extern void copy_from_absolute_zero(void *dest, void *src, size_t count);
 
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -23,7 +23,7 @@ CFLAGS_sysinfo.o += -Iinclude/math-emu -
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o vtime.o \
 	    processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o nmi.o \
 	    debug.o irq.o ipl.o dis.o diag.o mem_detect.o sclp.o vdso.o \
-	    sysinfo.o jump_label.o
+	    sysinfo.o jump_label.o meminfo.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
@@ -48,6 +48,7 @@ obj-$(CONFIG_FUNCTION_TRACER)	+= $(if $(
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)  += ftrace.o
+obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o crash_dump_elf.o
 
 # Kexec part
 S390_KEXEC_OBJS := machine_kexec.o crash.o
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -142,6 +142,11 @@ int main(void)
 	DEFINE(__LC_FPREGS_SAVE_AREA, offsetof(struct _lowcore, floating_pt_save_area));
 	DEFINE(__LC_GPREGS_SAVE_AREA, offsetof(struct _lowcore, gpregs_save_area));
 	DEFINE(__LC_CREGS_SAVE_AREA, offsetof(struct _lowcore, cregs_save_area));
+	DEFINE(__LC_SAVE_AREA_64, offsetof(struct _lowcore, save_area_64));
+	DEFINE(__LC_MEMINFO, offsetof(struct _lowcore, meminfo));
+	DEFINE(__MI_TYPE_KDUMP_MEM, (MEMINFO_TYPE_KDUMP_MEM * sizeof(struct meminfo)));
+	DEFINE(__MI_ADDR, offsetof(struct meminfo, addr));
+	DEFINE(__MI_SIZE, offsetof(struct meminfo, size));
 #ifdef CONFIG_32BIT
 	DEFINE(SAVE_AREA_BASE, offsetof(struct _lowcore, extended_save_area_addr));
 #else /* CONFIG_32BIT */
@@ -153,6 +158,8 @@ int main(void)
 	DEFINE(__LC_VDSO_PER_CPU, offsetof(struct _lowcore, vdso_per_cpu_data));
 	DEFINE(__LC_SIE_HOOK, offsetof(struct _lowcore, sie_hook));
 	DEFINE(__LC_CMF_HPP, offsetof(struct _lowcore, cmf_hpp));
+	DEFINE(__LC_OLDMEM_BASE, offsetof(struct _lowcore, oldmem_base));
+	DEFINE(__LC_OLDMEM_SIZE, offsetof(struct _lowcore, oldmem_size));
 #endif /* CONFIG_32BIT */
 	return 0;
 }
--- a/arch/s390/kernel/base.S
+++ b/arch/s390/kernel/base.S
@@ -75,6 +75,43 @@ s390_base_pgm_handler_fn:
 	.quad	0
 	.previous
 
+#
+# Calls diag 308 subcode 1 and continues execution
+#
+# The following conditions must be ensured before calling this function:
+# * Prefix register = 0
+# * Lowcore protection is disabled
+#
+	.globl	do_reset_diag308
+do_reset_diag308:
+	larl	%r4,.Lctlregs		# Save control registers
+	stctg	%c0,%c15,0(%r4)
+	larl	%r4,.Lrestart_psw	# Setup restart PSW at absolute 0
+	lghi	%r3,0
+	lg	%r4,0(%r4)		# Save PSW
+	sturg	%r4,%r3			# Use sturg, because of large pages
+	lghi	%r1,1
+	diag	%r1,%r1,0x308
+.Lrestart_part2:
+	lhi	%r0,0			# Load r0 with zero
+	lhi	%r1,2			# Use mode 2 = ESAME (dump)
+	sigp	%r1,%r0,0x12		# Switch to ESAME mode
+	sam64				# Switch to 64 bit addressing mode
+	larl	%r4,.Lctlregs		# Restore control registers
+	lctlg	%c0,%c15,0(%r4)
+	br	%r14
+.align 16
+.Lrestart_psw:
+	.long	0x00080000,0x80000000 + .Lrestart_part2
+
+	.section .bss
+.align 8
+.Lctlregs:
+	.rept	16
+	.quad	0
+	.endr
+	.previous
+
 #else /* CONFIG_64BIT */
 
 	.globl	s390_base_mcck_handler
--- /dev/null
+++ b/arch/s390/kernel/crash_dump.c
@@ -0,0 +1,76 @@
+/*
+ * S390 kdump implementation
+ *
+ * Copyright IBM Corp. 2011
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <linux/crash_dump.h>
+#include <asm/lowcore.h>
+
+/*
+ * Copy one page from "oldmem"
+ *
+ * For the kdump reserved memory this functions performs a swap operation:
+ *  - [kdump_base - kdump_base + kdump_size] is mapped to [0 - kdump_size].
+ *  - [0 - kdump_size] is mapped to [kdump_base - kdump_base + kdump_size]
+ */
+ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
+			 size_t csize, unsigned long offset, int userbuf)
+{
+	unsigned long src, kdump_base, kdump_size;
+	int rc;
+
+	if (!csize)
+		return 0;
+
+	kdump_base = oldmem_base;
+	kdump_size = oldmem_size;
+
+	src = (pfn << PAGE_SHIFT) + offset;
+	if (src < kdump_size)
+		src += kdump_base;
+	else if (src > kdump_base &&
+		 src < kdump_base + kdump_size)
+		src -= kdump_base;
+	if (userbuf)
+		rc = copy_to_user_real((void __user *) buf, (void *) src,
+				       csize);
+	else
+		rc = memcpy_real(buf, (void *) src, csize);
+	return rc < 0 ? rc : csize;
+}
+
+/*
+ * Read memory from oldmem
+ */
+ssize_t crash_read_from_oldmem(void *buf, size_t count, u64 ppos, int userbuf)
+{
+	unsigned long pfn, offset;
+	ssize_t read = 0, tmp;
+	size_t nr_bytes;
+
+	if (!count)
+		return 0;
+
+	offset = (unsigned long)(ppos % PAGE_SIZE);
+	pfn = (unsigned long)(ppos / PAGE_SIZE);
+
+	do {
+		if (count > (PAGE_SIZE - offset))
+			nr_bytes = PAGE_SIZE - offset;
+		else
+			nr_bytes = count;
+
+		tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);
+		if (tmp < 0)
+			return tmp;
+		count -= nr_bytes;
+		buf += nr_bytes;
+		read += nr_bytes;
+		++pfn;
+		offset = 0;
+	} while (count);
+
+	return read;
+}
--- /dev/null
+++ b/arch/s390/kernel/crash_dump_elf.c
@@ -0,0 +1,434 @@
+/*
+ * S390 kdump implementation - Create ELF core header
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#define KMSG_COMPONENT "kdump"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/crash_dump.h>
+#include <linux/bootmem.h>
+#include <linux/elf.h>
+#include <asm/ipl.h>
+
+#define HDR_PER_CPU_SIZE	0x300
+#define HDR_PER_MEMC_SIZE	0x100
+#define HDR_BASE_SIZE		0x2000
+
+#define ROUNDUP(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define PTR_ADD(x, y) (((char *) (x)) + ((unsigned long) (y)))
+#define PTR_SUB(x, y) (((char *) (x)) - ((unsigned long) (y)))
+#define PTR_DIFF(x, y) ((unsigned long)(((char *) (x)) - ((unsigned long) (y))))
+
+#ifndef ELFOSABI_SYSV
+#define ELFOSABI_SYSV 0
+#endif
+
+#ifndef EI_ABIVERSION
+#define EI_ABIVERSION 8
+#endif
+
+#ifndef NT_FPREGSET
+#define NT_FPREGSET 2
+#endif
+
+/*
+ * prstatus ELF Note
+ */
+struct nt_prstatus_64 {
+	u8	pad1[32];
+	u32	pr_pid;
+	u8	pad2[76];
+	u64	psw[2];
+	u64	gprs[16];
+	u32	acrs[16];
+	u64	orig_gpr2;
+	u32	pr_fpvalid;
+	u8	pad3[4];
+} __packed;
+
+/*
+ * fpregset ELF Note
+ */
+struct nt_fpregset_64 {
+	u32	fpc;
+	u32	pad;
+	u64	fprs[16];
+} __packed;
+
+/*
+ * prpsinfo ELF Note
+ */
+struct nt_prpsinfo_64 {
+	char	pr_state;
+	char	pr_sname;
+	char	pr_zomb;
+	char	pr_nice;
+	u64	pr_flag;
+	u32	pr_uid;
+	u32	pr_gid;
+	u32	pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	char	pr_fname[16];
+	char	pr_psargs[80];
+};
+
+/*
+ * File local static data
+ */
+static struct {
+	void	*hdr;
+	u32	hdr_size;
+	int	mem_chunk_cnt;
+} l;
+
+/*
+ * Create all required memory holes
+ */
+static void create_mem_holes(struct mem_chunk chunk_array[])
+{
+	create_mem_hole(chunk_array, oldmem_base, oldmem_size, CHUNK_CRASHK);
+}
+
+/*
+ * Alloc memory and panic in case of alloc failure
+ */
+static void *zg_alloc(int len)
+{
+	void *rc;
+
+	rc = kzalloc(len, GFP_KERNEL);
+	if (!rc)
+		panic("crash_dump_elf: alloc failed");
+	return rc;
+}
+
+/*
+ * Calculate CPUs count for dump
+ */
+static int cpu_cnt(void)
+{
+	int i, cpus = 0;
+
+	for (i = 0; zfcpdump_save_areas[i]; i++) {
+		if (zfcpdump_save_areas[i]->pref_reg == 0)
+			continue;
+		cpus++;
+	}
+	return cpus;
+}
+
+/*
+ * Calculate memory chunk count
+ */
+static int mem_chunk_cnt(void)
+{
+	struct mem_chunk *chunk_array, *mem_chunk;
+	int i, cnt = 0;
+
+	chunk_array = zg_alloc(MEMORY_CHUNKS * sizeof(struct mem_chunk));
+	detect_memory_layout(chunk_array);
+	create_mem_holes(chunk_array);
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		mem_chunk = &chunk_array[i];
+		if (chunk_array[i].type != CHUNK_READ_WRITE &&
+		    chunk_array[i].type != CHUNK_READ_ONLY)
+			continue;
+		if (mem_chunk->size == 0)
+			continue;
+		cnt++;
+	}
+	kfree(chunk_array);
+	return cnt;
+}
+
+/*
+ * Initialize ELF header
+ */
+static void *ehdr_init(Elf64_Ehdr *ehdr)
+{
+	memcpy(ehdr->e_ident, ELFMAG, SELFMAG);
+	ehdr->e_ident[EI_CLASS] = ELFCLASS64;
+	ehdr->e_ident[EI_DATA] = ELFDATA2MSB;
+	ehdr->e_ident[EI_VERSION] = EV_CURRENT;
+	ehdr->e_ident[EI_OSABI] = ELFOSABI_SYSV;
+	ehdr->e_ident[EI_ABIVERSION] = 0;
+	memset(ehdr->e_ident+EI_PAD, 0, EI_NIDENT-EI_PAD);
+	ehdr->e_type = ET_CORE;
+	ehdr->e_machine = EM_S390;
+	ehdr->e_version = EV_CURRENT;
+	ehdr->e_entry = 0;
+	ehdr->e_phoff = sizeof(Elf64_Ehdr);
+	ehdr->e_shoff = 0;
+	ehdr->e_flags = 0;
+	ehdr->e_ehsize = sizeof(Elf64_Ehdr);
+	ehdr->e_phentsize = sizeof(Elf64_Phdr);
+	ehdr->e_shentsize = 0;
+	ehdr->e_shnum = 0;
+	ehdr->e_shstrndx = 0;
+	ehdr->e_phnum = l.mem_chunk_cnt + 1;
+	return ehdr + 1;
+}
+
+/*
+ * Initialize ELF loads
+ */
+static int loads_init(Elf64_Phdr *phdr, u64 loads_offset)
+{
+	struct mem_chunk *chunk_array, *mem_chunk;
+	int i;
+
+	chunk_array = zg_alloc(MEMORY_CHUNKS * sizeof(struct mem_chunk));
+	detect_memory_layout(chunk_array);
+	create_mem_holes(chunk_array);
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		mem_chunk = &chunk_array[i];
+		if (mem_chunk->size == 0)
+			break;
+		if (chunk_array[i].type != CHUNK_READ_WRITE &&
+		    chunk_array[i].type != CHUNK_READ_ONLY)
+			continue;
+		else
+			phdr->p_filesz = mem_chunk->size;
+		phdr->p_type = PT_LOAD;
+		phdr->p_offset = mem_chunk->addr;
+		phdr->p_vaddr = mem_chunk->addr;
+		phdr->p_paddr = mem_chunk->addr;
+		phdr->p_memsz = mem_chunk->size;
+		phdr->p_flags = PF_R | PF_W | PF_X;
+		phdr->p_align = PAGE_SIZE;
+		phdr++;
+	}
+	kfree(chunk_array);
+	return i;
+}
+
+/*
+ * Initialize ELF note
+ */
+static void *nt_init(void *buf, Elf64_Word type, void *desc, int d_len,
+		     const char *name)
+{
+	Elf64_Nhdr *note;
+	u64 len;
+
+	note = (Elf64_Nhdr *)buf;
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = d_len;
+	note->n_type = type;
+	len = sizeof(Elf64_Nhdr);
+
+	memcpy(buf + len, name, note->n_namesz);
+	len = ROUNDUP(len + note->n_namesz, 4);
+
+	memcpy(buf + len, desc, note->n_descsz);
+	len = ROUNDUP(len + note->n_descsz, 4);
+
+	return PTR_ADD(buf, len);
+}
+
+/*
+ * Initialize prstatus note
+ */
+static void *nt_prstatus(void *ptr, struct save_area *cpu)
+{
+	struct nt_prstatus_64 nt_prstatus;
+	static int cpu_nr = 1;
+
+	memset(&nt_prstatus, 0, sizeof(nt_prstatus));
+	memcpy(&nt_prstatus.gprs, cpu->gp_regs, sizeof(cpu->gp_regs));
+	memcpy(&nt_prstatus.psw, cpu->psw, sizeof(cpu->psw));
+	memcpy(&nt_prstatus.acrs, cpu->acc_regs, sizeof(cpu->acc_regs));
+	nt_prstatus.pr_pid = cpu_nr;
+	cpu_nr++;
+
+	return nt_init(ptr, NT_PRSTATUS, &nt_prstatus, sizeof(nt_prstatus),
+			 "CORE");
+}
+
+/*
+ * Initialize fpregset (floating point) note
+ */
+static void *nt_fpregset(void *ptr, struct save_area *cpu)
+{
+	struct nt_fpregset_64 nt_fpregset;
+
+	memset(&nt_fpregset, 0, sizeof(nt_fpregset));
+	memcpy(&nt_fpregset.fpc, &cpu->fp_ctrl_reg, sizeof(cpu->fp_ctrl_reg));
+	memcpy(&nt_fpregset.fprs, &cpu->fp_regs, sizeof(cpu->fp_regs));
+
+	return nt_init(ptr, NT_FPREGSET, &nt_fpregset, sizeof(nt_fpregset),
+			 "CORE");
+}
+
+/*
+ * Initialize timer note
+ */
+static void *nt_s390_timer(void *ptr, struct save_area *cpu)
+{
+	return nt_init(ptr, NT_S390_TIMER, &cpu->timer, sizeof(cpu->timer),
+			 "LINUX");
+}
+
+/*
+ * Initialize TOD clock comparator note
+ */
+static void *nt_s390_tod_cmp(void *ptr, struct save_area *cpu)
+{
+	return nt_init(ptr, NT_S390_TODCMP, &cpu->clk_cmp,
+		       sizeof(cpu->clk_cmp), "LINUX");
+}
+
+/*
+ * Initialize TOD programmable register note
+ */
+static void *nt_s390_tod_preg(void *ptr, struct save_area *cpu)
+{
+	return nt_init(ptr, NT_S390_TODPREG, &cpu->tod_reg,
+		       sizeof(cpu->tod_reg), "LINUX");
+}
+
+/*
+ * Initialize control register note
+ */
+static void *nt_s390_ctrs(void *ptr, struct save_area *cpu)
+{
+	return nt_init(ptr, NT_S390_CTRS, &cpu->ctrl_regs,
+		       sizeof(cpu->ctrl_regs), "LINUX");
+}
+
+/*
+ * Initialize prefix register note
+ */
+static void *nt_s390_prefix(void *ptr, struct save_area *cpu)
+{
+	return nt_init(ptr, NT_S390_PREFIX, &cpu->pref_reg,
+			 sizeof(cpu->pref_reg), "LINUX");
+}
+
+/*
+ * Initialize prpsinfo note
+ */
+static void *nt_prpsinfo(void *ptr)
+{
+	struct nt_prpsinfo_64 prpsinfo;
+
+	memset(&prpsinfo, 0, sizeof(prpsinfo));
+	prpsinfo.pr_state = 0;
+	prpsinfo.pr_sname = 'R';
+	prpsinfo.pr_zomb = 0;
+	strcpy(prpsinfo.pr_fname, "vmlinux");
+
+	return nt_init(ptr, NT_PRPSINFO, &prpsinfo, sizeof(prpsinfo), "CORE");
+}
+
+/*
+ * Initialize vmcoreinfo note
+ */
+static void *nt_vmcoreinfo(void *ptr)
+{
+	struct meminfo meminfo_vmcoreinfo;
+	char note_name[11];
+	unsigned long addr;
+	char *vmcoreinfo;
+	Elf64_Nhdr note;
+
+	if (meminfo_old_get(MEMINFO_TYPE_VMCOREINFO, &meminfo_vmcoreinfo))
+		return ptr;
+	addr = meminfo_vmcoreinfo.addr;
+	memset(note_name, 0, sizeof(note_name));
+	crash_read_from_oldmem(&note, sizeof(note), addr, 0);
+	crash_read_from_oldmem(note_name, sizeof(note_name) - 1,
+			       addr + sizeof(note), 0);
+	if (strcmp(note_name, "VMCOREINFO") != 0)
+		return ptr;
+	vmcoreinfo = zg_alloc(note.n_descsz + 1);
+	crash_read_from_oldmem(vmcoreinfo, note.n_descsz, addr + 24, 0);
+	vmcoreinfo[note.n_descsz + 1] = 0;
+
+	return nt_init(ptr, 0, vmcoreinfo, note.n_descsz, "VMCOREINFO");
+}
+
+/*
+ * Initialize notes
+ */
+static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
+{
+	struct save_area *cpu;
+	void *ptr_start = ptr;
+	int i;
+
+	ptr = nt_prpsinfo(ptr);
+
+	for (i = 0; zfcpdump_save_areas[i]; i++) {
+		cpu = zfcpdump_save_areas[i];
+		if (cpu->pref_reg == 0)
+			continue;
+		ptr = nt_prstatus(ptr, cpu);
+		ptr = nt_fpregset(ptr, cpu);
+		ptr = nt_s390_timer(ptr, cpu);
+		ptr = nt_s390_tod_cmp(ptr, cpu);
+		ptr = nt_s390_tod_preg(ptr, cpu);
+		ptr = nt_s390_ctrs(ptr, cpu);
+		ptr = nt_s390_prefix(ptr, cpu);
+	}
+	ptr = nt_vmcoreinfo(ptr);
+	memset(phdr, 0, sizeof(*phdr));
+	phdr->p_type = PT_NOTE;
+	phdr->p_offset = notes_offset;
+	phdr->p_filesz = (unsigned long) PTR_SUB(ptr, ptr_start);
+	phdr->p_memsz = phdr->p_filesz;
+	return ptr;
+}
+
+/*
+ * Initialize ELF header for kdump
+ */
+static void setup_kdump_elf_hdr(void)
+{
+	Elf64_Phdr *phdr_notes, *phdr_loads;
+	u32 alloc_size;
+	u64 hdr_off;
+	void *ptr;
+
+	if (!is_kdump_kernel())
+		return;
+	l.mem_chunk_cnt = mem_chunk_cnt();
+
+	alloc_size = HDR_BASE_SIZE + cpu_cnt() * HDR_PER_CPU_SIZE +
+		l.mem_chunk_cnt * HDR_PER_MEMC_SIZE;
+	l.hdr = zg_alloc(alloc_size);
+	/* Init elf header */
+	ptr = ehdr_init(l.hdr);
+	/* Init program headers */
+	phdr_notes = ptr;
+	ptr = PTR_ADD(ptr, sizeof(Elf64_Phdr));
+	phdr_loads = ptr;
+	ptr = PTR_ADD(ptr, sizeof(Elf64_Phdr) * l.mem_chunk_cnt);
+	/* Init notes */
+	hdr_off = PTR_DIFF(ptr, l.hdr);
+	ptr = notes_init(phdr_notes, ptr, hdr_off);
+	/* Init loads */
+	hdr_off = PTR_DIFF(ptr, l.hdr);
+	loads_init(phdr_loads, hdr_off);
+	l.hdr_size = hdr_off;
+	BUG_ON(l.hdr_size > alloc_size);
+}
+
+/*
+ * Get ELF header - called from vmcore common code
+ */
+int arch_vmcore_get_elf_hdr(char **elfcorebuf, size_t *elfcorebuf_sz)
+{
+	if (!l.hdr)
+		setup_kdump_elf_hdr();
+	*elfcorebuf = l.hdr;
+	*elfcorebuf_sz = l.hdr_size;
+	return 0;
+}
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -20,6 +20,7 @@
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/crash_dump.h>
 #include <asm/ebcdic.h>
 #include <asm/ipl.h>
 #include <asm/lowcore.h>
@@ -29,6 +30,7 @@
 #include <asm/sysinfo.h>
 #include <asm/cpcmd.h>
 #include <asm/sclp.h>
+#include <asm/asm-offsets.h>
 #include "entry.h"
 
 /*
@@ -453,6 +455,14 @@ static void __init setup_boot_command_li
 	append_to_cmdline(append_ipl_scpdata);
 }
 
+static void __init setup_kdump(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	if (!oldmem_base)
+		return;
+	elfcorehdr_addr = ELFCORE_ADDR_NEWMEM; /* needed for is_kdump_kernel */
+#endif
+}
 
 /*
  * Save ipl parameters, clear bss memory, initialize storage keys
@@ -460,6 +470,8 @@ static void __init setup_boot_command_li
  */
 void __init startup_init(void)
 {
+	meminfo_init();
+	setup_kdump();
 	reset_tod_clock();
 	ipl_save_parameters();
 	rescue_initrd();
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -859,6 +859,34 @@ restart_crash:
 restart_go:
 #endif
 
+#
+# PSW restart interrupt handler
+#
+	.globl psw_restart_int_handler
+psw_restart_int_handler:
+	st	%r15,__LC_SAVE_AREA_64(%r0)	# save r15
+	basr	%r15,0
+0:	l	%r15,.Lrestart_stack-0b(%r15)	# load restart stack
+	l	%r15,0(%r15)
+	ahi	%r15,-SP_SIZE			# make room for pt_regs
+	stm	%r0,%r14,SP_R0(%r15)		# store gprs %r0-%r14 to stack
+	mvc	SP_R15(4,%r15),__LC_SAVE_AREA_64(%r0)# store saved %r15 to stack
+	mvc	SP_PSW(8,%r15),__LC_RST_OLD_PSW(%r0) # store restart old psw
+	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15) # set backchain to 0
+	basr	%r14,0
+1:	l	%r14,.Ldo_restart-1b(%r14)
+	basr	%r14,%r14
+
+	basr	%r14,0				# load disabled wait PSW if
+2:	lpsw	restart_psw_crash-2b(%r14)	# do_restart returns
+.Ldo_restart:
+	.long	do_restart
+.Lrestart_stack:
+	.long	restart_stack
+	.align 8
+restart_psw_crash:
+	.long	0x000a0000,0x00000000 + restart_psw_crash
+
 	.section .kprobes.text, "ax"
 
 #ifdef CONFIG_CHECK_STACK
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -862,6 +862,27 @@ restart_crash:
 restart_go:
 #endif
 
+#
+# PSW restart interrupt handler
+#
+	.globl psw_restart_int_handler
+psw_restart_int_handler:
+	stg	%r15,__LC_SAVE_AREA_64(%r0)	# save r15
+	larl	%r15,restart_stack		# load restart stack
+	lg	%r15,0(%r15)
+	aghi	%r15,-SP_SIZE			# make room for pt_regs
+	stmg	%r0,%r14,SP_R0(%r15)		# store gprs %r0-%r14 to stack
+	mvc	SP_R15(8,%r15),__LC_SAVE_AREA_64(%r0)# store saved %r15 to stack
+	mvc	SP_PSW(16,%r15),__LC_RST_OLD_PSW(%r0)# store restart old psw
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15) # set backchain to 0
+	brasl	%r14,do_restart
+
+	larl	%r14,restart_psw_crash		# load disabled wait PSW if
+	lpswe	0(%r14)				# do_restart returns
+	.align 8
+restart_psw_crash:
+	.quad	0x0002000080000000,0x0000000000000000 + restart_psw_crash
+
 	.section .kprobes.text, "ax"
 
 #ifdef CONFIG_CHECK_STACK
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -450,10 +450,22 @@ start:
 	.org	0x10000
 	.globl	startup
 startup:
+	j	.Lep_startup_normal
+
+#
+# kdump startup-code at 0x10008, running in 64 bit absolute addressing mode
+#
+	.org	0x10008
+	.globl	startup_kdump
+startup_kdump:
+	j	.Lep_startup_kdump
+
+.Lep_startup_normal:
 	basr	%r13,0			# get base
 .LPG0:
 	xc	0x200(256),0x200	# partially clear lowcore
 	xc	0x300(256),0x300
+	xc	0xe00(256),0xe00
 	stck	__LC_LAST_UPDATE_CLOCK
 	spt	5f-.LPG0(%r13)
 	mvc	__LC_LAST_UPDATE_TIMER(8),5f-.LPG0(%r13)
@@ -535,6 +547,8 @@ startup:
 	.align	8
 5:	.long	0x7fffffff,0xffffffff
 
+#include "head_kdump.S"
+
 #
 # params at 10400 (setup.h)
 #
--- /dev/null
+++ b/arch/s390/kernel/head_kdump.S
@@ -0,0 +1,133 @@
+/*
+ * S390 kdump lowlevel functions (new kernel)
+ *
+ * Copyright IBM Corp. 2011
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#define DATAMOVER_ADDR	0x4000
+#define COPY_PAGE_ADDR	0x6000
+
+#ifdef CONFIG_CRASH_DUMP
+
+#
+# kdump entry (new kernel - not yet relocated)
+#
+# Note: This code has to be position independent
+#
+
+.align 2
+.Lep_startup_kdump:
+	basr	%r13,0
+.Lbase:
+	larl	%r2,.Lbase_addr			# Check, if we have been
+	lg	%r2,0(%r2)			# already relocated:
+	clgr	%r2,%r13			#
+	jne	.Lrelocate			# No : Start data mover
+	lghi	%r2,0				# Yes: Start kdump kernel
+	brasl	%r14,startup_kdump_relocated
+
+.Lrelocate:
+	lg	%r4,__LC_MEMINFO+__MI_ADDR(%r0)	# Load meminfo base (%r4)
+
+	lgr	%r5,%r4
+	aghi	%r5,__MI_TYPE_KDUMP_MEM		# Base for kdump meminfo
+	lg	%r2,__MI_ADDR(%r5)		# Load kdump base address (%r2)
+	lg	%r3,__MI_SIZE(%r5)		# Load kdump size (%r3)
+
+	stg	%r2,__LC_OLDMEM_BASE(%r2)	# Save kdump base
+	stg	%r3,__LC_OLDMEM_SIZE(%r2)	# Save kdump size
+
+	larl	%r10,.Lcopy_start		# Source of data mover
+	lghi	%r8,DATAMOVER_ADDR		# Target of data mover
+	mvc	0(256,%r8),0(%r10)		# Copy data mover code
+
+	agr	%r8,%r2				# Copy data mover to
+	mvc	0(256,%r8),0(%r10)		# reserved mem
+
+	lghi	%r14,DATAMOVER_ADDR		# Jump to copied data mover
+	basr	%r14,%r14
+.Lbase_addr:
+	.quad	.Lbase
+
+#
+# kdump data mover code (runs at address DATAMOVER_ADDR)
+#
+# r2: kdump base address
+# r3: kdump size
+#
+.Lcopy_start:
+	basr	%r13,0				# Base
+0:
+	lgr	%r11,%r2			# Save kdump base address
+	lgr	%r12,%r2
+	agr	%r12,%r3			# Compute kdump end address
+
+	lghi	%r5,0
+	lghi	%r10,COPY_PAGE_ADDR		# Load copy page address
+1:
+	mvc	0(256,%r10),0(%r5)		# Copy old kernel to tmp
+	mvc	0(256,%r5),0(%r11)		# Copy new kernel to old
+	mvc	0(256,%r11),0(%r10)		# Copy tmp to new
+	aghi	%r11,256
+	aghi	%r5,256
+	clgr	%r11,%r12
+	jl	1b
+
+	lg	%r14,.Lstartup_kdump-0b(%r13)
+	basr	%r14,%r14			# Start relocated kernel
+.Lstartup_kdump:
+	.long	0x00000000,0x00000000 + startup_kdump_relocated
+.Lcopy_end:
+
+#
+# Startup of kdump (relocated new kernel)
+#
+.align 2
+startup_kdump_relocated:
+	basr	%r13,0
+0:	lg	%r3,__LC_OLDMEM_BASE(%r0)	# Save oldmem base
+	stg	%r3,oldmem_base-0b(%r13)
+	lg	%r3,__LC_OLDMEM_SIZE(%r0)	# Save oldmem size
+	stg	%r3,oldmem_size-0b(%r13)
+
+	mvc	0(8,%r0),.Lrestart_psw-0b(%r13)	# Setup restart PSW
+	mvc	464(16,%r0),.Lpgm_psw-0b(%r13)	# Setup pgm check PSW
+	lhi	%r1,1				# Start new kernel
+	diag	%r1,%r1,0x308			# with diag 308
+
+.Lno_diag308:					# No diag 308
+	sam31					# Switch to 31 bit addr mode
+	sr	%r1,%r1				# Erase register r1
+	sr	%r2,%r2				# Erase register r2
+	sigp	%r1,%r2,0x12			# Switch to 31 bit arch mode
+	lpsw	0				# Start new kernel...
+.align	8
+.Lrestart_psw:
+	.long	0x00080000,0x80000000 + startup
+.Lpgm_psw:
+	.quad	0x0000000180000000,0x0000000000000000 + .Lno_diag308
+	.globl	oldmem_base
+oldmem_base:
+	.quad	0x0
+	.globl	oldmem_size
+oldmem_size:
+	.quad	0x0
+
+#else
+.align 2
+.Lep_startup_kdump:
+#ifdef CONFIG_64BIT
+	larl	%r13,startup_kdump_crash
+	lpswe	0(%r13)
+.align 8
+startup_kdump_crash:
+	.quad	0x0002000080000000,0x0000000000000000 + startup_kdump_crash
+#else
+	basr	%r13,0
+0:	lpsw	startup_kdump_crash-0b(%r13)
+.align 8
+startup_kdump_crash:
+	.long	0x000a0000,0x00000000 + startup_kdump_crash
+#endif /* CONFIG_64BIT */
+#endif /* CONFIG_CRASH_DUMP */
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -16,6 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
+#include <linux/crash_dump.h>
 #include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
@@ -26,6 +27,7 @@
 #include <asm/sclp.h>
 #include <asm/sigp.h>
 #include <asm/checksum.h>
+#include <asm/lowcore.h>
 
 #define IPL_PARM_BLOCK_VERSION 0
 
@@ -45,11 +47,13 @@
  * - halt
  * - power off
  * - reipl
+ * - restart
  */
 #define ON_PANIC_STR		"on_panic"
 #define ON_HALT_STR		"on_halt"
 #define ON_POFF_STR		"on_poff"
 #define ON_REIPL_STR		"on_reboot"
+#define ON_RESTART_STR		"on_restart"
 
 struct shutdown_action;
 struct shutdown_trigger {
@@ -66,6 +70,7 @@ struct shutdown_trigger {
 #define SHUTDOWN_ACTION_VMCMD_STR	"vmcmd"
 #define SHUTDOWN_ACTION_STOP_STR	"stop"
 #define SHUTDOWN_ACTION_DUMP_REIPL_STR	"dump_reipl"
+#define SHUTDOWN_ACTION_KDUMP_STR	"kdump"
 
 struct shutdown_action {
 	char *name;
@@ -946,6 +951,13 @@ static struct attribute_group reipl_nss_
 	.attrs = reipl_nss_attrs,
 };
 
+static void set_reipl_block_actual(struct ipl_parameter_block *reipl_block)
+{
+	meminfo_update(MEMINFO_TYPE_IPIB, reipl_block, reipl_block->hdr.len,
+		       MEMINFO_FLAG_ELEM_VALID | MEMINFO_FLAG_CSUM_VALID);
+	reipl_block_actual = reipl_block;
+}
+
 /* reipl type */
 
 static int reipl_set_type(enum ipl_type type)
@@ -961,7 +973,7 @@ static int reipl_set_type(enum ipl_type
 			reipl_method = REIPL_METHOD_CCW_VM;
 		else
 			reipl_method = REIPL_METHOD_CCW_CIO;
-		reipl_block_actual = reipl_block_ccw;
+		set_reipl_block_actual(reipl_block_ccw);
 		break;
 	case IPL_TYPE_FCP:
 		if (diag308_set_works)
@@ -970,7 +982,7 @@ static int reipl_set_type(enum ipl_type
 			reipl_method = REIPL_METHOD_FCP_RO_VM;
 		else
 			reipl_method = REIPL_METHOD_FCP_RO_DIAG;
-		reipl_block_actual = reipl_block_fcp;
+		set_reipl_block_actual(reipl_block_fcp);
 		break;
 	case IPL_TYPE_FCP_DUMP:
 		reipl_method = REIPL_METHOD_FCP_DUMP;
@@ -980,7 +992,7 @@ static int reipl_set_type(enum ipl_type
 			reipl_method = REIPL_METHOD_NSS_DIAG;
 		else
 			reipl_method = REIPL_METHOD_NSS;
-		reipl_block_actual = reipl_block_nss;
+		set_reipl_block_actual(reipl_block_nss);
 		break;
 	case IPL_TYPE_UNKNOWN:
 		reipl_method = REIPL_METHOD_DEFAULT;
@@ -1111,6 +1123,12 @@ static void reipl_block_ccw_init(struct
 static void reipl_block_ccw_fill_parms(struct ipl_parameter_block *ipb)
 {
 	/* LOADPARM */
+	/* For kdump we use IPL parameters from original system */
+	if (is_kdump_kernel()) {
+		memcpy(ipb->ipl_info.ccw.load_parm,
+		       ipl_block.ipl_info.ccw.load_parm, LOADPARM_LEN);
+		return;
+	}
 	/* check if read scp info worked and set loadparm */
 	if (sclp_ipl_info.is_valid)
 		memcpy(ipb->ipl_info.ccw.load_parm,
@@ -1495,30 +1513,10 @@ static struct shutdown_action __refdata
 
 static void dump_reipl_run(struct shutdown_trigger *trigger)
 {
-	preempt_disable();
-	/*
-	 * Bypass dynamic address translation (DAT) when storing IPL parameter
-	 * information block address and checksum into the prefix area
-	 * (corresponding to absolute addresses 0-8191).
-	 * When enhanced DAT applies and the STE format control in one,
-	 * the absolute address is formed without prefixing. In this case a
-	 * normal store (stg/st) into the prefix area would no more match to
-	 * absolute addresses 0-8191.
-	 */
-#ifdef CONFIG_64BIT
-	asm volatile("sturg %0,%1"
-		:: "a" ((unsigned long) reipl_block_actual),
-		"a" (&lowcore_ptr[smp_processor_id()]->ipib));
-#else
-	asm volatile("stura %0,%1"
-		:: "a" ((unsigned long) reipl_block_actual),
-		"a" (&lowcore_ptr[smp_processor_id()]->ipib));
-#endif
-	asm volatile("stura %0,%1"
-		:: "a" (csum_partial(reipl_block_actual,
-				     reipl_block_actual->hdr.len, 0)),
-		"a" (&lowcore_ptr[smp_processor_id()]->ipib_checksum));
-	preempt_enable();
+	u32 csum;
+
+	csum = csum_partial(reipl_block_actual, reipl_block_actual->hdr.len, 0);
+	copy_to_absolute_zero(&S390_lowcore.ipib_checksum, &csum, sizeof(csum));
 	dump_run(trigger);
 }
 
@@ -1544,17 +1542,20 @@ static char vmcmd_on_reboot[128];
 static char vmcmd_on_panic[128];
 static char vmcmd_on_halt[128];
 static char vmcmd_on_poff[128];
+static char vmcmd_on_restart[128];
 
 DEFINE_IPL_ATTR_STR_RW(vmcmd, on_reboot, "%s\n", "%s\n", vmcmd_on_reboot);
 DEFINE_IPL_ATTR_STR_RW(vmcmd, on_panic, "%s\n", "%s\n", vmcmd_on_panic);
 DEFINE_IPL_ATTR_STR_RW(vmcmd, on_halt, "%s\n", "%s\n", vmcmd_on_halt);
 DEFINE_IPL_ATTR_STR_RW(vmcmd, on_poff, "%s\n", "%s\n", vmcmd_on_poff);
+DEFINE_IPL_ATTR_STR_RW(vmcmd, on_restart, "%s\n", "%s\n", vmcmd_on_restart);
 
 static struct attribute *vmcmd_attrs[] = {
 	&sys_vmcmd_on_reboot_attr.attr,
 	&sys_vmcmd_on_panic_attr.attr,
 	&sys_vmcmd_on_halt_attr.attr,
 	&sys_vmcmd_on_poff_attr.attr,
+	&sys_vmcmd_on_restart_attr.attr,
 	NULL,
 };
 
@@ -1576,6 +1577,8 @@ static void vmcmd_run(struct shutdown_tr
 		cmd = vmcmd_on_halt;
 	else if (strcmp(trigger->name, ON_POFF_STR) == 0)
 		cmd = vmcmd_on_poff;
+	else if (strcmp(trigger->name, ON_RESTART_STR) == 0)
+		cmd = vmcmd_on_restart;
 	else
 		return;
 
@@ -1621,11 +1624,43 @@ static void stop_run(struct shutdown_tri
 static struct shutdown_action stop_action = {SHUTDOWN_ACTION_STOP_STR,
 					     stop_run, NULL};
 
+/*
+ * kdump shutdown action: Trigger kdump on shutdown.
+ */
+
+#ifdef CONFIG_CRASH_DUMP
+static int kdump_init(void)
+{
+	if (crashk_res.start == 0)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static void kdump_run(struct shutdown_trigger *trigger)
+{
+	/*
+	 * We do not call crash_kexec(), because the image could also
+	 * be loaded externally without kexec_load(). In this case
+	 * crash_kexec() would have no effect because crash_image is not
+	 * defined.
+	 */
+	machine_kdump();
+	disabled_wait((unsigned long) __builtin_return_address(0));
+}
+
+static struct shutdown_action kdump_action = {SHUTDOWN_ACTION_KDUMP_STR,
+					     kdump_run, kdump_init};
+#endif
+
 /* action list */
 
 static struct shutdown_action *shutdown_actions_list[] = {
 	&ipl_action, &reipl_action, &dump_reipl_action, &dump_action,
-	&vmcmd_action, &stop_action};
+	&vmcmd_action, &stop_action,
+#ifdef CONFIG_CRASH_DUMP
+	&kdump_action
+#endif
+	};
 #define SHUTDOWN_ACTIONS_COUNT (sizeof(shutdown_actions_list) / sizeof(void *))
 
 /*
@@ -1707,6 +1742,34 @@ static void do_panic(void)
 	stop_run(&on_panic_trigger);
 }
 
+/* on restart */
+
+static struct shutdown_trigger on_restart_trigger = {ON_RESTART_STR,
+	&reipl_action};
+
+static ssize_t on_restart_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *page)
+{
+	return sprintf(page, "%s\n", on_restart_trigger.action->name);
+}
+
+static ssize_t on_restart_store(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				const char *buf, size_t len)
+{
+	return set_trigger(buf, &on_restart_trigger, len);
+}
+
+static struct kobj_attribute on_restart_attr =
+	__ATTR(on_restart, 0644, on_restart_show, on_restart_store);
+
+void do_restart(void)
+{
+	smp_send_stop();
+	on_restart_trigger.action->fn(&on_restart_trigger);
+	stop_run(&on_restart_trigger);
+}
+
 /* on halt */
 
 static struct shutdown_trigger on_halt_trigger = {ON_HALT_STR, &stop_action};
@@ -1767,6 +1830,16 @@ void (*_machine_power_off)(void) = do_ma
 
 static void __init shutdown_triggers_init(void)
 {
+#ifdef CONFIG_CRASH_DUMP
+	/*
+	 * We set the kdump action for panic and restart, if the kdump
+	 * reserved area is defined.
+	 */
+	if (crashk_res.start != 0) {
+		on_restart_trigger.action = &kdump_action;
+		on_panic_trigger.action = &kdump_action;
+	}
+#endif
 	shutdown_actions_kset = kset_create_and_add("shutdown_actions", NULL,
 						    firmware_kobj);
 	if (!shutdown_actions_kset)
@@ -1783,7 +1856,9 @@ static void __init shutdown_triggers_ini
 	if (sysfs_create_file(&shutdown_actions_kset->kobj,
 			      &on_poff_attr.attr))
 		goto fail;
-
+	if (sysfs_create_file(&shutdown_actions_kset->kobj,
+			      &on_restart_attr.attr))
+		goto fail;
 	return;
 fail:
 	panic("shutdown_triggers_init failed\n");
@@ -1908,6 +1983,26 @@ void __init setup_ipl(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
 }
 
+/*
+ * In case of kdump get re-IPL configuration of crashed system via meminfo
+ */
+static int __init ipl_kdump_ipib_init(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	struct meminfo meminfo_ipib;
+
+	if (!is_kdump_kernel())
+		return -EINVAL;
+	if (meminfo_old_get(MEMINFO_TYPE_IPIB, &meminfo_ipib))
+		return -EINVAL;
+	crash_read_from_oldmem(&ipl_block, sizeof(ipl_block),
+			       meminfo_ipib.addr, 0);
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 void __init ipl_update_parameters(void)
 {
 	int rc;
@@ -1915,6 +2010,35 @@ void __init ipl_update_parameters(void)
 	rc = diag308(DIAG308_STORE, &ipl_block);
 	if ((rc == DIAG308_RC_OK) || (rc == DIAG308_RC_NOCONFIG))
 		diag308_set_works = 1;
+	ipl_kdump_ipib_init();
+}
+
+/*
+ * For kdump IPL we set the IPL info to the values that get from the crashed
+ * system using the ipib meminfo pointer. Then a reboot of the kdump
+ * kernel will reboot the original system.
+ */
+static int setup_kdump_iplinfo(struct cio_iplinfo *iplinfo)
+{
+#ifdef CONFIG_CRASH_DUMP
+	if (ipl_kdump_ipib_init())
+		return -EINVAL;
+
+	if (ipl_block.hdr.pbt == DIAG308_IPL_TYPE_CCW) {
+		iplinfo->devno = ipl_block.ipl_info.ccw.devno;
+		iplinfo->is_qdio = 0;
+		return 0;
+	}
+	if (ipl_block.hdr.pbt == DIAG308_IPL_TYPE_FCP) {
+		iplinfo->devno = ipl_block.ipl_info.fcp.devno;
+		iplinfo->is_qdio = 1;
+		S390_lowcore.ipl_parmblock_ptr = (unsigned long) &ipl_block;
+		return 0;
+	}
+	return -ENODEV;
+#else
+	return -ENODEV;
+#endif
 }
 
 void __init ipl_save_parameters(void)
@@ -1922,9 +2046,13 @@ void __init ipl_save_parameters(void)
 	struct cio_iplinfo iplinfo;
 	void *src, *dst;
 
-	if (cio_get_iplinfo(&iplinfo))
-		return;
-
+	if (is_kdump_kernel()) {
+		if (setup_kdump_iplinfo(&iplinfo))
+			return;
+	} else {
+		if (cio_get_iplinfo(&iplinfo))
+			return;
+	}
 	ipl_devno = iplinfo.devno;
 	ipl_flags |= IPL_DEVNO_VALID;
 	if (!iplinfo.is_qdio)
@@ -1992,7 +2120,10 @@ void s390_reset_system(void)
 	S390_lowcore.program_new_psw.mask = psw_kernel_bits & ~PSW_MASK_MCHECK;
 	S390_lowcore.program_new_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) s390_base_pgm_handler;
-
-	do_reset_calls();
+#ifdef CONFIG_64BIT
+	if (diag308_set_works)
+		do_reset_diag308();
+	else
+#endif
+		do_reset_calls();
 }
-
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -21,12 +21,169 @@
 #include <asm/smp.h>
 #include <asm/reset.h>
 #include <asm/ipl.h>
+#include <asm/cacheflush.h>
+#include <asm/asm-offsets.h>
+#include <asm/checksum.h>
+#include <asm/diag.h>
+#include <asm/sclp.h>
 
 typedef void (*relocate_kernel_t)(kimage_entry_t *, unsigned long);
 
 extern const unsigned char relocate_kernel[];
 extern const unsigned long long relocate_kernel_len;
 
+#ifdef CONFIG_CRASH_DUMP
+
+static struct meminfo meminfo_kdump_segments[KEXEC_SEGMENT_MAX];
+
+/*
+ * S390 version: Currently we do not support freeing crashkernel memory
+ */
+void crash_free_reserved_phys_range(unsigned long begin, unsigned long end)
+{
+	return;
+}
+
+/*
+ * S390 version: Just do real copy of segment
+ */
+int kimage_load_crash_segment(struct kimage *image,
+			      struct kexec_segment *segment)
+{
+	return copy_from_user_real((void *) segment->mem, segment->buf,
+				   segment->bufsz);
+}
+
+/*
+ * Update KDUMP_MEM meminfo and store oldmem base and size to absolute zero
+ */
+static void kdump_mem_update(void)
+{
+	unsigned long base, size;
+
+	base = crashk_res.start;
+	size = crashk_res.end - crashk_res.start + 1;
+	memcpy_real((void *) __LC_OLDMEM_BASE + base, &base, sizeof(base));
+	memcpy_real((void *) __LC_OLDMEM_SIZE + base, &size, sizeof(size));
+	meminfo_update(MEMINFO_TYPE_KDUMP_MEM, (void *) base, size,
+		       MEMINFO_FLAG_ELEM_VALID);
+}
+
+/*
+ * Clear kdump segments (kdump has been unloaded)
+ */
+static void kdump_segments_clear(void)
+{
+	memset(meminfo_kdump_segments, 0, sizeof(meminfo_kdump_segments));
+	meminfo_update(MEMINFO_TYPE_KDUMP_SEGM, NULL, 0, 0);
+	if (MACHINE_IS_VM)
+		diag10_range(PFN_DOWN(crashk_res.start),
+			     PFN_DOWN(crashk_res.end - crashk_res.start + 1));
+}
+
+/*
+ * Update kdump segments (kdump has been loaded)
+ */
+static void kdump_segments_update(struct kimage *image)
+{
+	int i, flags = MEMINFO_FLAG_ELEM_VALID | MEMINFO_FLAG_CSUM_VALID;
+
+	memset(meminfo_kdump_segments, 0, sizeof(meminfo_kdump_segments));
+
+	for (i = 0; i < image->nr_segments; i++) {
+		meminfo_kdump_segments[i].addr = image->segment[i].mem;
+		meminfo_kdump_segments[i].size = image->segment[i].memsz;
+		meminfo_kdump_segments[i].flags = flags;
+	}
+
+	meminfo_update(MEMINFO_TYPE_KDUMP_SEGM, &meminfo_kdump_segments,
+		       image->nr_segments * sizeof(struct meminfo),
+		       flags | MEMINFO_FLAG_ELEM_IND);
+}
+
+/*
+ * Finish kexec_load() and update meminfo data in case of kdump
+ */
+void machine_kexec_finish(struct kimage *image, int kexec_flags)
+{
+	if (!(kexec_flags & KEXEC_ON_CRASH))
+		return;
+	kdump_mem_update();
+	if (image)
+		kdump_segments_update(image);
+	else
+		kdump_segments_clear();
+}
+
+/*
+ * Print error message and load disabled wait PSW
+ */
+static void kdump_failed(const char *str)
+{
+	psw_t kdump_failed_psw;
+
+	kdump_failed_psw.mask = PSW_BASE_BITS | PSW_MASK_WAIT;
+	kdump_failed_psw.addr = (unsigned long) kdump_failed;
+	_sclp_print_early(str);
+	_sclp_print_early("Please use alternative dump tool");
+	__load_psw(kdump_failed_psw);
+}
+
+/*
+ * Check if kdump is loaded/valid and start it
+ */
+static void __machine_kdump(void *data)
+{
+	u32 flags = meminfo_array[MEMINFO_TYPE_KDUMP_SEGM].flags;
+	struct meminfo root;
+	psw_t kdump_psw;
+	u32 csum;
+
+	pfault_fini();
+	s390_reset_system();
+	__arch_local_irq_stnsm(0xfb); /* disable DAT */
+	do_store_status();
+
+	if (!(flags & MEMINFO_FLAG_ELEM_VALID))
+		kdump_failed("kdump failed: Kernel not loaded");
+
+	copy_from_absolute_zero(&root, &S390_lowcore.meminfo, sizeof(root));
+	copy_from_absolute_zero(&csum, &S390_lowcore.meminfo_csum,
+				sizeof(csum));
+	if (csum != csum_partial(&root, sizeof(root), 0))
+		kdump_failed("kdump failed: Invalid meminfo checksum");
+	if (meminfo_csum_check(&root, 1))
+		kdump_failed("kdump failed: Invalid checksum");
+
+	_sclp_print_early("Starting kdump");
+	kdump_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
+	kdump_psw.addr = crashk_res.start + 0x10008;
+	__load_psw(kdump_psw);
+}
+
+/*
+ * Start kdump on IPL CPU
+ */
+void machine_kdump(void)
+{
+	crash_save_vmcoreinfo();
+	smp_switch_to_ipl_cpu(__machine_kdump, NULL);
+}
+#endif
+
+/*
+ * Invalidate KDUMP_SEGM meminfo before new kdump is loaded
+ */
+static int machine_kexec_prepare_kdump(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	kdump_segments_clear();
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 int machine_kexec_prepare(struct kimage *image)
 {
 	void *reboot_code_buffer;
@@ -35,6 +192,9 @@ int machine_kexec_prepare(struct kimage
 	if (ipl_flags & IPL_NSS_VALID)
 		return -ENOSYS;
 
+	if (image->type == KEXEC_TYPE_CRASH)
+		return machine_kexec_prepare_kdump();
+
 	/* We don't support anything but the default image type for now. */
 	if (image->type != KEXEC_TYPE_DEFAULT)
 		return -EINVAL;
@@ -72,6 +232,10 @@ static void __machine_kexec(void *data)
 
 void machine_kexec(struct kimage *image)
 {
+#ifdef CONFIG_CRASH_DUMP
+	if (image->type == KEXEC_TYPE_CRASH)
+		machine_kdump();
+#endif
 	tracer_disable();
 	smp_send_stop();
 	smp_switch_to_ipl_cpu(__machine_kexec, image);
--- a/arch/s390/kernel/mem_detect.c
+++ b/arch/s390/kernel/mem_detect.c
@@ -62,3 +62,73 @@ void detect_memory_layout(struct mem_chu
 	arch_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(detect_memory_layout);
+
+/*
+ * Create memory hole with given address, size, and type
+ */
+void create_mem_hole(struct mem_chunk chunks[], unsigned long addr,
+		     unsigned long size, int type)
+{
+	unsigned long start, end, new_size;
+	int i;
+
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		if (chunks[i].size == 0)
+			continue;
+		if (addr + size < chunks[i].addr)
+			continue;
+		if (addr >= chunks[i].addr + chunks[i].size)
+			continue;
+		start = max(addr, chunks[i].addr);
+		end = min(addr + size, chunks[i].addr + chunks[i].size);
+		new_size = end - start;
+		if (new_size == 0)
+			continue;
+		if (start == chunks[i].addr &&
+		    end == chunks[i].addr + chunks[i].size) {
+			/* Remove chunk */
+			chunks[i].type = type;
+		} else if (start == chunks[i].addr) {
+			/* Make chunk smaller at start */
+			if (i >= MEMORY_CHUNKS - 1)
+				panic("Unable to create memory hole");
+			memmove(&chunks[i + 1], &chunks[i],
+				sizeof(struct mem_chunk) *
+				(MEMORY_CHUNKS - (i + 1)));
+			chunks[i + 1].addr = chunks[i].addr + new_size;
+			chunks[i + 1].size = chunks[i].size - new_size;
+			chunks[i].size = new_size;
+			chunks[i].type = type;
+			i += 1;
+		} else if (end == chunks[i].addr + chunks[i].size) {
+			/* Make chunk smaller at end */
+			if (i >= MEMORY_CHUNKS - 1)
+				panic("Unable to create memory hole");
+			memmove(&chunks[i + 1], &chunks[i],
+				sizeof(struct mem_chunk) *
+				(MEMORY_CHUNKS - (i + 1)));
+			chunks[i + 1].addr = start;
+			chunks[i + 1].size = new_size;
+			chunks[i + 1].type = type;
+			chunks[i].size -= new_size;
+			i += 1;
+		} else {
+			/* Create memory hole */
+			if (i >= MEMORY_CHUNKS - 2)
+				panic("Unable to create memory hole");
+			memmove(&chunks[i + 2], &chunks[i],
+				sizeof(struct mem_chunk) *
+				(MEMORY_CHUNKS - (i + 2)));
+			chunks[i + 1].addr = addr;
+			chunks[i + 1].size = size;
+			chunks[i + 1].type = type;
+			chunks[i + 2].addr = addr + size;
+			chunks[i + 2].size =
+				chunks[i].addr + chunks[i].size - (addr + size);
+			chunks[i + 2].type = chunks[i].type;
+			chunks[i].size = addr - chunks[i].addr;
+			i += 2;
+		}
+	}
+}
+
--- /dev/null
+++ b/arch/s390/kernel/meminfo.c
@@ -0,0 +1,132 @@
+/*
+ * Store memory information for external users like stand-alone dump tools
+ *
+ * Copyright IBM Corp. 2011
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <asm/asm-offsets.h>
+#include <asm/lowcore.h>
+#include <asm/checksum.h>
+
+struct meminfo meminfo_array[MEMINFO_TYPE_LAST];
+
+static inline int meminfo_ind_cnt(struct meminfo *meminfo)
+{
+	return meminfo->size / sizeof(struct meminfo);
+}
+
+/*
+ * Recursively update meminfo checksums
+ */
+static void meminfo_csum_update(struct meminfo *meminfo)
+{
+	struct meminfo *child;
+	int i;
+
+	if (!(meminfo->flags & MEMINFO_FLAG_CSUM_VALID))
+		return;
+	if (meminfo->flags & MEMINFO_FLAG_ELEM_IND) {
+		child = (struct meminfo *) meminfo->addr;
+		for (i = 0; i < meminfo_ind_cnt(meminfo); i++) {
+			if (!(child[i].flags & MEMINFO_FLAG_ELEM_VALID))
+				continue;
+			meminfo_csum_update(&child[i]);
+		}
+	}
+	meminfo->csum = csum_partial_real((void *) meminfo->addr,
+					  meminfo->size, 0);
+}
+
+/*
+ * Verify checksum for meminfo element(s)
+ */
+int meminfo_csum_check(struct meminfo *meminfo, int recursive)
+{
+	struct meminfo *child;
+	u32 csum;
+	int i;
+
+	if (!(meminfo->flags & MEMINFO_FLAG_CSUM_VALID))
+		return 0;
+	csum = csum_partial_real((void *) meminfo->addr, meminfo->size, 0);
+	if (meminfo->csum != csum)
+		return -EINVAL;
+	if (!recursive)
+		return 0;
+	if (meminfo->flags & MEMINFO_FLAG_ELEM_IND) {
+		child = (struct meminfo *) meminfo->addr;
+		for (i = 0; i < meminfo_ind_cnt(meminfo); i++) {
+			if (!(child[i].flags & MEMINFO_FLAG_ELEM_VALID))
+				continue;
+			if (meminfo_csum_check(&child[i], 1))
+				return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Update root meminfo element and corresponding checksum
+ */
+static void meminfo_update_root(void)
+{
+	struct meminfo root;
+	u32 csum;
+
+	copy_from_absolute_zero(&root, &S390_lowcore.meminfo, sizeof(root));
+	meminfo_csum_update(&root);
+	copy_to_absolute_zero(&S390_lowcore.meminfo, &root, sizeof(root));
+	csum = csum_partial(&root, sizeof(root), 0);
+	copy_to_absolute_zero(&S390_lowcore.meminfo_csum, &csum, sizeof(csum));
+}
+
+/*
+ * Add memory info for given type
+ */
+void meminfo_update(enum meminfo_type type, void *buf, unsigned long size,
+		    u32 flags)
+{
+	struct meminfo *meminfo = &meminfo_array[type];
+
+	meminfo->addr = (unsigned long) buf;
+	meminfo->size = size;
+	meminfo->flags = flags;
+	meminfo_update_root();
+}
+
+/*
+ * Init meminfo and setup absolute zero pointer
+ */
+void __init meminfo_init(void)
+{
+	struct meminfo root;
+
+	root.addr = (unsigned long) &meminfo_array,
+	root.size = sizeof(meminfo_array),
+	root.flags = MEMINFO_FLAG_ELEM_VALID | MEMINFO_FLAG_ELEM_IND |
+		MEMINFO_FLAG_CSUM_VALID;
+	copy_to_absolute_zero(&S390_lowcore.meminfo, &root, sizeof(root));
+	meminfo_update_root();
+}
+
+#ifdef CONFIG_CRASH_DUMP
+/*
+ * Get meminfo from old kernel
+ */
+int meminfo_old_get(enum meminfo_type type, struct meminfo *meminfo)
+{
+	struct meminfo root, *meminfo_array_old;
+
+	if (!oldmem_base)
+		return -ENOENT;
+	memcpy_real(&root, (void *) oldmem_base + __LC_MEMINFO, sizeof(root));
+	if (type > meminfo_ind_cnt(&root))
+		return -ENOENT;
+	meminfo_array_old = (struct meminfo *) (oldmem_base + root.addr);
+	memcpy_real(meminfo, &meminfo_array_old[type], sizeof(*meminfo));
+	if (!(meminfo->flags & MEMINFO_FLAG_ELEM_VALID))
+		return -ENOENT;
+	return 0;
+}
+#endif
--- a/arch/s390/kernel/reipl64.S
+++ b/arch/s390/kernel/reipl64.S
@@ -1,5 +1,5 @@
 /*
- *    Copyright IBM Corp 2000,2009
+ *    Copyright IBM Corp 2000,2011
  *    Author(s): Holger Smolinski <Holger.Smolinski@de.ibm.com>,
  *		 Denis Joseph Barrow,
  */
@@ -7,6 +7,66 @@
 #include <asm/asm-offsets.h>
 
 #
+# do_store_status
+#
+# Prerequisites to run this function:
+# - DAT mode is off
+# - Prefix register is set to zero
+# - Original prefix register is stored in "dump_prefix_page"
+# - Lowcore protection is off
+#
+	.globl	do_store_status
+do_store_status:
+	/* Save register one and load save area base */
+	stg	%r1,__LC_SAVE_AREA_64(%r0)
+	lghi	%r1,SAVE_AREA_BASE
+	/* General purpose registers */
+	stmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	lg	%r2,__LC_SAVE_AREA_64(%r0)
+	stg	%r2,__LC_GPREGS_SAVE_AREA-SAVE_AREA_BASE+8(%r1)
+	/* Control registers */
+	stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Access registers */
+	stam	%a0,%a15,__LC_AREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Floating point registers */
+	std	%f0, 0x00 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f1, 0x08 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f2, 0x10 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f3, 0x18 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f4, 0x20 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f5, 0x28 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f6, 0x30 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f7, 0x38 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f8, 0x40 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f9, 0x48 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f10,0x50 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f11,0x58 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f12,0x60 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f13,0x68 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f14,0x70 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f15,0x78 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Floating point control register */
+	stfpc	__LC_FP_CREG_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* CPU timer */
+	stpt	__LC_CPU_TIMER_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Saved prefix register */
+	larl	%r2,dump_prefix_page
+	mvc	__LC_PREFIX_SAVE_AREA-SAVE_AREA_BASE(4,%r1),0(%r2)
+	/* Clock comparator - seven bytes */
+	larl	%r2,.Lclkcmp
+	stckc	0(%r2)
+	mvc	__LC_CLOCK_COMP_SAVE_AREA-SAVE_AREA_BASE + 1(7,%r1),1(%r2)
+	/* Program status word */
+	epsw	%r2,%r3
+	st	%r2,__LC_PSW_SAVE_AREA-SAVE_AREA_BASE + 0(%r1)
+	st	%r3,__LC_PSW_SAVE_AREA-SAVE_AREA_BASE + 4(%r1)
+	larl	%r2,do_store_status
+	stg	%r2,__LC_PSW_SAVE_AREA-SAVE_AREA_BASE + 8(%r1)
+	br	%r14
+.align	8
+.Lclkcmp:	.quad	0x0000000000000000
+
+#
 # do_reipl_asm
 # Parameter: r2 = schid of reipl device
 #
@@ -14,22 +74,7 @@
 		.globl	do_reipl_asm
 do_reipl_asm:	basr	%r13,0
 .Lpg0:		lpswe	.Lnewpsw-.Lpg0(%r13)
-.Lpg1:		# do store status of all registers
-
-		stg	%r1,.Lregsave-.Lpg0(%r13)
-		lghi	%r1,0x1000
-		stmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-0x1000(%r1)
-		lg	%r0,.Lregsave-.Lpg0(%r13)
-		stg	%r0,__LC_GPREGS_SAVE_AREA-0x1000+8(%r1)
-		stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-0x1000(%r1)
-		stam	%a0,%a15,__LC_AREGS_SAVE_AREA-0x1000(%r1)
-		lg	%r10,.Ldump_pfx-.Lpg0(%r13)
-		mvc	__LC_PREFIX_SAVE_AREA-0x1000(4,%r1),0(%r10)
-		stfpc	__LC_FP_CREG_SAVE_AREA-0x1000(%r1)
-		stckc	.Lclkcmp-.Lpg0(%r13)
-		mvc	__LC_CLOCK_COMP_SAVE_AREA-0x1000(7,%r1),.Lclkcmp-.Lpg0(%r13)
-		stpt	__LC_CPU_TIMER_SAVE_AREA-0x1000(%r1)
-		stg	%r13, __LC_PSW_SAVE_AREA-0x1000+8(%r1)
+.Lpg1:		brasl	%r14,do_store_status
 
 		lctlg	%c6,%c6,.Lall-.Lpg0(%r13)
 		lgr	%r1,%r2
@@ -66,10 +111,7 @@ do_reipl_asm:	basr	%r13,0
 		st	%r14,.Ldispsw+12-.Lpg0(%r13)
 		lpswe	.Ldispsw-.Lpg0(%r13)
 		.align	8
-.Lclkcmp:	.quad	0x0000000000000000
 .Lall:		.quad	0x00000000ff000000
-.Ldump_pfx:	.quad	dump_prefix_page
-.Lregsave:	.quad	0x0000000000000000
 		.align	16
 /*
  * These addresses have to be 31 bit otherwise
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -42,6 +42,9 @@
 #include <linux/reboot.h>
 #include <linux/topology.h>
 #include <linux/ftrace.h>
+#include <linux/kexec.h>
+#include <linux/crash_dump.h>
+#include <linux/memory.h>
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
@@ -57,6 +60,7 @@
 #include <asm/ebcdic.h>
 #include <asm/compat.h>
 #include <asm/kvm_virtio.h>
+#include <asm/diag.h>
 
 long psw_kernel_bits	= (PSW_BASE_BITS | PSW_MASK_DAT | PSW_ASC_PRIMARY |
 			   PSW_MASK_MCHECK | PSW_DEFAULT_KEY);
@@ -346,7 +350,7 @@ setup_lowcore(void)
 	lc = __alloc_bootmem_low(LC_PAGES * PAGE_SIZE, LC_PAGES * PAGE_SIZE, 0);
 	lc->restart_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
 	lc->restart_psw.addr =
-		PSW_ADDR_AMODE | (unsigned long) restart_int_handler;
+		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 	if (user_mode != HOME_SPACE_MODE)
 		lc->restart_psw.mask |= PSW_ASC_HOME;
 	lc->external_new_psw.mask = psw_kernel_bits;
@@ -435,6 +439,9 @@ static void __init setup_resources(void)
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		if (!memory_chunk[i].size)
 			continue;
+		if (memory_chunk[i].type == CHUNK_OLDMEM ||
+		    memory_chunk[i].type == CHUNK_CRASHK)
+			continue;
 		res = alloc_bootmem_low(sizeof(*res));
 		res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
 		switch (memory_chunk[i].type) {
@@ -479,6 +486,7 @@ static void __init setup_memory_end(void
 	unsigned long max_mem;
 	int i;
 
+
 #ifdef CONFIG_ZFCPDUMP
 	if (ipl_info.type == IPL_TYPE_FCP_DUMP) {
 		memory_end = ZFCPDUMP_HSA_SIZE;
@@ -529,6 +537,193 @@ static void __init setup_memory_end(void
 		memory_end = memory_size;
 }
 
+void *restart_stack __attribute__((__section__(".data")));
+
+/*
+ * Setup new PSW and allocate stack for PSW restart interrupt
+ */
+static void __init setup_restart_psw(void)
+{
+	psw_t psw;
+
+	restart_stack = __alloc_bootmem(ASYNC_SIZE, ASYNC_SIZE, 0);
+	restart_stack += ASYNC_SIZE;
+
+	/*
+	 * Setup restart PSW for absolute zero lowcore. This is necesary
+	 * if PSW restart is done on an offline CPU that has lowcore zero
+	 */
+	psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
+	psw.addr = PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
+	copy_to_absolute_zero(&S390_lowcore.restart_psw, &psw, sizeof(psw));
+}
+
+#ifdef CONFIG_CRASH_DUMP
+
+/*
+ * Find suitable location for crashkernel memory
+ */
+static unsigned long __init find_crash_base(unsigned long crash_size)
+{
+	unsigned long crash_base;
+	struct mem_chunk *chunk;
+	int i;
+
+	if (is_kdump_kernel() && (crash_size == oldmem_size))
+		return oldmem_base;
+
+	for (i = MEMORY_CHUNKS - 1; i >= 0; i--) {
+		chunk = &memory_chunk[i];
+		if (chunk->size == 0)
+			continue;
+		if (chunk->type != CHUNK_READ_WRITE)
+			continue;
+		if (chunk->size < crash_size)
+			continue;
+		crash_base = max(chunk->addr, crash_size);
+		crash_base = max(crash_base, ZFCPDUMP_HSA_SIZE_MAX);
+		crash_base = max(crash_base, (unsigned long) INITRD_START +
+				 INITRD_SIZE);
+		crash_base = PAGE_ALIGN(crash_base);
+		if (crash_base >= chunk->addr + chunk->size)
+			continue;
+		if (chunk->addr + chunk->size - crash_base < crash_size)
+			continue;
+		crash_base = chunk->size - crash_size;
+		return crash_base;
+	}
+	return 0;
+}
+
+/*
+ * Check if crash_base and crash_size is valid
+ */
+static int __init verify_crash_base(unsigned long crash_base,
+				    unsigned long crash_size)
+{
+	struct mem_chunk *chunk;
+	int i;
+
+	/*
+	 * Because we do the swap to zero, we must have at least 'crash_size'
+	 * bytes free space before crash_base
+	 */
+	if (crash_size > crash_base)
+		return -EINVAL;
+
+	/* First memory chunk must be at least crash_size */
+	if (memory_chunk[0].size < crash_size)
+		return -EINVAL;
+
+	/* Check if we fit into the respective memory chunk */
+	for (i = 0; i < MEMORY_CHUNKS; i++) {
+		chunk = &memory_chunk[i];
+		if (chunk->size == 0)
+			continue;
+		if (crash_base < chunk->addr)
+			continue;
+		if (crash_base >= chunk->addr + chunk->size)
+			continue;
+		/* we have found the memory chunk */
+		if (crash_base + crash_size > chunk->addr + chunk->size)
+			return -EINVAL;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/*
+ * Reserve kdump memory by creating a memory hole in the mem_chunk array
+ */
+static void __init reserve_kdump_bootmem(unsigned long addr, unsigned long size,
+					 int type)
+{
+	create_mem_hole(memory_chunk, addr, size, type);
+}
+
+/*
+ * When kdump is enabled, we have to ensure that no memory from
+ * the area [0 - crashkernel memory size] is set offline
+ */
+static int kdump_mem_notifier(struct notifier_block *nb,
+			      unsigned long action, void *data)
+{
+	struct memory_notify *arg = data;
+
+	if (arg->start_pfn >= PFN_DOWN(crashk_res.end - crashk_res.start + 1))
+		return NOTIFY_OK;
+	return NOTIFY_BAD;
+}
+
+static struct notifier_block kdump_mem_nb = {
+	.notifier_call = kdump_mem_notifier,
+};
+#endif
+
+/*
+ * Make sure that oldmem, where the dump is stored, is protected
+ */
+static void reserve_oldmem(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	if (!is_kdump_kernel())
+		return;
+
+	reserve_kdump_bootmem(oldmem_base, oldmem_size, CHUNK_OLDMEM);
+	reserve_kdump_bootmem(oldmem_size, memory_end - oldmem_size,
+			      CHUNK_OLDMEM);
+	if (oldmem_base + oldmem_size == real_memory_size)
+		saved_max_pfn = PFN_DOWN(oldmem_base) - 1;
+	else
+		saved_max_pfn = PFN_DOWN(real_memory_size) - 1;
+#endif
+}
+
+/*
+ * Reserve memory for kdump kernel to be loaded with kexec
+ */
+static void __init reserve_crashkernel(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	unsigned long long crash_base, crash_size;
+	int rc;
+
+	rc = parse_crashkernel(boot_command_line, memory_end, &crash_size,
+			       &crash_base);
+	if (rc || crash_size == 0)
+		return;
+	if (register_memory_notifier(&kdump_mem_nb))
+		return;
+	if (!crash_base)
+		crash_base = find_crash_base(crash_size);
+	if (!crash_base) {
+		pr_info("crashkernel reservation failed: %s\n",
+			"No suitable area found");
+		unregister_memory_notifier(&kdump_mem_nb);
+		return;
+	}
+	if (verify_crash_base(crash_base, crash_size)) {
+		pr_info("crashkernel reservation failed: %s\n",
+			"Invalid memory range specified");
+		unregister_memory_notifier(&kdump_mem_nb);
+		return;
+	}
+	if (!is_kdump_kernel() && MACHINE_IS_VM)
+		diag10_range(PFN_DOWN(crash_base), PFN_DOWN(crash_size));
+	crashk_res.start = crash_base;
+	crashk_res.end = crash_base + crash_size - 1;
+	insert_resource(&iomem_resource, &crashk_res);
+	meminfo_update(MEMINFO_TYPE_KDUMP_MEM, (void *) crash_base,
+		       crash_size, MEMINFO_FLAG_ELEM_VALID);
+	reserve_kdump_bootmem(crashk_res.start,
+			      crashk_res.end - crashk_res.start + 1,
+			      CHUNK_CRASHK);
+	pr_info("Reserving %lluMB of memory at %lluMB "
+		"for crashkernel (System RAM: %luMB)\n",
+		crash_size >> 20, crash_base >> 20, memory_end >> 20);
+#endif
+}
+
 static void __init
 setup_memory(void)
 {
@@ -559,6 +754,14 @@ setup_memory(void)
 		if (PFN_PHYS(start_pfn) + bmap_size > INITRD_START) {
 			start = PFN_PHYS(start_pfn) + bmap_size + PAGE_SIZE;
 
+#ifdef CONFIG_CRASH_DUMP
+			if (is_kdump_kernel()) {
+				/* Move initrd behind kdump oldmem */
+				if (start + INITRD_SIZE > oldmem_base &&
+				    start < oldmem_base + oldmem_size)
+					start = oldmem_base + oldmem_size;
+			}
+#endif
 			if (start + INITRD_SIZE > memory_end) {
 				pr_err("initrd extends beyond end of "
 				       "memory (0x%08lx > 0x%08lx) "
@@ -787,11 +990,16 @@ setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	meminfo_update(MEMINFO_TYPE_VMCOREINFO, &vmcoreinfo_note,
+		       sizeof(vmcoreinfo_note), MEMINFO_FLAG_ELEM_VALID);
 	setup_ipl();
 	setup_memory_end();
 	setup_addressing_mode();
+	reserve_oldmem();
+	reserve_crashkernel();
 	setup_memory();
 	setup_resources();
+	setup_restart_psw();
 	setup_lowcore();
 
         cpu_init();
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -38,6 +38,7 @@
 #include <linux/timex.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
+#include <linux/crash_dump.h>
 #include <asm/asm-offsets.h>
 #include <asm/ipl.h>
 #include <asm/setup.h>
@@ -281,11 +282,11 @@ void smp_ctl_clear_bit(int cr, int bit)
 }
 EXPORT_SYMBOL(smp_ctl_clear_bit);
 
-#ifdef CONFIG_ZFCPDUMP
+#if defined(CONFIG_ZFCPDUMP) || defined(CONFIG_CRASH_DUMP)
 
 static void __init smp_get_save_area(unsigned int cpu, unsigned int phy_cpu)
 {
-	if (ipl_info.type != IPL_TYPE_FCP_DUMP)
+	if (ipl_info.type != IPL_TYPE_FCP_DUMP && !is_kdump_kernel())
 		return;
 	if (cpu >= NR_CPUS) {
 		pr_warning("CPU %i exceeds the maximum %i and is excluded from "
@@ -403,6 +404,19 @@ static void __init smp_detect_cpus(void)
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		panic("smp_detect_cpus failed to allocate memory\n");
+
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel()) {
+		struct save_area *save_area;
+
+		save_area = kmalloc(sizeof(*save_area), GFP_KERNEL);
+		if (!save_area)
+			panic("could not allocate memory for save area\n");
+		crash_read_from_oldmem(save_area, sizeof(*save_area),
+				       SAVE_AREA_BASE, 0);
+		zfcpdump_save_areas[0] = save_area;
+	}
+#endif
 	/* Use sigp detection algorithm if sclp doesn't work. */
 	if (sclp_get_cpu_info(info)) {
 		smp_use_sigp_detection = 1;
@@ -470,6 +484,11 @@ int __cpuinit start_secondary(void *cpuv
 	ipi_call_unlock();
 	/* Switch on interrupts */
 	local_irq_enable();
+	__ctl_clear_bit(0, 28); /* Disable lowcore protection */
+	S390_lowcore.restart_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
+	S390_lowcore.restart_psw.addr =
+		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
+	__ctl_set_bit(0, 28); /* Enable lowcore protection */
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
 	return 0;
@@ -507,6 +526,9 @@ static int __cpuinit smp_alloc_lowcore(i
 	memset((char *)lowcore + 512, 0, sizeof(*lowcore) - 512);
 	lowcore->async_stack = async_stack + ASYNC_SIZE;
 	lowcore->panic_stack = panic_stack + PAGE_SIZE;
+	lowcore->restart_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
+	lowcore->restart_psw.addr =
+		PSW_ADDR_AMODE | (unsigned long) restart_int_handler;
 
 #ifndef CONFIG_64BIT
 	if (MACHINE_HAS_IEEE) {
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/gfp.h>
 #include <asm/system.h>
 
 /*
@@ -60,6 +61,9 @@ long probe_kernel_write(void *dst, const
 	return copied < 0 ? -EFAULT : 0;
 }
 
+/*
+ * Copy memory in real mode (kernel to kernel)
+ */
 int memcpy_real(void *dest, void *src, size_t count)
 {
 	register unsigned long _dest asm("2") = (unsigned long) dest;
@@ -85,3 +89,82 @@ int memcpy_real(void *dest, void *src, s
 	arch_local_irq_restore(flags);
 	return rc;
 }
+
+/*
+ * Copy memory from kernel (real) to user (virtual)
+ */
+int copy_to_user_real(void __user *dest, void *src, size_t count)
+{
+	int offs = 0, size, rc;
+	char *buf;
+
+	buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	rc = -EFAULT;
+	while (offs < count) {
+		size = min(PAGE_SIZE, count - offs);
+		if (memcpy_real(buf, src + offs, size))
+			goto out;
+		if (copy_to_user(dest + offs, buf, size))
+			goto out;
+		offs += size;
+	}
+	rc = 0;
+out:
+	free_page((unsigned long) buf);
+	return rc;
+}
+
+/*
+ * Copy memory from user (virtual) to kernel (real)
+ */
+int copy_from_user_real(void *dest, void __user *src, size_t count)
+{
+	int offs = 0, size, rc;
+	char *buf;
+
+	buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	rc = -EFAULT;
+	while (offs < count) {
+		size = min(PAGE_SIZE, count - offs);
+		if (copy_from_user(buf, src + offs, size))
+			goto out;
+		if (memcpy_real(dest + offs, buf, size))
+			goto out;
+		offs += size;
+	}
+	rc = 0;
+out:
+	free_page((unsigned long) buf);
+	return rc;
+}
+
+/*
+ * Copy memory to absolute zero
+ */
+void copy_to_absolute_zero(void *dest, void *src, size_t count)
+{
+	unsigned long cr0;
+
+	BUG_ON((unsigned long) dest + count >= sizeof(struct _lowcore));
+	preempt_disable();
+	__ctl_store(cr0, 0, 0);
+	__ctl_clear_bit(0, 28); /* disable lowcore protection */
+	memcpy_real(dest + store_prefix(), src, count);
+	__ctl_load(cr0, 0, 0);
+	preempt_enable();
+}
+
+/*
+ * Copy memory from absolute zero
+ */
+void copy_from_absolute_zero(void *dest, void *src, size_t count)
+{
+	BUG_ON((unsigned long) src + count >= sizeof(struct _lowcore));
+	preempt_disable();
+	memcpy_real(dest, src + store_prefix(), count);
+	preempt_enable();
+}
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -335,6 +335,9 @@ void __init vmem_map_init(void)
 	ro_start = ((unsigned long)&_stext) & PAGE_MASK;
 	ro_end = PFN_ALIGN((unsigned long)&_eshared);
 	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++) {
+		if (memory_chunk[i].type == CHUNK_CRASHK ||
+		    memory_chunk[i].type == CHUNK_OLDMEM)
+			continue;
 		start = memory_chunk[i].addr;
 		end = memory_chunk[i].addr + memory_chunk[i].size;
 		if (start >= ro_end || end <= ro_start)
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -142,22 +142,6 @@ static int memcpy_hsa_kernel(void *dest,
 	return memcpy_hsa(dest, src, count, TO_KERNEL);
 }
 
-static int memcpy_real_user(void __user *dest, unsigned long src, size_t count)
-{
-	static char buf[4096];
-	int offs = 0, size;
-
-	while (offs < count) {
-		size = min(sizeof(buf), count - offs);
-		if (memcpy_real(buf, (void *) src + offs, size))
-			return -EFAULT;
-		if (copy_to_user(dest + offs, buf, size))
-			return -EFAULT;
-		offs += size;
-	}
-	return 0;
-}
-
 static int __init init_cpu_info(enum arch_id arch)
 {
 	struct save_area *sa;
@@ -346,8 +330,8 @@ static ssize_t zcore_read(struct file *f
 
 	/* Copy from real mem */
 	size = count - mem_offs - hdr_count;
-	rc = memcpy_real_user(buf + hdr_count + mem_offs, mem_start + mem_offs,
-			      size);
+	rc = copy_to_user_real(buf + hdr_count + mem_offs,
+			       (void *) mem_start + mem_offs, size);
 	if (rc)
 		goto fail;
 

