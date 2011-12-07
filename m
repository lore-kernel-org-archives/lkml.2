Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1LGN2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:28:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:38935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1LGN2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:28:41 -0500
Message-ID: <1323264485.32012.106.camel@twins>
Subject: Re: [BUG -tip/sched] INFO: suspicious RCU usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 07 Dec 2011 14:28:05 +0100
In-Reply-To: <20111207073942.GA12029@zhy>
References: <20111207073942.GA12029@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 15:39 +0800, Yong Zhang wrote:
> ===============================
> [ INFO: suspicious RCU usage. ]
> -------------------------------
> /build/linux/kernel/sched/fair.c:5091 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by swapper/0/1:
>  #0:  (&sb->s_type->i_mutex_key#2){+.+.+.}, at: [<ffffffff812a0e0c>] debugfs_create_file+0x8c/0x270
> 
> stack backtrace:
> Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc1-00339-gcd490c5 #14
> Call Trace:
>  <IRQ>  [<ffffffff815f9968>] ? _raw_spin_unlock_irqrestore+0x38/0x80
>  [<ffffffff8109407f>] lockdep_rcu_suspicious+0xbf/0xe0
>  [<ffffffff8107dd48>] trigger_load_balance+0x5b8/0x5c0
>  [<ffffffff81070544>] scheduler_tick+0x104/0x160
>  [<ffffffff8104a1ce>] update_process_times+0x6e/0x90
>  [<ffffffff8108e32c>] tick_periodic+0x2c/0x70
>  [<ffffffff8108e394>] tick_handle_periodic+0x24/0x80
>  [<ffffffff812a07a7>] ? T.562+0xf7/0x170
>  [<ffffffff815fce56>] smp_apic_timer_interrupt+0x66/0x98
>  [<ffffffff815fb2f0>] apic_timer_interrupt+0x70/0x80
>  <EOI>  [<ffffffff810984a4>] ? lock_release+0xe4/0x2b0
>  [<ffffffff815f98f3>] _raw_spin_unlock+0x23/0x60
>  [<ffffffff812a07a7>] T.562+0xf7/0x170
>  [<ffffffff812a0e71>] debugfs_create_file+0xf1/0x270
>  [<ffffffff810e96c9>] trace_create_file+0x19/0x50
>  [<ffffffff81af7b3c>] tracer_init_debugfs+0x2bd/0x3c0
>  [<ffffffff810e96c9>] ? trace_create_file+0x19/0x50
>  [<ffffffff81af787f>] ? clear_boot_tracer+0x2d/0x2d
>  [<ffffffff810001d3>] do_one_initcall+0x43/0x180
>  [<ffffffff81adf637>] kernel_init+0xd0/0x156
>  [<ffffffff815fc574>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8106fdb8>] ? finish_task_switch+0x88/0xf0
>  [<ffffffff815f99eb>] ? _raw_spin_unlock_irq+0x3b/0x70
>  [<ffffffff815f9f61>] ? retint_restore_args+0xe/0xe
>  [<ffffffff81adf567>] ? parse_early_options+0x20/0x20
>  [<ffffffff815fc570>] ? gs_change+0xb/0xb
> 
> Seems due to commit [0b005cf5: sched, nohz: Implement sched group, domain
> aware nohz idle load balancing]

I think something like the below should suffice, the sd argument only
lives inside the for_each_domain() so wrapping the whole block should
suffice.

---
 kernel/sched/fair.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6482136..a4d2b7a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5088,23 +5088,28 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (rq->nr_running >= 2)
 		goto need_kick;
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		struct sched_group *sg = sd->groups;
 		struct sched_group_power *sgp = sg->sgp;
 		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
 
 		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
-			goto need_kick;
+			goto need_kick_unlock;
 
 		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
 		    && (cpumask_first_and(nohz.idle_cpus_mask,
 					  sched_domain_span(sd)) < cpu))
-			goto need_kick;
+			goto need_kick_unlock;
 
 		if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
 			break;
 	}
+	rcu_read_unlock();
 	return 0;
+
+need_kick_unlock:
+	rcu_read_unlock();
 need_kick:
 	return 1;
 }

