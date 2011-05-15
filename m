Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1EOVeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 17:34:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60649 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab1EOVeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 17:34:16 -0400
Date: Sun, 15 May 2011 11:55:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
Message-ID: <20110515185547.GL2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110428161149.GA15658@redhat.com>
 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
 <20110502195657.2D68.A69D9226@jp.fujitsu.com>
 <1305129929.2914.247.camel@laptop>
 <4DCCC61F.80408@jp.fujitsu.com>
 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 02:42:48PM +0800, Yong Zhang wrote:
> On Fri, May 13, 2011 at 1:48 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> >
> >> On Mon, 2011-05-02 at 19:55 +0900, KOSAKI Motohiro wrote:
> >>>
> >>> The rule is, we have to update tsk->rt.nr_cpus_allowed too if we change
> >>> tsk->cpus_allowed. Otherwise RT scheduler may confuse.
> >>>
> >>> This patch fixes it.
> >>>
> >>> btw, system_state checking is very important. current boot sequence is
> >>> (1) smp_init
> >>> (ie secondary cpus up and created cpu bound kthreads). (2)
> >>> sched_init_smp().
> >>> Then following bad scenario can be happen,
> >>>
> >>> (1) cpuup call notifier(CPU_UP_PREPARE)
> >>> (2) A cpu notifier consumer create FIFO kthread
> >>> (3) It call kthread_bind()
> >>>    ... but, now secondary cpu haven't ONLINE
> >>
> >> isn't
> >
> > thanks, correction.
> >
> >>
> >>> (3) schedule() makes fallback and cpuset_cpus_allowed_fallback
> >>>     change task->cpus_allowed
> >>
> >> I'm failing to see how this is happening, surely that kthread isn't
> >> actually running that early?
> >
> > If my understand correctly, current call graph is below.
> >
> > kernel_init()
> >        smp_init();
> >                cpu_up()
> >                        ... cpu hotplug notification
> >                                kthread_create()
> >        sched_init_smp();
> >
> >
> > So, cpu hotplug event is happen before sched_init_smp(). The old rule is,
> > all kthreads of using cpu-up notification have to use kthread_bind(). It
> > protected from sched load balance.
> >
> > but, now cpuset_cpus_allowed_fallback() forcedly change kthread's cpumask.
> > Why is this works? the point are two.
> >
> > - rcu_cpu_kthread_should_stop() call set_cpus_allowed_ptr() again
> > periodically.
> >  then, it can reset cpumask if cpuset_cpus_allowed_fallback() change it.
> >  my debug print obseve following cpumask change occur at boot time.
> >     1) kthread_bind: bind cpu1
> >     2) cpuset_cpus_allowed_fallback: bind possible cpu
> >     3) rcu_cpu_kthread_should_stop: rebind cpu1
> > - while tsk->rt.nr_cpus_allowed == 1, sched load balancer never be crash.
> 
> Seems rcu_spawn_one_cpu_kthread() call wake_up_process() directly,
> which is under hotplug event CPU_UP_PREPARE. Maybe it should be
> under CPU_ONLINE.

Sorry, but this does not work.  The kthread must be running by the time
the CPU appears, otherwise RCU grace periods in CPU_ONLINE notifiers
will never complete.

This did turn out to be a scheduler bug -- see Cheng Xu's recent patch.
(chengxu@linux.vnet.ibm.com)

							Thanx, Paul

> Thanks,
> Yong
> 
> >
> >
> >>
> >>> (4) find_lowest_rq() touch local_cpu_mask if task->rt.nr_cpus_allowed !=
> >>> 1,
> >>>     but it haven't been initialized.
> >>>
> >>> RCU folks plan to introduce such FIFO kthread and our testing hitted the
> >>> above issue. Then this patch also protect it.
> >>
> >> I'm fairly sure it doesn't, normal cpu-hotplug doesn't poke at
> >> system_state.
> >
> > If my understand correctly. it's pure scheduler issue. because
> >
> > - rcuc keep the old rule (ie an early spawned kthread have to call
> > kthread_bind)
> > - cpuset_cpus_allowed_fallback() is called from scheduler internal
> > - crash is happen in find_lowest_rq(). (following line)
> >
> >
> > static int find_lowest_rq(struct task_struct *task)
> > {
> >  (snip)
> >        if (cpumask_test_cpu(cpu, lowest_mask))   // HERE
> >
> >
> > IOW, I think cpuset_cpus_allowed_fallback() should NOT be changed
> > tsk->cpus_allowed until to finish sched_init_smp().
> >
> > Do you have an any alternative idea for this?
> >
> >
> >>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> >>> Cc: Oleg Nesterov<oleg@redhat.com>
> >>> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> >>> Cc: Ingo Molnar<mingo@elte.hu>
> >>> ---
> >>>  include/linux/cpuset.h |    1 +
> >>>  kernel/cpuset.c        |    1 +
> >>>  kernel/sched.c         |    4 ++++
> >>>  3 files changed, 6 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> >>> index f20eb8f..42dcbdc 100644
> >>> --- a/include/linux/cpuset.h
> >>> +++ b/include/linux/cpuset.h
> >>> @@ -147,6 +147,7 @@ static inline void cpuset_cpus_allowed(struct
> >>> task_struct *p,
> >>>  static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
> >>>  {
> >>>        cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> >>> +       p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
> >>>        return cpumask_any(cpu_active_mask);
> >>>  }
> >>>
> >>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> >>> index 1ceeb04..6e5bbe8 100644
> >>> --- a/kernel/cpuset.c
> >>> +++ b/kernel/cpuset.c
> >>> @@ -2220,6 +2220,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct
> >>> *tsk)
> >>>                cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
> >>>                cpu = cpumask_any(cpu_active_mask);
> >>>        }
> >>> +       tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);
> >>>
> >>>        return cpu;
> >>>  }
> >>
> >> I don't really see the point of doing this separately from your second
> >> patch, please fold them.
> >
> > Ok. Will do.
> >
> >>
> >>> diff --git a/kernel/sched.c b/kernel/sched.c
> >>> index fd4625f..bfcd219 100644
> >>> --- a/kernel/sched.c
> >>> +++ b/kernel/sched.c
> >>> @@ -2352,6 +2352,10 @@ static int select_fallback_rq(int cpu, struct
> >>> task_struct *p)
> >>>        if (dest_cpu<  nr_cpu_ids)
> >>>                return dest_cpu;
> >>>
> >>> +       /* Don't worry. It's temporary mismatch. */
> >>> +       if (system_state<  SYSTEM_RUNNING)
> >>> +               return cpu;
> >>> +
> >>>        /* No more Mr. Nice Guy. */
> >>>        dest_cpu = cpuset_cpus_allowed_fallback(p);
> >>>        /*
> >>
> >> Like explained, I don't believe this actually fixes your problem (its
> >> also disgusting).
> >
> > If anybody have an alternative idea, I have no reason to refuse it.
> >
> > Thanks.
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> Only stand for myself
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
