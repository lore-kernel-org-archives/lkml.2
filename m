Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab0DHTMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:12:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab0DHTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:12:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=edEqGo6aKrbeWJ44cx8HptYGu+V6YGYMgGxAN9xUIrRTbc5tEKDp8EXpmb1wR+nKa
	4Wt/WT13GWvM12QF8SfSg==
Date: Thu, 8 Apr 2010 12:12:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] slab: fix caller tracking on !CONFIG_DEBUG_SLAB &&
 CONFIG_TRACING
In-Reply-To: <1270721493-27820-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.DEB.2.00.1004081209380.21040@chino.kir.corp.google.com>
References: <1270721493-27820-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010, Xiaotian Feng wrote:

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 4884462..1a0625c 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -267,7 +267,7 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
>   * allocator where we care about the real place the memory allocation
>   * request comes from.
>   */
> -#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
> +#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || defined(CONFIG_TRACING)
>  extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
>  #define kmalloc_track_caller(size, flags) \
>  	__kmalloc_track_caller(size, flags, _RET_IP_)
> @@ -285,7 +285,7 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
>   * standard allocator where we care about the real place the memory
>   * allocation request comes from.
>   */
> -#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
> +#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || defined(CONFIG_TRACING)
>  extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
>  #define kmalloc_node_track_caller(size, flags, node) \
>  	__kmalloc_node_track_caller(size, flags, node, \

This doesn't work if the underlying slab allocator doesn't define 
__kmalloc_node_track_caller() regardless of whether CONFIG_TRACING is 
enabled or not.  SLOB, for example, never defines it, and that's why the 
conditional exists in the way it currently does.

This is your patch with CONFIG_EMBEDDED && CONFIG_SLOB:

mm/built-in.o: In function `__krealloc':
(.text+0x1283c): undefined reference to `__kmalloc_track_caller'
mm/built-in.o: In function `kmemdup':
(.text+0x128b4): undefined reference to `__kmalloc_track_caller'
mm/built-in.o: In function `kstrndup':
(.text+0x128fc): undefined reference to `__kmalloc_track_caller'
mm/built-in.o: In function `kstrdup':
(.text+0x12943): undefined reference to `__kmalloc_track_caller'
mm/built-in.o: In function `memdup_user':
(.text+0x129f7): undefined reference to `__kmalloc_track_caller'
drivers/built-in.o:(.text+0xc48a4): more undefined references to `__kmalloc_track_caller' follow
net/built-in.o: In function `__alloc_skb':
(.text+0x8dc6): undefined reference to `__kmalloc_node_track_caller'
