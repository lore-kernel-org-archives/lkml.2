Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2E3AP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:15:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab2E3AP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:15:56 -0400
Date: Wed, 30 May 2012 02:14:38 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 14/35] autonuma: knuma_migrated per NUMA node queues
Message-ID: <20120530001438.GX21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-15-git-send-email-aarcange@redhat.com>
 <1338299468.26856.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338299468.26856.80.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 29, 2012 at 03:51:08PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> 
> 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 41aa49b..8e578e6 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -666,6 +666,12 @@ typedef struct pglist_data {
> >  	struct task_struct *kswapd;
> >  	int kswapd_max_order;
> >  	enum zone_type classzone_idx;
> > +#ifdef CONFIG_AUTONUMA
> > +	spinlock_t autonuma_lock;
> > +	struct list_head autonuma_migrate_head[MAX_NUMNODES];
> > +	unsigned long autonuma_nr_migrate_pages;
> > +	wait_queue_head_t autonuma_knuma_migrated_wait;
> > +#endif
> >  } pg_data_t;
> >  
> >  #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
> 
> O(nr_nodes^2) data.. ISTR people rewriting a certain slab allocator to
> get rid of that :-)
> 
> Also, don't forget that MAX_NUMNODES is an unconditional 512 on distro
> kernels, even when we only have 2.
> 
> Now the total wasted space isn't too bad since its only 16 bytes,
> totaling a whole 2M for a 256 node system. But still, something like
> that wants at least a mention somewhere.

I fully agree, I prefer to fix it and I was fully aware about
this. It's not a big deal so it got low priority to be fixed, but I
intended to optimize this.

As long as num_possible_nodes() is initialized before the pgdat is
allocated it shouldn't be difficult to optimize this moving struct
list_head autonuma_migrate_head[0] at the end of the structure.

mm_autonuma and sched_autonuma initially also had MAX_NUMNODES arrays
in them, then I converted to dynamic allocations to be optimal. We
same needs to happen here. 

Thanks,
Andrea
