Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1DNGvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:51:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:58704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab1DNGvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:51:53 -0400
Date: Thu, 14 Apr 2011 08:51:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: cpusets: randomize node rotor used in cpuset_mem_spread_node()
Message-ID: <20110414065146.GA19685@tiehlicka.suse.cz>
References: <20110413143539.GB11051@tiehlicka.suse.cz>
 <20110414111939.0812.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414111939.0812.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-04-11 11:19:24, KOSAKI Motohiro wrote:
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 959a8b8..8e57a72 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -93,6 +93,7 @@
> >  
> >  #include <asm/tlbflush.h>
> >  #include <asm/uaccess.h>
> > +#include <linux/random.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -1649,6 +1650,21 @@ static inline unsigned interleave_nid(struct mempolicy *pol,
> >  		return interleave_nodes(pol);
> >  }
> >  
> > +/*
> > + * Return the bit number of a random bit set in the nodemask.
> > + * (returns -1 if nodemask is empty)
> > + */
> > +int node_random(const nodemask_t *maskp)
> > +{
> > +	int w, bit = -1;
> > +
> > +	w = nodes_weight(*maskp);
> > +	if (w)
> > +		bit = bitmap_ord_to_pos(maskp->bits,
> > +			get_random_int() % w, MAX_NUMNODES);
> > +	return bit;
> > +}
> > +
> >  #ifdef CONFIG_HUGETLBFS
> >  /*
> >   * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
>
> mempolicy.c is no best place for putting generic nodemask utility function.
> but unforunately we have no alternative. Gack.

Agreed. I was thinking about adding a new mm/numa.c but then I concluded
that it would be overkill for the single function.

> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks!
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
