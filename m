Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924Ab1ITPQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:16:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42095 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1ITPQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:16:11 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=6qbAnu_Q0HoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=KRJPN9EQwMRj6goULc0A:9 a=cJRSa4pm1uBFkfS6-4cA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <alpine.DEB.2.00.1109200940240.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.688732950@goodmis.org>
	 <alpine.DEB.2.00.1109191657150.19059@router.home>
	 <1316476089.29966.9.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109200940240.8056@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 11:16:09 -0400
Message-ID: <1316531769.29966.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 09:46 -0500, Christoph Lameter wrote:

> The effects on just reading are not that severe. We may calculate the
> address of the per cpu variable on one cpu and then be migrated to another
> processor. Then there is an access to the per cpu area of another
> processor which in many cases is harmless and will just cause the
> cacheline to go from exclusive mode into shared mode on the other cpu. The
> next write by the other cpu then brings it back to exclusive mode evicting
> the cacheline from the cpu we migrated to.

Then what protects another process from touching that same CPU variable?
Looks very error prone to me.

> 
> The same conventions are also used for RMV instructions like this_cpu_inc.
> In that case the situation is much more sever. Now we are locklessly
> incrementing a counter in the per cpu area of another cpu. That is a race
> condition that can corrupt the counter data.

If you read a per cpu variable with simple this_cpu_read() and then make
a decision based on that variable, it may be useless in the process if
you migrate.

> 
> > The point is, most places use this_cpu_read(). Adding a "__" or "raw_"
> > prefix usually means that less checks are done. Think of the
> > copy_from_user(). You have __copy_from_user() that does less checks.
> 
> Why do you need any checks there? this_cpu_xxx operations should take care
> of preemption.

NO IT DOES NOT!!!! Look at the damn memcg bug and figure it out!

> 
> > Most of the per_cpu() and get_cpu_var() code was blindly replaced with
> > the this_cpu_*() variants. The original code had preemption disabled
> > checks. Now they don't. Which means if you use the this_cpu_read() and
> > then make some decision on it, that read may be useless and buggy.
> >
> > We have smp_processor_id() that does the check (and the old per_cpu()
> > and get_cpu_var()). Now we have this_cpu_read() which replaced most of
> > the per_cpu() code in the kernel, making them vulnerable to bugs when
> > preemption is enabled.
> 
> this_cpu_xx can only replace a get_cpu_var/per_cpu section where a single
> word is read or updated. If multiple per cpu variables are accessed and
> modified in one go then it is better to keep disabling preemption for
> the whole section and use the __this_cpu_xx operations.

And that is what __get_cpu_var() is for.

> 
> If there are cases where this was not done correctly then lets fix those.

Lets not let this happen in the first place! There's absolutely no
advantage of not disabling preemption for a period of time while per cpu
variables are being used. If we annotate this properly, then the -rt
kernel could handle this in other ways too, to not keep the latency of
preemption off too long.

-- Steve


