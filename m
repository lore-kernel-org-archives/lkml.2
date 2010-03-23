Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0CWSI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:08:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0CWSIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:08:25 -0400
Subject: Re: [PATCH] sched: prevent compiler from optimising
 sched_avg_update loop
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
References: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 19:08:02 +0100
Message-ID: <1269367682.5109.155.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 17:36 +0000, Will Deacon wrote:
> GCC 4.4.1 on ARM has been observed to replace the while loop
> in sched_avg_update with a call to uldivmod, resulting in the
> following build failure at link-time:
> 
> kernel/built-in.o: In function `sched_avg_update':
> /linux-2.6/kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
> /linux-2.6/kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
> make: *** [.tmp_vmlinux1] Error 1
> 
> This patch [taken against 2.6.34-rc2] replaces the loop with a call to
> div_s64 which allows the Kernel to link.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  kernel/sched.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9ab3cd7..6b74f21 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1238,11 +1238,10 @@ static u64 sched_avg_period(void)
>  static void sched_avg_update(struct rq *rq)
>  {
>  	s64 period = sched_avg_period();
> +	s64 elapsed_periods = div_s64(rq->clock - rq->age_stamp - 1, period);
>  
> -	while ((s64)(rq->clock - rq->age_stamp) > period) {
> -		rq->age_stamp += period;
> -		rq->rt_avg /= 2;
> -	}
> +	rq->age_stamp += (u64)(elapsed_periods * period);
> +	rq->rt_avg >>= elapsed_periods;
>  }

Hmm, and that does an unconditional division, thing is, I don't expect
(under normal circumstances) for that loop to go round more than once so
that division will hurt for no reason.

Should we maybe write it like so:

  if ((s64)(rq->clock - rq->age_stamp) > period) {
    rq->age_stamp += period;
    rq->rt_avg >>= 1;
  }
  if (unlikely((s64)(rq->clock - rq->age_stamp) > period)) {
    s64 overflows = div_s64(rq->clocks - rq->age_stamp, period);
    int width = sizeof(rq->rt_avg) * 8;

    rq->age_stamp += overflows * period;
    if (unlikely(overflows >= width))
      rq->rt_avg = 0;
    else
      rq->rt_avg >>= overflows;
  }

?
    
