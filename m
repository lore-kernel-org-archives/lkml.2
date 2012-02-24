Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2BXGM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:12:57 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:46793 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033Ab2BXGM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:12:56 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] Input: usbtouchscreen: add support for Data Modul EasyTouch TP 72037
Date: Fri, 24 Feb 2012 11:22:38 +0530
Message-ID: <1df92b173fb58c4b6d3091c3eb94d53bf03cfa9e.1330061754.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Armando Visconti <armando.visconti@st.com>

The Data Modul TP 72037 EasyTouch controller is derived from EGALAX
controller and is capable of detecting dual contacts. Packets can be 5
bytes or 10 bytes long, depending whether one or two contacts are
detected. Format is same as EGALAX touch controller, but with x and y
coordinates inverted.

Signed-off-by: Armando Visconti <armando.visconti@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/input/touchscreen/Kconfig          |    9 ++++
 drivers/input/touchscreen/usbtouchscreen.c |   59 ++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 2b21a70..2acf16f 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -607,6 +607,7 @@ config TOUCHSCREEN_USB_COMPOSITE
 	  - JASTEC USB Touch Controller/DigiTech DTR-02U
 	  - Zytronic controllers
 	  - Elo TouchSystems 2700 IntelliTouch
+	  - EasyTouch USB Touch Controller from Data Modul
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -711,6 +712,14 @@ config TOUCHSCREEN_USB_NEXIO
 	bool "NEXIO/iNexio device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_EASYTOUCH
+	default y
+	bool "EasyTouch USB Touch controller device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+	help
+	  Say Y here if you have a EasyTouch USB Touch controller device support.
+	  If unsure, say N.
+
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 3a5ebf4..39350cc 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -17,6 +17,7 @@
  *  - Zytronic capacitive touchscreen
  *  - NEXIO/iNexio
  *  - Elo TouchSystems 2700 IntelliTouch
+ *  - EasyTouch USB Dual/Multi touch controller from Data Modul
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -140,6 +141,7 @@ enum {
 	DEVTYPE_TC45USB,
 	DEVTYPE_NEXIO,
 	DEVTYPE_ELO,
+	DEVTYPE_ETOUCH,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -245,6 +247,10 @@ static const struct usb_device_id usbtouch_devices[] = {
 	{USB_DEVICE(0x04e7, 0x0020), .driver_info = DEVTYPE_ELO},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
+	{USB_DEVICE(0x7374, 0x0001), .driver_info = DEVTYPE_ETOUCH},
+#endif
+
 	{}
 };
 
@@ -326,6 +332,47 @@ static int egalax_get_pkt_len(unsigned char *buf, int len)
 }
 #endif
 
+/*****************************************************************************
+ * EasyTouch part
+ */
+
+#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
+
+#define EGALAX_PKT_TYPE_MASK		0xFE
+#define EGALAX_PKT_TYPE_REPT		0x80
+#define EGALAX_PKT_TYPE_REPT2		0xB0
+#define EGALAX_PKT_TYPE_DIAG		0x0A
+
+static int etouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	if ((pkt[0] & EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT &&
+		(pkt[0] & EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT2)
+		return 0;
+
+	dev->x = ((pkt[1] & 0x1F) << 7) | (pkt[2] & 0x7F);
+	dev->y = ((pkt[3] & 0x1F) << 7) | (pkt[4] & 0x7F);
+	dev->touch = pkt[0] & 0x01;
+
+	return 1;
+}
+
+static int etouch_get_pkt_len(unsigned char *buf, int len)
+{
+	switch (buf[0] & EGALAX_PKT_TYPE_MASK) {
+	case EGALAX_PKT_TYPE_REPT:
+	case EGALAX_PKT_TYPE_REPT2:
+		return 5;
+
+	case EGALAX_PKT_TYPE_DIAG:
+		if (len < 2)
+			return -1;
+
+		return buf[1] + 2;
+	}
+
+	return 0;
+}
+#endif
 
 /*****************************************************************************
  * PanJit Part
@@ -1175,6 +1222,18 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.exit		= nexio_exit,
 	},
 #endif
+#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
+	[DEVTYPE_ETOUCH] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x07ff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x07ff,
+		.rept_size	= 16,
+		.process_pkt	= usbtouch_process_multi,
+		.get_pkt_len	= etouch_get_pkt_len,
+		.read_data	= etouch_read_data,
+	},
+#endif
 };
 
 
-- 
1.7.8.110.g4cb5d

