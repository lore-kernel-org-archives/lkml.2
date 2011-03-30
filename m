Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab1C3QHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:07:04 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58445 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754680Ab1C3QHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:07:01 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: UV kdump reboot fix
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, rja@sgi.com
Message-Id: <E1Q4xxV-0004MJ-Pa@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 30 Mar 2011 11:09:25 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

After a crash dump on an SGI Altix UV system the crash kernel fails to
cause a reboot.  EFI mode is disabled in the kdump kernel, so only the
reboot_type of BOOT_ACPI works.

native_machine_restart() is the generic restart function.  This patch
overrides the generic version with a UV-specific version.
(an earlier (6Dec2010) version of this patch was nack'd as it patched
 native_machine_restart() with special case is_uv_system() kludge)

Diffed against 2.6.38-rc8 (current tip tree)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>


 arch/x86/include/asm/uv/uv.h       |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   18 ++++++++++++++++++
 arch/x86/kernel/reboot.c           |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

Index: linux.trees.git/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux.trees.git/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/crash_dump.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -33,12 +34,16 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 #include <asm/smp.h>
+#include <asm/reboot.h>
+#include <asm/proto.h>
 #include <asm/x86_init.h>
+#include <asm/emergency-restart.h>
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 #define PR_DEVEL(fmt, args...)	pr_devel("%s: " fmt, __func__, args)
 
+static void uv_machine_restart(char *);
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
 static union uvh_apicid uvh_apicid;
@@ -115,6 +120,7 @@ static int __init uv_acpi_madt_oem_check
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
+		machine_ops.restart = uv_machine_restart;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -667,6 +673,18 @@ void uv_register_nmi_notifier(void)
 		printk(KERN_WARNING "UV NMI handler failed to register\n");
 }
 
+static void uv_machine_restart(char *__unused)
+{
+	printk(KERN_INFO "uv machine restart\n");
+	if (is_kdump_kernel())
+		/* efi is not enabled in the UV kdump kernel */
+		reboot_type = BOOT_ACPI;
+	if (!reboot_force)
+		machine_ops.shutdown();
+	reboot_emergency = 0;
+	machine_ops.emergency_restart();
+}
+
 void uv_nmi_init(void)
 {
 	unsigned int value;
Index: linux.trees.git/arch/x86/kernel/reboot.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/reboot.c
+++ linux.trees.git/arch/x86/kernel/reboot.c
@@ -46,7 +46,7 @@ static int reboot_cpu = -1;
  * When machine_emergency_restart() is called, we may be on
  * an inconsistent state and won't be able to do a clean cleanup
  */
-static int reboot_emergency;
+int reboot_emergency;
 
 /* This is set by the PCI code if either type 1 or type 2 PCI is detected */
 bool port_cf9_safe = false;
Index: linux.trees.git/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/uv/uv.h
+++ linux.trees.git/arch/x86/include/asm/uv/uv.h
@@ -8,6 +8,7 @@ struct mm_struct;
 
 #ifdef CONFIG_X86_UV
 
+extern int reboot_emergency;
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
