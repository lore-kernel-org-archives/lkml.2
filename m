Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0FGMjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:39:53 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47076 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab0FGMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:46 -0400
Message-ID: <4C0CE88C.9050708@dsn.okisemi.com>
Date: Mon, 07 Jun 2010 21:39:40 +0900
From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Intel OTC <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: [PATCH] Topcliff PHUB: Generate PacketHub driver
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

We have modified for the following your indication.
Please confirm.

> > +/*!

> > + * @ingroup	PHUB_PCILayerAPI

> > + * @fn		static void __exit pch_phub_pci_exit(void)

> > + * @brief	Provides the functionality of exiting the module

> > + * */



> Can we please do something about all this stuff first so the code is

> easier to review by those not familiar with the kernel format.



> I sent a bit of code out last time that did most of the work



> Alan


Thanks.
Masayuki Ohtake

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
---
 linux-2.6.33.1/drivers/char/Kconfig             |   20 +
 linux-2.6.33.1/drivers/char/Makefile            |    4 +
 linux-2.6.33.1/drivers/char/pch_phub/Makefile   |   11 +
 linux-2.6.33.1/drivers/char/pch_phub/pch_phub.c | 1232 +++++++++++++++++++++++
 linux-2.6.33.1/drivers/char/pch_phub/pch_phub.h |   96 ++
 5 files changed, 1363 insertions(+), 0 deletions(-)
 create mode 100644 linux-2.6.33.1/drivers/char/pch_phub/Makefile
 create mode 100755 linux-2.6.33.1/drivers/char/pch_phub/pch_phub.c
 create mode 100755 linux-2.6.33.1/drivers/char/pch_phub/pch_phub.h

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index e023682..16a8334 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -4,6 +4,26 @@
 
 menu "Character devices"
 
+config PCH_IEEE1588
+	tristate "PCH IEEE1588"
+	depends on PCI
+	help
+	  If you say yes to this option, support will be included for the
+	  PCH IEEE1588 Host controller.
+
+config PCH_PHUB
+        tristate "PCH PHUB"
+        depends on PCI
+        help
+          If you say yes to this option, support will be included for the
+          PCH Packet Hub Host controller.
+
+config PCH_CAN_PCLK_50MHZ
+	bool "CAN PCLK 50MHz"
+	depends on PCH_PHUB
+        help
+          If you say yes to this option, clock is set to 50MHz.(For CAN control)
+
 config VT
 	bool "Virtual terminal" if EMBEDDED
 	depends on !S390
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f957edf..dc092d0 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -111,6 +111,10 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
+obj-$(CONFIG_PCH_IEEE1588)		+= pch_ieee1588/
+
+obj-$(CONFIG_PCH_PHUB)	+= pch_phub/
+
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
diff --git a/drivers/char/pch_phub/Makefile b/drivers/char/pch_phub/Makefile
new file mode 100644
index 0000000..bfe2a2b
--- /dev/null
+++ b/drivers/char/pch_phub/Makefile
@@ -0,0 +1,11 @@
+ifeq ($(CONFIG_PHUB_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+obj-$(CONFIG_PCH_PHUB) += pch_phub_drv.o
+#to set CAN clock to 50Mhz
+ifdef CONFIG_PCH_CAN_PCLK_50MHZ
+EXTRA_CFLAGS +=-DPCH_CAN_PCLK_50MHZ
+endif
+
+pch_phub_drv-objs := pch_phub.o
diff --git a/drivers/char/pch_phub/pch_phub.c b/drivers/char/pch_phub/pch_phub.c
new file mode 100755
index 0000000..da5b92e
--- /dev/null
+++ b/drivers/char/pch_phub/pch_phub.c
@@ -0,0 +1,1232 @@
+/*!
+ * @file pch_phub.c
+ * @brief Provides all the implementation of the interfaces pertaining to
+ *		the Packet Hub module.
+ * @version 1.0.0.0
+ * @section
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
+/*
+ * History:
+ * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 04/14/2010
+ * modified:
+ *
+ */
+
+/* includes */
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
+
+#include "pch_phub.h"
+
+/*--------------------------------------------
+	macros
+--------------------------------------------*/
+/* Status Register offset */
+#define PHUB_STATUS (0x00)
+/* Control Register offset */
+#define PHUB_CONTROL (0x04)
+/* Time out value for Status Register */
+#define PHUB_TIMEOUT (0x05)
+/* Enabling for writing ROM */
+#define PCH_PHUB_ROM_WRITE_ENABLE (0x01)
+/* Disabling for writing ROM */
+#define PCH_PHUB_ROM_WRITE_DISABLE (0x00)
+/* ROM data area start address offset */
+#define PCH_PHUB_ROM_START_ADDR (0x14)
+/* MAX number of INT_REDUCE_CONTROL registers */
+#define MAX_NUM_INT_REDUCE_CONTROL_REG (128)
+
+#define PCI_DEVICE_ID_PCH1_PHUB (0x8801)
+
+#define PCH_MINOR_NOS (1)
+#define CLKCFG_CAN_50MHZ (0x12000000)
+#define CLKCFG_CANCLK_MASK (0xFF000000)
+
+#define MODULE_NAME "pch_phub"
+
+#define PCH_READ_REG(a)	ioread32((pch_phub_base_address + a))
+
+#define PCH_WRITE_REG(a, b)	iowrite32(a, (pch_phub_base_address + b))
+
+/*--------------------------------------------
+	global variables
+--------------------------------------------*/
+struct pch_phub_reg {
+	u32 phub_id_reg;		/* PHUB_ID register val */
+	u32 q_pri_val_reg;		/* QUEUE_PRI_VAL register val */
+	u32 rc_q_maxsize_reg;	/* RC_QUEUE_MAXSIZE register val */
+	u32 bri_q_maxsize_reg;	/* BRI_QUEUE_MAXSIZE register val */
+	u32 comp_resp_timeout_reg;	/* COMP_RESP_TIMEOUT register val */
+	u32 bus_slave_control_reg;	/* BUS_SLAVE_CONTROL_REG register val */
+	u32 deadlock_avoid_type_reg; /* DEADLOCK_AVOID_TYPE register val */
+	u32 intpin_reg_wpermit_reg0; /* INTPIN_REG_WPERMIT register 0 val */
+	u32 intpin_reg_wpermit_reg1; /* INTPIN_REG_WPERMIT register 1 val */
+	u32 intpin_reg_wpermit_reg2; /* INTPIN_REG_WPERMIT register 2 val */
+	u32 intpin_reg_wpermit_reg3; /* INTPIN_REG_WPERMIT register 3 val */
+	/* INT_REDUCE_CONTROL registers val */
+	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
+#ifdef PCH_CAN_PCLK_50MHZ
+	u32 clkcfg_reg;		/* CLK CFG register val */
+#endif
+} g_pch_phub_reg;
+
+s32 pch_phub_opencount;	/* check whether opened or not */
+u32 pch_phub_base_address;
+u32 pch_phub_extrom_base_address;
+s32 pch_phub_suspended;
+
+struct device *dev_dbg;
+
+DEFINE_SPINLOCK(pch_phub_lock);	/* for spin lock */
+
+/**
+ * file_operations structure initialization
+ */
+const struct file_operations pch_phub_fops = {
+	.owner = THIS_MODULE,
+	.open = pch_phub_open,
+	.release = pch_phub_release,
+	.ioctl = pch_phub_ioctl,
+};
+
+/* ToDo: major number allocation via module parameter */
+static dev_t pch_phub_dev_no;
+static int pch_phub_major_no;
+static struct cdev pch_phub_dev;
+
+
+/*--------------------------------------------
+	exported function prototypes
+--------------------------------------------*/
+static int __devinit pch_phub_probe(struct pci_dev *pdev, const
+				       struct pci_device_id *id);
+static void __devexit pch_phub_remove(struct pci_dev *pdev);
+static int pch_phub_suspend(struct pci_dev *pdev, pm_message_t state);
+static int pch_phub_resume(struct pci_dev *pdev);
+
+/*--------------------------------------------
+	structures
+--------------------------------------------*/
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
+#ifdef CONFIG_PM
+	.suspend = pch_phub_suspend,
+	.resume = pch_phub_resume
+#endif
+};
+
+static int __init pch_phub_pci_init(void);
+static void __exit pch_phub_pci_exit(void);
+
+MODULE_DESCRIPTION("PCH PACKET HUB PCI Driver");
+MODULE_LICENSE("GPL");
+module_init(pch_phub_pci_init);
+module_exit(pch_phub_pci_exit);
+module_param(pch_phub_major_no, int, S_IRUSR | S_IWUSR);
+
+
+/*--------------------------------------------
+	functions implementations
+--------------------------------------------*/
+/** pch_phub_read_modify_write_reg - Implements the functionality of reading,
+ * 						modifying and writing register.
+ *  @reg_addr_offset:  Contains the register offset address value
+ *  @data:             Contains the writing value
+ *  @mask:             Contains the mask value
+ */
+void pch_phub_read_modify_write_reg(unsigned long reg_addr_offset,
+				       unsigned long data, unsigned long mask)
+{
+	unsigned long reg_addr = pch_phub_base_address + reg_addr_offset;
+	iowrite32(((ioread32((void __iomem *)reg_addr) & ~mask)) | data,
+			(void __iomem *)reg_addr);
+	return;
+}
+
+
+/** pch_phub_save_reg_conf - saves register configuration
+ */
+void pch_phub_save_reg_conf(void)
+{
+	u32 i = 0;
+
+	dev_dbg(dev_dbg, "pch_phub_save_reg_conf ENTRY\n");
+	/* to store contents of PHUB_ID register */
+	g_pch_phub_reg.phub_id_reg = PCH_READ_REG(PCH_PHUB_PHUB_ID_REG);
+	/* to store contents of QUEUE_PRI_VAL register */
+	g_pch_phub_reg.q_pri_val_reg = PCH_READ_REG(PCH_PHUB_QUEUE_PRI_VAL_REG);
+	/* to store contents of RC_QUEUE_MAXSIZE register */
+	g_pch_phub_reg.rc_q_maxsize_reg =
+	    PCH_READ_REG(PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
+	/* to store contents of BRI_QUEUE_MAXSIZE register */
+	g_pch_phub_reg.bri_q_maxsize_reg =
+	    PCH_READ_REG(PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
+	/* to store contents of COMP_RESP_TIMEOUT register */
+	g_pch_phub_reg.comp_resp_timeout_reg =
+	    PCH_READ_REG(PCH_PHUB_COMP_RESP_TIMEOUT_REG);
+	/* to store contents of BUS_SLAVE_CONTROL_REG register */
+	g_pch_phub_reg.bus_slave_control_reg =
+	    PCH_READ_REG(PCH_PHUB_BUS_SLAVE_CONTROL_REG);
+	/* to store contents of DEADLOCK_AVOID_TYPE register */
+	g_pch_phub_reg.deadlock_avoid_type_reg =
+	    PCH_READ_REG(PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
+	/* to store contents of INTPIN_REG_WPERMIT register 0 */
+	g_pch_phub_reg.intpin_reg_wpermit_reg0 =
+	    PCH_READ_REG(PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
+	/* to store contents of INTPIN_REG_WPERMIT register 1 */
+	g_pch_phub_reg.intpin_reg_wpermit_reg1 =
+	    PCH_READ_REG(PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
+	/* to store contents of INTPIN_REG_WPERMIT register 2 */
+	g_pch_phub_reg.intpin_reg_wpermit_reg2 =
+	    PCH_READ_REG(PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
+	/* to store contents of INTPIN_REG_WPERMIT register 3 */
+	g_pch_phub_reg.intpin_reg_wpermit_reg3 =
+	    PCH_READ_REG(PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
+	dev_dbg(dev_dbg, "pch_phub_save_reg_conf : "
+		"g_pch_phub_reg.phub_id_reg=%x, "
+		"g_pch_phub_reg.q_pri_val_reg=%x, "
+		"g_pch_phub_reg.rc_q_maxsize_reg=%x, "
+		"g_pch_phub_reg.bri_q_maxsize_reg=%x, "
+		"g_pch_phub_reg.comp_resp_timeout_reg=%x, "
+		"g_pch_phub_reg.bus_slave_control_reg=%x, "
+		"g_pch_phub_reg.deadlock_avoid_type_reg=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg0=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg1=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg2=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg3=%x\n",
+		g_pch_phub_reg.phub_id_reg,
+		g_pch_phub_reg.q_pri_val_reg,
+		g_pch_phub_reg.rc_q_maxsize_reg,
+		g_pch_phub_reg.bri_q_maxsize_reg,
+		g_pch_phub_reg.comp_resp_timeout_reg,
+		g_pch_phub_reg.bus_slave_control_reg,
+		g_pch_phub_reg.deadlock_avoid_type_reg,
+		g_pch_phub_reg.intpin_reg_wpermit_reg0,
+		g_pch_phub_reg.intpin_reg_wpermit_reg1,
+		g_pch_phub_reg.intpin_reg_wpermit_reg2,
+		g_pch_phub_reg.intpin_reg_wpermit_reg3);
+	/* to store contents of INT_REDUCE_CONTROL registers */
+	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
+		g_pch_phub_reg.int_reduce_control_reg[i] =
+		    PCH_READ_REG(
+			PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
+		dev_dbg(dev_dbg, "pch_phub_save_reg_conf : "
+			"g_pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
+			i, g_pch_phub_reg.int_reduce_control_reg[i]);
+	}
+#ifdef PCH_CAN_PCLK_50MHZ
+	/* save clk cfg register */
+	g_pch_phub_reg.clkcfg_reg = PCH_READ_REG(CLKCFG_REG_OFFSET);
+#endif
+	return;
+}
+
+/** pch_phub_restore_reg_conf - restore register configuration
+ */
+
+void pch_phub_restore_reg_conf(void)
+{
+	u32 i = 0;
+
+	dev_dbg(dev_dbg, "pch_phub_restore_reg_conf ENTRY\n");
+	/* to store contents of PHUB_ID register */
+	PCH_WRITE_REG(g_pch_phub_reg.phub_id_reg, PCH_PHUB_PHUB_ID_REG);
+	/* to store contents of QUEUE_PRI_VAL register */
+	PCH_WRITE_REG(g_pch_phub_reg.q_pri_val_reg, PCH_PHUB_QUEUE_PRI_VAL_REG);
+	/* to store contents of RC_QUEUE_MAXSIZE register */
+	PCH_WRITE_REG(g_pch_phub_reg.rc_q_maxsize_reg,
+			PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
+	/* to store contents of BRI_QUEUE_MAXSIZE register */
+	PCH_WRITE_REG(g_pch_phub_reg.bri_q_maxsize_reg,
+			PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
+	/* to store contents of COMP_RESP_TIMEOUT register */
+	PCH_WRITE_REG(g_pch_phub_reg.comp_resp_timeout_reg,
+			PCH_PHUB_COMP_RESP_TIMEOUT_REG);
+	/* to store contents of BUS_SLAVE_CONTROL_REG register */
+	PCH_WRITE_REG(g_pch_phub_reg.bus_slave_control_reg,
+			PCH_PHUB_BUS_SLAVE_CONTROL_REG);
+	/* to store contents of DEADLOCK_AVOID_TYPE register */
+	PCH_WRITE_REG(g_pch_phub_reg.deadlock_avoid_type_reg,
+			PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
+	/* to store contents of INTPIN_REG_WPERMIT register 0 */
+	PCH_WRITE_REG(g_pch_phub_reg.intpin_reg_wpermit_reg0,
+			PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
+	/* to store contents of INTPIN_REG_WPERMIT register 1 */
+	PCH_WRITE_REG(g_pch_phub_reg.intpin_reg_wpermit_reg1,
+			PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
+	/* to store contents of INTPIN_REG_WPERMIT register 2 */
+	PCH_WRITE_REG(g_pch_phub_reg.intpin_reg_wpermit_reg2,
+			PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
+	/* to store contents of INTPIN_REG_WPERMIT register 3 */
+	PCH_WRITE_REG(g_pch_phub_reg.intpin_reg_wpermit_reg3,
+			PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
+	dev_dbg(dev_dbg, "pch_phub_save_reg_conf : "
+		"g_pch_phub_reg.phub_id_reg=%x, "
+		"g_pch_phub_reg.q_pri_val_reg=%x, "
+		"g_pch_phub_reg.rc_q_maxsize_reg=%x, "
+		"g_pch_phub_reg.bri_q_maxsize_reg=%x, "
+		"g_pch_phub_reg.comp_resp_timeout_reg=%x, "
+		"g_pch_phub_reg.bus_slave_control_reg=%x, "
+		"g_pch_phub_reg.deadlock_avoid_type_reg=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg0=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg1=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg2=%x, "
+		"g_pch_phub_reg.intpin_reg_wpermit_reg3=%x\n",
+		g_pch_phub_reg.phub_id_reg,
+		g_pch_phub_reg.q_pri_val_reg,
+		g_pch_phub_reg.rc_q_maxsize_reg,
+		g_pch_phub_reg.bri_q_maxsize_reg,
+		g_pch_phub_reg.comp_resp_timeout_reg,
+		g_pch_phub_reg.bus_slave_control_reg,
+		g_pch_phub_reg.deadlock_avoid_type_reg,
+		g_pch_phub_reg.intpin_reg_wpermit_reg0,
+		g_pch_phub_reg.intpin_reg_wpermit_reg1,
+		g_pch_phub_reg.intpin_reg_wpermit_reg2,
+		g_pch_phub_reg.intpin_reg_wpermit_reg3);
+	/* to store contents of INT_REDUCE_CONTROL register */
+	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
+		PCH_WRITE_REG(g_pch_phub_reg.int_reduce_control_reg[i],
+			PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
+		dev_dbg(dev_dbg, "pch_phub_save_reg_conf : "
+			"g_pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
+			i, g_pch_phub_reg.int_reduce_control_reg[i]);
+	}
+
+#ifdef PCH_CAN_PCLK_50MHZ
+	/*restore the clock config reg */
+	PCH_WRITE_REG(g_pch_phub_reg.clkcfg_reg, CLKCFG_REG_OFFSET);
+#endif
+
+	return;
+}
+
+/** pch_phub_read_serial_rom - Implements the functionality of reading Serial
+ *  									 ROM.
+ *  @offset_address: Contains the Serial ROM address offset value
+ *  @data: Contains the Serial ROM value
+ */
+int pch_phub_read_serial_rom(unsigned long offset_address, unsigned char *data)
+{
+	unsigned long mem_addr = pch_phub_extrom_base_address + offset_address;
+
+	dev_dbg(dev_dbg,
+		"pch_phub_read_serial_rom:mem_addr=0x%08x\n", (u32)mem_addr);
+	*data = ioread8((void __iomem *)mem_addr);
+
+	return 0;
+}
+
+/** pch_phub_write_serial_rom - Implements the functionality of writing Serial
+ *  									 ROM.
+ *  @offset_address: Contains the Serial ROM address offset value
+ *  @data: Contains the Serial ROM value
+ */
+int pch_phub_write_serial_rom(unsigned long offset_address, unsigned char data)
+{
+	int retval = 0;
+	unsigned long mem_addr = pch_phub_extrom_base_address + offset_address;
+	int i = 0;
+	unsigned long word_data = 0;
+
+	dev_dbg(dev_dbg,
+		"pch_phub_write_serial_rom:mem_addr=0x%08x\n", (u32)mem_addr);
+	iowrite32(PCH_PHUB_ROM_WRITE_ENABLE, (void __iomem *)
+			(pch_phub_extrom_base_address + PHUB_CONTROL));
+
+	word_data = ioread32((void __iomem *)(mem_addr & 0xFFFFFFFC));
+	dev_dbg(dev_dbg, "word_data=0x%08x  data=0x%02x\n",
+		 (u32)word_data, data);
+	switch (mem_addr % 4) {
+	case 0:
+		word_data &= 0xFFFFFF00;
+		iowrite32((word_data | (unsigned long)data),
+				(void __iomem *)(mem_addr & 0xFFFFFFFC));
+		break;
+	case 1:
+		word_data &= 0xFFFF00FF;
+		iowrite32((word_data | ((unsigned long)data << 8)),
+				(void __iomem *)(mem_addr & 0xFFFFFFFC));
+		break;
+	case 2:
+		word_data &= 0xFF00FFFF;
+		iowrite32((word_data | ((unsigned long)data << 16)),
+				(void __iomem *)(mem_addr & 0xFFFFFFFC));
+		break;
+	case 3:
+		word_data &= 0x00FFFFFF;
+		iowrite32((word_data | ((unsigned long)data << 24)),
+				(void __iomem *)(mem_addr & 0xFFFFFFFC));
+		break;
+	}
+	while (0x00 !=
+	       ioread8((void __iomem *)
+			 (pch_phub_extrom_base_address + PHUB_STATUS))) {
+		msleep(1);
+		if (PHUB_TIMEOUT == i) {
+			retval = -EPERM;
+			break;
+		}
+		i++;
+	}
+
+	iowrite32(PCH_PHUB_ROM_WRITE_DISABLE, (void __iomem *)
+			(pch_phub_extrom_base_address + PHUB_CONTROL));
+
+	return retval;
+}
+
+/** pch_phub_read_serial_rom_val - Implements the functionality of reading
+ *  							 Serial ROM value.
+ *  @offset_address: Contains the Serial ROM address offset value
+ *  @data: Contains the Serial ROM value
+ */
+int pch_phub_read_serial_rom_val(unsigned long offset_address,
+				    unsigned char *data)
+{
+	int retval = 0;
+	unsigned long mem_addr;
+
+	mem_addr = (offset_address / 4 * 8) + 3 -
+			(offset_address % 4) + PCH_PHUB_ROM_START_ADDR;
+	retval = pch_phub_read_serial_rom(mem_addr, data);
+
+	return retval;
+}
+
+/** pch_phub_write_serial_rom_val - Implements the functionality of writing
+ *  							 Serial ROM value.
+ *  @offset_address: Contains the Serial ROM address offset value
+ *  @data: Contains the Serial ROM value
+ */
+int pch_phub_write_serial_rom_val(unsigned long offset_address,
+				     unsigned char data)
+{
+	int retval = 0;
+	unsigned long mem_addr;
+
+	mem_addr =
+	    (offset_address / 4 * 8) + 3 - (offset_address % 4) +
+	    PCH_PHUB_ROM_START_ADDR;
+	retval = pch_phub_write_serial_rom(mem_addr, data);
+
+	return retval;
+}
+
+/** pch_phub_gbe_serial_rom_conf - makes Serial ROM header format configuration
+ *  						for Gigabit Ethernet MAC address
+ */
+int pch_phub_gbe_serial_rom_conf(void)
+{
+	int retval = 0;
+
+	retval |= pch_phub_write_serial_rom(0x0b, 0xbc);
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
+/** pch_phub_read_gbe_mac_addr - Contains the Gigabit Ethernet MAC address
+ *  								offset value
+ *  @offset_address: Gigabit Ethernet MAC address offset value
+ *  @data: Contains the Gigabit Ethernet MAC address value
+ */
+int pch_phub_read_gbe_mac_addr(unsigned long offset_address,
+				  unsigned char *data)
+{
+	int retval = 0;
+
+	retval = pch_phub_read_serial_rom_val(offset_address, data);
+
+	return retval;
+}
+
+/** pch_phub_write_gbe_mac_addr - Write MAC address
+ *  @offset_address: Contains the Gigabit Ethernet MAC address offset value
+ *  @data: Contains the Gigabit Ethernet MAC address value
+ */
+int pch_phub_write_gbe_mac_addr(unsigned long offset_address,
+				   unsigned char data)
+{
+	int retval = 0;
+
+	retval = pch_phub_gbe_serial_rom_conf();
+	retval |= pch_phub_write_serial_rom_val(offset_address, data);
+
+	return retval;
+}
+
+/** pch_phub_open - Implements the Initializing and opening of the Packet Hub
+									 module.
+ *  @inode: Contains the reference of the inode structure
+ *  @file: Contains the reference of the file structure
+ */
+int pch_phub_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	spin_lock(&pch_phub_lock);
+	dev_dbg(dev_dbg, "pch_phub_open : open count value = %d",
+		  pch_phub_opencount);
+	if (pch_phub_opencount) {
+		dev_dbg(dev_dbg, "pch_phub_open :  device already opened\n");
+		ret = -EBUSY;
+	} else {
+		pch_phub_opencount++;
+		ret = 0;
+	}
+	spin_unlock(&pch_phub_lock);
+
+	dev_dbg(dev_dbg, "pch_phub_open returns=%d\n", ret);
+	return ret;
+}
+
+/** pch_phub_release - Implements the release functionality of the Packet Hub
+ *  									 module.
+ *  @inode: Contains the reference of the inode structure
+ *  @file: Contains the reference of the file structure
+ */
+int pch_phub_release(struct inode *inode, struct file *file)
+{
+	spin_lock(&pch_phub_lock);
+
+	if (pch_phub_opencount > 0)
+		pch_phub_opencount--;
+	spin_unlock(&pch_phub_lock);
+
+	dev_dbg(dev_dbg, "pch_phub_release : "
+		"pch_phub_opencount=%d  returning=%d\n",
+		pch_phub_opencount, 0);
+	return 0;
+}
+
+/** pch_phub_ioctl - Implements the various ioctl functionalities of the Packet
+ *  								 Hub module.
+ *  @inode: Contains the reference of the inode structure
+ *  @file: Contains the reference of the file structure
+ *  @cmd: Contains the command value
+ *  @arg: Contains the command argument value
+ */
+#if 0
+int pch_phub_ioctl(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	int ret_value = 0;
+	struct pch_phub_reqt *p_pch_phub_reqt;
+	unsigned long addr_offset;
+	unsigned long data;
+	unsigned long mask;
+
+	do {
+		if (pch_phub_suspended == true) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"suspend initiated returning =%d\n",
+				-EPERM);
+			ret_value = -EPERM;
+			break;
+		}
+
+		p_pch_phub_reqt = (struct pch_phub_reqt *)arg;
+		ret_value =
+			copy_from_user((void *)&addr_offset,
+				(void *)&p_pch_phub_reqt->addr_offset,
+				sizeof(addr_offset));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"copy_from_user fail returning =%d\n",
+				-EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		dev_dbg(dev_dbg, "pch_phub_ioctl : "
+			"copy_from_user returns =%d\n", ret_value);
+
+		/* Access area check */
+		switch (cmd) {
+		case IOCTL_PHUB_READ_REG:
+		case IOCTL_PHUB_WRITE_REG:
+		case IOCTL_PHUB_READ_MODIFY_WRITE_REG:
+			if (addr_offset >= 0x504)
+				ret_value = -EPERM;
+			break;
+		case IOCTL_PHUB_READ_OROM:
+		case IOCTL_PHUB_WRITE_OROM:
+		case IOCTL_PHUB_READ_MAC_ADDR:
+		case IOCTL_PHUB_WRITE_MAC_ADDR:
+			if (addr_offset >= 0x10000)
+				ret_value = -EPERM;
+			break;
+		}
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"access area is wrong returning =%d\n",
+				-EPERM);
+			break;
+		}
+		/* End of Access area check */
+
+		switch (cmd) {
+		case IOCTL_PHUB_READ_REG:
+			data = PCH_READ_REG(addr_offset);
+			dev_dbg(dev_dbg, "pch_phub_ioctl  : Invoked "
+				"PCH_READ_REG successfully\n");
+
+			ret_value =
+			    copy_to_user((void *)&p_pch_phub_reqt->data,
+					 (void *)&data, sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+					"copy_to_user fail returning =%d\n",
+					-EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			break;
+		case IOCTL_PHUB_WRITE_REG:
+			ret_value = copy_from_user((void *)&data,
+						(void *)&p_pch_phub_reqt->data,
+						sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"copy_from_user fail returning =%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			PCH_WRITE_REG(data, addr_offset);
+			dev_dbg(dev_dbg, "pch_phub_ioctl  : Invoked "
+				"PCH_WRITE_REG successfully\n");
+			break;
+		case IOCTL_PHUB_READ_MODIFY_WRITE_REG:
+			ret_value = copy_from_user((void *)&data,
+						   (void *)&p_pch_phub_reqt->
+						   data, sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+						"copy_from_user fail "
+						"returning =%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			ret_value = copy_from_user((void *)&mask,
+						   (void *)&p_pch_phub_reqt->
+						   mask, sizeof(mask));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+					"copy_from_user fail "
+					"returning =%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			pch_phub_read_modify_write_reg(addr_offset, data, mask);
+			dev_dbg(dev_dbg, "pch_phub_ioctl  : Invoked "
+				"pch_phub_read_modify_write_reg "
+				"successfully\n");
+			break;
+		case IOCTL_PHUB_READ_OROM:
+			ret_value = pch_phub_read_serial_rom(addr_offset,
+							(unsigned char *)&data);
+			if (ret_value) {
+				dev_dbg(dev_dbg,
+					"pch_phub_ioctl : Invoked "
+					"pch_phub_read_serial_rom "
+					"=%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			} else {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+					"pch_phub_read_serial_rom "
+					"successfully\n");
+			}
+			ret_value = copy_to_user((void *)&p_pch_phub_reqt->
+						 data, (void *)&data,
+						 sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+					"copy_to_user fail returning "
+					"=%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			break;
+		case IOCTL_PHUB_WRITE_OROM:
+			ret_value =
+			    copy_from_user((void *)&data,
+					   (void *)&p_pch_phub_reqt->
+					   data, sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+					"copy_from_user fail returning "
+					"=%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			ret_value =
+				pch_phub_write_serial_rom(addr_offset, data);
+			if (ret_value) {
+				dev_dbg(dev_dbg,
+					"pch_phub_ioctl : Invoked "
+					"pch_phub_write_serial_rom "
+					"=%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			} else {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+					"pch_phub_write_serial_rom "
+					"successfully\n");
+			}
+			break;
+		case IOCTL_PHUB_READ_MAC_ADDR:
+			pch_phub_read_gbe_mac_addr(addr_offset,
+					 (unsigned char *)&data);
+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_read_gbe_mac_addr successfully\n");
+
+			ret_value =
+			    copy_to_user((void *)&p_pch_phub_reqt->data,
+					 (void *)&data, sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+					"copy_to_user fail "
+					"returning =%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			break;
+		case IOCTL_PHUB_WRITE_MAC_ADDR:
+			ret_value =
+			    copy_from_user((void *)&data,
+					   (void *)&p_pch_phub_reqt->data,
+					   sizeof(data));
+			if (ret_value) {
+				dev_dbg(dev_dbg, "pch_phub_ioctl : "
+					"copy_from_user fail "
+					"returning =%d\n", -EFAULT);
+				ret_value = -EFAULT;
+				break;
+			}
+			pch_phub_write_gbe_mac_addr(addr_offset, data);
+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+					"pch_phub_write_gbe_mac_addr "
+					"successfully\n");
+			break;
+		default:
+			dev_dbg(dev_dbg, "pch_write_ioctl invalid "
+				"command returning=%d\n", -EINVAL);
+			ret_value = -EINVAL;
+			break;
+		}
+		break;
+
+	} while (0);
+
+
+	dev_dbg(dev_dbg, "pch_write_ioctl returns=%d\n", ret_value);
+	return ret_value;
+}
+#endif
+int pch_phub_ioctl(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	int ret_value = 0;
+	struct pch_phub_reqt *p_pch_phub_reqt;
+	unsigned long addr_offset;
+	unsigned long data;
+	unsigned long mask;
+
+	if (pch_phub_suspended == true) {
+		dev_dbg(dev_dbg, "pch_phub_ioctl : "
+			"suspend initiated returning =%d\n", -EPERM);
+		ret_value = -EPERM;
+		goto return_ioctrl;
+	}
+
+	p_pch_phub_reqt = (struct pch_phub_reqt *)arg;
+	ret_value = copy_from_user((void *)&addr_offset,
+				(void *)&p_pch_phub_reqt->addr_offset,
+				sizeof(addr_offset));
+	if (ret_value) {
+		dev_dbg(dev_dbg, "pch_phub_ioctl : "
+			"copy_from_user fail returning =%d\n", -EFAULT);
+		ret_value = -EFAULT;
+		goto return_ioctrl;
+	}
+	dev_dbg(dev_dbg, "pch_phub_ioctl : "
+		"copy_from_user returns =%d\n", ret_value);
+
+	/* Access area check */
+	switch (cmd) {
+	case IOCTL_PHUB_READ_REG:
+	case IOCTL_PHUB_WRITE_REG:
+	case IOCTL_PHUB_READ_MODIFY_WRITE_REG:
+		if (addr_offset >= 0x504)
+			ret_value = -EPERM;
+		break;
+	case IOCTL_PHUB_READ_OROM:
+	case IOCTL_PHUB_WRITE_OROM:
+	case IOCTL_PHUB_READ_MAC_ADDR:
+	case IOCTL_PHUB_WRITE_MAC_ADDR:
+		if (addr_offset >= 0x10000)
+			ret_value = -EPERM;
+		break;
+	}
+	if (ret_value) {
+		dev_dbg(dev_dbg, "pch_phub_ioctl : "
+			"access area is wrong returning =%d\n", -EPERM);
+		goto return_ioctrl;
+	}
+	/* End of Access area check */
+
+	switch (cmd) {
+	case IOCTL_PHUB_READ_REG:
+		data = PCH_READ_REG((void __iomem *)addr_offset);
+		dev_dbg(dev_dbg, "pch_phub_ioctl  : Invoked "
+			"PCH_READ_REG successfully\n");
+
+		ret_value = copy_to_user((void *)&p_pch_phub_reqt->data,
+					 (void *)&data, sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"copy_to_user fail returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		break;
+	case IOCTL_PHUB_WRITE_REG:
+		ret_value = copy_from_user((void *)&data,
+					(void *)&p_pch_phub_reqt->data,
+					sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"copy_from_user fail returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		PCH_WRITE_REG(data, (void __iomem *)addr_offset);
+		dev_dbg(dev_dbg, "pch_phub_ioctl  : Invoked "
+				"PCH_WRITE_REG successfully\n");
+		break;
+	case IOCTL_PHUB_READ_MODIFY_WRITE_REG:
+		ret_value = copy_from_user((void *)&data,
+			   (void *)&p_pch_phub_reqt->data, sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : copy_from_user fail "
+					"returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		ret_value = copy_from_user((void *)&mask,
+			   (void *)&p_pch_phub_reqt->mask, sizeof(mask));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : copy_from_user fail "
+					"returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		pch_phub_read_modify_write_reg(addr_offset,
+								 data, mask);
+		dev_dbg(dev_dbg, "pch_phub_ioctl  : Invoked "
+			"pch_phub_read_modify_write_reg successfully\n");
+		break;
+	case IOCTL_PHUB_READ_OROM:
+		ret_value = pch_phub_read_serial_rom(addr_offset,
+							(unsigned char *)&data);
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_read_serial_rom =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		} else {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_read_serial_rom successfully\n");
+		}
+		ret_value = copy_to_user((void *)&p_pch_phub_reqt->data,
+						(void *)&data, sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"copy_to_user fail returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		break;
+	case IOCTL_PHUB_WRITE_OROM:
+		ret_value = copy_from_user((void *)&data,
+			   (void *)&p_pch_phub_reqt->data, sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
+				"copy_from_user fail returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		ret_value = pch_phub_write_serial_rom(addr_offset, data);
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_write_serial_rom =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		} else {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_write_serial_rom successfully\n");
+		}
+		break;
+	case IOCTL_PHUB_READ_MAC_ADDR:
+		pch_phub_read_gbe_mac_addr(addr_offset, (unsigned char *)&data);
+		dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_read_gbe_mac_addr successfully\n");
+
+		ret_value = copy_to_user((void *)&p_pch_phub_reqt->data,
+						 (void *)&data, sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : copy_to_user fail "
+					"returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		break;
+	case IOCTL_PHUB_WRITE_MAC_ADDR:
+		ret_value = copy_from_user((void *)&data,
+			   (void *)&p_pch_phub_reqt->data, sizeof(data));
+		if (ret_value) {
+			dev_dbg(dev_dbg, "pch_phub_ioctl : copy_from_user fail "
+					"returning =%d\n", -EFAULT);
+			ret_value = -EFAULT;
+			break;
+		}
+		pch_phub_write_gbe_mac_addr(addr_offset, data);
+		dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
+				"pch_phub_write_gbe_mac_addr successfully\n");
+		break;
+	default:
+		dev_dbg(dev_dbg, "pch_write_ioctl invalid "
+				"command returning=%d\n", -EINVAL);
+		ret_value = -EINVAL;
+		break;
+	}
+return_ioctrl:
+	dev_dbg(dev_dbg, "pch_write_ioctl returns=%d\n", ret_value);
+	return ret_value;
+}
+
+/** pch_phub_pci_init - Implements the initialization functionality of
+ *  								 the module.
+ */
+static int __init pch_phub_pci_init(void)
+{
+	s32 ret;
+	ret = pci_register_driver(&pch_phub_driver);
+	dev_dbg(dev_dbg, "pch_phub_pci_init : "
+			"Invoked pci_register_driver successfully   "
+			"returns = %d\n", ret);
+	return ret;
+}
+
+/** pch_phub_pci_exit - Implements the exit functionality of the module.
+ */
+static void __exit pch_phub_pci_exit(void)
+{
+	pci_unregister_driver(&pch_phub_driver);
+	dev_dbg(dev_dbg, "pch_phub_pci_exit : "
+			"Invoked pci_unregister_driver successfully\n");
+}
+
+/** pch_phub_probe - Implements the probe functionality of the module.
+ *  @pdev: Contains the reference of the pci_dev structure
+ *  @id: Contains the reference of the pci_device_id structure
+ */
+static int __devinit pch_phub_probe(struct pci_dev *pdev,
+				       const struct pci_device_id *id)
+{
+
+	char *DRIVER_NAME = "pch_phub";
+	int ret;
+	unsigned int rom_size;
+
+	dev_dbg = &pdev->dev;
+
+	pch_phub_major_no = (pch_phub_major_no < 0 || pch_phub_major_no > 254) ?
+				0 : pch_phub_major_no;
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_dbg(dev_dbg, "\npch_phub_probe : pci_enable_device FAILED");
+		goto err_probe;
+	}
+	dev_dbg(dev_dbg, "pch_phub_probe : "
+			"pci_enable_device returns %d\n", ret);
+
+	ret = pci_request_regions(pdev, DRIVER_NAME);
+	if (ret) {
+		dev_dbg(dev_dbg, "pch_phub_probe : pci_request_regions FAILED");
+		pci_disable_device(pdev);
+		goto err_probe;
+	}
+	dev_dbg(dev_dbg, "pch_phub_probe : "
+		"pci_request_regions returns %d\n", ret);
+
+	pch_phub_base_address = (unsigned long)pci_iomap(pdev, 1, 0);
+
+	if (pch_phub_base_address == 0) {
+		dev_dbg(dev_dbg, "pch_phub_probe : pci_iomap FAILED");
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+		ret = -ENOMEM;
+		goto err_probe;
+	}
+	dev_dbg(dev_dbg, "pch_phub_probe : pci_iomap SUCCESS and value "
+		"in pch_phub_base_address variable is 0x%08x\n",
+		pch_phub_base_address);
+
+	pch_phub_extrom_base_address =
+	    (unsigned long)pci_map_rom(pdev, &rom_size);
+	if (pch_phub_extrom_base_address == 0) {
+		dev_dbg(dev_dbg, "pch_phub_probe : pci_map_rom FAILED");
+		pci_iounmap(pdev, (void *)pch_phub_base_address);
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+		ret = -ENOMEM;
+		goto err_probe;
+	}
+	dev_dbg(dev_dbg, "pch_phub_probe : "
+		"pci_map_rom SUCCESS and value in "
+		"pch_phub_extrom_base_address variable is 0x%08x\n",
+		pch_phub_extrom_base_address);
+
+	if (pch_phub_major_no) {
+		pch_phub_dev_no = MKDEV(pch_phub_major_no, 0);
+		ret = register_chrdev_region(pch_phub_dev_no,
+					   PCH_MINOR_NOS, DRIVER_NAME);
+		if (ret) {
+			dev_dbg(dev_dbg, "pch_phub_probe : "
+				"register_chrdev_region FAILED");
+			pci_unmap_rom(pdev,
+					(void *)pch_phub_extrom_base_address);
+			pci_iounmap(pdev, (void *)pch_phub_base_address);
+			pci_release_regions(pdev);
+			pci_disable_device(pdev);
+			goto err_probe;
+		}
+		dev_dbg(dev_dbg, "pch_phub_probe : "
+				"register_chrdev_region returns %d\n", ret);
+	} else {
+		ret = alloc_chrdev_region(&pch_phub_dev_no, 0,
+						PCH_MINOR_NOS, DRIVER_NAME);
+		if (ret) {
+			dev_dbg(dev_dbg, "pch_phub_probe : "
+					"alloc_chrdev_region FAILED");
+			pci_unmap_rom(pdev,
+				      (void *)pch_phub_extrom_base_address);
+			pci_iounmap(pdev,
+				    (void *)pch_phub_base_address);
+			pci_release_regions(pdev);
+			pci_disable_device(pdev);
+			goto err_probe;
+		}
+		dev_dbg(dev_dbg, "pch_phub_probe : "
+			"alloc_chrdev_region returns %d\n", ret);
+	}
+
+	cdev_init(&pch_phub_dev, &pch_phub_fops);
+	dev_dbg(dev_dbg, "pch_phub_probe :  cdev_init invoked successfully\n");
+
+	pch_phub_dev.owner = THIS_MODULE;
+	pch_phub_dev.ops = &pch_phub_fops;
+
+	ret = cdev_add(&pch_phub_dev, pch_phub_dev_no, PCH_MINOR_NOS);
+	if (ret) {
+		dev_dbg(dev_dbg, "pch_phub_probe :  cdev_add FAILED");
+		unregister_chrdev_region(pch_phub_dev_no, PCH_MINOR_NOS);
+		pci_unmap_rom(pdev, (void *)pch_phub_extrom_base_address);
+		pci_iounmap(pdev, (void *)pch_phub_base_address);
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+		goto err_probe;
+	}
+	dev_dbg(dev_dbg, "pch_phub_probe :  cdev_add returns %d\n", ret);
+
+#ifdef PCH_CAN_PCLK_50MHZ
+	/*set the clock config reg if CAN clock is 50Mhz */
+	dev_dbg(dev_dbg, "pch_phub_probe : invoking "
+		"pch_phub_read_modify_write_reg "
+		"to set CLKCFG reg for CAN clk 50Mhz\n");
+	pch_phub_read_modify_write_reg((unsigned long)CLKCFG_REG_OFFSET,
+					  CLKCFG_CAN_50MHZ, CLKCFG_CANCLK_MASK);
+#endif
+	/* set the prefech value */
+	PCH_WRITE_REG(0x000ffffa, (void __iomem *)0x14);
+	/* set the interrupt delay value */
+	PCH_WRITE_REG(0x25, (void __iomem *)0x44);
+	return 0;
+
+err_probe:
+	dev_dbg(dev_dbg, "pch_phub_probe returns %d\n", ret);
+	return ret;
+}
+
+/** pch_phub_remove - Implements the remove functionality of the module.
+ *  @pdev: Contains the reference of the pci_dev structure
+ */
+static void __devexit pch_phub_remove(struct pci_dev *pdev)
+{
+
+	cdev_del(&pch_phub_dev);
+	dev_dbg(dev_dbg, "pch_phub_remove - cdev_del Invoked successfully\n");
+
+	unregister_chrdev_region(pch_phub_dev_no, PCH_MINOR_NOS);
+	dev_dbg(dev_dbg, "pch_phub_remove - "
+		"unregister_chrdev_region Invoked successfully\n");
+
+	pci_unmap_rom(pdev, (void *)pch_phub_extrom_base_address);
+
+	pci_iounmap(pdev, (void *)pch_phub_base_address);
+
+	dev_dbg(dev_dbg, "pch_phub_remove - "
+			"pci_iounmap Invoked successfully\n");
+
+	pci_release_regions(pdev);
+	dev_dbg(dev_dbg, "pch_phub_remove - "
+		"pci_release_regions Invoked successfully\n");
+
+	pci_disable_device(pdev);
+	dev_dbg(dev_dbg, "pch_phub_remove - "
+		"pci_disable_device Invoked successfully\n");
+
+}
+
+#ifdef CONFIG_PM
+
+/** pch_phub_suspend - Implements the suspend functionality of the module.
+ *  @pdev: Contains the reference of the pci_dev structure
+ *  @state: Contains the reference of the pm_message_t structure
+ */
+static int pch_phub_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int ret;
+
+	pch_phub_suspended = true;	/* For blocking further IOCTLs */
+
+	pch_phub_save_reg_conf();
+	dev_dbg(dev_dbg, "pch_phub_suspend - "
+		"pch_phub_save_reg_conf Invoked successfully\n");
+
+	ret = pci_save_state(pdev);
+	if (ret) {
+		dev_dbg(dev_dbg,
+			" pch_phub_suspend -pci_save_state returns-%d\n", ret);
+		return ret;
+	}
+	dev_dbg(dev_dbg, "pch_phub_suspend - pci_save_state returns %d\n", ret);
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	dev_dbg(dev_dbg, "pch_phub_suspend - "
+			"pci_enable_wake Invoked successfully\n");
+
+	pci_disable_device(pdev);
+	dev_dbg(dev_dbg, "pch_phub_suspend - "
+			"pci_disable_device Invoked successfully\n");
+
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	dev_dbg(dev_dbg, "pch_phub_suspend - "
+			"pci_set_power_state Invoked successfully   "
+			"return = %d\n", 0);
+
+	return 0;
+}
+
+/** pch_phub_resume - Implements the resume functionality of the module.
+ *  @pdev: Contains the reference of the pci_dev structure
+ */
+static int pch_phub_resume(struct pci_dev *pdev)
+{
+
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	dev_dbg(dev_dbg, "pch_phub_resume - "
+		"pci_set_power_state Invoked successfully\n");
+
+	pci_restore_state(pdev);
+	dev_dbg(dev_dbg, "pch_phub_resume - "
+		"pci_restore_state Invoked successfully\n");
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_dbg(dev_dbg, "pch_phub_resume-pci_enable_device failed ");
+		return ret;
+	}
+
+	dev_dbg(dev_dbg, "pch_phub_resume - "
+			"pci_enable_device returns -%d\n", ret);
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	dev_dbg(dev_dbg, "pch_phub_resume - "
+			"pci_enable_wake Invoked successfully\n");
+
+	pch_phub_restore_reg_conf();
+	dev_dbg(dev_dbg, "pch_phub_resume - "
+		"pch_phub_restore_reg_conf Invoked successfully\n");
+
+	pch_phub_suspended = false;
+
+	dev_dbg(dev_dbg, "pch_phub_resume  returns- %d\n", 0);
+	return 0;
+}
+#endif /* CONFIG_PM */
diff --git a/drivers/char/pch_phub/pch_phub.h b/drivers/char/pch_phub/pch_phub.h
new file mode 100755
index 0000000..62ed819
--- /dev/null
+++ b/drivers/char/pch_phub/pch_phub.h
@@ -0,0 +1,96 @@
+#ifndef __PCH_PHUB_H__
+#define __PCH_PHUB_H__
+/*!
+ * @file pch_phub.h
+ * @brief Provides all the interfaces pertaining to the Packet Hub module.
+ * @version 1.0.0.0
+ * @section
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
+/*
+ * History:
+ * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ *
+ * created:
+ *	OKI SEMICONDUCTOR 04/14/2010
+ * modified:
+ *
+ */
+
+#define PHUB_IOCTL_MAGIC 		(0xf7)
+
+/*Outlines the read register function signature.  */
+#define IOCTL_PHUB_READ_REG (_IOW(PHUB_IOCTL_MAGIC, 1, unsigned long))
+
+/*Outlines the write register function signature. */
+#define IOCTL_PHUB_WRITE_REG (_IOW(PHUB_IOCTL_MAGIC, 2, unsigned long))
+
+/*Outlines the read, modify and write register function signature. */
+#define IOCTL_PHUB_READ_MODIFY_WRITE_REG (_IOW(PHUB_IOCTL_MAGIC, 3,\
+								 unsigned long))
+
+/*Outlines the read option rom function signature. */
+#define IOCTL_PHUB_READ_OROM (_IOW(PHUB_IOCTL_MAGIC, 4, unsigned long))
+
+/*Outlines the write option rom function signature. */
+#define IOCTL_PHUB_WRITE_OROM (_IOW(PHUB_IOCTL_MAGIC, 5, unsigned long))
+
+/*Outlines the read mac address function signature. */
+#define IOCTL_PHUB_READ_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 6, unsigned long))
+
+/*brief Outlines the write mac address function signature. */
+#define IOCTL_PHUB_WRITE_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 7, unsigned long))
+
+
+/* Registers address offset */
+#define PCH_PHUB_PHUB_ID_REG			(void __iomem *)(0x0000)
+#define PCH_PHUB_QUEUE_PRI_VAL_REG			(void __iomem *)(0x0004)
+#define PCH_PHUB_RC_QUEUE_MAXSIZE_REG		(void __iomem *)(0x0008)
+#define PCH_PHUB_BRI_QUEUE_MAXSIZE_REG		(void __iomem *)(0x000C)
+#define PCH_PHUB_COMP_RESP_TIMEOUT_REG		(void __iomem *)(0x0010)
+#define PCH_PHUB_BUS_SLAVE_CONTROL_REG		(void __iomem *)(0x0014)
+#define PCH_PHUB_DEADLOCK_AVOID_TYPE_REG		(void __iomem *)(0x0018)
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG0		(void __iomem *)(0x0020)
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG1		(void __iomem *)(0x0024)
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG2		(void __iomem *)(0x0028)
+#define PCH_PHUB_INTPIN_REG_WPERMIT_REG3		(void __iomem *)(0x002C)
+#define PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE	(void __iomem *)(0x0040)
+#define CLKCFG_REG_OFFSET           		(void __iomem *)(0x500)
+
+/*structures*/
+/*It is a structure used for perserving information related to the
+ * 							 Packet Hub request.
+ */
+struct pch_phub_reqt {
+	unsigned long addr_offset;	/*specifies the register address
+								 offset */
+	unsigned long data;	/*specifies the data */
+	unsigned long mask;	/*specifies the mask */
+};
+
+/* exported function prototypes */
+int pch_phub_open(struct inode *inode, struct file *file);
+int pch_phub_release(struct inode *inode, struct file *file);
+int pch_phub_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		      unsigned long arg);
+
+/**global variables*/
+extern u32 pch_phub_base_address;	/* base address */
+extern s32 pch_phub_suspended;		/* suspend status */
+
+extern s32 pch_phub_opencount;
+extern spinlock_t pch_phub_lock;
+extern const struct file_operations pch_phub_fops;
+#endif
-- 
1.6.0.6
