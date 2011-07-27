Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1G0WIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:08:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:36473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab1G0VsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826287"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: stern@rowland.harvard.edu, andre.osku.schmidt@googlemail.com,
        yurand2@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [21/99] OHCI: fix regression caused by nVidia shutdown workaround
Message-Id: <20110727214819.ADD9B2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 2b7aaf503d56216b847c8265421d2a7d9b42df3e upstream.

This patch (as1463) fixes a regression caused by commit
3df7169e73fc1d71a39cffeacc969f6840cdf52b (OHCI: work around for nVidia
shutdown problem).

The original problem encountered by people using NVIDIA chipsets was
that USB devices were not turning off when the system shut down.  For
example, the LED on an optical mouse would remain on, draining a
laptop's battery.  The problem was caused by a bug in the chipset; an
OHCI controller in the Reset state would continue to drive a bus reset
signal even after system shutdown.  The workaround was to put the
controllers into the Suspend state instead.

It turns out that later NVIDIA chipsets do not suffer from this bug.
Instead some have the opposite bug: If a system is shut down while an
OHCI controller is in the Suspend state, USB devices remain powered!
On other systems, shutting down with a Suspended controller causes the
system to reboot immediately.  Thus, working around the original bug
on some machines exposes other bugs on other machines.

The best solution seems to be to limit the workaround to OHCI
controllers with a low-numbered PCI product ID.  I don't know exactly
at what point NVIDIA changed their chipsets; the value used here is a
guess.  So far it was worked out okay for all the people who have
tested it.

This fixes Bugzilla #35032.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Andre "Osku" Schmidt <andre.osku.schmidt@googlemail.com>
Tested-by: Yury Siamashka <yurand2@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/ohci-pci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/ohci-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ohci-pci.c
+++ linux-2.6.35.y/drivers/usb/host/ohci-pci.c
@@ -207,10 +207,18 @@ static int ohci_quirk_amd700(struct usb_
  */
 static int ohci_quirk_nvidia_shutdown(struct usb_hcd *hcd)
 {
+	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
 
-	ohci->flags |= OHCI_QUIRK_SHUTDOWN;
-	ohci_dbg(ohci, "enabled nVidia shutdown quirk\n");
+	/* Evidently nVidia fixed their later hardware; this is a guess at
+	 * the changeover point.
+	 */
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_USB		0x026d
+
+	if (pdev->device < PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_USB) {
+		ohci->flags |= OHCI_QUIRK_SHUTDOWN;
+		ohci_dbg(ohci, "enabled nVidia shutdown quirk\n");
+	}
 
 	return 0;
 }
