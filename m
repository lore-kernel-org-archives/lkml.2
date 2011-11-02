Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1KCBeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:34:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab1KCBeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:50 2011
Message-Id: <20111102221450.161845440@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [001/107] USB: ftdi_sio: add Calao reference board support
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit c96fbdd0ab97235f930ebf24b38fa42a2e3458cf upstream.

Calao use on there dev kits a FT2232 where the port 0 is used for the JTAG and
port 1 for the UART

They use the same VID and PID as FTDI Chip but they program the manufacturer
name in the eeprom

So use this information to detect it

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -105,6 +105,7 @@ static int   ftdi_jtag_probe(struct usb_
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
 static int   ftdi_stmclite_probe(struct usb_serial *serial);
+static int   ftdi_8u2232c_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -132,6 +133,10 @@ static struct ftdi_sio_quirk ftdi_stmcli
 	.probe	= ftdi_stmclite_probe,
 };
 
+static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
+	.probe	= ftdi_8u2232c_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -181,7 +186,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_8U232AM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_8U232AM_ALT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_232RL_PID) },
-	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) ,
+		.driver_info = (kernel_ulong_t)&ftdi_8u2232c_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_4232H_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MICRO_CHAMELEON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RELAIS_PID) },
@@ -1761,6 +1767,18 @@ static int ftdi_jtag_probe(struct usb_se
 
 	return 0;
 }
+
+static int ftdi_8u2232c_probe(struct usb_serial *serial)
+{
+	struct usb_device *udev = serial->dev;
+
+	dbg("%s", __func__);
+
+	if (strcmp(udev->manufacturer, "CALAO Systems") == 0)
+		return ftdi_jtag_probe(serial);
+
+	return 0;
+}
 
 /*
  * First and second port on STMCLiteadaptors is reserved for JTAG interface


