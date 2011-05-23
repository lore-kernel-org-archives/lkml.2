Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1EWP4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:56:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:52252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab1EWP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:56:12 -0400
X-ExtLoop1: 1
Date: Mon, 23 May 2011 08:55:53 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110523155553.GA5606@xanatos>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-8-git-send-email-tlinder@codeaurora.org>
 <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
 <00a301cc1919$f0e1fa00$d2a5ee00$@org>
 <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
 <00cc01cc1922$0fb4ee80$2f1ecb80$@org>
 <20110523083208.GM3095@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523083208.GM3095@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:32:18AM +0300, Felipe Balbi wrote:
> hi,
> 
> On Mon, May 23, 2011 at 11:18:53AM +0300, Tanya Brokhman wrote:
> > > > > > +
> > > > > > +static struct dummy_hcd_module_parameters mod_data = {
> > > > > > +	.is_super_speed = false
> > > > > > +};
> > > > > > +module_param_named(is_super_speed, mod_data.is_super_speed,
> > > bool,
> > > > > > +S_IRUGO); MODULE_PARM_DESC(is_super_speed, "true to simulate
> > > > > > +SuperSpeed connection");
> > > > >
> > > > > you shouldn't need this. You should always enable SuperSpeed for
> > > > > this driver.
> > > >
> > > > You mean I don't need the module parameter? IMO it's the best way to
> > > > enable HS connection. If driver->speed=USB_SPEED_SUPER than dummy_hcd
> > > > will try to enumerate the device on the SS root hub and if the gadget
> > > > didn't provide SS descriptors - it will fail. Just as it happened
> > > > before. Finding out from
> > > 
> > > then it should hand the device over to the hs_hcd ;-) Meaning it would
> > > disconnect the device, switch to hs_hcd and reconnect :-)
> > 
> > Yes this will be the best solution :) But as I said, the enumeration occurs
> > not in dummy_hcd thus I'm not sure how dummy_hcd can find out that it failed
> 
> take a look at xhci-ring.c for an example :-)
> 
> see that it check whether the attached device is a USB3.0 device or
> USB2.0/1.1 device and chooses hcd or shared_hcd accordingly.

Yes, that's based on what the port speed registers report.  The host
controller will detect either a connect on the SuperSpeed terminations
and set the SuperSpeed speed accordingly.  I'm not sure how it detects
whether the device is a high speed device.  I think it has something to
do with the LPF signaling, but I'm not a link layer expert.

> > in order to reconnect the device to hs_hcd. And I'm not sure that dummy_hcd
> > should care whether the enumeration succeeds or fails. It seems to me that
> > this should be handled by upper levels. Shouldn't it?
> 
> nope. If dummy_hcd was a SW xhci implementation then it should be taken
> care by upper layers, but since this is a complete SW non-standard Host
> interface, then we need to handle the whole thing.
> 
> > But we're discussing a more general issue; do you remember what the usb30
> > spec sais about this? I mean when connecting a HS device to a SS port (over
> 
> not the exact wording of the Specs but it should work :-)
> 
> > SS cable), should it still enumerate as a HS device? It seems to me that the
> > answer is no but I'm not sure...

If you look at Figure 7-13 in the USB 3.0 spec, you'll see that the
device is supposed to try to detect SuperSpeed terminations, but if that
times out, then it goes to the "SuperSpeed disabled" state, and falls
back to the USB 2.0 bus connection.

> the USB3 host shouldn't enumerate but it has the shared_hcd which is
> USB2.0 compliant.

Felipe, technically the xHCI host controller handles all device speeds.
There are no companion controllers in an xHCI host controller.  The hcd
and shared_hcd is just an abstraction to make the roothub look like an
external USB 3.0 hub to the USB core.

External USB 3.0 devices show up as two separate devices -- a USB 3.0
hub and a USB 2.0 hub.  The xHCI host controller originally just showed
as a USB 3.0 hub that could handle all speeds, but when we needed to add
support for external USB 3.0 hubs, that simplification broke the USB
core's assumption that roothubs and external hubs act the same way.  So
we changed the xHCI driver to register to usb_hcd structures for one PCI
device.

Basically you should just think of the xHCI host as taking care of all
devices plugged into it.

> > > > dummy_hcd that the enumeration failed is very complicated (if even
> > > > possible) and I'm not sure that is the right thing to do... If you
> > > > connect a real device over SS port to xHCI and the device doesn't
> > > > provide SS descriptors - the enumeration fails and it's ok. But if
> > > you
> > > > connect the same device to a HS port - it should work properly. This
> > > > is what I tried to simulate with this parameter.
> > > 
> > > it doesn't just fails, it gives the device over to the shared_hcd :-)
> > > 
> > 
> > Hmmm.... I have v2.6.38 installed on my Linux-host at the moment and I just
> > verified that when connecting a Gadget driver without SS descriptors over SS
> > connection - the enumeration fails. Was this fixed in v2.6.39? It will take
> > me some time to upgrade to v2.6.39  and verify but I have to do it any way
> > so I'll give it a shot...
> 
> Maybe Sarah can give more details on this one. Sarah, what happens if we
> attach USB2.0 device to USB3.0 roothub ?

It gets enumerated under xHCI as a USB 2.0 device.  With 2.6.39 and
later, you'll see it ends up under the "Linux Foundation 2.0 root hub",
but if you look at iManufacturer under that hub's description, you'll
see it's an xHCI roothub.  With kernels before 2.6.39, it will end up
under the "Linux Foundation 3.0 root hub".

Sarah Sharp
