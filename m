Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1CBORB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:17:01 -0500
Received: from www.tglx.de ([62.245.132.106]:36911 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1CBORA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:17:00 -0500
Date: Wed, 2 Mar 2011 15:16:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Ahern <daahern@cisco.com>
cc: linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        acme@ghostprotocols.net, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
In-Reply-To: <1298865151-23656-4-git-send-email-daahern@cisco.com>
Message-ID: <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com> <1298865151-23656-4-git-send-email-daahern@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Feb 2011, David Ahern wrote:

> Enable data collection for generating time-of-day strings when
> printing individual perf samples. This is done by sampling the
> realtime clock event with the perf_clock time stamps.
> 
> If the realtime-clock event is not available (e.g, older kernels)
> fallback to a synthesized event. (I realize there is resistance
> to new synthesized events, but it is a simple way to gain this
> feature on older kernels without the need to modify the kernel
> code).

...
  
> +/* add a sample to the event stream based on user request */
> +static int perf_event_generate_sample(struct perf_event *event)
> +{
> +	struct perf_sample_data data;
> +	struct pt_regs regs;
> +
> +	perf_fetch_caller_regs(&regs);
> +	event->pmu->read(event);
> +	perf_sample_data_init(&data, 0);
> +	data.period = event->hw.last_period;
> +	perf_event_output(event, 0, &data, &regs);
> +
> +	return 0;
> +}

Errm. This is a generic ioctl to inject random events from user space.

First of all this wants to be a separate patch and not burried into
some 100 lines of changes to tools/perf.

Secondly adding such an ioctl needs a pretty good reason, and the use
case at hand is not really one.

Reading through the other patches, your goal is to correlate
CLOCK_REALTIME based logs to CLOCK_PERF based events.

To achieve that you inject cyclic clock_realtime samples into the
event stream and want to have this initial event inserted via the
ioctl.

How does all that deal with CLOCK_REALTIME being affected by NTP and
settimeofday? Not really, as far as I can tell. It somehow works, but
that depends on the frequency of your event injection.

To be honest, that's just too much churn for a feature which is single
purpose and questionable functionality.

It would be far more interesting to have trace points in the
timekeeping code, which are useful for other things as well
(e.g. precise monitoring of NTP) and provide always a correct
association with the trace clock. That would cover everything from
frequency adjustments, clock setting including the information about
the relation to clock monotonic.

Thanks,

	tglx
