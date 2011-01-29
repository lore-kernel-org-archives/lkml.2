Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1A2B1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 20:27:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab1A2B1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 20:27:18 -0500
Subject: Re: [PATCH v2 3/6] KVM-GST: KVM Steal time accounting
From: Glauber Costa <glommer@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aliguori@us.ibm.com" <aliguori@us.ibm.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <4D436A68.2000100@goop.org>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-4-git-send-email-glommer@redhat.com>
	 <4D436A68.2000100@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 28 Jan 2011 23:27:08 -0200
Message-ID: <1296264428.3591.40.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 17:16 -0800, Jeremy Fitzhardinge wrote:
> On 01/28/2011 11:52 AM, Glauber Costa wrote:
> > This patch accounts steal time time in kernel/sched.
> > I kept it from last proposal, because I still see advantages
> > in it: Doing it here will give us easier access from scheduler
> > variables such as the cpu rq. The next patch shows an example of
> > usage for it.
> 
> Is this used on the host or guest side?

Guest.

>     J
> 
> > Since functions like account_idle_time() can be called from
> > multiple places, not only account_process_tick(), steal time
> > grabbing is repeated in each account function separatedely.
> >
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > CC: Rik van Riel <riel@redhat.com>
> > CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Avi Kivity <avi@redhat.com>
> > ---
> >  include/linux/sched.h |    1 +
> >  kernel/sched.c        |   41 +++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 42 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index d747f94..77e9297 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -302,6 +302,7 @@ long io_schedule_timeout(long timeout);
> >  extern void cpu_init (void);
> >  extern void trap_init(void);
> >  extern void update_process_times(int user);
> > +extern u64 (*hypervisor_steal_time)(void);
> >  extern void scheduler_tick(void);
> >  
> >  extern void sched_show_task(struct task_struct *p);
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index ea3e5ef..7765e9d 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -3508,6 +3508,39 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
> >  	return ns;
> >  }
> >  
> > +u64 (*hypervisor_steal_time)(void) = NULL;
> > +
> > +/*
> > + * We have to at flush steal time information every time something else
> > + * is accounted. Since the accounting functions are all visible to the rest
> > + * of the kernel, it gets tricky to do them in one place. This helper function
> > + * helps us.
> > + *
> > + * When the system is idle, the concept of steal time does not apply. We just
> > + * tell the underlying hypervisor that we grabbed the data, but skip steal time
> > + * accounting
> > + */
> > +static int touch_steal_time(int is_idle)
> > +{
> > +	u64 steal, st;
> > +
> > +	if (!hypervisor_steal_time)
> > +		return 0;
> > +
> > +	steal = hypervisor_steal_time();
> > +
> > +	st = usecs_to_cputime(steal / 1000);
> > +
> > +	if (is_idle)
> > +		return 0;
> > +
> > +	if (st) {
> > +		account_steal_time(st);
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Account user cpu time to a process.
> >   * @p: the process that the cpu time gets accounted to
> > @@ -3520,6 +3553,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
> >  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> >  	cputime64_t tmp;
> >  
> > +	if (touch_steal_time(0))
> > +		return;
> > +
> >  	/* Add user time to process. */
> >  	p->utime = cputime_add(p->utime, cputime);
> >  	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
> > @@ -3580,6 +3616,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
> >  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> >  	cputime64_t tmp;
> >  
> > +	if (touch_steal_time(0))
> > +		return;
> > +
> >  	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
> >  		account_guest_time(p, cputime, cputime_scaled);
> >  		return;
> > @@ -3627,6 +3666,8 @@ void account_idle_time(cputime_t cputime)
> >  	cputime64_t cputime64 = cputime_to_cputime64(cputime);
> >  	struct rq *rq = this_rq();
> >  
> > +	touch_steal_time(1);
> > +
> >  	if (atomic_read(&rq->nr_iowait) > 0)
> >  		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
> >  	else
> 


