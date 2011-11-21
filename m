Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1KUXrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:47:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1KUXrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:47:05 -0500
Date: Tue, 22 Nov 2011 00:46:59 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: charge leaked page dirties to active
 tasks
Message-ID: <20111121234659.GF4017@quack.suse.cz>
References: <20111121130342.211953629@intel.com>
 <20111121131215.772231181@intel.com>
 <20111121134929.b7008f6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121134929.b7008f6e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-11-11 13:49:29, Andrew Morton wrote:
> On Mon, 21 Nov 2011 21:03:44 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > It's a years long problem that a large number of short-lived dirtiers
> > (eg. gcc instances in a fast kernel build) may starve long-run dirtiers
> > (eg. dd) as well as pushing the dirty pages to the global hard limit.
> > 
> > The solution is to charge the pages dirtied by the exited gcc to the
> > other random dirtying tasks. It sounds not perfect, however should
> > behave good enough in practice, seeing as that throttled tasks aren't
> > actually running so those that are running are more likely to pick it up
> > and get throttled, therefore promoting an equal spread.
> > 
> > --- linux-next.orig/mm/page-writeback.c	2011-11-17 20:57:04.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2011-11-17 20:57:13.000000000 +0800
> > @@ -1194,6 +1194,7 @@ void set_page_dirty_balance(struct page 
> >  }
> >  
> >  static DEFINE_PER_CPU(int, bdp_ratelimits);
> > +DEFINE_PER_CPU(int, dirty_leaks) = 0;
> 
> This is a poor identifier for a global symbol.  Generally such symbols
> should at least identify what subsystem they belong to.
> 
> Also, this would be a good site at whcih to document the global
> symbol's role.  The writeback code needs a lot of documentation. Of
> the design-level kind.
> 
> >  /**
> >   * balance_dirty_pages_ratelimited_nr - balance dirty memory state
> > @@ -1242,6 +1243,17 @@ void balance_dirty_pages_ratelimited_nr(
> >  			ratelimit = 0;
> >  		}
> >  	}
> > +	/*
> > +	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
> > +	 * short-lived tasks (eg. gcc invocations in a kernel build) escaping
> > +	 * the dirty throttling and livelock other long-run dirtiers.
> > +	 */
> > +	p = &__get_cpu_var(dirty_leaks);
> > +	if (*p > 0 && current->nr_dirtied < ratelimit) {
> > +		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
> > +		*p -= nr_pages_dirtied;
> > +		current->nr_dirtied += nr_pages_dirtied;
> > +	}
> >  	preempt_enable();
> >  
> >  	if (unlikely(current->nr_dirtied >= ratelimit))
> > --- linux-next.orig/kernel/exit.c	2011-11-17 20:57:02.000000000 +0800
> > +++ linux-next/kernel/exit.c	2011-11-17 20:57:04.000000000 +0800
> > @@ -1037,6 +1037,8 @@ NORET_TYPE void do_exit(long code)
> >  	validate_creds_for_do_exit(tsk);
> >  
> >  	preempt_disable();
> > +	if (tsk->nr_dirtied)
> > +		__this_cpu_add(dirty_leaks, tsk->nr_dirtied);
> 
> Whatever problem this code is solving, it only solved it in certain
> cases.  For example, if tasks are forking, dirtying and exiting at a
> rapid rate on CPU 0 then all the other CPUs don't know anything about
> this and we didn't fix anything.
  I think it will work - dirty_leaks at CPU0 will get leaked pages from the
first task when it dies, the second task will pick them up and as soon as
it dies it puts all the pages back to dirty_leaks at CPU0. This goes on and
on and eventually, dirty_leaks will accumulate enough pages so that a task
dirtying even a single page will enter balance_dirty_pages() as if it
dirtied 'ratelimit' pages.
 
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
