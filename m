Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab1J1EGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 00:06:46 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22485 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751073Ab1J1EGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 00:06:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WxzEPigVM1lfFjFE6.7_ro_B8inHvMgXkJr0sJbL2vYwgK5
 rKwaBNisB8QGBGhB3VZXQEvsECGssB3LOgovW0.U_ADFyQavLPfUQfumEUNY
 h.NLylw81IeklzJCe4i8fxL1oTI.sAvopSiBoEEnqZC0fnEpZ6zkPtkEhEEH
 7HaiWIx1RyKgmwTWumeWthJ_srhazj2PYZKNMO8HLDi6zC8QDrR_Q8e4BAiP
 ZTiCGKfH0npeiOW9h1QSC4tyn3sCLkpxRIMWtGuuCQU7AlUEpjg57CUK4mGF
 o5_9nKXMcZl6zqq.cVbQRrf_Bd7IZfvuh60tBLQep0n80IlxtRUewp311QAY
 Ms0QuoypBTF0QG6p5nY0M9sWD9knFjcclbevMTPjipQCj_dylan23HdJz70M
 xaojHQiQR7spUiWvcS4mmj28-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 27 Oct 2011 23:06:41 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2 5/6] slub: Only IPI CPUs that have per cpu obj to
 flush
In-Reply-To: <1319385413-29665-6-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1110272257040.14619@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com> <1319385413-29665-6-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011, Gilad Ben-Yossef wrote:

> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index f58d641..b130f61 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -102,6 +102,9 @@ struct kmem_cache {
>  	 */
>  	int remote_node_defrag_ratio;
>  #endif
> +
> +	/* Which CPUs hold local slabs for this cache. */
> +	cpumask_var_t cpus_with_slabs;
>  	struct kmem_cache_node *node[MAX_NUMNODES];
>  };

Please do not add fields to structures for passing parameters to
functions. This just increases the complexity of the patch and extends a
structures needlessly.

> diff --git a/mm/slub.c b/mm/slub.c
> index 7c54fe8..f8cbf2d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1948,7 +1948,18 @@ static void flush_cpu_slab(void *d)
>
>  static void flush_all(struct kmem_cache *s)
>  {
> -	on_each_cpu(flush_cpu_slab, s, 1);
> +	struct kmem_cache_cpu *c;
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		c = per_cpu_ptr(s->cpu_slab, cpu);
> +		if (c && c->page)
> +			cpumask_set_cpu(cpu, s->cpus_with_slabs);
> +		else
> +			cpumask_clear_cpu(cpu, s->cpus_with_slabs);
> +	}
> +
> +	on_each_cpu_mask(s->cpus_with_slabs, flush_cpu_slab, s, 1);
>  }


You do not need s->cpus_with_slabs to be in kmem_cache. Make it a local
variable instead.

