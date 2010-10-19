Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0JSWCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:02:05 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:36539 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639Ab0JSWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:02:04 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: Add XO-1 suspend/resume support
Message-Id: <20101019220159.0DBBE9D401B@zog.reactivated.net>
Date: Tue, 19 Oct 2010 23:01:58 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=419UjrMU8xoA:10 a=Op-mwl0xAAAA:8 a=Uylrg1PJ_mGYvFKekVwA:9 a=FREXpYLf375pJQe-hb0A:7 a=iBf7QCf3-8zLryDmR6P78hU3rcQA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code needed for basic suspend/resume of the XO-1 laptop.

swsusp_pg_dir needs to be exposed as it is used by the assembly
code run in the wakeup path.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/include/asm/olpc.h       |    5 +-
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/olpc-xo1-wakeup.S |  132 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/olpc-xo1.c        |   79 ++++++++++++++++++++++
 arch/x86/mm/init_32.c             |    6 +-
 5 files changed, 219 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kernel/olpc-xo1-wakeup.S

diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 101229b..54dfe92 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -88,7 +88,10 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 
 /* EC commands */
 
-#define EC_FIRMWARE_REV		0x08
+#define EC_FIRMWARE_REV			0x08
+#define EC_WAKE_UP_WLAN			0x24
+#define EC_SET_SCI_INHIBIT		0x32
+#define EC_SET_SCI_INHIBIT_RELEASE	0x34
 
 /* SCI source values */
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4983b61..1b23334 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,7 +106,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
+obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o olpc-xo1-wakeup.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
diff --git a/arch/x86/kernel/olpc-xo1-wakeup.S b/arch/x86/kernel/olpc-xo1-wakeup.S
new file mode 100644
index 0000000..d335074
--- /dev/null
+++ b/arch/x86/kernel/olpc-xo1-wakeup.S
@@ -0,0 +1,132 @@
+.text
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+
+	.macro writepost,value
+		movb $0x34, %al
+		outb %al, $0x70
+		movb $\value, %al
+		outb %al, $0x71
+	.endm
+
+ALIGN
+	.align 4096
+
+wakeup_start:
+#	jmp wakeup_start
+
+	cli
+	cld
+
+	# Clear any dangerous flags
+
+	pushl $0
+	popfl
+
+	writepost 0x31
+
+	# Set up %cr3
+	movl $swsusp_pg_dir - __PAGE_OFFSET, %eax
+	movl %eax, %cr3
+
+	movl saved_cr4, %eax
+	movl %eax, %cr4
+
+	movl saved_cr0, %eax
+	movl %eax, %cr0
+
+	jmp 1f
+1:
+	ljmpl $__KERNEL_CS,$wakeup_return
+
+
+.org 0x1000
+
+wakeup_return:
+	movw    $__KERNEL_DS, %ax
+	movw    %ax, %ss
+	movw    %ax, %ds
+	movw    %ax, %es
+	movw    %ax, %fs
+	movw    %ax, %gs
+
+	lgdt    saved_gdt
+	lidt    saved_idt
+	lldt    saved_ldt
+	ljmp    $(__KERNEL_CS),$1f
+1:
+	movl    %cr3, %eax
+	movl    %eax, %cr3
+	wbinvd
+
+	# Go back to the return point
+	jmp ret_point
+
+save_registers:
+	sgdt  saved_gdt
+	sidt  saved_idt
+	sldt  saved_ldt
+
+	pushl %edx
+	movl %cr4, %edx
+	movl %edx, saved_cr4
+
+	movl %cr0, %edx
+	movl %edx, saved_cr0
+
+	popl %edx
+
+	movl %ebx, saved_context_ebx
+	movl %ebp, saved_context_ebp
+	movl %esi, saved_context_esi
+	movl %edi, saved_context_edi
+
+	pushfl
+	popl saved_context_eflags
+
+	ret
+
+
+restore_registers:
+	movl saved_context_ebp, %ebp
+	movl saved_context_ebx, %ebx
+	movl saved_context_esi, %esi
+	movl saved_context_edi, %edi
+
+	pushl saved_context_eflags
+	popfl
+
+	ret
+
+
+ENTRY(do_olpc_suspend_lowlevel)
+	call	save_processor_state
+	call	save_registers
+
+	# This is the stack context we want to remember
+	movl %esp, saved_context_esp
+
+	pushl	$3
+	call	olpc_xo1_do_sleep
+
+	jmp	wakeup_start
+	.p2align 4,,7
+ret_point:
+	movl    saved_context_esp, %esp
+
+	writepost 0x32
+
+	call	restore_registers
+	call	restore_processor_state
+	ret
+
+.data
+ALIGN
+
+saved_gdt:     .long   0,0
+saved_idt:     .long   0,0
+saved_ldt:     .long   0
+saved_cr4:     .long   0
+saved_cr0:     .long   0
+
diff --git a/arch/x86/kernel/olpc-xo1.c b/arch/x86/kernel/olpc-xo1.c
index f5442c0..9a06081 100644
--- a/arch/x86/kernel/olpc-xo1.c
+++ b/arch/x86/kernel/olpc-xo1.c
@@ -16,6 +16,7 @@
 #include <linux/pci_ids.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/suspend.h>
 
 #include <asm/io.h>
 #include <asm/olpc.h>
@@ -33,12 +34,83 @@
 #define PM_SSC		0x54
 
 /* PM registers (ACPI block) */
+#define PM1_STS		0x00
 #define PM1_CNT		0x08
 #define PM_GPE0_STS	0x18
 
+#define CS5536_PM_PWRBTN (1 << 8)
+
+extern void do_olpc_suspend_lowlevel(void);
+
 static unsigned long acpi_base;
 static unsigned long pms_base;
 
+static struct {
+	unsigned long address;
+	unsigned short segment;
+} ofw_bios_entry = { 0xF0000 + PAGE_OFFSET, __KERNEL_CS };
+
+static int xo1_power_state_enter(suspend_state_t pm_state)
+{
+	int r;
+
+	/* Only STR is supported */
+	if (pm_state != PM_SUSPEND_MEM)
+		return -EINVAL;
+
+	r = olpc_ec_cmd(EC_SET_SCI_INHIBIT, NULL, 0, NULL, 0);
+	if (r)
+		return r;
+
+	/* Save CPU state */
+	do_olpc_suspend_lowlevel();
+
+	/* Resume path starts here */
+
+	/* Tell the EC to stop inhibiting SCIs */
+	olpc_ec_cmd(EC_SET_SCI_INHIBIT_RELEASE, NULL, 0, NULL, 0);
+
+	/*
+	 * Tell the wireless module to restart USB communication.
+	 * Must be done twice.
+	 */
+	olpc_ec_cmd(EC_WAKE_UP_WLAN, NULL, 0, NULL, 0);
+	olpc_ec_cmd(EC_WAKE_UP_WLAN, NULL, 0, NULL, 0);
+
+	return 0;
+}
+
+asmlinkage int olpc_xo1_do_sleep(u8 sleep_state)
+{
+	void *pgd_addr = __va(read_cr3());
+	printk(KERN_ERR "xo1_do_sleep!\n"); /* this needs to remain here so
+					      * that gcc doesn't optimize
+					      * away our __va! */
+
+	/* Enable wakeup through power button */
+	outl((CS5536_PM_PWRBTN << 16) | 0xFFFF, acpi_base + PM1_STS);
+
+	__asm__ __volatile__("movl %0,%%eax" : : "r" (pgd_addr));
+	__asm__("call *(%%edi); cld"
+		: : "D" (&ofw_bios_entry));
+	__asm__ __volatile__("movb $0x34, %al\n\t"
+			     "outb %al, $0x70\n\t"
+			     "movb $0x30, %al\n\t"
+			     "outb %al, $0x71\n\t");
+	return 0;
+}
+
+static int xo1_power_state_valid(suspend_state_t pm_state)
+{
+	/* suspend-to-RAM only */
+	return pm_state == PM_SUSPEND_MEM;
+}
+
+static struct platform_suspend_ops xo1_suspend_ops = {
+	.valid = xo1_power_state_valid,
+	.enter = xo1_power_state_enter,
+};
+
 static void xo1_power_off(void)
 {
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
@@ -101,6 +173,13 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 	if (r)
 		return r;
 
+	/*
+	 * Take a reference on ourself to prevent module unloading. We can't
+	 * safely unload after changing the suspend handlers.
+	 */
+	__module_get(THIS_MODULE);
+
+	suspend_set_ops(&xo1_suspend_ops);
 	pm_power_off = xo1_power_off;
 
 	printk(KERN_INFO "OLPC XO-1 support registered\n");
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 43bbc29..dbdab67 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -549,7 +549,7 @@ static void __init pagetable_init(void)
 	permanent_kmaps_init(pgd_base);
 }
 
-#ifdef CONFIG_ACPI_SLEEP
+#if defined(CONFIG_ACPI_SLEEP) || defined(CONFIG_OLPC_XO1)
 /*
  * ACPI suspend needs this for resume, because things like the intel-agp
  * driver might have split up a kernel 4MB mapping.
@@ -561,11 +561,11 @@ static inline void save_pg_dir(void)
 {
 	copy_page(swsusp_pg_dir, swapper_pg_dir);
 }
-#else /* !CONFIG_ACPI_SLEEP */
+#else /* !CONFIG_ACPI_SLEEP && !CONFIG_OLPC_XO1 */
 static inline void save_pg_dir(void)
 {
 }
-#endif /* !CONFIG_ACPI_SLEEP */
+#endif /* !CONFIG_ACPI_SLEEP && !CONFIG_OLPC_XO1 */
 
 void zap_low_mappings(bool early)
 {
-- 
1.7.2.3

