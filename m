Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2IDPP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:15:58 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2IDPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:35 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLATQSECAFAiYCAlcGE4gRp3uSYIEhkAyBEgOVWZJ/
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821814"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 02/16] Staging: ipack/bridges/tpci200: Use the TPCI200 in big endian mode.
Date: Tue,  4 Sep 2012 17:01:07 +0200
Message-Id: <1346770881-4723-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

During initialization we configure the TPCI200 so it does not swap data
lanes on IndustryPack module access.  The read and write functions are
changed accordingly.

We are taking this approach in the hope that all IP Carriers are able to
present the Module memory layout unchanged.  We can thus directly access
the memory and registers of IP Modules without having to rely on the
read and write wrappers currently exposed in ipack_bus_opts.  A later
patch will convert the existing driver and remove the wrappers.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   49 +++++++++++++++++++++++++++----
 drivers/staging/ipack/bridges/tpci200.h |    9 ++++++
 drivers/staging/ipack/devices/ipoctal.c |    2 +-
 3 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index eda02e7..f2501c9 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -54,39 +54,39 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 static inline unsigned char __tpci200_read8(void __iomem *address,
 					    unsigned long offset)
 {
-	return ioread8(address + (offset^1));
+	return ioread8(address + offset);
 }
 
 static inline unsigned short __tpci200_read16(void __iomem *address,
 					      unsigned long offset)
 {
-	return ioread16(address + offset);
+	return ioread16be(address + offset);
 }
 
 static inline unsigned int __tpci200_read32(void __iomem *address,
 					    unsigned long offset)
 {
-	return swahw32(ioread32(address + offset));
+	return ioread32be(address + offset);
 }
 
 static inline void __tpci200_write8(unsigned char value,
 				    void __iomem *address, unsigned long offset)
 {
-	iowrite8(value, address+(offset^1));
+	iowrite8(value, address + offset);
 }
 
 static inline void __tpci200_write16(unsigned short value,
 				     void __iomem *address,
 				     unsigned long offset)
 {
-	iowrite16(value, address+offset);
+	iowrite16be(value, address + offset);
 }
 
 static inline void __tpci200_write32(unsigned int value,
 				     void __iomem *address,
 				     unsigned long offset)
 {
-	iowrite32(swahw32(value), address+offset);
+	iowrite32be(value, address + offset);
 }
 
 static struct ipack_addr_space *get_slot_address_space(struct ipack_device *dev,
@@ -783,6 +783,7 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 {
 	int ret, i;
 	struct tpci200_board *tpci200;
+	__le32 reg32;
 
 	tpci200 = kzalloc(sizeof(struct tpci200_board), GFP_KERNEL);
 	if (!tpci200)
@@ -794,6 +795,34 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 		goto out_err_info;
 	}
 
+	/* Obtain a mapping of the carrier's PCI configuration registers */
+	ret = pci_request_region(pdev, TPCI200_CFG_MEM_BAR,
+				 KBUILD_MODNAME " Configuration Memory");
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to allocate PCI Configuration Memory");
+		ret = -EBUSY;
+		goto out_err_pci_request;
+	}
+	tpci200->info->cfg_regs = ioremap_nocache(
+			pci_resource_start(pdev, TPCI200_CFG_MEM_BAR),
+			pci_resource_len(pdev, TPCI200_CFG_MEM_BAR));
+	if (!tpci200->info->cfg_regs) {
+		dev_err(&pdev->dev, "Failed to map PCI Configuration Memory");
+		ret = -EFAULT;
+		goto out_err_ioremap;
+	}
+
+	/* Disable byte swapping for 16 bit IP module access. This will ensure
+	 * that the Industrypack big endian byte order is preserved by the
+	 * carrier. */
+	reg32 = ioread32(tpci200->info->cfg_regs + LAS1_DESC);
+	reg32 |= 1 << LAS_BIT_BIGENDIAN;
+	iowrite32(reg32, tpci200->info->cfg_regs + LAS1_DESC);
+
+	reg32 = ioread32(tpci200->info->cfg_regs + LAS2_DESC);
+	reg32 |= 1 << LAS_BIT_BIGENDIAN;
+	iowrite32(reg32, tpci200->info->cfg_regs + LAS2_DESC);
+
 	/* Save struct pci_dev pointer */
 	tpci200->info->pdev = pdev;
 	tpci200->info->id_table = (struct pci_device_id *)id;
@@ -833,6 +862,10 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 out_err_bus_register:
 	tpci200_uninstall(tpci200);
 out_err_install:
+	iounmap(tpci200->info->cfg_regs);
+out_err_ioremap:
+	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
+out_err_pci_request:
 	kfree(tpci200->info);
 out_err_info:
 	kfree(tpci200);
@@ -843,6 +876,10 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 {
 	tpci200_uninstall(tpci200);
 	ipack_bus_unregister(tpci200->info->ipack_bus);
+
+	iounmap(tpci200->info->cfg_regs);
+	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
+
 	kfree(tpci200->info);
 	kfree(tpci200);
 }
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index d04510a..38acba1 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -31,6 +31,7 @@
 #define TPCI200_SUBVENDOR_ID          0x1498
 #define TPCI200_SUBDEVICE_ID          0x300A
 
+#define TPCI200_CFG_MEM_BAR           0
 #define TPCI200_IP_INTERFACE_BAR      2
 #define TPCI200_IO_ID_INT_SPACES_BAR  3
 #define TPCI200_MEM16_SPACE_BAR       4
@@ -97,6 +98,13 @@
 
 #define TPCI200_SLOT_INT_MASK         0x00FF
 
+/* PCI Configuration registers. The PCI bridge is a PLX Technology PCI9030. */
+#define LAS1_DESC		      0x2C
+#define LAS2_DESC		      0x30
+
+/* Bits in the LAS?_DESC registers */
+#define LAS_BIT_BIGENDIAN	      24
+
 #define VME_IOID_SPACE  "IOID"
 #define VME_MEM_SPACE  "MEM"
 
@@ -144,6 +152,7 @@ struct tpci200_infos {
 	void __iomem			*interface_regs;
 	void __iomem			*ioidint_space;
 	void __iomem			*mem8_space;
+	void __iomem			*cfg_regs;
 	struct ipack_bus_device		*ipack_bus;
 };
 struct tpci200_board {
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index fd0e301..963ed20 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -449,7 +449,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	 */
 	ipoctal->dev->bus->ops->request_irq(ipoctal->dev, vector,
 				       ipoctal_irq_handler, ipoctal);
-	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_MEM_SPACE, 0,
+	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_MEM_SPACE, 1,
 				       vector);
 
 	/* Register the TTY device */
-- 
1.7.10.4

