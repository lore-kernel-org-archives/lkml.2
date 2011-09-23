Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1IWHGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 03:06:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36374 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751064Ab1IWHGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 03:06:02 -0400
X-Authenticated: #3169751
X-Provags-ID: V01U2FsdGVkX19sDEEol5tstLMVeuvlEt0WM3Mnoj0iaFZo/+cAFJ
	E2UxeklFG/5a4o
Date: Fri, 23 Sep 2011 09:05:50 +0200
From: Matthias Dellweg <2500@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Michal Sojka <sojkam1@fel.cvut.cz>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enable usb control message with class specific request
Message-ID: <20110923090550.43ec1fd1@horus>
In-Reply-To: <20110922235656.1f821c1f@horus>
References: <20110922121031.639006d0@horus>
	<Pine.LNX.4.44L0.1109221100270.2137-100000@iolanthe.rowland.org>
	<20110922235656.1f821c1f@horus>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 22 Sep 2011 23:56:56 +0200
schrieb Matthias Dellweg <2500@gmx.de>:

> +       if ((requesttype == 0xa1) && (request == 0x00)
> +        && (usb_find_alt_setting(ps->dev->actconfig, index >> 8,
> index & 0xff)
> +        ->desc.bInterfaceClass == USB_CLASS_PRINTER))
> +               index >>= 8;

I just woke up and realised this is a very bad idea if there is no such
setting...
So here's the next version I'd like to propose for comments:

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..d2efc97 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -607,9 +607,10 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
 }
 
 static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
-                          unsigned int index)
+                          unsigned int request, unsigned int index)
 {
        int ret = 0;
+       struct usb_host_interface *alt_setting;
 
        if (ps->dev->state != USB_STATE_UNAUTHENTICATED
         && ps->dev->state != USB_STATE_ADDRESS
@@ -618,6 +619,15 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
        if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
                return 0;
 
+       /* check for the special corner case 'get_device_id' in the printer class specification,
+        * where wIndex is (configuration << 8 | altsetting) */
+       if ((requesttype == 0xa1) && (request == 0x00))
+       {
+               alt_setting = usb_find_alt_setting(ps->dev->actconfig, index >> 8, index & 0xff);
+               if (alt_setting && (alt_setting->desc.bInterfaceClass == USB_CLASS_PRINTER))
+                       index >>= 8;
+       }
+
        index &= 0xff;
        switch (requesttype & USB_RECIP_MASK) {
        case USB_RECIP_ENDPOINT:
@@ -770,7 +780,7 @@ static int proc_control(struct dev_state *ps, void __user *arg)
 
        if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
                return -EFAULT;
-       ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
+       ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest, ctrl.wIndex);
        if (ret)
                return ret;
        wLength = ctrl.wLength;         /* To suppress 64k PAGE_SIZE warning */
@@ -1100,7 +1110,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
                        kfree(dr);
                        return -EINVAL;
                }
-               ret = check_ctrlrecip(ps, dr->bRequestType,
+               ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
                                      le16_to_cpup(&dr->wIndex));
                if (ret) {
                        kfree(dr);
