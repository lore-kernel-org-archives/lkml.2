Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1ITDND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:13:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1ITDNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:13:01 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=dqh-4gNtgei17wFymfcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <m2ehzcdkf2.fsf@firstfloor.org>
References: <20110919212040.745370781@goodmis.org>
	 <m2ehzcdkf2.fsf@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Sep 2011 23:12:58 -0400
Message-ID: <1316488378.29966.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 19:20 -0700, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > I just found out that the this_cpu_*() functions do not perform the
> > test to see if the usage is in atomic or not. Thus, the blind
> > conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
> > code to this_cpu_*() introduce the regression to detect the hard
> > to find case where a per cpu variable is used in preempt code that
> > migrates and causes bugs.
> 
> 
> Didn't preempt-rt recently get changed to not migrate in kernel-preempt
> regions. How about just fixing the normal preemption to not do this
> either.

Actually, that's part of the issue. RT has made spin_locks not migrate.
But this has also increased the overhead of those same spinlocks. I'm
hoping to do away with the big hammer approach (although Thomas is less
interested in this). I would like to have areas that require per-cpu
variables to be annotated, and not have every spinlock disable
preemption.

> 
> Then all these complications wouldn't be necessary and a whole lot 
> of code related to this could be removed too, and you would still
> have less bugs.

Note, that normal preemption doesn't migrate either. If you disable
preemption, you don't migrate.

-- Steve


