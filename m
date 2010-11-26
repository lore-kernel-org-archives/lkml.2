Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0KZX4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 18:56:22 -0500
Received: from www.tglx.de ([62.245.132.106]:43663 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0KZX4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 18:56:21 -0500
Date: Sat, 27 Nov 2010 00:55:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 2/5] perf events: Default to using event__process_lost
In-Reply-To: <1290808041-16535-3-git-send-email-acme@infradead.org>
Message-ID: <alpine.LFD.2.00.1011270042520.2900@localhost6.localdomain6>
References: <1290808041-16535-1-git-send-email-acme@infradead.org> <1290808041-16535-3-git-send-email-acme@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Arnaldo Carvalho de Melo wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Tool developers have to fill in a 'perf_event_ops' method table to
> specify how to handle each event, so far the ones that were not
> explicitely especified would get a stub that would just discard the
> event.
> 
> Change that so that tool developers can get the lost event details and
> the total number of such events at the end of 'perf report -D' output.

That should be always displayed if the subcommand does not have it's
own lost event handling. I stared long enough into the wrong place,
just because the stupid thing just was silent about it. And with this
patch it's still silent for the normal use case.

We really want to tell the user when something went wrong. Users do
not run perf report -D when the tool shows fancy events, why should
they? Just because they know that the tool is hiding problems? If
that's the case then the trust into perf tools is about 0.

Darn, being silent about a known problem is the most stupid error
handling ever.

That's what I added at the end of perf_session__process_events()

+	if (self->hists.stats.total_lost)
+		fprintf(stderr, "Lost events. Check IO/CPU overload!\n");

It's hacky, but it does the job and tells me clearly that the trace is
only halfways useful.

There are only two files, which implement their own lost handling:
builtin-inject.c and builtin-script.c

So everything else looks at incomplete data and let's the user wonder
about the resulting crap in the output.

Thanks,

	tglx
