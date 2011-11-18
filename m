Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1KRT5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:57:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:42120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1KRT5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:57:03 -0500
Date: Fri, 18 Nov 2011 20:57:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.2-rc2-rt3
Message-ID: <alpine.LFD.2.02.1111182047371.4902@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.2-rc2-rt3 release. There is no
intermediate release as the rc1-rt2 patch applies cleanly to rc2.

NOTE: Releases are back to www.kernel.org - the intermediate tglx.de
      release URL is history!

Changes vs. 3.2-rc1-rt2:

  * Refreshed the device mapper patch (fixes the NORT typo)

  * Trace padding fix (Steven Rostedt)

  * memcg preemptability fix (Johannes Weimer)


The incremental patch against 3.2-rc1-rt2 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2-rc2-rt2-rt3.patch.bz2    

and is also appended below.


The RT patch against 3.2-rc2 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2-rc2-rt3.patch.bz2 


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patches-3.2-rc2-rt3.tar.bz2 


Enjoy,

	tglx
---
Index: linux-3.2/drivers/md/dm.c
===================================================================
--- linux-3.2.orig/drivers/md/dm.c
+++ linux-3.2/drivers/md/dm.c
@@ -1648,14 +1648,14 @@ static void dm_request_fn(struct request
 		if (map_request(ti, clone, md))
 			goto requeued;
 
-		BUG_ON_NORT(!irqs_disabled());
+		BUG_ON_NONRT(!irqs_disabled());
 		spin_lock(q->queue_lock);
 	}
 
 	goto out;
 
 requeued:
-	BUG_ON_NORT(!irqs_disabled());
+	BUG_ON_NONRT(!irqs_disabled());
 	spin_lock(q->queue_lock);
 
 delay_and_out:
Index: linux-3.2/kernel/trace/trace_events.c
===================================================================
--- linux-3.2.orig/kernel/trace/trace_events.c
+++ linux-3.2/kernel/trace/trace_events.c
@@ -117,7 +117,7 @@ static int trace_define_common_fields(vo
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
 	__common_field(unsigned short, migrate_disable);
-	__common_field(int, padding);
+	__common_field(unsigned short, padding);
 
 	return ret;
 }
Index: linux-3.2/localversion-rt
===================================================================
--- linux-3.2.orig/localversion-rt
+++ linux-3.2/localversion-rt
@@ -1 +1 @@
--rt2
+-rt3
Index: linux-3.2/mm/memcontrol.c
===================================================================
--- linux-3.2.orig/mm/memcontrol.c
+++ linux-3.2/mm/memcontrol.c
@@ -683,37 +683,32 @@ static unsigned long mem_cgroup_nr_lru_p
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
@@ -724,25 +719,27 @@ static void memcg_check_events(struct me
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
