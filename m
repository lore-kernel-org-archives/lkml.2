Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab0KQPd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:33:27 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37377 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab0KQPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DfoUvNbMtWGsIp+Z2kmsESsTHJT5IyaHFZXemXXrYvci7sH/wqF+FTXH+srj1m9Cjb
         zcdgEA3DClpL7MLjbvHaHpZ03Ezj+2NIE7OJTjodUBYjSYncfgIS2tB/WvkuNHadoRIn
         9mjh0YdbUdddj9Vvzoq9487UutbgwgxHzJ47U=
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Tom Zanussi <tzanussi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1290003110.2109.822.camel@laptop>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>
	 <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>
	 <1290003110.2109.822.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:33:21 -0600
Message-ID: <1290008001.1921.14.camel@elnicho>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:11 +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 15:00 +0100, Ingo Molnar wrote:
> > > But yes, it is functional.
> > 
> > I suspect that is what matters mostly - unless you think that it's impossible to 
> > have a sane implementation of it, if the users come. 
> 
> I'm not sure, I raised the point several times, and I think Steve and
> Tom though it was possible to implement sanely, but I'm not sure if it
> was expression invariant (the fix that is).
> 
> It would be very good to have a definite answer on that.
> 
> The idea was to not let the filter engine work on the trace data (once
> its gathered) but on the trace argument right at the beginning of the
> tracepoint callchain, since some of the trace data is an expression of
> the trace argument (say next->prio instead of next), the trace
> expression wouldn't stay invariant, you'd have to write a different
> filter for the same effect.
> 

IIRC, I think the conclusion we came to was that it could be done
mechanically if for example the right-hand-side of an assignment in
TP_fast_assign() only involved a simple variable assignment, but as
Steve pointed out, some assignments are more complicated than that.

For example, in the sched_switch tracepoint assignments:

	__entry->prev_prio      = prev->prio;
        __entry->prev_state     = __trace_sched_switch_state(prev);

so the prev_prio should be able to be tested 'in-line' but the
prev_state would require a temporary buffer to write the value into
before doing the test as mentioned by Steve.  At which point you're no
further ahead (in that case) than the current situation...

Tom

> So I think it would be wise to make this change sooner rather than
> later.


