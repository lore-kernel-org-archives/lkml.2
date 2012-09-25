Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2IYTxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:53:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2IYTxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:53:53 -0400
Date: Tue, 25 Sep 2012 12:53:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ezequiel Garcia <elezegarcia@gmail.com>, Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch slab/next] mm, slob: fix build breakage in
 __kmalloc_node_track_caller
In-Reply-To: <1347137279-17568-4-git-send-email-elezegarcia@gmail.com>
Message-ID: <alpine.DEB.2.00.1209251250520.31518@chino.kir.corp.google.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com> <1347137279-17568-4-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2012, Ezequiel Garcia wrote:

> @@ -454,15 +455,35 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
>  			gfp |= __GFP_COMP;
>  		ret = slob_new_pages(gfp, order, node);
>  
> -		trace_kmalloc_node(_RET_IP_, ret,
> +		trace_kmalloc_node(caller, ret,
>  				   size, PAGE_SIZE << order, gfp, node);
>  	}
>  
>  	kmemleak_alloc(ret, size, 1, gfp);
>  	return ret;
>  }
> +
> +void *__kmalloc_node(size_t size, gfp_t gfp, int node)
> +{
> +	return __do_kmalloc_node(size, gfp, node, _RET_IP_);
> +}
>  EXPORT_SYMBOL(__kmalloc_node);
>  
> +#ifdef CONFIG_TRACING
> +void *__kmalloc_track_caller(size_t size, gfp_t gfp, unsigned long caller)
> +{
> +	return __do_kmalloc_node(size, gfp, NUMA_NO_NODE, caller);
> +}
> +
> +#ifdef CONFIG_NUMA
> +void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
> +					int node, unsigned long caller)
> +{
> +	return __do_kmalloc_node(size, gfp, node, caller);
> +}
> +#endif

This breaks Pekka's slab/next tree with this:

mm/slob.c: In function '__kmalloc_node_track_caller':
mm/slob.c:488: error: 'gfp' undeclared (first use in this function)
mm/slob.c:488: error: (Each undeclared identifier is reported only once
mm/slob.c:488: error: for each function it appears in.)


mm, slob: fix build breakage in __kmalloc_node_track_caller

"mm, slob: Add support for kmalloc_track_caller()" breaks the build 
because gfp is undeclared.  Fix it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slob.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -482,7 +482,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfp, unsigned long caller)
 }
 
 #ifdef CONFIG_NUMA
-void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
+void *__kmalloc_node_track_caller(size_t size, gfp_t gfp,
 					int node, unsigned long caller)
 {
 	return __do_kmalloc_node(size, gfp, node, caller);
