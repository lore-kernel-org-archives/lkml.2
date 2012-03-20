Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab2CTOOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:14:50 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:41480 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758036Ab2CTOOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:14:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Gl_oitEVM1nvYmh8o9RCbpDvszopNl.Xt48C13cDKIsOlex
 9Xnobnb6ipA1m1C6zJ8iYyMr.9qB9jDDKKqXCDK31Lx4EaNM0B3Oee4SZtDb
 VecaFNciC5kN6Rd6FB3sGgmhTAabbZ0KRa3A.DfJB9K2vYaRccI3fMn5E7ud
 .43uN30ABPNJZamJMeiKEr12WL.0bv9tgVnlj4Y4tkHuUcx0UOC6nmW.WVu2
 6jMedOS5kQxSwbJtCWz8d2dcOR__RgnoE28kPpnh.Cg1585ntmf1p0ADnYh.
 ro6FYzXxAQtmvkQoRG.PTKwalMjq_czAIC9kfPa9qsWEuuC1QOvLrnMxf9u5
 G1HtgVPIo4.P34TN3RPlQxDVnIkU0z_wJvTmTjqJTpxgyy0Y8.501K0ZpJRp
 i
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Mar 2012 09:14:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/6] slub: add kmalloc_align()
In-Reply-To: <1332238884-6237-3-git-send-email-laijs@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1203200910030.19333@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012, Lai Jiangshan wrote:

> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index a32bcfd..67ac6b4 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -280,6 +280,12 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
>  	return __kmalloc(size, flags);
>  }
>
> +static __always_inline
> +void *kmalloc_align(size_t size, gfp_t flags, size_t align)
> +{
> +	return kmalloc(ALIGN(size, align), flags);
> +}

This assumes that kmalloc allocates aligned memory. Which it does only
in special cases (power of two cache and debugging off).

>  #ifdef CONFIG_NUMA
>  void *__kmalloc_node(size_t size, gfp_t flags, int node);
>  void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
> diff --git a/mm/slub.c b/mm/slub.c
> index 4907563..01cf99d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3238,7 +3238,7 @@ static struct kmem_cache *__init create_kmalloc_cache(const char *name,
>  	 * This function is called with IRQs disabled during early-boot on
>  	 * single CPU so there's no need to take slub_lock here.
>  	 */
> -	if (!kmem_cache_open(s, name, size, ARCH_KMALLOC_MINALIGN,
> +	if (!kmem_cache_open(s, name, size, ALIGN_OF_LAST_BIT(size),
>  								flags, NULL))
>  		goto panic;

Why does the alignment of struct kmem_cache change? I'd rather have a
__alignof__(struct kmem_cache) here with alignment specified with the
struct definition.

