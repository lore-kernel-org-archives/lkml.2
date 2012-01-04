Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2ADUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:01:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:37352 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab2ADUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:01:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: alan@linux.intel.com, gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: relocate remaining serial drivers from tty/ to tty/serial/
Date: Wed,  4 Jan 2012 15:01:27 -0500
Message-Id: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8,

   "tty: move drivers/serial/ to drivers/tty/serial/"

put most of the serial drivers together in one place, but the ones
that were hiding in drivers/char didn't get picked up in that change.

They did get moved in commit a6afd9f3e819de4795fcd356e5bfad446e4323f2

   "tty: move a number of tty drivers from drivers/char/ to drivers/tty/"

but there was no distinction of serial vs. non-serial in the above.

Here we take the remaining serial drivers (mostly legacy multiport
drivers) and put them alongside all the others in tty/serial/ dir.

We can drop SERIAL_NONSTANDARD's dependency on HAS_IOMEM, since the
encompassing menu block already has that dependency called out.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/Kconfig                    |  129 --------------------------------
 drivers/tty/Makefile                   |    9 --
 drivers/tty/serial/Kconfig             |  128 +++++++++++++++++++++++++++++++
 drivers/tty/serial/Makefile            |   11 +++
 drivers/tty/{ => serial}/amiserial.c   |    0
 drivers/tty/{ => serial}/cyclades.c    |    0
 drivers/tty/{ => serial}/isicom.c      |    0
 drivers/tty/{ => serial}/moxa.c        |    0
 drivers/tty/{ => serial}/moxa.h        |    0
 drivers/tty/{ => serial}/mxser.c       |    0
 drivers/tty/{ => serial}/mxser.h       |    0
 drivers/tty/{ => serial}/rocket.c      |    0
 drivers/tty/{ => serial}/rocket.h      |    0
 drivers/tty/{ => serial}/rocket_int.h  |    0
 drivers/tty/{ => serial}/synclink.c    |    0
 drivers/tty/{ => serial}/synclink_gt.c |    0
 drivers/tty/{ => serial}/synclinkmp.c  |    0
 17 files changed, 139 insertions(+), 138 deletions(-)
 rename drivers/tty/{ => serial}/amiserial.c (100%)
 rename drivers/tty/{ => serial}/cyclades.c (100%)
 rename drivers/tty/{ => serial}/isicom.c (100%)
 rename drivers/tty/{ => serial}/moxa.c (100%)
 rename drivers/tty/{ => serial}/moxa.h (100%)
 rename drivers/tty/{ => serial}/mxser.c (100%)
 rename drivers/tty/{ => serial}/mxser.h (100%)
 rename drivers/tty/{ => serial}/rocket.c (100%)
 rename drivers/tty/{ => serial}/rocket.h (100%)
 rename drivers/tty/{ => serial}/rocket_int.h (100%)
 rename drivers/tty/{ => serial}/synclink.c (100%)
 rename drivers/tty/{ => serial}/synclink_gt.c (100%)
 rename drivers/tty/{ => serial}/synclinkmp.c (100%)

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index b3d1741..fe9bf59 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -164,125 +164,6 @@ config BFIN_JTAG_COMM_CONSOLE
 	bool "Console on Blackfin JTAG"
 	depends on BFIN_JTAG_COMM=y
 
-config SERIAL_NONSTANDARD
-	bool "Non-standard serial port support"
-	depends on HAS_IOMEM
-	---help---
-	  Say Y here if you have any non-standard serial boards -- boards
-	  which aren't supported using the standard "dumb" serial driver.
-	  This includes intelligent serial boards such as Cyclades,
-	  Digiboards, etc. These are usually used for systems that need many
-	  serial ports because they serve many terminals or dial-in
-	  connections.
-
-	  Note that the answer to this question won't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about non-standard serial boards.
-
-	  Most people can say N here.
-
-config ROCKETPORT
-	tristate "Comtrol RocketPort support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
-	help
-	  This driver supports Comtrol RocketPort and RocketModem PCI boards.   
-          These boards provide 2, 4, 8, 16, or 32 high-speed serial ports or
-          modems.  For information about the RocketPort/RocketModem  boards
-          and this driver read <file:Documentation/serial/rocket.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rocket.
-
-	  If you want to compile this driver into the kernel, say Y here.  If
-          you don't have a Comtrol RocketPort/RocketModem card installed, say N.
-
-config CYCLADES
-	tristate "Cyclades async mux support"
-	depends on SERIAL_NONSTANDARD && (PCI || ISA)
-	select FW_LOADER
-	---help---
-	  This driver supports Cyclades Z and Y multiserial boards.
-	  You would need something like this to connect more than two modems to
-	  your Linux box, for instance in order to become a dial-in server.
-
-	  For information about the Cyclades-Z card, read
-	  <file:Documentation/serial/README.cycladesZ>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called cyclades.
-
-	  If you haven't heard about it, it's safe to say N.
-
-config CYZ_INTR
-	bool "Cyclades-Z interrupt mode operation (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && CYCLADES
-	help
-	  The Cyclades-Z family of multiport cards allows 2 (two) driver op
-	  modes: polling and interrupt. In polling mode, the driver will check
-	  the status of the Cyclades-Z ports every certain amount of time
-	  (which is called polling cycle and is configurable). In interrupt
-	  mode, it will use an interrupt line (IRQ) in order to check the
-	  status of the Cyclades-Z ports. The default op mode is polling. If
-	  unsure, say N.
-
-config MOXA_INTELLIO
-	tristate "Moxa Intellio support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
-	select FW_LOADER
-	help
-	  Say Y here if you have a Moxa Intellio multiport serial card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called moxa.
-
-config MOXA_SMARTIO
-	tristate "Moxa SmartIO support v. 2.0"
-	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
-	help
-	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
-	  want to help develop a new version of this driver.
-
-	  This is upgraded (1.9.1) driver from original Moxa drivers with
-	  changes finally resulting in PCI probing.
-
-	  This driver can also be built as a module. The module will be called
-	  mxser. If you want to do that, say M here.
-
-config SYNCLINK
-	tristate "Microgate SyncLink card support"
-	depends on SERIAL_NONSTANDARD && PCI && ISA_DMA_API
-	help
-	  Provides support for the SyncLink ISA and PCI multiprotocol serial
-	  adapters. These adapters support asynchronous and HDLC bit
-	  synchronous communication up to 10Mbps (PCI adapter).
-
-	  This driver can only be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called synclink.  If you want to do that, say M
-	  here.
-
-config SYNCLINKMP
-	tristate "SyncLink Multiport support"
-	depends on SERIAL_NONSTANDARD && PCI
-	help
-	  Enable support for the SyncLink Multiport (2 or 4 ports)
-	  serial adapter, running asynchronous and HDLC communications up
-	  to 2.048Mbps. Each ports is independently selectable for
-	  RS-232, V.35, RS-449, RS-530, and X.21
-
-	  This driver may be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called synclinkmp.  If you want to do that, say M
-	  here.
-
-config SYNCLINK_GT
-	tristate "SyncLink GT/AC support"
-	depends on SERIAL_NONSTANDARD && PCI
-	help
-	  Support for SyncLink GT and SyncLink AC families of
-	  synchronous and asynchronous serial adapters
-	  manufactured by Microgate Systems, Ltd. (www.microgate.com)
-
 config NOZOMI
 	tristate "HSDPA Broadband Wireless Data Card - Globe Trotter"
 	depends on PCI && EXPERIMENTAL
@@ -293,16 +174,6 @@ config NOZOMI
 	  To compile this driver as a module, choose M here, the module
 	  will be called nozomi.
 
-config ISI
-	tristate "Multi-Tech multiport card support (EXPERIMENTAL)"
-	depends on SERIAL_NONSTANDARD && PCI
-	select FW_LOADER
-	help
-	  This is a driver for the Multi-Tech cards which provide several
-	  serial ports.  The driver is experimental and can currently only be
-	  built as a module. The module will be called isicom.
-	  If you want to do that, choose M here.
-
 config N_HDLC
 	tristate "HDLC line discipline support"
 	depends on SERIAL_NONSTANDARD
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 2953059..b5ce64b 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -15,17 +15,8 @@ obj-$(CONFIG_HVC_DRIVER)	+= hvc/
 obj-y				+= serial/
 
 # tty drivers
-obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
-obj-$(CONFIG_CYCLADES)		+= cyclades.o
-obj-$(CONFIG_ISI)		+= isicom.o
-obj-$(CONFIG_MOXA_INTELLIO)	+= moxa.o
-obj-$(CONFIG_MOXA_SMARTIO)	+= mxser.o
 obj-$(CONFIG_NOZOMI)		+= nozomi.o
-obj-$(CONFIG_ROCKETPORT)	+= rocket.o
-obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
-obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
-obj-$(CONFIG_SYNCLINK)		+= synclink.o
 obj-$(CONFIG_PPC_EPAPR_HV_BYTECHAN) += ehv_bytechan.o
 
 obj-y += ipwireless/
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 925a1e5..ab117ad 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1610,4 +1610,132 @@ config SERIAL_XILINX_PS_UART_CONSOLE
 	help
 	  Enable a Xilinx PS UART port to be the system console.
 
+config SERIAL_NONSTANDARD
+	bool "Non-standard serial port support"
+	---help---
+	  Say Y here if you have any non-standard serial boards -- boards
+	  which aren't supported using the standard "dumb" serial driver.
+	  This includes intelligent serial boards such as Cyclades,
+	  Digiboards, etc. These are usually used for systems that need many
+	  serial ports because they serve many terminals or dial-in
+	  connections.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about non-standard serial boards.
+
+	  Most people can say N here.
+
+config ROCKETPORT
+	tristate "Comtrol RocketPort support"
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	help
+	  This driver supports Comtrol RocketPort and RocketModem PCI boards.
+          These boards provide 2, 4, 8, 16, or 32 high-speed serial ports or
+          modems.  For information about the RocketPort/RocketModem  boards
+          and this driver read <file:Documentation/serial/rocket.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rocket.
+
+	  If you want to compile this driver into the kernel, say Y here.  If
+          you don't have a Comtrol RocketPort/RocketModem card installed, say N.
+
+config CYCLADES
+	tristate "Cyclades async mux support"
+	depends on SERIAL_NONSTANDARD && (PCI || ISA)
+	select FW_LOADER
+	---help---
+	  This driver supports Cyclades Z and Y multiserial boards.
+	  You would need something like this to connect more than two modems to
+	  your Linux box, for instance in order to become a dial-in server.
+
+	  For information about the Cyclades-Z card, read
+	  <file:Documentation/serial/README.cycladesZ>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyclades.
+
+	  If you haven't heard about it, it's safe to say N.
+
+config CYZ_INTR
+	bool "Cyclades-Z interrupt mode operation (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && CYCLADES
+	help
+	  The Cyclades-Z family of multiport cards allows 2 (two) driver op
+	  modes: polling and interrupt. In polling mode, the driver will check
+	  the status of the Cyclades-Z ports every certain amount of time
+	  (which is called polling cycle and is configurable). In interrupt
+	  mode, it will use an interrupt line (IRQ) in order to check the
+	  status of the Cyclades-Z ports. The default op mode is polling. If
+	  unsure, say N.
+
+config MOXA_INTELLIO
+	tristate "Moxa Intellio support"
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	select FW_LOADER
+	help
+	  Say Y here if you have a Moxa Intellio multiport serial card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called moxa.
+
+config MOXA_SMARTIO
+	tristate "Moxa SmartIO support v. 2.0"
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
+	help
+	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
+	  want to help develop a new version of this driver.
+
+	  This is upgraded (1.9.1) driver from original Moxa drivers with
+	  changes finally resulting in PCI probing.
+
+	  This driver can also be built as a module. The module will be called
+	  mxser. If you want to do that, say M here.
+
+config SYNCLINK
+	tristate "Microgate SyncLink card support"
+	depends on SERIAL_NONSTANDARD && PCI && ISA_DMA_API
+	help
+	  Provides support for the SyncLink ISA and PCI multiprotocol serial
+	  adapters. These adapters support asynchronous and HDLC bit
+	  synchronous communication up to 10Mbps (PCI adapter).
+
+	  This driver can only be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called synclink.  If you want to do that, say M
+	  here.
+
+config SYNCLINKMP
+	tristate "SyncLink Multiport support"
+	depends on SERIAL_NONSTANDARD && PCI
+	help
+	  Enable support for the SyncLink Multiport (2 or 4 ports)
+	  serial adapter, running asynchronous and HDLC communications up
+	  to 2.048Mbps. Each ports is independently selectable for
+	  RS-232, V.35, RS-449, RS-530, and X.21
+
+	  This driver may be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called synclinkmp.  If you want to do that, say M
+	  here.
+
+config SYNCLINK_GT
+	tristate "SyncLink GT/AC support"
+	depends on SERIAL_NONSTANDARD && PCI
+	help
+	  Support for SyncLink GT and SyncLink AC families of
+	  synchronous and asynchronous serial adapters
+	  manufactured by Microgate Systems, Ltd. (www.microgate.com)
+
+config ISI
+	tristate "Multi-Tech multiport card support (EXPERIMENTAL)"
+	depends on SERIAL_NONSTANDARD && PCI
+	select FW_LOADER
+	help
+	  This is a driver for the Multi-Tech cards which provide several
+	  serial ports.  The driver is experimental and can currently only be
+	  built as a module. The module will be called isicom.
+	  If you want to do that, choose M here.
+
 endmenu
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index e10cf5b..da4b608 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -94,3 +94,14 @@ obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
 obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
 obj-$(CONFIG_SERIAL_LANTIQ)	+= lantiq.o
 obj-$(CONFIG_SERIAL_XILINX_PS_UART) += xilinx_uartps.o
+obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
+
+# Stuff depending on SERIAL_NONSTANDARD; mostly legacy multiport cards.
+obj-$(CONFIG_CYCLADES)			+= cyclades.o
+obj-$(CONFIG_ISI)			+= isicom.o
+obj-$(CONFIG_MOXA_INTELLIO)		+= moxa.o
+obj-$(CONFIG_MOXA_SMARTIO)		+= mxser.o
+obj-$(CONFIG_ROCKETPORT)		+= rocket.o
+obj-$(CONFIG_SYNCLINK_GT)		+= synclink_gt.o
+obj-$(CONFIG_SYNCLINKMP)		+= synclinkmp.o
+obj-$(CONFIG_SYNCLINK)			+= synclink.o
diff --git a/drivers/tty/amiserial.c b/drivers/tty/serial/amiserial.c
similarity index 100%
rename from drivers/tty/amiserial.c
rename to drivers/tty/serial/amiserial.c
diff --git a/drivers/tty/cyclades.c b/drivers/tty/serial/cyclades.c
similarity index 100%
rename from drivers/tty/cyclades.c
rename to drivers/tty/serial/cyclades.c
diff --git a/drivers/tty/isicom.c b/drivers/tty/serial/isicom.c
similarity index 100%
rename from drivers/tty/isicom.c
rename to drivers/tty/serial/isicom.c
diff --git a/drivers/tty/moxa.c b/drivers/tty/serial/moxa.c
similarity index 100%
rename from drivers/tty/moxa.c
rename to drivers/tty/serial/moxa.c
diff --git a/drivers/tty/moxa.h b/drivers/tty/serial/moxa.h
similarity index 100%
rename from drivers/tty/moxa.h
rename to drivers/tty/serial/moxa.h
diff --git a/drivers/tty/mxser.c b/drivers/tty/serial/mxser.c
similarity index 100%
rename from drivers/tty/mxser.c
rename to drivers/tty/serial/mxser.c
diff --git a/drivers/tty/mxser.h b/drivers/tty/serial/mxser.h
similarity index 100%
rename from drivers/tty/mxser.h
rename to drivers/tty/serial/mxser.h
diff --git a/drivers/tty/rocket.c b/drivers/tty/serial/rocket.c
similarity index 100%
rename from drivers/tty/rocket.c
rename to drivers/tty/serial/rocket.c
diff --git a/drivers/tty/rocket.h b/drivers/tty/serial/rocket.h
similarity index 100%
rename from drivers/tty/rocket.h
rename to drivers/tty/serial/rocket.h
diff --git a/drivers/tty/rocket_int.h b/drivers/tty/serial/rocket_int.h
similarity index 100%
rename from drivers/tty/rocket_int.h
rename to drivers/tty/serial/rocket_int.h
diff --git a/drivers/tty/synclink.c b/drivers/tty/serial/synclink.c
similarity index 100%
rename from drivers/tty/synclink.c
rename to drivers/tty/serial/synclink.c
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/serial/synclink_gt.c
similarity index 100%
rename from drivers/tty/synclink_gt.c
rename to drivers/tty/serial/synclink_gt.c
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/serial/synclinkmp.c
similarity index 100%
rename from drivers/tty/synclinkmp.c
rename to drivers/tty/serial/synclinkmp.c
-- 
1.7.7

