Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab2EVAMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:12:25 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:15800 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2EVAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:12:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1337645541!6290272!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove private header comedi_pci.h
Date: Mon, 21 May 2012 17:12:12 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205211712.12753.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the private header, comedi_pci.h, by moving the two
helper functions into divers.c and providing the prototypes
in comedidev.h.

This allows the comedi_pci_enable/disable helper functions
to be shared instead of having an inline version in every
comedi pci driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

Note: The pci helper functions are all defined as stubs in
pci.h when CONFIG_PCI is not enabled.

 drivers/staging/comedi/comedidev.h                 |    5 +-
 drivers/staging/comedi/drivers.c                   |   34 +++++++++++
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    2 -
 drivers/staging/comedi/drivers/adl_pci6208.c       |    1 -
 drivers/staging/comedi/drivers/adl_pci7230.c       |    1 -
 drivers/staging/comedi/drivers/adl_pci7296.c       |    1 -
 drivers/staging/comedi/drivers/adl_pci7432.c       |    1 -
 drivers/staging/comedi/drivers/adl_pci8164.c       |    1 -
 drivers/staging/comedi/drivers/adl_pci9111.c       |    1 -
 drivers/staging/comedi/drivers/adl_pci9118.c       |    1 -
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 -
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 -
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    1 -
 drivers/staging/comedi/drivers/amplc_dio200.c      |    2 -
 drivers/staging/comedi/drivers/amplc_pc236.c       |    2 -
 drivers/staging/comedi/drivers/amplc_pc263.c       |    2 -
 drivers/staging/comedi/drivers/amplc_pci224.c      |    2 -
 drivers/staging/comedi/drivers/amplc_pci230.c      |    1 -
 drivers/staging/comedi/drivers/cb_pcidas.c         |    1 -
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    1 -
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 -
 drivers/staging/comedi/drivers/cb_pcidio.c         |    1 -
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    1 -
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    2 -
 drivers/staging/comedi/drivers/comedi_pci.h        |   60 --------------------
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    2 -
 drivers/staging/comedi/drivers/daqboard2000.c      |    1 -
 drivers/staging/comedi/drivers/das08.c             |    1 -
 drivers/staging/comedi/drivers/dt3000.c            |    2 -
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    1 -
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    1 -
 drivers/staging/comedi/drivers/icp_multi.h         |    1 -
 drivers/staging/comedi/drivers/jr3_pci.c           |    1 -
 drivers/staging/comedi/drivers/ke_counter.c        |    2 -
 drivers/staging/comedi/drivers/me4000.c            |    1 -
 drivers/staging/comedi/drivers/me_daq.c            |    2 -
 drivers/staging/comedi/drivers/mite.c              |    1 -
 drivers/staging/comedi/drivers/rtd520.c            |    1 -
 drivers/staging/comedi/drivers/s626.c              |    2 -
 39 files changed, 37 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 134be93..9cd2b51 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -40,6 +40,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/timer.h>
+#include <linux/pci.h>
 
 #include "comedi.h"
 
@@ -180,7 +181,6 @@ struct comedi_async {
 			unsigned int x);
 };
 
-struct pci_dev;
 struct usb_interface;
 
 struct comedi_driver {
@@ -310,7 +310,8 @@ int comedi_driver_unregister(struct comedi_driver *);
 	module_driver(__comedi_driver, comedi_driver_register, \
 			comedi_driver_unregister)
 
-struct pci_driver;
+int comedi_pci_enable(struct pci_dev *, const char *);
+void comedi_pci_disable(struct pci_dev *);
 
 int comedi_pci_driver_register(struct comedi_driver *, struct pci_driver *);
 void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 1c3d638..7289dcb 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -908,6 +908,40 @@ static void comedi_auto_unconfig(struct device *hardware_device)
 	comedi_free_board_minor(minor);
 }
 
+/**
+ * comedi_pci_enable() - Enable the PCI device and request the regions.
+ * @pdev: pci_dev struct
+ * @res_name: name for the requested reqource
+ */
+int comedi_pci_enable(struct pci_dev *pdev, const char *res_name)
+{
+	int rc;
+
+	rc = pci_enable_device(pdev);
+	if (rc < 0)
+		return rc;
+
+	rc = pci_request_regions(pdev, res_name);
+	if (rc < 0)
+		pci_disable_device(pdev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(comedi_pci_enable);
+
+/**
+ * comedi_pci_disable() - Release the regions and disable the PCI device.
+ * @pdev: pci_dev struct
+ *
+ * This must be matched with a previous successful call to comedi_pci_enable().
+ */
+void comedi_pci_disable(struct pci_dev *pdev)
+{
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+EXPORT_SYMBOL_GPL(comedi_pci_disable);
+
 static int comedi_old_pci_auto_config(struct pci_dev *pcidev,
 				      struct comedi_driver *driver)
 {
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
index 35a3ea1..d70ac8b 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -22,8 +22,6 @@
 
 #include "../../comedidev.h"
 
-#include "../comedi_pci.h"
-
 #ifdef PCI_SUPPORT_VER1
 #error     No support for 2.1.55 and older
 #endif
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index de8c68a..2f48dc7 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -52,7 +52,6 @@ References:
  * options that are used with comedi_config.
  */
 #include "../comedidev.h"
-#include "comedi_pci.h"
 
 /* Board descriptions */
 struct pci6208_board {
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index e8053bc..e7eb229 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -36,7 +36,6 @@ Configuration Options:
 
 #include "../comedidev.h"
 #include <linux/kernel.h>
-#include "comedi_pci.h"
 
 #define PCI7230_DI      0x00
 #define PCI7230_DO	    0x00
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index b4dae3b..bf2f7fb 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -37,7 +37,6 @@ Configuration Options:
 #include "../comedidev.h"
 #include <linux/kernel.h>
 
-#include "comedi_pci.h"
 #include "8255.h"
 /* #include "8253.h" */
 
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 9cbfb61..2fc1dbb 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -36,7 +36,6 @@ Configuration Options:
 
 #include "../comedidev.h"
 #include <linux/kernel.h>
-#include "comedi_pci.h"
 
 #define PCI7432_DI      0x00
 #define PCI7432_DO	    0x00
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 409ef13..fbc859e 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -38,7 +38,6 @@ Configuration Options:
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include "comedi_fc.h"
-#include "comedi_pci.h"
 #include "8253.h"
 
 #define PCI8164_AXIS_X  0x00
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index ccfb1a5..308cca7 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -81,7 +81,6 @@ TODO:
 #include <linux/interrupt.h>
 
 #include "8253.h"
-#include "comedi_pci.h"
 #include "comedi_fc.h"
 
 #define PCI9111_DRIVER_NAME	"adl_pci9111"
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 7864586..aa4244e 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -71,7 +71,6 @@ Configuration options:
 
 #include "amcc_s5933.h"
 #include "8253.h"
-#include "comedi_pci.h"
 #include "comedi_fc.h"
 
 #define PCI_VENDOR_ID_AMCC	0x10e8
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index de8c98c..db9f0a5 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -45,8 +45,6 @@ Configuration options:
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #include "8253.h"
 #include "amcc_s5933.h"
 
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 336addc..b8768b5 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -50,8 +50,6 @@ TODO:
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe	/* Advantech PCI vendor ID */
 
 /* hardware types of the cards */
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 43a32dc..df8236c 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -33,7 +33,6 @@ Configuration options:
 
 #include <linux/delay.h>
 
-#include "comedi_pci.h"
 #include "8255.h"
 #include "8253.h"
 
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index c9c5d97..f6f6144 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -210,8 +210,6 @@ order they appear in the channel list.
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #include "8255.h"
 #include "8253.h"
 
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 57ba322..6cb06ec 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -56,8 +56,6 @@ unused.
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #include "8255.h"
 #include "plx9052.h"
 
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 974d745..086579f 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -46,8 +46,6 @@ The state of the outputs can be read.
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #define PC263_DRIVER_NAME	"amplc_pc263"
 
 #ifdef CONFIG_COMEDI_AMPLC_PC263_ISA_MODULE
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index fbf19ca..0d1f9cc 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -108,8 +108,6 @@ Caveats:
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #include "comedi_fc.h"
 #include "8253.h"
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index d4c80b1..b05a684 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -193,7 +193,6 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include "comedi_pci.h"
 #include "8253.h"
 #include "8255.h"
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index ee9e084..7f88d08 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -77,7 +77,6 @@ analog triggering on 1602 series
 #include "8253.h"
 #include "8255.h"
 #include "amcc_s5933.h"
-#include "comedi_pci.h"
 #include "comedi_fc.h"
 
 #undef CB_PCIDAS_DEBUG		/*  disable debugging code */
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 9d0b875..1e30f22 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -87,7 +87,6 @@ TODO:
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include "comedi_pci.h"
 #include "8253.h"
 #include "8255.h"
 #include "plx9080.h"
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 25ebca1..dc4cf0b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -48,10 +48,8 @@ Please report success/failure with other different cards to
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
 #include "8255.h"
 
-
 /* PCI vendor number of ComputerBoards */
 #define PCI_VENDOR_ID_CB        0x1307
 #define EEPROM_SIZE	128	/*  number of entries in eeprom */
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 713132c..58d5a3d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -41,7 +41,6 @@ Passing a zero for an option is the same as leaving it unspecified.
 
 /*------------------------------ HEADER FILES ---------------------------------*/
 #include "../comedidev.h"
-#include "comedi_pci.h"
 #include "8255.h"
 
 /*-------------------------- MACROS and DATATYPES -----------------------------*/
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 5f834d0..a06b67a 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -45,7 +45,6 @@ See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include "comedi_pci.h"
 #include "plx9052.h"
 #include "8255.h"
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index b339685..bec250b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -86,8 +86,6 @@ Configuration Options:
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #include "8255.h"
 
 /* device ids of the cards we support -- currently only 1 card supported */
diff --git a/drivers/staging/comedi/drivers/comedi_pci.h b/drivers/staging/comedi/drivers/comedi_pci.h
deleted file mode 100644
index c14a036..0000000
--- a/drivers/staging/comedi/drivers/comedi_pci.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
-    comedi/drivers/comedi_pci.h
-    Various PCI functions for drivers.
-
-    Copyright (C) 2007 MEV Ltd. <http://www.mev.co.uk/>
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-*/
-
-#ifndef _COMEDI_PCI_H_
-#define _COMEDI_PCI_H_
-
-#include <linux/pci.h>
-
-/*
- * Enable the PCI device and request the regions.
- */
-static inline int comedi_pci_enable(struct pci_dev *pdev, const char *res_name)
-{
-	int rc;
-
-	rc = pci_enable_device(pdev);
-	if (rc < 0)
-		return rc;
-
-	rc = pci_request_regions(pdev, res_name);
-	if (rc < 0)
-		pci_disable_device(pdev);
-
-	return rc;
-}
-
-/*
- * Release the regions and disable the PCI device.
- *
- * This must be matched with a previous successful call to comedi_pci_enable().
- */
-static inline void comedi_pci_disable(struct pci_dev *pdev)
-{
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-}
-
-#endif
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index b8bac80..2cd7407 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -36,8 +36,6 @@ Configuration Options:
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 enum contec_model {
 	PIO1616L = 0,
 };
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 696b58c..d84794c 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -118,7 +118,6 @@ Configuration options:
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include "comedi_pci.h"
 #include "8255.h"
 
 #define DAQBOARD2000_SUBSYSTEM_IDS2 	0x00021616	/* Daqboard/2000 - 2 Dacs */
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 1f31943..f53e597 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -55,7 +55,6 @@
 
 #include <linux/delay.h>
 
-#include "comedi_pci.h"
 #include "8255.h"
 #include "das08.h"
 
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 0d27326..2c1c6140 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -63,8 +63,6 @@ AO commands are not supported.
 #include "../comedidev.h"
 #include <linux/delay.h>
 
-#include "comedi_pci.h"
-
 #define PCI_VENDOR_ID_DT	0x1116
 
 static const struct comedi_lrange range_dt3000_ai = { 4, {
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index b0cec7b..9586f24 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -38,7 +38,6 @@
 */
 
 #include "../comedidev.h"
-#include "comedi_pci.h"
 #include <linux/mutex.h>
 
 #define PCI_VENDOR_ID_DYNALOG		0x10b5
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 8aece08..79e22b1 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -49,7 +49,6 @@ support could be added to this driver.
 #include "../comedidev.h"
 #include <linux/delay.h>
 
-#include "comedi_pci.h"
 #include "plx9080.h"
 #include "comedi_fc.h"
 
diff --git a/drivers/staging/comedi/drivers/icp_multi.h b/drivers/staging/comedi/drivers/icp_multi.h
index 68acefe..dbf9908 100644
--- a/drivers/staging/comedi/drivers/icp_multi.h
+++ b/drivers/staging/comedi/drivers/icp_multi.h
@@ -11,7 +11,6 @@
 #define _ICP_MULTI_H_
 
 #include "../comedidev.h"
-#include "comedi_pci.h"
 
 /****************************************************************************/
 
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index d536a11..e8dfc36 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -49,7 +49,6 @@ Devices: [JR3] PCI force sensor board (jr3_pci)
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/kernel.h>
-#include "comedi_pci.h"
 #include "jr3_pci.h"
 
 #define PCI_VENDOR_ID_JR3 0x1762
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 09d1918..9f92420 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -40,8 +40,6 @@ Kolter Electronic PCI Counter Card.
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #define CNT_DRIVER_NAME         "ke_counter"
 #define PCI_VENDOR_ID_KOLTER    0x1001
 #define CNT_CARD_DEVICE_ID      0x0014
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 8ca1b54..cb6bf8c 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -58,7 +58,6 @@ broken.
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
-#include "comedi_pci.h"
 #include "me4000.h"
 #if 0
 /* file removed due to GPL incompatibility */
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index ffe2512..fcadb0f 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -54,8 +54,6 @@ from http://www.comedi.org
 #include <linux/sched.h>
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 /*#include "me2600_fw.h" */
 
 #define ME_DRIVER_NAME		"me_daq"
diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
index 13e9c80..a93166d 100644
--- a/drivers/staging/comedi/drivers/mite.c
+++ b/drivers/staging/comedi/drivers/mite.c
@@ -52,7 +52,6 @@
 #include "mite.h"
 
 #include "comedi_fc.h"
-#include "comedi_pci.h"
 #include "../comedidev.h"
 
 
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 1678a0c..d3e2786 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -105,7 +105,6 @@ Configuration options:
 #include <linux/delay.h>
 
 #include "../comedidev.h"
-#include "comedi_pci.h"
 
 #define DRV_NAME "rtd520"
 
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 7beb8f6..5160370 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -74,8 +74,6 @@ INSN_CONFIG instructions:
 
 #include "../comedidev.h"
 
-#include "comedi_pci.h"
-
 #include "comedi_fc.h"
 #include "s626.h"
 
