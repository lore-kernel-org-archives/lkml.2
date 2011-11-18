Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1KRHsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 02:48:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KRHsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 02:48:40 -0500
Date: Fri, 18 Nov 2011 08:48:31 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Cousson, Benoit" <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 6/8] of: add clock providers
Message-ID: <20111118074831.GW27267@pengutronix.de>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
 <20111109091328.GY16886@pengutronix.de>
 <4EBA62AD.3000407@ti.com>
 <20111109114936.GL16886@pengutronix.de>
 <4EBD7E47.8010502@ti.com>
 <20111116221250.GA12884@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116221250.GA12884@ponder.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:52:36 up 5 days, 14:39, 17 users,  load average: 0.00, 0.01, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 03:12:50PM -0700, Grant Likely wrote:
> On Fri, Nov 11, 2011 at 08:57:59PM +0100, Cousson, Benoit wrote:
> > On 11/9/2011 12:49 PM, Sascha Hauer wrote:
> > >On Wed, Nov 09, 2011 at 12:23:25PM +0100, Cousson, Benoit wrote:
> > >>On 11/9/2011 10:13 AM, Sascha Hauer wrote:
> > >>>On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
> > >>
> > >>[...]
> > >>
> > >>>>+Sources of clock signal can be represented by any node in the device
> > >>>>+tree.  Those nodes are designated as clock providers.  Clock consumer
> > >>>>+nodes use a phandle and clock specifier pair to connect clock provider
> > >>>>+outputs to clock inputs.  Similar to the gpio specifiers, a clock
> > >>>>+specifier is an array of one more more cells identifying the clock
> > >>>>+output on a device.  The length of a clock specifier is defined by the
> > >>>>+value of a #clock-cells property in the clock provider node.
> > >>>>+
> > >>>>+[1] http://patchwork.ozlabs.org/patch/31551/
> > >>>>+
> > >>>>+==Clock providers==
> > >>>>+
> > >>>>+Required properties:
> > >>>>+#clock-cells:	   Number of cells in a clock specifier; typically will be
> > >>>>+		   set to 1
> > >>>>+
> > >>>>+Optional properties:
> > >>>>+clock-output-name: Recommended to be a list of strings of clock output signal
> > >>>>+		   names indexed by the first cell in the clock specifier.
> > >>>>+		   However, the meaning of clock-output-names is domain
> > >>>>+		   specific to the clock provider, and is only provided to
> > >>>>+		   encourage using the same meaning for the majority of clock
> > >>>>+		   providers.  This format may not work for clock providers
> > >>>>+		   using a complex clock specifier format.  In those cases it
> > >>>>+		   is recommended to omit this property and create a binding
> > >>>>+		   specific names property.
> > >>>
> > >>>If the clock-output-name property is omitted, does this mean a clock
> > >>>provider only has a single output or does it mean that it's not known
> > >>>how many clock outputs a provider actually has?
> 
> As Rob said, it only means that there are no names assigned to those
> inputs.  In fact, it leaves it up to the specific clock binding as to
> what it really means.  One driver may require the clock-output-name
> property to be present because it uses data from there to figure out
> how to configure the clock.  Another might not require it at all and
> the only reason for its existence is informational.
> 
> > >>Allowing several outputs for a single clock node might lead to a lot
> > >>of confusion. What will be the meaning of a clock rate if you have
> > >>several outputs at different frequency?
> 
> No, clock-frequency is specific to the fixed-clock binding (which I
> need to document).  That may or may not be present in other clock
> provider nodes.  For instance, there is a xilinx clock divider ip
> block that doesn't have any frequency of its own, but rather has
> multiple clock outputs that are a scale of the input clock.  The node
> for that device would never have a clock-frequency property because it
> relies entirely on the upstream clock.
> 
> This proposed binding is only about one thing: attaching clock
> providers to clock consumers.  It doesn't make any statements about
> how the clock provider driver is organized or how it manages its
> clocks.
> 
> This is by design to prevent clock consumers from digging into a clock
> provider node manually without consulting its driver.  The consumer
> only has a reference to a clock provider node + arguments.  It is the
> job of the producer driver to interpret the arguments.
> 
> The proposed API also reflects this.  The consumer driver requests a
> clock, but it is the producer driver that determines what the clock
> reference actually means, and which struct clk to return.
> 
> > >>I think it will be better to define a clock node as a single source
> > >>of clock. If several outputs are needed, then we should define
> > >>several clock nodes.
> 
> That is entirely up to the binding for the specific clock device(s).
> If it makes sense to have one node per clock, so be it.  If it makes
> more sense to have a clock nexus node for other hardware, then that is
> fine too.
> 
> > >>If we let a clock node be any kind of big clock blob, we will never
> > >>be able to define some generic reusable clock node API. Everybody
> > >>will define its own custom clock blobs.
> > >
> > >Generally +1. I asked myself the same question whether it's a good thing
> > >to allow a node to have multiple clocks. For i.MX I can say that I don't
> > >need this and that I do not intend to use this feature. Grants concerns
> > >about this are that the clock part of the device tree might explode when
> > >we put each and every clock into the devicetree, so he wants to allow
> > >bigger blobs of multiple clocks.
> > 
> > I can clearly understand this concern, because in the case of OMAP4,
> > we will have to add ~250 nodes if we want to define the current
> > clock tree.
> 
> I'm really not convinced that it is a good idea to break out the
> entire clock tree into one node per struct clk.  To begin with, that
> looks to be very centric around the current 'struct clk' Linux
> abstraction, which is potentially in flux.  Also, looking at Sascha's
> initial RFC for describing the clock tree, I see cases where it looks
> like a clock nexus node really makes sense.  For instance, the
> 'divider-ipg@0x53fd4014' node which has a list of child nodes
> which merely provide a register offset and shift value
> (reg=0x53fd4068..0x53fd4084, shift=0x0..0xf).

Yes, these are 6 (or 7) registers which contains all the gates. But not
all of these gates are children of the ipg clock, some are derived from
other clocks. So describing this as a nexus clock would give you 6 nexus
clocks, each having 16 parents and 16 children (we have 2 bits per gate).
Many of these clock gates go to external devices, but others are also
used internally by the clock module.
With the clock gates you picked the only example in the i.MX clock
module which has a straight forward register layout. All other muxes
and dividers are spread randomly in the registers.

> It would be natural to
> instead encode that as part of the clock reference, or map it directly
> from the clock reference (ie, assign names to each of the clocks, and
> let the clock provider driver match up the name to the reg offset &
> shift values).
> 
> I had originally thought that it would be better to use names directly
> for references to clocks (ie. clock = <phandle>,"name") , but after
> actually playing with it and looking at the existing DT conventions,
> I've reverted to cell values for the arguments and a separate set of
> clock-{input,output}-name properties for attaching meaningful names,
> just like we decided to do for assigning names to 'reg' properties.
> 
> > >My impression gets more and more that we either put the clock tree in the
> > >devicetree or we do not do it, but there's not much room in between.
> 
> I disagree here entirely because there is a lot of room in between.
> Drivers still need to understand the hardware block they are driving,
> and there will still be a lot of hardware-specific knowledge encoded
> into clock provider drivers (just as there is for every other kind of
> driver).  The trick (and even artistry) is to determine the ideal
> balance between hard coding static hardware details and
> parameterization of interconnects between blocks.

That's part of the problem. When in copy-a-new-clktree-from-datasheet-to-c
mode I don't want to be an artist at all. Instead I want to be a trained
monkey. Too many people have tried to be intelligent when hacking the
clock files which explains the mess we currently have.

Ok, as you know my original goal was only to describe the building
blocks as what they are and not arbitrarily grouped together. Originally
I did not even have the device tree in mind. I am perfectly fine with
describing the clock module as a single blob with few input clocks
and many many output clocks. Then we can internally (in C code) still
describe the building blocks.

One thing I like about the full description in the device tree is
that boards would be able to adjust divider/mux settings directly in the
device tree, but we can do without.

One thing though needs a better solution I think. What if a clock module
has 100 outputs? An UART might look like this then:

uart {
	clock-input = <&ccm 23> <&ccm 97>;
	clock-input-name = "baud", "register";
};

This would be hard to verify for correctness because of the high
numbers. Also, when a maintainer gets two patches which both add
a forgotten clock to the device tree he can't just merge them but
instead has to adjust the numbers in one patch.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
