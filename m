Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab1ESVUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:20:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38487 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab1ESVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:20:54 -0400
Date: Thu, 19 May 2011 23:20:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/reboot change for v2.6.40
Message-ID: <20110519212045.GA21021@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-reboot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-reboot-for-linus

This change modifies the x86 reboot method order to be ACPI first.

This affects a lot of systems - the hope is that it will reduce the steady 
influx of reboot quirks (and the large body of boxes that will not reboot 
properly under Linux).

 Thanks,

	Ingo

------------------>
Matthew Garrett (1):
      x86: Reorder reboot method preferences


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
