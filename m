Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab1KVKwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:52:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56513 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1KVKwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:52:13 -0500
Message-ID: <1321959115.5148.22.camel@twins>
Subject: Re: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: eyal@mips.com, zenon@mips.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 11:51:55 +0100
In-Reply-To: <1321932601-21128-1-git-send-email-dczhu@mips.com>
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 11:30 +0800, Deng-Cheng Zhu wrote:
> Currently, when grouped events are created disabled and enable-on-exec, the
> siblings won't be enabled on exec in fact. The problem looks like this:

Arguably that's a daft thing to do, since if the leader is disabled the
group won't get scheduled anyway. But I guess we should at least try to
deal with it when people do do it.

Seems perf-stat is a bit daft this way.

> This patch fixes it.

I guess it does, but its not pretty, event_enable_on_exec() already
calls __perf_event_mark_enable(), now this recursion is limited because
siblings can't have a sibling list of their own, but still.

> +++ b/kernel/events/core.c
> @@ -1651,6 +1651,8 @@ retry:
>  	raw_spin_unlock_irq(&ctx->lock);
>  }
>  
> +static int event_enable_on_exec(struct perf_event *event,
> +				struct perf_event_context *ctx);
>  /*
>   * Put a event into inactive state and update time fields.
>   * Enabling the leader of a group effectively enables all
> @@ -1668,6 +1670,7 @@ static void __perf_event_mark_enabled(struct perf_event *event,
>  	event->state = PERF_EVENT_STATE_INACTIVE;
>  	event->tstamp_enabled = tstamp - event->total_time_enabled;
>  	list_for_each_entry(sub, &event->sibling_list, group_entry) {
> +		event_enable_on_exec(sub, sub->ctx);
>  		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
>  			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
>  	}

The below is a somewhat larger patch that avoids the recursion (and does
a small cleanup by eradicating all those useless ctx arguments). Quick
testing seems to indicate it works, but please confirm.

---
Subject: perf: Fix enable_on_exec for sibling events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Nov 22 11:25:43 CET 2011

Deng-Cheng Zhu reported that sibling events that were created disabled
with enable_on_exec would never get enabled.

Reported-by: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -1664,8 +1664,7 @@ perf_install_in_context(struct perf_even
  * Note: this works for group members as well as group leaders
  * since the non-leader members' sibling_lists will be empty.
  */
-static void __perf_event_mark_enabled(struct perf_event *event,
-					struct perf_event_context *ctx)
+static void __perf_event_mark_enabled(struct perf_event *event)
 {
 	struct perf_event *sub;
 	u64 tstamp = perf_event_time(event);
@@ -1703,7 +1702,7 @@ static int __perf_event_enable(void *inf
 	 */
 	perf_cgroup_set_timestamp(current, ctx);
 
-	__perf_event_mark_enabled(event, ctx);
+	__perf_event_mark_enabled(event);
 
 	if (!event_filter_match(event)) {
 		if (is_cgroup_event(event))
@@ -1784,7 +1783,7 @@ void perf_event_enable(struct perf_event
 
 retry:
 	if (!ctx->is_active) {
-		__perf_event_mark_enabled(event, ctx);
+		__perf_event_mark_enabled(event);
 		goto out;
 	}
 
@@ -2453,8 +2452,7 @@ void perf_event_task_tick(void)
 	}
 }
 
-static int event_enable_on_exec(struct perf_event *event,
-				struct perf_event_context *ctx)
+static int event_enable_on_exec(struct perf_event *event)
 {
 	if (!event->attr.enable_on_exec)
 		return 0;
@@ -2463,11 +2461,25 @@ static int event_enable_on_exec(struct p
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	__perf_event_mark_enabled(event, ctx);
+	event->state = PERF_EVENT_STATE_INACTIVE;
 
 	return 1;
 }
 
+static int group_enable_on_exec(struct perf_event *event)
+{
+	struct perf_event *sub;
+	int ret = 0;
+
+	ret += event_enable_on_exec(event);
+	list_for_each_entry(sub, &event->sibling_list, group_entry)
+		ret += event_enable_on_exec(sub);
+
+	__perf_event_mark_enabled(event);
+
+	return ret;
+}
+
 /*
  * Enable all of a task's events that have been marked enable-on-exec.
  * This expects task == current.
@@ -2496,13 +2508,13 @@ static void perf_event_enable_on_exec(st
 	task_ctx_sched_out(ctx);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
-		ret = event_enable_on_exec(event, ctx);
+		ret = group_enable_on_exec(event);
 		if (ret)
 			enabled = 1;
 	}
 
 	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
-		ret = event_enable_on_exec(event, ctx);
+		ret = group_enable_on_exec(event);
 		if (ret)
 			enabled = 1;
 	}

