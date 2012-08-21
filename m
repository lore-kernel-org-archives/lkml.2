Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2HUEHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:07:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2HUEG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:06:59 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, manoj.iyer@canonical.com
Subject: [PATCH 1/1] xhci: Unconditionally switch ports to xHCI on powerup
Date: Mon, 20 Aug 2012 23:06:55 -0500
Message-Id: <1345522015-13740-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345521975-13708-1-git-send-email-manoj.iyer@canonical.com>
References: <1345521975-13708-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

USB 3.0 devices show up as high-speed devices on powerup, after an
s3 cycle they are correctly recognized as SuperSpeed. At powerup
unconditionally switch the port to xHCI like we do when we resume
from suspend.

BugLink: http://bugs.launchpad.net/bugs/1000424

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/usb/host/xhci-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9bfd4ca11..5c8dbea 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -48,6 +48,14 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
 	if (!pci_set_mwi(pdev))
 		xhci_dbg(xhci, "MWI active\n");
 
+	/*
+	 * USB SuperSpeed ports are recognized as HighSpeed ports on powerup
+	 * unconditionally switch the ports to xHCI like we do when resume
+	 * from suspend.
+	 */
+	if (usb_is_intel_switchable_xhci(pdev))
+		usb_enable_xhci_ports(pdev);
+
 	xhci_dbg(xhci, "Finished xhci_pci_reinit\n");
 	return 0;
 }
-- 
1.7.9.5

