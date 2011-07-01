Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1GAPUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:20:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:57418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1GAPUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:20:14 -0400
Date: Fri, 1 Jul 2011 15:20:02 GMT
From: tip-bot for Eric B Munson <emunson@mgebm.net>
Message-ID: <tip-c4794295917ebeda8013b6cb9c8d71ab4f74a1fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        emunson@mgebm.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, emunson@mgebm.net,
        mingo@elte.hu
In-Reply-To: <1308861279-15216-2-git-send-email-emunson@mgebm.net>
References: <1308861279-15216-2-git-send-email-emunson@mgebm.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] events: Move lockless timer calculation into helper function
Git-Commit-ID: c4794295917ebeda8013b6cb9c8d71ab4f74a1fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:20:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4794295917ebeda8013b6cb9c8d71ab4f74a1fa
Gitweb:     http://git.kernel.org/tip/c4794295917ebeda8013b6cb9c8d71ab4f74a1fa
Author:     Eric B Munson <emunson@mgebm.net>
AuthorDate: Thu, 23 Jun 2011 16:34:38 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:33 +0200

events: Move lockless timer calculation into helper function

Take the timer calculation from perf_output_read and move it to a helper
function for any place that needs timer values but cannot take the ctx->lock.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1308861279-15216-2-git-send-email-emunson@mgebm.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2293e0b..c851d70 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3351,6 +3351,18 @@ static int perf_event_index(struct perf_event *event)
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
@@ -3816,7 +3828,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
-	u64 enabled = 0, running = 0, now, ctx_time;
+	u64 enabled = 0, running = 0;
 	u64 read_format = event->attr.read_format;
 
 	/*
@@ -3828,12 +3840,8 @@ static void perf_output_read(struct perf_output_handle *handle,
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
