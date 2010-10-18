Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0JRMBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:01:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60222 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0JRMBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:01:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 18 Oct 2010 13:57:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.e34cffac0ba3b03c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following firewire driver update.  It is a
straight-forward revert.  Thanks.

Stefan Richter (1):
      firewire: ohci: fix TI TSB82AA2 regression since 2.6.35

 drivers/firewire/ohci.c |   19 +------------------
 drivers/firewire/ohci.h |    8 --------
 2 files changed, 1 insertions(+), 26 deletions(-)


commit aa0170fff3c26bf2b42159af2dd9cf86444c292a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 17 14:09:12 2010 +0200

    firewire: ohci: fix TI TSB82AA2 regression since 2.6.35
    
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

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 1b05896..9dcb17d 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2840,7 +2840,7 @@ static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
 {
 	struct fw_ohci *ohci;
-	u32 bus_options, max_receive, link_speed, version, link_enh;
+	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
 	int i, err, n_ir, n_it;
 	size_t size;
@@ -2894,23 +2894,6 @@ static int __devinit pci_probe(struct pci_dev *dev,
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
 
diff --git a/drivers/firewire/ohci.h b/drivers/firewire/ohci.h
index 0e6c5a4..ef5e733 100644
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
-=====-==-=- =-=- =--=-
http://arcgraph.de/sr/

