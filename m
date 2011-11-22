Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab1KVWR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:17:28 -0500
Received: from twinhelix.com ([109.169.67.147]:56088 "EHLO twinhelix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab1KVWR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:17:27 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Nov 2011 17:17:27 EST
Message-ID: <1321999736.3573.10.camel@nirvana>
Subject: [PATCH] ACPI: Force acpi_skip_timer_override for Gigabyte
 GA-MA78GPM-UD2H
From: Angus Turnbull <angus@twinhelix.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, len.brown@intel.com
Date: Wed, 23 Nov 2011 11:08:56 +1300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several Gigabyte motherboards from the SB700 generation have an issue
where they will not boot or suspend/resume reliably without
"acpi_skip_timer_override" on the kernel command line. I have a
GA-MA78GPM-UD2H (AM2+ socket) and the below patch allows it to boot
successfully by adding it to the quirks list (the AMD bug detection in
early_quirks.c isn't enabling acpi_skip_timer_override automatically).

https://lkml.org/lkml/2011/3/31/195 covered a very similar issue.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/658955 is a bug
report with my system information.


diff -ru a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1466,6 +1466,19 @@
 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
 		     },
 	 },
+	/*
+	 * Buggy Gigabyte ACPI on SB700 boards, will not boot or resume
+	 * reliably without acpi_skip_timer_override (last stable BIOS).
+	 * Affects multiple boards of this generation.
+	 */
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "Gigabyte GA-MA78GPM-UD2H",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR,
+			"Gigabyte Technology Co., Ltd."),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "GA-MA78GPM-UD2H"),
+		     },
+	 },
 	{}
 };


