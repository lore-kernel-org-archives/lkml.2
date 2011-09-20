Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1ITQAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:00:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1ITQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:00:42 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=6tZ-v_apZIWo3q58ihwA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110920154610.GB28952@Krystal>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <20110920154610.GB28952@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 12:00:41 -0400
Message-ID: <1316534441.29966.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 11:46 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > [ Added Mathieu as I've been discussing this with him on IRC ]
> [...]
> > My suggestion is to nuke the __this_cpu*() functions and have them
> > called this_cpu*(). And change the locations that allow for preemption
> > enabled to be called preemptsafe_cpu_*() just like the irqsafe_cpu*()
> > are used.
> > 
> > Thoughts?
> 
> I fully agreed with this proposal.
> 
> this_cpu_*() should be a sane default, which is cases that require
> preemption to be disabled. Warning about use without preemption disabled
> is important, because most users will _assume_ that they stay on the
> same CPU across multiple calls.
> 
> preemptsafe_cpu_*() is an optimisation made for those who know that
> they don't care about having consistent view of the variables across
> multiple operations, e.g. statistics, or deal with this explicitly, like
> SLUB. Typical use require either add_return or cmpxchg for validation.

The funny thing is, the few uses where preemption is enabled in slub,
happens to use the __this_cpu_() version. Which shows me that this whole
concept is completely flawed.

> 
> In the past, we used to have something like raw_smp_processor_id()
> though, for sites where racy use does not matter. So probably having a
> raw_this_cpu_*() that behaves like "this_cpu_*()" proposed here, but
> does not check for preemption disabled would also be useful.

I'm going with all users of this_cpu_*() must be used in a preempt
disabled section. Byte the bullet. I doubt any sane benchmark shows any
improvement by removing preempt_disable() from small code paths. If a
longer code path is needed, then the code was probably buggy to begin
with.

For those cases that really do not care about preemption enabled, maybe
we could add a single this_cpu() function that allows that.


this_cpu_snapshot();

This would be the only function that can be used with preemption
enabled. It is read only (no modification of the variable). It is used
in cases that you really don't care what CPU you are on. For instance
the const_udelay() could use this.

The term "snapshot" should document very nicely that you do not care
that you migrated in the next moment. As a snapshot is just a quick
instance of time.

I really mean all other users of this_cpu_*(), including the cmpxchg and
friends, still need to have preemption disabled.

-- Steve


