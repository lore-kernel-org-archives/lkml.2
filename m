Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1H3PKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:10:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33195 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab1H3PKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:10:50 -0400
Date: Tue, 30 Aug 2011 17:10:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 19/32] nohz/cpuset: Restart tick when nohz flag is
 cleared on cpuset
Message-ID: <20110830151042.GU9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-20-git-send-email-fweisbec@gmail.com>
 <1314633721.2816.109.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314633721.2816.109.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 06:02:01PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > +++ b/kernel/cpuset.c
> > @@ -1199,6 +1199,14 @@ static void cpuset_change_flag(struct task_struct *tsk,
> >  
> >  DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
> >  
> > +static void cpu_exit_nohz(int cpu)
> > +{
> > +       preempt_disable();
> > +       smp_call_function_single(cpu, cpuset_exit_nohz_interrupt,
> > +                                NULL, true);
> > +       preempt_enable();
> > +}
> > +
> >  static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
> >  {
> >         int cpu;
> > @@ -1212,6 +1220,19 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
> >                         per_cpu(cpu_adaptive_nohz_ref, cpu) += 1;
> >                 else
> >                         per_cpu(cpu_adaptive_nohz_ref, cpu) -= 1;
> > +
> > +               val = per_cpu(cpu_adaptive_nohz_ref, cpu);
> > +
> > +               if (!val) {
> > +                       /*
> > +                        * The update to cpu_adaptive_nohz_ref must be
> > +                        * visible right away. So that once we restart the tick
> > +                        * from the IPI, it won't be stopped again due to cache
> > +                        * update lag.
> > +                        */
> > +                       smp_mb();
> > +                       cpu_exit_nohz(cpu);
> > +               }
> >         }
> >  }
> >  #else
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 78ea0a5..75378be 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2513,6 +2513,14 @@ void cpuset_update_nohz(void)
> >                 cpuset_nohz_restart_tick();
> >  }
> >  
> > +void cpuset_exit_nohz_interrupt(void *unused)
> > +{
> > +       if (!tick_nohz_adaptive_mode())
> > +               return;
> > +
> > +       cpuset_nohz_restart_tick();
> > +} 
> 
> You do this just to annoy me, right? Why doesn't it live in cpuset.c
> where you use it?


Right, I'll move all those things and fix the naming / namespace.
