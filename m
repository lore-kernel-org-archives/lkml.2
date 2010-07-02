Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab0GBMyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:54:53 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:37479 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0GBMyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:54:52 -0400
Date: Fri, 2 Jul 2010 14:56:28 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] Fixed division by zero bug in kernel/padata.c
Message-ID: <20100702125628.GK10072@secunet.com>
References: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jul 2010 12:54:50.0108 (UTC) FILETIME=[C1E003C0:01CB19E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 03:59:54PM +0400, Dan Kruchinin wrote:
>  When boot CPU(typically CPU #0) is excluded from padata cpumask and
>  user enters halt command from console, kernel faults on division by zero;
>  This occurs because during the halt kernel shuts down each non-boot CPU one
>  by one and after it shuts down the last CPU that is set in the padata cpumask,
>  the only working CPU in the system is a boot CPU(#0) and it's the only CPU that
>  is set in the cpu_active_mask. Hence when padata_cpu_callback calls
>  __padata_remove_cpu(which calls padata_alloc_pd) it appears that
> padata cpumask and
>  cpu_active_mask aren't intersect. Hence the following code in
> padata_alloc_pd causes
>  a DZ error exception:
>   cpumask_and(pd->cpumask, cpumask, cpu_active_mask); // pd->cpumask
> will be empty
>   ...
>   num_cpus = cpumask_weight(pd->cpumask); // num_cpus = 0
>   pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1; // DZ!
> 

Good catch!

> 
> Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
> ---
>  kernel/padata.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index fdd8ae6..dbe6d26 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -434,7 +434,7 @@ static struct parallel_data
> *padata_alloc_pd(struct padata_instance *pinst,
>  		atomic_set(&queue->num_obj, 0);
>  	}
> 
> -	num_cpus = cpumask_weight(pd->cpumask);
> +	num_cpus = cpumask_weight(pd->cpumask) + 1;
>  	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
> 

num_cpus should stay the number of cpus in this cpumask, this is required
to handle a smooth overrun of the sequence numbers. 
I think it's better to return with an error and to stop the instance
if somebody takes away the last cpu in our cpumask. We can't run with an 
empty cpumask anyway.

Let us look again at this on monday.

Thanks again for catching this,

Steffen
