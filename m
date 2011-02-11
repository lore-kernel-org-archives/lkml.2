Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab1BKVqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:46:32 -0500
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:44959 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106Ab1BKVqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:46:31 -0500
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add reboot=acpi quirk for OLPC XO-1.5
Message-Id: <20110211213221.B78DE9D401D@zog.reactivated.net>
Date: Fri, 11 Feb 2011 21:32:21 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=cM3ahYHrfgMA:10 a=Op-mwl0xAAAA:8 a=FVUYNIW6Qfhn-Ud8g34A:9 a=3wyHMZQiBRXXX4mPvvbuY_TTg68A:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OLPC XO-1.5 needs the reboot=acpi flag to reboot correctly.
Add a quirk so that this becomes the default.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/kernel/reboot.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fc7aae1..110e334 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -135,6 +135,19 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+/*
+ * Some machines require the "reboot=a"  commandline option,
+ * this quirk makes that automatic.
+ */
+static int __init set_acpi_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_ACPI) {
+		reboot_type = BOOT_ACPI;
+		printk(KERN_INFO "%s series board detected. Selecting ACPI-method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
@@ -285,6 +298,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
+	{       /* OLPC XO-1.5 does not implement KBD reboot */
+		.callback = set_acpi_reboot,
+		.ident = "OLPC XO-1.5",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1.5"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.4

