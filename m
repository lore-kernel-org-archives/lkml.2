Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab2G0EEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:04:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2G0EEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:04:35 -0400
From: Daniel J Blueman <daniel@quora.org>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Add Etron XHCI quirk to avoid warning spam
Date: Fri, 27 Jul 2012 12:03:44 +0800
Message-Id: <1343361824-11417-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When various USB3 devices with Etron XHCI controllers, we see a bunch of
warnings:
xhci_hcd 0000:02:00.0: WARN Successful completion on short TX: needs
XHCI_TRUST_TX_LENGTH quirk?

Acknowledge the issue by adding the quirk.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/usb/host/xhci-pci.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18b231b..715ad11 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -95,10 +95,13 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->limit_active_eps = 64;
 		xhci->quirks |= XHCI_SW_BW_CHECKING;
 	}
-	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
-		xhci->quirks |= XHCI_RESET_ON_RESUME;
-		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
+	if (pdev->vendor == PCI_VENDOR_ID_ETRON) {
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+
+		if (pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
+			xhci->quirks |= XHCI_RESET_ON_RESUME;
+			xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
+		}
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
-- 
1.7.9.5

