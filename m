Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0EGSmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:42:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:46465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab0EGSmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:42:50 -0400
Date: Fri, 7 May 2010 18:41:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1273160566.5605.404.camel@twins>
References: <1273160566.5605.404.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix exit() vs PERF_FORMAT_GROUP
Message-ID: <tip-4fd38e4595e2f6c9d27732c042a0e16b2753049c@git.kernel.org>
Git-Commit-ID: 4fd38e4595e2f6c9d27732c042a0e16b2753049c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:41:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fd38e4595e2f6c9d27732c042a0e16b2753049c
Gitweb:     http://git.kernel.org/tip/4fd38e4595e2f6c9d27732c042a0e16b2753049c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 6 May 2010 17:31:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:30:17 +0200

perf: Fix exit() vs PERF_FORMAT_GROUP

Both Stephane and Corey reported that PERF_FORMAT_GROUP didn't work
as expected if the task the counters were attached to quit before
the read() call.

The cause is that we unconditionally destroy the grouping when we
remove counters from their context. Fix this by only doing this when
we free the counter itself.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1273160566.5605.404.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c8e3754..bf8f3c0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -522,6 +522,7 @@ struct pmu {
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
+	PERF_EVENT_STATE_FREE		= -3,
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3d1552d..f13c3db 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -341,6 +341,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
 
+	if (event->state > PERF_EVENT_STATE_FREE)
+		return;
+
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them
@@ -1856,6 +1859,8 @@ int perf_event_release_kernel(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
+	event->state = PERF_EVENT_STATE_FREE;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_event_remove_from_context(event);
