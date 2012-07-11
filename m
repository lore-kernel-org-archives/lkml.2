Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2GKBSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:18:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2GKBSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:18:17 -0400
Date: Tue, 10 Jul 2012 18:18:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/slob: avoid type warning about alignment value
In-Reply-To: <201207102055.35278.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1207101815580.684@chino.kir.corp.google.com>
References: <201207102055.35278.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Arnd Bergmann wrote:

> diff --git a/mm/slob.c b/mm/slob.c
> index 95d1c7d..51d6a27 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -426,7 +426,7 @@ out:
>  void *__kmalloc_node(size_t size, gfp_t gfp, int node)
>  {
>  	unsigned int *m;
> -	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> +	int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
>  	void *ret;
>  
>  	gfp &= gfp_allowed_mask;
> @@ -479,7 +479,7 @@ void kfree(const void *block)
>  
>  	sp = virt_to_page(block);
>  	if (PageSlab(sp)) {
> -		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> +		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
>  		unsigned int *m = (unsigned int *)(block - align);
>  		slob_free(m, *m + align);
>  	} else
> @@ -498,7 +498,7 @@ size_t ksize(const void *block)
>  
>  	sp = virt_to_page(block);
>  	if (PageSlab(sp)) {
> -		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> +		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
>  		unsigned int *m = (unsigned int *)(block - align);
>  		return SLOB_UNITS(*m) * SLOB_UNIT;
>  	} else

Wouldn't it be better to avoid this problem more generally by casting the 
__alignof__ for ARCH_{KMALLOC,SLAB}_MINALIGN to int in slab.h?  All 
architectures that define these themselves will be using plain integers, 
the problem is __alignof__ returning size_t when undefined.
