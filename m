Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0D1XEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:04:13 -0400
Received: from waste.org ([173.11.57.241]:37902 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab0D1XEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:04:12 -0400
Subject: Re: [PATCH v2] - Randomize node rotor used in
 cpuset_mem_spread_node()
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100428154034.fb823484.akpm@linux-foundation.org>
References: <20100428131158.GA2648@sgi.com> <20100428150432.GA3137@sgi.com>
	 <20100428154034.fb823484.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 18:04:06 -0500
Message-ID: <1272495846.21962.1090.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 15:40 -0700, Andrew Morton wrote:
> On Wed, 28 Apr 2010 10:04:32 -0500
> Jack Steiner <steiner@sgi.com> wrote:
> 
> > Some workloads that create a large number of small files tend to assign
> > too many pages to node 0 (multi-node systems). Part of the reason is that
> > the rotor (in cpuset_mem_spread_node()) used to assign nodes starts
> > at node 0 for newly created tasks.
> 
> And, presumably, your secret testcase forks lots of subprocesses which
> do the file creation?
> 
> > This patch changes the rotor to be initialized to a random node number
> > of the cpuset.
> 
> Why random as opposed to, say, inherit-rotor-from-parent?

That'd be fine, I bet.

> > Index: linux/arch/x86/mm/numa.c
> > ===================================================================
> > --- linux.orig/arch/x86/mm/numa.c	2010-04-28 09:44:52.422898844 -0500
> > +++ linux/arch/x86/mm/numa.c	2010-04-28 09:49:39.282899779 -0500
> > @@ -2,6 +2,7 @@
> >  #include <linux/topology.h>
> >  #include <linux/module.h>
> >  #include <linux/bootmem.h>
> > +#include <linux/random.h>
> >  
> >  #ifdef CONFIG_DEBUG_PER_CPU_MAPS
> >  # define DBG(x...) printk(KERN_DEBUG x)
> > @@ -65,3 +66,19 @@ const struct cpumask *cpumask_of_node(in
> >  }
> >  EXPORT_SYMBOL(cpumask_of_node);
> >  #endif
> > +
> > +/*
> > + * Return the bit number of a random bit set in the nodemask.
> > + *   (returns -1 if nodemask is empty)
> > + */
> > +int __node_random(const nodemask_t *maskp)
> > +{
> > +	int w, bit = -1;
> > +
> > +	w = nodes_weight(*maskp);
> > +	if (w)
> > +		bit = bitmap_find_nth_bit(maskp->bits,
> > +			get_random_int() % w, MAX_NUMNODES);
> > +	return bit;
> > +}
> > +EXPORT_SYMBOL(__node_random);
> 
> I suspect random32() would suffice here.  It avoids depleting the
> entropy pool altogether.

I wouldn't worry about that. get_random_int() touches the urandom pool,
which will always leave entropy around. Also, Ted and I decided over a
year ago that we should drop the whole entropy accounting framework,
which I'll get around to some rainy weekend.

-- 
http://selenic.com : development and support for Mercurial and Linux


