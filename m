Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1AXQe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:34:29 -0500
Received: from fb2.tech.numericable.fr ([82.216.111.50]:58949 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1AXQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:33:34 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 12/14] eeepc-wmi: add wimax support
Date: Mon, 24 Jan 2011 17:23:56 +0100
Message-Id: <1295886238-15961-13-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
References: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 83415dd..0db7009 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -71,6 +71,7 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 
 #define EEEPC_WMI_DEVID_WLAN		0x00010011
 #define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
+#define EEEPC_WMI_DEVID_WIMAX		0x00010017
 #define EEEPC_WMI_DEVID_WWAN3G		0x00010019
 #define EEEPC_WMI_DEVID_BACKLIGHT	0x00050012
 #define EEEPC_WMI_DEVID_CAMERA		0x00060013
@@ -138,6 +139,7 @@ struct eeepc_wmi {
 
 	struct rfkill *wlan_rfkill;
 	struct rfkill *bluetooth_rfkill;
+	struct rfkill *wimax_rfkill;
 	struct rfkill *wwan3g_rfkill;
 
 	struct hotplug_slot *hotplug_slot;
@@ -691,6 +693,11 @@ static void eeepc_wmi_rfkill_exit(struct eeepc_wmi *eeepc)
 		rfkill_destroy(eeepc->bluetooth_rfkill);
 		eeepc->bluetooth_rfkill = NULL;
 	}
+	if (eeepc->wimax_rfkill) {
+		rfkill_unregister(eeepc->wimax_rfkill);
+		rfkill_destroy(eeepc->wimax_rfkill);
+		eeepc->wimax_rfkill = NULL;
+	}
 	if (eeepc->wwan3g_rfkill) {
 		rfkill_unregister(eeepc->wwan3g_rfkill);
 		rfkill_destroy(eeepc->wwan3g_rfkill);
@@ -719,6 +726,13 @@ static int eeepc_wmi_rfkill_init(struct eeepc_wmi *eeepc)
 	if (result && result != -ENODEV)
 		goto exit;
 
+	result = eeepc_new_rfkill(eeepc, &eeepc->wimax_rfkill,
+				  "eeepc-wimax", RFKILL_TYPE_WIMAX,
+				  EEEPC_WMI_DEVID_WIMAX);
+
+	if (result && result != -ENODEV)
+		goto exit;
+
 	result = eeepc_new_rfkill(eeepc, &eeepc->wwan3g_rfkill,
 				  "eeepc-wwan3g", RFKILL_TYPE_WWAN,
 				  EEEPC_WMI_DEVID_WWAN3G);
@@ -1276,7 +1290,11 @@ static int eeepc_hotk_restore(struct device *device)
 	if (eeepc->bluetooth_rfkill) {
 		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_BLUETOOTH);
 		rfkill_set_sw_state(eeepc->bluetooth_rfkill, bl);
-}
+	}
+	if (eeepc->wimax_rfkill) {
+		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WIMAX);
+		rfkill_set_sw_state(eeepc->wimax_rfkill, bl);
+	}
 	if (eeepc->wwan3g_rfkill) {
 		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WWAN3G);
 		rfkill_set_sw_state(eeepc->wwan3g_rfkill, bl);
-- 
1.7.3.4

