Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1IWQQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:16:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50971 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751959Ab1IWQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:16:41 -0400
Date: Fri, 23 Sep 2011 12:16:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthias Dellweg <2500@gmx.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Michal Sojka <sojkam1@fel.cvut.cz>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] enable usb control message with class specific request
In-Reply-To: <20110923090550.43ec1fd1@horus>
Message-ID: <Pine.LNX.4.44L0.1109231207160.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Matthias Dellweg wrote:

> Am Thu, 22 Sep 2011 23:56:56 +0200
> schrieb Matthias Dellweg <2500@gmx.de>:
> 
> > +       if ((requesttype == 0xa1) && (request == 0x00)
> > +        && (usb_find_alt_setting(ps->dev->actconfig, index >> 8,
> > index & 0xff)
> > +        ->desc.bInterfaceClass == USB_CLASS_PRINTER))
> > +               index >>= 8;
> 
> I just woke up and realised this is a very bad idea if there is no such
> setting...
> So here's the next version I'd like to propose for comments:

This is basically okay.  But your mailer has mangled the whitespace.

> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 37518df..d2efc97 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -607,9 +607,10 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
>  }
>  
>  static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
> -                          unsigned int index)
> +                          unsigned int request, unsigned int index)
>  {
>         int ret = 0;
> +       struct usb_host_interface *alt_setting;
>  
>         if (ps->dev->state != USB_STATE_UNAUTHENTICATED
>          && ps->dev->state != USB_STATE_ADDRESS
> @@ -618,6 +619,15 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
>         if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
>                 return 0;
>  
> +       /* check for the special corner case 'get_device_id' in the printer class specification,
> +        * where wIndex is (configuration << 8 | altsetting) */

Here and below, you should fit lines into 80 columns.  And the closing
*/ should be on a separate line (many people like to put the opening /*
on a separate line too).

Also, the high byte of wIndex is interface, not configuration.

> +       if ((requesttype == 0xa1) && (request == 0x00))

Nested parens not needed.  And the request value should be given in
decimal, like it is in the spec.

> +       {

The open paren should be at the end of the "if" line, not on a line of
its own.

> +               alt_setting = usb_find_alt_setting(ps->dev->actconfig, index >> 8, index & 0xff);
> +               if (alt_setting && (alt_setting->desc.bInterfaceClass == USB_CLASS_PRINTER))
> +                       index >>= 8;
> +       }
> +
>         index &= 0xff;
>         switch (requesttype & USB_RECIP_MASK) {
>         case USB_RECIP_ENDPOINT:
> @@ -770,7 +780,7 @@ static int proc_control(struct dev_state *ps, void __user *arg)
>  
>         if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
>                 return -EFAULT;
> -       ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
> +       ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest, ctrl.wIndex);
>         if (ret)
>                 return ret;
>         wLength = ctrl.wLength;         /* To suppress 64k PAGE_SIZE warning */
> @@ -1100,7 +1110,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>                         kfree(dr);
>                         return -EINVAL;
>                 }
> -               ret = check_ctrlrecip(ps, dr->bRequestType,
> +               ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
>                                       le16_to_cpup(&dr->wIndex));
>                 if (ret) {
>                         kfree(dr);

Alan Stern

