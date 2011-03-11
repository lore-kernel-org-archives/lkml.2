Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1CKBpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:45:23 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:26307
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372Ab1CKBpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:45:21 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK1432N98dNef8Kzz1202hzz8275bhz2fh637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D797E92.20408@am.sony.com>
Date: Thu, 10 Mar 2011 17:44:50 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/22] sched: Move the second half of ttwu() to the remote
 cpu
References: <20110302173831.295031866@chello.nl> <20110302174121.709471743@chello.nl>
In-Reply-To: <20110302174121.709471743@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 09:38, Peter Zijlstra wrote:
> Now that we've removed the rq->lock requirement from the first part of
> ttwu() and can compute placement without holding any rq->lock, ensure
> we execute the second half of ttwu() on the actual cpu we want the
> task to run on.
> 
> This avoids having to take rq->lock and doing the task enqueue
> remotely, saving lots on cacheline transfers.
> 
> As measured using: http://oss.oracle.com/~mason/sembench.c
> 
> $ echo 4096 32000 64 128 > /proc/sys/kernel/sem
> $ ./sembench -t 2048 -w 1900 -o 0
> 
> unpatched: run time 30 seconds 537953 worker burns per second
> patched:   run time 30 seconds 847526 worker burns per second
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  include/linux/sched.h   |    4 +--
>  kernel/sched.c          |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched_features.h |    2 +
>  3 files changed, 60 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -1202,6 +1201,7 @@ struct task_struct {
>  	int lock_depth;		/* BKL lock depth */
>  
>  #ifdef CONFIG_SMP
> +	struct task_struct *wake_entry;
>  	int on_cpu;
>  #endif
>  	int on_rq;
> @@ -2185,7 +2185,7 @@ extern void set_task_comm(struct task_st
>  extern char *get_task_comm(char *to, struct task_struct *tsk);
>  
>  #ifdef CONFIG_SMP
> -static inline void scheduler_ipi(void) { }
> +void scheduler_ipi(void);
>  extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
>  #else
>  static inline unsigned long wait_task_inactive(struct task_struct *p,
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -557,6 +557,10 @@ struct rq {
>  	unsigned int ttwu_count;
>  	unsigned int ttwu_local;
>  #endif
> +
> +#ifdef CONFIG_SMP
> +	struct task_struct *wake_list;
> +#endif
>  };
>  
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
> @@ -2511,10 +2515,61 @@ static int ttwu_remote(struct task_struc
>  	return ret;
>  }
>  
> +#ifdef CONFIG_SMP
> +void sched_ttwu_pending(void)
> +{

sched_ttwu_pending() is now only used in sched.c, so can be static
(in the previous patch version is was called from other files).

> +	struct rq *rq = this_rq();
> +	struct task_struct *list = xchg(&rq->wake_list, NULL);
> +
> +	if (!list)
> +		return;
> +
> +	raw_spin_lock(&rq->lock);
> +
> +	while (list) {
> +		struct task_struct *p = list;
> +		list = list->wake_entry;
> +		ttwu_do_activate(rq, p, 0);
> +	}
> +
> +	raw_spin_unlock(&rq->lock);
> +}
> +
> +void scheduler_ipi(void)
> +{
> +	sched_ttwu_pending();
> +}
> +
> +static void ttwu_queue_remote(struct task_struct *p, int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	struct task_struct *next = rq->wake_list;
> +
> +	for (;;) {
> +		struct task_struct *old = next;
> +
> +		p->wake_entry = next;
> +		next = cmpxchg(&rq->wake_list, old, p);
> +		if (next == old)
> +			break;
> +	}
> +
> +	if (!next)
> +		smp_send_reschedule(cpu);
> +}
> +#endif
> +
>  static void ttwu_queue(struct task_struct *p, int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
>  
> +#ifdef CONFIG_SMP
> +	if (!sched_feat(TTWU_FORCE_REMOTE) && cpu != smp_processor_id()) {
> +		ttwu_queue_remote(p, cpu);
> +		return;
> +	}
> +#endif
> +
>  	raw_spin_lock(&rq->lock);
>  	ttwu_do_activate(rq, p, 0);
>  	raw_spin_unlock(&rq->lock);
> @@ -6287,6 +6342,7 @@ migration_call(struct notifier_block *nf
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  	case CPU_DYING:

Should pi_lock be locked here, so that additional wake ups can not
be put on the wake list in the window after sched_ttwu_pending()
completes, and before set_rq_offline(rq) is called?  If so, then
of course unlock pi_lock after the matching
"raw_spin_unlock_irqrestore(&rq->lock, flags);"

> +		sched_ttwu_pending();
>  		/* Update our root-domain */
>  		raw_spin_lock_irqsave(&rq->lock, flags);
>  		if (rq->rd) {
> Index: linux-2.6/kernel/sched_features.h
> ===================================================================
> --- linux-2.6.orig/kernel/sched_features.h
> +++ linux-2.6/kernel/sched_features.h
> @@ -64,3 +64,5 @@ SCHED_FEAT(OWNER_SPIN, 1)
>   * Decrement CPU power based on irq activity
>   */
>  SCHED_FEAT(NONIRQ_POWER, 1)
> +
> +SCHED_FEAT(TTWU_FORCE_REMOTE, 0)
> 
> 
> 
> .
> 


