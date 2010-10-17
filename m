Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0JQLum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 07:50:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52704 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0JQLul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 07:50:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Oct 2010 13:50:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: fix TI TSB82AA2 regression since 2.6.35
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Eric Shattow <lucent@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>
Message-ID: <tkrat.e62242bd924b1d5b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert commit 54672386ccf36ffa21d1de8e75624af83f9b0eeb
"firewire: ohci: fix up configuration of TI chips".
It caused massive slow-down and data corruption with a TSB82AA2 based
StarTech EC1394B2 ExpressCard and FireWire 800 harddisks.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/657081
http://thread.gmane.org/gmane.linux.kernel.firewire.user/4013

The fact that some card EEPROMs do not program these enhancements may be
related to TSB81BA3 phy chip errata, if not to bugs of TSB82AA2 itself.
We could re-add these configuration steps, but only conditional on a
whitelist of cards on which these enhancements bring a proven positive
effect.

Reported-and-tested-by: Eric Shattow <lucent@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: <stable@kernel.org> 2.6.35
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   19 +------------------
 drivers/firewire/ohci.h |    8 --------
 2 files changed, 1 insertion(+), 26 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2843,7 +2843,7 @@ static int __devinit pci_probe(struct pc
 			       const struct pci_device_id *ent)
 {
 	struct fw_ohci *ohci;
-	u32 bus_options, max_receive, link_speed, version, link_enh;
+	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
 	int i, err, n_ir, n_it;
 	size_t size;
@@ -2897,23 +2897,6 @@ static int __devinit pci_probe(struct pc
 	if (param_quirks)
 		ohci->quirks = param_quirks;
 
-	/* TI OHCI-Lynx and compatible: set recommended configuration bits. */
-	if (dev->vendor == PCI_VENDOR_ID_TI) {
-		pci_read_config_dword(dev, PCI_CFG_TI_LinkEnh, &link_enh);
-
-		/* adjust latency of ATx FIFO: use 1.7 KB threshold */
-		link_enh &= ~TI_LinkEnh_atx_thresh_mask;
-		link_enh |= TI_LinkEnh_atx_thresh_1_7K;
-
-		/* use priority arbitration for asynchronous responses */
-		link_enh |= TI_LinkEnh_enab_unfair;
-
-		/* required for aPhyEnhanceEnable to work */
-		link_enh |= TI_LinkEnh_enab_accel;
-
-		pci_write_config_dword(dev, PCI_CFG_TI_LinkEnh, link_enh);
-	}
-
 	ar_context_init(&ohci->ar_request_ctx, ohci,
 			OHCI1394_AsReqRcvContextControlSet);
 
Index: b/drivers/firewire/ohci.h
===================================================================
--- a/drivers/firewire/ohci.h
+++ b/drivers/firewire/ohci.h
@@ -155,12 +155,4 @@
 
 #define OHCI1394_phy_tcode		0xe
 
-/* TI extensions */
-
-#define PCI_CFG_TI_LinkEnh		0xf4
-#define  TI_LinkEnh_enab_accel		0x00000002
-#define  TI_LinkEnh_enab_unfair		0x00000080
-#define  TI_LinkEnh_atx_thresh_mask	0x00003000
-#define  TI_LinkEnh_atx_thresh_1_7K	0x00001000
-
 #endif /* _FIREWIRE_OHCI_H */

-- 
Stefan Richter
-=====-==-=- =-=- =---=
http://arcgraph.de/sr/

