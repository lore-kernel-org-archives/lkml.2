Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1G0NAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:00:18 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:59707 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab1G0M6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:58:17 -0400
Message-Id: <20110727125808.172069159@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jul 2011 14:55:09 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 05/10] s390: Add PSW restart shutdown trigger
References: <20110727125504.491183728@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-psw-restart.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

With this patch a new S390 shutdown trigger "restart" is added. If under
z/VM "systerm restart" is entered or under the HMC the "PSW restart" button
is pressed, the PSW located at 0 (31 bit) or 0x1a0 (64 bit) bit is loaded.
Now we execute do_restart() that processes the restart action that is
defined under /sys/firmware/shutdown_actions/on_restart. Currently the
following actions are possible: reipl (default), stop, vmcmd, dump, and
dump_reipl.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/lowcore.h |   11 +++++++++--
 arch/s390/include/asm/system.h  |    1 +
 arch/s390/kernel/asm-offsets.c  |    1 +
 arch/s390/kernel/entry.S        |   28 ++++++++++++++++++++++++++++
 arch/s390/kernel/entry64.S      |   20 ++++++++++++++++++++
 arch/s390/kernel/ipl.c          |   39 ++++++++++++++++++++++++++++++++++++++-
 arch/s390/kernel/setup.c        |   24 +++++++++++++++++++++++-
 arch/s390/kernel/smp.c          |    8 ++++++++
 arch/s390/mm/maccess.c          |   16 ++++++++++++++++
 9 files changed, 144 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -18,6 +18,7 @@ void system_call(void);
 void pgm_check_handler(void);
 void mcck_int_handler(void);
 void io_int_handler(void);
+void psw_restart_int_handler(void);
 
 #ifdef CONFIG_32BIT
 
@@ -150,7 +151,10 @@ struct _lowcore {
 	 */
 	__u32	ipib;				/* 0x0e00 */
 	__u32	ipib_checksum;			/* 0x0e04 */
-	__u8	pad_0x0e08[0x0f00-0x0e08];	/* 0x0e08 */
+
+	/* 64 bit save area */
+	__u64	save_area_64;			/* 0x0e08 */
+	__u8	pad_0x0e10[0x0f00-0x0e10];	/* 0x0e10 */
 
 	/* Extended facility list */
 	__u64	stfle_fac_list[32];		/* 0x0f00 */
@@ -286,7 +290,10 @@ struct _lowcore {
 	 */
 	__u64	ipib;				/* 0x0e00 */
 	__u32	ipib_checksum;			/* 0x0e08 */
-	__u8	pad_0x0e0c[0x0f00-0x0e0c];	/* 0x0e0c */
+
+	/* 64 bit save area */
+	__u64	save_area_64;			/* 0x0e0c */
+	__u8	pad_0x0e14[0x0f00-0x0e14];	/* 0x0e14 */
 
 	/* Extended facility list */
 	__u64	stfle_fac_list[32];		/* 0x0f00 */
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -113,6 +113,7 @@ extern void pfault_fini(void);
 
 extern void cmma_init(void);
 extern int memcpy_real(void *, void *, size_t);
+extern void copy_to_absolute_zero(void *dest, void *src, size_t count);
 
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -142,6 +142,7 @@ int main(void)
 	DEFINE(__LC_FPREGS_SAVE_AREA, offsetof(struct _lowcore, floating_pt_save_area));
 	DEFINE(__LC_GPREGS_SAVE_AREA, offsetof(struct _lowcore, gpregs_save_area));
 	DEFINE(__LC_CREGS_SAVE_AREA, offsetof(struct _lowcore, cregs_save_area));
+	DEFINE(__LC_SAVE_AREA_64, offsetof(struct _lowcore, save_area_64));
 #ifdef CONFIG_32BIT
 	DEFINE(SAVE_AREA_BASE, offsetof(struct _lowcore, extended_save_area_addr));
 #else /* CONFIG_32BIT */
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -849,6 +849,34 @@ restart_crash:
 restart_go:
 #endif
 
+#
+# PSW restart interrupt handler
+#
+ENTRY(psw_restart_int_handler)
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
+	.align 4
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
@@ -865,6 +865,26 @@ restart_crash:
 restart_go:
 #endif
 
+#
+# PSW restart interrupt handler
+#
+ENTRY(psw_restart_int_handler)
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
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -45,11 +45,13 @@
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
@@ -1544,17 +1546,20 @@ static char vmcmd_on_reboot[128];
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
 
@@ -1576,6 +1581,8 @@ static void vmcmd_run(struct shutdown_tr
 		cmd = vmcmd_on_halt;
 	else if (strcmp(trigger->name, ON_POFF_STR) == 0)
 		cmd = vmcmd_on_poff;
+	else if (strcmp(trigger->name, ON_RESTART_STR) == 0)
+		cmd = vmcmd_on_restart;
 	else
 		return;
 
@@ -1707,6 +1714,34 @@ static void do_panic(void)
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
@@ -1783,7 +1818,9 @@ static void __init shutdown_triggers_ini
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
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -346,7 +346,7 @@ setup_lowcore(void)
 	lc = __alloc_bootmem_low(LC_PAGES * PAGE_SIZE, LC_PAGES * PAGE_SIZE, 0);
 	lc->restart_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
 	lc->restart_psw.addr =
-		PSW_ADDR_AMODE | (unsigned long) restart_int_handler;
+		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 	if (user_mode != HOME_SPACE_MODE)
 		lc->restart_psw.mask |= PSW_ASC_HOME;
 	lc->external_new_psw.mask = psw_kernel_bits;
@@ -529,6 +529,27 @@ static void __init setup_memory_end(void
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
 static void __init
 setup_memory(void)
 {
@@ -792,6 +813,7 @@ setup_arch(char **cmdline_p)
 	setup_addressing_mode();
 	setup_memory();
 	setup_resources();
+	setup_restart_psw();
 	setup_lowcore();
 
         cpu_init();
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -470,6 +470,11 @@ int __cpuinit start_secondary(void *cpuv
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
@@ -507,6 +512,9 @@ static int __cpuinit smp_alloc_lowcore(i
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
@@ -85,3 +85,19 @@ int memcpy_real(void *dest, void *src, s
 	arch_local_irq_restore(flags);
 	return rc;
 }
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

