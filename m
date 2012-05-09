Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2EILlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:41:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50953 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2EILlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:41:16 -0400
Message-ID: <1336563661.2527.20.camel@twins>
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Jiang Liu <liuj97@gmail.com>
Date: Wed, 09 May 2012 13:41:01 +0200
In-Reply-To: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 12:38 +0200, Igor Mammedov wrote:
> init_sched_groups_power() that expects sched_groups to be
> circular linked list. However it is not always true, since sched_groups
> preallocated in __sdt_alloc are initialized in build_sched_groups and it
> may exit early
> 
>         if (cpu != cpumask_first(sched_domain_span(sd)))
>                 return 0;
> 
> without initializing sd->groups->next field.

The only way I can see that happen is if the arch code is lying to us.
We build the sched_domain_span() like:

  cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));

and the above != first_cpumask() can only happen if the topology mask
provided by the architecture includes a cpu that isn't actually there.

(and equally, how did it get in the active_mask if its not there).

Jiang, how did your IA64 arrive in this state?

> Fix bug by initializing next field right after sched_group was allocated.

I'd not call it a bug, the bug is the arch being broken, its a
robustification of the code to better handle broken input.

Ideally we'd also add a WARN someplace to notify us of this situation.

Still, nice catch..

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  kernel/sched/core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0533a68..e5212ae 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6382,6 +6382,8 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
>                         if (!sg)
>                                 return -ENOMEM;
>  
> +                       sg->next = sg;
> +
>                         *per_cpu_ptr(sdd->sg, j) = sg;
>  
>                         sgp = kzalloc_node(sizeof(struct sched_group_power), 
