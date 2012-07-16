Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2GPQqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:46:18 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:58509 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab2GPQqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:46:14 -0400
Message-ID: <5004454E.9030903@compulab.co.il>
Date: Mon, 16 Jul 2012 19:46:06 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] xhci: EHCI/xHCI ports switching on Intense-PC.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intense-PC is Compulab's mini-desktop with Intel Panther Point
chipset.

Unconditional ports switching provided by function
usb_enable_xhci_ports() leads to surprising results, after shutdown
system powered-on again after a few seconds. On Windows power
related problems were not observed.

The patch avoids ports switching for Intense-PC.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index df0828c..6f72593 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -759,6 +759,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 {
 	u32		ports_available;

+	const char *brd_name;
+	brd_name = dmi_get_system_info(DMI_BOARD_NAME);
+
+	/* quirk for Compulab's Intense-PC board */
+	if (brd_name && strstr(brd_name, "Intense-PC"))
+		return;
+
 	/* Don't switchover the ports if the user hasn't compiled the xHCI
 	 * driver.  Otherwise they will see "dead" USB ports that don't power
 	 * the devices.
-- 
1.7.9.5
