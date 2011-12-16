Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab1LPQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:13:35 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:44975
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751994Ab1LPQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:13:26 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB10Z-02-2GP-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bebl@mageta.org>,
        Benjamin Block <benjamin.block@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 2/5] perf: adds prototype for a new perf-context-type
Date: Fri, 16 Dec 2011 17:12:20 +0100
Message-ID: <1324051943-21112-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Block <benjamin.block@amd.com>

Adds a prototype for a new perf-event context-type for permanent events.
This new context shall later handle events of pmus which don't have to
be enabled or disabled by the scheduler (i.e. lwp).

The current implementation doesn't prevent the scheduler from scheduling
events in this context, it only adds the necessary enum-value and some
checks to prevent that other events than permanent events get added to
this context.

Signed-off-by: Benjamin Block <benjamin.block@amd.com>
Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 include/linux/perf_event.h |   21 +++++++++++++++++++-
 include/linux/sched.h      |   15 ++++++++++++++
 kernel/events/core.c       |   46 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..81807bd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1015,11 +1015,30 @@ static inline bool is_sampling_event(struct perf_event *event)
 }
 
 /*
+ * Returns the type of context, the event is in (hardware, software, permanent).
+ */
+static inline int context_type(struct perf_event *event)
+{
+	return event->pmu->task_ctx_nr;
+}
+
+/*
  * Return 1 for a software event, 0 for a hardware event
  */
 static inline int is_software_event(struct perf_event *event)
 {
-	return event->pmu->task_ctx_nr == perf_sw_context;
+	return context_type(event) == perf_sw_context;
+}
+
+static inline int is_permanent_event(struct perf_event *event)
+{
+	return context_type(event) == perf_permanent_context;
+}
+
+static inline int event_context_differ(struct perf_event *event1,
+				       struct perf_event *event2)
+{
+	return context_type(event1) != context_type(event2);
 }
 
 extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 41d0237..16b771d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1214,6 +1214,21 @@ enum perf_event_task_context {
 	perf_invalid_context = -1,
 	perf_hw_context = 0,
 	perf_sw_context,
+
+	/*
+	 * perf_permanent_context should be used for events which run on PMUs
+	 * that do the context-switching without the scheduler. The
+	 * corresponding PMU has to ensure that the events are only running if
+	 * the task is.
+	 * Like with software-events, the PMU should not have limitations that
+	 * could cause a event not to be activated. Because there is no
+	 * interaction with the scheduler, these limitations could not be
+	 * balanced by perf.
+	 * No other event should be in this context.
+	 *
+	 * TODO: implement scheduler-exceptions
+	 */
+	perf_permanent_context,
 	perf_nr_task_contexts,
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0f85778..faf52f7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6140,26 +6140,56 @@ SYSCALL_DEFINE5(perf_event_open,
 	 */
 	pmu = event->pmu;
 
-	if (group_leader &&
-	    (is_software_event(event) != is_software_event(group_leader))) {
-		if (is_software_event(event)) {
+	if (group_leader && event_context_differ(event, group_leader)) {
+		if (is_permanent_event(event) ||
+		    is_permanent_event(group_leader)) {
 			/*
-			 * If event and group_leader are not both a software
-			 * event, and event is, then group leader is not.
+			 * Permanent events are not scheduled by the scheduler-
+			 * perf-hooks and thus no other event should ever be
+			 * moved in their context, they also should not be
+			 * moved in an other context, because that would cause
+			 * unnecessary scheduler-overhead
+			 *
+			 * TODO: implement scheduler-exceptions
+			 */
+			err = -EINVAL;
+			goto err_alloc;
+		}
+
+		/*
+		 * In the case that neither the event nor the group_leader is a
+		 * permanent event, we have do decide whether it is feasible to
+		 * move the event to the context of the group_leader or
+		 * vis-a-vis.
+		 * Background is: a software-event can be grouped together with
+		 * hardware-events, because they never fail to be scheduled. A
+		 * hardware-event otherwise can fail to be scheduled and thus
+		 * should not be added to a software-context, because that could
+		 * lead to wrong decisions
+		 */
+		switch (context_type(event)) {
+		case perf_sw_context:
+			/*
+			 * If event and group_leader differ in the
+			 * event_context_type and none of them is a permanent
+			 * event, and event is a SW-event, then group_leader has
+			 * to be a HW-event
 			 *
 			 * Allow the addition of software events to !software
 			 * groups, this is safe because software events never
 			 * fail to schedule.
 			 */
 			pmu = group_leader->pmu;
-		} else if (is_software_event(group_leader) &&
-			   (group_leader->group_flags & PERF_GROUP_SOFTWARE)) {
+			break;
+		case perf_hw_context:
 			/*
 			 * In case the group is a pure software group, and we
 			 * try to add a hardware event, move the whole group to
 			 * the hardware context.
 			 */
-			move_group = 1;
+			if (group_leader->group_flags & PERF_GROUP_SOFTWARE)
+				move_group = 1;
+			break;
 		}
 	}
 
-- 
1.7.7


