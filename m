Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1BHB7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:59:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1BHB7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:36 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=9grv2lgZbdsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=c2TNGMgT6eVCfmJCFUsA:9 a=5WTmM8j3pn_8zjjY5zYS_Q-PVrUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015934.627812992@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 14/14] tracing/filter: Remove synchronize_sched() from __alloc_preds()
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-filter-Remove-synchronize_sched-from-__alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Because the filters are processed first and then activated
(added to the call), we no longer need to worry about the preds
of the filter in __alloc_preds() being used. As the filter that
is allocating preds is not activated yet.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f5d335d..3249b4f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -795,33 +795,17 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 	struct filter_pred *pred;
 	int i;
 
-	if (filter->preds) {
-		if (filter->a_preds < n_preds) {
-			/*
-			 * We need to reallocate.
-			 * We should have already have zeroed out
-			 * the pred count and called synchronized_sched()
-			 * to make sure no one is using the preds.
-			 */
-			if (WARN_ON_ONCE(filter->n_preds)) {
-				/* We need to reset it now */
-				filter->n_preds = 0;
-				synchronize_sched();
-			}
-			__free_preds(filter);
-		}
-	}
+	if (filter->preds)
+		__free_preds(filter);
+
+	filter->preds =
+		kzalloc(sizeof(*filter->preds) * n_preds, GFP_KERNEL);
 
-	if (!filter->preds) {
-		filter->preds =
-			kzalloc(sizeof(*filter->preds) * n_preds, GFP_KERNEL);
-		filter->a_preds = n_preds;
-	}
 	if (!filter->preds)
 		return -ENOMEM;
 
-	if (WARN_ON(filter->a_preds < n_preds))
-		return -EINVAL;
+	filter->a_preds = n_preds;
+	filter->n_preds = 0;
 
 	for (i = 0; i < n_preds; i++) {
 		pred = &filter->preds[i];
-- 
1.7.2.3


