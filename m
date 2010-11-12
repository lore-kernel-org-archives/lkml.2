Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0KLXki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:40:38 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59301 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KLXkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:40:36 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
	 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 15:40:21 -0800
Message-ID: <1289605221.3292.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 16:52 -0500, Andrew Lutomirski wrote:
> On Fri, Nov 12, 2010 at 4:31 PM, john stultz <johnstul@us.ibm.com> wrote:
> > Ideas:
> > 1) Maybe should we check that we get two sequential failures where the
> > cpu seems fast before we throw out the TSC? This will still fall over
> > in some stall cases (ie: a poor rt task hogging the cpu  for 10
> > minutes, pausing for a 10th of a second and then continuing to hog the
> > cpu).
> >
> > 2) We could look at the TSC delta, and if it appears outside the order
> > of 2-10x faster (i don't think any cpus scale up even close to 10x in
> > freq, but please correct me if so), then assume we just have been
> > blocked from running and don't throw out the TSC.
> >
> > 3) Similar to #2 we could look at the max interval that the watchdog
> > clocksource provides, and if the TSC delta is greater then that, avoid
> > throwing things out. This combined with #2 might narrow out the false
> > positives fairly well.
> >
> > Any additional thoughts here?
> 
> Yes.  As far as I know, the watchdog doesn't give arbitrary values
> when it wraps; it just wraps.  Here's a possible heuristic, in
> pseudocode:
> 
> wd_now_1 = (read watchdog)
> cs_now = (read clocksource)
> 
> cs_elapsed = cs_now - cs_last;
> wd_elapsed = wd_now_1 - wd_last;
> 
> if ( abs(wd_elapsed - cs_elapsed) < MAX_DELTA)
>   return;  // We're OK.
> 
> wd_now_2 = (read watchdog again)
> if (abs(wd_now_1 - wd_now_2) > MAX_DELTA / 2)
>   bail;  // The clocksource might be unstable, but we either just
> lagged or the watchdog is unstable, and in either case we don't gain
> anything by marking the clocksource unstable.

This is more easily done by just bounding the clocksource read:
wd_now_1 = watchdog->read()
cs_now = clocksource->read()
wd_now_2 = watchdog->read()

if (((wd_now_2 - wd_now_1)&watchdog->mask) > SOMETHING_SMALL)
	bail; // hit an SMI or some sort of long preemption

> if ( wd_elapsed < cs_elapsed and ( (cs_elapsed - wd_elapsed) %
> wd_wrapping_time ) < (something fairly small) )
>   bail;  // The watchdog most likely wrapped.

Huh. The modulo bit may need tweaking as its not immediately clear its
right. Maybe the following is clearer?:

if ((cs_elapsed > wd_wrapping_time) 
	&& (abs((cs_elapsed % wd_wrapping_time)-wd_elapsed) < MAX_DELTA)
	// should be ok.


> The idea is that there are three obvious causes for false positives.
> 
> 1. Something caused the watchdog itself to lag.  In this case, the
> second watchdog read will differ from the first one by a lot and we'll
> bail.
> 
> 2. The TSC wrapped in the time between two watchdog checks.  I don't
> think that this is very likely on x86 CPUs.  (Tsn't the TSC always 64
> bits?  By the time that a 20GHz CPU wraps a 64-bit TSC, you're
> probably already replaced the computer.)

Yea, current TSCs won't wrap in our lifetime. And even if it ever does
get close, it will have to wrap between watchdog checks to be an issue
(since twos-compliment math makes the subtraction work even if it does
roll over).


> 3. The watchdog wrapped in the time between two watchdog checks.  In
> this case, unless something else went wrong simultaneously, we'll
> detect it.
> 
> On the other hand, the chance that the TSC was unstable by almost
> exactly a multiple of the watchdog wrapping time is pretty unlikely.
> 
> 
> If we're using a non-TSC clocksource, then you could get false
> positives if that clocksource wraps, but maybe the watchdog is
> unnecessary in that case.

Yea. Some similar extra modulo conditions could probably handle that
too. But again, the only clocksource that needs the watchdog is the TSC.

thanks
-john


