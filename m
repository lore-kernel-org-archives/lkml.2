Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab1IMXO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 19:14:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab1IMXOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 19:14:55 -0400
From: Sameer Nanda <snanda@chromium.org>
To: stern@rowland.harvard.edu, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH] USB: ehci-pci: Check and enable wakeup capability
Date: Tue, 13 Sep 2011 16:14:21 -0700
Message-Id: <1315955661-29493-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PORTWAK register is implemented and at least one of the physical
ports is enabled for wakeup, enable wakeup for the ehci-pci device.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
 drivers/usb/host/ehci-pci.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 1102ce6..ce6f784 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -285,6 +285,16 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			dev_warn(&pdev->dev, "Enabling legacy PCI PM\n");
 			device_set_wakeup_capable(&pdev->dev, 1);
 		}
+	} else {
+		u16	port_wake;
+
+		pci_read_config_word(pdev, 0x62, &port_wake);
+
+		/* If PORTWAK register is implemented and at least one USB
+		 * port is enabled for wakeup, enable wakeup.
+		 */
+		if (port_wake & 0x0001 && port_wake & 0xfffe)
+			device_set_wakeup_enable(&pdev->dev, 1);
 	}
 
 #ifdef	CONFIG_USB_SUSPEND
-- 
1.7.3.1

