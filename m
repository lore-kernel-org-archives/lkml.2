Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1HRVlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:41:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112Ab1HRVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:41:04 -0400
Date: Thu, 18 Aug 2011 14:40:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
Message-Id: <20110818144025.8e122a67.akpm@linux-foundation.org>
In-Reply-To: <1313650253-21794-1-git-send-email-gthelen@google.com>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-arch)

On Wed, 17 Aug 2011 23:50:53 -0700
Greg Thelen <gthelen@google.com> wrote:

> Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
> unnecessarily disabling preemption when adjusting per-cpu counters:
>     preempt_disable()
>     __this_cpu_xxx()
>     __this_cpu_yyy()
>     preempt_enable()
> 
> This change does not disable preemption and thus CPU switch is possible
> within these routines.  This does not cause a problem because the total
> of all cpu counters is summed when reporting stats.  Now both
> mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
>     this_cpu_xxx()
>     this_cpu_yyy()
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -664,24 +664,20 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *mem,
>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>  					 bool file, int nr_pages)
>  {
> -	preempt_disable();
> -
>  	if (file)
> -		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
> +		this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
>  	else
> -		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
> +		this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
>  
>  	/* pagein of a big page is an event. So, ignore page size */
>  	if (nr_pages > 0)
> -		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
> +		this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
>  	else {
> -		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
> +		this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
>  		nr_pages = -nr_pages; /* for event */
>  	}
>  
> -	__this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
> -
> -	preempt_enable();
> +	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
>  }

On non-x86 architectures this_cpu_add() internally does
preempt_disable() and preempt_enable().  So the patch is a small
optimisation for x86 and a larger deoptimisation for non-x86.

I think I'll apply it, as the call frequency is low (correct?) and the
problem will correct itself as other architectures implement their
atomic this_cpu_foo() operations.
