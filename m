Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1ATKuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:50:05 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:59703 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab1ATKuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:50:01 -0500
Date: Thu, 20 Jan 2011 11:49:47 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch rfc] memcg: correctly order reading PCG_USED and
 pc->mem_cgroup
Message-ID: <20110120104947.GK2232@cmpxchg.org>
References: <20110119120319.GA2232@cmpxchg.org>
 <20110120100654.a90d9cc6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120100654.a90d9cc6.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 10:06:54AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 19 Jan 2011 13:03:19 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > The placement of the read-side barrier is confused: the writer first
> > sets pc->mem_cgroup, then PCG_USED.  The read-side barrier has to be
> > between testing PCG_USED and reading pc->mem_cgroup.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/memcontrol.c |   27 +++++++++------------------
> >  1 files changed, 9 insertions(+), 18 deletions(-)
> > 
> > I am a bit dumbfounded as to why this has never had any impact.  I see
> > two scenarios where charging can race with LRU operations:
> > 
> > One is shmem pages on swapoff.  They are on the LRU when charged as
> > page cache, which could race with isolation/putback.  This seems
> > sufficiently rare.
> > 
> > The other case is a swap cache page being charged while somebody else
> > had it isolated.  mem_cgroup_lru_del_before_commit_swapcache() would
> > see the page isolated and skip it.  The commit then has to race with
> > putback, which could see PCG_USED but not pc->mem_cgroup, and crash
> > with a NULL pointer dereference.  This does sound a bit more likely.
> > 
> > Any idea?  Am I missing something?
> > 
> 
> I think troubles happen only when PCG_USED bit was found but pc->mem_cgroup
> is NULL. Hmm.

Correct.  Well, or get linked to the wrong LRU list and subsequently
prevent removal of both cgroups because it's impossible to empty them.

>   set pc->mem_cgroup
>   write_barrier
>   set USED bit.
> 
>   read_barrier
>   check USED bit
>   access pc->mem_cgroup
> 
> So, is there a case which only USED bit can be seen ?

That's what I am not quite sure about.  As said, I think it can happen
when swap cache charging races with reclaim or migration.

When the two loads of the used bit and the memcg pointer get
reordered, it could observe a set PCG_USED and a stale/unset
pc->mem_cgroup.

For example:

swap minor fault:			vmscan:

lookup_swap_cache()
					unlock_page()
lock_page()
mem_cgroup_try_charge_swapin()
					putback_lru_page()
					mem_cgroup_add_lru_list()
					  p = pc->mem_cgroup
  pc->mem_cgroup = FOO
  smp_wmb()
  pc->flags |= PCG_USED
					  f = pc->flags
					  if (!(f & PCG_USED))
						  return
					  *p /* bang */

> Anyway, your patch is right.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you.

	Hannes
