Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0KKPCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:02:17 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:7223 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869Ab0KKPCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:02:15 -0500
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: Add XO-1 suspend/resume support
Message-Id: <20101111150210.B84E49D401B@zog.reactivated.net>
Date: Thu, 11 Nov 2010 15:02:10 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=X0sWjjQ37bMP4yB/pNNinY3VxVB2n/hmdAjhihaCFGs= c=1 sm=0 a=419UjrMU8xoA:10 a=Op-mwl0xAAAA:8 a=Uylrg1PJ_mGYvFKekVwA:9 a=eIS83zP1Xf5fIaSwLTAA:7 a=N2-3kUS7CyFSEaWo2oDR-owS5qcA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code needed for basic suspend/resume of the XO-1 laptop.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig                         |    2 +-
 arch/x86/include/asm/olpc.h              |    9 ++-
 arch/x86/platform/olpc/Makefile          |    2 +-
 arch/x86/platform/olpc/olpc-xo1-wakeup.S |  132 ++++++++++++++++++++++++++++++
 arch/x86/platform/olpc/olpc-xo1.c        |   79 ++++++++++++++++++
 5 files changed, 219 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/platform/olpc/olpc-xo1-wakeup.S

v2: add dependency on CONFIG_PM_SLEEP (thanks Randy), avoid requirement
on hacking swsusp_pg_dir by switching to initial_page_table

v3: rebase to fix conflict in olpc.h with the now-merged XO-1 rfkill driver

Resending after 2 weeks of no feedback.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..a27b0dc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2041,7 +2041,7 @@ config OLPC
 
 config OLPC_XO1
 	tristate "OLPC XO-1 support"
-	depends on OLPC && PCI
+	depends on OLPC && PCI && PM_SLEEP
 	---help---
 	  Add support for non-essential features of the OLPC XO-1 laptop.
 
diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 42a978c..5bf0805 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -88,9 +88,12 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 
 /* EC commands */
 
-#define EC_FIRMWARE_REV		0x08
-#define EC_WLAN_ENTER_RESET	0x35
-#define EC_WLAN_LEAVE_RESET	0x25
+#define EC_FIRMWARE_REV			0x08
+#define EC_WAKE_UP_WLAN			0x24
+#define EC_WLAN_LEAVE_RESET		0x25
+#define EC_SET_SCI_INHIBIT		0x32
+#define EC_SET_SCI_INHIBIT_RELEASE	0x34
+#define EC_WLAN_ENTER_RESET		0x35
 
 /* SCI source values */
 
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index c31b8fc..a1e7f02 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_OLPC)		+= olpc.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
+obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o olpc-xo1-wakeup.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
diff --git a/arch/x86/platform/olpc/olpc-xo1-wakeup.S b/arch/x86/platform/olpc/olpc-xo1-wakeup.S
new file mode 100644
index 0000000..d36e5f4
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-wakeup.S
@@ -0,0 +1,132 @@
+.text
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/pgtable_32.h>
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
+	movl $initial_page_table - __PAGE_OFFSET, %eax
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
diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index f5442c0..9a06081 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
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
-- 
1.7.3.2

