Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2EBDg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:36:27 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35450 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2EBDg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:36:26 -0400
Message-ID: <4FA0ABA7.10906@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 11:36:07 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 35/41] sched: Update rq clock before idle balancing
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-36-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1335830115-14335-36-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050118-3568-0000-0000-000001A212B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 07:55 AM, Frederic Weisbecker wrote:

> idle_balance() is called from schedule() right before we schedule the
> idle task. It needs to record the idle timestamp at that time and for
> this the rq clock must be accurate. If the CPU is running tickless
> we need to update the rq clock manually.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/sched/fair.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index eff80e0..cd871e7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4638,6 +4638,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	int pulled_task = 0;
>  	unsigned long next_balance = jiffies + HZ;
> 
> +	update_nohz_rq_clock(this_rq);


I'm not sure but why we have to care nohz? if we really need an accurate
clock, we should do the update anyway, don't we?

Some thing also confused me is the description:
"If the CPU is running tickless we need to update the rq clock manually."

I think the cpu will enter tickless mode only when the idle thread
already switched in, then invoke
tick_nohz_idle_enter->tick_nohz_stop_sched_tick, isn't it?

And if we invoke idle_balance for a cpu, that means it hasn't enter
idle(current task is not idle task), so how can such a cpu in tickless mode?

Regards,
Michael Wang

>  	this_rq->idle_stamp = this_rq->clock;
> 
>  	if (this_rq->avg_idle < sysctl_sched_migration_cost)

