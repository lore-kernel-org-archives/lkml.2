Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab2JXPVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:21:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48385 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965100Ab2JXPVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:21:39 -0400
Message-ID: <5088076D.6080208@ti.com>
Date: Wed, 24 Oct 2012 20:51:17 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <peterz@infradead.org>,
        <mingo@redhat.com>, <pjt@google.com>, <linux@arm.linux.org.uk>
Subject: Re: [RFC 4/6] sched: secure access to other CPU statistics
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org> <1349595838-31274-5-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1349595838-31274-5-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject is bit confusing here.

On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
> The atomic update of runnable_avg_sum and runnable_avg_period are ensured
> by their size and the toolchain. But we must ensure to not read an old value
> for one field and a newly updated value for the other field. As we don't
> want to lock other CPU while reading these fields, we read twice each fields
> and check that no change have occured in the middle.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>   kernel/sched/fair.c |   19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8c9d3ed..6df53b5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3133,13 +3133,28 @@ static int select_idle_sibling(struct task_struct *p, int target)
>   static inline bool is_buddy_busy(int cpu)
>   {
>   	struct rq *rq = cpu_rq(cpu);
> +	volatile u32 *psum = &rq->avg.runnable_avg_sum;
> +	volatile u32 *pperiod = &rq->avg.runnable_avg_period;
> +	u32 sum, new_sum, period, new_period;
> +	int timeout = 10;
So it can be 2 times read or more as well.
> +
> +	while (timeout) {
> +		sum = *psum;
> +		period = *pperiod;
> +		new_sum = *psum;
> +		new_period = *pperiod;
> +
> +		if ((sum == new_sum) && (period == new_period))
> +			break;
> +
> +		timeout--;
> +	}
>
Seems like you did notice incorrect pair getting read
for rq runnable_avg_sum and runnable_avg_period. Seems
like the fix is to update them together under some lock
to avoid such issues.

Regards
Santosh

