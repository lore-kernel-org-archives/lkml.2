Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2EYOt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:49:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:34739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2EYOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:49:25 -0400
Subject: Re: [PATCH] sched: unthrottle rt_rq in migrate_tasks()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F379AD507F2@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379AD507F2@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 16:49:21 +0200
Message-ID: <1337957361.9783.213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 11:56 -0700, Peter Boonstoppel wrote:
> migrate_tasks() uses _pick_next_task_rt() to get tasks from the
> real-time runqueue to be migrated. When rt_rq is throttled
> _pick_next_task_rt() won't return anything, in which case
> migrate_tasks() can't move all threads over and gets stuck in an
> infinite loop.
> 
> Instead unthrottle rt_rq before migrating tasks.
> 
> Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
> ---
>  kernel/sched/core.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9236a48..b37e0b3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5159,6 +5159,12 @@ static void migrate_tasks(unsigned int dead_cpu)
>  	/* Ensure any throttled groups are reachable by pick_next_task */
>  	unthrottle_offline_cfs_rqs(rq);
>  
> +	/*
> +	 * Ensure rt_rq is not throttled so its threads can be migrated using
> +	 * pick_next_task_rt
> +	 */
> +	rq->rt.rt_throttled = 0;
> +
>  	for ( ; ; ) {
>  		/*
>  		 * There's this thread running, bail when that's the only

OK, so there's two things:

 - there's a set_rq_offline() call in CPU_DYING right before calling
migrate_tasks(). This would end up calling rq_offline_rt() which should
disable all the runtime muck.

 - If the above doesn't unthrottle rqs (looks like it doesn't, should
it?) you still only unthrottle the root and 'forgot' to deal with
cgroups.

So I think I'm going to ask you to make rq_offline_rt() dtrt, and while
you're at it, move unthrottle_offline_cfs_rqs() to rq_offline_fair().

