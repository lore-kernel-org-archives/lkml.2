Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1ITOZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:25:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54022 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab1ITOZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:25:03 -0400
Date: Tue, 20 Sep 2011 16:24:56 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 3/5] memcg: Disable preemption in
 memcg_check_events()
Message-ID: <20110920142456.GC17198@cmpxchg.org>
References: <20110919212040.745370781@goodmis.org>
 <20110919212641.015320989@goodmis.org>
 <20110920142031.GB17198@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920142031.GB17198@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 04:20:31PM +0200, Johannes Weiner wrote:
> On Mon, Sep 19, 2011 at 05:20:43PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The code in memcg_check_events() calls this_cpu_read() on
> > different variables without disabling preemption, and can cause
> > the calculations to be done from two different CPU variables.
> > 
> > Disable preemption throughout the check to keep apples and oranges
> > from becoming a mixed drink.
> 
> Makes sense, thanks!
> 
> Since the atomic versions are no longer required with preemption
> disabled explicitely, could you also make the this_cpu ops in
> __memcg_event_check and __mem_cgroup_target_update non-atomic in the
> same go?

Sorry, shouldn't be on you, can you fold this in?

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b76011a..9d4ba65 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -683,8 +683,8 @@ static bool __memcg_event_check(struct mem_cgroup *memcg, int target)
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
-	next = this_cpu_read(memcg->stat->targets[target]);
+	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
 	return ((long)next - (long)val < 0);
 }
@@ -693,7 +693,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	switch (target) {
 	case MEM_CGROUP_TARGET_THRESH:
@@ -709,7 +709,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
 		return;
 	}
 
-	this_cpu_write(memcg->stat->targets[target], next);
+	__this_cpu_write(memcg->stat->targets[target], next);
 }
 
 /*
