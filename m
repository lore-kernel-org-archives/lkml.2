Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2E0Uuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:50:55 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:44211 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2E0Uux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:50:53 -0400
Date: Sun, 27 May 2012 22:50:20 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Samuel Ortiz <sameo@linux.intel.com>, x86@kernel.org
Subject: [PATCH] x86/platform: sta2x11: add platform code
Message-ID: <20120527205020.GA3050@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds platform code for the STA2X11 (aka ConneXt) I/O Hub,
including support for the Intel NorthVille evaluation board and the
ST-Eval PCIe carrier.

The boards differ for the amount of peripherals actually wired out,
GPIO configuration and some accessory pins. At this point, platform
data for peripherals other tha GPIO is not instantiated because the
drivers are not yet upstream.

The array of supported boards is built using a local ELF section to
avoid ifdef; the section is folded in the .data section by a local
linker script.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/Kconfig                       |   18 +++
 arch/x86/include/asm/sta2x11.h         |    6 +
 arch/x86/pci/sta2x11-fixup.c           |   14 ++
 arch/x86/platform/sta2x11/Makefile     |    5 +
 arch/x86/platform/sta2x11/boards.lds   |    9 ++
 arch/x86/platform/sta2x11/northville.c |  140 ++++++++++++++++++++
 arch/x86/platform/sta2x11/sta2x11.c    |  224 ++++++++++++++++++++++++++++++++
 arch/x86/platform/sta2x11/sta2x11.h    |   79 +++++++++++
 arch/x86/platform/sta2x11/steval.c     |  150 +++++++++++++++++++++
 9 files changed, 645 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/sta2x11/Makefile
 create mode 100644 arch/x86/platform/sta2x11/boards.lds
 create mode 100644 arch/x86/platform/sta2x11/northville.c
 create mode 100644 arch/x86/platform/sta2x11/sta2x11.c
 create mode 100644 arch/x86/platform/sta2x11/sta2x11.h
 create mode 100644 arch/x86/platform/sta2x11/steval.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4732997..23548ca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -507,6 +507,24 @@ config STA2X11
 	  option is selected the kernel will still be able to boot on
 	  standard PC machines.
 
+menu "STA2X11 boards"
+	depends on STA2X11
+
+config STA2X11_NORTHVILLE
+	bool "Support for Intel Northville board"
+	---help---
+	  Compile platform data for the Intel NorthVille board.
+	  If present, this board is selected by default at boot.
+
+config STA2X11_STEVAL
+	bool "Support for ST Evaluation board"
+	---help---
+	  Compile platform data for the PCIe carrier called "ST-Eval".
+	  Support for the boards can be selected using the command line
+	  option "sta2x11.board_name=steval" .
+
+endmenu
+
 config X86_SUMMIT
 	bool "Summit/EXA (IBM x440)"
 	depends on X86_32_NON_STANDARD
diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
index e9d32df..6b6e5c1 100644
--- a/arch/x86/include/asm/sta2x11.h
+++ b/arch/x86/include/asm/sta2x11.h
@@ -9,4 +9,10 @@
 /* This needs to be called from the MFD to configure its sub-devices */
 struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev);
 
+/*
+ * This function is called at PCI enable time to obtain platform/board
+ * specific data and make sure that all dependencies are met.
+ */
+void *sta2x11_get_platform_data(struct pci_dev *pdev);
+
 #endif /* __ASM_STA2X11_H */
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 5aaa434..7a3d146 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -26,6 +26,7 @@
 #include <linux/pci_ids.h>
 #include <linux/export.h>
 #include <linux/list.h>
+#include <asm/sta2x11.h>
 
 #define STA2X11_SWIOTLB_SIZE (4*1024*1024)
 extern int swiotlb_late_init_with_default_size(size_t default_size);
@@ -214,6 +215,19 @@ static void sta2x11_setup_pdev(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, sta2x11_setup_pdev);
 
 /*
+ * Set platform data for pci device, to use sta2x11-specifics in the drivers
+ */
+static void set_platform_data(struct pci_dev *pdev)
+{
+	void *data = sta2x11_get_platform_data(pdev);
+	if (data)
+		dev_info(&pdev->dev, "setting platform data for device "
+		       "%04x:%04x\n", pdev->vendor, pdev->device);
+	pdev->dev.platform_data = data;
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, set_platform_data);
+
+/*
  * The following three functions are exported (used in swiotlb: FIXME)
  */
 /**
diff --git a/arch/x86/platform/sta2x11/Makefile b/arch/x86/platform/sta2x11/Makefile
new file mode 100644
index 0000000..c54aba4
--- /dev/null
+++ b/arch/x86/platform/sta2x11/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_STA2X11) +=  sta2x11.o
+obj-$(CONFIG_STA2X11_NORTHVILLE) +=  northville.o
+obj-$(CONFIG_STA2X11_STEVAL) +=  steval.o
+
+ldflags-y = -T $(srctree)/$(obj)/boards.lds
diff --git a/arch/x86/platform/sta2x11/boards.lds b/arch/x86/platform/sta2x11/boards.lds
new file mode 100644
index 0000000..36e80a5
--- /dev/null
+++ b/arch/x86/platform/sta2x11/boards.lds
@@ -0,0 +1,9 @@
+SECTIONS
+{
+	.data : {
+		sta2x11_board_first = .;
+		*(.board);
+		sta2x11_board_last = .;
+	}
+}
+
diff --git a/arch/x86/platform/sta2x11/northville.c b/arch/x86/platform/sta2x11/northville.c
new file mode 100644
index 0000000..2fbe90e
--- /dev/null
+++ b/arch/x86/platform/sta2x11/northville.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (c) 2011 Wind River Systems, Inc.
+ * Copyright (c) 2011 Soft-In (Davide Ciminaghi, Aurelio Colosimo)
+ * Copyright (c) 2011 ST Microelectronics (Alessandro Rubini)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/mfd/sta2x11-mfd.h>
+#include <asm/sta2x11.h>
+#include "sta2x11.h"
+
+static struct sta2x11_gpio_pdata northville_gpio = {
+	.pinconfig = {
+	[STA2X11_GPIO0] =			PINMUX_TYPE_INPUT,
+	[STA2X11_GPIO1] =			PINMUX_TYPE_INPUT,
+	[STA2X11_GPIO2] =			PINMUX_TYPE_INPUT,
+	[STA2X11_GPIO3] =			PINMUX_TYPE_INPUT,
+	[STA2X11_GPIO4] =			PINMUX_TYPE_INPUT_PULLUP,
+	[STA2X11_GPIO5] =			PINMUX_TYPE_INPUT,
+	[STA2X11_GPIO6] =			PINMUX_TYPE_INPUT_PULLDOWN,
+	[STA2X11_GPIO7] =			PINMUX_TYPE_INPUT,
+	[STA2X11_GPIO8_RGBOUT_RED7] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO9_RGBOUT_RED6] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO10_RGBOUT_RED5] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO11_RGBOUT_RED4] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO12_RGBOUT_RED3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO13_RGBOUT_RED2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO14_RGBOUT_RED1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO15_RGBOUT_RED0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO16_RGBOUT_GREEN7] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO17_RGBOUT_GREEN6] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO18_RGBOUT_GREEN5] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO19_RGBOUT_GREEN4] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO20_RGBOUT_GREEN3] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO21_RGBOUT_GREEN2] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO22_RGBOUT_GREEN1] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO23_RGBOUT_GREEN0] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO24_RGBOUT_BLUE7] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO25_RGBOUT_BLUE6] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO26_RGBOUT_BLUE5] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO27_RGBOUT_BLUE4] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO28_RGBOUT_BLUE3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO29_RGBOUT_BLUE2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO30_RGBOUT_BLUE1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO31_RGBOUT_BLUE0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO32_RGBOUT_VSYNCH] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO33_RGBOUT_HSYNCH] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO34_RGBOUT_DEN] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO35_ETH_CRS_DV] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO36_ETH_TXD1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO37_ETH_TXD0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO38_ETH_TX_EN] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO39_MDIO] =			PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO40_ETH_REF_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO41_ETH_RXD1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO42_ETH_RXD0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO43_MDC] =			PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO44_CAN_TX] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO45_CAN_RX] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO46_MLB_DAT] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO47_MLB_SIG] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO48_SPI0_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO49_SPI0_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO50_SPI0_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO51_SPI0_FRM] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO52_SPI1_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO53_SPI1_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO54_SPI1_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO55_SPI1_FRM] =		PINMUX_TYPE_FUNCTION,
+		/* no SPI 2: gpio 56..59 */
+	[STA2X11_GPIO60_I2C0_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO61_I2C0_SDA] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO62_I2C1_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO63_I2C1_SDA] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO64_I2C2_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO65_I2C2_SDA] =		PINMUX_TYPE_FUNCTION,
+		/* no I2C 3: gpio 66.67 */
+	[STA2X11_GPIO70_MSP0_RFS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO72_MSP0_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO74_MSP0_SCK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO75_MSP1_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO76_MSP1_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO77_MSP1_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO78_MSP1_TXD] =		PINMUX_TYPE_FUNCTION,
+		/* no MSP 2: gpio 79..82 */
+	[STA2X11_GPIO83_MSP3_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO84_MSP3_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO85_MSP3_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO86_MSP3_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO87_MSP4_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO88_MSP4_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO89_MSP4_FS] =		PINMUX_TYPE_FUNCTION,
+		/* 90 is most_power, other MSP5 are in use */
+	[STA2X11_GPIO91_MSP5_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO92_MSP5_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO93_MSP5_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO94_MSP5_TXD] =		PINMUX_TYPE_FUNCTION,
+		/* no SDIO 3: gpio 95..100, then 101..104 are gpio-only */
+	[STA2X11_GPIO105_SDIO2_DAT3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO106_SDIO2_DAT2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO107_SDIO2_DAT1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO108_SDIO2_DAT0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO109_SDIO2_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO110_SDIO2_CMD] =		PINMUX_TYPE_FUNCTION,
+		/* gpio 111..114 are gpio only (111 is mmc2-power) */
+	[STA2X11_GPIO115_SDIO1_DAT3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO116_SDIO1_DAT2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO117_SDIO1_DAT1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO118_SDIO1_DAT0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO119_SDIO1_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO120_SDIO1_CMD] =		PINMUX_TYPE_FUNCTION,
+		/* gpio 121..124 are gpio only */
+	[STA2X11_GPIO125_UART2_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO126_UART2_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO127_UART3_TXD] =		PINMUX_TYPE_FUNCTION,
+	}
+};
+
+struct sta2x11_board northville_board = {
+	.name = "northville",
+	.config_data = {
+		[GPIO] =	&northville_gpio,
+	},
+};
+
+DECLARE_STA2X11_BOARD(northville_board);
diff --git a/arch/x86/platform/sta2x11/sta2x11.c b/arch/x86/platform/sta2x11/sta2x11.c
new file mode 100644
index 0000000..11c5e2d
--- /dev/null
+++ b/arch/x86/platform/sta2x11/sta2x11.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (c) 2011 Wind River Systems, Inc.
+ * Copyright (c) 2011 Soft-In (Davide Ciminaghi, Aurelio Colosimo)
+ * Copyright (c) 2011 ST Microelectronics (Alessandro Rubini)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *
+ * This file provides a generic interface for providing various
+ * board/device specific data to the sta2x11 PCI drivers.
+ * This is so that we can have 1 kernel with support compiled in
+ * for all known boards containing the STA2x11 IO Hub.
+ *
+ * Platform code for different STA2x11 boards. The 2 main functions
+ * of this code is to define the platform/board and provide configuration
+ * data to the sta2x11 drivers for this board. A new board file needs to
+ * be created for every new board
+ *
+ * Use the kernel cmd line sta2x11.board_name=xxx to change the
+ * supported platform. Default board is the first one compiled in, in the
+ * shipped code this is "northville"
+ *
+ * The PCI fixups call the function
+ *             void *sta2x11_get_platform_data(struct pci_dev *pdev)
+ * for all devices that are going to be used.
+ * The configuration is dependent on device id and position in the bus tree.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/amba/serial.h>
+#include <linux/mfd/sta2x11-mfd.h>
+
+#include <asm/pci-direct.h>
+#include <asm/mtrr.h>
+#include <asm/sta2x11.h>
+
+#include "sta2x11.h"
+
+/*
+ * The board can be named on the kernel command line:
+ *      sta2x11.board_name=steval
+ */
+static char *board_name = "northville"; /* default board name */
+module_param(board_name, charp, 0444);
+
+struct sta2x11_device {
+	unsigned short pci_devid;
+	int endpoint;
+	int pci_func;
+	enum sta2x11_pcie_devid sta2x11_id;
+	void *data;
+	void (*add_data)(struct sta2x11_device *);
+};
+
+#define _dev(devid, ep, func, id, ad)	\
+	.pci_devid = PCI_DEVICE_ID_STMICRO_ ## devid, \
+	.endpoint = ep, \
+	.pci_func = func, \
+	.sta2x11_id = id, \
+	.add_data = ad
+
+static struct sta2x11_device __devices[] = {
+
+	/* EP0 */
+	{_dev(GPIO,			0, 0,	GPIO,		NULL)},
+	{_dev(USB_HOST,			0, 1,	USB_EHCI,	NULL)},
+	{_dev(USB_OHCI,			0, 2,	USB_OHCI,	NULL)},
+	{_dev(USB_OTG,			0, 3,	USB_OTG,	NULL)},
+	{_dev(SOC_DMA,			0, 4,	DMA,		NULL)},
+	{_dev(UART_HWFC,		0, 5,	UART0,		NULL)},
+	{_dev(UART_HWFC,		0, 6,	UART1,		NULL)},
+	{_dev(UART_NO_HWFC,		0, 7,	UART2,		NULL)},
+
+	/* EP1 */
+	{_dev(SATA,			1, 0,	SATAC,		NULL)},
+	{_dev(I2C,			1, 1,	I2C0,		NULL)},
+	{_dev(I2C,			1, 2,	I2C1,		NULL)},
+	{_dev(I2C,			1, 3,	I2C2,		NULL)},
+	{_dev(I2C,			1, 4,	I2C3,		NULL)},
+	{_dev(UART_NO_HWFC,		1, 5,	UART3,		NULL)},
+	{_dev(SATA_PHY,			1, 6,	SATAP,		NULL)},
+	{_dev(MLB,			1, 7,	MLB,		NULL)},
+
+	/* EP2 */
+	{_dev(VIC,			2, 0,	VIC,		NULL)},
+	{_dev(SDIO_EMMC,		2, 1,	SDIO0,		NULL)},
+	{_dev(SDIO,			2, 2,	SDIO1,		NULL)},
+	{_dev(SDIO,			2, 3,	SDIO2,		NULL)},
+	{_dev(SDIO,			2, 4,	SDIO3,		NULL)},
+	{_dev(ESRAM,			2, 5,	ROMRAM,		NULL)},
+	{_dev(MAC,			2, 6,	ETH,		NULL)},
+	{_dev(CAN,			2, 7,	CAN,		NULL)},
+
+	/* EP3 */
+	{_dev(VIP,			3, 0,	VIP,		NULL)},
+	{_dev(DBP,			3, 1,	DBRG,		NULL)},
+	{_dev(SPI_HS,			3, 2,	SPI0,		NULL)},
+	{_dev(SPI_HS,			3, 3,	SPI1,		NULL)},
+	{_dev(SPI_HS,			3, 4,	SPI2,		NULL)},
+	{_dev(AUDIO_ROUTER_DMA,		3, 5,	ARDMA,		NULL)},
+	{_dev(AUDIO_ROUTER_SRCS,	3, 6,	ARSRC,		NULL)},
+	{_dev(AUDIO_ROUTER_MSPS,	3, 7,	ARMSPS,		NULL)},
+};
+
+/* Apply board-specific configuration on top of the table above */
+static void __init config_board_devices(struct sta2x11_board *brd)
+{
+	int i;
+	struct sta2x11_device *d;
+
+	pr_debug("sta2x11: configuring board devices\n");
+
+	for (i = 0, d = __devices; i < ARRAY_SIZE(__devices); i++, d++) {
+
+		/* if the board offers a config, override the default */
+		if (brd->config_data[d->sta2x11_id])
+			d->data = brd->config_data[d->sta2x11_id];
+		if (!d->data)
+			continue;
+		pr_debug("sta2x11: dev %04x ep %d func %d, d->data = %pS",
+			d->pci_devid, d->endpoint, d->pci_func, d->data);
+		if (d->add_data)
+			d->add_data(d);
+	}
+}
+
+/**
+ * find_device - Find STMicro device id
+ * @pdev: PCI device
+ *
+ * Return sta2x11 device configuration
+ */
+static struct sta2x11_device *find_device(struct pci_dev *pdev)
+{
+	struct sta2x11_device *dev;
+	int i, endpoint;
+
+	if (pdev->vendor != PCI_VENDOR_ID_STMICRO)
+		return NULL;
+	if (!pdev->bus->parent)
+		return NULL;
+	endpoint = pdev->bus->number - pdev->bus->parent->number - 1;
+	for (i = 0, dev = __devices; i < ARRAY_SIZE(__devices); i++, dev++) {
+		if (dev->pci_devid != pdev->device)
+			continue;
+		if (dev->endpoint != endpoint)
+			continue;
+		if (dev->pci_func != PCI_FUNC(pdev->devfn))
+			continue;
+		return dev;
+	}
+	return NULL;
+}
+
+/**
+ * sta2x11_get_platform_data - get platform data for the PCI device
+ * @pdev: PCI device
+ *
+ * Return sta2x11 device configuration
+ */
+void *sta2x11_get_platform_data(struct pci_dev *pdev)
+{
+	struct sta2x11_device *dev;
+
+	BUG_ON(pdev == NULL);
+
+	dev_dbg(&pdev->dev, "sta2x11_platform: bus.fn %i.%i\n",
+		pdev->bus->number,
+		PCI_FUNC(pdev->devfn));
+
+	dev = find_device(pdev);
+	if (dev != NULL)
+		return dev->data;
+
+	dev_dbg(&pdev->dev, "sta2x11_platform: no match for device\n");
+	return NULL;
+}
+EXPORT_SYMBOL(sta2x11_get_platform_data);
+
+/* This is our early initcall, we must detect the board and init devices */
+static int __init sta2x11_platform_init(void)
+{
+	struct sta2x11_board *brd, **bpp;
+
+	if (sta2x11_board_first == sta2x11_board_last) {
+		pr_err("STA2X11: no boards selected in kernel configuration\n");
+		return -ENODEV;
+	}
+
+	/* Currently there is no way of detecting boards. Use cmdline arg. */
+	for (bpp = sta2x11_board_first;
+	     brd = *bpp, bpp < sta2x11_board_last;
+	     bpp++) {
+		if (!strcmp(board_name, brd->name))
+			break;
+	}
+	if (bpp == sta2x11_board_last) {
+		pr_warn("STA2X11: can't find board \"%s\"\n", board_name);
+		brd = *sta2x11_board_first;
+	}
+	pr_info("STA2x11: Configuring for board \"%s\"\n", brd->name);
+	if (brd->setup)
+		brd->setup(brd);
+	config_board_devices(brd);
+
+	return 0;
+}
+early_initcall(sta2x11_platform_init);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Platform for STA2X11");
diff --git a/arch/x86/platform/sta2x11/sta2x11.h b/arch/x86/platform/sta2x11/sta2x11.h
new file mode 100644
index 0000000..97de40b
--- /dev/null
+++ b/arch/x86/platform/sta2x11/sta2x11.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2011 Wind River Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#ifndef __PLATFORM_STA2X11_H
+#define __PLATFORM_STA2X11_H
+
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/i2c.h>
+#include <asm/sta2x11.h>
+
+/* Symbolic id for pcie devices */
+enum sta2x11_pcie_devid {
+	GPIO = 0,
+	USB_OHCI,
+	USB_EHCI,
+	USB_OTG,
+	DMA,
+	UART0,
+	UART1,
+	UART2,
+	UART3,
+	SATAC,
+	I2C0,
+	I2C1,
+	I2C2,
+	I2C3,
+	SATAP,
+	MLB,
+	VIC,
+	SDIO0,
+	SDIO1,
+	SDIO2,
+	SDIO3,
+	ROMRAM,
+	ETH,
+	CAN,
+	VIP,
+	DBRG,
+	SPI0,
+	SPI1,
+	SPI2,
+	ARDMA,
+	ARSRC,
+	ARMSPS,
+	STA2X11_NR_OF_DEVICES,
+};
+
+struct sta2x11_board {
+	const char *name;
+	void (*setup)(struct sta2x11_board *);
+	void *config_data[STA2X11_NR_OF_DEVICES];
+};
+
+/* To build the board array we use a local elf section: see ./boards.lds */
+extern struct sta2x11_board *sta2x11_board_first[], *sta2x11_board_last[];
+
+/* Boards are part of an array in the .boards ELF section, local to this dir */
+#define DECLARE_STA2X11_BOARD(brd) \
+	static struct sta2x11_board __attribute__((section(".board"), used)) \
+	*__sta2x11_board_ ## brd = &brd
+
+#endif /* __PLATFORM_STA2X11_H */
+
diff --git a/arch/x86/platform/sta2x11/steval.c b/arch/x86/platform/sta2x11/steval.c
new file mode 100644
index 0000000..b434cab
--- /dev/null
+++ b/arch/x86/platform/sta2x11/steval.c
@@ -0,0 +1,150 @@
+/*
+ * Copyright (c) 2011 Wind River Systems, Inc.
+ * Copyright (c) 2011 Soft-In (Davide Ciminaghi, Aurelio Colosimo)
+ * Copyright (c) 2011 ST Microelectronics (Alessandro Rubini)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/mfd/sta2x11-mfd.h>
+#include <asm/sta2x11.h>
+#include "sta2x11.h"
+
+static struct sta2x11_gpio_pdata steval_gpio = {
+	.pinconfig = {
+		/* 0..7 are gpio only */
+	[STA2X11_GPIO8_RGBOUT_RED7] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO9_RGBOUT_RED6] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO10_RGBOUT_RED5] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO11_RGBOUT_RED4] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO12_RGBOUT_RED3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO13_RGBOUT_RED2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO14_RGBOUT_RED1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO15_RGBOUT_RED0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO16_RGBOUT_GREEN7] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO17_RGBOUT_GREEN6] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO18_RGBOUT_GREEN5] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO19_RGBOUT_GREEN4] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO20_RGBOUT_GREEN3] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO21_RGBOUT_GREEN2] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO22_RGBOUT_GREEN1] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO23_RGBOUT_GREEN0] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO24_RGBOUT_BLUE7] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO25_RGBOUT_BLUE6] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO26_RGBOUT_BLUE5] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO27_RGBOUT_BLUE4] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO28_RGBOUT_BLUE3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO29_RGBOUT_BLUE2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO30_RGBOUT_BLUE1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO31_RGBOUT_BLUE0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO32_RGBOUT_VSYNCH] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO33_RGBOUT_HSYNCH] =	PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO34_RGBOUT_DEN] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO35_ETH_CRS_DV] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO36_ETH_TXD1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO37_ETH_TXD0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO38_ETH_TX_EN] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO39_MDIO] =			PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO40_ETH_REF_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO41_ETH_RXD1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO42_ETH_RXD0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO43_MDC] =			PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO44_CAN_TX] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO45_CAN_RX] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO46_MLB_DAT] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO47_MLB_SIG] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO48_SPI0_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO49_SPI0_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO50_SPI0_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO51_SPI0_FRM] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO52_SPI1_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO53_SPI1_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO54_SPI1_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO55_SPI1_FRM] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO56_SPI2_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO57_SPI2_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO58_SPI2_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO59_SPI2_FRM] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO60_I2C0_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO61_I2C0_SDA] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO62_I2C1_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO63_I2C1_SDA] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO64_I2C2_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO65_I2C2_SDA] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO66_I2C3_SCL] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO67_I2C3_SDA] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO68_MSP0_RCK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO69_MSP0_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO70_MSP0_RFS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO71_MSP0_TCK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO72_MSP0_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO73_MSP0_TFS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO74_MSP0_SCK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO75_MSP1_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO76_MSP1_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO77_MSP1_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO78_MSP1_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO79_MSP2_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO80_MSP2_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO81_MSP2_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO82_MSP2_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO83_MSP3_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO84_MSP3_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO85_MSP3_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO86_MSP3_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO87_MSP4_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO88_MSP4_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO89_MSP4_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO90_MSP4_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO91_MSP5_CK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO92_MSP5_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO93_MSP5_FS] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO94_MSP5_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO95_SDIO3_DAT3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO96_SDIO3_DAT2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO97_SDIO3_DAT1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO98_SDIO3_DAT0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO99_SDIO3_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO100_SDIO3_CMD] =		PINMUX_TYPE_FUNCTION,
+		/* 101..104: gpio only */
+	[STA2X11_GPIO105_SDIO2_DAT3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO106_SDIO2_DAT2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO107_SDIO2_DAT1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO108_SDIO2_DAT0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO109_SDIO2_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO110_SDIO2_CMD] =		PINMUX_TYPE_FUNCTION,
+		/* 111..114: gpio only */
+	[STA2X11_GPIO115_SDIO1_DAT3] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO116_SDIO1_DAT2] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO117_SDIO1_DAT1] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO118_SDIO1_DAT0] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO119_SDIO1_CLK] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO120_SDIO1_CMD] =		PINMUX_TYPE_FUNCTION,
+		/* 121..124: gpio only */
+	[STA2X11_GPIO125_UART2_TXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO126_UART2_RXD] =		PINMUX_TYPE_FUNCTION,
+	[STA2X11_GPIO127_UART3_TXD] =		PINMUX_TYPE_FUNCTION,
+	}
+};
+
+struct sta2x11_board steval_board = {
+	.name = "steval",
+	.config_data = {
+		[GPIO] =	&steval_gpio,
+	},
+};
+
+DECLARE_STA2X11_BOARD(steval_board);
-- 
1.7.7.2
