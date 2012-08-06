Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2HFXPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:15:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2HFXPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:15:42 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        mjg@redhat.com, ibm-acpi@hmh.eng.br
Subject: [PATCH] thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR
Date: Mon,  6 Aug 2012 18:15:37 -0500
Message-Id: <1344294937-19338-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

In the latest V-series bios DMI_PRODUCT_VERSION does not contain
the string Lenovo or Thinkpad, but is set to the model number, this
causes the thinkpad_acpi module to fail to load. Recognize laptop
as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.

Test on V490u
=============
== After the patch ==

[ 1350.295757] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[ 1350.295760] thinkpad_acpi: http://ibm-acpi.sf.net/
[ 1350.295761] thinkpad_acpi: ThinkPad BIOS H7ET21WW (1.00 ), EC unknown
[ 1350.295763] thinkpad_acpi: Lenovo LENOVO, model LV5DXXX
[ 1350.296086] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[ 1350.296694] thinkpad_acpi: radio switch found; radios are enabled
[ 1350.296703] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[ 1350.306466] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[ 1350.307082] Registered led device: tpacpi::thinklight
[ 1350.307215] Registered led device: tpacpi::power
[ 1350.307255] Registered led device: tpacpi::standby
[ 1350.307294] Registered led device: tpacpi::thinkvantage
[ 1350.308160] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[ 1350.308333] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[ 1350.312287] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input14

== Before the patch ==
sudo modprobe thinkpad_acpi
FATAL: Error inserting thinkpad_acpi (/lib/modules/3.2.0-27-generic/kernel/drivers/platform/x86/thinkpad_acpi.ko): No such device

Test on B485
=============
This patch was also test in a B485 where the thinkpad_acpi module does not
have any issues loading. But, I tested it to make sure this patch does not
break on already functioning models of Lenovo products.

[13486.746359] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[13486.746364] thinkpad_acpi: http://ibm-acpi.sf.net/
[13486.746368] thinkpad_acpi: ThinkPad BIOS HJET15WW(1.01), EC unknown
[13486.746373] thinkpad_acpi: Lenovo Lenovo LB485, model 814TR01
[13486.747300] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[13486.752435] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[13486.752883] Registered led device: tpacpi::thinklight
[13486.752915] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[13486.753216] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[13486.757147] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input15

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e7f7328..d05c0a4 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8662,7 +8662,14 @@ static int __must_check __init get_thinkpad_model_data(
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
 			return -ENOMEM;
-	}
+	} else {
+		s = dmi_get_system_info(DMI_BIOS_VENDOR);
+		if (s && !(strnicmp(s, "Lenovo", 6))) {
+			tp->model_str = kstrdup(s, GFP_KERNEL);
+			if (!tp->model_str)
+				return -ENOMEM;
+		}
+	} 
 
 	s = dmi_get_system_info(DMI_PRODUCT_NAME);
 	tp->nummodel_str = kstrdup(s, GFP_KERNEL);
-- 
1.7.9.5

