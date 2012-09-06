Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2IFNXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:23:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40016 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2IFNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:23:50 -0400
Date: Thu, 6 Sep 2012 15:23:46 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH] perf: remove sw events from multiplexing rotation list
Message-ID: <20120906132346.GA32717@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Software events (sw,tracepoints,...) do not need to be
multiplexed. However, when using a SW event, the SW PMU
(TYPE_SOFTWARE, TYPE_TRACEPOINT) was added to the per-cpu
rotation_list. That list is used by perf_rotate_context()
to iterate over all the PMUs to rotate event lists and
multiplex.

This is not needed for SW events. Doing this adds some
unnecessary overhead, so drop it by rejecting SW PMUs
in perf_pmu_rotate_start().

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b9df35..40f42b8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -651,6 +651,10 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 	struct list_head *head = &__get_cpu_var(rotation_list);
 
+	/* no need to mutliplex software events */
+	if (pmu->task_ctx_nr == perf_sw_context)
+		return;
+
 	WARN_ON(!irqs_disabled());
 
 	if (list_empty(&cpuctx->rotation_list))
