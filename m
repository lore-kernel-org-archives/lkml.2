Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0LGKsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:48:08 -0500
Received: from www.tglx.de ([62.245.132.106]:37469 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab0LGKsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:48:06 -0500
Date: Tue, 7 Dec 2010 11:47:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Munsie <imunsie@au1.ibm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
In-Reply-To: <1291679635-sup-9860@au1.ibm.com>
Message-ID: <alpine.LFD.2.00.1012070942070.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6> <1291637998-sup-4601@au1.ibm.com> <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
 <1291640985-sup-4443@au1.ibm.com> <alpine.LFD.2.00.1012061447080.2653@localhost6.localdomain6> <1291679635-sup-9860@au1.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian,

On Tue, 7 Dec 2010, Ian Munsie wrote:
> >      case PERF_RECORD_HEADER_ATTR:
> > -        return ops->attr(event, session);
> > +        /* This updates session->sample_id_all */
> > +        ret = ops->attr(event, session);
> > +        if (ops->ordering_requires_timestamps &&
> > +            ops->ordered_samples && !session->sample_id_all) {
> > +            session->ordered_samples.next_flush = ULLONG_MAX;
> > +            flush_sample_queue(session, ops);
> > +            ops->ordered_samples = false;
> > +        }
> 
> Makes sense. I did something similar in the report layer that I was
> about to send when I saw this email, but this way we have a generic
> solution for other parts of perf that might want this.
> The problem here is that we only get the PERF_RECORD_HEADER_ATTR if perf
> record has been piped somewhere, so running perf record <load>; perf
> report on an unpatched kernel results in the COMM, MMAP, etc events
> being processed last (timestamp -1ULL) and no userspace samples are
> attributed at all:

Ok. We need to treat timestamp ~0ULL the same as timestamp 0ULL then.
 
> > +    event__parse_sample(event, session, &sample);
> > +    if (dump_trace)
> > +        perf_session__print_tstamp(session, event, &sample);
> 
> Moving this here after the dump_printf("%#Lx [%#x]: PERF_RECORD_%s"...
> changes the output of perf report -D in a bad way. Changing the spacing
> in dump_printf can make up for it, or juggle the code around some more.

Crap. I wanted to restrict the sample parsing to the real events w/o
having this magic comparison in place as we filter out the synth stuff
in the switch case already. 

> How do you want to proceed? At this point either version of the patches
> are pretty functionally equivelant. Mine does the perf report -D

Hmm. Arnaldo merged my version already.

> reordering as well, but that isn't really necessary to solve the bug.
> Either way we only have a few minor fixups left.

Having time ordered output of -D needs more than fixing the time stamp
issue. The dump_printf/dump_trace stuff is scattered all over the
place. So that needs more code churn, as you want to output the non
synth events when the ordered queue is drained.

Will send an update with that solved soon.

Thanks,

	tglx

