Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1IZXYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:24:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41442 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752836Ab1IZXYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:24:16 -0400
X-Authenticated: #3169751
X-Provags-ID: V01U2FsdGVkX1/zwZxdSrnzHdf+Grz0RC8wC5f9gUIXDleAhrUO3l
	41gbWO/p7ri4NJ
Date: Tue, 27 Sep 2011 01:24:07 +0200
From: Matthias Dellweg <2500@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/core/devio.c: Check for printer class specific
 request
Message-ID: <20110927012407.6b294fbf@horus>
In-Reply-To: <20110926223430.GA21960@kroah.com>
References: <20110923195726.0cf0e8b5@horus>
	<Pine.LNX.4.44L0.1109231427280.2059-100000@iolanthe.rowland.org>
	<20110925144651.0ed3daaf@horus>
	<20110926223430.GA21960@kroah.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_//nTYqSRMqb6Xl.Hh5Arthd+"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_//nTYqSRMqb6Xl.Hh5Arthd+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Mon, 26 Sep 2011 15:34:30 -0700
schrieb Greg KH <greg@kroah.com>:

> On Sun, Sep 25, 2011 at 02:46:51PM +0200, Matthias Dellweg wrote:
> > From: Matthias Dellweg <2500@gmx.de>
> > 
> > In the usb printer class specific request get_device_id the value of
> > wIndex is (interface << 8 | altsetting) instead of just interface.
> > This enables the detection of some printers with libusb.
> > 
> > The hardware I tested this patch with is a Prolific
> > USB->Centronics cable (067b:2305).
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Matthias Dellweg <2500@gmx.de>
> > Cc: stable <stable@kernel.org>
> > ---
> >  drivers/usb/core/devio.c |   21 ++++++++++++++++++---
> >  1 files changed, 18 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> > index 37518df..1d73709 100644
> > --- a/drivers/usb/core/devio.c
> > +++ b/drivers/usb/core/devio.c
> > @@ -607,9 +607,10 @@ static int findintfep(struct usb_device *dev,
> > unsigned int ep) }
> >  
> >  static int check_ctrlrecip(struct dev_state *ps, unsigned int
> > requesttype,
> > -                          unsigned int index)
> > +                          unsigned int request, unsigned int index)
> >  {
> >         int ret = 0;
> > +       struct usb_host_interface *alt_setting;
> >  
> >         if (ps->dev->state != USB_STATE_UNAUTHENTICATED
> >          && ps->dev->state != USB_STATE_ADDRESS
> 
> All of the tabs were stripped out of this email, making it impossible
> to apply it :(
> 
> Care to fix this up and resend it so that I can apply it?
> 
> thanks,
> 
> greg k-h

Again? I mean I'm sorry.
Do you accept it as an attachment?
  Matthias Dellweg
--MP_//nTYqSRMqb6Xl.Hh5Arthd+
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-usb-core-devio.c-Check-for-printer-class-specific-re.patch

>From 5bdb64cbee0b2f353d3bc444c147ba78f34a1f69 Mon Sep 17 00:00:00 2001
From: Matthias Dellweg <2500@gmx.de>
Date: Sun, 25 Sep 2011 14:26:25 +0200
Subject: [PATCH] usb/core/devio.c: Check for printer class specific request

In the usb printer class specific request get_device_id the value of
wIndex is (interface << 8 | altsetting) instead of just interface.
This enables the detection of some printers with libusb.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Matthias Dellweg <2500@gmx.de>
---
 drivers/usb/core/devio.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..1d73709 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -607,9 +607,10 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
 }
 
 static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
-			   unsigned int index)
+			   unsigned int request, unsigned int index)
 {
 	int ret = 0;
+	struct usb_host_interface *alt_setting;
 
 	if (ps->dev->state != USB_STATE_UNAUTHENTICATED
 	 && ps->dev->state != USB_STATE_ADDRESS
@@ -618,6 +619,19 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
 		return 0;
 
+	/*
+	 * check for the special corner case 'get_device_id' in the printer
+	 * class specification, where wIndex is (interface << 8 | altsetting)
+	 * instead of just interface
+	 */
+	if (requesttype == 0xa1 && request == 0) {
+		alt_setting = usb_find_alt_setting(ps->dev->actconfig,
+						   index >> 8, index & 0xff);
+		if (alt_setting
+		 && alt_setting->desc.bInterfaceClass == USB_CLASS_PRINTER)
+			index >>= 8;
+	}
+
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
@@ -770,7 +784,8 @@ static int proc_control(struct dev_state *ps, void __user *arg)
 
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
-	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
+	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest,
+			      ctrl.wIndex);
 	if (ret)
 		return ret;
 	wLength = ctrl.wLength;		/* To suppress 64k PAGE_SIZE warning */
@@ -1100,7 +1115,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			kfree(dr);
 			return -EINVAL;
 		}
-		ret = check_ctrlrecip(ps, dr->bRequestType,
+		ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
 				      le16_to_cpup(&dr->wIndex));
 		if (ret) {
 			kfree(dr);
-- 
1.7.6.3


--MP_//nTYqSRMqb6Xl.Hh5Arthd+--
