Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1IZXqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:46:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61824 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1IZXqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:46:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Km2ZtiY4KNUik3tA+8fmNPAQOiaXRXKdEKA/RRyYPcDqRRL+9sWMyCpBU79T3C0z7
	8bHxLzkMQFx9Sg6cs10gw==
Date: Mon, 26 Sep 2011 16:45:59 -0700
From: Andrew Morton <akpm@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
Message-Id: <20110926164559.91f028a2.akpm@google.com>
In-Reply-To: <20110926094322.8ac019d5.kamezawa.hiroyu@jp.fujitsu.com>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com>
	<20110926094322.8ac019d5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 09:43:22 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 23 Sep 2011 20:54:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The code in memcg_check_events() calls this_cpu_read() on
> > different variables without disabling preemption, and can cause
> > the calculations to be done from two different CPU variables.
> > 
> > Disable preemption throughout the check to keep apples and oranges
> > from becoming a mixed drink.
> > 
> > [ Added this_cpu to __this_cpu conversion by Johannes ]
> > 
> > Cc: Greg Thelen <gthelen@google.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Christoph Lameter <cl@linux.com>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > Link: http://lkml.kernel.org/r/20110919212641.015320989@goodmis.org
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Andrew, could you pick this up ?

The patch needed rework due to other changes we have pending in there.


From: Steven Rostedt <srostedt@redhat.com>
Subject: memcg: Fix race condition in memcg_check_events() with this_cpu usage

Various code in memcontrol.c () calls this_cpu_read() on the calculations
to be done from two different percpu variables, or does an open-coded
read-modify-write on a single percpu variable.

Disable preemption throughout these operations so that the writes go to
the correct palces.

[ Added this_cpu to __this_cpu conversion by Johannes ]

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage
+++ a/mm/memcontrol.c
@@ -687,8 +687,8 @@ static bool __memcg_event_check(struct m
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
-	next = this_cpu_read(memcg->stat->targets[target]);
+	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
 	return ((long)next - (long)val < 0);
 }
@@ -697,7 +697,7 @@ static void __mem_cgroup_target_update(s
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	switch (target) {
 	case MEM_CGROUP_TARGET_THRESH:
@@ -713,7 +713,7 @@ static void __mem_cgroup_target_update(s
 		return;
 	}
 
-	this_cpu_write(memcg->stat->targets[target], next);
+	__this_cpu_write(memcg->stat->targets[target], next);
 }
 
 /*
@@ -722,6 +722,7 @@ static void __mem_cgroup_target_update(s
  */
 static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
+	preempt_disable();
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(memcg);
@@ -741,6 +742,7 @@ static void memcg_check_events(struct me
 		}
 #endif
 	}
+	preempt_enable();
 }
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
_

