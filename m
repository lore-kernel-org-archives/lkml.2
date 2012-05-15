Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625Ab2EOCSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53104 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907Ab2EOCQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 050/179] PCI: Set PCIE maxpayload for card during hotplug insertion
Date: Mon, 14 May 2012 22:12:26 -0400
Message-ID: <1337048075-6132-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jordan_Hargrave@Dell.com" <Jordan_Hargrave@Dell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e522a7126c7c144a1dd14c6f217ac31e71082b1d upstream.

The following patch sets the MaxPayload setting to match the parent
reading when inserting a PCIE card into a hotplug slot.  On our system,
the upstream bridge is set to 256, but when inserting a card, the card
setting defaults to 128.  As soon as I/O is performed to the card it
starts receiving errors since the payload size is too small.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/hotplug/pcihp_slot.c |   45 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
index 80b461c..749fdf0 100644
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -158,6 +158,47 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
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
@@ -169,6 +210,10 @@ void pci_configure_slot(struct pci_dev *dev)
 			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
 		return;
 
+       ret = pci_set_payload(dev);
+       if (ret)
+               dev_warn(&dev->dev, "could not set device max payload\n");
+
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
 	if (ret)
-- 
1.7.9.6

