Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab0DZT3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:29:54 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:37475 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab0DZT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:29:52 -0400
X-Greylist: delayed 2457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 15:29:52 EDT
Subject: hack for Lilliput 669GL-70NP/C/T 7" USB touchscreen
From: Hollis Blanchard <hollis_blanchard@mentor.com>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Mentor Graphics, Embedded Systems Division
Date: Mon, 26 Apr 2010 11:48:21 -0700
Message-ID: <1272307701.19363.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2010 18:48:31.0459 (UTC) FILETIME=[111BF330:01CAE571]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working with a Lilliput 7" USB touchscreen (model
669GL-70NP/C/T), and discovered that while usbtouchscreen.c claims to
support its USB ID, the driver didn't actually work.

Here is the lsusb output:

Bus 001 Device 003: ID 0eef:0001 D-WAV Scientific Co., Ltd eGalax TouchScreen
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0eef D-WAV Scientific Co., Ltd
  idProduct          0x0001 eGalax TouchScreen
  bcdDevice            1.00
  iManufacturer           1 eGalax Inc.
  iProduct                2 USB TouchController
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         8704
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1 eGalax Inc.
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
      ** UNRECOGNIZED:  09 21 10 02 00 01 22 8d 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0800  2x 0 bytes
        bInterval               3
Device Status:     0x0000
  (Bus Powered)

After dumping the incoming bytestream, here is the hack I made to
usbtouchscreen.c to actually register touches correctly. I haven't tried
to clean it up because I'm not sure what the real problem is. It sounds
like this device is not expected to work with the standard usbhid driver
(and it doesn't), but neither does it work with usbtouchscreen.c. I
really don't know anything about USB, but I could figure out how to
interpret this 6-byte packet...

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 68ece58..e9597fa 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -252,6 +252,7 @@ static int e2i_read_data(struct usbtouch_usb *dev, unsigned 
 #define EGALAX_PKT_TYPE_REPT           0x80
 #define EGALAX_PKT_TYPE_DIAG           0x0A
 
+#if 0
 static int egalax_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
        if ((pkt[0] & EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT)
@@ -279,6 +280,34 @@ static int egalax_get_pkt_len(unsigned char *buf, int len)
 
        return 0;
 }
+
+#else
+
+static int egalax_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+       if ((pkt[0] & EGALAX_PKT_TYPE_MASK) != 2)
+               return 0;
+
+       dev->x = (pkt[5] << 8) | pkt[4];
+       dev->y = (pkt[3] << 8) | pkt[2];
+       dev->touch = pkt[1] & 0x01;
+
+       return 1;
+}
+
+static int egalax_get_pkt_len(unsigned char *buf, int len)
+{
+       switch (buf[0] & EGALAX_PKT_TYPE_MASK) {
+       case 2:
+               return 6;
+       default:
+               printk(KERN_WARNING "%s: unknown packet type 0x%x\n", __func__, buf[0]);
+       }
+
+       return 0;
+}
+#endif
+
 #endif
 
 
Signed-off-by: Hollis Blanchard <hollis_blanchard@mentor.com>

Comments?

-- 
Hollis Blanchard
Mentor Graphics, Embedded Systems Division



