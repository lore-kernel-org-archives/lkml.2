Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2KMTOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:14:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37687 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754579Ab2KMTOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:14:45 -0500
Message-ID: <1352834072.16401.100.camel@thor>
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-serial@vger.kernel.org
Date: Tue, 13 Nov 2012 14:14:32 -0500
In-Reply-To: <20121113003338.6aafd7c8@stein>
References: <1350565015.23730.4.camel@thor>
	 <cover.1351817601.git.peter@hurleysoftware.com>
	 <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
	 <20121113003338.6aafd7c8@stein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 00:33 +0100, Stefan Richter wrote:
> On Nov 02 Peter Hurley wrote:
> > This patch provides the kernel driver for high-speed TTY
> > communication over the IEEE 1394 bus.
> > 
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> 
> Hi Greg,
> 
> you asked for an Ack.  Here it is:  I am OK with this getting added to the
> staging tree.
> 
> (Sorry for the delay, I was ill and at the same time buried in work at the
> day job.)  Note, I only quickly scrolled through v1 and v2.  I will do an
> actual review when somebody asks to move this from staging into a proper
> mainline place.

Hi Stefan,

Thanks very much for looking over this submission. (I hope you're
feeling better.)

> Peter,
> below are some high-level comments to your TODOs.

> > --- /dev/null
> > +++ b/drivers/staging/fwserial/Kconfig
> > @@ -0,0 +1,9 @@
> > +config FIREWIRE_SERIAL
> > +       tristate "TTY over Firewire"
> > +       depends on FIREWIRE
> > +       help
> > +          This enables TTY over IEEE 1394, providing high-speed serial
> > +	  connectivity to cabled peers.
> > +
> > +	  To compile this driver as a module, say M here:  the module will
> > +	  be called firewire-serial.
> 
> This should mention that this is a Linux-only affair at this time:  It uses
> an ad-hoc defined protocol which no other platform is known to support for
> the time being.

Good point. I'll make this change.

> > --- /dev/null
> > +++ b/drivers/staging/fwserial/TODO
> > @@ -0,0 +1,37 @@
> > +TODOs
> > +-----
> > +1. Implement retries for RCODE_BUSY, RCODE_NO_ACK and RCODE_SEND_ERROR
> > +   - I/O is handled asynchronously which presents some issues when error
> > +     conditions occur.
> > +2. Implement _robust_ console on top of this. The existing prototype console
> > +   driver is not ready for the big leagues yet.
> > +3. Expose means of controlling attach/detach of peers via sysfs. Include
> > +   GUID-to-port matching/whitelist/blacklist.
> > +
> > +-- Issues with firewire stack --
> > +1. This driver uses the same unregistered vendor id that the firewire core does
> > +     (0xd00d1e). Perhaps this could be exposed as a define in
> > +     firewire-constants.h?
> 
> I guess there is no better OUI for this purpose.
> 
> The constant could be added to linux/firewire.h, but IMO rather not to
> uapi/linux/firewire-constants.h.  We don't want this definition to leak
> out to userland; userland can hardwire its own hacks itself. :-)
> 
> This trivial move to a header should be deferred until the driver moves
> out of staging.

You're right. I'll update the TODO.

And I should have noted in the TODO file itself that the issues noted
are for moving the driver out of staging.

> > +2. MAX_ASYNC_PAYLOAD needs to be publicly exposed by core/ohci
> > +   - otherwise how will this driver know the max size of address window to
> > +     open for one packet write?
> 
> Hmm, don't firewire-sbp2 and firewire-net deal with this very problem
> already on their own?  Firewire-sbp2 tells the target what maximum payload
> the local node is ready to accept, and firewire-net figures out whether it
> needs to fragment the datagrams in unicast TX depending on the remote
> node's capabilities.

I wasn't as clear as I should have been here. This is only about how big
to make the address handler window. Just like firewire-net, this driver
communicates with remotes at S100 speeds (and packet sizes) to
query the largest packet size that the remote supports.

Currently, firewire-net sets an arbitrary address handler length of
4096. This works because the largest AR packet size the current
firewire-ohci driver handles is 4096 (value of MAX_ASYNC_PAYLOAD) +
header/trailer. Note that firewire-ohci does not limit card->max_receive
to this value.

So if the ohci driver changes to handle 8K+ AR packets and the hardware
supports it, these address handler windows will be too small.

> > +3. Maybe device_max_receive() and link_speed_to_max_payload() should be
> > +     taken up by the firewire core?
> 
> Sounds like an extension of item 2, and is easier resolved after the
> driver moves out of staging.

Ok.

> > +4. To avoid dropping rx data while still limiting the maximum buffering,
> > +     the size of the AR context must be known. How to expose this to drivers?
> 
> I don't see a requirement to know the local or remote node's size of AR
> DMA buffer.  Rather, keep the traffic throttled such that too frequent
> ack-busy are avoided.  As far as I have learned from firewire-net, just
> limiting the number or in-flight transactions should work reasonably.  Of
> course, hardware ack-busy retries which the OHCI performs on its own won't
> be noticed by software but take away from overall bus bandwidth.  IOW the
> optimum queue depth is by a certain margin less than the depth at which
> software starts to see ack-busy transaction terminations.
> 
> Furthermore:  In order to avoid dropping data, you don't need to know the
> buffer size at all.  You need to implement proper software retries.  I.e.
> either those which you noted yourself at the top of this TODO file, or you
> let the userland on top of the TTY handle it if this is possible.  (I
> don't know how the TTY subsystem and TTY based applications work.)

I do need to implement retries but that will be of limited benefit to
this particular problem.

Data is written from the remote as a posted write into the AR buffer.
The remote receives hardware ack and continues writing more. Meanwhile,
the local node schedules the AR tasklet. The AR tasklet runs,
dispatching the packets to each appropriate handler. So, by the time
this driver's handler is delivered the first packet, many packets could
already have been acked and sitting in the AR buffer. At this point,
throttling the remote will only prevent the remote from sending even
more, and can't help with the data which has already been received.

The driver already limits the max in-flight transactions to 8. But since
they're unified transactions, that doesn't do much. Under heavy loads,
there may be many (small) completed packets in the AR buffer (NB: the
driver already does write aggregation but this isn't appropriate in the
console driver).

Besides the inefficiency of re-sending data that has already been
received, retrying may not be possible. Consider when a console driver
(work-in-progress) writes to the remote using the same interface. It
could be one of the last things the remote does. And the most crucial
information is that last write.

Despite my lengthy description, I agree that knowing the size of the AR
context is not a requirement, and we can drop this as an issue. As you
suggest, I can determine the appropriate buffer size experimentally (and
implement retries).

> > +5. Explore if bigger AR context will reduce RCODE_BUSY responses
> > +   (or auto-grow to certain max size -- but this would require major surgery
> > +    as the current AR is contiguously mapped)
> 
> For the particular application "firewire-net", the present AR-Req DMA
> buffer size has apparently been determined as suitable.  Of course if you
> find a different optimum, that could certainly be changed.
> 
> I haven't looked closely, but I suppose your bandwidth requirement
> concerns AR-Request DMA, not so much AR-Response DMA, right?

Exactly. And I was just thinking to myself there which unfortunately
slipped into a public document :)

Thanks again for your time, Stefan.

Regards,
Peter Hurley


