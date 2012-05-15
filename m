Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab2EOO6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:58:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab2EOO6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:58:06 -0400
Date: Tue, 15 May 2012 16:58:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] mm: memcg: keep ratelimit counter separate from
 event counters
Message-ID: <20120515145805.GI11346@tiehlicka.suse.cz>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
 <1337018451-27359-5-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337018451-27359-5-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-05-12 20:00:49, Johannes Weiner wrote:
> All events except the ratelimit counter are statistics exported to
> userspace.  Keep this internal value out of the event count array.

OK, makes sense. I was just thinking that events_internal array (with a
single MEM_CGROUP_EVENTS_COUNT) would be more consistent. Probably too
much churn for a single event though.

> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9e8551c..546e7db 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -105,7 +105,6 @@ enum mem_cgroup_stat_index {
>  enum mem_cgroup_events_index {
>  	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
>  	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
> -	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
>  	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
>  	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
>  	MEM_CGROUP_EVENTS_NSTATS,
> @@ -129,6 +128,7 @@ enum mem_cgroup_events_target {
>  struct mem_cgroup_stat_cpu {
>  	long count[MEM_CGROUP_STAT_NSTATS];
>  	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
> +	unsigned long nr_page_events;
>  	unsigned long targets[MEM_CGROUP_NTARGETS];
>  };
>  
> @@ -736,7 +736,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
>  		nr_pages = -nr_pages; /* for event */
>  	}
>  
> -	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
> +	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
>  
>  	preempt_enable();
>  }
> @@ -797,7 +797,7 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
>  {
>  	unsigned long val, next;
>  
> -	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> +	val = __this_cpu_read(memcg->stat->nr_page_events);
>  	next = __this_cpu_read(memcg->stat->targets[target]);
>  	/* from time_after() in jiffies.h */
>  	if ((long)next - (long)val < 0) {
> -- 
> 1.7.10.1
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
