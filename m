Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab0IXQMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:12:08 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:54704 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158Ab0IXQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:12:04 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 353D3D8373
Date: Fri, 24 Sep 2010 18:12:01 +0200
From: "Matthias G. Eckermann" <mge@arcor.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Anssi Hannula <anssi.hannula@gmail.com>,
        Bernhard Rosenkraenzer <bero@arklinux.org>,
        Andrew Bird <ajb@spheresytems.co.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] (qcserial.c) Enable Diagnostics Monitor and GPS ports on
 Gobi 2000
Message-ID: <20100924161201.GA10482@arcor.de>
Reply-To: "Matthias G. Eckermann" <mge@arcor.de>
Mail-Followup-To: "Matthias G. Eckermann" <mge@arcor.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Matthew Garrett <mjg@redhat.com>,
	Anssi Hannula <anssi.hannula@gmail.com>,
	Bernhard Rosenkraenzer <bero@arklinux.org>,
	Andrew Bird <ajb@spheresytems.co.uk>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Author: Matthias G. Eckermann
X-MgEFrom: patmos
X-Address: Marienburger Str. 5A, 10405 Berlin, Germany 
X-Mobile: +49 160 96 25 35 71
X-Operating-System: SUSE Linux Enterprise Server 11 (x86_64) Linux
 2.6.32.19-0.3-default x86_64
X-GPG-Key_0: 1024D/CCB58790
X-PGP-Fingerprint_0: B249 A371 AD81 1A36 E93F  4537 1509 F836 CCB5 8790
X-GPG-Key_1: 2048g/05FE58F8
X-PGP-Fingerprint_1: 3D28 E4E3 69A5 655E 7590  82A9 12E9 8C27 05FE 58F8
X-PGP-Keyserver: blackhole.pca.dfn.de
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

this patch to qcserial.c enables the Diagnostics Monitor
and NMEA GPS ports on Qualcomm Gobi 2000 devices. 

A Gobi 2000 device will provide 3 serial ports:
        # /dev/ttyUSB0 -> Diagnostics
        # /dev/ttyUSB1 -> 3G Modem
        # /dev/ttyUSB2 -> NMEA GPS port

* The Diagnostics Monitor uses Qualcomm's DM protocol; I used
  libqcdm (ModemManager) to talk to it, found it working, but at
  least DM commands 12 and 64 are not implemented on my device
  (Gobi 2000 built into Thinkpad x100e).

* Functionality of the 3G Modem port remains unchanged.

* The GPS port and how to enable it has been confirmed now in the
  Gobi 3000 source code at:
	https://www.codeaurora.org/patches/quic/gobi/
  Enable/disable GPS via:
        echo "\$GPS_START" > /dev/ttyUSB2
        # use GPS
        echo "\$GPS_STOP"  > /dev/ttyUSB2


Signed-off-by: Matthias G. Eckermann <mge@arcor.de>


--- 
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 2846ad8..1fac621 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -150,21 +150,50 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		break;
 
 	case 3:
 	case 4:
 		/* Composite mode */
-		if (ifnum == 2) {
+		/* ifnum == 0 is a broadband network adapter */
+		if (ifnum == 1) {
+			/* 
+			 * Diagnostics Monitor (serial line 9600 8N1)
+			 * Qualcomm DM protocol
+			 * use "libqcdm" (ModemManager) for communication
+			 */
+			dbg("Diagnostics Monitor found");
+			retval = usb_set_interface(serial->dev, ifnum, 0);
+			if (retval < 0) {
+				dev_err(&serial->dev->dev,
+					"Could not set interface, error %d\n",
+					retval);
+				retval = -ENODEV;
+			}
+		} else if (ifnum == 2) {
 			dbg("Modem port found");
 			retval = usb_set_interface(serial->dev, ifnum, 0);
 			if (retval < 0) {
 				dev_err(&serial->dev->dev,
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
 				kfree(data);
 			}
 			return retval;
+		} else if (ifnum==3) {
+			/* 
+			 * NMEA (serial line 9600 8N1)
+			 * # echo "\$GPS_START" > /dev/ttyUSBx
+			 * # echo "\$GPS_STOP"  > /dev/ttyUSBx
+			 */
+			dbg("NMEA GPS interface found");
+			retval = usb_set_interface(serial->dev, ifnum, 0);
+			if (retval < 0) {
+				dev_err(&serial->dev->dev,
+					"Could not set interface, error %d\n",
+					retval);
+				retval = -ENODEV;
+			}
 		}
 		break;
 
 	default:
 		dev_err(&serial->dev->dev,
-- 
Voluminous documentation is  part of the problem 
not part of the solution           (Tom DeMarco)
No documentation though is not a solution either 
