Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1CCOPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:15:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:45251 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1CCOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:15:50 -0500
Subject: Re: [BUG] lock issue in perf cgroup with jump label enabled
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299146787.1310.41.camel@laptop>
References: <4D6F51C9.3020800@cn.fujitsu.com>
	 <1299146787.1310.41.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 15:17:20 +0100
Message-ID: <1299161840.1310.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 11:06 +0100, Peter Zijlstra wrote:
> 
> > list_add_event() is called with spin lock ctl->lock held,  while
> > jump_label_inc() will acquire jump_label_mutex..
> 

The below seems to actually work, I totally overlooked the dec case
earlier.

---
Subject: perf: Fix cgroup vs jump_label problem
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Mar 03 11:31:20 CET 2011

Li Zefan reported that the jump label code sleeps and we're calling it
under a spinlock, *fail* ;-)

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -820,16 +820,8 @@ list_add_event(struct perf_event *event,
 		list_add_tail(&event->group_entry, list);
 	}
 
-	if (is_cgroup_event(event)) {
+	if (is_cgroup_event(event))
 		ctx->nr_cgroups++;
-		/*
-		 * one more event:
-		 * - that has cgroup constraint on event->cpu
-		 * - that may need work on context switch
-		 */
-		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events);
-	}
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
@@ -957,11 +949,8 @@ list_del_event(struct perf_event *event,
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	if (is_cgroup_event(event)) {
+	if (is_cgroup_event(event))
 		ctx->nr_cgroups--;
-		atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_dec(&perf_sched_events);
-	}
 
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
@@ -2903,6 +2892,10 @@ static void free_event(struct perf_event
 			atomic_dec(&nr_task_events);
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
 			put_callchain_buffers();
+		if (is_cgroup_event(event)) {
+			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
+			jump_label_dec(&perf_sched_events);
+		}
 	}
 
 	if (event->buffer) {
@@ -6478,6 +6471,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		err = perf_cgroup_connect(pid, event, &attr, group_leader);
 		if (err)
 			goto err_alloc;
+		/*
+		 * one more event:
+		 * - that has cgroup constraint on event->cpu
+		 * - that may need work on context switch
+		 */
+		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_inc(&perf_sched_events);
 	}
 
 	/*


