Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935186Ab0KQSXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:23:49 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43948 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933148Ab0KQSXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:23:47 -0500
Date: Wed, 17 Nov 2010 13:23:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117182344.GD13717@Krystal>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu> <1290001128.2109.785.camel@laptop> <20101117140002.GH27063@elte.hu> <1290003110.2109.822.camel@laptop> <1290006634.30543.61.camel@gandalf.stny.rr.com> <1290008637.2109.967.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290008637.2109.967.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:17:42 up 55 days, 22:19,  6 users,  load average: 0.34, 0.25,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-11-17 at 10:10 -0500, Steven Rostedt wrote:
> > 
> > Right, the problem with filtering is what do we want to filter, and what
> > about copying?
> > 
> > Currently, we copy the data into the buffer and then filter on that
> > data. We could also easily filter on the parameters of the tracepoint,
> > but sometimes those parameters do not match the final output (as the
> > case with sched_switch). Do we copy the data into a separate "per cpu"
> > temp buffer, and figure out the filter then? And if the filter is fine,
> > then copy into the buffer. This obviously is slow, due to the multiple
> > copies. We could do this only if the filtering is enabled.
> 
> Right, so what is the primary purpose of this filtering stuff? As it
> stands it makes stuff terribly slow, so you add overhead but the win
> (presumably) is less data output, is that a sane trade-off?
> 
> Most people I've heard -- both at LinuxCon.JP and LPC -- are asking for
> lower overhead tracing (while at the same time demanding more features).
> 
> Who are actually using this and can they provide some input on this?

Amongst others, Ericsson rely on this kind of feature. The case where we're
filtering "out" should be really, really fast (even if it makes the recording
slightly slower). If there is a race modifying the data underneath between the
filter execution and the copy to the buffers, I really don't think it matters.
If the tracepoint caller context don't provide data consistency guarantees for
the parameters it passes, we should not expect 100% perfect consistency between
filter and what is actually saved in the trace. The trace analysis tools should
just be able to cope with that, but I really don't think anyone should care.

So I would recommend no copy, filter directly on the source data, stop the
filter chain as soon as a non-match is observed. Copy the data into the buffers
if the filter passes.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
