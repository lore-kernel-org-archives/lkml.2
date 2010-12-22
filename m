Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0LVO3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:29:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61564 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0LVO3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DFBRRDdB8xY4+AEFPg1e7a6onemgbYYNhChMR8vYJLRE53ThN4eNNr4JZIVfWYiTxU
         4D8ZgrRd7Z+7q3iFTpiovbwdS/PmDL3H8YVJ5uzyyp84XzURWdVPs/lfsgIZZrrPO3dW
         iPBkbd/H2MWpVlsRUF48XG9kUepvomrBkHPD8=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Anatolij Gustschin <agust@denx.de>, Anand Gadiyar <gadiyar@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Paul Mortier <mortier@btinternet.com>, Andiry Xu <andiry.xu@amd.com>
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH V2 2/2] MSP onchip root hub over current quirk.
Date: Wed, 22 Dec 2010 20:06:50 +0530
Message-Id: <1293028610-22233-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <y>
References: <y>
In-Reply-To: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
References: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Adding chip specific code under quirk.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 drivers/usb/core/hub.c     |   45 ++++++++++++++++++++++++++++++++++++++-----
 drivers/usb/core/quirks.c  |    3 ++
 include/linux/usb/quirks.h |    3 ++
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 27115b4..4bff994 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3377,12 +3377,45 @@ static void hub_events(void)
 			}
 			
 			if (portchange & USB_PORT_STAT_C_OVERCURRENT) {
-				dev_err (hub_dev,
-					"over-current change on port %d\n",
-					i);
-				clear_port_feature(hdev, i,
-					USB_PORT_FEAT_C_OVER_CURRENT);
-				hub_power_on(hub, true);
+				usb_detect_quirks(hdev);
+				if (hdev->quirks & USB_QUIRK_MSP_OVERCURRENT) {
+					/* clear OCC bit */
+					clear_port_feature(hdev, i,
+						USB_PORT_FEAT_C_OVER_CURRENT);
+
+					/* This step is required to toggle the
+					* PP bit to 0 and 1 (by hub_power_on)
+					* in order the CSC bit to be
+					* transitioned properly for device
+					* hotplug
+					*/
+					/* clear PP bit */
+					clear_port_feature(hdev, i,
+						USB_PORT_FEAT_POWER);
+
+					/* resume power */
+					hub_power_on(hub, true);
+
+					/* delay 100 usec */
+					udelay(100);
+
+					/* read OCA bit */
+					if (portstatus &
+					(1<<USB_PORT_FEAT_OVER_CURRENT)) {
+						/* declare overcurrent */
+						dev_err(hub_dev,
+						"over-current change \
+							on port %d\n", i);
+					}
+				} else {
+					dev_err(hub_dev,
+						"over-current change \
+							on port %d\n", i);
+					clear_port_feature(hdev, i,
+						USB_PORT_FEAT_C_OVER_CURRENT);
+					hub_power_on(hub, true);
+				}
+
 			}
 
 			if (portchange & USB_PORT_STAT_C_RESET) {
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 25719da..59843b9 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -88,6 +88,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* PMC MSP over current quirk */
+	{ USB_DEVICE(0x1d6b, 0x0002), .driver_info = USB_QUIRK_MSP_OVERCURRENT },
+
 	{ }  /* terminating entry must be last */
 };
 
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 3e93de7..97ab168 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -30,4 +30,7 @@
    descriptor */
 #define USB_QUIRK_DELAY_INIT		0x00000040
 
+/*MSP SoC onchip EHCI overcurrent issue */
+#define USB_QUIRK_MSP_OVERCURRENT	0x00000080
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
1.7.0.4

