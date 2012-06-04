Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2FDFkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:37 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54747 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2FDFkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:32 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 09/15] acpi_video: Intel video is not always i915
Date: Mon,  4 Jun 2012 01:40:00 -0400
Message-Id: <c6996bdd850fb53319918487d5f674203517fdc5.1338786832.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Stop it poking at random registers on the i740 cards that may be out there
still.

As per Matthew's feedback remove the conditional checks and never enable the
opregion handling unless an appropriate driver has been loaded.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/video.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 66e8f73..609262d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1743,10 +1743,18 @@ static int acpi_video_bus_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
+static int __init is_i740(struct pci_dev *dev)
+{
+	if (dev->device == 0x00D1)
+		return 1;
+	if (dev->device == 0x7000)
+		return 1;
+	return 0;
+}
+
 static int __init intel_opregion_present(void)
 {
-	int i915 = 0;
-#if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
+	int opregion = 0;
 	struct pci_dev *dev = NULL;
 	u32 address;
 
@@ -1755,13 +1763,15 @@ static int __init intel_opregion_present(void)
 			continue;
 		if (dev->vendor != PCI_VENDOR_ID_INTEL)
 			continue;
+		/* We don't want to poke around undefined i740 registers */
+		if (is_i740(dev))
+			continue;
 		pci_read_config_dword(dev, 0xfc, &address);
 		if (!address)
 			continue;
-		i915 = 1;
+		opregion = 1;
 	}
-#endif
-	return i915;
+	return opregion;
 }
 
 int acpi_video_register(void)
-- 
1.7.11.rc0.100.g5498c5f

