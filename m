Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1DDRzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab1DDRzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:55:24 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] X86: Reorder reboot method preferences
Date: Mon,  4 Apr 2011 13:55:05 -0400
Message-Id: <1301939705-2404-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows reboots by hitting the ACPI reboot vector (if available), trying
the keyboard controller, hitting the ACPI reboot vector again and then
giving the keyboard controller one last go. This is important for modern
hardware, which often lacks a keyboard controller and may even wedge if the
legacy io ports are hit. Rework our reboot process a little to default to
matching this behaviour, although we'll fall through to attempting a triple
fault if nothing else works.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/reboot.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d3ce37e..9dd4330 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
@@ -477,9 +477,23 @@ void __attribute__((weak)) mach_reboot_fixups(void)
 {
 }
 
+/*
+ * Windows does the following on reboot:
+ * 1) If the FADT has the ACPI reboot register flag set, try it
+ * 2) If still alive, write to the keyboard controller
+ * 3) If still alive, write to the ACPI reboot register again
+ * 4) If still alive, write to the keyboard controller again
+ *
+ * If the machine is still alive at this stage, it gives up. We default to
+ * following the same pattern, except that if we're still alive after (4) we'll
+ * try to force a triple fault and then cycle between hitting the keyboard
+ * controller and doing that
+ */
 static void native_machine_emergency_restart(void)
 {
 	int i;
+	int attempt = 0;
+	int orig_reboot_type = reboot_type;
 
 	if (reboot_emergency)
 		emergency_vmx_disable_all();
@@ -501,6 +515,13 @@ static void native_machine_emergency_restart(void)
 				outb(0xfe, 0x64); /* pulse reset low */
 				udelay(50);
 			}
+			if (attempt == 0 && orig_reboot_type == BOOT_ACPI) {
+				attempt = 1;
+				reboot_type = BOOT_ACPI;
+			} else {
+				reboot_type = BOOT_TRIPLE;
+			}
+			break;
 
 		case BOOT_TRIPLE:
 			load_idt(&no_idt);
-- 
1.7.4.1

