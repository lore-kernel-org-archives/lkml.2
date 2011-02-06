Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1BFMaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:09 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57960 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1BFMaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:06 -0500
X-Originating-IP: 217.70.178.41
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/18] eeepc-wmi: add wimax support
Date: Sun,  6 Feb 2011 13:28:37 +0100
Message-Id: <1296995324-5462-13-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
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
1.7.4.rc3

