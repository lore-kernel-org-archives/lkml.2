Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab1DXO5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 10:57:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:18529 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab1DXO5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 10:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,263,1301900400"; 
   d="scan'208";a="424619205"
Subject: [PATCH] perf: Allow set output buffer for tasks in the same thread
 group
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Blechmann <tim@klingt.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 22:57:44 +0800
Message-Id: <1303657064.2239.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kernel only allows an event to redirect its output to other
events of the same task.

This causes PERF_EVENT_IOC_SET_OUTPUT ioctl fails when an event is
trying to redirect its output to other events in the same thread group.

This patch fixes the bug reported at,
https://lkml.org/lkml/2011/4/6/499

Tested-by: Tim Blechmann <tim@klingt.org>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/perf_event.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8e81a98..216a617 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6379,9 +6379,12 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		goto out;
 
 	/*
-	 * If its not a per-cpu buffer, it must be the same task.
+	 * If its not a per-cpu buffer,
+	 * it must be the same task or in the same thread group.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 &&
+			!same_thread_group(output_event->ctx->task,
+					event->ctx->task))
 		goto out;
 
 set:



