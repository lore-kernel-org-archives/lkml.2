Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1GPMhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47385 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab1GPMhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:17 -0400
Date: Sat, 16 Jul 2011 21:15:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        "Joerg Roedel" <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: manual merge of the tip tree with the of-pci tree
Message-Id: <20110716211523.f3932e32f347c29eb4b6254d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/pci.h between commit 98d9f30c820d ("pci/of: Match PCI
devices to OF nodes dynamically") from the of-pci tree and commit
166e9278a3f9 ("x86/ia64: intel-iommu: move to drivers/iommu/") from the
tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/pci.h
index 2d29218,970bfe0..0000000
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@@ -1589,33 -1589,16 +1589,44 @@@ int pci_vpd_find_tag(const u8 *buf, uns
  int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
  			      unsigned int len, const char *kw);
  
 +/* PCI <-> OF binding helpers */
 +#ifdef CONFIG_OF
 +struct device_node;
 +extern void pci_set_of_node(struct pci_dev *dev);
 +extern void pci_release_of_node(struct pci_dev *dev);
 +extern void pci_set_bus_of_node(struct pci_bus *bus);
 +extern void pci_release_bus_of_node(struct pci_bus *bus);
 +
 +/* Arch may override this (weak) */
 +extern struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus);
 +
 +static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
 +{
 +	return pdev ? pdev->dev.of_node : NULL;
 +}
 +
 +static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 +{
 +	return bus ? bus->dev.of_node : NULL;
 +}
 +
 +#else /* CONFIG_OF */
 +static inline void pci_set_of_node(struct pci_dev *dev) { }
 +static inline void pci_release_of_node(struct pci_dev *dev) { }
 +static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
 +static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
 +#endif  /* CONFIG_OF */
 +
+ /**
+  * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device
+  * @pdev: the PCI device
+  *
+  * if the device is PCIE, return NULL
+  * if the device isn't connected to a PCIe bridge (that is its parent is a
+  * legacy PCI bridge and the bridge is directly connected to bus 0), return its
+  * parent
+  */
+ struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+ 
  #endif /* __KERNEL__ */
  #endif /* LINUX_PCI_H */
