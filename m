Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0KTKmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 05:42:22 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42681 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0KTKmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 05:42:20 -0500
Subject: Re: [PATCH 1/5] sched: Enable might_sleep before initializing
 drivers.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1290218934-8544-2-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	 <1290218934-8544-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 20 Nov 2010 11:42:35 +0100
Message-ID: <1290249755.2118.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 18:08 -0800, John Stultz wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> This allows detection of init bugs in built-in drivers.
> 
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/sched.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index aa14a56..0b58415 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8104,13 +8104,24 @@ static inline int preempt_count_equals(int preempt_offset)
>  	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
>  }
>  
> +static int __might_sleep_init_called;
> +int __init __might_sleep_init(void)
> +{
> +	__might_sleep_init_called = 1;
> +	return 0;
> +}
> +early_initcall(__might_sleep_init);
> +
>  void __might_sleep(const char *file, int line, int preempt_offset)
>  {
>  #ifdef in_atomic
>  	static unsigned long prev_jiffy;	/* ratelimiting */
>  
>  	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
> -	    system_state != SYSTEM_RUNNING || oops_in_progress)
> +	    oops_in_progress)
> +		return;
> +	if (system_state != SYSTEM_RUNNING &&
> +	    (!__might_sleep_init_called || system_state != SYSTEM_BOOTING))
>  		return;
>  	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
>  		return;

Remind me, why isn't scheduler_running good enough?
