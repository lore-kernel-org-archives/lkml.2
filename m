Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1HLNt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:49:59 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41572 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1HLNt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:49:28 -0400
Message-Id: <20110812134907.651658120@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 12 Aug 2011 15:48:54 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v3 5/8] s390: kdump backend code
References: <20110812134849.748973593@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-backend.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch provides the architecture specific part of the s390 kdump
support.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/Kconfig                |   10 +
 arch/s390/include/asm/ipl.h      |    1 
 arch/s390/include/asm/kexec.h    |    3 
 arch/s390/include/asm/setup.h    |    9 +
 arch/s390/kernel/Makefile        |    1 
 arch/s390/kernel/crash_dump.c    |   39 +++++
 arch/s390/kernel/head.S          |   16 ++
 arch/s390/kernel/head_kdump.S    |  116 +++++++++++++++++
 arch/s390/kernel/ipl.c           |    4 
 arch/s390/kernel/machine_kexec.c |  255 +++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/mem_detect.c    |   69 ++++++++++
 arch/s390/kernel/setup.c         |  190 +++++++++++++++++++++++++++++
 arch/s390/mm/vmem.c              |    3 
 13 files changed, 716 insertions(+)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -568,6 +568,16 @@ config KEXEC
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
--- a/arch/s390/include/asm/ipl.h
+++ b/arch/s390/include/asm/ipl.h
@@ -168,5 +168,6 @@ enum diag308_rc {
 
 extern int diag308(unsigned long subcode, void *addr);
 extern void diag308_reset(void);
+extern void store_status(void);
 
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
 
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -30,11 +30,15 @@
 #define IPL_DEVICE        (*(unsigned long *)  (0x10400))
 #define INITRD_START      (*(unsigned long *)  (0x10408))
 #define INITRD_SIZE       (*(unsigned long *)  (0x10410))
+#define OLDMEM_BASE       (*(unsigned long *)  (0x10418))
+#define OLDMEM_SIZE       (*(unsigned long *)  (0x10420))
 #endif /* __s390x__ */
 #define COMMAND_LINE      ((char *)            (0x10480))
 
 #define CHUNK_READ_WRITE 0
 #define CHUNK_READ_ONLY  1
+#define CHUNK_OLDMEM     4
+#define CHUNK_CRASHK     5
 
 struct mem_chunk {
 	unsigned long addr;
@@ -48,6 +52,8 @@ extern int memory_end_set;
 extern unsigned long memory_end;
 
 void detect_memory_layout(struct mem_chunk chunk[]);
+void create_mem_hole(struct mem_chunk memory_chunk[], unsigned long addr,
+		     unsigned long size, int type);
 
 #define PRIMARY_SPACE_MODE	0
 #define ACCESS_REGISTER_MODE	1
@@ -106,6 +112,7 @@ extern unsigned int user_mode;
 #endif /* __s390x__ */
 
 #define ZFCPDUMP_HSA_SIZE	(32UL<<20)
+#define ZFCPDUMP_HSA_SIZE_MAX	(64UL<<20)
 
 /*
  * Console mode. Override with conmode=
@@ -138,6 +145,8 @@ extern char kernel_nss_name[];
 #define IPL_DEVICE        0x10400
 #define INITRD_START      0x10408
 #define INITRD_SIZE       0x10410
+#define OLDMEM_BASE       0x10418
+#define OLDMEM_SIZE       0x10420
 #endif /* __s390x__ */
 #define COMMAND_LINE      0x10480
 
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_FUNCTION_TRACER)	+= $(if $(
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)  += ftrace.o
+obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 # Kexec part
 S390_KEXEC_OBJS := machine_kexec.o crash.o
--- /dev/null
+++ b/arch/s390/kernel/crash_dump.c
@@ -0,0 +1,39 @@
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
+ *  - [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE] is mapped to [0 - OLDMEM_SIZE].
+ *  - [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
+ */
+ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
+			 size_t csize, unsigned long offset, int userbuf)
+{
+	unsigned long src;
+	int rc;
+
+	if (!csize)
+		return 0;
+
+	src = (pfn << PAGE_SHIFT) + offset;
+	if (src < OLDMEM_SIZE)
+		src += OLDMEM_BASE;
+	else if (src > OLDMEM_BASE &&
+		 src < OLDMEM_BASE + OLDMEM_SIZE)
+		src -= OLDMEM_BASE;
+	if (userbuf)
+		rc = copy_to_user_real((void __user *) buf, (void *) src,
+				       csize);
+	else
+		rc = memcpy_real(buf, (void *) src, csize);
+	return rc < 0 ? rc : csize;
+}
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -449,10 +449,22 @@ ENTRY(start)
 #
 	.org	0x10000
 ENTRY(startup)
+	j	.Lep_startup_normal
+	.org	0x10008
+	.ascii	"S390EP"
+	.byte	0x00,0x01
+#
+# kdump startup-code at 0x10010, running in 64 bit absolute addressing mode
+#
+	.org	0x10010
+ENTRY(startup_kdump)
+	j	.Lep_startup_kdump
+.Lep_startup_normal:
 	basr	%r13,0			# get base
 .LPG0:
 	xc	0x200(256),0x200	# partially clear lowcore
 	xc	0x300(256),0x300
+	xc	0xe00(256),0xe00
 	stck	__LC_LAST_UPDATE_CLOCK
 	spt	5f-.LPG0(%r13)
 	mvc	__LC_LAST_UPDATE_TIMER(8),5f-.LPG0(%r13)
@@ -534,6 +546,8 @@ ENTRY(startup)
 	.align	8
 5:	.long	0x7fffffff,0xffffffff
 
+#include "head_kdump.S"
+
 #
 # params at 10400 (setup.h)
 #
@@ -541,6 +555,8 @@ ENTRY(startup)
 	.long	0,0			# IPL_DEVICE
 	.long	0,0			# INITRD_START
 	.long	0,0			# INITRD_SIZE
+	.long	0,0			# OLDMEM_BASE
+	.long	0,0			# OLDMEM_SIZE
 
 	.org	COMMAND_LINE
 	.byte	"root=/dev/ram0 ro"
--- /dev/null
+++ b/arch/s390/kernel/head_kdump.S
@@ -0,0 +1,116 @@
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
+	larl	%r4,startup
+	lg	%r2,0x418(%r4)			# Get kdump base
+	lg	%r3,0x420(%r4)			# Get kdump size
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
+0:
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
@@ -1738,6 +1739,9 @@ static struct kobj_attribute on_restart_
 void do_restart(void)
 {
 	smp_send_stop();
+#ifdef CONFIG_CRASH_DUMP
+	crash_kexec(NULL);
+#endif
 	on_restart_trigger.action->fn(&on_restart_trigger);
 	stop_run(&on_restart_trigger);
 }
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -21,12 +21,260 @@
 #include <asm/smp.h>
 #include <asm/reset.h>
 #include <asm/ipl.h>
+#include <asm/diag.h>
 
 typedef void (*relocate_kernel_t)(kimage_entry_t *, unsigned long);
 
 extern const unsigned char relocate_kernel[];
 extern const unsigned long long relocate_kernel_len;
 
+#ifdef CONFIG_CRASH_DUMP
+
+#define ROUNDUP(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define PTR_ADD(x, y) (((char *) (x)) + ((unsigned long) (y)))
+
+#ifndef NT_FPREGSET
+#define NT_FPREGSET 2
+#endif
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
+static void *nt_prstatus(void *ptr, struct save_area *sa)
+{
+	struct elf_prstatus nt_prstatus;
+	static int cpu_nr = 1;
+
+	memset(&nt_prstatus, 0, sizeof(nt_prstatus));
+	memcpy(&nt_prstatus.pr_reg.gprs, sa->gp_regs, sizeof(sa->gp_regs));
+	memcpy(&nt_prstatus.pr_reg.psw, sa->psw, sizeof(sa->psw));
+	memcpy(&nt_prstatus.pr_reg.acrs, sa->acc_regs, sizeof(sa->acc_regs));
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
+static void *nt_fpregset(void *ptr, struct save_area *sa)
+{
+	struct nt_fpregset_64 nt_fpregset;
+
+	memset(&nt_fpregset, 0, sizeof(nt_fpregset));
+	memcpy(&nt_fpregset.fpc, &sa->fp_ctrl_reg, sizeof(sa->fp_ctrl_reg));
+	memcpy(&nt_fpregset.fprs, &sa->fp_regs, sizeof(sa->fp_regs));
+
+	return nt_init(ptr, NT_FPREGSET, &nt_fpregset, sizeof(nt_fpregset),
+			 "CORE");
+}
+
+/*
+ * Initialize timer note
+ */
+static void *nt_s390_timer(void *ptr, struct save_area *sa)
+{
+	return nt_init(ptr, NT_S390_TIMER, &sa->timer, sizeof(sa->timer),
+			 KEXEC_CORE_NOTE_NAME);
+}
+
+/*
+ * Initialize TOD clock comparator note
+ */
+static void *nt_s390_tod_cmp(void *ptr, struct save_area *sa)
+{
+	return nt_init(ptr, NT_S390_TODCMP, &sa->clk_cmp,
+		       sizeof(sa->clk_cmp), KEXEC_CORE_NOTE_NAME);
+}
+
+/*
+ * Initialize TOD programmable register note
+ */
+static void *nt_s390_tod_preg(void *ptr, struct save_area *sa)
+{
+	return nt_init(ptr, NT_S390_TODPREG, &sa->tod_reg,
+		       sizeof(sa->tod_reg), KEXEC_CORE_NOTE_NAME);
+}
+
+/*
+ * Initialize control register note
+ */
+static void *nt_s390_ctrs(void *ptr, struct save_area *sa)
+{
+	return nt_init(ptr, NT_S390_CTRS, &sa->ctrl_regs,
+		       sizeof(sa->ctrl_regs), KEXEC_CORE_NOTE_NAME);
+}
+
+/*
+ * Initialize prefix register note
+ */
+static void *nt_s390_prefix(void *ptr, struct save_area *sa)
+{
+	return nt_init(ptr, NT_S390_PREFIX, &sa->pref_reg,
+			 sizeof(sa->pref_reg), KEXEC_CORE_NOTE_NAME);
+}
+
+/*
+ * Final empty node
+ */
+static void nt_final(void *ptr)
+{
+	memset(ptr, 0, sizeof(struct elf_note));
+}
+
+/*
+ * Add create ELF notes for CPU
+ */
+static void add_elf_notes(int cpu)
+{
+	struct save_area *sa = (void *) 4608 + store_prefix();
+	void *ptr;
+
+	memcpy((void *) (4608UL + sa->pref_reg), sa, sizeof(*sa));
+	ptr = (u64 *) per_cpu_ptr(crash_notes, cpu);
+	ptr = nt_prstatus(ptr, sa);
+	ptr = nt_fpregset(ptr, sa);
+	ptr = nt_s390_timer(ptr, sa);
+	ptr = nt_s390_tod_cmp(ptr, sa);
+	ptr = nt_s390_tod_preg(ptr, sa);
+	ptr = nt_s390_ctrs(ptr, sa);
+	ptr = nt_s390_prefix(ptr, sa);
+	nt_final(ptr);
+}
+
+/*
+ * Store status of next available physical CPU
+ */
+static int store_status_next(int start_cpu, int this_cpu)
+{
+	struct save_area *sa = (void *) 4608 + store_prefix();
+	int cpu, rc;
+
+	for (cpu = start_cpu; cpu < 65536; cpu++) {
+		if (cpu == this_cpu)
+			continue;
+		do {
+			rc = raw_sigp(cpu, sigp_stop_and_store_status);
+		} while (rc == sigp_busy);
+		if (rc != sigp_order_code_accepted)
+			continue;
+		if (sa->pref_reg)
+			return cpu;
+	}
+	return -1;
+}
+
+/*
+ * Initialize CPU ELF notes
+ */
+void setup_regs(void)
+{
+	int cpu, this_cpu, phys_cpu = 0, first = 1;
+
+	this_cpu = stap();
+
+	store_status();
+	if (!S390_lowcore.prefixreg_save_area)
+		first = 0;
+	for_each_online_cpu(cpu) {
+		if (first) {
+			add_elf_notes(cpu);
+			first = 0;
+			continue;
+		}
+		phys_cpu = store_status_next(phys_cpu, this_cpu);
+		if (phys_cpu == -1)
+			return;
+		add_elf_notes(cpu);
+		phys_cpu++;
+	}
+}
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
+ * Start kdump
+ */
+static void __machine_kdump(void *image)
+{
+	int (*start_kdump)(int) = (void *)((struct kimage *) image)->start;
+
+	pfault_fini();
+	s390_reset_system();
+	__load_psw_mask(PSW_BASE_BITS | PSW_DEFAULT_KEY);
+	setup_regs();
+	start_kdump(1);
+	disabled_wait((unsigned long) __builtin_return_address(0));
+}
+
+#endif
+
+/*
+ * Give back memory to hypervisor before new kdump is loaded
+ */
+static int machine_kexec_prepare_kdump(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	if (MACHINE_IS_VM)
+		diag10_range(PFN_DOWN(crashk_res.start),
+			     PFN_DOWN(crashk_res.end - crashk_res.start + 1));
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 int machine_kexec_prepare(struct kimage *image)
 {
 	void *reboot_code_buffer;
@@ -35,6 +283,9 @@ int machine_kexec_prepare(struct kimage
 	if (ipl_flags & IPL_NSS_VALID)
 		return -ENOSYS;
 
+	if (image->type == KEXEC_TYPE_CRASH)
+		return machine_kexec_prepare_kdump();
+
 	/* We don't support anything but the default image type for now. */
 	if (image->type != KEXEC_TYPE_DEFAULT)
 		return -EINVAL;
@@ -73,6 +324,10 @@ static void __machine_kexec(void *data)
 void machine_kexec(struct kimage *image)
 {
 	tracer_disable();
+#ifdef CONFIG_CRASH_DUMP
+	if (image->type == KEXEC_TYPE_CRASH)
+		smp_switch_to_ipl_cpu(__machine_kdump, image);
+#endif
 	smp_send_stop();
 	smp_switch_to_ipl_cpu(__machine_kexec, image);
 }
--- a/arch/s390/kernel/mem_detect.c
+++ b/arch/s390/kernel/mem_detect.c
@@ -62,3 +62,72 @@ void detect_memory_layout(struct mem_chu
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
@@ -550,6 +558,173 @@ static void __init setup_restart_psw(voi
 	copy_to_absolute_zero(&S390_lowcore.restart_psw, &psw, sizeof(psw));
 }
 
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
+	if (is_kdump_kernel() && (crash_size == OLDMEM_SIZE))
+		return OLDMEM_BASE;
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
+
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
+	reserve_kdump_bootmem(OLDMEM_BASE, OLDMEM_SIZE, CHUNK_OLDMEM);
+	reserve_kdump_bootmem(OLDMEM_SIZE, memory_end - OLDMEM_SIZE,
+			      CHUNK_OLDMEM);
+	if (OLDMEM_BASE + OLDMEM_SIZE == real_memory_size)
+		saved_max_pfn = PFN_DOWN(OLDMEM_BASE) - 1;
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
+	crash_base = PAGE_ALIGN(crash_base);
+	crash_size = PAGE_ALIGN(crash_size);
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
@@ -580,6 +755,14 @@ setup_memory(void)
 		if (PFN_PHYS(start_pfn) + bmap_size > INITRD_START) {
 			start = PFN_PHYS(start_pfn) + bmap_size + PAGE_SIZE;
 
+#ifdef CONFIG_CRASH_DUMP
+			if (is_kdump_kernel()) {
+				/* Move initrd behind kdump oldmem */
+				if (start + INITRD_SIZE > OLDMEM_BASE &&
+				    start < OLDMEM_BASE + OLDMEM_SIZE)
+					start = OLDMEM_BASE + OLDMEM_SIZE;
+			}
+#endif
 			if (start + INITRD_SIZE > memory_end) {
 				pr_err("initrd extends beyond end of "
 				       "memory (0x%08lx > 0x%08lx) "
@@ -644,6 +827,11 @@ setup_memory(void)
 	reserve_bootmem(start_pfn << PAGE_SHIFT, bootmap_size,
 			BOOTMEM_DEFAULT);
 
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel())
+		reserve_bootmem(elfcorehdr_addr - OLDMEM_BASE,
+				PAGE_ALIGN(elfcorehdr_size), BOOTMEM_DEFAULT);
+#endif
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (INITRD_START && INITRD_SIZE) {
 		if (INITRD_START + INITRD_SIZE <= memory_end) {
@@ -812,6 +1000,8 @@ setup_arch(char **cmdline_p)
 	setup_ipl();
 	setup_memory_end();
 	setup_addressing_mode();
+	reserve_oldmem();
+	reserve_crashkernel();
 	setup_memory();
 	setup_resources();
 	setup_restart_psw();
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

