Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab0DVVUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:20:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab0DVVUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:20:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QSINF2fqB0Eu+avkhq+99TB+xNhsu1yHVTVrdEkdxZzUO5c4UZCgdPuJ7m3UICFHO
	HQfDkukVYYqCnoPj1Wjzg==
Date: Thu, 22 Apr 2010 14:20:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Lee Schermerhorn <lee.schermerhorn@hp.com>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: fix bugs of mpol_rebind_nodemask()
In-Reply-To: <4BD05929.8040900@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1004221415090.25350@chino.kir.corp.google.com>
References: <4BD05929.8040900@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, Miao Xie wrote:

> - local variable might be an empty nodemask, so must be checked before setting
>   pol->v.nodes to it.
> 
> - nodes_remap() may cause the weight of pol->v.nodes being monotonic decreasing.
>   and never become large even we pass a nodemask with large weight after
>   ->v.nodes become little.
> 

That's always been the intention of rebinding a mempolicy nodemask: we 
remap the current mempolicy nodes over the new nodemask given the set of 
allowed nodes.  The nodes_remap() shouldn't be removed.

> this patch fixes these two problem.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  mm/mempolicy.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 08f40a2..03ba9fc 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -291,12 +291,15 @@ static void mpol_rebind_nodemask(struct mempolicy *pol,
>  	else if (pol->flags & MPOL_F_RELATIVE_NODES)
>  		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
>  	else {
> -		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
> -			    *nodes);
> +		tmp = *nodes;
>  		pol->w.cpuset_mems_allowed = *nodes;
>  	}
>  
> -	pol->v.nodes = tmp;
> +	if (nodes_empty(tmp))
> +		pol->v.nodes = *nodes;
> +	else
> +		pol->v.nodes = tmp;
> +
>  	if (!node_isset(current->il_next, tmp)) {
>  		current->il_next = next_node(current->il_next, tmp);
>  		if (current->il_next >= MAX_NUMNODES)
