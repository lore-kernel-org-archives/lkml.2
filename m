Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1ATW2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:28:55 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:40345 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1ATW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QVcCXCt9zs4sv9oMk2Zv4S2Bknat6gUGFOmpxHV5KmsWw5XTTYaYVJcLXqj4qDvUzF
         Vn9mFRiOR6rdq6ihlhP9fNvz32nTfBRMjxCnzRx/MQyoxf4tSUIk70t0fA5umCmUt/l4
         OjyVB3nfwpD4zMY33QFtsxbzpO/ac4Fc4Xl7g=
Message-ID: <4D38B721.9090906@gmail.com>
Date: Fri, 21 Jan 2011 07:28:49 +0900
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; ja-JP-mac; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH][Bug 26922]USB: yurex: recognize GeneralKeys wireless presenter
 as generic HID (Re: New: 2.6.37 breaks USB wireless presenter HID device)
References: <bug-26922-10286@https.bugzilla.kernel.org/> <20110119132659.3e815450.akpm@linux-foundation.org>
In-Reply-To: <20110119132659.3e815450.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/01/20 6:26), Andrew Morton wrote:
> On Mon, 17 Jan 2011 10:53:51 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
>
>> https://bugzilla.kernel.org/show_bug.cgi?id=26922
> 2.6.36->2.6.37 USB regression, bisected to "USB: add driver for
> Meywa-Denki&  Kayac YUREX"
Unfortunately, the device seems to have the same Vendor ID
and Product ID as YUREX leg-shakes sensors, and the
commit 6bc235a2e2 added the ID to hid_ignore_list.

I believe that we can distinguish YUREX and the Wireless Presenter
by device type. The patch below makes the driver ignore only
YUREX (bInterfaceProtocol==0), and recognize Wireless Presenter
(bInterfaceProtocol is keyboard or mouse) as generic HID.
(I don't have the Wireless Presenter, so not yet ested.)

** YUREX lsusb information:
Bus 002 Device 007: ID 0c45:1010 Microdia
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x0c45 Microdia
   idProduct          0x1010
   bcdDevice            0.03
   iManufacturer           1 JESS
   iProduct                2 YUREX
   iSerial                 3 10000269
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
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
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      31
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

  3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 88cb04e..021d298 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1672,7 +1672,6 @@ static const struct hid_device_id 
hid_ignore_list[] = {
      { HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1006) },
      { HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1007) },
      { HID_USB_DEVICE(USB_VENDOR_ID_IMATION, USB_DEVICE_ID_DISC_STAKKA) },
-    { HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_JESS_YUREX) },
      { HID_USB_DEVICE(USB_VENDOR_ID_KBGEAR, 
USB_DEVICE_ID_KBGEAR_JAMSTUDIO) },
      { HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, 
USB_DEVICE_ID_KWORLD_RADIO_FM700) },
      { HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_GPEN_560) },
@@ -1786,6 +1785,11 @@ static bool hid_ignore(struct hid_device *hdev)
              hdev->product <= USB_DEVICE_ID_HANWANG_TABLET_LAST)
              return true;
          break;
+    case USB_VENDOR_ID_JESS:
+        if (hdev->product == USB_DEVICE_ID_JESS_YUREX &&
+            hdev->type == HID_TYPE_USBNONE)
+            return true;
+        break;
      }

      if (hdev->type == HID_TYPE_USBMOUSE &&
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5489eab..ce3f947 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1168,6 +1168,8 @@ static int usbhid_probe(struct usb_interface 
*intf, const struct usb_device_id *
      if (intf->cur_altsetting->desc.bInterfaceProtocol ==
              USB_INTERFACE_PROTOCOL_MOUSE)
          hid->type = HID_TYPE_USBMOUSE;
+    else if (intf->cur_altsetting->desc.bInterfaceProtocol == 0)
+        hid->type = HID_TYPE_USBNONE;

      if (dev->manufacturer)
          strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
diff --git a/include/linux/hid.h b/include/linux/hid.h
index bb0f56f..37f0e59 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -453,7 +453,8 @@ struct hid_input {

  enum hid_type {
      HID_TYPE_OTHER = 0,
-    HID_TYPE_USBMOUSE
+    HID_TYPE_USBMOUSE,
+    HID_TYPE_USBNONE = -1,
  };

  struct hid_driver;
-- 
1.7.3.5


