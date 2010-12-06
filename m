Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0LFJUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:20:34 -0500
Received: from www.tglx.de ([62.245.132.106]:41797 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0LFJUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:20:32 -0500
Date: Mon, 6 Dec 2010 10:20:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Munsie <imunsie@au1.ibm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
In-Reply-To: <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com>
Message-ID: <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Ian Munsie wrote:

> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This patch changes perf report to ask for the ID info on all events be
> default if recording from multiple CPUs.
>
> Perf report will now process the events in order if the kernel is able
> to provide timestamps on all events. This ensures that events such as
> COMM and MMAP which are necessary to correctly interpret samples are
> processed prior to those samples so that they are attributed correctly.

See https://lkml.org/lkml/2010/12/5/45

Slightly different, but the same idea :)
 
>  
> +static int perf_session__dispatch_event(event_t *event,
> +					struct sample_data *sample,
> +					struct perf_session *s,
> +					struct perf_event_ops *ops)
> +{
> +	switch (event->header.type) {
> +	case PERF_RECORD_SAMPLE:
> +		return ops->sample(event, sample, s);
> +	case PERF_RECORD_MMAP:
> +		return ops->mmap(event, sample, s);
> +	case PERF_RECORD_COMM:
> +		return ops->comm(event, sample, s);
> +	case PERF_RECORD_FORK:
> +		return ops->fork(event, sample, s);
> +	case PERF_RECORD_EXIT:
> +		return ops->exit(event, sample, s);
> +	case PERF_RECORD_LOST:
> +		return ops->lost(event, sample, s);
> +	case PERF_RECORD_READ:
> +		return ops->read(event, sample, s);
> +	case PERF_RECORD_THROTTLE:
> +		return ops->throttle(event, sample, s);
> +	case PERF_RECORD_UNTHROTTLE:
> +		return ops->unthrottle(event, sample, s);


> +	case PERF_RECORD_HEADER_ATTR:
> +		return ops->attr(event, s);
> +	case PERF_RECORD_HEADER_EVENT_TYPE:
> +		return ops->event_type(event, s);
> +	case PERF_RECORD_HEADER_TRACING_DATA:
> +		return ops->tracing_data(event, s);
> +	case PERF_RECORD_HEADER_BUILD_ID:
> +		return ops->build_id(event, s);

These can be processed unordered.

> +	case PERF_RECORD_FINISHED_ROUND:
> +		return ops->finished_round(event, s, ops);

You don't want to delay this unless you have unlimited memory. See my
patch.

>  {
> +	if (ops->ordered_samples && sample->time == -1ULL) {
> +		dump_printf("Event missing timestamp, switching to unordered processing\n");
> +		flush_sample_queue(s, ops);
> +		ops->ordered_samples = false;

Why ? The events injected by perf record itself have no timestamps and
do not need them. So why disabling ordered_samples ?

Thanks,

	tglx
