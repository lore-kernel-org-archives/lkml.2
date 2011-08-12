Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1HLKuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:50:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1HLKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:50:24 -0400
Date: Fri, 12 Aug 2011 12:50:21 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: Starting with kernel 3.0, Acer Aspire One A110 hangs on reboot
Message-ID: <20110812105021.GA29908@zverina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Starting with kernel 3.0, my Acer Aspire One A110 hangs on reboot. Doing 
an internet search, I found that in git commit 
b49c78d4827be8d7e67e5b94adac6b30a4a9ad14 x86, reboot: Acer Aspire One 
A110 reboot quirk

the machine was made to reboot with the bios method. Well, it doesn't 
work here. I reverted that commit and found out that only the kbd method 
(reboot=k) works. So what I did is create a new quirks section for 
machines that only reboot with the kbd method and put the Aspire One 
into it.

No idea if this is the correct solution, all I know is my Aspire One now 
reboots again.


Signed-off-by: Uroš Vampl <mobile.leecher@gmail.com>

--- linux-3.0.1.orig/arch/x86/kernel/reboot.c	2011-08-05 06:59:21.000000000 +0200
+++ linux-3.0.1/arch/x86/kernel/reboot.c	2011-08-12 02:48:11.608815724 +0200
@@ -294,8 +294,32 @@
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
+		printk(KERN_INFO "%s series board detected. Selecting KBD-method for reboots.\n", d->ident);
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
@@ -305,12 +329,12 @@
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

