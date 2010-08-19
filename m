Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0HSM17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:27:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0HSM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:27:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Date: Thu, 19 Aug 2010 14:28:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: john stultz <johnstul@us.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
References: <cover.1281956490.git.richard.cochran@omicron.at> <1282176776.2865.100.camel@localhost.localdomain> <20100819055518.GA4084@riccoc20.at.omicron.at>
In-Reply-To: <20100819055518.GA4084@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191428.04546.arnd@arndb.de>
X-Provags-ID: V02:K0:xzOZUtvf0m3GCbwlNTigaKS+K6xE28p9Gp72CDvpGgt
 MYWRUywX+YVplwA/JTITatXs8RdATTq6ncG/PkriZ76J9pECfe
 ui0y0CZH80IWWXGK6bheV3Bvdl3aET44LOTGzF7l3jHJzNrdcO
 hmVZcHtzMv6dIk+cLvvkQJsGpEv+vD0L8i+Nm6eDZt8uQyw6pc
 hmGz5e5187ZqS8VBt1OKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010, Richard Cochran wrote:
> On Wed, Aug 18, 2010 at 05:12:56PM -0700, john stultz wrote:
> > On Wed, 2010-08-18 at 09:19 +0200, Richard Cochran wrote:
> > > The timer/alarm stuff is "ancillary" and is not at all necessary. It
> > > is just a "nice to have." I will happily remove it, if it is too
> > > troubling for people.
> > 
> > If there's a compelling argument for it, I'm interested to hear. But
> > again, it seems like just
> > yet-another-way-to-get-alarm/timer-functionality, so before we add an
> > extra API (or widen an existing API) I'd like to understand the need.
> 
> We don't really need it, IMHO.
> 
> But if we offer clockid_t CLOCK_PTP, then we get timer_settime()
> without any extra effort.

Makes sense.

> > So in thinking about this, try to focus on what the new clock_id
> > provides that the other existing clockids do not? Are they at comparable
> > levels of abstraction? 15 years from now, are folks likely to still be
> > using it? Will it be maintainable? etc...
> 
> Arnd convinced me that clockid_t=CLOCK_PTP is a good fit.

My point was that a syscall is better than an ioctl based interface here,
which I definitely still think. Given that John knows much more about
clocks than I do, we still need to get agreement on the question that
he raised, which is whether we actually need to expose this clock to the
user or not.

If we can find a way to sync system time accurate enough with PTP and
PPS, user applications may not need to see two separate clocks at all.

> My plan would be to introduce just one additional syscall:
> 
> SYSCALL_DEFINE3(clock_adjtime, const clockid_t, clkid,
> 		int, ppb, struct timespec __user *, ts)
> 
> ppb - desired frequency adjustment in parts per billion
> ts  - desired time step (or jump) in <sec,nsec> to correct
>       a measured offset
> 
> Arguably, this syscall might be useful for other clocks, too.

This is a mix of adjtime and adjtimex with the addition of
the clkid parameter, right?

Have you considered passing a struct timex instead of ppb and ts?

Is using ppb instead of the timex ppm required to get the accuracy
you want?

	Arnd
