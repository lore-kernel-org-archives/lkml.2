Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab1FWRZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab1FWRZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:25:05 -0400
Date: Thu, 23 Jun 2011 13:25:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172504.27758.60054.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 28/35] drivers/usb changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- add exactmatch functionality

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/usb/host/pci-quirks.c |   19 ++++++++++++++-----
 drivers/usb/host/uhci-hcd.c   |    2 +-
 drivers/usb/host/uhci-pci.c   |   15 +++++++++++----
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index fd93061..ae2a681 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include "pci-quirks.h"
 #include "xhci-ext-caps.h"
 
@@ -507,6 +507,18 @@ static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	iounmap(base);
 }
 
+static const struct sysfw_id __devinitdata ehci_bios_handoff_table[] = {
+	{
+		.ident = "Pegatron Lucid (ExoPC) Tablet",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "EXOPG06411"),
+			SYSFW_MATCH(SYSFW_BIOS_VERSION, "Lucid-CE-133"),
+		},
+		.exactmatch = 1,
+	},
+	{}
+};
+
 static void __devinit ehci_bios_handoff(struct pci_dev *pdev,
 					void __iomem *op_reg_base,
 					u32 cap, u8 offset)
@@ -517,10 +529,7 @@ static void __devinit ehci_bios_handoff(struct pci_dev *pdev,
 	 * seconds trying the handoff on its unused controller.  Skip
 	 * it. */
 	if (pdev->vendor == 0x8086 && pdev->device == 0x283a) {
-		const char *dmi_bn = dmi_get_system_info(DMI_BOARD_NAME);
-		const char *dmi_bv = dmi_get_system_info(DMI_BIOS_VERSION);
-		if (dmi_bn && !strcmp(dmi_bn, "EXOPG06411") &&
-		    dmi_bv && !strcmp(dmi_bv, "Lucid-CE-133"))
+		if (sysfw_callback(ehci_bios_handoff_table))
 			try_handoff = 0;
 	}
 
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index fba99b1..1b03b7a 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -40,7 +40,7 @@
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 #include <linux/bitops.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
index c300bd2f7..ef3de10 100644
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -88,18 +88,25 @@ static int uhci_pci_resume_detect_interrupts_are_broken(struct uhci_hcd *uhci)
 	return 0;
 }
 
+static const struct sysfw_id bad_Asus_board_id[] = {
+	{
+		.ident = "A7V8X",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "A7V8X"),
+		},
+	},
+	{}
+};
+
 static int uhci_pci_global_suspend_mode_is_broken(struct uhci_hcd *uhci)
 {
 	int port;
-	const char *sys_info;
-	static const char bad_Asus_board[] = "A7V8X";
 
 	/* One of Asus's motherboards has a bug which causes it to
 	 * wake up immediately from suspend-to-RAM if any of the ports
 	 * are connected.  In such cases we will not set EGSM.
 	 */
-	sys_info = dmi_get_system_info(DMI_BOARD_NAME);
-	if (sys_info && !strcmp(sys_info, bad_Asus_board)) {
+	if (sysfw_callback(bad_Asus_board_id)) {
 		for (port = 0; port < uhci->rh_numports; ++port) {
 			if (inw(uhci->io_addr + USBPORTSC1 + port * 2) &
 					USBPORTSC_CCS)
-- 
1.7.5.4

