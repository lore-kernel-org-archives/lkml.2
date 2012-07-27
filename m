Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2G0TBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:01:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2G0TBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:01:21 -0400
Date: Fri, 27 Jul 2012 12:01:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [ 39/40] cpuset: mm: reduce large amounts of memory barrier
 related damage v3
Message-ID: <20120727190116.GA29646@kroah.com>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
 <20120726211414.752069185@linuxfoundation.org>
 <20120727150823.GD3033@herton-Z68MA-D2H-B3>
 <20120727152347.GG612@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727152347.GG612@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 04:23:47PM +0100, Mel Gorman wrote:
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -1457,6 +1457,7 @@ static struct page *get_any_partial(stru
> > >  	struct zone *zone;
> > >  	enum zone_type high_zoneidx = gfp_zone(flags);
> > >  	struct page *page;
> > > +	unsigned int cpuset_mems_cookie;
> > >  
> > >  	/*
> > >  	 * The defrag ratio allows a configuration of the tradeoffs between
> > > @@ -1480,22 +1481,32 @@ static struct page *get_any_partial(stru
> > >  			get_cycles() % 1024 > s->remote_node_defrag_ratio)
> > >  		return NULL;
> > >  
> > > -	get_mems_allowed();
> > > -	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
> > > -	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> > > -		struct kmem_cache_node *n;
> > > +	do {
> > > +		cpuset_mems_cookie = get_mems_allowed();
> > > +		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
> > > +		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> > > +			struct kmem_cache_node *n;
> > >  
> > > -		n = get_node(s, zone_to_nid(zone));
> > > +			n = get_node(s, zone_to_nid(zone));
> > >  
> > > -		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
> > > -				n->nr_partial > s->min_partial) {
> > > -			page = get_partial_node(n);
> > > -			if (page) {
> > > -				put_mems_allowed();
> > > -				return page;
> > > +			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
> > > +					n->nr_partial > s->min_partial) {
> > > +				page = get_partial_node(n);
> > > +				if (page) {
> > > +					/*
> > > +					 * Return the object even if
> > > +					 * put_mems_allowed indicated that
> > > +					 * the cpuset mems_allowed was
> > > +					 * updated in parallel. It's a
> > > +					 * harmless race between the alloc
> > > +					 * and the cpuset update.
> > > +					 */
> > > +					put_mems_allowed(cpuset_mems_cookie);
> > > +					return page;
> > > +				}
> > >  			}
> > >  		}
> > > -	}
> > > +	} while (!put_mems_allowed(cpuset_mems_cookie));
> > >  	put_mems_allowed();
> > 
> > This doesn't build on 3.0, the backport left the stray put_mems_allowed
> > above:
> > 
> > linux-stable/mm/slub.c: In function 'get_any_partial':
> > linux-stable/mm/slub.c:1510:2: error: too few arguments to function 'put_mems_allowed'
> > linux-stable/include/linux/cpuset.h:108:20: note: declared here
> > 
> 
> That line should have been deleted and tests were based on slab. My
> apologies.
> 
> ---8<---
> cpuset: mm: Reduce large amounts of memory barrier related damage fix
> 
> linux-stable/mm/slub.c: In function 'get_any_partial':
> linux-stable/mm/slub.c:1510:2: error: too few arguments to function 'put_mems_allowed'
> linux-stable/include/linux/cpuset.h:108:20: note: declared here
> 
> Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 00ccf2c..ae6e80e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1507,7 +1507,6 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
>  			}
>  		}
>  	} while (!put_mems_allowed(cpuset_mems_cookie));
> -	put_mems_allowed();
>  #endif
>  	return NULL;
>  }

Thanks, I've merged this with the "original" in the tree, so all should
be good now.

greg k-h
