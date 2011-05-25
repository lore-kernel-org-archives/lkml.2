Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1EYKun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:50:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1EYKum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:50:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93511129"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <011d01cc19ff$616055c0$24210140$@org> <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org> <013201cc1a96$bdda7910$398f6b30$@org> <20110525092124.GI14556@legolas.emea.dhcp.ti.com> <015801cc1abd$ca534e20$5ef9ea60$@org> <20110525092743.GK14556@legolas.emea.dhcp.ti.com> <018e01cc1ac0$2b09b040$811d10c0$@org> <20110525094902.GM14556@legolas.emea.dhcp.ti.com> <01a601cc1ac2$f0041a00$d00c4e00$@org> <20110525102945.GN14556@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110525102945.GN14556@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Wed, 25 May 2011 13:52:15 +0300
Message-ID: <01b401cc1ac9$d1c57870$75506950$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwaxqMnsuhlBl2tRVyfjmUWSp62UgAAONKg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> >
> > You want to remove the following change from in composite.c:
> >
> > @@ -1386,6 +1604,9 @@ int usb_composite_probe(struct
> > usb_composite_driver *driver,
> >  		driver->iProduct = driver->name;
> >  	composite_driver.function =  (char *) driver->name;
> >  	composite_driver.driver.name = driver->name;
> > +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> > +	composite_driver.speed = USB_SPEED_SUPER; #endif /*
> > +CONFIG_USB_GADGET_SUPERSPEED */
> >  	composite = driver;
> >  	composite_gadget_bind = bind;
> >
> > Right? I'm sorry, but I really don't understand why... :( Removing it
> > is the same as not defining CONFIG_USB_GADGET_SUPERSPEED.
> 
> we still want to build a SuperSpeed dummy_hcd but have HS gadget
> drivers
> :-)

But we do! I'm sorry, I'm getting a bit frustrated from not understanding
what bothers you here...
The above change in usb_composite_probe() doesn't prevent HS gadgets from
working with SS dummy_hcd.
Here is an example of the tests I ran on this patch series:
In my build CONFIG_USB_GADGET_SUPERSPEED=true so composite_driver.speed =
USBSPEED_SUPER.
1)
$> modprobe g_zero
G_zero was enumerated over HS root hub as a HS device. I ran our HS test
suite (from the UT framework) to test its functionality. It includes (HS)
descriptors verification, connect/disconnect and bulk in/out tests.

2) 
$> modprobe dummy_hcd is_super_speed=1
$> modprobe g_zero
In this case the enumeration fails since g_zero didn't provide SS
descriptors!

I prepared another build, in which I used our generate_ss_descriptors() to
automaticly generate SS descriptors for g_zero gadget.
CONFIG_USB_GADGET_SUPERSPEED is still true:

3)
$> modprobe g_zero
G_zero was enumerated over HS root hub as a HS device although it has SS
descriptors. All HS UT that I described above passed

4) 
$> modprobe dummy_hcd is_super_speed=1
$> modprobe g_zero
G_zero enumerated over SS root hub as a SS device. I verified that it's
functional with the SS test suite. It also verifies (SS) descriptors,
connect/disconnect and bulk in/out tests.

Please give me an example of what WOUN'T work with the above change.

> 
> > > we should be to compile dummy_hcd in SuperSpeed and still have
> high-
> > > speed gadget drivers :-)
> >
> > But this is the case right now. Or do you mean that you want to load
> > (not
> > compile) the dummy_hcd with is_super_speed=1 and still be able to
> > enumerate HS gadgets?
> 
> that too.

Well you can if at compile time you don't set CONFIG_USB_GADGET_SUPERSPEED
to true.

> 
> > > > following:
> > > > 1. if CONFIG_USB_GADGET_SUPERSPEED=true, existing gadget drivers
> > > > are still functional with dummy_hcd since as I already mentioned,
> > > > they will be enumerated through HS root hub and thus the
> > > > gadget.speed will
> > > be set to HS.
> > > > This is true for all gadget drivers, including the once that
> don't
> > > > define SS descriptors.
> > >
> > > only due the module parameter, right ?
> >
> > Due to the module parameter default value being FALSE, yes.
> 
> Ok, so let's take your approach but change the speed in the gadget
> driver structure, put your ifdef somewhere like here:
> 
> diff --git a/drivers/usb/gadget/composite.c
> b/drivers/usb/gadget/composite.c index 1ba4bef..d02d6e8 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1224,7 +1224,11 @@ composite_resume(struct usb_gadget *gadget)  /*-
> -----------------------------------------------------------------------
> -*/
> 
>  static struct usb_gadget_driver composite_driver = {
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +       .speed          = USB_SPEE_SUPER,
> +#else
>         .speed          = USB_SPEED_HIGH,
> +#endif
> 
>         .unbind         = composite_unbind,
> 

I have no problem updating static struct usb_gadget_driver composite_driver
as you suggested but it seems the same as updating it @
usb_composite_probe()...


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




