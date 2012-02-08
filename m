Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2BHOix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:38:53 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48567 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2BHOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:38:52 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] x86/mrst/pci: assign d3_delay to 0 for
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 08 Feb 2012 14:52:35 +0000
Message-ID: <20120208145226.10900.49460.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Langwell devices are not true pci devices, they are not subject to the 10 ms
d3 to d0 delay required by pci spec. This patch assigns d3_delay to 0 for all
langwell pci devices.

We can also power off devices that are not really used by the OS

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/pci/mrst.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)


diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index cb29191..89e5548 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -239,6 +239,30 @@ int __init pci_mrst_init(void)
 	return 1;
 }
 
+/* Langwell devices are not true pci devices, they are not subject to 10 ms
+ * d3 to d0 delay required by pci spec.
+ */
+static void __devinit pci_d3delay_fixup(struct pci_dev *dev)
+{
+	/* true pci devices in lincroft should allow type 1 access, the rest
+	 * are langwell fake pci devices.
+	 */
+	if (type1_access_ok(dev->bus->number, dev->devfn, PCI_DEVICE_ID))
+		return;
+	dev->d3_delay = 0;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_d3delay_fixup);
+
+static void __devinit mrst_power_off_unused_dev(struct pci_dev *dev)
+{
+	pci_set_power_state(dev, PCI_D3cold);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0801, mrst_power_off_unused_dev);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0809, mrst_power_off_unused_dev);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x080C, mrst_power_off_unused_dev);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0812, mrst_power_off_unused_dev);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0815, mrst_power_off_unused_dev);
+
 /*
  * Langwell devices reside at fixed offsets, don't try to move them.
  */

