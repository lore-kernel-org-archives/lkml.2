Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2AUKxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:53:51 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:37873 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2AUKxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:53:49 -0500
Message-ID: <4F1A98F5.3080402@freemail.hu>
Date: Sat, 21 Jan 2012 11:52:37 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
CC: techeng <dzshen@gmail.com>, clyu@citiz.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add Winbond WB528SD Secure Digital (SD) card reader driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.83.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

This driver version of Winbond WB528SD can detect mechanical card
presence only. The information is provided through sysfs.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: techeng <dzshen@gmail.com>
---
 drivers/staging/Kconfig           |    2 +
 drivers/staging/Makefile          |    1 +
 drivers/staging/wb528sd/Kconfig   |   16 ++
 drivers/staging/wb528sd/Makefile  |    1 +
 drivers/staging/wb528sd/wb528sd.c |  274 +++++++++++++++++++++++++++++++++++++
 5 files changed, 294 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/wb528sd/Kconfig
 create mode 100644 drivers/staging/wb528sd/Makefile
 create mode 100644 drivers/staging/wb528sd/wb528sd.c

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 21e2f4b..c1ce429 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -132,4 +132,6 @@ source "drivers/staging/omapdrm/Kconfig"

 source "drivers/staging/android/Kconfig"

+source "drivers/staging/wb528sd/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 7c5808d..7da8c3b 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
 obj-$(CONFIG_DRM_OMAP)		+= omapdrm/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_WB528SD)		+= wb528sd/
diff --git a/drivers/staging/wb528sd/Kconfig b/drivers/staging/wb528sd/Kconfig
new file mode 100644
index 0000000..b7af426
--- /dev/null
+++ b/drivers/staging/wb528sd/Kconfig
@@ -0,0 +1,16 @@
+config WB528SD
+	tristate "Winbond 528SD Secure Digital (SD) card reader"
+	depends on PCI
+	help
+	  The Winbond 528SD Secure Digital (SD) card reader connects to
+	  the PCI bus and can be found in laptop Clevo model D4J, product
+	  code D410J. It can be identified by its PCI ID 1050:8481
+	  (for example by using "lspci" and "lspci -n" commands).
+	  The driver currently only detects whether an SD card is
+	  mechanically inserted in the reader (dummy SD card is also
+	  detected). The information can be fetched in Clevo D410J
+	  with the command
+	  "cat /sys/devices/pci0000:00/0000:00:0e.0/card_present".
+
+	  Currently (Jan 2012) there is a lack of register description
+	  of this device.
diff --git a/drivers/staging/wb528sd/Makefile b/drivers/staging/wb528sd/Makefile
new file mode 100644
index 0000000..758026d
--- /dev/null
+++ b/drivers/staging/wb528sd/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_WB528SD) += wb528sd.o
diff --git a/drivers/staging/wb528sd/wb528sd.c b/drivers/staging/wb528sd/wb528sd.c
new file mode 100644
index 0000000..7f6380a
--- /dev/null
+++ b/drivers/staging/wb528sd/wb528sd.c
@@ -0,0 +1,274 @@
+/*
+ * Winbond 528SD Secure Digital (SD) card reader
+ *
+ * # lspci -d 1050:8481 -vv -xx
+ * 00:0e.0 Mass storage controller: Winbond Electronics Corp Device 8481 (rev 01)
+ *         Subsystem: Winbond Electronics Corp Device 1050
+ *         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
+ *         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort+ <TAbort- <MAbort- >SERR- <PERR- INTx-
+ *         Interrupt: pin A routed to IRQ 19
+ *         Region 0: Memory at d0001000 (32-bit, non-prefetchable) [size=4K]
+ *         Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=4K]
+ *         Capabilities: [c0] Power Management version 2
+ *                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=100mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
+ *                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
+ * 00: 50 10 81 84 13 00 90 0a 01 00 80 01 10 42 80 00
+ * 10: 00 10 00 d0 00 00 00 d0 00 00 00 00 00 00 00 00
+ * 20: 00 00 00 00 00 00 00 00 00 00 00 00 50 10 50 10
+ * 30: 00 00 00 00 c0 00 00 00 00 00 00 00 05 01 08 1a
+ *
+ * There are two memory mapped regions: region 0 and region 1.
+ * Region 0 has a 4KiB address window but it contains only 256 bytes
+ * of registers, the same registers repeats every 256 bytes.
+ * Region 1 truly has a 4KiB address window.
+ *
+ * There is one interrupt associated to this device.
+ *
+ * Region 0 registers:
+ * BASE0+0x00: ?
+ * ...
+ * BASE0+0xFF: ?
+ *
+ * Region 1 registers:
+ * BASE1+0x000: ?
+ * ...
+ * BASE1+0x51C: bit7: ?
+ *              bit6: ?
+ *              bit5: ?
+ *              bit4: ?
+ *              bit3: ?
+ *              bit2: ?
+ *              bit1: ?
+ *              bit0: mechanical card persence (dummy card is also detected)
+ *                    0: card not present
+ *                    1: card present
+ * ...
+ * BASE1+0xFFF: ?
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+
+MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
+MODULE_DESCRIPTION("Winbond 528SD Secure Digital (SD) card reader");
+MODULE_LICENSE("GPL");
+
+#define PCI_DEVICE_ID_WINBOND_528SD	0x8481
+
+#define WB528SD_REG_STATUS_51C		0x51C
+#define WB528SD_CARD_PRESENCE_MASK	0x01
+
+#define WB528SD_SIZE_4K		0x1000
+
+struct wb528sd_data {
+	void __iomem *ioaddr0;
+	void __iomem *ioaddr1;
+};
+
+static ssize_t card_present_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct wb528sd_data *data = dev_get_drvdata(dev);
+	unsigned int data51c;
+
+	data51c = ioread8(data->ioaddr1 + WB528SD_REG_STATUS_51C);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+		data51c & WB528SD_CARD_PRESENCE_MASK ? 1 : 0);
+}
+static DEVICE_ATTR(card_present, S_IRUGO, card_present_show, NULL);
+
+static irqreturn_t wb528sd_handler(int irq, void *dev_id)
+{
+#if 0
+	struct pci_dev *dev = dev_id;
+	struct wb528sd_data *data = pci_get_drvdata(dev);
+#endif
+	int ret = IRQ_NONE;
+
+	if (0) {
+		/* TODO: find out how to detect if wb528sd is the source
+		 * of the interrupt. Note that the interrupt might be
+		 * shared with other hardware devices.
+		 */
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
+#if 0
+static void dump_content(char *name, void __iomem *base, unsigned long length)
+{
+	unsigned int i;
+	unsigned int data;
+
+	for (i = 0; i < length; i += 4) {
+		data = ioread32(base + i);
+		printk(KERN_DEBUG "%s+0x%X: 0x%X\n", name, i, data);
+	}
+}
+#endif
+
+static int probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	unsigned long addr0_start, addr0_end, addr0_len, addr0_flags;
+	unsigned long addr1_start, addr1_end, addr1_len, addr1_flags;
+	void __iomem *ioaddr0;
+	void __iomem *ioaddr1;
+	int result;
+	u8 irq;
+	struct wb528sd_data *data = NULL;
+	int ret;
+
+	addr0_start = pci_resource_start(dev, 0);
+	addr0_end = pci_resource_end(dev, 0);
+	addr0_len = pci_resource_len(dev, 0);
+	addr0_flags = pci_resource_flags(dev, 0);
+	printk(KERN_DEBUG "Resource 0: 0x%lX..0x%lX, length=0x%lX, flags=0x%lX\n",
+		addr0_start, addr0_end, addr0_len, addr0_flags);
+
+	addr1_start = pci_resource_start(dev, 1);
+	addr1_end = pci_resource_end(dev, 1);
+	addr1_len = pci_resource_len(dev, 1);
+	addr1_flags = pci_resource_flags(dev, 1);
+	printk(KERN_DEBUG "Resource 1: 0x%lX..0x%lX, length=0x%lX, flags=0x%lX\n",
+		addr1_start, addr1_end, addr1_len, addr1_flags);
+
+	printk(KERN_DEBUG "dev->irq: IRQ #%u\n", dev->irq);
+
+	result = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
+	if (!result)
+		printk(KERN_DEBUG "PCI_INTERRUPT_LINE: IRQ #%u\n", irq);
+	else
+		printk(KERN_DEBUG "Can't read PCI_INTERRUPT_LINE\n");
+
+	if (!(addr0_flags & IORESOURCE_MEM)) {
+		dev_err(&dev->dev, "region #0 not an MMIO resource, aborting\n");
+		return -ENODEV;
+	}
+	if (addr0_len != WB528SD_SIZE_4K) {
+		dev_err(&dev->dev, "Invalid PCI mem region size, aborting\n");
+		return -ENODEV;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&dev->dev, "%s : kzalloc failed", __func__);
+		return -ENOMEM;
+	}
+
+	printk(KERN_DEBUG "pci_enable_device()\n");
+	result = pci_enable_device(dev);
+	if (result) {
+		printk(KERN_DEBUG "Error enabling wb528sd PCI device: %u\n",
+			result);
+		kfree(data);
+		return result;
+	}
+
+	printk(KERN_DEBUG "pci_request_regions()\n");
+	result = pci_request_regions(dev, KBUILD_MODNAME);
+	if (result) {
+		printk(KERN_DEBUG "pci_request_regions failed, error %d\n",
+			result);
+		pci_disable_device(dev);
+		kfree(data);
+		return result;
+	}
+
+	ioaddr0 = pci_iomap(dev, 0, 0);
+	if (!ioaddr0) {
+		printk(KERN_DEBUG "cannot remap MMIO #0\n");
+		pci_release_regions(dev);
+		pci_disable_device(dev);
+		kfree(data);
+		return result;
+	} else {
+		data->ioaddr0 = ioaddr0;
+	}
+
+	ioaddr1 = pci_iomap(dev, 1, 0);
+	if (!ioaddr1) {
+		printk(KERN_DEBUG "cannot remap MMIO #1\n");
+		pci_release_regions(dev);
+		pci_disable_device(dev);
+		kfree(data);
+		return result;
+	} else {
+		data->ioaddr1 = ioaddr1;
+	}
+
+	printk(KERN_DEBUG "request_irq()\n");
+	result = request_irq(dev->irq, wb528sd_handler,
+			     IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (result != 0) {
+		printk(KERN_DEBUG "Error requesting IRQ #%u device: %d\n",
+			dev->irq, result);
+		pci_release_regions(dev);
+		pci_disable_device(dev);
+		kfree(data);
+		return result;
+	}
+
+	/* TODO: enable wb528sd interrupt generation */
+
+	pci_set_drvdata(dev, data);
+
+	ret = device_create_file(&dev->dev, &dev_attr_card_present);
+	if (!ret)
+		;
+
+	printk(KERN_DEBUG "done\n");
+
+	return 0;
+}
+
+static void remove(struct pci_dev *dev)
+{
+	struct wb528sd_data *data = pci_get_drvdata(dev);
+
+	printk(KERN_DEBUG "%s: remove\n", KBUILD_MODNAME);
+
+	device_remove_file(&dev->dev, &dev_attr_card_present);
+	pci_disable_device(dev);
+	pci_release_regions(dev);
+	if (data) {
+		pci_iounmap(dev, data->ioaddr0);
+		pci_iounmap(dev, data->ioaddr1);
+	}
+	free_irq(dev->irq, dev);
+
+}
+
+static DEFINE_PCI_DEVICE_TABLE(wb528sd_ids) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_WINBOND2, PCI_DEVICE_ID_WINBOND_528SD) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, wb528sd_ids);
+
+static struct pci_driver pci_driver = {
+	.name = "wb528sd",
+	.id_table = wb528sd_ids,
+	.probe = probe,
+	.remove = remove,
+};
+
+static int __init wb528sd_init(void)
+{
+	printk(KERN_DEBUG "%s: init\n", KBUILD_MODNAME);
+	return pci_register_driver(&pci_driver);
+}
+
+static void wb528sd_exit(void)
+{
+	printk(KERN_DEBUG "%s: exit\n", KBUILD_MODNAME);
+	pci_unregister_driver(&pci_driver);
+}
+
+module_init(wb528sd_init);
+module_exit(wb528sd_exit);
-- 
1.7.2.5

