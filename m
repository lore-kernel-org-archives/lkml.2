Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1FWGej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:34:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36549 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1FWGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:34:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jun 2011 15:27:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/7] memcg: update numa information based on event
 counter
Message-Id: <20110623152734.3a4f867a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110622155309.GH14343@tiehlicka.suse.cz>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125400.1145a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110622155309.GH14343@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 17:53:09 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 16-06-11 12:54:00, KAMEZAWA Hiroyuki wrote:
> > From 88090fe10e225ad8769ba0ea01692b7314e8b973 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Wed, 15 Jun 2011 16:19:46 +0900
> > Subject: [PATCH 4/7] memcg: update numa information based on event counter
> > 
> > commit 889976 adds an numa node round-robin for memcg. But the information
> > is updated once per 10sec.
> > 
> > This patch changes the update trigger from jiffies to memcg's event count.
> > After this patch, numa scan information will be updated when
> > 
> >   - the number of pagein/out events is larger than 3% of limit
> >   or
> >   - the number of pagein/out events is larger than 16k
> >     (==64MB pagein/pageout if pagesize==4k.)
> > 
> > The counter of mem->numascan_update the sum of percpu events counter.
> > When a task hits limit, it checks mem->numascan_update. If it's over
> > min(3% of limit, 16k), numa information will be updated.
> 
> Yes, I like the event based approach more than the origin (time) based
> one.
> 
> > 
> > This patch also adds mutex for updating information. This will allow us
> > to avoid unnecessary scan.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |   51 +++++++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 45 insertions(+), 6 deletions(-)
> > 
> > Index: mmotm-0615/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0615.orig/mm/memcontrol.c
> > +++ mmotm-0615/mm/memcontrol.c
> > @@ -108,10 +108,12 @@ enum mem_cgroup_events_index {
> >  enum mem_cgroup_events_target {
> >  	MEM_CGROUP_TARGET_THRESH,
> >  	MEM_CGROUP_TARGET_SOFTLIMIT,
> > +	MEM_CGROUP_TARGET_NUMASCAN,
> 
> Shouldn't it be defined only for MAX_NUMNODES > 1
> 

Hmm, yes. But I want to reduce #ifdefs..


> >  	MEM_CGROUP_NTARGETS,
> >  };
> >  #define THRESHOLDS_EVENTS_TARGET (128)
> >  #define SOFTLIMIT_EVENTS_TARGET (1024)
> > +#define NUMASCAN_EVENTS_TARGET  (1024)
> >  
> >  struct mem_cgroup_stat_cpu {
> >  	long count[MEM_CGROUP_STAT_NSTATS];
> > @@ -288,8 +290,9 @@ struct mem_cgroup {
> >  	int last_scanned_node;
> >  #if MAX_NUMNODES > 1
> >  	nodemask_t	scan_nodes;
> > -	unsigned long   next_scan_node_update;
> > +	struct mutex	numascan_mutex;
> >  #endif
> > +	atomic_t	numascan_update;
> 
> Why it is out of ifdef?
> 

This was for avoiding #ifdef in mem_cgroup_create()...but it's not used now.
I'll fix this.



> >  	/*
> >  	 * Should the accounting and control be hierarchical, per subtree?
> >  	 */
> > @@ -741,6 +744,9 @@ static void __mem_cgroup_target_update(s
> >  	case MEM_CGROUP_TARGET_SOFTLIMIT:
> >  		next = val + SOFTLIMIT_EVENTS_TARGET;
> >  		break;
> > +	case MEM_CGROUP_TARGET_NUMASCAN:
> > +		next = val + NUMASCAN_EVENTS_TARGET;
> > +		break;
> 
> MAX_NUMNODES > 1
> 
> >  	default:
> >  		return;
> >  	}
> > @@ -764,6 +770,13 @@ static void memcg_check_events(struct me
> >  			__mem_cgroup_target_update(mem,
> >  				MEM_CGROUP_TARGET_SOFTLIMIT);
> >  		}
> > +		if (unlikely(__memcg_event_check(mem,
> > +			MEM_CGROUP_TARGET_NUMASCAN))) {
> > +			atomic_add(MEM_CGROUP_TARGET_NUMASCAN,
> > +				&mem->numascan_update);
> > +			__mem_cgroup_target_update(mem,
> > +				MEM_CGROUP_TARGET_NUMASCAN);
> > +		}
> >  	}
> 
> again MAX_NUMNODES > 1
> 

Hmm, ok, I will add #ifdef only here.



> >  }
> >  
> > @@ -1616,17 +1629,32 @@ mem_cgroup_select_victim(struct mem_cgro
> >  /*
> >   * Always updating the nodemask is not very good - even if we have an empty
> >   * list or the wrong list here, we can start from some node and traverse all
> > - * nodes based on the zonelist. So update the list loosely once per 10 secs.
> > + * nodes based on the zonelist.
> >   *
> > + * The counter of mem->numascan_update is updated once per
> > + * NUMASCAN_EVENTS_TARGET. We update the numa information when we see
> > + * the number of event is larger than 3% of limit or  64MB pagein/pageout.
> >   */
> > +#define NUMASCAN_UPDATE_RATIO	(3)
> > +#define NUMASCAN_UPDATE_THRESH	(16384UL) /* 16k events of pagein/pageout */
> >  static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
> >  {
> >  	int nid;
> > -
> > -	if (time_after(mem->next_scan_node_update, jiffies))
> > +	unsigned long long limit;
> > +	/* if no limit, we never reach here */
> > +	limit = res_counter_read_u64(&mem->res, RES_LIMIT);
> > +	limit /= PAGE_SIZE;
> > +	/* 3% of limit */
> > +	limit = (limit * NUMASCAN_UPDATE_RATIO/100UL);
> > +	limit = min_t(unsigned long long, limit, NUMASCAN_UPDATE_THRESH);
> > +	/*
> > +	 * If the number of pagein/out event is larger than 3% of limit or
> > +	 * 64MB pagein/out, refresh numa information.
> > +	 */
> > +	if (atomic_read(&mem->numascan_update) < limit ||
> > +	    !mutex_trylock(&mem->numascan_mutex))
> >  		return;
> 
> I am not sure whether a mutex is not overkill here. What about using an
> atomic operation instead?
> 

I think mutex is informative than atomic counter for code readers.
If influence of overhead is not big, I'd like to use mutex.

Thanks,
-Kame


