Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab1CaO3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:29:37 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59496 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757540Ab1CaO3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:29:36 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3] x86: UV kdump reboot fix
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, rja@sgi.com
Message-Id: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 31 Mar 2011 09:32:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

After a crash dump on an SGI Altix UV system the crash kernel fails to
cause a reboot.  EFI mode is disabled in the kdump kernel, so only the
reboot_type of BOOT_ACPI works.

> The clean solution would be to add the reboot_type setting to an UV specific
> initialization function. That way only UV is affected and there's no extra
> kludge either, as reboot_type is already global.  [Ingo]
(this is too simple -- sometimes I can't see the forest for the trees!)

Diffed against 2.6.38-rc8 (current tip tree)

Signed-off-by: Cliff Wickman <cpw@sgi.com>

 arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
@@ -34,6 +35,7 @@
 #include <asm/ipi.h>
 #include <asm/smp.h>
 #include <asm/x86_init.h>
+#include <asm/emergency-restart.h>
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
@@ -810,4 +812,11 @@ void __init uv_system_init(void)
 
 	/* register Legacy VGA I/O redirection handler */
 	pci_register_set_vga_state(uv_set_vga_state);
+
+	/*
+	 * for a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
+	 * EFI is not enabled in the kdump kernel.
+	 */
+	if (is_kdump_kernel())
+		reboot_type = BOOT_ACPI;
 }
