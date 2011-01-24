Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1AXQeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:34:50 -0500
Received: from fb2.tech.numericable.fr ([82.216.111.50]:52199 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1AXQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:33:34 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 10/14] eeepc-wmi: use the presence bit correctly
Date: Mon, 24 Jan 2011 17:23:54 +0100
Message-Id: <1295886238-15961-11-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
References: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I checked some more DSDT, and it seems that I wasn't
totally right about the meaning of DSTS return value.
Bit 0 is clearly the status of the device, and I discovered
that bit 16 is set when the device is present.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index aa9e1d1..391c32b 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -75,6 +75,9 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define EEEPC_WMI_DEVID_BACKLIGHT	0x00050012
 #define EEEPC_WMI_DEVID_TPDLED		0x00100011
 
+#define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
+#define EEEPC_WMI_DSTS_PRESENCE_BIT	0x00010000
+
 static bool hotplug_wireless;
 
 module_param(hotplug_wireless, bool, 0444);
@@ -265,16 +268,10 @@ static int eeepc_wmi_get_devstate_simple(u32 dev_id)
 	if (ACPI_FAILURE(status))
 		return -EINVAL;
 
-	/* If the device is present, DSTS will always set some bits
-	 * 0x00070000 - 1110000000000000000 - device supported
-	 * 0x00060000 - 1100000000000000000 - not supported
-	 * 0x00020000 - 0100000000000000000 - device supported
-	 * 0x00010000 - 0010000000000000000 - not supported / special mode ?
-	 */
-	if (!retval || retval == 0x00060000)
+	if (!(retval & EEEPC_WMI_DSTS_PRESENCE_BIT))
 		return -ENODEV;
 
-	return retval & 0x1;
+	return retval & EEEPC_WMI_DSTS_STATUS_BIT;
 }
 
 /*
-- 
1.7.3.4

