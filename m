Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1CCKE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:04:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:40453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1CCKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:04:57 -0500
Subject: Re: [BUG] lock issue in perf cgroup with jump label enabled
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D6F51C9.3020800@cn.fujitsu.com>
References: <4D6F51C9.3020800@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 11:06:27 +0100
Message-ID: <1299146787.1310.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 16:31 +0800, Li Zefan wrote:
> With CONFIG_JUMP_LABEL enabled:
> 
> # mount -t cgroup -o perf_event xxx /mnt
> # mkdir /mnt/test
> # ./perf stat -B -a -e cycles:u -G test -- sleep 1
> 
> lockdep warning will be triggered immediately, and the machine
> will become unresponsive.
> 
> I guess this is the culprit?
> 
> In the "perf cgroup support" patch:
> 
> @@ -419,6 +781,17 @@ list_add_event(struct perf_event *event, struct perf_event_con
>                 list_add_tail(&event->group_entry, list);
>         }
>  
> +       if (is_cgroup_event(event)) {
> +               ctx->nr_cgroups++;
> +               /*
> +                * one more event:
> +                * - that has cgroup constraint on event->cpu
> +                * - that may need work on context switch
> +                */
> +               atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
> +               jump_label_inc(&perf_sched_events);
> +       }
> 
> list_add_event() is called with spin lock ctl->lock held,  while
> jump_label_inc() will acquire jump_label_mutex..

I think something like the below ought to cure that.

---
 kernel/perf_event.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64a018e..6bc69a4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -817,16 +817,8 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -6553,6 +6545,16 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_context;
 	}
 
+	if (is_cgroup_event(event)) {
+		/*
+		 * one more event:
+		 * - that has cgroup constraint on event->cpu
+		 * - that may need work on context switch
+		 */
+		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_inc(&perf_sched_events);
+	}
+
 	if (move_group) {
 		struct perf_event_context *gctx = group_leader->ctx;
 


