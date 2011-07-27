Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1G0OQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:16:22 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:33599 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753351Ab1G0OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:16:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9NqGd5wVM1ka.AHJZeIOkMDrT43dUhmKTqaIpgStrw2aPuT
 2E6gZqjRI1sTmZuKSjgT58YKbt5QQPP1sRzmhFOoWTenOJqrPY1OG6TXoPtp
 NqIQTglSxySn37fv5BLUsp_njYKQyDsySRcPkYUsT3HCZnFYI9oUO7QlaBfT
 gxADwW052Dy.FtuEze9rxsRd7Em6a84Utb6MIt6XKQG8T4eguHXPimXnsJIW
 kmR1qXfOivxIyy8P_M03pO56Fjuvn5kILaDKGeKwE_3_Ea.uosCT8BzWO8if
 qllbwDCqQjyoev3kZe6x_WxcljMBPDt1YIC.OEUGbdFh1zj.IDGeYNqX2s4Q
 8wAEbI3LfWUpD8Hc8AV3g3tNM
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 27 Jul 2011 09:16:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <1311768693.24752.488.camel@twins>
Message-ID: <alpine.DEB.2.00.1107270904290.9418@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home> <1311768693.24752.488.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Peter Zijlstra wrote:

> > On x86 these operations are rt safe by the pure fact that all these
> > operations are the same interrupt safe instruction.
>
> The number of instructions has nothing what so ever to do with things.

Of course it has. If its one instruction then that instruction is by
design atomic vs interrupts and preemption. No interrupt disable or
preemption disabling is necessary to ensure that that the RMV operation is
safe from interrupts or preemption.

> And while the individual ops might be preempt/irq/nmi safe, that doesn't
> say anything at all about the piece of code they're used in.

Sure only the individual RMV operation is safe. If there are multiple
operations then there are the usual issues.

> And doesn't solve the larger issue of multiple per-cpu variables forming
> a consistent piece of data.

That is a different issue from single atomic operations and AFAICT that
whas what we discussed here.

> Suppose there's two per-cpu variables, a and b, and we have an invariant
> that says that a-b := 5. Then the following code:
>
> preempt_disable();
> __this_cpu_inc(a);
> __this_cpu_inc(b);
> preempt_enable();
>
> is only correct when used from task context, an IRQ user can easily
> observe our invariant failing and none of your above validations will
> catch this.

Well yes these are multiple operations that have a sort of atomicity
requirement together. You want both variables to be updated together and
therefore the individual RMV operations wont do the trick. The algorithm
would have to be changed to take advantage of the this_cpu ops or you will
have to take the penalty of higher synchronization costs.

> Now move to -rt where the above will likely end up looking something
> like:
>
> migrate_disable();
> __this_cpu_inc(a);
> __this_cpu_inc(b);
> migrate_enable();
>
> and everybody can see the invariant failing.

Obviously. The this_cpu ops etc are not inteded to address large sections
that access per cpu data and want to make sure that others see the changes
in an atomic fashion.

> Now clearly my example is very artificial but not far fetched at all,

Sure but these issues require a different way of structuring the
algorithm. That is why I have introduced longer cmpxchg operations.

What you can do is what the slub fastpath does in order to allow updates
without caring about preemption or interrupts.

1. You get a reference to the current per cpu data.
2. You obtain a transaction id that is cpu specific and operation specifc.
3. Speculatively access an object and work with the information of that
object. Do not change anything.
4. Calculate the next transaction id
4. Replace pointer and transaction id with a new object pointer and new
tranaction id. If there is no match restart at 1.

Otherwise you are done. Any interrupt or preemption section that also does
operation on the critical data also would increment the transaction id and
cause a retry of the section.

So now you have a per cpu access that is fully immunte from interrupt and
preemption issues.

> Hence my suggestion to do something like:
>
> struct foo {
> 	percpu_lock_t lock;
> 	int a;
> 	int b;
> }
>
> DEFINE_PER_CPU(struct foo, foo);
>
> percpu_lock(&foo.lock);
> __this_cpu_inc(foo.a);
> __this_cpu_inc(foo.b);
> percpu_unlock(&foo.lock);

This is too expensive for my taste. If you adopt the above transaction id
scheme then you will have rt performance on per cpu sections that is
competitive with a non rt kernel. The cost involved is that the per cpu
sections have to be done differently. But there is a win both for RT and
non RT kernels.

> Possibly we could reduce all this percpu madness back to one form
> (__this_cpu_*) and require that when used a lock of the percpu_lock_t is
> taken.

percpu sections are very performance critical components of the kernel.
Taking locks could be avoided with serialization through transaction ids
f.e.

