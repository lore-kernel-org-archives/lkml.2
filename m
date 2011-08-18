Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1HRGvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:51:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1HRGvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:51:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=UBmPfEEL8Vwb954561HnrRG5wL44uqaeDv9r8vk8jBSxNLEXaGHuLJdNnghko0m3X
	PYsBbKk2j8uP7bCWKFjmA==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: remove unneeded preempt_disable
Date: Wed, 17 Aug 2011 23:50:53 -0700
Message-Id: <1313650253-21794-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
unnecessarily disabling preemption when adjusting per-cpu counters:
    preempt_disable()
    __this_cpu_xxx()
    __this_cpu_yyy()
    preempt_enable()

This change does not disable preemption and thus CPU switch is possible
within these routines.  This does not cause a problem because the total
of all cpu counters is summed when reporting stats.  Now both
mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
    this_cpu_xxx()
    this_cpu_yyy()

Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c6faa32..048b205 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -664,24 +664,20 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *mem,
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 bool file, int nr_pages)
 {
-	preempt_disable();
-
 	if (file)
-		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
+		this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
 	else
-		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
+		this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
 
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
-		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
+		this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
 	else {
-		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
+		this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
-
-	preempt_enable();
+	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
 }
 
 unsigned long
@@ -2713,10 +2709,8 @@ static int mem_cgroup_move_account(struct page *page,
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
-		preempt_disable();
-		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		preempt_enable();
+		this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 	}
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
-- 
1.7.3.1

