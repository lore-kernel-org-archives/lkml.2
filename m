Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2IMAoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:44:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab2ILXab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:30:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Gabor Juhos <juhosg@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [ 017/108] MIPS: pci-ar724x: avoid data bus error due to a missing PCIe module
Date: Wed, 12 Sep 2012 16:28:15 -0700
Message-Id: <20120912232452.346902780@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit a1dca315ce3f78347bca8ce8befe3cc71ae63b7e upstream.

If the controller has no PCIe module attached, accessing of the device
configuration space causes a data bus error. Avoid this by checking the
status of the PCIe link in advance, and indicate an error if the link
is down.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/4293/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/pci/pci-ar724x.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/mips/pci/pci-ar724x.c
+++ b/arch/mips/pci/pci-ar724x.c
@@ -23,9 +23,12 @@
 #define AR724X_PCI_MEM_BASE	0x10000000
 #define AR724X_PCI_MEM_SIZE	0x08000000
 
+#define AR724X_PCI_REG_RESET		0x18
 #define AR724X_PCI_REG_INT_STATUS	0x4c
 #define AR724X_PCI_REG_INT_MASK		0x50
 
+#define AR724X_PCI_RESET_LINK_UP	BIT(0)
+
 #define AR724X_PCI_INT_DEV0		BIT(14)
 
 #define AR724X_PCI_IRQ_COUNT		1
@@ -38,6 +41,15 @@ static void __iomem *ar724x_pci_ctrl_bas
 
 static u32 ar724x_pci_bar0_value;
 static bool ar724x_pci_bar0_is_cached;
+static bool ar724x_pci_link_up;
+
+static inline bool ar724x_pci_check_link(void)
+{
+	u32 reset;
+
+	reset = __raw_readl(ar724x_pci_ctrl_base + AR724X_PCI_REG_RESET);
+	return reset & AR724X_PCI_RESET_LINK_UP;
+}
 
 static int ar724x_pci_read(struct pci_bus *bus, unsigned int devfn, int where,
 			    int size, uint32_t *value)
@@ -46,6 +58,9 @@ static int ar724x_pci_read(struct pci_bu
 	void __iomem *base;
 	u32 data;
 
+	if (!ar724x_pci_link_up)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
 	if (devfn)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
@@ -96,6 +111,9 @@ static int ar724x_pci_write(struct pci_b
 	u32 data;
 	int s;
 
+	if (!ar724x_pci_link_up)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
 	if (devfn)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
@@ -280,6 +298,10 @@ int __init ar724x_pcibios_init(int irq)
 	if (ar724x_pci_ctrl_base == NULL)
 		goto err_unmap_devcfg;
 
+	ar724x_pci_link_up = ar724x_pci_check_link();
+	if (!ar724x_pci_link_up)
+		pr_warn("ar724x: PCIe link is down\n");
+
 	ar724x_pci_irq_init(irq);
 	register_pci_controller(&ar724x_pci_controller);
 


