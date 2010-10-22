Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab0JVTIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:08:47 -0400
Received: from kroah.org ([198.145.64.141]:34236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759409Ab0JVS4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:40 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:32 2010
Message-Id: <20101022185232.760272391@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [060/103] firewire: ohci: fix TI TSB82AA2 regression since 2.6.35
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit aa0170fff3c26bf2b42159af2dd9cf86444c292a upstream.

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
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |   19 +------------------
 drivers/firewire/ohci.h |    8 --------
 2 files changed, 1 insertion(+), 26 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2439,7 +2439,7 @@ static int __devinit pci_probe(struct pc
 			       const struct pci_device_id *ent)
 {
 	struct fw_ohci *ohci;
-	u32 bus_options, max_receive, link_speed, version, link_enh;
+	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
 	int i, err, n_ir, n_it;
 	size_t size;
@@ -2492,23 +2492,6 @@ static int __devinit pci_probe(struct pc
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
 
--- a/drivers/firewire/ohci.h
+++ b/drivers/firewire/ohci.h
@@ -154,12 +154,4 @@
 
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


