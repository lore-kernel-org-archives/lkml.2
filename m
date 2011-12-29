Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1L2LIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 06:08:55 -0500
Received: from shutemov.name ([188.40.19.243]:44219 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1L2LIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 06:08:52 -0500
Date: Thu, 29 Dec 2011 13:08:50 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefiles: Disable unused-variable warning (was: Re:
 [PATCH 1/6] memcg: fix unused variable warning)
Message-ID: <20111229110850.GA5680@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <20111227135752.GK5344@tiehlicka.suse.cz>
 <20111227182613.GA21840@shutemov.name>
 <20111229104230.GA20854@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111229104230.GA20854@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 11:42:30AM +0100, Michal Hocko wrote:
> On Tue 27-12-11 20:26:13, Kirill A. Shutemov wrote:
> > On Tue, Dec 27, 2011 at 02:57:52PM +0100, Michal Hocko wrote:
> > > On Sat 24-12-11 05:00:14, Kirill A. Shutemov wrote:
> > > > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > > > 
> > > > mm/memcontrol.c: In function ‘memcg_check_events’:
> > > > mm/memcontrol.c:784:22: warning: unused variable ‘do_numainfo’ [-Wunused-variable]
> > > > 
> > > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > > > ---
> > > >  mm/memcontrol.c |    7 ++++---
> > > >  1 files changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index d643bd6..a5e92bd 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
> > > >  	/* threshold event is triggered in finer grain than soft limit */
> > > >  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> > > >  						MEM_CGROUP_TARGET_THRESH))) {
> > > > -		bool do_softlimit, do_numainfo;
> > > > +		bool do_softlimit;
> > > >  
> > > > -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> > > > -						MEM_CGROUP_TARGET_SOFTLIMIT);
> > > >  #if MAX_NUMNODES > 1
> > > > +		bool do_numainfo;
> > > >  		do_numainfo = mem_cgroup_event_ratelimit(memcg,
> > > >  						MEM_CGROUP_TARGET_NUMAINFO);
> > > >  #endif
> > > > +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> > > > +						MEM_CGROUP_TARGET_SOFTLIMIT);
> > > 
> > > I don't like this very much. Maybe we should get rid of both do_* and
> > > do it with flags? But maybe it is not worth the additional code at
> > > all...
> > 
> > Something like this (untested):
> > ====
> > From f57e1a2e1aaaa167c75b963d5bf12fcbdd3331b8 Mon Sep 17 00:00:00 2001
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > Date: Tue, 27 Dec 2011 20:17:13 +0200
> > Subject: [PATCH] memcg: cleanup memcg_check_events()
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> The patch looks correct but I am still not sure this is worth fixing in
> the code rather than disabling Wunused-variable.

Does it look better then original code from your POV?

It's a bit cleaner, I think.

> 
> > ---
> >  mm/memcontrol.c |   42 ++++++++++++++++++++++++------------------
> >  1 files changed, 24 insertions(+), 18 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d643bd6..40c2236 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -108,11 +108,12 @@ enum mem_cgroup_events_index {
> >   * than using jiffies etc. to handle periodic memcg event.
> >   */
> >  enum mem_cgroup_events_target {
> > -	MEM_CGROUP_TARGET_THRESH,
> > -	MEM_CGROUP_TARGET_SOFTLIMIT,
> > -	MEM_CGROUP_TARGET_NUMAINFO,
> > -	MEM_CGROUP_NTARGETS,
> > +	MEM_CGROUP_TARGET_THRESH	= BIT(1),
> > +	MEM_CGROUP_TARGET_SOFTLIMIT	= BIT(2),
> > +	MEM_CGROUP_TARGET_NUMAINFO	= BIT(3),
> >  };
> > +#define MEM_CGROUP_NTARGETS 3
> > +
> >  #define THRESHOLDS_EVENTS_TARGET (128)
> >  #define SOFTLIMIT_EVENTS_TARGET (1024)
> >  #define NUMAINFO_EVENTS_TARGET	(1024)
> > @@ -743,7 +744,7 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
> >  	return total;
> >  }
> >  
> > -static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> > +static int mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> >  				       enum mem_cgroup_events_target target)
> >  {
> >  	unsigned long val, next;
> > @@ -766,9 +767,9 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> >  			break;
> >  		}
> >  		__this_cpu_write(memcg->stat->targets[target], next);
> > -		return true;
> > +		return target;
> >  	}
> > -	return false;
> > +	return 0;
> >  }
> >  
> >  /*
> > @@ -777,29 +778,34 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> >   */
> >  static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
> >  {
> > +	int flags;
> > +
> >  	preempt_disable();
> > -	/* threshold event is triggered in finer grain than soft limit */
> > -	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> > -						MEM_CGROUP_TARGET_THRESH))) {
> > -		bool do_softlimit, do_numainfo;
> > +	flags = mem_cgroup_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH);
> >  
> > -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> > +	/*
> > +	 * Threshold event is triggered in finer grain than soft limit
> > +	 * and numainfo
> > +	 */
> > +	if (unlikely(flags)) {
> > +		flags |= mem_cgroup_event_ratelimit(memcg,
> >  						MEM_CGROUP_TARGET_SOFTLIMIT);
> >  #if MAX_NUMNODES > 1
> > -		do_numainfo = mem_cgroup_event_ratelimit(memcg,
> > +		flags |= mem_cgroup_event_ratelimit(memcg,
> >  						MEM_CGROUP_TARGET_NUMAINFO);
> >  #endif
> > -		preempt_enable();
> > +	}
> > +	preempt_enable();
> >  
> > +	if (unlikely(flags)) {
> >  		mem_cgroup_threshold(memcg);
> > -		if (unlikely(do_softlimit))
> > +		if (unlikely(flags & MEM_CGROUP_TARGET_SOFTLIMIT))
> >  			mem_cgroup_update_tree(memcg, page);
> >  #if MAX_NUMNODES > 1
> > -		if (unlikely(do_numainfo))
> > +		if (unlikely(flags & MEM_CGROUP_TARGET_NUMAINFO))
> >  			atomic_inc(&memcg->numainfo_events);
> >  #endif
> > -	} else
> > -		preempt_enable();
> > +	}
> >  }
> >  
> >  struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
> > -- 
> > 1.7.7.3
> 
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic

-- 
 Kirill A. Shutemov
