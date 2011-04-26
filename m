Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1DZKnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:43:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1DZKnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:43:14 -0400
Subject: Re: [PATCH] cpumask: convert cpumask_of_cpu() with cpumask_of()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110425184245.2699.A69D9226@jp.fujitsu.com>
References: <20110425184245.2699.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 12:42:52 +0200
Message-ID: <1303814572.20212.249.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 18:41 +0900, KOSAKI Motohiro wrote:
> This patch adapt the code to new api fashion. 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/kthread.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 3b34d27..4102518 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -202,7 +202,7 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
>  		return;
>  	}
>  
> -	p->cpus_allowed = cpumask_of_cpu(cpu);
> +	cpumask_copy(&p->cpus_allowed, cpumask_of(cpu));
>  	p->rt.nr_cpus_allowed = 1;
>  	p->flags |= PF_THREAD_BOUND;
>  }

But why? Are we going to get rid of cpumask_t (which is a fixed sized
struct to direct assignment is perfectly fine)?

Also, do we want to convert cpus_allowed to cpumask_var_t? It would save
quite a lot of memory on distro configs that set NR_CPUS silly high.
Currently NR_CPUS=4096 configs allocate 512 bytes per task for this
bitmap, 511 of which will never be used on most machines (510 in the
near future).

The cost if of course an extra memory dereference in scheduler hot
paths.. also not nice.


