Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1EWQIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:08:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:55075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1EWQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:08:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,257,1304319600"; 
   d="scan'208";a="3218691"
Date: Mon, 23 May 2011 09:08:03 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110523160803.GB5606@xanatos>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-8-git-send-email-tlinder@codeaurora.org>
 <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
 <00a301cc1919$f0e1fa00$d2a5ee00$@org>
 <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
 <00cc01cc1922$0fb4ee80$2f1ecb80$@org>
 <20110523083208.GM3095@legolas.emea.dhcp.ti.com>
 <00e401cc192a$2211bb50$663531f0$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e401cc192a$2211bb50$663531f0$@org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:16:40PM +0300, Tanya Brokhman wrote:
> Hi 
> 
> > > > >
> > > > > You mean I don't need the module parameter? IMO it's the best way
> > > > > to enable HS connection. If driver->speed=USB_SPEED_SUPER than
> > > > > dummy_hcd will try to enumerate the device on the SS root hub and
> > > > > if the gadget didn't provide SS descriptors - it will fail. Just
> > > > > as it happened before. Finding out from
> > > >
> > > > then it should hand the device over to the hs_hcd ;-) Meaning it
> > > > would disconnect the device, switch to hs_hcd and reconnect :-)
> > >
> > > Yes this will be the best solution :) But as I said, the enumeration
> > > occurs not in dummy_hcd thus I'm not sure how dummy_hcd can find out
> > > that it failed
> > 
> > take a look at xhci-ring.c for an example :-)
> > 
> > see that it check whether the attached device is a USB3.0 device or
> > USB2.0/1.1 device and chooses hcd or shared_hcd accordingly.
> > 
> 
> I ran some more tests with xhci and I think (or hope :) ) I figured this
> out:
> When connecting a gadget driver that is marked as SS device (the flag
> CONFIG_USB_GADGET_IS_SUPER_SPEED = true) to a SS port over SS cable - 
> the enumeration fails if that gadget driver doesn't provide SS descriptors.

If you're connecting as a SuperSpeed device, you need to have SuperSpeed
descriptors.  You definitely won't pass the USB-IF compliance test if
you don't have those descriptors. :)  You need to be able to
automatically fall back to high speed with high speed descriptors when
necessary.

> BUT: if I connect the same device via HS cable to SS port - the enumeration
> is successful. I think that this is the case where xhci-ring handles the
> device over to the HS hcd :) (By the way, I think that in xhci the
> shared_hcd is SS and the main_hcd is HS)

Yes, main_hcd is the high speed portion of the roothub.  It's registered
first, so that during a system resume, the HS roothub gets the devices
reset first, and any USB 3.0 devices that had erroneously connected on
USB 2.0 can migrate over to the SuperSpeed terminations.  (If you are a
USB 2.0 device that also has the ability to work at USB 3.0, you don't
change speeds after USB 2.0 connection unless you get a reset.)  We had
to register the USB 2.0 roothub first so that USB 2.0 devices would get
reset first, otherwise persistent storage might fail for USB 3.0
devices.

> In conclusion it seems to me that the device speed is determined by 2
> things:
> 1. the cable used

Not necessarily the cable used.  You can have a SuperSpeed cable and
have both host and device be SuperSpeed capable, but signal noise could
cause the SuperSpeed enumeration to fail.

> 2. whether the device HW supports SS protocol. In our scenario it can since
> SS support is enabled in our udc. (We haven't released it yet.)

What is a UDC?

> So when a HS device is connected to a SS port, the xHCI checks it's speed
> and if necessary handles it over to the SS root hub. But this is done prior
> to the enumeration phase so if the device speed is SS but it has no SS
> descriptors - the enumeration will fail. The enumeration itself occurs not
> in xhci but in hub.c so the xhci isn't aware of the fact that it failed and
> doesn't handle this.

The USB core might try to disable the device in that case, and the xHCI
driver would see that.

> Since in dummy_hcd all of this is much simpler I think that the device speed
> should be determined by driver->speed and "which type of cable the
> connection was made over - SS or HS". The "cable type" is exactly what the
> module parameter is.

I really don't understand this.  You're going to have a module parameter
for what type of cable is plugged in?  How can you tell which one the
user is going to use?  What about the case where SuperSpeed enumeration
fails and you have to fall back to high speed?  It seems like you really
need to handle both speeds and the speed fall back parameter in the same
driver.  Isn't there some other gadget driver that has a fall back to
full or low speed when high speed enumeration fails?

Sarah Sharp
