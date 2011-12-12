Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1LLNGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:06:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:45972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1LLNGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:06:08 -0500
Message-ID: <1323695116.13285.14.camel@twins>
Subject: Re: [PATCH tip] sched/trivial: Remove cfs bandwidth period check in
 tg_set_cfs_period()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 12 Dec 2011 14:05:16 +0100
In-Reply-To: <20111210135925.GA14593@linux.vnet.ibm.com>
References: <20111210135925.GA14593@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 19:29 +0530, Kamalesh Babulal wrote:
> sched: Remove cfs bandwidth period check in tg_set_cfs_period()
> 
> Remove cfs bandwidth period check from tg_set_cfs_period.
> Invalid bandwidth period's lower/upper limits are denoted
> by min_cfs_quota_period/max_cfs_quota_period repsectively,
> and are checked against valid period in tg_set_cfs_bandwidth().
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> -- 
>  kernel/sched/core.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3c5b21e..57cf3ab 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7689,9 +7689,6 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
>         period = (u64)cfs_period_us * NSEC_PER_USEC;
>         quota = tg->cfs_bandwidth.quota;
>  
> -       if (period <= 0)
> -               return -EINVAL;
> -
>         return tg_set_cfs_bandwidth(tg, period, quota);
>  } 

There's a number of funnies here... it checks an unsigned value for <=
0, which suggests it wanted to check cfs_period_us, which is a signed
value.

tg_set_cfs_bandwidth() has the same problem, at that point everything is
unsigned and all below zero checks will fail.

Please reconsider things and see if this patch is still the right one.
