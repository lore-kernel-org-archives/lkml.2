Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0CXFpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:45:39 -0400
Received: from ozlabs.org ([203.10.76.45]:55535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0CXFpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:45:38 -0400
Date: Wed, 24 Mar 2010 16:45:31 +1100
From: Paul Mackerras <paulus@samba.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: fix remapped count support
Message-ID: <20100324054531.GA30416@drongo>
References: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 06:25:01PM +0200, Stephane Eranian wrote:

> The patch adds a new field to the perf_mmap_page buffer header (delta_base).
> It is necessary to correctly scale the count. This new value represents the
> counter value when the event was last scheduled in. It cannot be substracted
> by the kernel from the total count because of scaling. The correct formula is:
> 
> 	 count = offset * time_enabled/time_running + (raw_count - prev_count)

Interesting.  On powerpc I took the view that what was needed from a
user-space direct_counter_read() function was to return the same value
as a read() on the event counter fd would give, that is, the unscaled
count.  The stuff that's in the mmapped page is sufficient to compute
the unscaled count, and I already have userspace code on powerpc that
does that.

We don't currently have a way to work out up-to-the-nanosecond values
of time_enabled and time_running in userspace, though it could be
done.  Userspace would have to read the timebase or TSC (or
equivalent), subtract a base value, multiply by a scale factor, and
add that on to the time_enabled/time_running values stored in the
mmapped page.  Although this is all quite doable on powerpc where the
timebase counts at constant frequency and is synchronized across cpus,
it seemed like it could get complicated on x86 where the TSC might
change speed and might not be synchronized (though I suppose we only
need to supply the values relevant to the cpu where the monitored
thread is running).

Your equation above contains the insight that if one wants to scale
readings by time_enabled/time_running, the scaling only needs to be
applied to the count as of the last time the event got scheduled, and
then we can add on the delta count since then, unscaled.  (That isn't
mathematically exactly the same if the event rate is changing, but it
should be close.)

That's probably a useful thing to do, but I think there are other uses
of time_enabled and time_running, for example for estimating error
bounds on the scaled count, or for knowing whether the event has been
on the PMU at all in a given time interval.  That's the main reason
that the read() interface gives the unscaled count plus (optionally)
time_enabled and time_running, rather than giving only the scaled
count.

> For other architectures, e.g., PPC, SPARC, assuming they do offer the ability
> to read counts directly from user space, all that is needed is a couple of new
> arch specific functions:
> 	- hw_perf_event_counter_width(): actual counter width
> 	- hw_perf_event_index(): register index to pass to the user instruction
> 	- hw_perf_update_user_read_perm(): toggle permission to read from userspace

I'm puzzled why powerpc now needs to supply more stuff when we already
have userspace reading of (unscaled) counts working just fine.

We don't have any way to stop userspace reading the counters, so the
sysctl_perf_event_paranoid_user_read is useless on powerpc and quite
possibly confusing to users.

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 2bccb7b..31eeb67 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -250,8 +250,8 @@ struct perf_event_mmap_page {
>  	 *
>  	 *     barrier()
>  	 *     if (pc->index) {
> -	 *       count = pmc_read(pc->index - 1);
> -	 *       count += pc->offset;
> +	 *       count = pmc_read(pc->index - 1)  - pc->delta_base;
> +	 *       count += pc->offset * pc->time_enabled/pc->time_running;
>  	 *     } else
>  	 *       goto regular_read;

This changes what's returned by this code snippet from an unscaled
count to a scaled count, and thus makes it not what read() returns,
which I think is a bad idea.  It would be OK to add another
alternative code snippet in the comment that returns a scaled count,
and make it clear that one returns the unscaled count and the other
the scaled count.

> @@ -2249,8 +2280,11 @@ void perf_event_update_userpage(struct perf_event *event)
>  	barrier();
>  	userpg->index = perf_event_index(event);
>  	userpg->offset = atomic64_read(&event->count);
> -	if (event->state == PERF_EVENT_STATE_ACTIVE)
> -		userpg->offset -= atomic64_read(&event->hw.prev_count);
> +	if (event->state == PERF_EVENT_STATE_ACTIVE
> +	    && !perf_paranoid_user_read()) {
> +                update_event_times(event);
> +                userpg->delta_base = perf_adjust_event_prev_count(event);
> +	}

And this changes the meaning of the offset field and thus breaks the
ABI, and makes existing userspace code on powerpc give the wrong
answer.

I don't mind if you add fields to make it possible to compute a scaled
count more easily, but please don't change the meaning of the existing
fields.

Regards,
Paul.
