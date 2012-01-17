Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2AQPQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:16:14 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:54627 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2AQPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:16:13 -0500
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Michael D Labriola <mlabriol@gdeb.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
MIME-Version: 1.0
Subject: [PATCH] x86, reboot: skip DMI checks if reboot set by user
X-KeepSent: 70B406E9:8D4A6789-85257988:0052C104;
 type=4; name=$KeepSent
Message-ID: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Tue, 17 Jan 2012 10:16:03 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1RnAlc-0007DW-W7
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit causes DMI checks for vendor specific reboot
quirks to be skipped if the user passed in a reboot= arg
on the command line.

Signed-off-by: Michael D Labriola <mlabriol@gdeb.com>
---
 arch/x86/kernel/reboot.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 37a458b..4240d58 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -38,6 +38,7 @@ static const struct desc_ptr no_idt = {};
 static int reboot_mode;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
+int reboot_user;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
 static int reboot_cpu = -1;
@@ -70,10 +71,12 @@ static int __init reboot_setup(char *str)
                switch (*str) {
                case 'w':
                        reboot_mode = 0x1234;
+                       reboot_user = 1;
                        break;
 
                case 'c':
                        reboot_mode = 0;
+                       reboot_user = 1;
                        break;
 
 #ifdef CONFIG_X86_32
@@ -87,6 +90,7 @@ static int __init reboot_setup(char *str)
                                /* we will leave sorting out the final 
value
                                   when we are ready to reboot, since we 
might not
                                   have detected BSP APIC ID or 
smp_num_cpu */
+                       reboot_user = 1;
                        break;
 #endif /* CONFIG_SMP */
 
@@ -98,10 +102,12 @@ static int __init reboot_setup(char *str)
                case 'e':
                case 'p':
                        reboot_type = *str;
+                       reboot_user = 1;
                        break;
 
                case 'f':
                        reboot_force = 1;
+                       reboot_user = 1;
                        break;
                }
 
@@ -316,7 +322,10 @@ static struct dmi_system_id __initdata 
reboot_dmi_table[] = {
 
 static int __init reboot_init(void)
 {
-       dmi_check_system(reboot_dmi_table);
+       /* Skip the DMI check if user set reboot= on the command line */
+       if (!reboot_user) {
+               dmi_check_system(reboot_dmi_table);
+       }
        return 0;
 }
 core_initcall(reboot_init);
@@ -465,7 +474,10 @@ static struct dmi_system_id __initdata 
pci_reboot_dmi_table[] = {
 
 static int __init pci_reboot_init(void)
 {
-       dmi_check_system(pci_reboot_dmi_table);
+       /* Skip the DMI check if user set reboot= on the command line */
+       if (!reboot_user) {
+               dmi_check_system(pci_reboot_dmi_table);
+       }
        return 0;
 }
 core_initcall(pci_reboot_init);
-- 
1.6.0.3




 
