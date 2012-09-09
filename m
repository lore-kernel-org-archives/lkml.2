Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2IIXPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:15:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51042 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab2IIXPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:48 -0400
Message-Id: <20120909224152.452842247@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Gary E. Miller" <gem@rellim.com>
Subject: [ 11/95] xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 5cb7df2b2d3afee7638b3ef23a5bcb89c6f07bd9 upstream.

Gary reports that with recent kernels, he notices more xHCI driver
warnings:

xhci_hcd 0000:03:00.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?

We think his Etron xHCI host controller may have the same buggy behavior
as the Fresco Logic xHCI host.  When a short transfer is received, the
host will mark the transfer as successfully completed when it should be
marking it with a short completion.

Fix this by turning on the XHCI_TRUST_TX_LENGTH quirk when the Etron
host is discovered.  Note that Gary has revision 1, but if Etron fixes
this bug in future revisions, the quirk will have no effect.

This patch should be backported to kernels as old as 2.6.36, that
contain a backported version of commit
1530bbc6272d9da1e39ef8e06190d42c13a02733 "xhci: Add new short TX quirk
for Fresco Logic host."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Gary E. Miller <gem@rellim.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18b231b..92eaff6 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -99,6 +99,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;


