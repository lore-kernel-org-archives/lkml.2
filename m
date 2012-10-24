Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab2JXQEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:04:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab2JXQET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:04:19 -0400
Date: Wed, 24 Oct 2012 18:03:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 02/11] perf: Do not get values from disabled counters in
 group format read
Message-ID: <20121024160344.GC5582@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <1350743599-4805-3-git-send-email-jolsa@redhat.com>
 <1351008789.13456.37.camel@twins>
 <20121023165040.GA7553@krava.brq.redhat.com>
 <1351080078.13456.60.camel@twins>
 <20121024121406.GA5582@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024121406.GA5582@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:14:06PM +0200, Jiri Olsa wrote:
> On Wed, Oct 24, 2012 at 02:01:18PM +0200, Peter Zijlstra wrote:

SNIP

> > Right, so I don't object to the patch per-se, I was just curious how you
> > ran into it, because ISTR what you just said, we enable all this stuff
> > together.
> > 
> > Also, why would disabled counters give strange values? They'd simply
> > return the same old value time after time, right?
> 
> well, x86_pmu_read calls x86_perf_event_update, which expects the event
> is active.. if it's not it'll update the count from whatever left in
> event.hw.idx counter.. could be uninitialized or used by others..
> 
> I can easily reproduce this one, so let's see.. ;)

ok, the problem code path is like this:

- running "perf record -e '{cycles,cache-misses}:S' -a sleep 1"
  which creates group of counters, that are enabled by perf via ioctl

- within the __perf_event_enable function the __perf_event_mark_enabled only
  change state for leader, so following group_sched_in will fail to schedule
  group siblings, because of the state check in event_sched_in:

	static int
	event_sched_in(struct perf_event *event,
			 struct perf_cpu_context *cpuctx,
			 struct perf_event_context *ctx)
	{
		u64 tstamp = perf_event_time(event);

		if (event->state <= PERF_EVENT_STATE_OFF)
			return 0;

- ending up with only leader enabled
- all the other events in group are enabled by perf after the leader,
  but meanwhile leader can hit sample.. and read group events.. ;)

attached patch fixies this for me and I was wondering we want
same behaviour for disable path as well (included below not tested)

I also think that we should keep that state check before calling
pmu->read() in the perf sample read

thanks,
jirka


---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dabfc5d..119a57e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1253,6 +1253,16 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+static void __perf_event_mark_disabled(struct perf_event *event)
+{
+	struct perf_event *sub;
+
+	event->state = PERF_EVENT_STATE_OFF;
+
+	list_for_each_entry(sub, &event->sibling_list, group_entry)
+		sub->state = PERF_EVENT_STATE_OFF;
+}
+
 /*
  * Cross CPU call to disable a performance event
  */
@@ -1286,7 +1296,8 @@ int __perf_event_disable(void *info)
 			group_sched_out(event, cpuctx, ctx);
 		else
 			event_sched_out(event, cpuctx, ctx);
-		event->state = PERF_EVENT_STATE_OFF;
+
+		__perf_event_mark_disabled(event);
 	}
 
 	raw_spin_unlock(&ctx->lock);
@@ -1685,8 +1696,8 @@ retry:
 /*
  * Put a event into inactive state and update time fields.
  * Enabling the leader of a group effectively enables all
- * the group members that aren't explicitly disabled, so we
- * have to update their ->tstamp_enabled also.
+ * the group members, so we have to update their ->tstamp_enabled
+ * also.
  * Note: this works for group members as well as group leaders
  * since the non-leader members' sibling_lists will be empty.
  */
@@ -1697,9 +1708,10 @@ static void __perf_event_mark_enabled(struct perf_event *event)
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	event->tstamp_enabled = tstamp - event->total_time_enabled;
+
 	list_for_each_entry(sub, &event->sibling_list, group_entry) {
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
-			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
+		sub->state = PERF_EVENT_STATE_INACTIVE;
+		sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 	}
 }
 
