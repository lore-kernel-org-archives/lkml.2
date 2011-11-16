Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab1KPRCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:02:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:59437 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1KPRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:02:45 -0500
Date: Wed, 16 Nov 2011 18:02:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
In-Reply-To: <1321452758.4181.18.camel@frodo>
Message-ID: <alpine.LFD.2.02.1111161801270.4902@ionos>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>  <20111115084059.GA23250@zhy>  <20111116091653.GA8692@zhy> <1321452758.4181.18.camel@frodo>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Steven Rostedt wrote:
> On Wed, 2011-11-16 at 17:16 +0800, Yong Zhang wrote:
> > Looking at commit 4799401f [memcg: Fix race condition in
> > memcg_check_events() with this_cpu usage], we just want
> > to disable migration. So use the right API in -rt. This
> > will cure below warning.
> No this won't work. Not even for -rt. If we disable migration but not
> preemption, then two tasks can take this path. And the checks in
> __memcg_event_check() will be corrupted because nothing is protecting
> the updates from two tasks going into the same path.
> 
> Perhaps a local_lock would work.

Yes, that's the only sensible option for now. Untested patch below.

Thanks,

	tglx

-------------->
 mm/memcontrol.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-3.2/mm/memcontrol.c
===================================================================
--- linux-3.2.orig/mm/memcontrol.c
+++ linux-3.2/mm/memcontrol.c
@@ -49,6 +49,8 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/locallock.h>
+
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -363,6 +365,8 @@ enum charge_type {
 #define MEM_CGROUP_RECLAIM_SOFT_BIT	0x2
 #define MEM_CGROUP_RECLAIM_SOFT		(1 << MEM_CGROUP_RECLAIM_SOFT_BIT)
 
+static DEFINE_LOCAL_IRQ_LOCK(stats_lock);
+
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
@@ -619,7 +623,7 @@ static unsigned long mem_cgroup_read_eve
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 bool file, int nr_pages)
 {
-	preempt_disable();
+	local_lock(stats_lock);
 
 	if (file)
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
@@ -638,7 +642,7 @@ static void mem_cgroup_charge_statistics
 
 	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
 
-	preempt_enable();
+	local_unlock(stats_lock);
 }
 
 unsigned long
@@ -722,7 +726,7 @@ static void __mem_cgroup_target_update(s
  */
 static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
-	preempt_disable();
+	local_lock(stats_lock);
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(memcg);
@@ -742,7 +746,7 @@ static void memcg_check_events(struct me
 		}
 #endif
 	}
-	preempt_enable();
+	local_unlock(stats_lock);
 }
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
@@ -2608,10 +2612,10 @@ static int mem_cgroup_move_account(struc
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
-		preempt_disable();
+		local_lock(stats_lock);
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		preempt_enable();
+		local_unlock(stats_lock);
 	}
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
