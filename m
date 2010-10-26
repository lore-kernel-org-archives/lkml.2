Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0JZJeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:34:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:44495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0JZJeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:34:13 -0400
Subject: Re: [PATCH 6/6] Account ksoftirqd time as cpustat softirq -v1
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <1288045817-3135-7-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
	 <1288045817-3135-7-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Oct 2010 11:33:52 +0200
Message-ID: <1288085632.15336.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:30 -0700, Venkatesh Pallipadi wrote:
> softirq time in ksoftirqd context is not accounted in ns granularity
> per cpu softirq stats, as we want that to be a part of ksoftirqd
> exec_runtime.
> 
> Accounting them as softirq on /proc/stat separately.
> 
> Tested-by: Shaun Ruffell <sruffell@digium.com>
> 
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  kernel/sched.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 49f6f61..0955050 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3617,6 +3617,14 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>  		cpustat->irq = cputime64_add(cpustat->irq, tmp);
>  	} else if (irqtime_account_si_update()) {
>  		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
> +	} else if (this_cpu_ksoftirqd() == p) {
> +		/*
> +		 * ksoftirqd time do not get accounted in cpu_softirq_time.
> +		 * So, we have to handle it separately here.
> +		 * Also, p->stime needs to be updated for ksoftirqd.
> +		 */
> +		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> +					&cpustat->softirq);
>  	} else if (user_tick) {
>  		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>  	} else if (p == rq->idle) {


I'm somewhat confused by this patch.. This is significantly different
from the thing proposed last time around, which was to use:

  cpustat->softirq + this_cpu_ksoftirqd()->se.sum_exec_runtime

The above looses the fine grained aspect of the accounting and simply
charges a whole jiffy if the current process happens to be ksoftirqd.


