Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1GMWcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:32:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab1GMWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:32:04 -0400
Date: Wed, 13 Jul 2011 15:31:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/4] sparc64: Kill page table quicklists.
Message-Id: <20110713153152.269b893c.akpm@linux-foundation.org>
In-Reply-To: <20110712122911.555480541@chello.nl>
References: <20110712122608.938583937@chello.nl>
	<20110712122911.555480541@chello.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 14:26:09 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> --- linux-2.6.orig/arch/sparc/mm/tsb.c
> +++ linux-2.6/arch/sparc/mm/tsb.c
> @@ -236,6 +236,8 @@ static void setup_tsb_params(struct mm_s
>  	}
>  }
>  
> +struct kmem_cache *pgtable_cache __read_mostly;
> +
>  static struct kmem_cache *tsb_caches[8] __read_mostly;
>  
>  static const char *tsb_cache_names[8] = {
> @@ -253,6 +255,15 @@ void __init pgtable_cache_init(void)
>  {
>  	unsigned long i;
>  
> +	pgtable_cache = kmem_cache_create("pgtable_cache",
> +					  PAGE_SIZE, PAGE_SIZE,
> +					  0,
> +					  _clear_page);

The use of slab constructors is often dubious from a cache usage POV. 
But the lifecycle of a page-table page might well be that it slowly
gets non-zeroes written into it and then slowly gets zeroes written
into it until it is all-zeroes and then we free it up.  And often only
a subset of the page will ever be written.

So it could be that the slab constructor behaviour is a good match
here.  And not just for sparc!

Did such thinking and/or any testing go into this decision?


> +	if (!pgtable_cache) {
> +		prom_printf("pgtable_cache_init(): Could not create!\n");
> +		prom_halt();
> +	}
> +
