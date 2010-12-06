Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab0LFMm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:42:27 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42502 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0LFMm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:42:26 -0500
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6>
Date: Mon, 06 Dec 2010 23:42:16 +1100
Message-Id: <1291637998-sup-4601@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Mon Dec 06 20:20:06 +1100 2010:
> See https://lkml.org/lkml/2010/12/5/45
> 
> Slightly different, but the same idea :)

Yeah I noted that in my cover email. I meant to get my patches out
before the weekend, but hadn't quite finished cleaning them up to ensure
they didn't break perf when running on a kernel without sample_id_all.

> > +    case PERF_RECORD_HEADER_ATTR:
> > +        return ops->attr(event, s);
> > +    case PERF_RECORD_HEADER_EVENT_TYPE:
> > +        return ops->event_type(event, s);
> > +    case PERF_RECORD_HEADER_TRACING_DATA:
> > +        return ops->tracing_data(event, s);
> > +    case PERF_RECORD_HEADER_BUILD_ID:
> > +        return ops->build_id(event, s);
> 
> These can be processed unordered.

I just moved them into this routine to keep all the dispatching in one
place, whether delayed or not. These particular events will still be
processed immediately when encountered in the file. Only >=
PERF_RECORD_MMAP && <= PERF_RECORD_SAMPLE will be delayed via the
perf_session__process_timed function.

> > +    case PERF_RECORD_FINISHED_ROUND:
> > +        return ops->finished_round(event, s, ops);
> 
> You don't want to delay this unless you have unlimited memory. See my
> patch.

As above, this is not delayed.

> >  {
> > +    if (ops->ordered_samples && sample->time == -1ULL) {
> > +        dump_printf("Event missing timestamp, switching to unordered processing\n");
> > +        flush_sample_queue(s, ops);
> > +        ops->ordered_samples = false;
> 
> Why ? The events injected by perf record itself have no timestamps and
> do not need them. So why disabling ordered_samples ?

For instance, suppose we ran this on an old kernel without support for
timestamps on every event (so timestamps are only on sample events):

perf record -T
perf report

If perf report tried to process the events in order, all the events
without timestamps would be processed first -- including the
PERF_RECORD_EXIT event, which would cause every sample not to be
attributed. Falling back means we should get no worse than the old
behaviour, while an upgraded kernel will provide the timestamps and
should not fall back.

Cheers,
-Ian
