Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1G2Mkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:40:46 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:35821 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1G2MkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:40:23 -0400
Message-Id: <20110729124000.650754716@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 29 Jul 2011 14:39:46 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 2/3] s390: Add external kdump entry point for s390 stand-alone dump tools
References: <20110729123944.562622201@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-backend-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

On s390 we want to be able to trigger kdump via our stand-alone dump tools,
if a valid kdump kernel has been pre-loaded. The mechanism works as follows:
We establish a ABI defined kdump entry point in the old kernel at 0x10018 and
a "kdump active" flag at 0xe18. The dump tools first verify 0xe18 in
order to find out if kdump kernel has been loaded. If kdump is loaded
they jump to 0x10008 which then triggers crash_kexec(). The dump tools
establish a program check handler so that if crash_kexec() or purgatory
is corrupted we return to the dump tools and create a full-blown stand-alone
dump as backup mechanism.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/kexec.h    |    1 
 arch/s390/include/asm/lowcore.h  |    4 +-
 arch/s390/kernel/entry64.S       |   16 ++++++++++
 arch/s390/kernel/head.S          |    8 ++++-
 arch/s390/kernel/head64.S        |    3 +
 arch/s390/kernel/head_kdump.S    |   13 ++++++++
 arch/s390/kernel/ipl.c           |    8 -----
 arch/s390/kernel/machine_kexec.c |   61 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 105 insertions(+), 9 deletions(-)

--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -40,4 +40,5 @@
 #define KEXEC_ARCH KEXEC_ARCH_S390
 
 extern void crash_setup_regs(struct pt_regs *newregs, struct pt_regs *oldregs);
+extern void s390_kdump_int(void);
 #endif /*_S390_KEXEC_H */
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -165,6 +165,7 @@ struct _lowcore {
 
 #define LC_ORDER 1
 #define LC_PAGES 2
+#define LC_KDUMP_ACTIVE_FLAG 0x4b44554d50414354ULL
 
 struct save_area {
 	u64	fp_regs[16];
@@ -295,7 +296,8 @@ struct _lowcore {
 	/* 64 bit save area */
 	__u64	save_area_64;			/* 0x0e0c */
 	__u32	ipib_checksum_perm;		/* 0x0e14 */
-	__u8	pad_0x0e18[0x0f00-0x0e18];	/* 0x0e18 */
+	__u64	kdump_active;			/* 0x0e18 */
+	__u8	pad_0x0e20[0x0f00-0x0e20];	/* 0x0e20 */
 
 	/* Extended facility list */
 	__u64	stfle_fac_list[32];		/* 0x0f00 */
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -885,6 +885,22 @@ ENTRY(psw_restart_int_handler)
 restart_psw_crash:
 	.quad	0x0002000080000000,0x0000000000000000 + restart_psw_crash
 
+#
+# kdump external entry (can be called from stand-alone dump tools)
+#
+ENTRY(kdump_ext_handler)
+	stg	%r15,__LC_SAVE_AREA_64(%r0)	# save r15
+	larl	%r15,restart_stack		# load restart stack
+	lg	%r15,0(%r15)
+	aghi	%r15,-SP_SIZE			# make room for pt_regs
+	stmg	%r0,%r14,SP_R0(%r15)		# store gprs %r0-%r14 to stack
+	mvc	SP_R15(8,%r15),__LC_SAVE_AREA_64(%r0)# store saved %r15 to stack
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15) # set backchain to 0
+
+	brasl	%r14,s390_kdump_ext
+0:	j	0b+2				# Force program check
+#endif
+
 	.section .kprobes.text, "ax"
 
 #ifdef CONFIG_CHECK_STACK
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -452,13 +452,19 @@ ENTRY(startup)
 	j	.Lep_startup_normal
 	.org	0x10008
 	.ascii	"S390EP"
-	.byte	0x00,0x01
+	.byte	0x00,0x02
 #
 # kdump startup-code at 0x10010, running in 64 bit absolute addressing mode
 #
 	.org	0x10010
 ENTRY(startup_kdump)
 	j	.Lep_startup_kdump
+#
+# External kdump startup-code at 0x10018
+#
+	.org	0x10018
+ENTRY(startup_kdump_ext)
+	j	.Lep_startup_kdump_ext
 .Lep_startup_normal:
 	basr	%r13,0			# get base
 .LPG0:
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -88,6 +88,9 @@ ENTRY(_ehead)
 ENTRY(_stext)
 	basr	%r13,0			# get base
 .LPG3:
+	larl	%r2,kdump_ext_handler		# Set kdump ext handler address
+	larl	%r3,kdump_ext_handler_addr	# This is needed
+	stg	%r2,0(%r3)			# because of bzImage
 # check control registers
 	stctg	%c0,%c15,0(%r15)
 	oi	6(%r15),0x40		# enable sigp emergency signal
--- a/arch/s390/kernel/head_kdump.S
+++ b/arch/s390/kernel/head_kdump.S
@@ -97,8 +97,21 @@ startup_kdump_relocated:
 	.long	0x00080000,0x80000000 + startup
 .Lpgm_psw:
 	.quad	0x0000000180000000,0x0000000000000000 + .Lno_diag308
+
+.align 2
+.Lep_startup_kdump_ext:
+	larl	%r14,kdump_ext_handler_addr
+	lg	%r14,0(%r14)
+	br	%r14
+
+ENTRY(kdump_ext_handler_addr)
+	.quad	0xffffffffffffffff
 #else
 .align 2
+.Lep_startup_kdump_ext:
+	br	%r14
+
+.align 2
 .Lep_startup_kdump:
 #ifdef CONFIG_64BIT
 	larl	%r13,startup_kdump_crash
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1651,13 +1651,7 @@ static int kdump_init(void)
 
 static void kdump_run(struct shutdown_trigger *trigger)
 {
-	pfault_fini();
-	s390_reset_system();
-	__arch_local_irq_stnsm(0xfb); /* disable DAT */
-	store_status();
-
-	crash_kexec(NULL);
-	disabled_wait((unsigned long) __builtin_return_address(0));
+	s390_kdump_int();
 }
 
 static struct shutdown_action kdump_action = {SHUTDOWN_ACTION_KDUMP_STR,
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -53,6 +53,19 @@ int kimage_load_crash_segment(struct kim
 }
 
 /*
+ * kdump program check handler
+ */
+static void kdump_pgm_handler(void)
+{
+	psw_t kdump_failed_psw;
+
+	kdump_failed_psw.mask = PSW_BASE_BITS | PSW_MASK_WAIT;
+	kdump_failed_psw.addr = (unsigned long) kdump_pgm_handler;
+	_sclp_print_early("kdump failed: Use stand-alone dump tool");
+	__load_psw(kdump_failed_psw);
+}
+
+/*
  * Start kdump
  */
 static void __machine_kdump(void *data)
@@ -82,6 +95,40 @@ static int machine_kexec_prepare_kdump(v
 #endif
 }
 
+/*
+ * Externally triggered kdump: Emit program check if kdump is not loaded
+ */
+void s390_kdump_ext(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+	if (!kexec_crash_image)
+		BUG();
+	crash_kexec(NULL);
+#else
+	return;
+#endif
+}
+
+/*
+ * Internally triggered kdump: Reset system and set PGM handler
+ */
+void s390_kdump_int(void)
+{
+	pfault_fini();
+	s390_reset_system();
+	__arch_local_irq_stnsm(0xfb); /* disable DAT */
+	store_status();
+	S390_lowcore.program_new_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
+	S390_lowcore.program_new_psw.addr = PSW_ADDR_AMODE |
+		(unsigned long) kdump_pgm_handler;
+	if (!kexec_crash_image) {
+		_sclp_print_early("kdump not loaded");
+		BUG();
+	}
+	crash_kexec(NULL);
+	BUG();
+}
+
 int machine_kexec_prepare(struct kimage *image)
 {
 	void *reboot_code_buffer;
@@ -109,6 +156,20 @@ void machine_kexec_cleanup(struct kimage
 {
 }
 
+/*
+ * Update kdump active flag for s390 stand-alone dump tools
+ */
+void machine_kexec_finish(struct kimage *image, int kexec_flags)
+{
+	u64 kdump_active;
+
+	if (!(kexec_flags & KEXEC_ON_CRASH))
+		return;
+	kdump_active = image ? LC_KDUMP_ACTIVE_FLAG : 0;
+	copy_to_absolute_zero(&S390_lowcore.kdump_active, &kdump_active,
+			      sizeof(kdump_active));
+}
+
 void machine_shutdown(void)
 {
 }

