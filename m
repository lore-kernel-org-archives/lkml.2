Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1E0THi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:07:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1E0THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kg9Y0mt5Br7YOAzEDrvVPYaLS4ukwI5q3mv62rxlLrSxbKNmg3bh18ok7W1wZOA4vL
         Uy2naEqY1Q0XSeY+v/GA==
Date: Fri, 27 May 2011 12:07:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] cpusets: randomize node rotor used in
 cpuset_mem_spread_node()
In-Reply-To: <20110527124705.GB4067@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1105271157350.2533@chino.kir.corp.google.com>
References: <20110414065146.GA19685@tiehlicka.suse.cz> <20110414160145.0830.A69D9226@jp.fujitsu.com> <20110415161831.12F8.A69D9226@jp.fujitsu.com> <20110415082051.GB8828@tiehlicka.suse.cz> <20110526153319.b7e8c0b6.akpm@linux-foundation.org>
 <20110527124705.GB4067@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Michal Hocko wrote:

> > alpha allmodconfig:
> > 
> > kernel/built-in.o: In function `cpuset_slab_spread_node':
> > (.text+0x67360): undefined reference to `node_random'
> > kernel/built-in.o: In function `cpuset_slab_spread_node':
> > (.text+0x67368): undefined reference to `node_random'
> > kernel/built-in.o: In function `cpuset_mem_spread_node':
> > (.text+0x673b8): undefined reference to `node_random'
> > kernel/built-in.o: In function `cpuset_mem_spread_node':
> > (.text+0x673c0): undefined reference to `node_random'
> > 
> > because it has CONFIG_NUMA=n, CONFIG_NODES_SHIFT=7.
> 
> non-NUMA with MAX_NUMA_NODES? Hmm, really weird and looks like a numa
> misuse.
> 

CONFIG_NODES_SHIFT is used for UMA machines that are using DISCONTIGMEM 
usually because they have very large holes; such machines don't need 
things like mempolicies but do need the data structures that abstract 
ranges of memory in the physical address space.  This build breakage 
probably isn't restricted to only alpha, you could probably see it with at 
least ia64 and mips as well.

> Define node_random directly in the mempolicy header
> 
> Alpha allows a strange configuration CONFIG_NUMA=n and CONFIG_NODES_SHIFT=7
> which means that mempolicy.c is not compiled and linked while we still have
> MAX_NUMNODES>1 which means that node_random is not defined.
> 

It's not just alpha, and it's not entirely strange.

> Let's move node_random definition into the header. We will be consistent with
> other node_* functions.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Index: linus_tree/include/linux/nodemask.h
> ===================================================================
> --- linus_tree.orig/include/linux/nodemask.h	2011-05-27 14:15:52.000000000 +0200
> +++ linus_tree/include/linux/nodemask.h	2011-05-27 14:36:30.000000000 +0200
> @@ -433,7 +433,21 @@ static inline void node_set_offline(int
>  	nr_online_nodes = num_node_state(N_ONLINE);
>  }
>  
> -extern int node_random(const nodemask_t *maskp);
> +unsigned int get_random_int(void );

Spurious space.

> +/*
> + * Return the bit number of a random bit set in the nodemask.
> + * (returns -1 if nodemask is empty)
> + */
> +static inline int node_random(const nodemask_t *maskp)
> +{
> +	int w, bit = -1;
> +
> +	w = nodes_weight(*maskp);
> +	if (w)
> +		bit = bitmap_ord_to_pos(maskp->bits,
> +			get_random_int() % w, MAX_NUMNODES);
> +	return bit;
> +}
>  
>  #else
>  

Probably should have a no-op definition when MAX_NUMNODES == 1 that just 
returns 0?

> Index: linus_tree/mm/mempolicy.c
> ===================================================================
> --- linus_tree.orig/mm/mempolicy.c	2011-05-27 14:16:05.000000000 +0200
> +++ linus_tree/mm/mempolicy.c	2011-05-27 14:16:34.000000000 +0200
> @@ -1650,21 +1650,6 @@ static inline unsigned interleave_nid(st
>  		return interleave_nodes(pol);
>  }
>  
> -/*
> - * Return the bit number of a random bit set in the nodemask.
> - * (returns -1 if nodemask is empty)
> - */
> -int node_random(const nodemask_t *maskp)
> -{
> -	int w, bit = -1;
> -
> -	w = nodes_weight(*maskp);
> -	if (w)
> -		bit = bitmap_ord_to_pos(maskp->bits,
> -			get_random_int() % w, MAX_NUMNODES);
> -	return bit;
> -}
> -
>  #ifdef CONFIG_HUGETLBFS
>  /*
>   * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
