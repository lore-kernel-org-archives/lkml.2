Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab0GFAtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:49:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34562 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0GFAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:49:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/11] oom: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20100702144941.8fa101c3.akpm@linux-foundation.org>
References: <20100630183243.AA65.A69D9226@jp.fujitsu.com> <20100702144941.8fa101c3.akpm@linux-foundation.org>
Message-Id: <20100706091607.CCCC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Jul 2010 09:49:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to James)

> On Wed, 30 Jun 2010 18:33:23 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > +static void boost_dying_task_prio(struct task_struct *p,
> > +				  struct mem_cgroup *mem)
> > +{
> > +	struct sched_param param = { .sched_priority = 1 };
> > +
> > +	if (mem)
> > +		return;
> > +
> > +	if (!rt_task(p))
> > +		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> > +}
> 
> We can actually make `param' static here.  That saves a teeny bit of
> code and a little bit of stack.  The oom-killer can be called when
> we're using a lot of stack.
> 
> But if we make that change we really should make the param arg to
> sched_setscheduler_nocheck() be const.  I did that (and was able to
> convert lots of callers to use a static `param') but to complete the
> job we'd need to chase through all the security goop, fixing up
> security_task_setscheduler() and callees, and I got bored.

ok, I've finished this works. I made two patches, for-security-tree and
for-core. diffstat is below.

I'll post the patches as reply of this mail.


KOSAKI Motohiro (2):
  security: add const to security_task_setscheduler()
  sched: make sched_param arugment static variables in some
    sched_setscheduler() caller

 include/linux/sched.h         |    5 +++--
 include/linux/security.h      |    9 +++++----
 kernel/irq/manage.c           |    4 +++-
 kernel/kthread.c              |    2 +-
 kernel/sched.c                |    6 +++---
 kernel/softirq.c              |    4 +++-
 kernel/stop_machine.c         |    2 +-
 kernel/trace/trace_selftest.c |    2 +-
 kernel/watchdog.c             |    2 +-
 kernel/workqueue.c            |    2 +-
 security/commoncap.c          |    2 +-
 security/security.c           |    4 ++--
 security/selinux/hooks.c      |    3 ++-
 security/smack/smack_lsm.c    |    2 +-
 14 files changed, 28 insertions(+), 21 deletions(-)

 - kosaki


> 
> 
>  include/linux/sched.h |    2 +-
>  kernel/kthread.c      |    2 +-
>  kernel/sched.c        |    4 ++--
>  kernel/softirq.c      |    4 +++-
>  kernel/stop_machine.c |    2 +-
>  kernel/workqueue.c    |    2 +-
>  6 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff -puN kernel/kthread.c~a kernel/kthread.c
> --- a/kernel/kthread.c~a
> +++ a/kernel/kthread.c
> @@ -131,7 +131,7 @@ struct task_struct *kthread_create(int (
>  	wait_for_completion(&create.done);
>  
>  	if (!IS_ERR(create.result)) {
> -		struct sched_param param = { .sched_priority = 0 };
> +		static struct sched_param param = { .sched_priority = 0 };
>  		va_list args;
>  
>  		va_start(args, namefmt);
> diff -puN kernel/workqueue.c~a kernel/workqueue.c
> --- a/kernel/workqueue.c~a
> +++ a/kernel/workqueue.c
> @@ -962,7 +962,7 @@ init_cpu_workqueue(struct workqueue_stru
>  
>  static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
>  {
> -	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> +	static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>  	struct workqueue_struct *wq = cwq->wq;
>  	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
>  	struct task_struct *p;
> diff -puN kernel/stop_machine.c~a kernel/stop_machine.c
> --- a/kernel/stop_machine.c~a
> +++ a/kernel/stop_machine.c
> @@ -291,7 +291,7 @@ repeat:
>  static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
>  					   unsigned long action, void *hcpu)
>  {
> -	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
> +	static struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
>  	unsigned int cpu = (unsigned long)hcpu;
>  	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
>  	struct task_struct *p;
> diff -puN kernel/sched.c~a kernel/sched.c
> --- a/kernel/sched.c~a
> +++ a/kernel/sched.c
> @@ -4570,7 +4570,7 @@ static bool check_same_owner(struct task
>  }
>  
>  static int __sched_setscheduler(struct task_struct *p, int policy,
> -				struct sched_param *param, bool user)
> +				const struct sched_param *param, bool user)
>  {
>  	int retval, oldprio, oldpolicy = -1, on_rq, running;
>  	unsigned long flags;
> @@ -4734,7 +4734,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
>   * but our caller might not have that capability.
>   */
>  int sched_setscheduler_nocheck(struct task_struct *p, int policy,
> -			       struct sched_param *param)
> +			       const struct sched_param *param)
>  {
>  	return __sched_setscheduler(p, policy, param, false);
>  }
> diff -puN kernel/softirq.c~a kernel/softirq.c
> --- a/kernel/softirq.c~a
> +++ a/kernel/softirq.c
> @@ -827,7 +827,9 @@ static int __cpuinit cpu_callback(struct
>  			     cpumask_any(cpu_online_mask));
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN: {
> -		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> +		static struct sched_param param = {
> +				.sched_priority = MAX_RT_PRIO-1,
> +			};
>  
>  		p = per_cpu(ksoftirqd, hotcpu);
>  		per_cpu(ksoftirqd, hotcpu) = NULL;
> diff -puN include/linux/sched.h~a include/linux/sched.h
> --- a/include/linux/sched.h~a
> +++ a/include/linux/sched.h
> @@ -1924,7 +1924,7 @@ extern int task_curr(const struct task_s
>  extern int idle_cpu(int cpu);
>  extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
>  extern int sched_setscheduler_nocheck(struct task_struct *, int,
> -				      struct sched_param *);
> +				      const struct sched_param *);
>  extern struct task_struct *idle_task(int cpu);
>  extern struct task_struct *curr_task(int cpu);
>  extern void set_curr_task(int cpu, struct task_struct *p);
> _
> 



