Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab0DHTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:03:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab0DHTDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:03:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nhCiLsJXYbDo3HSQZsuRc764rTtFpf1DFINAzRgOcCoj31Qx4TW8YQ7oH/INEUhi2
	x9TFM0BLq+4x3qfk823yA==
Date: Thu, 8 Apr 2010 12:03:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] slub: __kmalloc_node_track_caller should trace
 kmalloc_large_node case
In-Reply-To: <1270718804-27268-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.DEB.2.00.1004081202570.21040@chino.kir.corp.google.com>
References: <1270718804-27268-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010, Xiaotian Feng wrote:

> commit 94b528d (kmemtrace: SLUB hooks for caller-tracking functions)
> missed tracing kmalloc_large_node in __kmalloc_node_track_caller. We
> should trace it same as __kmalloc_node.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  mm/slub.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b364844..a3a5a18 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3335,8 +3335,15 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
>  	struct kmem_cache *s;
>  	void *ret;
>  
> -	if (unlikely(size > SLUB_MAX_SIZE))
> -		return kmalloc_large_node(size, gfpflags, node);
> +	if (unlikely(size > SLUB_MAX_SIZE)) {
> +		ret = kmalloc_large_node(size, gfpflags, node);
> +
> +		trace_kmalloc_node(caller, ret,
> +				   size, PAGE_SIZE << get_order(size),
> +				   gfpflags, node);
> +
> +		return ret;
> +	}
>  
>  	s = get_slab(size, gfpflags);
>  
