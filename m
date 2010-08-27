Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0H0LIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:08:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0H0LIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=istmhNkAWI8970ugNGPoSTAiyjLN97KpTg16FlO+wrfpcRpUKxVTAXFG/oUObz6PhZ
         uNS0mptw13F9vIkdHV/b5AliuEbWKzMm9JlJRpCGlkcLcf1CsKWG0qsDEwKKVqzzgO+1
         ItE628s5x9y3LKS6JZLXJu7HKIokhORZ8bR84=
Date: Fri, 27 Aug 2010 13:08:55 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100827110855.GA11657@riccoc20.at.omicron.at>
References: <cover.1281956490.git.richard.cochran@omicron.at>
 <1282176776.2865.100.camel@localhost.localdomain>
 <20100819055518.GA4084@riccoc20.at.omicron.at>
 <201008191428.04546.arnd@arndb.de>
 <20100819153847.GA10695@riccoc20.at.omicron.at>
 <1282594899.3111.358.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282594899.3111.358.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 01:21:39PM -0700, john stultz wrote:
> On Thu, 2010-08-19 at 17:38 +0200, Richard Cochran wrote:
> > On Thu, Aug 19, 2010 at 02:28:04PM +0200, Arnd Bergmann wrote:
> > > My point was that a syscall is better than an ioctl based interface here,
> > > which I definitely still think. Given that John knows much more about
> > > clocks than I do, we still need to get agreement on the question that
> > > he raised, which is whether we actually need to expose this clock to the
> > > user or not.
> > > 
> > > If we can find a way to sync system time accurate enough with PTP and
> > > PPS, user applications may not need to see two separate clocks at all.
> > 
> > At the very least, one user application (the PTPd) needs to see the
> > PTP clock.
> > 
> > > > SYSCALL_DEFINE3(clock_adjtime, const clockid_t, clkid,
> > > > 		int, ppb, struct timespec __user *, ts)
> > > > 
> > > > ppb - desired frequency adjustment in parts per billion
> > > > ts  - desired time step (or jump) in <sec,nsec> to correct
> > > >       a measured offset
> > > > 
> > > > Arguably, this syscall might be useful for other clocks, too.
> > > 
> > > This is a mix of adjtime and adjtimex with the addition of
> > > the clkid parameter, right?
> > 
> > Sort of, but not really. ADJTIME(3) takes an offset and slowly
> > corrects the clock using a servo in the kernel, over hours.
> > 
> > For this function, the offset passed in the 'ts' parameter will be
> > immediately corrected, by jumping to the new time. This reflects the
> > way that PTP works. After the first few samples, the PTPd has an
> > estimate of the offset to the master and the rate difference. The PTPd
> > can proceed in one of two ways.
> > 
> > 1. If resetting the clock is not desired, then the clock is set to the
> >    maximum adjustment (in the right direction) until the clock time is
> >    close to the master's time.
> > 
> > 2. The estimated offset is added to the current time, resulting in a
> >    jump in time.
> > 
> > We need clock_adjtime(id, 0, ts) for the second case.
> >
> > > Have you considered passing a struct timex instead of ppb and ts?
> > 
> > Yes, but the timex is not suitable, IMHO.
> 
> Could you expand on this?

We need to able to specify that the call is for a PTP clock. We could
add that to the modes flag, like this:

/*timex.h*/
#define ADJ_PTP_0 0x10000
#define ADJ_PTP_1 0x20000
#define ADJ_PTP_2 0x30000
#define ADJ_PTP_3 0x40000

I can live with this, if everyone else can, too.
 
> Could we not add a adjustment mode ADJ_SETOFFSET or something that would
> provide the instantaneous offset correction?

Yes, but we would also need to add a struct timespec to the struct
timex, in order to get nanosecond resolution. I think it would be
possible to do in the padding at the end?

> You're right that the timex is a little crufty. But its legacy that we
> will support indefinitely. So following the established interface helps
> maintainability.

We can use it for PTP, with the modifications suggested above. Or we
can just introduce the clock_adjtime method, instead.
 
> So if the clock_adjtime interface is needed, it would seem best for it
> to be generic enough to support not only PTP, but also the NTP kernel
> PLL.

For the proposed clock_adjime, what else is needed to support clock
adjustment in general?

I don't mind making the interface generic enough to support any
(realistic) conceivable clock adjustment scheme, but beyond the
present PTP hardware clocks, I don't know what else might be needed.

Richard


