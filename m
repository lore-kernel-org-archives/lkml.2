Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1C2Nm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:42:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab1C2NmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:42:25 -0400
Date: Tue, 29 Mar 2011 15:42:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-ID: <20110329134223.GB3361@tiehlicka.suse.cz>
References: <20110328093957.089007035@suse.cz>
 <20110328200332.17fb4b78.kamezawa.hiroyu@jp.fujitsu.com>
 <20110328114430.GE5693@tiehlicka.suse.cz>
 <20110329090924.6a565ef3.kamezawa.hiroyu@jp.fujitsu.com>
 <20110329073232.GB30671@tiehlicka.suse.cz>
 <20110329165117.179d87f9.kamezawa.hiroyu@jp.fujitsu.com>
 <20110329085942.GD30671@tiehlicka.suse.cz>
 <20110329184119.219f7d7b.kamezawa.hiroyu@jp.fujitsu.com>
 <20110329111858.GF30671@tiehlicka.suse.cz>
 <AANLkTi=1WA-oF1kraTMMcSgwqvaXqrEiROVGeDfejO45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=1WA-oF1kraTMMcSgwqvaXqrEiROVGeDfejO45@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-03-11 21:15:59, Zhu Yanhai wrote:
> Michal,

Hi,

> Maybe what we need here is some kind of trade-off?
> Let's say a new configuable parameter reserve_limit, for the cgroups
> which want to
> have some guarantee in the memory resource, we have:
> 
> limit_in_bytes > soft_limit > reserve_limit
> 
> MEM[limit_in_bytes..soft_limit] are the bytes that I'm willing to contribute
> to the others if they are short of memory.
> 
> MEM[soft_limit..reserve_limit] are the bytes that I can afford if the others
> are still eager for memory after I gave them MEM[limit_in_bytes..soft_limit].
> 
> MEM[reserve_limit..0] are the bytes which is a must for me to guarantee QoS.
> Nobody is allowed to steal them.
> 
> And reserve_limit is 0 by default for the cgroups who don't care about Qos.
> 
> Then the reclaim path also needs some changes, i.e, balance_pgdat():
> 1) call mem_cgroup_soft_limit_reclaim(), if nr_reclaimed is meet, goto finish.
> 2) shrink the global LRU list, and skip the pages which belong to the cgroup
> who have set a reserve_limit. if nr_reclaimed is meet, goto finish.

Isn't this an overhead that would slow the whole thing down. Consider
that you would need to lookup page_cgroup for every page and touch
mem_cgroup to get the limit.
The point of the isolation is to not touch the global reclaim path at
all.

> 3) shrink the cgroups who have set a reserve_limit, and leave them with only
> the reserve_limit bytes they need. if nr_reclaimed is meet, goto finish.
> 4) OOM
> 
> Does it make sense?

It sounds like a good thing - in that regard it is more generic than
a simple flag - but I am afraid that the implementation wouldn't be
that easy to preserve the performance and keep the balance between
groups. But maybe it can be done without too much cost.

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
