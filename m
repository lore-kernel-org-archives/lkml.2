Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1IFJ7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab1IFJ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:59:02 -0400
Date: Tue, 6 Sep 2011 11:58:52 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
Message-ID: <20110906095852.GA25053@redhat.com>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313650253-21794-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:50:53PM -0700, Greg Thelen wrote:
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
> Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

I just noticed that both cases have preemption disabled anyway because
of the page_cgroup bit spinlock.

So removing the preempt_disable() is fine but we can even keep the
non-atomic __this_cpu operations.

Something like this instead?

---
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: remove needless recursive preemption disabling

Callsites of mem_cgroup_charge_statistics() hold the page_cgroup bit
spinlock, which implies disabled preemption.

The same goes for the explicit preemption disabling to account mapped
file pages in mem_cgroup_move_account().

The explicit disabling of preemption in both cases is redundant.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/memcontrol.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -618,8 +618,6 @@ static unsigned long mem_cgroup_read_eve
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 bool file, int nr_pages)
 {
-	preempt_disable();
-
 	if (file)
 		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
 	else
@@ -634,8 +632,6 @@ static void mem_cgroup_charge_statistics
 	}
 
 	__this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
-
-	preempt_enable();
 }
 
 unsigned long
@@ -2582,10 +2578,8 @@ static int mem_cgroup_move_account(struc
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
-		preempt_disable();
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		preempt_enable();
 	}
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
