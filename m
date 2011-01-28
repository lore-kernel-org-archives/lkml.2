Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1A1Edq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:33:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1A1Edp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:45 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=Jl7PdmRC0h4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=MW1-nspqn-TxXM5hiR0A:9 a=Wk_mXkwSAfjt92R4BjkA:7 a=HEYOzX8zS-ewpbxyu3rNN3PY1JIA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043343.452376340@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 01/12] tracing/filter: Have no filter return a match
References: <20110128042118.561146147@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-filter-Have-no-filter-return-a-match.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The n_preds field of a file can change at anytime, and even can become
zero, just as the filter is about to be processed by an event.
In the case that is zero on entering the filter, return 1, telling
the caller the event matchs and should be trace.

Also use a variable and assign it with ACCESS_ONCE() such that the
count stays consistent within the function.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 36d4010..7275f03 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -383,9 +383,14 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 	int match, top = 0, val1 = 0, val2 = 0;
 	int stack[MAX_FILTER_PRED];
 	struct filter_pred *pred;
+	int n_preds = ACCESS_ONCE(filter->n_preds);
 	int i;
 
-	for (i = 0; i < filter->n_preds; i++) {
+	/* no filter is considered a match */
+	if (!n_preds)
+		return 1;
+
+	for (i = 0; i < n_preds; i++) {
 		pred = filter->preds[i];
 		if (!pred->pop_n) {
 			match = pred->fn(pred, rec, val1, val2);
-- 
1.7.2.3


