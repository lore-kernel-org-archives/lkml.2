Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab0CPOMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0CPOMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:12:45 -0400
Date: Tue, 16 Mar 2010 10:11:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 4/5] memcg: dirty pages accounting and limiting
	infrastructure
Message-ID: <20100316141150.GC9144@redhat.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com> <1268609202-15581-5-git-send-email-arighi@develer.com> <20100316113238.f7d74848.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316113238.f7d74848.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 11:32:38AM +0900, Daisuke Nishimura wrote:

[..]
> > + * mem_cgroup_page_stat() - get memory cgroup file cache statistics
> > + * @item:	memory statistic item exported to the kernel
> > + *
> > + * Return the accounted statistic value, or a negative value in case of error.
> > + */
> > +s64 mem_cgroup_page_stat(enum mem_cgroup_read_page_stat_item item)
> > +{
> > +	struct mem_cgroup_page_stat stat = {};
> > +	struct mem_cgroup *mem;
> > +
> > +	rcu_read_lock();
> > +	mem = mem_cgroup_from_task(current);
> > +	if (mem && !mem_cgroup_is_root(mem)) {
> > +		/*
> > +		 * If we're looking for dirtyable pages we need to evaluate
> > +		 * free pages depending on the limit and usage of the parents
> > +		 * first of all.
> > +		 */
> > +		if (item == MEMCG_NR_DIRTYABLE_PAGES)
> > +			stat.value = memcg_get_hierarchical_free_pages(mem);
> > +		/*
> > +		 * Recursively evaluate page statistics against all cgroup
> > +		 * under hierarchy tree
> > +		 */
> > +		stat.item = item;
> > +		mem_cgroup_walk_tree(mem, &stat, mem_cgroup_page_stat_cb);
> > +	} else
> > +		stat.value = -EINVAL;
> > +	rcu_read_unlock();
> > +
> > +	return stat.value;
> > +}
> > +
> hmm, mem_cgroup_page_stat() can return negative value, but you place BUG_ON()
> in [5/5] to check it returns negative value. What happens if the current is moved
> to root between mem_cgroup_has_dirty_limit() and mem_cgroup_page_stat() ?
> How about making mem_cgroup_has_dirty_limit() return the target mem_cgroup, and
> passing the mem_cgroup to mem_cgroup_page_stat() ?
> 

Hmm, if mem_cgroup_has_dirty_limit() retrun pointer to memcg, then one
shall have to use rcu_read_lock() and that will look ugly.

Why don't we simply look at the return value and if it is negative, we
fall back to using global stats and get rid of BUG_ON()?

Or, modify mem_cgroup_page_stat() to return global stats if it can't
determine per cgroup stat for some reason. (mem=NULL or root cgroup etc).

Vivek
