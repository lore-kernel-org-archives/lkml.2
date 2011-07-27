Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1G0Q3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:29:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40295 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1G0Q3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:29:32 -0400
Subject: Re: per-cpu operation madness vs validation
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1311783617.5890.179.camel@twins>
References: <1311714410.24752.404.camel@twins>
	 <alpine.DEB.2.00.1107261624210.10273@router.home>
	 <1311768693.24752.488.camel@twins> <1311771677.24752.495.camel@twins>
	 <alpine.DEB.2.00.1107270916240.9418@router.home>
	 <1311783617.5890.179.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 18:29:09 +0200
Message-ID: <1311784149.5890.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 18:20 +0200, Peter Zijlstra wrote:
> > > get_cpu_var()/put_cpu_var() were supposed to provide such delineation as
> > > well, but you've been actively destroying things like that with the
> > > recent per-cpu work.
> > 
> > The per cpu work is *not* focused on sections that access per cpu data, so
> > how could it destroy that? Nothing is changed there so far. The this_cpu
> > ops are introducing per cpu atomic operations that are safe and cheap
> > regardless of the execution context. The primary initial motivation was
> > incrementing per cpu counters without having to disabling interrupts
> > and/or preemption and it grew from there.
> 
> I think you need to look at 20b876918c065818b3574a426d418f68b4f8ad19 and
> try again. You removed get_cpu_var()/put_cpu_var() and replaced it with
> naked preempt_disable()/preempt_enable(). That's loosing information
> right there. 

Also things like the below hunk are just plain ugly and obfuscate the
code to safe one load at best. I'm sorely tempted to revert such crap.

@@ -1468,14 +1465,12 @@ static void x86_pmu_start_txn(struct pmu *pmu)
  */
 static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
-       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
-       cpuc->group_flag &= ~PERF_EVENT_TXN;
+       __this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
        /*
         * Truncate the collected events.
         */
-       cpuc->n_added -= cpuc->n_txn;
-       cpuc->n_events -= cpuc->n_txn;
+       __this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
+       __this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
        perf_pmu_enable(pmu);
 }

