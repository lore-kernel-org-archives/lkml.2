Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0LHDDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 22:03:22 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:27491 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0LHDDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 22:03:21 -0500
Subject: Re: [06/44] numa: fix slab_node(MPOL_BIND)
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <20101208000640.115606851@clark.site>
References: <20101208000640.115606851@clark.site>
Content-Type: text/plain; charset="UTF-8"
Organization: HP/LKTT
Date: Tue, 07 Dec 2010 22:03:15 -0500
Message-ID: <1291777395.26147.69.camel@zaphod>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 16:04 -0800, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Eric Dumazet <eric.dumazet@gmail.com>
> 
> commit 800416f799e0723635ac2d720ad4449917a1481c upstream.
> 
> When a node contains only HighMem memory, slab_node(MPOL_BIND)
> dereferences a NULL pointer.
> 
> [ This code seems to go back all the way to commit 19770b32609b: "mm:
>   filter based on a nodemask as well as a gfp_mask".  Which was back in
>   April 2008, and it got merged into 2.6.26.  - Linus ]
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  mm/mempolicy.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1404,7 +1404,7 @@ unsigned slab_node(struct mempolicy *pol
>  		(void)first_zones_zonelist(zonelist, highest_zoneidx,
>  							&policy->v.nodes,
>  							&zone);
> -		return zone->node;
> +		return zone ? zone->node : numa_node_id();

I think this should be numa_mem_id().  Given the documented purpose of
slab_node(), we want a node from which page allocation is likely to
succeed.  numa_node_id() can return a memoryless node for, e.g.,  some
configurations of some HP ia64 platforms.  numa_mem_id() was introduced
to return that same node from which "local" mempolicy would allocate
pages.

Lee

>  	}
>  
>  	default:
> 
> 



