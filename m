Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1ALPVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:21:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:38968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1ALPVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:21:30 -0500
Date: Wed, 12 Jan 2011 13:21:12 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Q: perf log mode?
Message-ID: <20110112152112.GE11968@ghostprotocols.net>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 12, 2011 at 05:06:13PM +0300, Kirill Smelkov escreveu:
> I'm trying to use perf together with e.g. kprobes as a tool to show what
> is happening with my system in "live-log" mode. The problem is, for
> seldom events, actual info output is largely delayed because perf reads
> sample data in whole pages. Could something be done with it or am I'm
> missing something? Here is detailed description:

<SNIP>
> 
> Judging from timestamps, the events were coming with 1-2 seconds period
> (ping <host> running) and for e.g. first event we got 96-43=53 seconds
> delay (which is happening already at `perf record` stage -- I've
> monitored it's raw output).
> 
> Is it somehow possible to display events instantly as they are coming?

Look at how perf top works:

        while (1) {
                int hits = samples;

                perf_session__mmap_read(session);

                if (hits == samples)
                        ret = poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
        }

It will only call poll if no events were found so there should be no
delays.

perf script instead uses perf_session__process_events() and that, as
requested by 'perf script' queues events to make sure they are ordered,
so probably the problem is related to this latency, probably we'll need
to use some timer to flush this queue more often.

Try tweaking:

        .ordering_requires_timestamps = true,
        .ordered_samples = true,

in builtin-script.c, if you disable those there should be no queueing
and we'll test this theory.

Also try checking if there isn't any buffering in action because it uses
pipes to connect the record with the python script by printing the event
as it comes in the record part.

- Arnaldo
