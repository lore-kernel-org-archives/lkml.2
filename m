Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934369Ab1FWUey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:34:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35602 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab1FWUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:34:52 -0400
From: Eric B Munson <emunson@mgebm.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 2/3] events: Move lockless timer calculation into helper function
Date: Thu, 23 Jun 2011 16:34:38 -0400
Message-Id: <1308861279-15216-2-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take the timer calculation from perf_output_read and move it to a helper
function for any place that needs timer values but cannot take the ctx->lock.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 kernel/events/core.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a054964..9e9a7fa 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3359,6 +3359,18 @@ static int perf_event_index(struct perf_event *event)
 	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
 }
 
+static void calc_timer_values(struct perf_event *event,
+				u64 *running,
+				u64 *enabled)
+{
+	u64 now, ctx_time;
+
+	now = perf_clock();
+	ctx_time = event->shadow_ctx_time + now;
+	*enabled = ctx_time - event->tstamp_enabled;
+	*running = ctx_time - event->tstamp_running;
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch
@@ -4250,7 +4262,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
-	u64 enabled = 0, running = 0, now, ctx_time;
+	u64 enabled = 0, running = 0;
 	u64 read_format = event->attr.read_format;
 
 	/*
@@ -4262,12 +4274,8 @@ static void perf_output_read(struct perf_output_handle *handle,
 	 * because of locking issue as we are called in
 	 * NMI context
 	 */
-	if (read_format & PERF_FORMAT_TOTAL_TIMES) {
-		now = perf_clock();
-		ctx_time = event->shadow_ctx_time + now;
-		enabled = ctx_time - event->tstamp_enabled;
-		running = ctx_time - event->tstamp_running;
-	}
+	if (read_format & PERF_FORMAT_TOTAL_TIMES)
+		calc_timer_values(event, &enabled, &running);
 
 	if (event->attr.read_format & PERF_FORMAT_GROUP)
 		perf_output_read_group(handle, event, enabled, running);
-- 
1.7.4.1

