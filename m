Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0LFW23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:28:29 -0500
Received: from relay1.sgi.com ([192.48.179.29]:46795 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0LFW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:28:28 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV kdump reboot fix
Cc: mingo@elte.hu
Message-Id: <E1PPjXy-0004Cs-5F@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 06 Dec 2010 16:28:38 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After a crash dump on an SGI Altix UV system the crash kernel fails to
cause a reboot.
Only the reboot_type of BOOT_ACPI works.
Other boot types ...BOOT_EFI, _KBD, _TRIPLE... fail.

The system's BIOS has an EFI layer, so it is a bit of a mystery to me
why BOOT_EFI fails.  Can someone explain that?

Diffed against 2.6.37-rc2

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/kernel/reboot.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/arch/x86/kernel/reboot.c
===================================================================
--- linux.orig/arch/x86/kernel/reboot.c
+++ linux/arch/x86/kernel/reboot.c
@@ -10,6 +10,7 @@
 #include <linux/dmi.h>
 #include <linux/sched.h>
 #include <linux/tboot.h>
+#include <linux/crash_dump.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -22,6 +23,7 @@
 #include <asm/pci_x86.h>
 #include <asm/virtext.h>
 #include <asm/cpu.h>
+#include <asm/uv/uv.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/ctype.h>
@@ -675,6 +677,10 @@ static void native_machine_restart(char 
 
 	if (!reboot_force)
 		machine_shutdown();
+
+	if (is_uv_system() && is_kdump_kernel())
+		reboot_type = BOOT_ACPI;
+
 	__machine_emergency_restart(0);
 }
 
