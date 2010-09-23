Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0IWVII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:08:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40905 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752425Ab0IWVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:08:06 -0400
Date: Thu, 23 Sep 2010 22:30:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100923223025.2877cce2@lxorguk.ukuu.org.uk>
In-Reply-To: <1285274952.2587.113.camel@localhost.localdomain>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	<20100923213654.0c64b047@lxorguk.ukuu.org.uk>
	<1285274952.2587.113.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> I don't see how this is a problem, as it exposes the multiple hardware
> clocks via different posix clock ids. So in the boundary clock case, you
> can configure which side is the client and which side is the master in a
> config file and the PTPd will appropriately steer them individually.

They may all be slaves - that means you can't treat them as part of
system time.
> 

> on module unload, but I don't think we need a use-count to prevent the
> module from being unloaded.
> 
> My question would be: How do we handle a USB network device ($14.99 now
> with PTP!) being unplugged? We can't say "Sorry! That's in use!". So we
> note the hardware is gone, and return the proper error code.
> 
> Or am I missing something else?

Open list
Oh number 31 appears to be the device I want
Close list

	USB unplugged
	Random other device plugged

clock_op(31, ....)

Oh bugger I've just reprogrammed the wrong time source.

We don't have stop the device being removed, instead of a disaster you get

	clock_op(fd, blah)
	-ENODEV

which btw is how just about everything else USB works when you pull the
hardware.

> > And about 40 already supported by char driver interface clocks and rtcs
> > in the kernel...
> 
> And those char driver interfaces are all subtly different.
> 
> I actually recently submitted an RFC to expose the RTC devices via the
> posix clock/timer interface, because working with the RTC hardware
> device directly is terrible for managing alarm interrupts. 

Given that driver interfaces are sane and posix clock/timer interfaces
have totally broken enumeration maybe you have it backwards. But if you
follow through to my proposal maybe there is a saner answer still
 
> For instance, you easily run into the case where your TV recording
> application programs an alarm to record your favorite show at 8pm. Then
> your backup script programs an alarm to wake up at 2am to do your
> nightly backups. Your box suspends and the next morning, you're missing
> your favorite show!

Poor resource management, and yes I'd agree you want a sensible interface.


> > Drop the clockid_t and swap it for a file handle like a proper Unix or
> > Linux interface. The rest is much the same
> > 
> > 	fd = open /sys/class/timesource/[whatever]
> > 
> > 	various queries you may want to do to check the name etc
> > 
> > 	fclock_adjtime(fd, ...)
> > 	
> > 
> > The posix interface is fundamentally flawed. It only works for staticly
> > enumerable objects. Unix avoided that forty years ago by making the
> > identifier a handle which immediately cures all your object lifetime
> > problems in one swoop.
> 
> So, I don't really see how that's so different from what is being
> proposed. The clock_id is dynamically assigned per registered clock, and
> exposed via the sysfs interface from ptp hardware entry.
> 
> The only difference is the open/close reference counting, which I don't
> think is necessary here (since we can't always keep the hardware from
> going away).

It is absolutely neccessary in order that you can be sure that two calls
actually relate to the *same* device. It's as fundamental as the
difference betweeh chmod and fchmod although with the added ugliness of
some random numeric identifier stuck in the middle.

It also btw makes it much easier to fix up the existing random collection
of /dev/rtc devices - because you can open them and issue fclock_adjtime
if we are careful how we do it and it makes sense.

Alan
