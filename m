Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2L0WZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:25:19 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36349 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0WZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:25:14 -0500
Date: Thu, 27 Dec 2012 14:25:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even
 if slab is available
In-Reply-To: <1356293711-23864-2-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <1356293711-23864-2-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2012, Sasha Levin wrote:

> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 1324cd7..198a92f 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -763,9 +763,6 @@ void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>  void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>  				   unsigned long align, unsigned long goal)
>  {
> -	if (WARN_ON_ONCE(slab_is_available()))
> -		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> -
>  	return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
>  }
>  

All you're doing is removing the fallback if this happens to be called 
with slab_is_available().  It's still possible that the slab allocator can 
successfully allocate the memory, though.  So it would be rather 
unfortunate to start panicking in a situation that used to only emit a 
warning.

Why can't you panic only kzalloc_node() returns NULL and otherwise just 
return the allocated memory?
