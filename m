Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1DZMu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:50:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62851 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1DZMu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=givVzzB98LP2LMk9ArP7Xufz4GDU/RtffFACsfCAgXbXWv7Y5tFZ8JgjoEDo90NYrO
         Low6Em20smgbOoy/h4zhQO5hSqQVV6xDtjmR7XefRcDRHkrlxu2hlzADlBMcvyBE/Sc8
         sw/SKl8MbcYSOt12C053OZHrM+esquUP41aOA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110426124256.GI4308@linux.vnet.ibm.com>
References: <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
	<20110423210539.GI2628@linux.vnet.ibm.com>
	<BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
	<BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
	<BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
	<20110424062728.GM2628@linux.vnet.ibm.com>
	<BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
	<20110424164331.GN2628@linux.vnet.ibm.com>
	<20110426050612.GA7651@linux.vnet.ibm.com>
	<BANLkTi=uvTkKi2Py5v818PKCDYKoLcDCSw@mail.gmail.com>
	<20110426124256.GI4308@linux.vnet.ibm.com>
Date: Tue, 26 Apr 2011 14:50:25 +0200
Message-ID: <BANLkTiko8dcYQtTo2P80nk503vxNabaLPw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 2:42 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Apr 26, 2011 at 01:45:31PM +0200, Sedat Dilek wrote:
>> On Tue, Apr 26, 2011 at 7:06 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Sun, Apr 24, 2011 at 09:43:31AM -0700, Paul E. McKenney wrote:
>> >> On Sun, Apr 24, 2011 at 11:36:44AM +0200, Sedat Dilek wrote:
>> >> > On Sun, Apr 24, 2011 at 8:27 AM, Paul E. McKenney
>> >> > <paulmck@linux.vnet.ibm.com> wrote:
>> >>
>> >> [ . . . ]
>> >>
>> >> > > OK, this looks unrelated, but just in case, could you please try it
>> >> > > again with the following patch?  (Not mainlinable, debug only.)
>> >> > >
>> >> > > Also, it does look like you are still seeing a grace-period hang.
>> >> > > Could you please send the output of the script?  Same one as last time.
>> >> > >
>> >> > >                                                        Thanx, Paul
>> >> > >
>> >> > > ------------------------------------------------------------------------
>> >> > >
>> >> > >  debugobjects.c |    8 +++++---
>> >> > >  1 file changed, 5 insertions(+), 3 deletions(-)
>> >> > >
>> >> > > diff --git a/lib/debugobjects.c b/lib/debugobjects.c
>> >> > > index 9d86e45..10a7c7a 100644
>> >> > > --- a/lib/debugobjects.c
>> >> > > +++ b/lib/debugobjects.c
>> >> > > @@ -289,10 +289,12 @@ static void debug_object_is_on_stack(void *addr, int onstack)
>> >> > >                return;
>> >> > >
>> >> > >        limit++;
>> >> > > -       if (is_on_stack)
>> >> > > +       if (is_on_stack) {
>> >> > > +               struct rcu_head *p = (struct rcu_head *)addr;
>> >> > >                printk(KERN_WARNING
>> >> > > -                      "ODEBUG: object is on stack, but not annotated\n");
>> >> > > -       else
>> >> > > +                      "ODEBUG: object is on stack, but not annotated: %p\n",
>> >> > > +                      p->func);
>> >> > > +       } else
>> >> > >                printk(KERN_WARNING
>> >> > >                       "ODEBUG: object is not on stack, but annotated\n");
>> >> > >        WARN_ON(1);
>> >> > >
>> >> >
>> >> > Somehow your attached patch was not applicable.
>> >> > As the changes were a few lines I applied it by myself.
>> >> > Attached are log, dmesg and patches (orig + mine)
>> >>
>> >> Hmmm...  Does 0xc10231a1 correspond to a function in your build?  If so,
>> >> could you please let me know which one?
>> >>
>> >> OK, so according to "ps" the per-CPU kthread is runnable, but it appears
>> >> to never run.  You only have one CPU, so it cannot be waiting due to
>> >> running on the wrong CPU.  The only other loop is in wait_event(), and
>> >> that code looks good -- besides, if wait_event() was broken, we would
>> >> be seeing breakage everywhere.
>> >>
>> >> Peter, any thoughts on what I might have done wrong to get the scheduler
>> >> into a state where it was ignoring a runnable realtime task?
>> >
>> > Hello, Sedat,
>> >
>> > Here is a diagnostic patch to apply on top of sedat.2011.04.23a from
>> > the -rcu git tree.  Could you please try it out, let me know what
>> > happens, and run the last collectdebugfs.sh during the test?
>> >
>> >                                                        Thanx, Paul
>> >
>> > ------------------------------------------------------------------------
>> >
>> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> > index 6cf6e47..65ae701 100644
>> > --- a/kernel/rcutree.c
>> > +++ b/kernel/rcutree.c
>> > @@ -1524,9 +1524,9 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
>> >                return;
>> >        if (to_rt) {
>> >                policy = SCHED_NORMAL;
>> > -               sp.sched_priority = RCU_KTHREAD_PRIO;
>> > +               sp.sched_priority = 0;
>> >        } else {
>> > -               policy = SCHED_FIFO;
>> > +               policy = SCHED_NORMAL;
>> >                sp.sched_priority = 0;
>> >        }
>> >        sched_setscheduler_nocheck(t, policy, &sp);
>> > @@ -1566,8 +1566,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
>> >        sp.sched_priority = 0;
>> >        sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
>> >        schedule();
>> > -       sp.sched_priority = RCU_KTHREAD_PRIO;
>> > -       sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
>> > +       sp.sched_priority = 0;
>> > +       sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
>> >        del_timer(&yield_timer);
>> >  }
>> >
>> > @@ -1671,8 +1671,8 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
>> >        WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
>> >        per_cpu(rcu_cpu_kthread_task, cpu) = t;
>> >        wake_up_process(t);
>> > -       sp.sched_priority = RCU_KTHREAD_PRIO;
>> > -       sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
>> > +       sp.sched_priority = 0;
>> > +       sched_setscheduler_nocheck(t, SCHED_NORMAL, &sp);
>> >        return 0;
>> >  }
>> >
>> > @@ -1713,8 +1713,8 @@ static int rcu_node_kthread(void *arg)
>> >                                continue;
>> >                        }
>> >                        per_cpu(rcu_cpu_has_work, cpu) = 1;
>> > -                       sp.sched_priority = RCU_KTHREAD_PRIO;
>> > -                       sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
>> > +                       sp.sched_priority = 0;
>> > +                       sched_setscheduler_nocheck(t, SCHED_NORMAL, &sp);
>> >                        preempt_enable();
>> >                }
>> >        }
>> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
>> > index a21413d..baee185 100644
>> > --- a/kernel/rcutree_plugin.h
>> > +++ b/kernel/rcutree_plugin.h
>> > @@ -1307,8 +1307,8 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
>> >        rnp->boost_kthread_task = t;
>> >        raw_spin_unlock_irqrestore(&rnp->lock, flags);
>> >        wake_up_process(t);
>> > -       sp.sched_priority = RCU_KTHREAD_PRIO;
>> > -       sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
>> > +       sp.sched_priority = 0;
>> > +       sched_setscheduler_nocheck(t, SCHED_NORMAL, &sp);
>> >        return 0;
>> >  }
>> >
>> >
>>
>> Hi Paul,
>>
>> I have tested with your patch and kept the kernel-config file from
>> previous tests (don't get confused by the new name).
>> Hope this helps you.
>>
>> I have some questions to k-c options espcially X86_UP and
>> CONFIG_RCU_FANOUT=32 options.
>> To what extent can they influence our RCU issue?
>> The below options were not set for this round of testing, but I would
>> like to have a feedback.
>> Thanks in advance.
>>
>> Would these settings be more optimal for a UP-machine?
>>
>> # CONFIG_SMP is not set
>> # CONFIG_M486 is not set
>> CONFIG_M686=y
>> CONFIG_NR_CPUS=1
>
> These should be fine.
>
>> CONFIG_X86_UP_APIC=y
>> CONFIG_X86_UP_IOAPIC=y
>
> These I don't know about.
>
>> CONFIG_HIGHMEM4G=y
>
> This one seems good for allowing the system to go as long as possible.
>
>> Is CONFIG_RCU_FANOUT=32 OK?
>
> On a UP system, this one doesn't matter.
>
>> With reverting commit 687d7a960aea46e016182c7ce346d62c4dbd0366 ("rcu:
>> restrict TREE_RCU to SMP builds with !PREEMPT").
>
> Thank you for trying this one out!
>
> I don't see any sign of a grace-period hang.  Did your test complete
> correctly?
>
>                                                        Thanx, Paul
>

Thanks for the comments.

I let run the script very long (approx. one hour) and did parallelly
my daily work.
Then booted into a known as working kernel.
Did I miss something, should I stress more?

- Sedat -
