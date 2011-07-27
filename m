Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1G0WDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:03:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:24579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab1G0Vsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900610"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Jordan_Hargrave@Dell.com, kaneshige.kenji@jp.fujitsu.com,
        jordan_hargrave@Dell.com, jbarnes@virtuousgeek.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [40/99] PCI: Set PCIE maxpayload for card during hotplug insertion
Message-Id: <20110727214839.0C7E42403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/hotplug/pcihp_slot.c |   45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

Index: linux-2.6.35.y/drivers/pci/hotplug/pcihp_slot.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/hotplug/pcihp_slot.c
+++ linux-2.6.35.y/drivers/pci/hotplug/pcihp_slot.c
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
