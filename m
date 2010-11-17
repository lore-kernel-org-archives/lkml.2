Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404Ab0KQTZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:25:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935196Ab0KQTZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:25:09 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=2kSzP4yT2LoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=_AC9WtJ-2uPqb6KMM2EA:9 a=C1zHnN8FNRtc_ItbOvAHQpltMzYA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117183642.GE13717@Krystal>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>
	 <1290001128.2109.785.camel@laptop> <20101117140002.GH27063@elte.hu>
	 <1290003110.2109.822.camel@laptop> <1290008001.1921.14.camel@elnicho>
	 <20101117183642.GE13717@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 14:25:06 -0500
Message-ID: <1290021906.30543.73.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 13:36 -0500, Mathieu Desnoyers wrote:
> * Tom Zanussi (tzanussi@gmail.com) wrote:
> [...]
> > IIRC, I think the conclusion we came to was that it could be done
> > mechanically if for example the right-hand-side of an assignment in
> > TP_fast_assign() only involved a simple variable assignment, but as
> > Steve pointed out, some assignments are more complicated than that.
> 
> Yep, we came up to the same conclusions in UST.
> 
> > For example, in the sched_switch tracepoint assignments:
> > 
> > 	__entry->prev_prio      = prev->prio;
> >         __entry->prev_state     = __trace_sched_switch_state(prev);
> > 
> > so the prev_prio should be able to be tested 'in-line' but the
> > prev_state would require a temporary buffer to write the value into
> > before doing the test as mentioned by Steve.  At which point you're no
> > further ahead (in that case) than the current situation...
> 
> if we change all assignments to, e.g.:
> 
> _tp_assign(__entry->prev_prio, prev->prio)
> _tp_assign(__entry->prev_state, __trace_sched_switch_state(prev))

I would just call it __assign().


> 
> then we can redefine the macros for filtering much more easily than with the
> " = " assignment operator.
> 
> About your comment above, what is the problem with evaluating
> "__trace_sched_switch_state(prev)" twice ? It will typically be cache-hot after
> the first evaluation, so I wonder if, in practice, we really save a significant
> amount of cycles by saving its result between filtering and writing into trace
> buffers. As I pointed out earlier, for my customers, having a very, very fast
> filter "out" case is more important that trying to squeeze a few cycles out of
> the filter passed case.
> 
> Also, how many of these "__trace_sched_switch_state(prev)" are static inlines vs
> actual function calls ? If it's mostly static inlines to dereference a few
> pointers, doing it the second time when the filter passed won't hurt much.

Yes, something like this could work. It would require a bit more CPP
magic to handle it though.

I could write something up to do this. I just have to add it to the 100
other things I'm doing at the same time :-p

-- Steve


