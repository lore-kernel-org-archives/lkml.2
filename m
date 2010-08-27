Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0H0Us1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:48:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33121 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0H0Us0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:48:26 -0400
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
From: John Stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100827112406.GB11657@riccoc20.at.omicron.at>
References: <cover.1282550649.git.richard.cochran@omicron.at>
	 <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
	 <201008231457.26690.arnd@arndb.de>
	 <1282596073.3111.373.camel@localhost.localdomain>
	 <20100827112406.GB11657@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:48:20 -0700
Message-ID: <1282942100.2268.53.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 13:24 +0200, Richard Cochran wrote:
> On Mon, Aug 23, 2010 at 01:41:13PM -0700, john stultz wrote:
> > As I mentioned in the previous mail, I agree the new functionality
> > (adjusting the time by an offset instantaneously) is useful, but I'd
> > prefer it be done initially within the existing adjtimex() interface.
> 
> But the adjtimex does not support nanosecond resolution.

As mentioned in the last mail, that's not the case. 

> > Then if the posix-time clock_id multiplexing version of adjtimex is
> > found to be necessary, the new syscall should be introduced, using the
> > same API (not all clock_ids need to support all the adjtimex modes, but
> > the new interface should be sufficient for NTPd to use).
> 
> Would the new syscall need to take a struct timex?
> 
> If so, I think it not worth the effort of adding a syscall. Instead,
> we can just add "clockid" flags into the mode field.

Personally I'd add the new clock_adjtime interface, since it parallels
the gettimeofday/clock_gettime() interface levels. Trying to multiplex
posix clock ids via the older interface feels a little ugly.


> > There are some other conceptual issues this new syscall introduces:
> > 
> > 1) While clock_adjtimex(CLOCK_REALTIME,...) would be equivalent to
> > adjtimex(), would clock_adjtimex(CLOCK_MONOTONIC,...) make sense? 
> > 
> > Given CLOCK_MONOTONIC and CLOCK_REALTIME are both based off the same
> > notion of time, but offset from each other, any adjustment to one clock
> > would be reflected in the other. However, the API would make it seem
> > like they could be adjusted independently.
> 
> You could adjust the frequency of either one. As a side effect, the
> other clock would also be adjusted.

This in most ways makes the most sense to me, since if CLOCK_REALTIME is
properly freq corrected, it would seem CLOCK_MONOTONIC would as well.

> You can only change the time offset on CLOCK_REALTIME, and that would
> have no effect on CLOCK_MONOTONIC.

But yes, this is another possibly valid interpretation. I don't prefer
this one, but that doesn't make it invalid. And so with the new
interface, and the possibility of multiple non-synced clocks, there are
more unfortunate subtleties like this. 


> > 3) Freq steering for MONOTONIC_RAW would defeat the purpose of the
> > clock_id.
> 
> If I understand correctly, MONOTONIC_RAW is just access to the
> hardware counter?

Not exactly. Its abstracted out a step. MONOTONIC_RAW was added as there
were other applications that were trying to get to raw hardware counters
through various means. Unfortunately that caused portability issues. So
CLOCK_MONOTONIC_RAW allows a constant freq nanosecond representation of
a hardware counter.

This is similar to what I'm hoping to find here with CLOCK_PTP.

Is there a step out that makes this interface similarly abstracted out
and easier to understand from a userland perspective?  (This is the
similar to Alan's critique that it needs to not be PTP specific). 

Additionally, I'm trying to make sure that having multiple unsynced
clocks accessible from the same top-level interface isn't going to
become a headache down the road API wise.

If we abstract CLOCK_PTP out, doesn't it in effect just be
CLOCK_REALTIME_BUTDIFFERENT?

thanks
-john



