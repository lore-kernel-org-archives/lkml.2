Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2JKIup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:50:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2JKIul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:50:41 -0400
Date: Thu, 11 Oct 2012 10:50:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] memcg: oom: fix totalpages calculation for
 swappiness==0
Message-ID: <20121011085038.GA29295@dhcp22.suse.cz>
References: <20121010141142.GG23011@dhcp22.suse.cz>
 <alpine.DEB.2.00.1210101346010.31237@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210101346010.31237@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-10-12 13:50:21, David Rientjes wrote:
> On Wed, 10 Oct 2012, Michal Hocko wrote:
> 
> > Hi,
> > I am sending the patch below as an RFC because I am not entirely happy
> > about myself and maybe somebody can come up with a different approach
> > which would be less hackish.
> 
> I don't see this as hackish, 

I didn't like how swappiness spreads outside of the LRU scanning code...

> if memory.swappiness limits access to swap then this shouldn't be
> factored into the calculation, and that's what your patch fixes.
> 
> The reason why the process with the largest rss isn't killed in this case 
> is because all processes have CAP_SYS_ADMIN so they get a 3% bonus;

OK I should have mentioned that I have tested it as root which makes a
big difference with the current upstream as totalpages are considered
only if adj!=0. 
I have originally seen the problem in 3.0 kernel (with fe35004f applied)
where the calculation is different (missing a7f638f9) and we always
consider total_pages there so it doesn't depend on root or oom_score_adj.

> when factoring swap into the calculation and subtracting 3% from
> the score in oom_badness(), they all end up having an internal
> score of 1 so they are all considered equal.  It appears like the
> cgroup_iter_next() iteration for memcg ooms does this in reverse
> order, which is actually helpful so it will select the task that is
> newer.
> 
> The only suggestion I have to make is specify this is for 
> memory.swappiness in the patch title, otherwise:

OK. I will also update the changelog to mention oom_score_adj and
CAP_SYS_ADMIN, mark the patch for stable and repost it.

> Acked-by: David Rientjes <rientjes@google.com>

Thanks
-- 
Michal Hocko
SUSE Labs
