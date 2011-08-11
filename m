Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1HKLb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:31:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41277 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab1HKLb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:31:27 -0400
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf: provide PMU when initing events
Date: Thu, 11 Aug 2011 12:31:20 +0100
Message-Id: <1313062280-19123-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, an event's 'pmu' field is set after pmu::event_init() is
called. This means that pmu::event_init() must figure out which struct
pmu the event was initialised from. This makes it difficult to
consolidate common event initialisation code for similar PMUs, and
very difficult to implement drivers for PMUs which can have multiple
instances (e.g. a USB controller PMU, a GPU PMU, etc).

This patch sets the 'pmu' field before initialising the event, allowing
event init code to identify the struct pmu instance easily. In the
event of failure to initialise an event, the event is destroyed via
kfree() without calling perf_event::destroy(), so this shouldn't
result in bad behaviour even if the destroy field was set before
failure to initialise was noted.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b8785e2..68c8017 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5715,6 +5715,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
+		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (ret)
 			pmu = ERR_PTR(ret);
@@ -5722,6 +5723,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
 			goto unlock;
@@ -5848,8 +5850,6 @@ done:
 		return ERR_PTR(err);
 	}
 
-	event->pmu = pmu;
-
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
 			jump_label_inc(&perf_sched_events);
-- 
1.7.0.4

