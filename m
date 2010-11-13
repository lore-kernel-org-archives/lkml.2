Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab0KMAWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:22:20 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39386 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0KMAWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:22:19 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
	 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
	 <1289605221.3292.53.camel@localhost.localdomain>
	 <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
	 <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 00:22:02 +0000
Message-ID: <1289607722.3292.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 18:51 -0500, Andrew Lutomirski wrote:
> On Fri, Nov 12, 2010 at 6:48 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> > On Fri, Nov 12, 2010 at 6:40 PM, john stultz <johnstul@us.ibm.com> wrote:
> >> On Fri, 2010-11-12 at 16:52 -0500, Andrew Lutomirski wrote:
> >>> On Fri, Nov 12, 2010 at 4:31 PM, john stultz <johnstul@us.ibm.com> wrote:
> >>> > Ideas:
> >>> > 1) Maybe should we check that we get two sequential failures where the
> >>> > cpu seems fast before we throw out the TSC? This will still fall over
> >>> > in some stall cases (ie: a poor rt task hogging the cpu  for 10
> >>> > minutes, pausing for a 10th of a second and then continuing to hog the
> >>> > cpu).
> >>> >
> >>> > 2) We could look at the TSC delta, and if it appears outside the order
> >>> > of 2-10x faster (i don't think any cpus scale up even close to 10x in
> >>> > freq, but please correct me if so), then assume we just have been
> >>> > blocked from running and don't throw out the TSC.
> >>> >
> >>> > 3) Similar to #2 we could look at the max interval that the watchdog
> >>> > clocksource provides, and if the TSC delta is greater then that, avoid
> >>> > throwing things out. This combined with #2 might narrow out the false
> >>> > positives fairly well.
> >>> >
> >>> > Any additional thoughts here?
> >>>
> >>> Yes.  As far as I know, the watchdog doesn't give arbitrary values
> >>> when it wraps; it just wraps.  Here's a possible heuristic, in
> >>> pseudocode:
> >>>
> >>> wd_now_1 = (read watchdog)
> >>> cs_now = (read clocksource)
> >>>
> >>> cs_elapsed = cs_now - cs_last;
> >>> wd_elapsed = wd_now_1 - wd_last;
> >>>
> >>> if ( abs(wd_elapsed - cs_elapsed) < MAX_DELTA)
> >>>   return;  // We're OK.
> >>>
> >>> wd_now_2 = (read watchdog again)
> >>> if (abs(wd_now_1 - wd_now_2) > MAX_DELTA / 2)
> >>>   bail;  // The clocksource might be unstable, but we either just
> >>> lagged or the watchdog is unstable, and in either case we don't gain
> >>> anything by marking the clocksource unstable.
> >>
> >> This is more easily done by just bounding the clocksource read:
> >> wd_now_1 = watchdog->read()
> >> cs_now = clocksource->read()
> >> wd_now_2 = watchdog->read()
> >>
> >> if (((wd_now_2 - wd_now_1)&watchdog->mask) > SOMETHING_SMALL)
> >>        bail; // hit an SMI or some sort of long preemption
> >>
> >>> if ( wd_elapsed < cs_elapsed and ( (cs_elapsed - wd_elapsed) %
> >>> wd_wrapping_time ) < (something fairly small) )
> >>>   bail;  // The watchdog most likely wrapped.
> >>
> >> Huh. The modulo bit may need tweaking as its not immediately clear its
> >> right. Maybe the following is clearer?:
> >>
> >> if ((cs_elapsed > wd_wrapping_time)
> >>        && (abs((cs_elapsed % wd_wrapping_time)-wd_elapsed) < MAX_DELTA)
> >>        // should be ok.
> >
> > I think this is wrong if wd_elapsed is large (which could happen if
> > the real wd time is something like (2 * wd_wrapping_time -
> > MAX_DELTA/4)).
> 
> Also wrong if cs_elapsed is just slightly less than wd_wrapping_time
> but the wd clocksource runs enough faster that it wrapped.

Ok. Good point, that's a problem. Hrmmmm. Too much math for Friday. :)

And your implementation above hits the same issue..  hrm.

I want to say we can get away with it using the same twos-complement
masking trick we use for subtracting around an overflow to calculate
cycle deltas, but I'm not confident it will work when we've moved from
clean bit field masks to nanosecond intervals.

I think I'll have to revisit this on Monday.

Thanks again for pointing out this think-o.
-john







