Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935361Ab0KQTC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:02:26 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35053 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935040Ab0KQTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:02:25 -0500
Date: Wed, 17 Nov 2010 14:02:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117190222.GA9361@Krystal>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu> <1290001128.2109.785.camel@laptop> <20101117140002.GH27063@elte.hu> <1290003110.2109.822.camel@laptop> <1290008001.1921.14.camel@elnicho> <20101117183642.GE13717@Krystal> <1290020004.1921.25.camel@elnicho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290020004.1921.25.camel@elnicho>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:00:25 up 55 days, 23:02,  3 users,  load average: 0.04, 0.14,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (tzanussi@gmail.com) wrote:
> On Wed, 2010-11-17 at 13:36 -0500, Mathieu Desnoyers wrote:
> > * Tom Zanussi (tzanussi@gmail.com) wrote:
> > [...]
> > > IIRC, I think the conclusion we came to was that it could be done
> > > mechanically if for example the right-hand-side of an assignment in
> > > TP_fast_assign() only involved a simple variable assignment, but as
> > > Steve pointed out, some assignments are more complicated than that.
> > 
> > Yep, we came up to the same conclusions in UST.
> > 
> > > For example, in the sched_switch tracepoint assignments:
> > > 
> > > 	__entry->prev_prio      = prev->prio;
> > >         __entry->prev_state     = __trace_sched_switch_state(prev);
> > > 
> > > so the prev_prio should be able to be tested 'in-line' but the
> > > prev_state would require a temporary buffer to write the value into
> > > before doing the test as mentioned by Steve.  At which point you're no
> > > further ahead (in that case) than the current situation...
> > 
> > if we change all assignments to, e.g.:
> > 
> > _tp_assign(__entry->prev_prio, prev->prio)
> > _tp_assign(__entry->prev_state, __trace_sched_switch_state(prev))
> > 
> > then we can redefine the macros for filtering much more easily than with the
> > " = " assignment operator.
> > 
> > About your comment above, what is the problem with evaluating
> > "__trace_sched_switch_state(prev)" twice ? It will typically be cache-hot after
> > the first evaluation, so I wonder if, in practice, we really save a significant
> > amount of cycles by saving its result between filtering and writing into trace
> > buffers. As I pointed out earlier, for my customers, having a very, very fast
> > filter "out" case is more important that trying to squeeze a few cycles out of
> > the filter passed case.
> > 
> 
> But the idea is to avoid allocating the trace buffer in the first place,
> until we've decided we want the event.  So how do you check the result
> of __trace_sched_switch_state(prev) with the filter value if you don't
> have it temporarily stored somewhere (not in the trace buffer, which
> doesn't exist yet as far as this event is concerned)?

It seems I might be missing something important, but what's wrong with using
registers or the stack to hold the value for comparison ? In this case, it's a
"long", so a register seems perfectly reasonable. But again, I feel I'm missing
a key point -- what is it ?

Thanks,

Mathieu

> 
> Tom
> 
> > Also, how many of these "__trace_sched_switch_state(prev)" are static inlines vs
> > actual function calls ? If it's mostly static inlines to dereference a few
> > pointers, doing it the second time when the filter passed won't hurt much.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
