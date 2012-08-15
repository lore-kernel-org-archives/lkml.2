Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2HOUfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:35:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62765 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab2HOTtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 021/165] USB: ftdi_sio: add Calao reference board support
Date: Wed, 15 Aug 2012 15:46:05 -0400
Message-ID: <1345060109-9187-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c7e4fb8..e8bc908 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -105,6 +105,7 @@ static int   ftdi_jtag_probe(struct usb_serial *serial);
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
 static int   ftdi_stmclite_probe(struct usb_serial *serial);
+static int   ftdi_8u2232c_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -132,6 +133,10 @@ static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
 	.probe	= ftdi_stmclite_probe,
 };
 
+static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
+	.probe	= ftdi_8u2232c_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -181,7 +186,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_8U232AM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_8U232AM_ALT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_232RL_PID) },
-	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) ,
+		.driver_info = (kernel_ulong_t)&ftdi_8u2232c_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_4232H_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MICRO_CHAMELEON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RELAIS_PID) },
@@ -1749,6 +1755,18 @@ static int ftdi_jtag_probe(struct usb_serial *serial)
 	return 0;
 }
 
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
+
 /*
  * First and second port on STMCLiteadaptors is reserved for JTAG interface
  * and the forth port for pio
-- 
1.7.12.rc2

