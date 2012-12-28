Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab2L1TcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:32:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356Ab2L1TTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:20 -0500
Message-Id: <20121228190341.837221372@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        A Sh <smr.ash1991@gmail.com>
Subject: [ 056/173] xhci: Extend Fresco Logic MSI quirk.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit bba18e33f25072ebf70fd8f7f0cdbf8cdb59a746 upstream.

Ali reports that plugging a device into the Fresco Logic xHCI host with
PCI device ID 1400 produces an IRQ error:

 do_IRQ: 3.176 No irq handler for vector (irq -1)

Other early Fresco Logic host revisions don't support MSI, even though
their PCI config space claims they do.  Extend the quirk to disabling
MSI to this chipset revision.  Also enable the short transfer quirk,
since it's likely this revision also has that quirk, and it should be
harmless to enable.

04:00.0 0c03: 1b73:1400 (rev 01) (prog-if 30 [XHCI])
        Subsystem: 1d5c:1000
        Physical Slot: 3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 51
        Region 0: Memory at d4600000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000feeff00c  Data: 41b1
        Capabilities: [80] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <2us, L1 <32us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: xhci_hcd

This patch should be backported to stable kernels as old as 2.6.36, that
contain the commit f5182b4155b9d686c5540a6822486400e34ddd98 "xhci:
Disable MSI for some Fresco Logic hosts."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: A Sh <smr.ash1991@gmail.com>
Tested-by: A Sh <smr.ash1991@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 8345d7c..dcb72f7 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -29,6 +29,7 @@
 /* Device for a quirk */
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
+#define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_ASROCK_P67	0x7023
@@ -58,8 +59,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
-			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK) {
-		if (pdev->revision == 0x0) {
+			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
+			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
+		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
+				pdev->revision == 0x0) {
 			xhci->quirks |= XHCI_RESET_EP_QUIRK;
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");


