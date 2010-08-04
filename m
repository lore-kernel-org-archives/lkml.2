Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0HDDeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:34:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab0HDDeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:34:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Etu0lsb53zHiOkkOVQqhA03iwOdcQ8fAX4G3hOseTJHSJB/EXwooCQUIhAmuM/ioI
	lXbadrmX/Wt3kRkX9G9fw==
Date: Tue, 3 Aug 2010 20:34:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 03/23] slub: Use a constant for a unspecified node.
In-Reply-To: <20100804024525.562559967@linux.com>
Message-ID: <alpine.DEB.2.00.1008032029380.23490@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <20100804024525.562559967@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Christoph Lameter wrote:

> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2010-07-26 12:57:52.000000000 -0500
> +++ linux-2.6/mm/slub.c	2010-07-26 12:57:59.000000000 -0500
> @@ -1073,7 +1073,7 @@ static inline struct page *alloc_slab_pa
>  
>  	flags |= __GFP_NOTRACK;
>  
> -	if (node == -1)
> +	if (node == NUMA_NO_NODE)
>  		return alloc_pages(flags, order);
>  	else
>  		return alloc_pages_exact_node(node, flags, order);
> @@ -1387,7 +1387,7 @@ static struct page *get_any_partial(stru
>  static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
>  {
>  	struct page *page;
> -	int searchnode = (node == -1) ? numa_node_id() : node;
> +	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
>  
>  	page = get_partial_node(get_node(s, searchnode));
>  	if (page || (flags & __GFP_THISNODE) || node != -1)

This has a merge conflict with 2.6.35 since it has this:

	page = get_partial_node(get_node(s, searchnode));
	if (page || (flags & __GFP_THISNODE))
		return page;

	return get_any_partial(s, flags);

so what happened to the dropped check for returning get_any_partial() when 
node != -1?  I added the check for benchmarking.
