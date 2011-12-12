Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1LLPuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:50:07 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47647 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750952Ab1LLPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:50:05 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fsCHc1IVM1lebERv_GeRm2NyFnXBT7pcjmX2uFGtor60scu
 dXYYeN6YMNqs5.viAExK2OwbM3WbCk6ZKxy.GfHsZufo0xWLOeDqHK5OGv2B
 87OnZcUqzhDFsKsjX_E2Md9p8ruy5kfclDGUx_KfHA2OlOt_HEEhnk5DyhZk
 NadZiOo5txDMn0jbxBambsyTcXrXAXLYJFyc32se0OZ85rh1anc49YuxWZAO
 ItqdPUAySWqLyMz7r1YV6KEpfYFPRu4rFp96_IlfCVRCpgexx7jPpQ1CqR_q
 vh6mWCJg3mv6yM8pDvdY6B9Ehpnz.HQ3xt7hOWf.G3gNenSIO6fR27377UGq
 OnccLBV.948YFpbTsQ7NXsLs0GO6QGebLiAMrEggoEJcsJg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 12 Dec 2011 09:50:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: zhihua che <zhihua.che@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Slub allocator] There are chances that kmem_cache_cpu->freelist
 gets lost if the process happens to be rescheduled to a differenet cpu before
 the local_irq_save() completes in __slab_alloc()
In-Reply-To: <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1112120922020.28410@router.home>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com> <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Eric Dumazet wrote:

> We miss a deactivate_slab() call or just deliver object if c->freelist
> is not null (and NUMA node matches)
>
> Untested patch :
>
> diff --git a/mm/slub.c b/mm/slub.c
> index ed3334d..923d238 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2166,6 +2166,12 @@ redo:
>  		goto new_slab;
>  	}
>
> +#ifdef CONFIG_PREEMPT
> +	object = c->freelist;
> +	if (object)
> +		goto load_freelist;
> +#endif
> +
>  	stat(s, ALLOC_SLOWPATH);
>
>  	do {

Correct. Issue was introduced in 2.6.39.

Acked-by: Christoph Lameter <cl@linux.com>

