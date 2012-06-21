Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2FUAHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:07:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:23907 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab2FUAHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182956032"
Date: Wed, 20 Jun 2012 17:07:34 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120621000734.GB32743@xanatos>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 05:24:28PM -0500, Alexis Cortes wrote:
> Hi Sarah,
> 
> First of all, thanks for your reply.
> 
> On the subject, although the workaround is implemented on the host
> controller, the problem is not with our host controller but with our
> SN65LVPE502CP redriver (http://www.ti.com/product/sn65lvpe502cp).

Is a redriver something motherboard manufacturers choose?  Or is a
redriver always sold paired with a particular host controller chip?

> As
> mentioned in our previous email, we discovered a timing issue in that
> version of our USB3.0 re-driver that can delay the negotiation between a
> device and the host past the usual handshake timeout, and if that happens on
> the first insertion, the host controller port will enter in Compliance mode
> as per the xHCI spec (Section 4.19.4 of the xHCI 1.0 spec "If a timeout is
> detected on the first LFPS handshake, the port transitions to the Compliance
> state and NO change flag is set");

How often is this timing issue hit?  On every plug in?  Every 100 plug
ins?  Is it specific to which devices are plugged in or can it be
triggered for any device?  Does the redriver get stuck in this state, or
is it transient?

Basically, will the user say, "Sometimes I plug the USB device in, and
it doesn't work, but then I unplug and replug it, and it works"?

> in conclusion No host controller will
> generate a Port Status Change (PSC) event (regardless of the host vendor) as
> a result of a transition to compliance mode and any port that has this piece
> of hardware between the root port and the physical port, it is most likely
> to suffer of this condition. 

That seems like a spec bug.  SW really needs to know when a failed link
training happens.  I've emailed the xHCI spec architect, and we'll see
if we can get an errata to set the PLC bit when the port goes into
compliance mode.

> Unfortunately there is not a way to programmatically detect if the re-driver
> is present on the system, and since it might affect any host controller, I'm
> afraid this workaround can't be limited on the driver to specific hardware. 

Ok, then make it a module parameter that is off by default.  Users who
find they have this issue can reload the driver with the timer on, and
add the module parameter to their grub linux boot line.  If we find that
the redriver is used always for one particular host vendor/revision,
we'll add a quirk for it.

But I really don't want an extra timer running and killing power
management for hosts that don't need this work around.

You should look at using slacktimers so that the timer can be grouped
with other timers.  It's not imperative that your timer runs exactly
every two seconds, so that might save power management a bit.  You
probably set the timer slack up to 500ms or a second without much user
experience degradation.  Here's an LWN article on slacktimers:

http://lwn.net/Articles/369549/

> Regarding the patch description I'm planning to add this: "This patch is
> intended to work around a known issue on the SN65LVPE502CP USB3.0 re-driver
> that can delay the negotiation between a device and the host past the usual
> handshake timeout, and if that happens on the first insertion, the host
> controller port will enter in Compliance mode as per the xHCI spec. The
> patch creates a timer which polls every 2 seconds the link state of each
> host controller's port (this by reading the PORTSC register) and recovers
> the port by issuing a Warm reset every time Compliance mode is detected."

Sounds fine.

> >> +			temp = xhci_port_state_to_neutral(temp);
> >> +			temp |= PORT_WR;
> >> +			xhci_writel(xhci, temp, xhci->usb3_ports[i]);
> >> +			xhci_dbg(xhci, "Compliance Mode Detected. Warm "
> >> +				       "reset performed to port %d for "
> >> +				       "recovery.\n", i + 1);
> > 
> > Instead of doing the warm reset here, you need to let the USB core handle
> it.
> > Here, you should kick khubd for the USB 3.0 roothub by calling
> > usb_hcd_poll_rh_status().  Look at
> > xhci-ring.c:handle_port_status() for an example.
> > 
> > Then in the xhci-hub.c code that checks for port changes, you should fake
> a
> > link status change.  The USB core will notice the status change and see
> the
> > port's link status of compliance.  Then the USB core will take care of
> issuing
> > the warm reset and doing a proper job of timing it.
> > 
> > You can see this sort of process by looking at the recent CAS patch:
> > http://marc.info/?l=linux-usb&m=134002582807373&w=2
> > 
> > Your patch will need to be built on top of that one, since that patch adds
> > support for issuing a warm reset when compliance mode is detected.
> 
> I made the patch the easiest way I could think off. I will explore this path
> you're proposing and change my patch. Has this patch you're mentioning
> already been committed to the usb-next branch?

It hasn't been queued to Greg yet.  I was waiting to see if it needed
another revision, but it looks like Andiry acked it.  I'm going to be
sending it off to Greg for the usb-linus branch, not the usb-next
branch, because it's a bug fix, not a new feature.  It's marked for
stable as well.

Your patch would come through my tree, so you should just base your
patch on my for-usb-linus branch:

http://git.kernel.org/?p=linux/kernel/git/sarah/xhci.git;a=shortlog;h=refs/heads/for-usb-linus

> >> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h index
> >> de3d6e3..0f11cb8 100644
> >> --- a/drivers/usb/host/xhci.h
> >> +++ b/drivers/usb/host/xhci.h
> >> @@ -1506,6 +1506,10 @@ struct xhci_hcd {
> >>  	unsigned		sw_lpm_support:1;
> >>  	/* support xHCI 1.0 spec USB2 hardware LPM */
> >>  	unsigned		hw_lpm_support:1;
> >> +	/* Compliance Mode Recovery Timer */
> >> +	struct timer_list comp_mode_rcvry_timer;
> >> +/* Compliance Mode Timer Triggered every 2 seconds */ #define
> >> +COMP_MODE_RCVRY_TIMEOUT 2
> > 
> > How often do you really need this timer to run?  Do you really want to
> wake
> > your CPU out of deep C states every two seconds?  Is there any way you can
> > narrow the scope of when the timer runs so that it doesn't run that often,
> or
> > increase this timeout to something like 10 seconds?
> 
> If this compliance mode gets to happen, 10 seconds could be too much waiting
> for an end user to see proper enumeration of their device, I think.

Meh, the USB storage driver waits five seconds for all devices, and that
seems tolerable to me.  But I'm fine with it being two seconds if it's a
module parameter that defaults to false.

> Also I'm
> planning to disable the timer once all of host's ports have enter U0 (since
> a port can't enter compliance mode once it has previously entered U0) to
> reduce timer's overload.

So it will still run if there is any empty USB port on the system?  And
what if some of the ports are in other link states, like U3?

Sarah Sharp
