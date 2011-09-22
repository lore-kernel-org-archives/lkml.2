Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1IVV5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:57:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41879 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752461Ab1IVV5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:57:06 -0400
X-Authenticated: #3169751
X-Provags-ID: V01U2FsdGVkX18Q30Z2GogQA1g9h7AgPSE4oUCcBQ/Ofkzu3yMFVS
	MMuCNGWAOH/Rcd
Date: Thu, 22 Sep 2011 23:56:56 +0200
From: Matthias Dellweg <2500@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Michal Sojka <sojkam1@fel.cvut.cz>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enable usb control message with class specific request
Message-ID: <20110922235656.1f821c1f@horus>
In-Reply-To: <Pine.LNX.4.44L0.1109221100270.2137-100000@iolanthe.rowland.org>
References: <20110922121031.639006d0@horus>
	<Pine.LNX.4.44L0.1109221100270.2137-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 22 Sep 2011 11:12:51 -0400 (EDT)
schrieb Alan Stern <stern@rowland.harvard.edu>:

> On Thu, 22 Sep 2011, Matthias Dellweg wrote:
> 
> > Hi!
> > Usb devio assumes that the wIndex in every control message apart
> > from those flagged as USB_TYPE_VENDOR holds the number of the
> > Interface being addressed. This is for example not true for the
> > class specific request GET_DEVICE_ID in the printer class:
> > 
> > "The high-byte of the wIndex field is used to specify the zero-based
> > interface index. The low-byte of the wIndex field is used to specify
> > the zero-based alternate setting." [1]
> > 
> > In this special case it misinterpretes the alternate setting 1 for
> > the interface and tries to claim a nonexisting one. Therefor you
> > won't get the printers name.
> > 
> > The patch below is a minimal approach to fix this. Maybe it should
> > be extended to USB_TYPE_RESERVED. Maybe there should be an extended
> > test that knows something about specific classes.
> > 
> > What do you think?
> > regards Matthias
> > 
> > [1] http://www.usb.org/developers/devclass_docs/usbprint11.pdf
> 
> In this case, it appears that the printer class specification 
> contradicts the USB-2.0 specification.  Section 9.3.1 says (referring 
> to the low-order five bits of bmRequestType):
> 
> 	Requests may be directed to the device, an interface on the 
> 	device, or a specific endpoint on a device. This field also
> 	specifies the intended recipient of the request. When an
> 	interface or endpoint is specified, the wIndex field
> identifies the interface or endpoint.
> 
> And Figure 9-3 shows that when wIndex is used to specify an
> interface, the interface number belongs in the low-order byte, not
> the high-order byte.
> 
> I don't think it's safe to relax the test the way you have suggested.
> There are too many other class-specific requests that must be 
> prevented.  Maybe an exception could be added for this one particular 
> case.  Besides, you don't want to remove the test entirely -- you
> want to use the high-order byte of wIndex instead of the low-order
> byte.
> 
> The printer spec really is spectacularly bad in this respect.  What 
> happens if the printer is a composite device, and the other interface 
> uses the same bmRequestType and bRequest values for its own 
> class-specific purpose, but uses the low-order byte of wIndex to 
> indicate the interface number (as it should).  Then the printer 
> wouldn't know which interface was supposed to respond to the message!
> 
> Alan Stern

OK, let's assume this is the only exception in the specs. Do you think
the test should look like this:

>From 6514baecca5e193b78e1f3343585c5c9a458a625 Mon Sep 17 00:00:00 2001
From: Matthias Dellweg <2500@gmx.de>
Date: Thu, 22 Sep 2011 23:50:35 +0200
Subject: [PATCH] drivers/usb/core/devio.c: Check for printer class specific
 request

Signed-off-by: Matthias Dellweg <2500@gmx.de>
---
 drivers/usb/core/devio.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..e3e60f7 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -607,7 +607,7 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
 }
 
 static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
-                          unsigned int index)
+                          unsigned int request, unsigned int index)
 {
        int ret = 0;
 
@@ -618,6 +618,12 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
        if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
                return 0;
 
+       /* check for a very special case in the printer class specification */
+       if ((requesttype == 0xa1) && (request == 0x00)
+        && (usb_find_alt_setting(ps->dev->actconfig, index >> 8, index & 0xff)
+        ->desc.bInterfaceClass == USB_CLASS_PRINTER))
+               index >>= 8;
+
        index &= 0xff;
        switch (requesttype & USB_RECIP_MASK) {
        case USB_RECIP_ENDPOINT:
@@ -770,7 +776,7 @@ static int proc_control(struct dev_state *ps, void __user *arg)
 
        if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
                return -EFAULT;
-       ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
+       ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest, ctrl.wIndex);
        if (ret)
                return ret;
        wLength = ctrl.wLength;         /* To suppress 64k PAGE_SIZE warning */
@@ -1100,7 +1106,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
                        kfree(dr);
                        return -EINVAL;
                }
-               ret = check_ctrlrecip(ps, dr->bRequestType,
+               ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
                                      le16_to_cpup(&dr->wIndex));
                if (ret) {
                        kfree(dr);
-- 
1.7.6.3
