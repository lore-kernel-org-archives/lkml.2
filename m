Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713Ab0KQPKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:10:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61159 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab0KQPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:10:37 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2kSzP4yT2LoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9YFv4M9CJv9Quf_-15wA:9 a=OQ2rEvxo_NaAW4ypFQY8d_qBfbcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
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
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 10:10:34 -0500
Message-ID: <1290006634.30543.61.camel@gandalf.stny.rr.com>
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
> So I think it would be wise to make this change sooner rather than
> later.

Right, the problem with filtering is what do we want to filter, and what
about copying?

Currently, we copy the data into the buffer and then filter on that
data. We could also easily filter on the parameters of the tracepoint,
but sometimes those parameters do not match the final output (as the
case with sched_switch). Do we copy the data into a separate "per cpu"
temp buffer, and figure out the filter then? And if the filter is fine,
then copy into the buffer. This obviously is slow, due to the multiple
copies. We could do this only if the filtering is enabled.

Note, the stable event proposal I suggested passes the same info via the
trace callback parameters that is expected to go into the buffer. Arrays
are passed as pointers so the copying is of the minimum. This would give
us the ability to filter _before_ writing into the buffer, and no
unnecessary copying.

-- Steve


