Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0LFNEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:04:48 -0500
Received: from www.tglx.de ([62.245.132.106]:46595 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0LFNEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:04:46 -0500
Date: Mon, 6 Dec 2010 14:04:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Munsie <imunsie@au1.ibm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
In-Reply-To: <1291637998-sup-4601@au1.ibm.com>
Message-ID: <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6> <1291637998-sup-4601@au1.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Ian Munsie wrote:

> Excerpts from Thomas Gleixner's message of Mon Dec 06 20:20:06 +1100 2010:
> > See https://lkml.org/lkml/2010/12/5/45
> > 
> > Slightly different, but the same idea :)
> 
> Yeah I noted that in my cover email. I meant to get my patches out
> before the weekend, but hadn't quite finished cleaning them up to ensure
> they didn't break perf when running on a kernel without sample_id_all.
> 
> > > +    case PERF_RECORD_HEADER_ATTR:
> > > +        return ops->attr(event, s);
> > > +    case PERF_RECORD_HEADER_EVENT_TYPE:
> > > +        return ops->event_type(event, s);
> > > +    case PERF_RECORD_HEADER_TRACING_DATA:
> > > +        return ops->tracing_data(event, s);
> > > +    case PERF_RECORD_HEADER_BUILD_ID:
> > > +        return ops->build_id(event, s);
> > 
> > These can be processed unordered.
> 
> I just moved them into this routine to keep all the dispatching in one
> place, whether delayed or not. These particular events will still be
> processed immediately when encountered in the file. Only >=
> PERF_RECORD_MMAP && <= PERF_RECORD_SAMPLE will be delayed via the
> perf_session__process_timed function.

Gah. This is nasty. I really prefer the explicit split of instant
processed and possibly delayed events. That makes the code clear and
easy to extend. I just want to add a new event type at the right place
and not worry about magic comparisions in some other place.

> > >  {
> > > +    if (ops->ordered_samples && sample->time == -1ULL) {
> > > +        dump_printf("Event missing timestamp, switching to unordered processing\n");
> > > +        flush_sample_queue(s, ops);
> > > +        ops->ordered_samples = false;
> > 
> > Why ? The events injected by perf record itself have no timestamps and
> > do not need them. So why disabling ordered_samples ?
> 
> For instance, suppose we ran this on an old kernel without support for
> timestamps on every event (so timestamps are only on sample events):
> 
> perf record -T
> perf report
> 
> If perf report tried to process the events in order, all the events
> without timestamps would be processed first -- including the
> PERF_RECORD_EXIT event, which would cause every sample not to be
> attributed. Falling back means we should get no worse than the old
> behaviour, while an upgraded kernel will provide the timestamps and
> should not fall back.

Ok, but you'll break existing code which does only care about sample
ordering if you do that at the session level unconditionally.

Thanks,

	tglx
