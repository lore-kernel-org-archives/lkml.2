Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KUAdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:33:19 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63280 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0KUAdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:33:18 -0500
From: "Brian J. Tarricone" <brian@tarricone.org>
To: linux-kernel@vger.kernel.org
Cc: Brian Tarricone <brian@tarricone.org>, Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH] ehci: disable LPM and PPCD for nVidia MCP89 chips
Date: Sat, 20 Nov 2010 16:32:55 -0800
Message-Id: <1290299575-15911-1-git-send-email-brian@tarricone.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Tarricone <brian@tarricone.org>

Tested on MacBookAir3,1.  Without this, we get EPROTO errors when
fetching device config descriptors.

Signed-off-by: Brian Tarricone <brian@tarricone.org>
Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
Tested-by: Edgar Hucek <gimli@dark-green.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/usb/host/ehci-pci.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index a1e8d27..aa79f98 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -148,6 +148,18 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			if (pdev->revision < 0xa4)
 				ehci->no_selective_suspend = 1;
 			break;
+
+		/* MCP89 chips on the MacBookAir3,1 give EPROTO when
+		 * fetching device descriptors unless LPM is disabled.
+		 * There are also intermittent problems enumerating
+		 * devices with PPCD enabled.
+		 */
+		case 0x0d9d:
+			ehci_info(ehci, "disable lpm/ppcd for nvidia mcp89");
+			ehci->has_lpm = 0;
+			ehci->has_ppcd = 0;
+			ehci->command &= ~(CMD_PPCEE);
+			break;
 		}
 		break;
 	case PCI_VENDOR_ID_VIA:
-- 
1.7.2.2

