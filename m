Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab0LVJUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:20:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:37260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0LVJUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:20:23 -0500
Subject: Re: [PATCH 5/5] Account ksoftirqd time as cpustat softirq -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>
In-Reply-To: <1292980144-28796-6-git-send-email-venki@google.com>
References: <1292980144-28796-1-git-send-email-venki@google.com>
	 <1292980144-28796-6-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 10:20:21 +0100
Message-ID: <1293009621.2170.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 17:09 -0800, Venkatesh Pallipadi wrote:
> softirq time in ksoftirqd context is not accounted in ns granularity
> per cpu softirq stats, as we want that to be a part of ksoftirqd
> exec_runtime.
> 
> Accounting them as softirq on /proc/stat separately.
> 
> Tested-by: Shaun Ruffell <sruffell@digium.com>
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  kernel/sched.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 193b1d0..4ff6d1a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3819,6 +3819,14 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
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

So you add the ksoftirqd runtime as softirq time in the /proc/stat
output?

That seems dubious...
