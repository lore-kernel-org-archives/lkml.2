Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab0LIVr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:47:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab0LIVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:47:25 -0500
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: hpa@zytor.com, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] X86: Revamp reboot behaviour to match Windows more closely
Date: Thu,  9 Dec 2010 16:46:42 -0500
Message-Id: <1291931204-5854-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows reboots by hitting the ACPI reboot vector (if available), trying
the keyboard controller, hitting the ACPI reboot vector again and then
giving the keyboard controller one last go. Rework our reboot process a
little to default to matching this behaviour, although we'll fall through
to attempting a triple fault if nothing else works.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/reboot.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c495aa8..c770e66 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
@@ -538,9 +538,23 @@ void __attribute__((weak)) mach_reboot_fixups(void)
 {
 }
 
+/*
+ * Windows does the following on reboot:
+ * 1) If the FADT has the ACPI reboot register flag set, try it
+ * 2) If still alive, write to the keyboard controller
+ * 3) If still alive, write to the ACPI reboot register again
+ * 4) Ig still alive, write to the keyboard controller again
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
@@ -562,6 +576,13 @@ static void native_machine_emergency_restart(void)
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
1.7.3.2

