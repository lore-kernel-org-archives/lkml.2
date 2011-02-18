Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1BRLMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 06:12:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1BRLMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 06:12:47 -0500
Subject: Re: [PATCH 2/3] perf events: Introduce realtime clock event
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
In-Reply-To: <1298008433-22911-3-git-send-email-daahern@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-3-git-send-email-daahern@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:14:01 +0100
Message-ID: <1298027641.5226.666.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 22:53 -0700, David Ahern wrote:
> The motivation for this event is to convert perf_clock() time stamps
> to wall-clock (gettimeofday()) equivalents, including adjustments made
> by NTP (e.g., for comparing perf events to other log files).

> This patch is based on the monotonic patch by Arnaldo Carvalho de Melo
> <acme@redhat.com>.
> 
> (NOTE: Comments from the last review of the timehist patch series
> suggested calling this a monotonic clock. I am not trying to be
> dense here; since gettimeofday maps to realtime clock I think that
> is the better name for it.)

Well, the idea was to use CLOCK_MONOTONIC, not to call CLOCK_REALTIME
monotonic.

I'm really not sure why you want CLOCK_REALTIME and I think
CLOCK_MONOTONIC is more useful (I'd argue you want your system logs to
contain both, every admin who's ever had to untangle what happened
during DST switches will agree)

> @@ -5610,6 +5612,13 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
>  
>  	perf_sample_data_init(&data, 0);
>  	data.period = event->hw.last_period;
> +	if (event->attr.sample_type & PERF_SAMPLE_RAW) 
> +	{
> +		raw.size = sizeof(u64);
> +		raw.data = &event->count;
> +		data.raw = &raw;
> +	}
> +
>  	regs = get_irq_regs();
>  
>  	if (regs && !perf_exclude_event(event, regs)) {


Why!? you already keep ->count = ktime_get_real(), so simply reading the
count value will get you the timestamp.. this is superfluous at best.


