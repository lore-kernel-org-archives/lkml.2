Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab0FJOoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:44:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0FJOoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:44:07 -0400
Subject: Re: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer
 with offstack cpumasks
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100610111046.18EB4B1A2B@basil.firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
	 <20100610111046.18EB4B1A2B@basil.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 16:43:50 +0200
Message-ID: <1276181030.2077.399.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 13:10 +0200, Andi Kleen wrote:
> This will save a few bytes in the non offstack cpumask case.
> 
> Found by gcc 4.6's new warnings.
> 
> Cc: peterz@infradead.org
> Cc: mingo@elte.hu
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  kernel/sched.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.35-rc2-gcc/kernel/sched.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/kernel/sched.c
> +++ linux-2.6.35-rc2-gcc/kernel/sched.c
> @@ -7482,7 +7482,7 @@ static void init_tg_rt_entry(struct task
>  void __init sched_init(void)
>  {
>  	int i, j;
> -	unsigned long alloc_size = 0, ptr;
> +	unsigned long alloc_size = 0;
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
> @@ -7494,7 +7494,10 @@ void __init sched_init(void)
>  	alloc_size += num_possible_cpus() * cpumask_size();
>  #endif
>  	if (alloc_size) {
> +#ifdef CONFIG_CPUMASK_OFFSTACK
> +		unsigned long ptr;
>  		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
> +#endif
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  		init_task_group.se = (struct sched_entity **)ptr;

This patch will actually break things.. please read the code.

I guess we could move the unsigned long into that block, but I really
don't see the point.
