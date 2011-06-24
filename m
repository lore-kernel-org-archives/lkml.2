Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1FXQ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:26:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45970 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FXQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:26:33 -0400
From: Eric B Munson <emunson@mgebm.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH V2] events: Ensure that timers are updated without requiring read() call
Date: Fri, 24 Jun 2011 12:26:26 -0400
Message-Id: <1308932786-5111-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event tracing infrastructure exposes two timers which should be updated
each time the value of the counter is updated.  Currently, these counters are
only updated when userspace calls read() on the fd associated with an event.
This means that counters which are read via the mmap'd page exclusively never
have their timers updated.  This patch adds ensures that the timers are updated
each time the values in the mmap'd page are updated.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
Changes from V1:
 Use local variables to hold enabled and running times instead of writing to
the event to avoid possible race.  The event updates will have to be done in
the arch code

 kernel/events/core.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9e9a7fa..a6ae668 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3380,8 +3380,19 @@ void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
 	struct perf_buffer *buffer;
+	u64 enabled, running;
 
 	rcu_read_lock();
+	/*
+	 * compute total_time_enabled, total_time_running
+	 * based on snapshot values taken when the event
+	 * was last scheduled in.
+	 *
+	 * we cannot simply called update_context_time()
+	 * because of locking issue as we can be called in
+	 * NMI context
+	 */
+	calc_timer_values(event, &enabled, &running);
 	buffer = rcu_dereference(event->buffer);
 	if (!buffer)
 		goto unlock;
@@ -3400,10 +3411,10 @@ void perf_event_update_userpage(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		userpg->offset -= local64_read(&event->hw.prev_count);
 
-	userpg->time_enabled = event->total_time_enabled +
+	userpg->time_enabled = enabled +
 			atomic64_read(&event->child_total_time_enabled);
 
-	userpg->time_running = event->total_time_running +
+	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
 	barrier();
-- 
1.7.4.1

