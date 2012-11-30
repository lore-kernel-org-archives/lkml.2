Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2K3Id7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:33:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2K3Id5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:33:57 -0500
Date: Fri, 30 Nov 2012 09:33:53 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, paul@paulmenage.org,
        glommer@parallels.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, peterz@infradead.org, bsingharora@gmail.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121130083353.GC29317@dhcp22.suse.cz>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <50B8263C.7060908@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B8263C.7060908@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 12:21:32, KAMEZAWA Hiroyuki wrote:
> (2012/11/29 6:34), Tejun Heo wrote:
> > Hello, guys.
> > 
> > Depending on cgroup core locking - cgroup_mutex - is messy and makes
> > cgroup prone to locking dependency problems.  The current code already
> > has lock dependency loop - memcg nests get_online_cpus() inside
> > cgroup_mutex.  cpuset the other way around.
> > 
> > Regardless of the locking details, whatever is protecting cgroup has
> > inherently to be something outer to most other locking constructs.
> > cgroup calls into a lot of major subsystems which in turn have to
> > perform subsystem-specific locking.  Trying to nest cgroup
> > synchronization inside other locks isn't something which can work
> > well.
> > 
> > cgroup now has enough API to allow subsystems to implement their own
> > locking and cgroup_mutex is scheduled to be made private to cgroup
> > core.  This patchset makes cpuset implement its own locking instead of
> > relying on cgroup_mutex.
> > 
> > cpuset is rather nasty in this respect.  Some of it seems to have come
> > from the implementation history - cgroup core grew out of cpuset - but
> > big part stems from cpuset's need to migrate tasks to an ancestor
> > cgroup when an hotunplug event makes a cpuset empty (w/o any cpu or
> > memory).
> > 
> > This patchset decouples cpuset locking from cgroup_mutex.  After the
> > patchset, cpuset uses cpuset-specific cpuset_mutex instead of
> > cgroup_mutex.  This also removes the lockdep warning triggered during
> > cpu offlining (see 0009).
> > 
> > Note that this leaves memcg as the only external user of cgroup_mutex.
> > Michal, Kame, can you guys please convert memcg to use its own locking
> > too?
> > 
> 
> Hmm. let me see....at quick glance cgroup_lock() is used at
>   hierarchy policy change
>   kmem_limit
>   migration policy change
>   swapiness change
>   oom control
> 
> Because all aboves takes care of changes in hierarchy,
> Having a new memcg's mutex in ->create() may be a way.
> 
> Ah, hm, Costa is mentioning task-attach. is the task-attach problem in
> memcg ?

Yes because we do not want to leak charges if we race with one of the
above hierarchy operation. Swappiness and oom control are not a big
deal. Same applies to migration policy change.
Those could be solved by using the same memcg lock in the attach hook.
Hierarchy policy change would be a bigger issue because the task is
already linked to the group when the callback is called. Same applies to
kmem_limit. Sorry I didn't have time to look into this deeper so I
cannot offer any solution right now.
-- 
Michal Hocko
SUSE Labs
