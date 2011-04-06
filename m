Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1DFLHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1DFLHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:07:20 -0400
Date: Wed, 6 Apr 2011 11:07:00 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, mjg@redhat.com,
        hpa@zytor.com, mingo@redhat.com, leann.ogasawara@canonical.com,
        torvalds@linux-foundation.org, davej@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, leann.ogasawara@canonical.com,
        davej@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        len.brown@intel.com, mingo@elte.hu
In-Reply-To: <1301939705-2404-1-git-send-email-mjg@redhat.com>
References: <1301939705-2404-1-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86: Reorder reboot method preferences
Message-ID: <tip-660e34cebf0a11d54f2d5dd8838607452355f321@git.kernel.org>
Git-Commit-ID: 660e34cebf0a11d54f2d5dd8838607452355f321
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 11:07:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  660e34cebf0a11d54f2d5dd8838607452355f321
Gitweb:     http://git.kernel.org/tip/660e34cebf0a11d54f2d5dd8838607452355f321
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Mon, 4 Apr 2011 13:55:05 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 Apr 2011 10:36:50 +0200

x86: Reorder reboot method preferences

We have a never ending stream of 'reboot quirks' for new boxes
that will not reboot properly under Linux (they will hang on
reboot).

The reason is widespread 'Windows compatible' assumption of modern
x86 hardware, which expects the following reboot sequence:

 - hitting the ACPI reboot vector (if available)
 - trying the keyboard controller
 - hitting the ACPI reboot vector again
 - then giving the keyboard controller one last go

This sequence expectation gets more and more embedded in modern
hardware, which often lacks a keyboard controller and may even
lock up if the legacy io ports are hit - and which hardware is
often not tested with Linux during development.

The end result is that reboot works under Windows-alike OSs but not
under Linux.

Rework our reboot process to meet this hardware externality a little
better and match this assumption of newer x86 hardware.

In addition to the ACPI,kbd,ACPI,kbd sequence we'll still fall
through to attempting a legacy triple fault if nothing else
works - and keep trying that and the kbd reset.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
[ this commit will also save special casing Oaktrail boards ]
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
LKML-Reference: <1301939705-2404-1-git-send-email-mjg@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 08c44b0..0c016f7 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -36,7 +36,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
@@ -478,9 +478,24 @@ void __attribute__((weak)) mach_reboot_fixups(void)
 {
 }
 
+/*
+ * Windows compatible x86 hardware expects the following on reboot:
+ *
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
@@ -502,6 +517,13 @@ static void native_machine_emergency_restart(void)
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
