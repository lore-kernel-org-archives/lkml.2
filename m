Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0HKTCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:02:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0HKTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:02:32 -0400
X-Authority-Analysis: v=1.1 cv=FLDyhxrUEZZDQYGWQdnXfbzWjjll+fIPMqQTcKt1R7E= c=1 sm=0 a=-fSXZVlqRNsA:10 a=GzHTLUccyWwA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=9S3UKyfeZDZYB59E7aAA:9 a=OXRP1B3BiH3-b4xzPtKWj54JYYEA:4 a=dGJ0OcVc7YAA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Message-Id: <20100811190231.056258855@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 11 Aug 2010 15:01:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@kernel.org>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 1/2] tracing: Fix an unallocated memory access in function_graph
References: <20100811190143.688551293@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-an-unallocated-memory-access-in-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

With CONFIG_DEBUG_PAGEALLOC, I observed an unallocated memory access in
function_graph trace. It appears we find a small size entry in ring buffer,
but we access it as a big size entry. The access overflows the page size
and touches an unallocated page.

Cc: <stable@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
[ Added a comment to explain the problem - SDR ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..b4c179a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -507,7 +507,15 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * if the output fails.
 			 */
 			data->ent = *curr;
-			data->ret = *next;
+			/*
+			 * If the next event is not a return type, then
+			 * we only care about what type it is. Otherwise we can
+			 * safely copy the entire event.
+			 */
+			if (next->ent.type == TRACE_GRAPH_RET)
+				data->ret = *next;
+			else
+				data->ret.ent.type = next->ent.type;
 		}
 	}
 
-- 
1.7.1


