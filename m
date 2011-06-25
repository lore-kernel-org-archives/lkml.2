Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1FYRns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 13:43:48 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:61867 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713Ab1FYRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 13:42:53 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 04/11] x86, olpc: Add XO-1 suspend/resume support
Date: Sat, 25 Jun 2011 17:34:11 +0100
Message-Id: <1309019658-1712-5-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=XVZArYmBx0MA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=Ph50c6MuhhJYuCEeRvgA:9 a=MPATUwAiyXTFClNk8doA:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code needed for basic suspend/resume of the XO-1 laptop.
Based on earlier work by Jordan Crouse, Andres Salomon, and others.

This patch incorporates all earlier feedback from Thomas Gleixner. To
clarify a certain point (now more obvious in the code itself):
On resume, OpenFirmware returns execution to Linux in protected mode
with a kernel-compatible GDT already set up. The changes and
simplifications suggested have all been included.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                     |    4 +-
 arch/x86/include/asm/olpc.h          |   15 +++-
 arch/x86/platform/olpc/Makefile      |    2 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c |   92 +++++++++++++++++++++++++
 arch/x86/platform/olpc/xo1-wakeup.S  |  124 ++++++++++++++++++++++++++++++++++
 include/linux/cs5535.h               |    3 +
 6 files changed, 234 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/platform/olpc/xo1-wakeup.S

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e7851be..a9953bf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2077,10 +2077,10 @@ config OLPC
 
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
-	depends on OLPC && MFD_CS5535
+	depends on OLPC && MFD_CS5535 && PM_SLEEP
 	select MFD_CORE
 	---help---
-	  Add support for poweroff of the OLPC XO-1 laptop.
+	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
 endif # X86_32
 
diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 5ca6801..10ea595 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -76,6 +76,12 @@ static inline int olpc_has_dcon(void)
 
 #endif
 
+#ifdef CONFIG_OLPC_XO1_PM
+extern void do_olpc_suspend_lowlevel(void);
+extern void olpc_xo1_pm_wakeup_set(u16 value);
+extern void olpc_xo1_pm_wakeup_clear(u16 value);
+#endif
+
 extern int pci_olpc_init(void);
 
 /* EC related functions */
@@ -88,9 +94,12 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 
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
index cd25038..1ae7bed 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
-obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o
+obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
diff --git a/arch/x86/platform/olpc/olpc-xo1-pm.c b/arch/x86/platform/olpc/olpc-xo1-pm.c
index a2a59d3..6f3855a 100644
--- a/arch/x86/platform/olpc/olpc-xo1-pm.c
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
+#include <linux/suspend.h>
 
 #include <asm/io.h>
 #include <asm/olpc.h>
@@ -25,6 +26,85 @@
 static unsigned long acpi_base;
 static unsigned long pms_base;
 
+static u16 wakeup_mask = CS5536_PM_PWRBTN;
+
+static struct {
+	unsigned long address;
+	unsigned short segment;
+} ofw_bios_entry = { 0xF0000 + PAGE_OFFSET, __KERNEL_CS };
+
+/* Set bits in the wakeup mask */
+void olpc_xo1_pm_wakeup_set(u16 value)
+{
+	wakeup_mask |= value;
+}
+EXPORT_SYMBOL_GPL(olpc_xo1_pm_wakeup_set);
+
+/* Clear bits in the wakeup mask */
+void olpc_xo1_pm_wakeup_clear(u16 value)
+{
+	wakeup_mask &= ~value;
+}
+EXPORT_SYMBOL_GPL(olpc_xo1_pm_wakeup_clear);
+
+static int xo1_power_state_enter(suspend_state_t pm_state)
+{
+	unsigned long saved_sci_mask;
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
+	/*
+	 * Save SCI mask (this gets lost since PM1_EN is used as a mask for
+	 * wakeup events, which is not necessarily the same event set)
+	 */
+	saved_sci_mask = inl(acpi_base + CS5536_PM1_STS);
+	saved_sci_mask &= 0xffff0000;
+
+	/* Save CPU state */
+	do_olpc_suspend_lowlevel();
+
+	/* Resume path starts here */
+
+	/* Restore SCI mask (using dword access to CS5536_PM1_EN) */
+	outl(saved_sci_mask, acpi_base + CS5536_PM1_STS);
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
+asmlinkage int xo1_do_sleep(u8 sleep_state)
+{
+	void *pgd_addr = __va(read_cr3());
+
+	/* Program wakeup mask (using dword access to CS5536_PM1_EN) */
+	outl(wakeup_mask << 16, acpi_base + CS5536_PM1_STS);
+
+	__asm__("movl %0,%%eax" : : "r" (pgd_addr));
+	__asm__("call *(%%edi); cld"
+		: : "D" (&ofw_bios_entry));
+	__asm__("movb $0x34, %al\n\t"
+		"outb %al, $0x70\n\t"
+		"movb $0x30, %al\n\t"
+		"outb %al, $0x71\n\t");
+	return 0;
+}
+
 static void xo1_power_off(void)
 {
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
@@ -43,6 +123,17 @@ static void xo1_power_off(void)
 	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
 }
 
+static int xo1_power_state_valid(suspend_state_t pm_state)
+{
+	/* suspend-to-RAM only */
+	return pm_state == PM_SUSPEND_MEM;
+}
+
+static const struct platform_suspend_ops xo1_suspend_ops = {
+	.valid = xo1_power_state_valid,
+	.enter = xo1_power_state_enter,
+};
+
 static int __devinit xo1_pm_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -68,6 +159,7 @@ static int __devinit xo1_pm_probe(struct platform_device *pdev)
 
 	/* If we have both addresses, we can override the poweroff hook */
 	if (pms_base && acpi_base) {
+		suspend_set_ops(&xo1_suspend_ops);
 		pm_power_off = xo1_power_off;
 		printk(KERN_INFO "OLPC XO-1 support registered\n");
 	}
diff --git a/arch/x86/platform/olpc/xo1-wakeup.S b/arch/x86/platform/olpc/xo1-wakeup.S
new file mode 100644
index 0000000..948deb2
--- /dev/null
+++ b/arch/x86/platform/olpc/xo1-wakeup.S
@@ -0,0 +1,124 @@
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
+wakeup_start:
+	# OFW lands us here, running in protected mode, with a
+	# kernel-compatible GDT already setup.
+
+	# Clear any dangerous flags
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
+	# Control registers were modified, pipeline resync is needed
+	jmp 1f
+1:
+
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
+ENTRY(do_olpc_suspend_lowlevel)
+	call	save_processor_state
+	call	save_registers
+
+	# This is the stack context we want to remember
+	movl %esp, saved_context_esp
+
+	pushl	$3
+	call	xo1_do_sleep
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
+saved_gdt:             .long   0,0
+saved_idt:             .long   0,0
+saved_ldt:             .long   0
+saved_cr4:             .long   0
+saved_cr0:             .long   0
+saved_context_esp:     .long   0
+saved_context_edi:     .long   0
+saved_context_esi:     .long   0
+saved_context_ebx:     .long   0
+saved_context_ebp:     .long   0
+saved_context_eflags:  .long   0
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index e46b8b0..2facf16 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -70,6 +70,9 @@
 #define CS5536_PM1_CNT		0x08
 #define CS5536_PM_GPE0_STS	0x18
 
+/* CS5536_PM1_EN bits */
+#define CS5536_PM_PWRBTN	(1 << 8)
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E
-- 
1.7.5.4

