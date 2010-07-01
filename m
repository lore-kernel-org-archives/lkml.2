Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0GAFOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:14:46 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:20102 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab0GAFOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:14:44 -0400
Message-ID: <4C2C2423.4060705@dsn.okisemi.com>
Date: Thu, 01 Jul 2010 14:14:11 +0900
From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>, Randy Dunlap <randy.dunlap@oracle.com>
CC: Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       qi.wang@intel.com, joel.clark@intel.com,
       andrew.chih.howe.khor@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Packet hub driver of Topcliff PCH
References: <4C204B0D.2030201@dsn.okisemi.com>
In-Reply-To: <4C204B0D.2030201@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy and Randy

I have modified for your comments.
Please confirm below.

Thanks, Ohtake.

---

Packet hub driver of Topcliff PCH

Topcliff PCH is the platform controller hub that is going to be used in
Intel's upcoming general embedded platform. All IO peripherals in
Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
a special converter device in Topcliff PCH that translate AMBA transactions
to PCI Express transactions and vice versa. Thus packet hub helps present
all IO peripherals in Topcliff PCH as PCIE devices to IA system.
Topcliff PCH have MAC address and Option ROM data.
These data are in SROM which is connected to PCIE bus.
Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
SROM.

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 drivers/char/Kconfig             |    9 +
 drivers/char/Makefile            |    2 +
 drivers/char/pch_phub/Makefile   |    3 +
 drivers/char/pch_phub/pch_phub.c |  805 ++++++++++++++++++++++++++++++++++++++
 drivers/char/pch_phub/pch_phub.h |   48 +++
 5 files changed, 867 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/pch_phub/Makefile
 create mode 100755 drivers/char/pch_phub/pch_phub.c
 create mode 100755 drivers/char/pch_phub/pch_phub.h

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index e023682..9ef3c85 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -4,6 +4,15 @@
 
 menu "Character devices"
 
+config PCH_PHUB
+	tristate "PCH PHUB"
+	depends on PCI
+	help
+	  This driver is for PCH PHUB of Topcliff which is an IOH for x86
+	  embedded processor. The Topcliff has MAC address and Option ROM data
+	  in SROM. This dirver can access MAC address and Option ROM data in
+	  SROM.
+
 config VT
 	bool "Virtual terminal" if EMBEDDED
 	depends on !S390
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f957edf..1e3eb6c 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -111,6 +111,8 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
+obj-$(CONFIG_PCH_PHUB)	+= pch_phub/
+
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
diff --git a/drivers/char/pch_phub/Makefile b/drivers/char/pch_phub/Makefile
new file mode 100644
index 0000000..93aaffe
--- /dev/null
+++ b/drivers/char/pch_phub/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_PCH_PHUB) += pch_phub_drv.o
+
+pch_phub_drv-objs := pch_phub.o
diff --git a/drivers/char/pch_phub/pch_phub.c b/drivers/char/pch_phub/pch_phub.c
new file mode 100755
index 0000000..d443048
--- /dev/null
+++ b/drivers/char/pch_phub/pch_phub.c
@@ -0,0 +1,805 @@
+/*!
+ * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include "pch_phub.h"
+
+#define PHUB_STATUS 0x00		/* Status Register offset */
+#define PHUB_CONTROL 0x04		/* Control Register offset */
+#define PHUB_TIMEOUT 0x05		/* Time out value for Status Register */
+#define PCH_PHUB_ROM_WRITE_ENABLE 0x01	/* Enabling for writing ROM */
+#define PCH_PHUB_ROM_WRITE_DISABLE 0x00	/* Disabling for writing ROM */
+#define PCH_PHUB_ROM_START_ADDR 0x14	/* ROM data area start address offset */
+
+/* MAX number of INT_REDUCE_CONTROL registers */
+#define MAX_NUM_INT_REDUCE_CONTROL_REG 128
+#define PCI_DEVICE_ID_PCH1_PHUB 0x8801
+#define PCH_MINOR_NOS 1
+#define CLKCFG_CAN_50MHZ 0x12000000
+#define CLKCFG_CANCLK_MASK 0xFF000000
+#define MODULE_NAME "pch_phub"
+
+/**
+ * struct pch_phub_reg - PHUB register structure
+ * @phub_id_reg:			PHUB_ID register val
+ * @q_pri_val_reg:			QUEUE_PRI_VAL register val
+ * @rc_q_maxsize_reg:			RC_QUEUE_MAXSIZE register val
+ * @bri_q_maxsize_reg:			BRI_QUEUE_MAXSIZE register val
+ * @comp_resp_timeout_reg:		COMP_RESP_TIMEOUT register val
+ * @bus_slave_control_reg:		BUS_SLAVE_CONTROL_REG register val
+ * @deadlock_avoid_type_reg:		DEADLOCK_AVOID_TYPE register val
+ * @intpin_reg_wpermit_reg0:		INTPIN_REG_WPERMIT register 0 val
+ * @intpin_reg_wpermit_reg1:		INTPIN_REG_WPERMIT register 1 val
+ * @intpin_reg_wpermit_reg2:		INTPIN_REG_WPERMIT register 2 val
+ * @intpin_reg_wpermit_reg3:		INTPIN_REG_WPERMIT register 3 val
+ * @int_reduce_control_reg:		INT_REDUCE_CONTROL registers val
+ * @clkcfg_reg:				CLK CFG register val
+ * @pch_phub_base_address:		Register base address
+ * @pch_phub_extrom_base_address:	external rom base address
+ * @pch_phub_suspended:			PHUB status val
+ */
+struct pch_phub_reg {
+	u32 phub_id_reg;
+	u32 q_pri_val_reg;
+	u32 rc_q_maxsize_reg;
+	u32 bri_q_maxsize_reg;
+	u32 comp_resp_timeout_reg;
+	u32 bus_slave_control_reg;
+	u32 deadlock_avoid_type_reg;
+	u32 intpin_reg_wpermit_reg0;
+	u32 intpin_reg_wpermit_reg1;
+	u32 intpin_reg_wpermit_reg2;
+	u32 intpin_reg_wpermit_reg3;
+	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
+	u32 clkcfg_reg;
+	void __iomem *pch_phub_base_address;
+	void __iomem *pch_phub_extrom_base_address;
+	int pch_phub_suspended;
+} pch_phub_reg;
+
+/* SROM SPEC for MAC address assignment offset */
+static const int pch_phub_mac_offset[6] = {0x3, 0x2, 0x1, 0x0, 0xb, 0xa};
+
+static DEFINE_MUTEX(pch_phub_ioctl_mutex);
+static DEFINE_MUTEX(pch_phub_read_mutex);
+static DEFINE_MUTEX(pch_phub_write_mutex);
+static dev_t pch_phub_dev_no;
+static struct cdev pch_phub_dev;
+
+/**
+ * pch_phub_read_modify_write_reg() - Reading modifying and writing register
+ * @reg_addr_offset:	Register offset address value.
+ * @data:		Writing value.
+ * @mask:		Mask value.
+ */
+static void pch_phub_read_modify_write_reg(unsigned int reg_addr_offset,
+					   unsigned int data, unsigned int mask)
+{
+	void __iomem *reg_addr = pch_phub_reg.pch_phub_base_address +
+					 reg_addr_offset;
+	iowrite32(((ioread32(reg_addr) & ~mask)) | data, reg_addr);
+}
+
+
+/* pch_phub_save_reg_conf - saves register configuration */
+static void pch_phub_save_reg_conf(struct pci_dev *pdev)
+{
+	unsigned int i;
+	void __iomem *p = pch_phub_reg.pch_phub_base_address;
+
+	dev_dbg(&pdev->dev, "pch_phub_save_reg_conf ENTRY\n");
+	pch_phub_reg.phub_id_reg = ioread32(p + PCH_PHUB_ID_REG);
+	pch_phub_reg.q_pri_val_reg = ioread32(p + PCH_PHUB_QUEUE_PRI_VAL_REG);
+	pch_phub_reg.rc_q_maxsize_reg =
+	    ioread32(p + PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
+	pch_phub_reg.bri_q_maxsize_reg =
+	    ioread32(p + PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
+	pch_phub_reg.comp_resp_timeout_reg =
+	    ioread32(p + PCH_PHUB_COMP_RESP_TIMEOUT_REG);
+	pch_phub_reg.bus_slave_control_reg =
+	    ioread32(p + PCH_PHUB_BUS_SLAVE_CONTROL_REG);
+	pch_phub_reg.deadlock_avoid_type_reg =
+	    ioread32(p + PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
+	pch_phub_reg.intpin_reg_wpermit_reg0 =
+	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
+	pch_phub_reg.intpin_reg_wpermit_reg1 =
+	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
+	pch_phub_reg.intpin_reg_wpermit_reg2 =
+	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
+	pch_phub_reg.intpin_reg_wpermit_reg3 =
+	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
+	dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
+		"pch_phub_reg.phub_id_reg=%x, "
+		"pch_phub_reg.q_pri_val_reg=%x, "
+		"pch_phub_reg.rc_q_maxsize_reg=%x, "
+		"pch_phub_reg.bri_q_maxsize_reg=%x, "
+		"pch_phub_reg.comp_resp_timeout_reg=%x, "
+		"pch_phub_reg.bus_slave_control_reg=%x, "
+		"pch_phub_reg.deadlock_avoid_type_reg=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg0=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg1=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg2=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg3=%x\n",
+		pch_phub_reg.phub_id_reg,
+		pch_phub_reg.q_pri_val_reg,
+		pch_phub_reg.rc_q_maxsize_reg,
+		pch_phub_reg.bri_q_maxsize_reg,
+		pch_phub_reg.comp_resp_timeout_reg,
+		pch_phub_reg.bus_slave_control_reg,
+		pch_phub_reg.deadlock_avoid_type_reg,
+		pch_phub_reg.intpin_reg_wpermit_reg0,
+		pch_phub_reg.intpin_reg_wpermit_reg1,
+		pch_phub_reg.intpin_reg_wpermit_reg2,
+		pch_phub_reg.intpin_reg_wpermit_reg3);
+	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
+		pch_phub_reg.int_reduce_control_reg[i] =
+		    ioread32(p + PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
+		dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
+			"pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
+			i, pch_phub_reg.int_reduce_control_reg[i]);
+	}
+	pch_phub_reg.clkcfg_reg = ioread32(p + CLKCFG_REG_OFFSET);
+
+}
+
+/* pch_phub_restore_reg_conf - restore register configuration */
+static void pch_phub_restore_reg_conf(struct pci_dev *pdev)
+{
+	unsigned int i;
+	void __iomem *p = pch_phub_reg.pch_phub_base_address;
+
+	dev_dbg(&pdev->dev, "pch_phub_restore_reg_conf ENTRY\n");
+	iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_ID_REG);
+	iowrite32(pch_phub_reg.q_pri_val_reg, p + PCH_PHUB_QUEUE_PRI_VAL_REG);
+	iowrite32(pch_phub_reg.rc_q_maxsize_reg,
+					p + PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
+	iowrite32(pch_phub_reg.bri_q_maxsize_reg,
+					p + PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
+	iowrite32(pch_phub_reg.comp_resp_timeout_reg,
+					p + PCH_PHUB_COMP_RESP_TIMEOUT_REG);
+	iowrite32(pch_phub_reg.bus_slave_control_reg,
+					p + PCH_PHUB_BUS_SLAVE_CONTROL_REG);
+	iowrite32(pch_phub_reg.deadlock_avoid_type_reg,
+					p + PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
+	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg0,
+					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
+	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg1,
+					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
+	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg2,
+					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
+	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg3,
+					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
+	dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
+		"pch_phub_reg.phub_id_reg=%x, "
+		"pch_phub_reg.q_pri_val_reg=%x, "
+		"pch_phub_reg.rc_q_maxsize_reg=%x, "
+		"pch_phub_reg.bri_q_maxsize_reg=%x, "
+		"pch_phub_reg.comp_resp_timeout_reg=%x, "
+		"pch_phub_reg.bus_slave_control_reg=%x, "
+		"pch_phub_reg.deadlock_avoid_type_reg=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg0=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg1=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg2=%x, "
+		"pch_phub_reg.intpin_reg_wpermit_reg3=%x\n",
+		pch_phub_reg.phub_id_reg,
+		pch_phub_reg.q_pri_val_reg,
+		pch_phub_reg.rc_q_maxsize_reg,
+		pch_phub_reg.bri_q_maxsize_reg,
+		pch_phub_reg.comp_resp_timeout_reg,
+		pch_phub_reg.bus_slave_control_reg,
+		pch_phub_reg.deadlock_avoid_type_reg,
+		pch_phub_reg.intpin_reg_wpermit_reg0,
+		pch_phub_reg.intpin_reg_wpermit_reg1,
+		pch_phub_reg.intpin_reg_wpermit_reg2,
+		pch_phub_reg.intpin_reg_wpermit_reg3);
+	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
+		iowrite32(pch_phub_reg.int_reduce_control_reg[i],
+			p + PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
+		dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
+			"pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
+			i, pch_phub_reg.int_reduce_control_reg[i]);
+	}
+
+	iowrite32(pch_phub_reg.clkcfg_reg, p + CLKCFG_REG_OFFSET);
+}
+
+/**
+ * pch_phub_read_serial_rom() - Reading Serial ROM
+ * @offset_address:	Serial ROM offset address to read.
+ * @data:		Read buffer for specified Serial ROM value.
+ */
+static void pch_phub_read_serial_rom(unsigned int offset_address, u8 *data)
+{
+	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +
+					 offset_address;
+
+	*data = ioread8(mem_addr);
+}
+
+/**
+ * pch_phub_write_serial_rom() - Writing Serial ROM
+ * @offset_address:	Serial ROM offset address.
+ * @data:		Serial ROM value to write.
+ */
+static int pch_phub_write_serial_rom(unsigned int offset_address, u8 data)
+{
+	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +
+					(offset_address & PCH_WORD_ADDR_MASK);
+	int i;
+	unsigned int word_data;
+	unsigned int pos;
+	unsigned int mask;
+	pos = (offset_address % 4) * 8;
+	mask = ~(0xFF << pos);
+
+	iowrite32(PCH_PHUB_ROM_WRITE_ENABLE,
+			pch_phub_reg.pch_phub_extrom_base_address +
+			PHUB_CONTROL);
+
+	word_data = ioread32(mem_addr);
+	iowrite32((word_data & mask) | (u32)data << pos, mem_addr);
+
+	i = 0;
+	while (0x00 != ioread8(pch_phub_reg.pch_phub_extrom_base_address +
+			PHUB_STATUS)) {
+		msleep(1);
+		if (PHUB_TIMEOUT == i)
+			return -EPERM;
+		i++;
+	}
+
+	iowrite32(PCH_PHUB_ROM_WRITE_DISABLE,
+			pch_phub_reg.pch_phub_extrom_base_address +
+			PHUB_CONTROL);
+
+	return 0;
+}
+
+/**
+ * pch_phub_read_serial_rom_val() - Read Serial ROM value
+ * @offset_address:	Serial ROM address offset value.
+ * @data:		Serial ROM value to read.
+ */
+static void pch_phub_read_serial_rom_val(unsigned int offset_address, u8 *data)
+{
+	unsigned int mem_addr;
+
+	mem_addr = PCH_PHUB_ROM_START_ADDR +
+			pch_phub_mac_offset[offset_address];
+
+	pch_phub_read_serial_rom(mem_addr, data);
+
+}
+
+
+/**
+ * pch_phub_write_serial_rom_val() - writing Serial ROM value
+ * @offset_address:	Serial ROM address offset value.
+ * @data:		Serial ROM value.
+ */
+static int pch_phub_write_serial_rom_val(unsigned int offset_address, u8 data)
+{
+	int retval;
+	unsigned int mem_addr;
+
+	mem_addr = PCH_PHUB_ROM_START_ADDR +
+			pch_phub_mac_offset[offset_address];
+
+	retval = pch_phub_write_serial_rom(mem_addr, data);
+
+	return retval;
+}
+
+/* pch_phub_gbe_serial_rom_conf - makes Serial ROM header format configuration
+ * for Gigabit Ethernet MAC address
+ */
+static int pch_phub_gbe_serial_rom_conf(void)
+{
+	int retval;
+
+	retval = pch_phub_write_serial_rom(0x0b, 0xbc);
+	retval |= pch_phub_write_serial_rom(0x0a, 0x10);
+	retval |= pch_phub_write_serial_rom(0x09, 0x01);
+	retval |= pch_phub_write_serial_rom(0x08, 0x02);
+
+	retval |= pch_phub_write_serial_rom(0x0f, 0x00);
+	retval |= pch_phub_write_serial_rom(0x0e, 0x00);
+	retval |= pch_phub_write_serial_rom(0x0d, 0x00);
+	retval |= pch_phub_write_serial_rom(0x0c, 0x80);
+
+	retval |= pch_phub_write_serial_rom(0x13, 0xbc);
+	retval |= pch_phub_write_serial_rom(0x12, 0x10);
+	retval |= pch_phub_write_serial_rom(0x11, 0x01);
+	retval |= pch_phub_write_serial_rom(0x10, 0x18);
+
+	retval |= pch_phub_write_serial_rom(0x1b, 0xbc);
+	retval |= pch_phub_write_serial_rom(0x1a, 0x10);
+	retval |= pch_phub_write_serial_rom(0x19, 0x01);
+	retval |= pch_phub_write_serial_rom(0x18, 0x19);
+
+	retval |= pch_phub_write_serial_rom(0x23, 0xbc);
+	retval |= pch_phub_write_serial_rom(0x22, 0x10);
+	retval |= pch_phub_write_serial_rom(0x21, 0x01);
+	retval |= pch_phub_write_serial_rom(0x20, 0x3a);
+
+	retval |= pch_phub_write_serial_rom(0x27, 0x01);
+	retval |= pch_phub_write_serial_rom(0x26, 0x00);
+	retval |= pch_phub_write_serial_rom(0x25, 0x00);
+	retval |= pch_phub_write_serial_rom(0x24, 0x00);
+
+	return retval;
+}
+
+/**
+ * pch_phub_read_gbe_mac_addr() - Read Gigabit Ethernet MAC address
+ * @offset_address:	Gigabit Ethernet MAC address offset value.
+ * @data:		Buffer of the Gigabit Ethernet MAC address value.
+ */
+static void pch_phub_read_gbe_mac_addr(unsigned int offset_address, u8 *data)
+{
+	pch_phub_read_serial_rom_val(offset_address, data);
+}
+
+/**
+ * pch_phub_write_gbe_mac_addr() - Write MAC address
+ * @offset_address:	Gigabit Ethernet MAC address offset value.
+ * @data:		Gigabit Ethernet MAC address value.
+ */
+static int pch_phub_write_gbe_mac_addr(unsigned int offset_address,
+				   u8 data)
+{
+	int retval;
+
+	retval = pch_phub_gbe_serial_rom_conf();
+	retval |= pch_phub_write_serial_rom_val(offset_address, data);
+
+	return retval;
+}
+
+static ssize_t pch_phub_read(struct file *file, char __user *buf, size_t size,
+			     loff_t *ppos)
+{
+	unsigned int rom_signature;
+	unsigned char rom_length;
+	int ret_value;
+	unsigned int tmp;
+	unsigned char data;
+	unsigned int addr_offset;
+	unsigned int orom_size;
+	int ret;
+	int err;
+	loff_t pos = *ppos;
+
+	ret = mutex_lock_interruptible(&pch_phub_read_mutex);
+	if (ret) {
+		err = -ERESTARTSYS;
+		goto return_err_nomutex;
+	}
+
+	/* Get Rom signature */
+	pch_phub_read_serial_rom(0x80, (unsigned char *)&rom_signature);
+	rom_signature &= 0xff;
+	pch_phub_read_serial_rom(0x81, (unsigned char *)&tmp);
+	rom_signature |= (tmp & 0xff) << 8;
+	if (rom_signature == 0xAA55) {
+		pch_phub_read_serial_rom(0x82, &rom_length);
+		orom_size = rom_length * 512;
+		if (orom_size < pos) {
+			addr_offset = 0;
+			goto return_ok;
+		}
+
+		for (addr_offset = 0; addr_offset < size; addr_offset++) {
+			pch_phub_read_serial_rom(0x80 + addr_offset + pos,
+									 &data);
+			ret_value = copy_to_user(&buf[addr_offset], &data, 1);
+			if (ret_value) {
+				err = -EFAULT;
+				goto return_err;
+			}
+
+			if (orom_size < pos + addr_offset) {
+				*ppos += addr_offset;
+				goto return_ok;
+			}
+
+		}
+	} else {
+		return -ENODATA;
+	}
+	*ppos += addr_offset;
+return_ok:
+	mutex_unlock(&pch_phub_read_mutex);
+	return addr_offset;
+
+return_err:
+	mutex_unlock(&pch_phub_read_mutex);
+return_err_nomutex:
+	return err;
+}
+
+
+static ssize_t pch_phub_write(struct file *file, const char __user *buf,
+			      size_t size, loff_t *ppos)
+{
+	unsigned int data;
+	int ret_value1;
+	int ret_value2;
+	int err;
+	unsigned int addr_offset;
+	loff_t pos = *ppos;
+	int ret;
+
+	ret = mutex_lock_interruptible(&pch_phub_write_mutex);
+	if (ret) {
+		err = -ERESTARTSYS;
+		goto return_err_nomutex;
+	}
+
+	for (addr_offset = 0; addr_offset < size; addr_offset++) {
+		ret_value1 = get_user(data, &buf[addr_offset]);
+		if (ret_value1) {
+			err = -EFAULT;
+			goto return_err;
+		}
+
+		ret_value2 = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
+							data);
+		if (ret_value2) {
+			err = ret_value2;
+			goto return_err;
+		}
+
+		if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
+			*ppos += addr_offset;
+			goto return_ok;
+		}
+
+	}
+
+	*ppos += addr_offset;
+
+return_ok:
+	mutex_unlock(&pch_phub_write_mutex);
+	return addr_offset;
+
+return_err:
+	mutex_unlock(&pch_phub_write_mutex);
+return_err_nomutex:
+	return err;
+}
+
+
+static long pch_phub_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	int ret_value;
+	__u8 mac_addr[6];
+	int ret;
+	unsigned int i;
+	void __user *varg = (void __user *)arg;
+
+	ret = mutex_lock_interruptible(&pch_phub_ioctl_mutex);
+	if (ret) {
+		ret_value = -ERESTARTSYS;
+		goto return_nomutex;
+	}
+
+	if (pch_phub_reg.pch_phub_suspended == true) {
+		ret_value = -EBUSY;
+		goto return_ioctrl;
+	}
+
+	switch (cmd) {
+	case IOCTL_PHUB_READ_MAC_ADDR:
+		for (i = 0; i < 6; i++)
+			pch_phub_read_gbe_mac_addr(i, &mac_addr[i]);
+
+		ret_value = copy_to_user(varg,
+					 mac_addr, sizeof(mac_addr));
+		if (ret_value)
+			ret_value = -EFAULT;
+
+		break;
+
+	case IOCTL_PHUB_WRITE_MAC_ADDR:
+		ret_value = copy_from_user(mac_addr, varg, sizeof(mac_addr));
+
+		if (ret_value)
+			ret_value = -EFAULT;
+
+		for (i = 0; i < 6; i++)
+			pch_phub_write_gbe_mac_addr(i, mac_addr[i]);
+		break;
+
+	default:
+		ret_value = -EINVAL;
+		break;
+	}
+return_ioctrl:
+	mutex_unlock(&pch_phub_ioctl_mutex);
+return_nomutex:
+	return ret_value;
+}
+
+
+/* file_operations structure initialization */
+static const struct file_operations pch_phub_fops = {
+	.owner = THIS_MODULE,
+	.read = pch_phub_read,
+	.write = pch_phub_write,
+	.unlocked_ioctl = pch_phub_ioctl,
+	.llseek = default_llseek
+};
+
+
+static int __devinit pch_phub_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
+{
+	int ret;
+	unsigned int rom_size;
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_dbg(&pdev->dev,
+				"\npch_phub_probe : pci_enable_device FAILED");
+		goto err_pci_enable_dev;
+	}
+	dev_dbg(&pdev->dev, "pch_phub_probe : "
+			"pci_enable_device returns %d\n", ret);
+
+	ret = pci_request_regions(pdev, MODULE_NAME);
+	if (ret) {
+		dev_dbg(&pdev->dev,
+				"pch_phub_probe : pci_request_regions FAILED");
+		goto err_req_regions;
+	}
+	dev_dbg(&pdev->dev, "pch_phub_probe : "
+		"pci_request_regions returns %d\n", ret);
+
+	pch_phub_reg.pch_phub_base_address = pci_iomap(pdev, 1, 0);
+
+	if (pch_phub_reg.pch_phub_base_address == 0) {
+		dev_dbg(&pdev->dev, "pch_phub_probe : pci_iomap FAILED");
+		ret = -ENOMEM;
+		goto err_pci_iomap;
+	}
+	dev_dbg(&pdev->dev, "pch_phub_probe : pci_iomap SUCCESS and value "
+		"in pch_phub_base_address variable is 0x%08x\n",
+		(unsigned int)pch_phub_reg.pch_phub_base_address);
+
+	pch_phub_reg.pch_phub_extrom_base_address =
+						pci_map_rom(pdev, &rom_size);
+	if (pch_phub_reg.pch_phub_extrom_base_address == 0) {
+		dev_dbg(&pdev->dev, "pch_phub_probe : pci_map_rom FAILED");
+		ret = -ENOMEM;
+		goto err_pci_map;
+	}
+	dev_dbg(&pdev->dev, "pch_phub_probe : "
+		"pci_map_rom SUCCESS and value in "
+		"pch_phub_extrom_base_address variable is 0x%08x\n",
+		(unsigned int)pch_phub_reg.pch_phub_extrom_base_address);
+
+	ret = alloc_chrdev_region(&pch_phub_dev_no, 0,
+					PCH_MINOR_NOS, MODULE_NAME);
+	if (ret) {
+		dev_dbg(&pdev->dev, "pch_phub_probe : "
+				"alloc_chrdev_region FAILED");
+
+		goto err_alloc_cdev;
+	}
+	dev_dbg(&pdev->dev, "pch_phub_probe : "
+		"alloc_chrdev_region returns %d\n", ret);
+
+	cdev_init(&pch_phub_dev, &pch_phub_fops);
+	dev_dbg(&pdev->dev,
+			"pch_phub_probe :  cdev_init invoked successfully\n");
+
+	pch_phub_dev.owner = THIS_MODULE;
+	pch_phub_dev.ops = &pch_phub_fops;
+
+	ret = cdev_add(&pch_phub_dev, pch_phub_dev_no, PCH_MINOR_NOS);
+	if (ret) {
+		dev_dbg(&pdev->dev, "pch_phub_probe :  cdev_add FAILED");
+		goto err_cdev_add;
+	}
+	dev_dbg(&pdev->dev, "pch_phub_probe :  cdev_add returns %d\n", ret);
+
+	/* set the clock config reg if CAN clock is 50Mhz */
+	dev_dbg(&pdev->dev, "pch_phub_probe : invoking "
+		"pch_phub_read_modify_write_reg "
+		"to set CLKCFG reg for CAN clk 50Mhz\n");
+	pch_phub_read_modify_write_reg((unsigned int)CLKCFG_REG_OFFSET,
+					  CLKCFG_CAN_50MHZ, CLKCFG_CANCLK_MASK);
+
+	/* set the prefech value */
+	iowrite32(0x000ffffa, pch_phub_reg.pch_phub_base_address + 0x14);
+	/* set the interrupt delay value */
+	iowrite32(0x25, pch_phub_reg.pch_phub_base_address + 0x44);
+	return 0;
+
+err_cdev_add:
+	unregister_chrdev_region(pch_phub_dev_no, PCH_MINOR_NOS);
+err_alloc_cdev:
+	pci_unmap_rom(pdev, pch_phub_reg.pch_phub_extrom_base_address);
+err_pci_map:
+	pci_iounmap(pdev, pch_phub_reg.pch_phub_base_address);
+err_pci_iomap:
+	pci_release_regions(pdev);
+err_req_regions:
+	pci_disable_device(pdev);
+err_pci_enable_dev:
+	dev_dbg(&pdev->dev, "pch_phub_probe returns %d\n", ret);
+	return ret;
+}
+
+static void __devexit pch_phub_remove(struct pci_dev *pdev)
+{
+
+	cdev_del(&pch_phub_dev);
+	dev_dbg(&pdev->dev,
+			"pch_phub_remove - cdev_del Invoked successfully\n");
+
+	unregister_chrdev_region(pch_phub_dev_no, PCH_MINOR_NOS);
+	dev_dbg(&pdev->dev, "pch_phub_remove - "
+		"unregister_chrdev_region Invoked successfully\n");
+
+	pci_unmap_rom(pdev, pch_phub_reg.pch_phub_extrom_base_address);
+
+	pci_iounmap(pdev, pch_phub_reg.pch_phub_base_address);
+
+	dev_dbg(&pdev->dev, "pch_phub_remove - "
+			"pci_iounmap Invoked successfully\n");
+
+	pci_release_regions(pdev);
+	dev_dbg(&pdev->dev, "pch_phub_remove - "
+		"pci_release_regions Invoked successfully\n");
+
+	pci_disable_device(pdev);
+	dev_dbg(&pdev->dev, "pch_phub_remove - "
+		"pci_disable_device Invoked successfully\n");
+
+}
+
+#ifdef CONFIG_PM
+
+static int pch_phub_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int ret;
+
+	pch_phub_reg.pch_phub_suspended = true;/* For blocking further IOCTLs */
+
+	pch_phub_save_reg_conf(pdev);
+	dev_dbg(&pdev->dev, "pch_phub_suspend - "
+		"pch_phub_save_reg_conf Invoked successfully\n");
+
+	ret = pci_save_state(pdev);
+	if (ret) {
+		dev_dbg(&pdev->dev,
+			" pch_phub_suspend -pci_save_state returns-%d\n", ret);
+		return ret;
+	}
+	dev_dbg(&pdev->dev,
+			"pch_phub_suspend - pci_save_state returns %d\n", ret);
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	dev_dbg(&pdev->dev, "pch_phub_suspend - "
+			"pci_enable_wake Invoked successfully\n");
+
+	pci_disable_device(pdev);
+	dev_dbg(&pdev->dev, "pch_phub_suspend - "
+			"pci_disable_device Invoked successfully\n");
+
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	dev_dbg(&pdev->dev, "pch_phub_suspend - "
+			"pci_set_power_state Invoked successfully   "
+			"return = %d\n", 0);
+
+	return 0;
+}
+
+static int pch_phub_resume(struct pci_dev *pdev)
+{
+
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	dev_dbg(&pdev->dev, "pch_phub_resume - "
+		"pci_set_power_state Invoked successfully\n");
+
+	pci_restore_state(pdev);
+	dev_dbg(&pdev->dev, "pch_phub_resume - "
+		"pci_restore_state Invoked successfully\n");
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_dbg(&pdev->dev,
+				"pch_phub_resume-pci_enable_device failed ");
+		return ret;
+	}
+
+	dev_dbg(&pdev->dev, "pch_phub_resume - "
+			"pci_enable_device returns -%d\n", ret);
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	dev_dbg(&pdev->dev, "pch_phub_resume - "
+			"pci_enable_wake Invoked successfully\n");
+
+	pch_phub_restore_reg_conf(pdev);
+	dev_dbg(&pdev->dev, "pch_phub_resume - "
+		"pch_phub_restore_reg_conf Invoked successfully\n");
+
+	pch_phub_reg.pch_phub_suspended = false;
+
+	dev_dbg(&pdev->dev, "pch_phub_resume  returns- %d\n", 0);
+	return 0;
+}
+#else
+#define pch_phub_suspend NULL
+#define pch_phub_resume NULL
+#endif /* CONFIG_PM */
+
+static struct pci_device_id pch_phub_pcidev_id[] = {
+
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH1_PHUB)},
+	{0,}
+};
+
+
+static struct pci_driver pch_phub_driver = {
+	.name = "pch_phub",
+	.id_table = pch_phub_pcidev_id,
+	.probe = pch_phub_probe,
+	.remove = __devexit_p(pch_phub_remove),
+	.suspend = pch_phub_suspend,
+	.resume = pch_phub_resume
+};
+
+/* pch_phub_pci_init - Implements the initialization functionality of
+ * the module.
+ */
+static int __init pch_phub_pci_init(void)
+{
+	int ret;
+	ret = pci_register_driver(&pch_phub_driver);
+
+	return ret;
+}
+
+/* pch_phub_pci_exit - Implements the exit functionality of the module. */
+static void __exit pch_phub_pci_exit(void)
+{
+	pci_unregister_driver(&pch_phub_driver);
+
+}
+
+module_init(pch_phub_pci_init);
+module_exit(pch_phub_pci_exit);
+
+MODULE_DESCRIPTION("PCH PACKET HUB PCI Driver");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/char/pch_phub/pch_phub.h b/drivers/char/pch_phub/pch_phub.h
new file mode 100755
index 0000000..7baa272
--- /dev/null
+++ b/drivers/char/pch_phub/pch_phub.h
@@ -0,0 +1,48 @@
+#ifndef __PCH_PHUB_H__
+#define __PCH_PHUB_H__
+/*!
+ * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#define PHUB_IOCTL_MAGIC		(0xf7)
+
+/* Read GbE MAC address */
+#define IOCTL_PHUB_READ_MAC_ADDR (_IOR(PHUB_IOCTL_MAGIC, 6, __u8[6]))
+
+/* Write GbE MAC address */
+#define IOCTL_PHUB_WRITE_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 7, __u8[6]))
+
+/* SROM ACCESS Macro */
+#define PCH_WORD_ADDR_MASK (~((1 << 2) - 1))
+
+/* Registers address offset */
+#define PCH_PHUB_ID_REG				0x0000
+#define PCH_PHUB_QUEUE_PRI_VAL_REG		0x0004
+#define PCH_PHUB_RC_QUEUE_MAXSIZE_REG		0x0008
+#define PCH_PHUB_BRI_QUEUE_MAXSIZE_REG		0x000C
+#define PCH_PHUB_COMP_RESP_TIMEOUT_REG		0x0010
+#define PCH_PHUB_BUS_SLAVE_CONTROL_REG		0x0014
+#define PCH_PHUB_DEADLOCK_AVOID_TYPE_REG	0x0018
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG0	0x0020
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG1	0x0024
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG2	0x0028
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG3	0x002C
+#define PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE	0x0040
+#define CLKCFG_REG_OFFSET			0x500
+
+#define PCH_PHUB_OROM_SIZE 15360
+
+#endif
-- 
1.6.0.6
