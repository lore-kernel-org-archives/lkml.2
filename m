Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1ISV1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:27:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1ISV0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:45 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=aNpYe9hrFvkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=ufHFDILaAAAA:8 a=1XWaLZrsAAAA:8 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=NWvjgwRQGdOIabK6crAA:9 a=ZnwbrsSBWAVPcJVNnfYA:7 a=jEp0ucaQiEUA:10 a=l7ZknGph1ugA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110919212641.015320989@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 19 Sep 2011 17:20:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 3/5] memcg: Disable preemption in memcg_check_events()
References: <20110919212040.745370781@goodmis.org>
Content-Disposition: inline; filename=0003-memcg-Disable-preemption-in-memcg_check_events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code in memcg_check_events() calls this_cpu_read() on
different variables without disabling preemption, and can cause
the calculations to be done from two different CPU variables.

Disable preemption throughout the check to keep apples and oranges
from becoming a mixed drink.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/memcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3508777..a164c93 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
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
1.7.5.4


