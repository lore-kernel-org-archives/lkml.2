Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2ECMlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:41:47 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:59241 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754649Ab2ECMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:41:46 -0400
Date: Thu, 3 May 2012 18:11:40 +0530
From: Rupjyoti Sarmah <rsarmah@amcc.com>
Message-Id: <201205031241.q43Cfer9028909@amcc.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v16 09/10]USB/ppc4xx: Add Synopsys DWC OTG driver kernel configuration and Makefile
Cc: rsarmah@apm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Synopsys DesignWare HS USB OTG driver kernel configuration.
Synopsys OTG driver may operate in  host only, device only, or OTG mode.
The driver also allows user configure the core to use its internal DMA
or Slave (PIO) mode.

Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
Signed-off-by: Tirumala R Marri <tmarri@apm.com>
Signed-off-by: Fushen Chen <fchen@apm.com>
Signed-off-by: Mark Miesfeld <mmiesfeld@apm.com>
---
 drivers/Makefile         |    1 +
 drivers/usb/Kconfig      |    2 +
 drivers/usb/dwc/Kconfig  |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/dwc/Makefile |   19 ++++++++++
 4 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/dwc/Kconfig
 create mode 100644 drivers/usb/dwc/Makefile

diff --git a/drivers/Makefile b/drivers/Makefile
index 262b19d..bae5eb9 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_PARIDE) 		+= block/paride/
 obj-$(CONFIG_TC)		+= tc/
 obj-$(CONFIG_UWB)		+= uwb/
 obj-$(CONFIG_USB_OTG_UTILS)	+= usb/
+obj-$(CONFIG_USB_DWC_OTG)	+= usb/dwc/
 obj-$(CONFIG_USB)		+= usb/
 obj-$(CONFIG_PCI)		+= usb/
 obj-$(CONFIG_USB_GADGET)	+= usb/
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index cbd8f5f..6812758 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -133,6 +133,8 @@ source "drivers/usb/host/Kconfig"
 
 source "drivers/usb/musb/Kconfig"
 
+source "drivers/usb/dwc/Kconfig"
+
 source "drivers/usb/renesas_usbhs/Kconfig"
 
 source "drivers/usb/class/Kconfig"
diff --git a/drivers/usb/dwc/Kconfig b/drivers/usb/dwc/Kconfig
new file mode 100644
index 0000000..eafc5ed
--- /dev/null
+++ b/drivers/usb/dwc/Kconfig
@@ -0,0 +1,84 @@
+#
+# USB Dual Role (OTG-ready) Controller Drivers
+# for silicon based on Synopsys DesignWare IP
+#
+
+comment "Enable Host or Gadget support for DesignWare OTG controller"
+	depends on !USB && USB_GADGET=n
+
+config USB_DWC_OTG
+	tristate "Synopsys DWC OTG Controller"
+	depends on USB || USB_GADGET
+	select NOP_USB_XCEIV
+	select USB_OTG_UTILS
+	default USB_GADGET
+	help
+	  This driver provides USB Device Controller support for the
+	  Synopsys DesignWare USB OTG Core used on the AppliedMicro PowerPC SoC.
+
+config DWC_DEBUG
+	bool "Enable DWC Debugging"
+	depends on USB_DWC_OTG
+	default n
+	help
+	  Enable DWC driver debugging
+
+choice
+	prompt "DWC Mode Selection"
+	depends on USB_DWC_OTG
+	default DWC_HOST_ONLY
+	help
+	  Select the DWC Core in OTG, Host only, or Device only mode.
+
+config DWC_HOST_ONLY
+	bool "DWC Host Only Mode"
+
+config DWC_OTG_MODE
+	bool "DWC OTG Mode"
+	select USB_GADGET_SELECTED
+
+config DWC_DEVICE_ONLY
+	bool "DWC Device Only Mode"
+	select USB_GADGET_SELECTED
+
+endchoice
+
+# enable peripheral support (including with OTG)
+choice
+	prompt "DWC DMA/SlaveMode Selection"
+	depends on USB_DWC_OTG
+	default DWC_DMA_MODE
+	help
+	  Select the DWC DMA or Slave Mode.
+	  DMA mode uses the DWC core internal DMA engines.
+	  Slave mode uses the processor PIO to tranfer data.
+	  In Slave mode, processor's DMA channels can be used if available.
+
+config DWC_SLAVE
+	bool "DWC Slave Mode"
+
+config DWC_DMA_MODE
+	bool "DWC DMA Mode"
+
+endchoice
+
+config DWC_OTG_REG_LE
+	bool "DWC Little Endian Register"
+	depends on USB_DWC_OTG
+	default y
+	help
+	  OTG core register access is Little-Endian.
+
+config DWC_OTG_FIFO_LE
+	bool "DWC FIFO Little Endian"
+	depends on USB_DWC_OTG
+	default n
+	help
+	  OTG core FIFO access is Little-Endian.
+
+config DWC_LIMITED_XFER_SIZE
+	bool "DWC Endpoint Limited Xfer Size"
+	depends on USB_GADGET_DWC_HDRC
+	default n
+	help
+	  Bit fields in the Device EP Transfer Size Register is 11 bits.
diff --git a/drivers/usb/dwc/Makefile b/drivers/usb/dwc/Makefile
new file mode 100644
index 0000000..4102add
--- /dev/null
+++ b/drivers/usb/dwc/Makefile
@@ -0,0 +1,19 @@
+#
+# OTG infrastructure and transceiver drivers
+#
+obj-$(CONFIG_USB_DWC_OTG)	+= dwc.o
+
+dwc-objs := cil.o cil_intr.o param.o
+
+ifeq ($(CONFIG_4xx_SOC),y)
+dwc-objs += apmppc.o
+endif
+
+ifneq ($(CONFIG_DWC_DEVICE_ONLY),y)
+dwc-objs += hcd.o hcd_intr.o \
+		hcd_queue.o
+endif
+
+ifneq ($(CONFIG_DWC_HOST_ONLY),y)
+dwc-objs += pcd.o pcd_intr.o
+endif
-- 
1.7.0.4

