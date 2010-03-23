Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0CWRxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:53:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46249 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0CWRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CU2krvVjiqR4C3g2so7409jYDojRZNa+UnI7yqy/wsgodMnRCxf+Zx7XDraPu2KwLY
         0xYNrHS8sdL2aYcEnMNfvemqSL8XvPTtdwoNSIJcqcw1q/hl8yIidjJaHfu7zn0In5xc
         5epyx1rABE0vuebOkLGIu4Md0VceXGjHDhH14=
Subject: Re: [PATCH] sched: prevent compiler from optimising
 sched_avg_update loop
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
References: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 18:53:24 +0100
Message-ID: <1269366804.2983.300.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 mars 2010 à 17:36 +0000, Will Deacon a écrit :
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
>  
>  static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)

Please take a look at __iter_div_u64_rem() , because we had a similar
problem in the past. We want to avoid this div_s64() call.



