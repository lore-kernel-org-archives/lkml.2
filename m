Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422963Ab2KNN7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:59:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2KNN7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:59:34 -0500
Date: Wed, 14 Nov 2012 14:59:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list error
 handling
Message-ID: <20121114135930.GE4929@dhcp22.suse.cz>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <1351251453-6140-4-git-send-email-mhocko@suse.cz>
 <508E8B95.406@parallels.com>
 <20121029150022.a595b866.akpm@linux-foundation.org>
 <20121030103559.GA7394@dhcp22.suse.cz>
 <20121113211041.GB1543@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113211041.GB1543@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-11-12 16:10:41, Johannes Weiner wrote:
> On Tue, Oct 30, 2012 at 11:35:59AM +0100, Michal Hocko wrote:
> > On Mon 29-10-12 15:00:22, Andrew Morton wrote:
> > > On Mon, 29 Oct 2012 17:58:45 +0400
> > > Glauber Costa <glommer@parallels.com> wrote:
> > > 
> > > > > + * move charges to its parent or the root cgroup if the group has no
> > > > > + * parent (aka use_hierarchy==0).
> > > > > + * Although this might fail (get_page_unless_zero, isolate_lru_page or
> > > > > + * mem_cgroup_move_account fails) the failure is always temporary and
> > > > > + * it signals a race with a page removal/uncharge or migration. In the
> > > > > + * first case the page is on the way out and it will vanish from the LRU
> > > > > + * on the next attempt and the call should be retried later.
> > > > > + * Isolation from the LRU fails only if page has been isolated from
> > > > > + * the LRU since we looked at it and that usually means either global
> > > > > + * reclaim or migration going on. The page will either get back to the
> > > > > + * LRU or vanish.
> > > > 
> > > > I just wonder for how long can it go in the worst case?
> > > 
> > > If the kernel is uniprocessor and the caller is SCHED_FIFO: ad infinitum!
> > 
> > You are right, if the rmdir (resp. echo > force_empty) at SCHED_FIFO
> > races with put_page (on a shared page) which gets preempted after
> > put_page_testzero and before __page_cache_release then we are screwed:
> > 
> > 						put_page(page)
> > 						  put_page_testzero
> > 						  <preempted and page still on LRU>
> > mem_cgroup_force_empty_list
> >   page = list_entry(list->prev, struct page, lru);
> >   mem_cgroup_move_parent(page)
> >     get_page_unless_zero <fails>
> >   cond_resched() <scheduled again>
> > 
> > The race window is really small but it is definitely possible. I am not
> > happy about this state and it should be probably mentioned in the
> > patch description but I do not see any way around (except for hacks like
> > sched_setscheduler for the current which is, ehm...) and still keep
> > do_not_fail contract here.
> > 
> > Can we consider this as a corner case (it is much easier to kill a
> > machine with SCHED_FIFO than this anyway) or the concern is really
> > strong and we should come with a solution before this can get merged?
> 
> Wouldn't the much bigger race window be reclaim having the page
> isolated and SCHED_FIFO preventing it from putback?

We wouldn't see the page on the LRU then, right?

> I also don't think this is a new class of problem, though.
> 
> Would it make sense to stick a wait_on_page_locked() in there just so
> that we don't busy spin on a page under migration/reclaim?

Hmm, this would also mean that get_page_unless_zero would fail as well
and so we would schedule in mem_cgroup_force_empty_list. It is true that
there might be no other runnable task so we can busy loop so yes this
would help. Care to cook the patch?

Thanks
-- 
Michal Hocko
SUSE Labs
