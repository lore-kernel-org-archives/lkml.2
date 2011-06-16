Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1FPHRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:17:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50712 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756956Ab1FPHLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:06 -0400
X-Sasl-enc: BC2PJ7L0fNBV5QgpdgJKm58xlBDWwC873KsnBV1lz3dX 1308208265
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:09 2011
Message-Id: <20110616002909.726897506@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jordan Hargrave <jordan_hargrave@dell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [59/85] PCI: Set PCIE maxpayload for card during hotplug insertion
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "Jordan_Hargrave@Dell.com" <Jordan_Hargrave@Dell.com>

commit e522a7126c7c144a1dd14c6f217ac31e71082b1d upstream.

The following patch sets the MaxPayload setting to match the parent
reading when inserting a PCIE card into a hotplug slot.  On our system,
the upstream bridge is set to 256, but when inserting a card, the card
setting defaults to 128.  As soon as I/O is performed to the card it
starts receiving errors since the payload size is too small.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/pcihp_slot.c |   45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -158,6 +158,47 @@ static void program_hpp_type2(struct pci
 	 */
 }
 
+/* Program PCIE MaxPayload setting on device: ensure parent maxpayload <= device */
+static int pci_set_payload(struct pci_dev *dev)
+{
+       int pos, ppos;
+       u16 pctl, psz;
+       u16 dctl, dsz, dcap, dmax;
+       struct pci_dev *parent;
+
+       parent = dev->bus->self;
+       pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+       if (!pos)
+               return 0;
+
+       /* Read Device MaxPayload capability and setting */
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &dctl);
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCAP, &dcap);
+       dsz = (dctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+       dmax = (dcap & PCI_EXP_DEVCAP_PAYLOAD);
+
+       /* Read Parent MaxPayload setting */
+       ppos = pci_find_capability(parent, PCI_CAP_ID_EXP);
+       if (!ppos)
+               return 0;
+       pci_read_config_word(parent, ppos + PCI_EXP_DEVCTL, &pctl);
+       psz = (pctl &  PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+
+       /* If parent payload > device max payload -> error
+        * If parent payload > device payload -> set speed
+        * If parent payload <= device payload -> do nothing
+        */
+       if (psz > dmax)
+               return -1;
+       else if (psz > dsz) {
+               dev_info(&dev->dev, "Setting MaxPayload to %d\n", 128 << psz);
+               pci_write_config_word(dev, pos + PCI_EXP_DEVCTL,
+                                     (dctl & ~PCI_EXP_DEVCTL_PAYLOAD) +
+                                     (psz << 5));
+       }
+       return 0;
+}
+
 void pci_configure_slot(struct pci_dev *dev)
 {
 	struct pci_dev *cdev;
@@ -169,6 +210,10 @@ void pci_configure_slot(struct pci_dev *
 			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
 		return;
 
+       ret = pci_set_payload(dev);
+       if (ret)
+               dev_warn(&dev->dev, "could not set device max payload\n");
+
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
 	if (ret)


