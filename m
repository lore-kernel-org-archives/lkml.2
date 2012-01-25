Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2AYOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:53:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:59300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2AYOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:53:15 -0500
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20120116162241.29759.13220.stgit@localhost>
References: <20120116161740.29759.4679.stgit@localhost>
	 <20120116162241.29759.13220.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 15:53:01 +0100
Message-ID: <1327503181.2614.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> +++ b/block/blk.h
> @@ -167,14 +167,15 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
>  static inline int blk_cpu_to_group(int cpu)
>  {
>         int group = NR_CPUS;
> -#ifdef CONFIG_SCHED_MC
> -       const struct cpumask *mask = cpu_coregroup_mask(cpu);
> -       group = cpumask_first(mask);
> -#elif defined(CONFIG_SCHED_SMT)
> -       group = cpumask_first(topology_thread_cpumask(cpu));
> +#ifdef CONFIG_SCHED_POWERSAVE
> +       if (smt_capable())
> +               group = cpumask_first(topology_thread_cpumask(cpu));
> +       else    
> +               group = cpumask_first(cpu_coregroup_mask(cpu));
>  #else
>         return cpu;
>  #endif
> +       /* Possible dead code?? */
>         if (likely(group < NR_CPUS))
>                 return group;
>         return cpu; 

After going, WTF is block doing! I had a closer look and this doesn't
seem right at all. The old code would use coregroup_mask when SCHED_MC
&& SCHED_SMT, the new code does something else.

Jens, what is this thing trying to do?

