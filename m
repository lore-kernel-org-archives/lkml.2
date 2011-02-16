Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1BPNqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:46:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:39923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1BPNqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:46:19 -0500
Date: Wed, 16 Feb 2011 13:45:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, jmoyer@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, jmoyer@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix throttle logic
Message-ID: <tip-4fe757dd48a9e95e1a071291f15dda5421dacb66@git.kernel.org>
Git-Commit-ID: 4fe757dd48a9e95e1a071291f15dda5421dacb66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:45:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fe757dd48a9e95e1a071291f15dda5421dacb66
Gitweb:     http://git.kernel.org/tip/4fe757dd48a9e95e1a071291f15dda5421dacb66
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Feb 2011 22:26:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:25:29 +0100

perf: Fix throttle logic

It was possible to call pmu::start() on an already running event. In
particular this lead so some wreckage as the hrtimer events would
re-initialize active timers.

This was due to throttled events being activated again by scheduling.
Scheduling in a context would add and force start events, resulting in
running events with a possible throttle status. The next tick to hit
that task will then try to unthrottle the event and call ->start() on
an already running event.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 999835b..656222f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -782,6 +782,10 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+#define MAX_INTERRUPTS (~0ULL)
+
+static void perf_log_throttle(struct perf_event *event, int enable);
+
 static int
 event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
@@ -794,6 +798,17 @@ event_sched_in(struct perf_event *event,
 
 	event->state = PERF_EVENT_STATE_ACTIVE;
 	event->oncpu = smp_processor_id();
+
+	/*
+	 * Unthrottle events, since we scheduled we might have missed several
+	 * ticks already, also for a heavily scheduling task there is little
+	 * guarantee it'll get a tick in a timely manner.
+	 */
+	if (unlikely(event->hw.interrupts == MAX_INTERRUPTS)) {
+		perf_log_throttle(event, 1);
+		event->hw.interrupts = 0;
+	}
+
 	/*
 	 * The new state must be visible before we turn it on in the hardware:
 	 */
@@ -1596,10 +1611,6 @@ void __perf_event_task_sched_in(struct task_struct *task)
 	}
 }
 
-#define MAX_INTERRUPTS (~0ULL)
-
-static void perf_log_throttle(struct perf_event *event, int enable);
-
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	u64 frequency = event->attr.sample_freq;
