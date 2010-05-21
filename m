Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab0EURJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:09:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934028Ab0EURJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:09:52 -0400
Subject: Re: [tip:sched/urgent] sched: Avoid side-effect of tickless idle
 on update_cpu_load
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, venki@google.com, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100521170320.GA2023@elte.hu>
References: <AANLkTilLtDWQsAUrIxJ6s04WTgmw9GuOODc5AOrYsaR5@mail.gmail.com>
	 <tip-4afc7e60ab25b72611771e48ca97b4f0104f77c7@git.kernel.org>
	 <20100521170320.GA2023@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 19:09:47 +0200
Message-ID: <1274461787.1674.1717.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 19:03 +0200, Ingo Molnar wrote:
> * tip-bot for Venkatesh Pallipadi <venki@google.com> wrote:
> 
> > Commit-ID:  4afc7e60ab25b72611771e48ca97b4f0104f77c7
> > Gitweb:     http://git.kernel.org/tip/4afc7e60ab25b72611771e48ca97b4f0104f77c7
> > Author:     Venkatesh Pallipadi <venki@google.com>
> > AuthorDate: Mon, 17 May 2010 18:14:43 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 21 May 2010 11:37:17 +0200
> > 
> > sched: Avoid side-effect of tickless idle on update_cpu_load
> 
> ok, probably this patch is causing:
> 
> [   59.250427] 
> [   59.250429] =================================
> [   59.256299] [ INFO: inconsistent lock state ]
> [   59.260014] 2.6.34-tip+ #6253
> [   59.260014] ---------------------------------
> [   59.260014] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> [   59.260014] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> [   59.260014]  (&rq->lock){?.-.-.}, at: [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
> [   59.260014] {IN-HARDIRQ-W} state was registered at:
> [   59.260014]   [<ffffffff8106583a>] __lock_acquire+0x5e8/0x1384
> [   59.260014]   [<ffffffff81066659>] lock_acquire+0x83/0x9d
> [   59.260014]   [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
> [   59.260014]   [<ffffffff81037865>] scheduler_tick+0x3a/0x2b7
> [   59.260014]   [<ffffffff810497c4>] update_process_times+0x4b/0x5b
> [   59.260014]   [<ffffffff8105f467>] tick_periodic+0x63/0x6f
> [   59.260014]   [<ffffffff8105f492>] tick_handle_periodic+0x1f/0x6d
> [   59.260014]   [<ffffffff81005e2d>] timer_interrupt+0x19/0x20
> [   59.260014]   [<ffffffff81084dc9>] handle_IRQ_event+0x20/0x9f
> [   59.260014]   [<ffffffff81086c2e>] handle_level_irq+0x9a/0xf4
> [   59.260014]   [<ffffffff81005729>] handle_irq+0x62/0x6d
> [   59.260014]   [<ffffffff81004b08>] do_IRQ+0x5e/0xc4
> [   59.260014]   [<ffffffff81baefd3>] ret_from_intr+0x0/0xf
> [   59.260014]   [<ffffffff81085abb>] __setup_irq+0x21b/0x2c1
> [   59.260014]   [<ffffffff81085d06>] setup_irq+0x1e/0x23
> [   59.260014]   [<ffffffff8282735f>] setup_default_timer_irq+0x12/0x14
> [   59.260014]   [<ffffffff82827378>] hpet_time_init+0x17/0x19
> [   59.260014]   [<ffffffff82827346>] x86_late_time_init+0xa/0x11
> [   59.260014]   [<ffffffff82824ce9>] start_kernel+0x338/0x3bf
> [   59.260014]   [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
> [   59.260014]   [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb
> [   59.260014] irq event stamp: 186338
> [   59.260014] hardirqs last  enabled at (186338): [<ffffffff81baecf5>] _raw_spin_unlock_irq+0x2b/0x53
> [   59.260014] hardirqs last disabled at (186337): [<ffffffff81bae317>] _raw_spin_lock_irq+0x14/0x74
> [   59.260014] softirqs last  enabled at (186326): [<ffffffff810449fe>] __do_softirq+0x13a/0x150
> [   59.260014] softirqs last disabled at (186331): [<ffffffff8100388c>] call_softirq+0x1c/0x28
> [   59.260014] 
> [   59.260014] other info that might help us debug this:
> [   59.260014] no locks held by swapper/0.
> [   59.260014] 
> [   59.260014] stack backtrace:
> [   59.260014] Pid: 0, comm: swapper Not tainted 2.6.34-tip+ #6253
> [   59.260014] Call Trace:
> [   59.260014]  <IRQ>  [<ffffffff8106318d>] print_usage_bug+0x187/0x198
> [   59.260014]  [<ffffffff8100d920>] ? save_stack_trace+0x2a/0x47
> [   59.260014]  [<ffffffff81063c67>] ? check_usage_backwards+0x0/0xa5
> [   59.260014]  [<ffffffff810633cd>] mark_lock+0x22f/0x412
> [   59.260014]  [<ffffffff810658b3>] __lock_acquire+0x661/0x1384
> [   59.260014]  [<ffffffff81038631>] ? load_balance+0xda/0x64d
> [   59.260014]  [<ffffffff8106275e>] ? put_lock_stats+0xe/0x27
> [   59.260014]  [<ffffffff8106285d>] ? lock_release_holdtime+0xe6/0xeb
> [   59.260014]  [<ffffffff81066659>] lock_acquire+0x83/0x9d
> [   59.260014]  [<ffffffff81038e23>] ? run_rebalance_domains+0xa1/0x131
> [   59.260014]  [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
> [   59.260014]  [<ffffffff81038e23>] ? run_rebalance_domains+0xa1/0x131
> [   59.260014]  [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
> [   59.260014]  [<ffffffff81044979>] __do_softirq+0xb5/0x150
> [   59.260014]  [<ffffffff8100388c>] call_softirq+0x1c/0x28
> [   59.260014]  [<ffffffff81005690>] do_softirq+0x38/0x6f
> [   59.260014]  [<ffffffff81044571>] irq_exit+0x45/0x90
> [   59.260014]  [<ffffffff81017ec4>] smp_apic_timer_interrupt+0x87/0x95
> [   59.260014]  [<ffffffff81003353>] apic_timer_interrupt+0x13/0x20
> [   59.260014]  <EOI>  [<ffffffff81009f8c>] ? default_idle+0x29/0x43
> [   59.260014]  [<ffffffff81009f8a>] ? default_idle+0x27/0x43
> [   59.260014]  [<ffffffff81001c52>] cpu_idle+0x6c/0xbe
> [   59.260014]  [<ffffffff81b411fb>] rest_init+0xff/0x106
> [   59.260014]  [<ffffffff81b410fc>] ? rest_init+0x0/0x106
> [   59.260014]  [<ffffffff82824d65>] start_kernel+0x3b4/0x3bf
> [   59.260014]  [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
> [   59.260014]  [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb 

I figure the below should fix that..

---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e91f833..980c909 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3411,9 +3411,9 @@ static void run_rebalance_domains(struct softirq_action *h)
 				break;
 
 			rq = cpu_rq(balance_cpu);
-			raw_spin_lock(&rq->lock);
+			raw_spin_lock_irq(&rq->lock);
 			update_cpu_load(rq);
-			raw_spin_unlock(&rq->lock);
+			raw_spin_unlock_irq(&rq->lock);
 			rebalance_domains(balance_cpu, CPU_IDLE);
 
 			if (time_after(this_rq->next_balance, rq->next_balance))


