Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab0J2PaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:30:22 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43781 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab0J2PaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:30:20 -0400
Date: Fri, 29 Oct 2010 17:30:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.37 #2
Message-ID: <20101029173014.70452b35@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

that's it for the merge window of 2.6.37. Please pull from 'for-linus'
branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (7):
      [S390] Add z196 machine type to setup_hwcaps
      [S390] Kconfig: add machine type number to code generation options
      [S390] topology: add SCHED_MC config option
      [S390] topology: fix cpu masks for topology=off case
      [S390] facility detection: remove unused variable
      [S390] vdso: get rid of redefinition warnings
      [S390] ftrace: select HAVE_C_RECORDMCOUNT

Martin Schwidefsky (1):
      [S390] fix kprobes single stepping

Michael Holzheu (1):
      [S390] hypfs: Fix error handling in hypfs_diag initialization

Sebastian Ott (1):
      [S390] tape: fix dbf usage

Stefan Weinhuber (1):
      [S390] dasd: provide a Sense Path Group ID ioctl

 arch/s390/Kconfig                       |   61 +++++++++++++++------------
 arch/s390/hypfs/hypfs_diag.c            |   19 +++++----
 arch/s390/include/asm/dasd.h            |   40 ++++++++++--------
 arch/s390/kernel/asm-offsets.c          |    6 +-
 arch/s390/kernel/early.c                |    2 -
 arch/s390/kernel/entry.S                |    1 +
 arch/s390/kernel/entry64.S              |    1 +
 arch/s390/kernel/kprobes.c              |    9 ++++-
 arch/s390/kernel/setup.c                |    3 +
 arch/s390/kernel/sysinfo.c              |    2 +
 arch/s390/kernel/topology.c             |    6 ++-
 arch/s390/kernel/vdso32/clock_getres.S  |    6 +-
 arch/s390/kernel/vdso32/clock_gettime.S |    4 +-
 arch/s390/kernel/vdso64/clock_getres.S  |    6 +-
 arch/s390/kernel/vdso64/clock_gettime.S |    4 +-
 drivers/s390/block/dasd_eckd.c          |   69 +++++++++++++++++++++++++++++++
 drivers/s390/block/dasd_eckd.h          |    1 +
 drivers/s390/char/tape_core.c           |    9 ++--
 drivers/s390/char/tape_std.c            |    4 +-
 19 files changed, 175 insertions(+), 78 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index fabb40b..e0b98e7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -80,6 +80,7 @@ config S390
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_C_RECORDMCOUNT
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
@@ -144,7 +145,7 @@ source "kernel/time/Kconfig"
 config 64BIT
 	bool "64 bit kernel"
 	help
-	  Select this option if you have a 64 bit IBM zSeries machine
+	  Select this option if you have an IBM z/Architecture machine
 	  and want to use the 64 bit addressing mode.
 
 config 32BIT
@@ -196,9 +197,18 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
+config SCHED_MC
+	def_bool y
+	prompt "Multi-core scheduler support"
+	depends on SMP
+	help
+	  Multi-core scheduler support improves the CPU scheduler's decision
+	  making when dealing with multi-core CPU chips at a cost of slightly
+	  increased overhead in some places.
+
 config SCHED_BOOK
 	bool "Book scheduler support"
-	depends on SMP
+	depends on SMP && SCHED_MC
 	help
 	  Book scheduler support improves the CPU scheduler's decision making
 	  when dealing with machines that have several books.
@@ -208,7 +218,7 @@ config MATHEMU
 	depends on MARCH_G5
 	help
 	  This option is required for IEEE compliant floating point arithmetic
-	  on older S/390 machines. Say Y unless you know your machine doesn't
+	  on older ESA/390 machines. Say Y unless you know your machine doesn't
 	  need this.
 
 config COMPAT
@@ -237,8 +247,8 @@ config S390_EXEC_PROTECT
 	  space programs and it also selects the addressing mode option above.
 	  The kernel parameter noexec=on will enable this feature and also
 	  switch the addressing modes, default is disabled. Enabling this (via
-	  kernel parameter) on machines earlier than IBM System z9-109 EC/BC
-	  will reduce system performance.
+	  kernel parameter) on machines earlier than IBM System z9 this will
+	  reduce system performance.
 
 comment "Code generation options"
 
@@ -247,49 +257,46 @@ choice
 	default MARCH_G5
 
 config MARCH_G5
-	bool "S/390 model G5 and G6"
+	bool "System/390 model G5 and G6"
 	depends on !64BIT
 	help
 	  Select this to build a 31 bit kernel that works
-	  on all S/390 and zSeries machines.
+	  on all ESA/390 and z/Architecture machines.
 
 config MARCH_Z900
-	bool "IBM eServer zSeries model z800 and z900"
+	bool "IBM zSeries model z800 and z900"
 	help
-	  Select this to optimize for zSeries machines. This
-	  will enable some optimizations that are not available
-	  on older 31 bit only CPUs.
+	  Select this to enable optimizations for model z800/z900 (2064 and
+	  2066 series). This will enable some optimizations that are not
+	  available on older ESA/390 (31 Bit) only CPUs.
 
 config MARCH_Z990
-	bool "IBM eServer zSeries model z890 and z990"
+	bool "IBM zSeries model z890 and z990"
 	help
-	  Select this enable optimizations for model z890/z990.
-	  This will be slightly faster but does not work on
-	  older machines such as the z900.
+	  Select this to enable optimizations for model z890/z990 (2084 and
+	  2086 series). The kernel will be slightly faster but will not work
+	  on older machines.
 
 config MARCH_Z9_109
 	bool "IBM System z9"
 	help
-	  Select this to enable optimizations for IBM System z9-109, IBM
-	  System z9 Enterprise Class (z9 EC), and IBM System z9 Business
-	  Class (z9 BC). The kernel will be slightly faster but will not
-	  work on older machines such as the z990, z890, z900, and z800.
+	  Select this to enable optimizations for IBM System z9 (2094 and
+	  2096 series). The kernel will be slightly faster but will not work
+	  on older machines.
 
 config MARCH_Z10
 	bool "IBM System z10"
 	help
-	  Select this to enable optimizations for IBM System z10. The
-	  kernel will be slightly faster but will not work on older
-	  machines such as the z990, z890, z900, z800, z9-109, z9-ec
-	  and z9-bc.
+	  Select this to enable optimizations for IBM System z10 (2097 and
+	  2098 series). The kernel will be slightly faster but will not work
+	  on older machines.
 
 config MARCH_Z196
 	bool "IBM zEnterprise 196"
 	help
-	  Select this to enable optimizations for IBM zEnterprise 196.
-	  The kernel will be slightly faster but will not work on older
-	  machines such as the z990, z890, z900, z800, z9-109, z9-ec,
-	  z9-bc, z10-ec and z10-bc.
+	  Select this to enable optimizations for IBM zEnterprise 196
+	  (2817 series). The kernel will be slightly faster but will not work
+	  on older machines.
 
 endchoice
 
diff --git a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
index 020e51c..cd4a81b 100644
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -638,18 +638,21 @@ __init int hypfs_diag_init(void)
 		pr_err("The hardware system does not support hypfs\n");
 		return -ENODATA;
 	}
-	rc = diag224_get_name_table();
-	if (rc) {
-		diag204_free_buffer();
-		pr_err("The hardware system does not provide all "
-		       "functions required by hypfs\n");
-	}
 	if (diag204_info_type == INFO_EXT) {
 		rc = hypfs_dbfs_init();
 		if (rc)
-			diag204_free_buffer();
+			return rc;
 	}
-	return rc;
+	if (MACHINE_IS_LPAR) {
+		rc = diag224_get_name_table();
+		if (rc) {
+			pr_err("The hardware system does not provide all "
+			       "functions required by hypfs\n");
+			debugfs_remove(dbfs_d204_file);
+			return rc;
+		}
+	}
+	return 0;
 }
 
 void hypfs_diag_exit(void)
diff --git a/arch/s390/include/asm/dasd.h b/arch/s390/include/asm/dasd.h
index 218bce8..b604a91 100644
--- a/arch/s390/include/asm/dasd.h
+++ b/arch/s390/include/asm/dasd.h
@@ -217,6 +217,25 @@ typedef struct dasd_symmio_parms {
 	int rssd_result_len;
 } __attribute__ ((packed)) dasd_symmio_parms_t;
 
+/*
+ * Data returned by Sense Path Group ID (SNID)
+ */
+struct dasd_snid_data {
+	struct {
+		__u8 group:2;
+		__u8 reserve:2;
+		__u8 mode:1;
+		__u8 res:3;
+	} __attribute__ ((packed)) path_state;
+	__u8 pgid[11];
+} __attribute__ ((packed));
+
+struct dasd_snid_ioctl_data {
+	struct dasd_snid_data data;
+	__u8 path_mask;
+} __attribute__ ((packed));
+
+
 /********************************************************************************
  * SECTION: Definition of IOCTLs
  *
@@ -261,25 +280,10 @@ typedef struct dasd_symmio_parms {
 /* Set Attributes (cache operations) */
 #define BIODASDSATTR   _IOW(DASD_IOCTL_LETTER,2,attrib_data_t) 
 
+/* Get Sense Path Group ID (SNID) data */
+#define BIODASDSNID    _IOWR(DASD_IOCTL_LETTER, 1, struct dasd_snid_ioctl_data)
+
 #define BIODASDSYMMIO  _IOWR(DASD_IOCTL_LETTER, 240, dasd_symmio_parms_t)
 
 #endif				/* DASD_H */
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4 
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index f3c1b82..33982e7 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -66,9 +66,9 @@ int main(void)
 	DEFINE(__VDSO_ECTG_BASE, offsetof(struct vdso_per_cpu_data, ectg_timer_base));
 	DEFINE(__VDSO_ECTG_USER, offsetof(struct vdso_per_cpu_data, ectg_user_time));
 	/* constants used by the vdso */
-	DEFINE(CLOCK_REALTIME, CLOCK_REALTIME);
-	DEFINE(CLOCK_MONOTONIC, CLOCK_MONOTONIC);
-	DEFINE(CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
+	DEFINE(__CLOCK_REALTIME, CLOCK_REALTIME);
+	DEFINE(__CLOCK_MONOTONIC, CLOCK_MONOTONIC);
+	DEFINE(__CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
 	BLANK();
 	/* constants for SIGP */
 	DEFINE(__SIGP_STOP, sigp_stop);
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index d149609..3b7e7dd 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -282,8 +282,6 @@ static noinline __init void setup_facility_list(void)
 static noinline __init void setup_hpage(void)
 {
 #ifndef CONFIG_DEBUG_PAGEALLOC
-	unsigned int facilities;
-
 	if (!test_facility(2) || !test_facility(8))
 		return;
 	S390_lowcore.machine_flags |= MACHINE_FLAG_HPAGE;
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 5efce72..1ecc337 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -557,6 +557,7 @@ pgm_svcper:
 # per was called from kernel, must be kprobes
 #
 kernel_per:
+	REENABLE_IRQS
 	mvi	SP_SVCNR(%r15),0xff	# set trap indication to pgm check
 	mvi	SP_SVCNR+1(%r15),0xff
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index a2be239..8f3e802 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -568,6 +568,7 @@ pgm_svcper:
 # per was called from kernel, must be kprobes
 #
 kernel_per:
+	REENABLE_IRQS
 	xc	SP_SVCNR(2,%r15),SP_SVCNR(%r15)	# clear svc number
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	brasl	%r14,do_single_step
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 2a3d2bf..d60fc43 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -316,6 +316,8 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		return 1;
 
 ss_probe:
+	if (regs->psw.mask & (PSW_MASK_PER | PSW_MASK_IO))
+		local_irq_disable();
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_HIT_SS;
 	return 1;
@@ -463,6 +465,8 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 		goto out;
 	}
 	reset_current_kprobe();
+	if (regs->psw.mask & (PSW_MASK_PER | PSW_MASK_IO))
+		local_irq_enable();
 out:
 	preempt_enable_no_resched();
 
@@ -502,8 +506,11 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		regs->psw.mask |= kcb->kprobe_saved_imask;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
-		else
+		else {
 			reset_current_kprobe();
+			if (regs->psw.mask & (PSW_MASK_PER | PSW_MASK_IO))
+				local_irq_enable();
+		}
 		preempt_enable_no_resched();
 		break;
 	case KPROBE_HIT_ACTIVE:
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e3ceb91..6f63508 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -761,6 +761,9 @@ static void __init setup_hwcaps(void)
 	case 0x2098:
 		strcpy(elf_platform, "z10");
 		break;
+	case 0x2817:
+		strcpy(elf_platform, "z196");
+		break;
 	}
 }
 
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index f04d93a..5c9e439 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -106,11 +106,13 @@ static int stsi_15_1_x(struct sysinfo_15_1_x *info, char *page, int len)
 	for (i = 0; i < TOPOLOGY_NR_MAG; i++)
 		len += sprintf(page + len, " %d", info->mag[i]);
 	len += sprintf(page + len, "\n");
+#ifdef CONFIG_SCHED_MC
 	store_topology(info);
 	len += sprintf(page + len, "CPU Topology SW:     ");
 	for (i = 0; i < TOPOLOGY_NR_MAG; i++)
 		len += sprintf(page + len, " %d", info->mag[i]);
 	len += sprintf(page + len, "\n");
+#endif
 	return len;
 }
 
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index a9dee90..94b06c3 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -53,8 +53,10 @@ static cpumask_t cpu_group_map(struct mask_info *info, unsigned int cpu)
 	cpumask_t mask;
 
 	cpus_clear(mask);
-	if (!topology_enabled || !MACHINE_HAS_TOPOLOGY)
-		return cpu_possible_map;
+	if (!topology_enabled || !MACHINE_HAS_TOPOLOGY) {
+		cpumask_copy(&mask, cpumask_of(cpu));
+		return mask;
+	}
 	while (info) {
 		if (cpu_isset(cpu, info->mask)) {
 			mask = info->mask;
diff --git a/arch/s390/kernel/vdso32/clock_getres.S b/arch/s390/kernel/vdso32/clock_getres.S
index 9532c4e..36aaa25 100644
--- a/arch/s390/kernel/vdso32/clock_getres.S
+++ b/arch/s390/kernel/vdso32/clock_getres.S
@@ -19,9 +19,9 @@
 	.type  __kernel_clock_getres,@function
 __kernel_clock_getres:
 	.cfi_startproc
-	chi	%r2,CLOCK_REALTIME
+	chi	%r2,__CLOCK_REALTIME
 	je	0f
-	chi	%r2,CLOCK_MONOTONIC
+	chi	%r2,__CLOCK_MONOTONIC
 	jne	3f
 0:	ltr	%r3,%r3
 	jz	2f				/* res == NULL */
@@ -34,6 +34,6 @@ __kernel_clock_getres:
 3:	lhi	%r1,__NR_clock_getres		/* fallback to svc */
 	svc	0
 	br	%r14
-4:	.long	CLOCK_REALTIME_RES
+4:	.long	__CLOCK_REALTIME_RES
 	.cfi_endproc
 	.size	__kernel_clock_getres,.-__kernel_clock_getres
diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index 9696439..b2224e0 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -21,9 +21,9 @@ __kernel_clock_gettime:
 	.cfi_startproc
 	basr	%r5,0
 0:	al	%r5,21f-0b(%r5)			/* get &_vdso_data */
-	chi	%r2,CLOCK_REALTIME
+	chi	%r2,__CLOCK_REALTIME
 	je	10f
-	chi	%r2,CLOCK_MONOTONIC
+	chi	%r2,__CLOCK_MONOTONIC
 	jne	19f
 
 	/* CLOCK_MONOTONIC */
diff --git a/arch/s390/kernel/vdso64/clock_getres.S b/arch/s390/kernel/vdso64/clock_getres.S
index 9ce8caa..176e1f7 100644
--- a/arch/s390/kernel/vdso64/clock_getres.S
+++ b/arch/s390/kernel/vdso64/clock_getres.S
@@ -19,9 +19,9 @@
 	.type  __kernel_clock_getres,@function
 __kernel_clock_getres:
 	.cfi_startproc
-	cghi	%r2,CLOCK_REALTIME
+	cghi	%r2,__CLOCK_REALTIME
 	je	0f
-	cghi	%r2,CLOCK_MONOTONIC
+	cghi	%r2,__CLOCK_MONOTONIC
 	je	0f
 	cghi	%r2,-2		/* CLOCK_THREAD_CPUTIME_ID for this thread */
 	jne	2f
@@ -39,6 +39,6 @@ __kernel_clock_getres:
 2:	lghi	%r1,__NR_clock_getres		/* fallback to svc */
 	svc	0
 	br	%r14
-3:	.quad	CLOCK_REALTIME_RES
+3:	.quad	__CLOCK_REALTIME_RES
 	.cfi_endproc
 	.size	__kernel_clock_getres,.-__kernel_clock_getres
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index f404678..d46c95e 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -20,11 +20,11 @@
 __kernel_clock_gettime:
 	.cfi_startproc
 	larl	%r5,_vdso_data
-	cghi	%r2,CLOCK_REALTIME
+	cghi	%r2,__CLOCK_REALTIME
 	je	4f
 	cghi	%r2,-2		/* CLOCK_THREAD_CPUTIME_ID for this thread */
 	je	9f
-	cghi	%r2,CLOCK_MONOTONIC
+	cghi	%r2,__CLOCK_MONOTONIC
 	jne	12f
 
 	/* CLOCK_MONOTONIC */
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 50cf963..bf61274 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2802,6 +2802,73 @@ dasd_eckd_steal_lock(struct dasd_device *device)
 }
 
 /*
+ * SNID - Sense Path Group ID
+ * This ioctl may be used in situations where I/O is stalled due to
+ * a reserve, so if the normal dasd_smalloc_request fails, we use the
+ * preallocated dasd_reserve_req.
+ */
+static int dasd_eckd_snid(struct dasd_device *device,
+			  void __user *argp)
+{
+	struct dasd_ccw_req *cqr;
+	int rc;
+	struct ccw1 *ccw;
+	int useglobal;
+	struct dasd_snid_ioctl_data usrparm;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (copy_from_user(&usrparm, argp, sizeof(usrparm)))
+		return -EFAULT;
+
+	useglobal = 0;
+	cqr = dasd_smalloc_request(DASD_ECKD_MAGIC, 1,
+				   sizeof(struct dasd_snid_data), device);
+	if (IS_ERR(cqr)) {
+		mutex_lock(&dasd_reserve_mutex);
+		useglobal = 1;
+		cqr = &dasd_reserve_req->cqr;
+		memset(cqr, 0, sizeof(*cqr));
+		memset(&dasd_reserve_req->ccw, 0,
+		       sizeof(dasd_reserve_req->ccw));
+		cqr->cpaddr = &dasd_reserve_req->ccw;
+		cqr->data = &dasd_reserve_req->data;
+		cqr->magic = DASD_ECKD_MAGIC;
+	}
+	ccw = cqr->cpaddr;
+	ccw->cmd_code = DASD_ECKD_CCW_SNID;
+	ccw->flags |= CCW_FLAG_SLI;
+	ccw->count = 12;
+	ccw->cda = (__u32)(addr_t) cqr->data;
+	cqr->startdev = device;
+	cqr->memdev = device;
+	clear_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags);
+	set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
+	cqr->retries = 5;
+	cqr->expires = 10 * HZ;
+	cqr->buildclk = get_clock();
+	cqr->status = DASD_CQR_FILLED;
+	cqr->lpm = usrparm.path_mask;
+
+	rc = dasd_sleep_on_immediatly(cqr);
+	/* verify that I/O processing didn't modify the path mask */
+	if (!rc && usrparm.path_mask && (cqr->lpm != usrparm.path_mask))
+		rc = -EIO;
+	if (!rc) {
+		usrparm.data = *((struct dasd_snid_data *)cqr->data);
+		if (copy_to_user(argp, &usrparm, sizeof(usrparm)))
+			rc = -EFAULT;
+	}
+
+	if (useglobal)
+		mutex_unlock(&dasd_reserve_mutex);
+	else
+		dasd_sfree_request(cqr, cqr->memdev);
+	return rc;
+}
+
+/*
  * Read performance statistics
  */
 static int
@@ -3036,6 +3103,8 @@ dasd_eckd_ioctl(struct dasd_block *block, unsigned int cmd, void __user *argp)
 		return dasd_eckd_reserve(device);
 	case BIODASDSLCK:
 		return dasd_eckd_steal_lock(device);
+	case BIODASDSNID:
+		return dasd_eckd_snid(device, argp);
 	case BIODASDSYMMIO:
 		return dasd_symm_io(device, argp);
 	default:
diff --git a/drivers/s390/block/dasd_eckd.h b/drivers/s390/block/dasd_eckd.h
index 0eb4965..12097c2 100644
--- a/drivers/s390/block/dasd_eckd.h
+++ b/drivers/s390/block/dasd_eckd.h
@@ -27,6 +27,7 @@
 #define DASD_ECKD_CCW_WRITE_CKD		 0x1d
 #define DASD_ECKD_CCW_READ_CKD		 0x1e
 #define DASD_ECKD_CCW_PSF		 0x27
+#define DASD_ECKD_CCW_SNID		 0x34
 #define DASD_ECKD_CCW_RSSD		 0x3e
 #define DASD_ECKD_CCW_LOCATE_RECORD	 0x47
 #define DASD_ECKD_CCW_SNSS		 0x54
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index 29c2d73..6c40867 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -1077,15 +1077,14 @@ __tape_do_irq (struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 		/* FIXME: What to do with the request? */
 		switch (PTR_ERR(irb)) {
 			case -ETIMEDOUT:
-				DBF_LH(1, "(%s): Request timed out\n",
-					dev_name(&cdev->dev));
+				DBF_LH(1, "(%08x): Request timed out\n",
+				       device->cdev_id);
 			case -EIO:
 				__tape_end_request(device, request, -EIO);
 				break;
 			default:
-				DBF_LH(1, "(%s): Unexpected i/o error %li\n",
-					dev_name(&cdev->dev),
-					PTR_ERR(irb));
+				DBF_LH(1, "(%08x): Unexpected i/o error %li\n",
+				       device->cdev_id,	PTR_ERR(irb));
 		}
 		return;
 	}
diff --git a/drivers/s390/char/tape_std.c b/drivers/s390/char/tape_std.c
index 03f07e5..3c3f342 100644
--- a/drivers/s390/char/tape_std.c
+++ b/drivers/s390/char/tape_std.c
@@ -47,8 +47,8 @@ tape_std_assign_timeout(unsigned long data)
 			device->cdev_id);
 	rc = tape_cancel_io(device, request);
 	if(rc)
-		DBF_EVENT(3, "(%s): Assign timeout: Cancel failed with rc = %i\n",
-			dev_name(&device->cdev->dev), rc);
+		DBF_EVENT(3, "(%08x): Assign timeout: Cancel failed with rc = "
+			  "%i\n", device->cdev_id, rc);
 }
 
 int
