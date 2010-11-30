Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0K3TNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:13:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49675 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0K3TNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uzcHtmaB6i50NL/DVtLsqHo9Q/f8/GcyH4OeGAdUXtTO1dQe1CNuZMrUeW4bSpBk2w
         M/m2RUMFSE0wuL/pLblSq2t2kKQNqZcdrQBX68zDqLvpb+cyd/2iPHhCuoxYfDM69D+q
         pgVOHVJr8ukYjmtF1Sg6eVQO8lRvduhIOhv1s=
Subject: Re: [thisops uV3 07/18] highmem: Use this_cpu_xx_return()
 operations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20101130190845.216537525@linux.com>
References: <20101130190707.457099608@linux.com>
	 <20101130190845.216537525@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 20:13:28 +0100
Message-ID: <1291144408.2904.232.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 novembre 2010 à 13:07 -0600, Christoph Lameter a écrit :
> pièce jointe document texte brut (this_cpu_highmem)
> Use this_cpu operations to optimize access primitives for highmem.
> 
> The main effect is the avoidance of address calculations through the
> use of a segment prefix.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  include/linux/highmem.h |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/include/linux/highmem.h
> ===================================================================
> --- linux-2.6.orig/include/linux/highmem.h	2010-11-22 14:43:40.000000000 -0600
> +++ linux-2.6/include/linux/highmem.h	2010-11-22 14:45:02.000000000 -0600
> @@ -81,7 +81,8 @@ DECLARE_PER_CPU(int, __kmap_atomic_idx);
>  
>  static inline int kmap_atomic_idx_push(void)
>  {
> -	int idx = __get_cpu_var(__kmap_atomic_idx)++;
> +	int idx = __this_cpu_inc_return(__kmap_atomic_idx) - 1;
> +
>  #ifdef CONFIG_DEBUG_HIGHMEM
>  	WARN_ON_ONCE(in_irq() && !irqs_disabled());
>  	BUG_ON(idx > KM_TYPE_NR);
> @@ -91,12 +92,12 @@ static inline int kmap_atomic_idx_push(v
>  
>  static inline int kmap_atomic_idx(void)
>  {
> -	return __get_cpu_var(__kmap_atomic_idx) - 1;
> +	return __this_cpu_read(__kmap_atomic_idx) - 1;
>  }
>  
>  static inline int kmap_atomic_idx_pop(void)
>  {
> -	int idx = --__get_cpu_var(__kmap_atomic_idx);
> +	int idx = __this_cpu_dec_return(__kmap_atomic_idx);

__this_cpu_dec_return() is only needed if CONFIG_DEBUG_HIGHMEM

>  #ifdef CONFIG_DEBUG_HIGHMEM
>  	BUG_ON(idx < 0);
>  #endif
> 

You could change kmap_atomic_idx_pop() to return void, and use
__this_cpu_dec(__kmap_atomic_idx)


