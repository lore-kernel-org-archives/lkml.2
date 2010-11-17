Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab0KQSxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:53:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58534 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935069Ab0KQSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:53:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q9fDnw0bnaA5ak3bpGg41J+DFI9DAm4CMmS62KwLmEP4wqZ2+zXxvVjd5eWh9+clNV
         0yJAflL+64kfSJmo3vgOLyy2t59aDqTzAtEA04biJNRWdWpR7yx0B6fdx/sXDZqwYrJn
         fYT1h5y/zJQHSTYPPTXOyEnaKdgOMJNiYfSq0=
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Tom Zanussi <tzanussi@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20101117183642.GE13717@Krystal>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>
	 <1290001128.2109.785.camel@laptop> <20101117140002.GH27063@elte.hu>
	 <1290003110.2109.822.camel@laptop> <1290008001.1921.14.camel@elnicho>
	 <20101117183642.GE13717@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 12:53:24 -0600
Message-ID: <1290020004.1921.25.camel@elnicho>
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

But the idea is to avoid allocating the trace buffer in the first place,
until we've decided we want the event.  So how do you check the result
of __trace_sched_switch_state(prev) with the filter value if you don't
have it temporarily stored somewhere (not in the trace buffer, which
doesn't exist yet as far as this event is concerned)?

Tom

> Also, how many of these "__trace_sched_switch_state(prev)" are static inlines vs
> actual function calls ? If it's mostly static inlines to dereference a few
> pointers, doing it the second time when the filter passed won't hurt much.
> 
> Thanks,
> 
> Mathieu
> 


