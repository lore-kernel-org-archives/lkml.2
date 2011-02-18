Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1BRO5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:57:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1BRO5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:57:11 -0500
Subject: Re: [PATCH 2/3] perf events: Introduce realtime clock event
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
In-Reply-To: <4D5E84AC.4040104@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-3-git-send-email-daahern@cisco.com>
	 <1298027641.5226.666.camel@laptop>  <4D5E84AC.4040104@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 15:58:26 +0100
Message-ID: <1298041106.5226.775.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 07:39 -0700, David Ahern wrote:
> 
> On 02/18/11 04:14, Peter Zijlstra wrote:
> > On Thu, 2011-02-17 at 22:53 -0700, David Ahern wrote:
> >> The motivation for this event is to convert perf_clock() time stamps
> >> to wall-clock (gettimeofday()) equivalents, including adjustments made
> >> by NTP (e.g., for comparing perf events to other log files).
> > 
> >> This patch is based on the monotonic patch by Arnaldo Carvalho de Melo
> >> <acme@redhat.com>.
> >>
> >> (NOTE: Comments from the last review of the timehist patch series
> >> suggested calling this a monotonic clock. I am not trying to be
> >> dense here; since gettimeofday maps to realtime clock I think that
> >> is the better name for it.)
> > 
> > Well, the idea was to use CLOCK_MONOTONIC, not to call CLOCK_REALTIME
> > monotonic.
> > 
> > I'm really not sure why you want CLOCK_REALTIME and I think
> > CLOCK_MONOTONIC is more useful (I'd argue you want your system logs to
> > contain both, every admin who's ever had to untangle what happened
> > during DST switches will agree)
> 
> I believe CLOCK_MONOTONIC is what perf_clock is tied to -- the
> timestamps for PERF_SAMPLE_TIME -- so we already have that.

Its not (it mere _can_ be), it could be tied to the TSC which can
significantly drift wrt CLOCK_MONOTONIC.

> Programs that generate time-of-day output are using gettimeofday which
> is tied to CLOCK_REALTIME. We want to be able to correlate a perf sample
> to an entry in an applications log file.

Well, you can argue those programs are broken :-), Imagine the joys of
trying to figure out wth happens when DST jumps the clock back an hour
and you have an hour of duplicate data.

> >> @@ -5610,6 +5612,13 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
> >>  
> >>  	perf_sample_data_init(&data, 0);
> >>  	data.period = event->hw.last_period;
> >> +	if (event->attr.sample_type & PERF_SAMPLE_RAW) 
> >> +	{
> >> +		raw.size = sizeof(u64);
> >> +		raw.data = &event->count;
> >> +		data.raw = &raw;
> >> +	}
> >> +
> >>  	regs = get_irq_regs();
> >>  
> >>  	if (regs && !perf_exclude_event(event, regs)) {
> > 
> > 
> > Why!? you already keep ->count = ktime_get_real(), so simply reading the
> > count value will get you the timestamp.. this is superfluous at best.
> 
> And that is a conundrum I was stuck on for a while. perf record does not
> sample counters; it only creates sample events. I looked at having perf
> record sample the clock event, but then I would have to synthesize an
> event for the output file. Similarly perf record for hardware counters
> does not show the value of the counter.

Well, but you can fix that, simply add PERF_SAMPLE_READ, no need to
abuse the raw crap.



