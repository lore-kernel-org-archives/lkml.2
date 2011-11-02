Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1KBNgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:36:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33232 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1KBNgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:36:05 -0400
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Cc: =?UTF-8?q?Uro=C5=A1=20Vampl?= <mobile.leecher@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH RESEND] Fix reboot regression on Acer Aspire One AOA110
Date: Wed,  2 Nov 2011 16:34:59 +0300
Message-Id: <1320240899-16889-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uroš Vampl <mobile.leecher@gmail.com>

Starting with kernel 3.0, my Acer Aspire One AOA110 hangs on reboot. Doing
an internet search, I found that in git commit
b49c78d4827be8d7e67e5b94adac6b30a4a9ad14 the machine was made to reboot with
the bios method, but it does not work on most (all?) AOA110s.

This patch introduces new quirks section for machines that only reboot with
the kbd method and put the Aspire One into it.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Uroš Vampl <mobile.leecher@gmail.com>
---
 arch/x86/kernel/reboot.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e334be1..f4544b1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -294,8 +294,33 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
 		},
 	},
+	{ }
+};
+
+static int __init reboot_init(void)
+{
+	dmi_check_system(reboot_dmi_table);
+	return 0;
+}
+core_initcall(reboot_init);
+
+/*
+ * Some machines require the "reboot=k" commandline option,
+ * this quirk makes that automatic.
+ */
+static int __init set_kbd_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_KBD) {
+		reboot_type = BOOT_KBD;
+		printk(KERN_INFO "%s series board detected. "
+			"Selecting KBD-method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
+static struct dmi_system_id __initdata kbd_reboot_dmi_table[] = {
 	{ /* Handle reboot issue on Acer Aspire one */
-		.callback = set_bios_reboot,
+		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
@@ -305,12 +330,12 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	{ }
 };
 
-static int __init reboot_init(void)
+static int __init kbd_reboot_init(void)
 {
-	dmi_check_system(reboot_dmi_table);
+	dmi_check_system(kbd_reboot_dmi_table);
 	return 0;
 }
-core_initcall(reboot_init);
+core_initcall(kbd_reboot_init);
 
 extern const unsigned char machine_real_restart_asm[];
 extern const u64 machine_real_restart_gdt[3];
-- 
1.7.7.1

