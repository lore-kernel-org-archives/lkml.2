Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1IUPbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:31:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1IUPbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:31:45 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=fBl8dBbB_sJAygz42ykA:9 a=ElVYSODfqjMQMkeZ5-cA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.DEB.2.00.1109211007450.12914@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <20110920154610.GB28952@Krystal>
	 <1316534441.29966.79.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201109470.8056@router.home>
	 <1316544841.29966.121.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109211007450.12914@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Sep 2011 11:31:43 -0400
Message-ID: <1316619103.29966.139.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 10:16 -0500, Christoph Lameter wrote:

> > My argument is that this_cpu_* is just confusing. Rename your use case
> > and keep this_cpu_*() as what you want __this_cpu_*() to be.
> 
> Thought about this a bit last night. I think the main issue are these
> this_cpu_read() and this_cpu_write() operations since people use those
> irresponsibly. It usually does not make sense to read a value from a
> random cpu nor does writing make sense. The situation is different for
> per cpu counter increments where it does not matter which cpus counter is
> incremented since we sum them up later anyways.
> 
> How about getting rid of this_cpu_read() and this_cpu_write() entirely?
> 
> Only allow __this_cpu_read and __this_cpu_write. There we check that the
> caller has disabled preemption.

The problem I have with this, is that this does not help at all. We are
back to the word "this_cpu" when you really do mean "any_cpu". We
optimize the implementation to only write to the current cpu we are on,
but that is an optimization not the design, as the process could migrate
before and after the call to your this_cpu_*() operation, which makes it
no longer "this cpu". The bigger view of this design is that
incrementing a cpu variable and then summing it up, means that you do
not care which CPU variable you updated. Do not call it "this_cpu"!
Yes, for optimization sake, we happen to use the current CPU, but if we
read/wrote to any CPU variable, the algorithm still works. Hence, it is
not "this_cpu" but "any_cpu".


> 
> For the rare special cases (are there any?) that are legitimate use cases
> for this_cpu_read/write we can use manual determination of per cpu
> pointers and then just do a load via the pointer?
> 
> Or alternatively give this_cpu_read and write special names that make
> their dangerousness clear.

Right, we need to change all "this_cpu_*()" operations that are made to
be safe under preempt enabled areas to "any_cpu_*()". And use
this_cpu_*() for the current __this_cpu_*().

This would clear up the confusion about using "this_cpu" vs "__this_cpu"
because "__" is truly meaningless.

> 
> In the case of slub there are only some this_cpu_write() things that can
> be __this_cpu_write without a problem.
> 
> The __this_cpu_ptr() can become this_cpu_ptr as far as I can tell. This
> should make it consistent so that we can check for disabled preemption for
> all __this_cpu thingies.


Again, lets just bite the bullet and rename them to something that is
understandable for everyone. This would make all of us happy.

I'm not against your code, I'm against the naming convention you decided
to use. It makes it confusing to something that is complex and complex
code needs to try to be a simple as possible.

-- Steve


