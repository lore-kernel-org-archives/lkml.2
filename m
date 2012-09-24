Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2IXQ5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:57:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2IXQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:57:45 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, manoj.iyer@canonical.com
Subject: [PATCH 1/1] thinkpad-acpi: enable loading module with new B-series Lenovo BIOS
Date: Mon, 24 Sep 2012 11:57:40 -0500
Message-Id: <1348505860-4121-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348505788-4090-1-git-send-email-manoj.iyer@canonical.com>
References: <1348505788-4090-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

The new B series BIOS has version string 43CN46WW. The driver
requires that 2nd and 3rd characters be 'E' and 'T' respectively,
where as the newer BIOS has 'C' and 'N' respectively. Failing to
load the module causes some of the hotkeys to not work.

Before the patch
================
sudo modprobe thinkpad_acpi
FATAL: Error inserting thinkpad_acpi (/lib/modules/3.5.0-15-generic/kernel/drivers/platform/x86/thinkpad_acpi.ko): No such device

After the patch
===============
[44937.265438] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[44937.265445] thinkpad_acpi: http://ibm-acpi.sf.net/
[44937.265449] thinkpad_acpi: ThinkPad BIOS 43CN46WW, EC unknown
[44937.265453] thinkpad_acpi: Lenovo Lenovo B470e, model HuronRiver Platform
[44937.266479] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[44937.266557] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[44937.267846] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[44937.268131] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input17

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-by: James Ferguson <james.ferguson@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 52daaa8..d5a9f1c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8585,7 +8585,8 @@ static bool __pure __init tpacpi_is_valid_fw_id(const char* const s,
 	return s && strlen(s) >= 8 &&
 		tpacpi_is_fw_digit(s[0]) &&
 		tpacpi_is_fw_digit(s[1]) &&
-		s[2] == t && s[3] == 'T' &&
+		s[2] == t &&
+		(s[3] == 'T' || s[3] == 'N') &&
 		tpacpi_is_fw_digit(s[4]) &&
 		tpacpi_is_fw_digit(s[5]);
 }
@@ -8618,7 +8619,8 @@ static int __must_check __init get_thinkpad_model_data(
 		return -ENOMEM;
 
 	/* Really ancient ThinkPad 240X will fail this, which is fine */
-	if (!tpacpi_is_valid_fw_id(tp->bios_version_str, 'E'))
+	if (!(tpacpi_is_valid_fw_id(tp->bios_version_str, 'E') ||
+	      tpacpi_is_valid_fw_id(tp->bios_version_str, 'C')))
 		return 0;
 
 	tp->bios_model = tp->bios_version_str[0]
-- 
1.7.9.5

