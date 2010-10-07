Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab0JGDbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:31:17 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58641 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0JGDbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:31:16 -0400
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: mjg59@srcf.ucam.org, len.brown@intel.com, alan-jenkins@tuffmail.co.uk,
        superm1@ubuntu.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] dell-laptop: Add hwswitch_only module parameter
Date: Thu,  7 Oct 2010 11:30:07 +0800
Message-Id: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOS does not report the correct state of the wireless killswitch
in the return value of SMI Class 17, Select 11.

This causes the killswitch to always stay as soft-blocked once the rfkill
hotkey is pressed.

This patch adds a module parameter to work around this by disregarding
the software rfkill and using only Bit 16 in the return value of
SMI Class 17, Select 11 as the hardware killswitch.

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/platform/x86/dell-laptop.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

 This patch is intended to work around the buggy BIOS.

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 4413975..a105d7e 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -74,6 +74,8 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
+static bool hwswitch_only;
+
 static const struct dmi_system_id __initdata dell_device_table[] = {
 	{
 		.ident = "Dell laptop",
@@ -314,7 +316,8 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 	status = buffer->output[1];
 	release_buffer();
 
-	rfkill_set_sw_state(rfkill, !!(status & BIT(bit)));
+	if (!hwswitch_only)
+		rfkill_set_sw_state(rfkill, !!(status & BIT(bit)));
 
 	if (hwswitch_state & (BIT(hwswitch_bit)))
 		rfkill_set_hw_state(rfkill, !(status & BIT(16)));
@@ -630,6 +633,9 @@ static void __exit dell_exit(void)
 module_init(dell_init);
 module_exit(dell_exit);
 
+module_param(hwswitch_only, bool, 0644);
+MODULE_PARM_DESC(hwswitch_only, "Use the hardware rfkill only");
+
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
-- 
1.7.1

