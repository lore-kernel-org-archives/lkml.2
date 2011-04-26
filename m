Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1DZUGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:06:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:41121 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1DZUGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:06:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738806696"
Date: Tue, 26 Apr 2011 13:06:25 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org, balbi@ti.com,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20110426200625.GB5405@xanatos>
References: <20110426172559.GA5405@xanatos>
 <Pine.LNX.4.44L0.1104261423250.2035-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104261423250.2035-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:40:58PM -0400, Alan Stern wrote:
> On Tue, 26 Apr 2011, Sarah Sharp wrote:
> 
> > On Tue, Apr 26, 2011 at 12:00:46PM +0300, Tanya Brokhman wrote:
> > > Our idea was that UAS supporting devices register with 2 configurations (not
> > > a second alternate setting to the MS interface). Upon enumeration the host
> > > will choose the operational mode/protocol (BOT/UAS) by choosing the
> > > configuration it wishes to operate in. As a first development phase it was
> > > easier for us to register only 1 configuration and that's why we added the
> > > module parameter. We're now working on removing this hack and registering 2
> > > configurations the host can choose from. From what I saw in the host side
> > > implementation the host always prefers the first configuration so right now
> > > we set the UAS config from user-space via sysfs.
> > > 
> > > I looked into USB-IF UAS compliance test document and you're right. There is
> > > something that mentions "Configuration Descriptor shall report B NUM
> > > INTERFACES > 0". Unfortunately in our version of the file this is the only
> > > reference I found for this demand so I need to look into that and get more
> > > details.
> > 
> > Ok, I'll double check with the people I know from the compliance team.
> > I remember the requirement from the discussion of the UAS compliance
> > test on the USB-IF website.  Do you have access to the UAS workgroup?
> 
> For what it's worth, my old copy of the UAS spec (working draft Rev. 2) 
> says nothing about this one way or another.  Evidently it was thought 
> that vendors would implement dual-protocol support any way they wanted.

Yeah, I'm looking over the UAS compliance spec, and I only see the
mention of making sure the bNumInterfaces is greater than 0 (which only
means there has to be at least one interface).  The specific discussion
I remember was about how to make sure a Windows install without a UAS
driver would fall back to BOT.  They wanted to make it a requirement
that BOT be the first alternate interface setting, but it looks like
that never made it into the compliance spec.  So yes, Tanya can
implement it however she wants.

> > > In the meanwhile: will this work with the existing UAS driver
> > > implementation? How will I be able to "force" the host to choose the UAS
> > > protocol? I can compile just cdc_ncm but I prefer to have my host support
> > > both UAS and BOT and be able to choose. As mentioned before, at the moment I
> > > achieved that by manually setting the device configuration to UAS from user
> > > space.
> > 
> > Unfortunately, Linux will choose the first configuration and bind
> > whatever driver that matches that configuration to the device.  So if
> > the BOT configuration is configuration 1, then the BOT driver will be
> > loaded.  Same with alternate interface settings.  Alternate interface 0
> > will always be chosen first during enumeration.
> 
> The part about configurations is right, but the part about altsettings
> is wrong.  The USB core does not choose altsettings; drivers do.  The
> driver that binds to an interface will select whichever altsetting it
> wants.

I meant that during enumeration, configuration 1 would be installed, and
because the USB core doesn't try to install a particular alternate
interface setting, alt setting 0 would be active by default.

> > We need a way to switch the UAS device from the BOT driver to the UAS
> > driver, but I'm not sure how to do that.  I think Alan might have had
> > some ideas?
> 
> One can always unbind usb-storage from an interface and bind uas to
> that interface by hand, using sysfs.  At the moment there doesn't 
> appear to be any mechanism for doing this automatically.  For example, 
> usb-storage _could_ choose not to bind to an interface if there's a UAS 
> altsetting -- but currently it doesn't take that into account.

How would the usb-storage driver reject a bind by the USB core?  By
returning an error from the probe function?  Would the USB core go and
search for the next driver after the BOT driver rejected the bind?  It
looks like usb_probe_interface will just return an error if the first
driver's probe function fails.

> Which reminds me...  Fallbacks are always a good idea.  If usb-storage 
> did decide not to bind to combined BOT/UAS devices, we should have a 
> mechanism for overriding this choice (i.e., forcing usb-storage to bind 
> regardless).

Sure, maybe a module parameter like "own_uas"?  Or do we want something
fancier, like a way to specify a list of VID:PIDs that the usb-storage
driver should own?  (I think the list parsing might be a bit hard to
implement though.)

> Likewise, Sarah, you should consider adding a mechanism to xhci-hcd for 
> forcing individual root-hub ports not to run at SuperSpeed (rather like 
> the "companion" attribute file in ehci-hcd, although I'm sure you can 
> come up with a better name).

I'm not entirely sure I can force a port down to USB 2.0 speeds, because
I'm not sure I can disable the port or turn off SuperSpeed terminations
from the xHCI driver.  I'd have to look into it.

Sarah Sharp
