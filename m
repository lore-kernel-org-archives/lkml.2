Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0IXNuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:50:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63609 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0IXNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MF2/Y2NMcQJ4kSGe9iqzOy2X3xSZ7rvipKoJ5s6K3xls3In/zUt+riQOSX7F9CT0jw
         34jzMvfm7BIEaH2Vprl5nALk79uoysGVL+XTUjkkgDpQqpjxykxY+PwPDWG2BN2HUBBr
         8aRHiVTgveDsMK6THS3dy8wCcvkbCVW6Q6rHE=
Date: Fri, 24 Sep 2010 15:50:01 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100924135001.GB3113@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
 <1285270733.2587.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285270733.2587.46.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:38:53PM -0700, john stultz wrote:
> On Thu, 2010-09-23 at 19:30 +0200, Richard Cochran wrote:
> >     /sys/class/timesource/<name>/id
> >     /sys/class/ptp/ptp_clock_X/id
> > 
> So yea, I'm not a fan of the "timesource" sysfs interface. One, I think
> the name is poor (posix_clocks or something a little more specific would
> be an improvement), and second, I don't like the dictionary interface,
> where one looks up the clock by name.
> 
> Instead, I think having the id hanging off the class driver is much
> better, as it allows mapping the actual hardware to the id more clearly.
> 
> So I'd drop the "timesource" listing. And maybe change "id" to
> "clock_id" so its a little more clear what the id is for.

Okay, I will drop /sys/class/timesource (hope Alan Cox agrees :)

I threw it out there mostly for the sake of discussion. I imagined
that there could be other properties in that directory, like time
scale (TAI, UTC, etc). But it seems like we don't really need anything
in that direction.

> > 3.3 Synchronizing the Linux System Time 
> > ========================================
> > 
> >    One could offer a PHC as a combined clock source and clock event
> >    device. The advantage of this approach would be that it obviates
> >    the need for synchronization when the PHC is selected as the system
> >    timer. However, some PHCs, namely the PHY based clocks, cannot be
> >    used in this way.
> 
> Again, I'd scratch this. 

Okay, I only wanted to preempt the question which people are asking
all the time: why can't it work with the system clock transparently?

> >    Instead, the patch set provides a way to offer a Pulse Per Second
> >    (PPS) event from the PHC to the Linux PPS subsystem. A user space
> >    application can read the PPS events and tune the system clock, just
> >    like when using other external time sources like radio clocks or
> >    GPS.
> 
> Forgive me for a bit of a tangent here:
> 	So while I think this PPS method is a neat idea, I'm a little curious
> how much of a difference the PPS method for syncing the clock would be
> over just a simple reading of the two clocks and correcting the offset.
> 
> It seems much of it depends on the read latency of the PTP hardware vs
> the interrupt latency. Also the PTP clock granularity would effect the
> read accuracy (like on the RTC, you don't really know how close to the
> second boundary you are).
> 
> Have you done any such measurements between the two methods?

I have not yet tested how well the PPS method works, but I expect at
least as good results as when using a GPS.

> I just
> wonder if it would actually be something noticeable, and if its not, how
> much lighter this patch-set would be without the PPS connection.

As you say, the problem with just reading two clocks at nearly the
same time is that you have two uncertain operations. If you use a PPS,
then there is only one clock to read, and that clock is the system
clock, which hopefully is not too slow to read!

In addition, PHY reads can sleep, and that surely won't work. Even with
MAC PHCs, reading outside of interrupt context makes you vulnerable to
other interrupts.

> Again, this isn't super critical, just trying to make sure we don't end
> up adding a bunch of code that doesn't end up being used.

The PPS hooks are really only just a few lines of code.

The great advantage of a PPS approach over and ad-hoc "read two clocks
and compare", is that, with a steady, known sample rate, you can
analyze and predict your control loop behavior. There is lots of
literature available on how to do it. IMHO, that is the big weakness
of the timecompare.c stuff used in the current IGB driver.

> Also PPS
> interrupts are awfully frequent, so systems concerned with power-saving
> and deep idles probably would like something that could be done at a
> more coarse interval.

We could always make the pulse rate programmable, for power-saving
applications.

> > 4.1 Supported Hardware Clocks 
> > ==============================
> > 
> >    + Standard Linux system timer
> >      This driver exports the standard Linux timer as a PTP clock.
> >      Although this duplicates CLOCK_REALTIME, the code serves as a
> >      simple example for driver development and lets people who without
> >      special hardware try the new API.
> 
> Still not a fan of this one, figure the app should handle the special
> case where there are no PTP clocks and just use CLOCK_REALTIME rather
> then funneling CLOCK_REALTIME through the PTP interface.

It is really just as an example and for people who want to test driver
the API. It can surely be removed before the final version...

Thanks for your comments,

Richard
