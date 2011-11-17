Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1KQKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:25:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:35091 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1KQKZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:25:58 -0500
Date: Thu, 17 Nov 2011 11:25:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
In-Reply-To: <20111117030332.GA14492@zhy>
Message-ID: <alpine.LFD.2.02.1111171125020.4902@ionos>
References: <alpine.LFD.2.02.1111150050590.4902@ionos> <20111115084059.GA23250@zhy> <20111116091653.GA8692@zhy> <1321452758.4181.18.camel@frodo> <alpine.LFD.2.02.1111161801270.4902@ionos> <20111117030332.GA14492@zhy>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Yong Zhang wrote:

> On Wed, Nov 16, 2011 at 06:02:42PM +0100, Thomas Gleixner wrote:
> > On Wed, 16 Nov 2011, Steven Rostedt wrote:
> > > On Wed, 2011-11-16 at 17:16 +0800, Yong Zhang wrote:
> > > > Looking at commit 4799401f [memcg: Fix race condition in
> > > > memcg_check_events() with this_cpu usage], we just want
> > > > to disable migration. So use the right API in -rt. This
> > > > will cure below warning.
> > > No this won't work. Not even for -rt. If we disable migration but not
> > > preemption, then two tasks can take this path. And the checks in
> > > __memcg_event_check() will be corrupted because nothing is protecting
> > > the updates from two tasks going into the same path.
> > > 
> > > Perhaps a local_lock would work.
> > 
> > Yes, that's the only sensible option for now. Untested patch below.
> 
> Works for me.

Johannes came up with a different solution. Could you please give it a try?

Thanks,

	tglx

------------->
Subject: [patch] mm: memcg: shorten preempt-disabled section around event checks

Only the ratelimit checks themselves have to run with preemption
disabled, the resulting actions - checking for usage thresholds,
updating the soft limit tree - can and should run with preemption
enabled.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/memcontrol.c |   73 ++++++++++++++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 38 deletions(-)

Thomas, HTH and it is probably interesting for upstream as well.
Unfortunately, I'm in the middle of moving right now, so this is
untested except for compiling.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..8e62d3e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -683,37 +683,32 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 	return total;
 }
 
-static bool __memcg_event_check(struct mem_cgroup *memcg, int target)
+static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
+				       enum mem_cgroup_events_target target)
 {
 	unsigned long val, next;
 
 	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
-	return ((long)next - (long)val < 0);
-}
-
-static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
-{
-	unsigned long val, next;
-
-	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
-
-	switch (target) {
-	case MEM_CGROUP_TARGET_THRESH:
-		next = val + THRESHOLDS_EVENTS_TARGET;
-		break;
-	case MEM_CGROUP_TARGET_SOFTLIMIT:
-		next = val + SOFTLIMIT_EVENTS_TARGET;
-		break;
-	case MEM_CGROUP_TARGET_NUMAINFO:
-		next = val + NUMAINFO_EVENTS_TARGET;
-		break;
-	default:
-		return;
+	if ((long)next - (long)val < 0) {
+		switch (target) {
+		case MEM_CGROUP_TARGET_THRESH:
+			next = val + THRESHOLDS_EVENTS_TARGET;
+			break;
+		case MEM_CGROUP_TARGET_SOFTLIMIT:
+			next = val + SOFTLIMIT_EVENTS_TARGET;
+			break;
+		case MEM_CGROUP_TARGET_NUMAINFO:
+			next = val + NUMAINFO_EVENTS_TARGET;
+			break;
+		default:
+			break;
+		}
+		__this_cpu_write(memcg->stat->targets[target], next);
+		return true;
 	}
-
-	__this_cpu_write(memcg->stat->targets[target], next);
+	return false;
 }
 
 /*
@@ -724,25 +719,27 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
 	preempt_disable();
 	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
+	if (unlikely(mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_THRESH))) {
+		bool do_softlimit, do_numainfo;
+
+		do_softlimit = mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_SOFTLIMIT);
+#if MAX_NUMNODES > 1
+		do_numainfo = mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_NUMAINFO);
+#endif
+		preempt_enable();
+
 		mem_cgroup_threshold(memcg);
-		__mem_cgroup_target_update(memcg, MEM_CGROUP_TARGET_THRESH);
-		if (unlikely(__memcg_event_check(memcg,
-			     MEM_CGROUP_TARGET_SOFTLIMIT))) {
+		if (unlikely(do_softlimit))
 			mem_cgroup_update_tree(memcg, page);
-			__mem_cgroup_target_update(memcg,
-						   MEM_CGROUP_TARGET_SOFTLIMIT);
-		}
 #if MAX_NUMNODES > 1
-		if (unlikely(__memcg_event_check(memcg,
-			MEM_CGROUP_TARGET_NUMAINFO))) {
+		if (unlikely(do_numainfo))
 			atomic_inc(&memcg->numainfo_events);
-			__mem_cgroup_target_update(memcg,
-				MEM_CGROUP_TARGET_NUMAINFO);
-		}
 #endif
-	}
-	preempt_enable();
+	} else
+		preempt_enable();
 }
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
-- 
1.7.6.4

