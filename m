Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab1EGWZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:25:03 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47934 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab1EGWZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XhIeVWXOeJUfxaD6KS+p5WfHaFPedZrPXdzAfHdU41BlbzyqeQkXP19/hg/p9dXp0t
         RiEJfxFqW7UibDL6hjHoMfpbPbKGSrzY4GXhkdd9Nql80M3thrXtjYtGe3NkAFktzZ2k
         d/M1hG2IBZXRnzSieZRmwLWLLNXI86xGAKdYI=
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
From: Christoph Fritz <chf.fritz@googlemail.com>
To: "Adi J. Sieker" <adi@core.adi.io>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>,
        USB list <linux-usb@vger.kernel.org>, linux-input@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <4DC3FEC7.6050503@sieker.io>
References: <Pine.LNX.4.44L0.1105030945410.2085-100000@iolanthe.rowland.org>
	 <alpine.LNX.2.00.1105061456320.28291@pobox.suse.cz>
	 <4DC3FEC7.6050503@sieker.io>
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 08 May 2011 00:24:53 +0200
Message-ID: <1304807093.5891.45.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 15:59 +0200, Adi J. Sieker wrote:
> On 06/05/11 14:58, Jiri Kosina wrote:
> > On Tue, 3 May 2011, Alan Stern wrote:
> >
> >>> Do you know of a way for me to tell the kernel/usbhid to use interface 1
> >>> and ignore interface 0?
> >>
> >> Well, you can always unbind interface 0 from usbhid -- it corresponds
> >> to the 2-1.1:1.0 file in /sys/bus/usb/drivers/usbhid/.  If you do that,
> >> you'll probably find the few keys which _do_ currently work suddenly
> >> stop working.
> >>
> >> But there's nothing to be done immediately about interface 1; usbhid is
> >> _already_ using it.  It just isn't using it correctly.
> >
> > Adi,
> >
> > could you please provide output of
> >
> > 	cat /syse/kernel/debug/hid/<keyboard>/rdesc
> >
> > anytime after the keyboard has been plugged, and
> 
> in /sys/kernel/debug/hid I have two devices for the keyboard. One is 
> 0003:060B:0230.0002 and the other 0003:060B:0230.0003
> 
> attached are the rdesc files for both devices.
> 
> >
> > 	cat /syse/kernel/debug/hid/<keyboard>/events
>  > from the time you press any of the working and non-working keys? (both
>  > cases will be interesting).
> 
> I only get events for the working keys on the *:0002 device.
> All other files were empty after I pressed some keys.
> 
> The events for the working keys are attached in the *.events file.
> I first pressed backspace and then the menu key.

Hi Adi,
 
 I'm not sure about my patch below because of interface one, maybe you
can give it a try.

Thanks,
 -- chf

---
Subject: [PATCH] HID: add quirk for Solid Year keyboard ACK231

This patch adds HID_QUIRK_MULTI_INPUT to Solid Year keyboard ACK231
which reports keystrokes from inside a firmware-configuration
interface instead of using its own interface.

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 00a94b5..abbace9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -528,6 +528,9 @@
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07
 
+#define USB_VENDOR_ID_SOLIDYEAR		0x060b
+#define USB_DEVICE_ID_SOLIDYEAR_KEYBOARD_ACK231	0x0230
+
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index a8426f1..b099380 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -49,6 +49,7 @@
 	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
 	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_SOLIDYEAR, USB_DEVICE_ID_SOLIDYEAR_KEYBOARD_ACK231, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS, HID_QUIRK_MULTI_INPUT },
 
 	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM, HID_QUIRK_NOGET },


