Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1A1Eft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:35:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab1A1Edp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:45 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=CR1Lrxq07PoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=No5Jr1LyxbjlGglRNzUA:9 a=EJ-oRPYxe2Lo9mtBIfO8rEsIw64A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043344.742156218@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 06/12] tracing/filter: Free pred array on disabling of filter
References: <20110128042118.561146147@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-filter-Free-pred-array-on-disabling-of-filte.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When a filter is disabled, free the preds.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8c560eb..23753f6 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1389,6 +1389,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable_preds(call);
+		reset_preds(call->filter);
+		/* Make sure the filter is not being used */
+		synchronize_sched();
+		__free_preds(call->filter);
 		remove_filter_string(call->filter);
 		goto out_unlock;
 	}
-- 
1.7.2.3


