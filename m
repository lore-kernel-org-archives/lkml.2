Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1BFM3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:29:44 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:53978 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1BFM3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:41 -0500
X-Originating-IP: 217.70.178.44
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/18] eeepc-wmi: add hibernate/resume callbacks
Date: Sun,  6 Feb 2011 13:28:32 +0100
Message-Id: <1296995324-5462-8-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   49 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index de501fb..583ba78 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -1183,10 +1183,59 @@ static int eeepc_wmi_remove(struct platform_device *device)
 	return 0;
 }
 
+/*
+ * Platform driver - hibernate/resume callbacks
+ */
+static int eeepc_hotk_thaw(struct device *device)
+{
+	struct eeepc_wmi *eeepc = dev_get_drvdata(device);
+
+	if (eeepc->wlan_rfkill) {
+		bool wlan;
+
+		/*
+		 * Work around bios bug - acpi _PTS turns off the wireless led
+		 * during suspend.  Normally it restores it on resume, but
+		 * we should kick it ourselves in case hibernation is aborted.
+		 */
+		wlan = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WLAN);
+		eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_WLAN, wlan, NULL);
+	}
+
+	return 0;
+}
+
+static int eeepc_hotk_restore(struct device *device)
+{
+	struct eeepc_wmi *eeepc = dev_get_drvdata(device);
+	int bl;
+
+	/* Refresh both wlan rfkill state and pci hotplug */
+	if (eeepc->wlan_rfkill)
+		eeepc_rfkill_hotplug(eeepc);
+
+	if (eeepc->bluetooth_rfkill) {
+		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_BLUETOOTH);
+		rfkill_set_sw_state(eeepc->bluetooth_rfkill, bl);
+}
+	if (eeepc->wwan3g_rfkill) {
+		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WWAN3G);
+		rfkill_set_sw_state(eeepc->wwan3g_rfkill, bl);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops eeepc_pm_ops = {
+	.thaw = eeepc_hotk_thaw,
+	.restore = eeepc_hotk_restore,
+};
+
 static struct platform_driver platform_driver = {
 	.driver = {
 		.name = EEEPC_WMI_FILE,
 		.owner = THIS_MODULE,
+		.pm = &eeepc_pm_ops,
 	},
 };
 
-- 
1.7.4.rc3

