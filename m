Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0KJGN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:13:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:49633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0KJGNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:13:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,177,1288594800"; 
   d="scan'208";a="346832939"
Subject: [RFC PATCH 1/2] perf: Enable group siblings on exec if
 attr::enable_on_exec set
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 14:15:11 +0800
Message-ID: <1289369711.2430.38.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only group leader is enabled on exec.
This patch enables all group events on exec if attr::enable_on_exec is
set.

This is needed by next patch.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/perf_event.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 517d827..b94c18d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1700,11 +1700,29 @@ static int event_enable_on_exec(struct perf_event *event,
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	__perf_event_mark_enabled(event, ctx);
+	event->state = PERF_EVENT_STATE_INACTIVE;
 
 	return 1;
 }
 
+static int group_enable_on_exec(struct perf_event *event,
+				struct perf_event_context *ctx)
+{
+	int enabled = 0;
+	struct perf_event *sub;
+
+	list_for_each_entry(sub, &event->sibling_list, group_entry)
+		if (event_enable_on_exec(sub, ctx))
+			enabled++;
+
+	if (event_enable_on_exec(event, ctx))
+		enabled++;
+
+	__perf_event_mark_enabled(event, ctx);
+
+	return enabled;
+}
+
 /*
  * Enable all of a task's events that have been marked enable-on-exec.
  * This expects task == current.
@@ -1725,13 +1743,13 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	raw_spin_lock(&ctx->lock);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
-		ret = event_enable_on_exec(event, ctx);
+		ret = group_enable_on_exec(event, ctx);
 		if (ret)
 			enabled = 1;
 	}
 
 	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
-		ret = event_enable_on_exec(event, ctx);
+		ret = group_enable_on_exec(event, ctx);
 		if (ret)
 			enabled = 1;
 	}
-- 
1.7.1



