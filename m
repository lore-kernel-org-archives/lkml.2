Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1IXAyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 20:54:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1IXAyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 20:54:45 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=K65SvNqAmvUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=NufY4J3AAAAA:8 a=ufHFDILaAAAA:8 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=mdeRhl1Et48XbF9MCOAA:9 a=lojrGcaCD2Pt7u4eO_MA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jbrJJM5MRmoA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=re9sYKne76oA:10 a=l7ZknGph1ugA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>
Date: Fri, 23 Sep 2011 20:54:42 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316825684.6387.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code in memcg_check_events() calls this_cpu_read() on
different variables without disabling preemption, and can cause
the calculations to be done from two different CPU variables.

Disable preemption throughout the check to keep apples and oranges
from becoming a mixed drink.

[ Added this_cpu to __this_cpu conversion by Johannes ]

Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20110919212641.015320989@goodmis.org
---
 mm/memcontrol.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3508777..f823fc8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -683,8 +683,8 @@ static bool __memcg_event_check(struct mem_cgroup *mem, int target)
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
-	next = this_cpu_read(mem->stat->targets[target]);
+	val = __this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = __this_cpu_read(mem->stat->targets[target]);
 	/* from time_after() in jiffies.h */
 	return ((long)next - (long)val < 0);
 }
@@ -693,7 +693,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	val = __this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	switch (target) {
 	case MEM_CGROUP_TARGET_THRESH:
@@ -709,7 +709,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
 		return;
 	}
 
-	this_cpu_write(mem->stat->targets[target], next);
+	__this_cpu_write(mem->stat->targets[target], next);
 }
 
 /*
@@ -718,6 +718,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
  */
 static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
 {
+	preempt_disable();
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(mem);
@@ -737,6 +738,7 @@ static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
 		}
 #endif
 	}
+	preempt_enable();
 }
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
-- 
1.7.3.4



