Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab0EUSSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:18:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab0EUSSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:18:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=eldgSB7mXYqFWIw1n0cX3zPS4lyUxAAU4wguxE/SJYAJ7yA/vq4rSewP3vkIfscjC
	oApC8rFGlbCAELmtVAB+A==
MIME-Version: 1.0
In-Reply-To: <1274461787.1674.1717.camel@laptop>
References: <AANLkTilLtDWQsAUrIxJ6s04WTgmw9GuOODc5AOrYsaR5@mail.gmail.com>
	 <tip-4afc7e60ab25b72611771e48ca97b4f0104f77c7@git.kernel.org>
	 <20100521170320.GA2023@elte.hu> <1274461787.1674.1717.camel@laptop>
Date: Fri, 21 May 2010 11:18:29 -0700
Message-ID: <AANLkTikNf1ID47mr6BuXkf718Cga1NbB2bEDPJ-3fkzR@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Avoid side-effect of tickless idle on 
	update_cpu_load
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 10:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-21 at 19:03 +0200, Ingo Molnar wrote:
>> * tip-bot for Venkatesh Pallipadi <venki@google.com> wrote:
>>
>> > Commit-ID:  4afc7e60ab25b72611771e48ca97b4f0104f77c7
>> > Gitweb:     http://git.kernel.org/tip/4afc7e60ab25b72611771e48ca97b4f0104f77c7
>> > Author:     Venkatesh Pallipadi <venki@google.com>
>> > AuthorDate: Mon, 17 May 2010 18:14:43 -0700
>> > Committer:  Ingo Molnar <mingo@elte.hu>
>> > CommitDate: Fri, 21 May 2010 11:37:17 +0200
>> >
>> > sched: Avoid side-effect of tickless idle on update_cpu_load
>>
>> ok, probably this patch is causing:
>>
>> [   59.250427]
>> [   59.250429] =================================
>> [   59.256299] [ INFO: inconsistent lock state ]
>> [   59.260014] 2.6.34-tip+ #6253
>> [   59.260014] ---------------------------------
>> [   59.260014] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
>> [   59.260014] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>> [   59.260014]  (&rq->lock){?.-.-.}, at: [<ffffffff81038e23>] run_rebalance_domains+0xa1/0x131
>> [   59.260014] {IN-HARDIRQ-W} state was registered at:
>> [   59.260014]   [<ffffffff8106583a>] __lock_acquire+0x5e8/0x1384
>> [   59.260014]   [<ffffffff81066659>] lock_acquire+0x83/0x9d
>> [   59.260014]   [<ffffffff81bae24c>] _raw_spin_lock+0x3b/0x6e
>> [   59.260014]   [<ffffffff81037865>] scheduler_tick+0x3a/0x2b7
>> [   59.260014]   [<ffffffff810497c4>] update_process_times+0x4b/0x5b
>> [   59.260014]   [<ffffffff8105f467>] tick_periodic+0x63/0x6f
>> [   59.260014]   [<ffffffff8105f492>] tick_handle_periodic+0x1f/0x6d
>> [   59.260014]   [<ffffffff81005e2d>] timer_interrupt+0x19/0x20
>> [   59.260014]   [<ffffffff81084dc9>] handle_IRQ_event+0x20/0x9f
>> [   59.260014]   [<ffffffff81086c2e>] handle_level_irq+0x9a/0xf4
>> [   59.260014]   [<ffffffff81005729>] handle_irq+0x62/0x6d
>> [   59.260014]   [<ffffffff81004b08>] do_IRQ+0x5e/0xc4
>> [   59.260014]   [<ffffffff81baefd3>] ret_from_intr+0x0/0xf
>> [   59.260014]   [<ffffffff81085abb>] __setup_irq+0x21b/0x2c1
>> [   59.260014]   [<ffffffff81085d06>] setup_irq+0x1e/0x23
>> [   59.260014]   [<ffffffff8282735f>] setup_default_timer_irq+0x12/0x14
>> [   59.260014]   [<ffffffff82827378>] hpet_time_init+0x17/0x19
>> [   59.260014]   [<ffffffff82827346>] x86_late_time_init+0xa/0x11
>> [   59.260014]   [<ffffffff82824ce9>] start_kernel+0x338/0x3bf
>> [   59.260014]   [<ffffffff828242a3>] x86_64_start_reservations+0xb3/0xb7
>> [   59.260014]   [<ffffffff8282438b>] x86_64_start_kernel+0xe4/0xeb
>> [   59.260014] irq event stamp: 186338
>> [   59.260014] hardirqs last  enabled at (186338): [<ffffffff81baecf5>] _raw_spin_unlock_irq+0x2b/0x53
>> [   59.260014] hardirqs last disabled at (186337): [<ffffffff81bae317>] _raw_spin_lock_irq+0x14/0x74
>> [   59.260014] softirqs last  enabled at (186326): [<ffffffff810449fe>] __do_softirq+0x13a/0x150
>> [   59.260014] softirqs last disabled at (186331): [<ffffffff8100388c>] call_softirq+0x1c/0x28
>> [   59.260014]
>
> I figure the below should fix that..
>
> ---
>  kernel/sched_fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index e91f833..980c909 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3411,9 +3411,9 @@ static void run_rebalance_domains(struct softirq_action *h)
>                                break;
>
>                        rq = cpu_rq(balance_cpu);
> -                       raw_spin_lock(&rq->lock);
> +                       raw_spin_lock_irq(&rq->lock);
>                        update_cpu_load(rq);
> -                       raw_spin_unlock(&rq->lock);
> +                       raw_spin_unlock_irq(&rq->lock);
>                        rebalance_domains(balance_cpu, CPU_IDLE);
>
>                        if (time_after(this_rq->next_balance, rq->next_balance))
>
>

Yes. Verified that the above change fixes the problem.

Thanks,
Venki
