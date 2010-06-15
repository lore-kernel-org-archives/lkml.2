Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0FOQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:29:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60250 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab0FOQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:29:23 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
       Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: use correct string size for snprintf
Date: Tue, 15 Jun 2010 12:29:15 -0400
Message-Id: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nsecs_str string is a local variable defined as:

char nsecs_str[5];

It is possible for the snprintf call to use a size value larger than the
size of the string. This should not cause a buffer overrun as it is
written now due to the maximum size of the string format. However, this
change makes it correct. By making the size correct we guard against
potential future changes that could actually cause a buffer overrun.

Cc: stable@kernel.org
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 kernel/trace/trace_functions_graph.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..73d6bd1 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -641,7 +641,8 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
-		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+		snprintf(nsecs_str, min(sizeof(nsecs_str), 8 - len), "%03lu",
+			 nsecs_rem);
 		ret = trace_seq_printf(s, ".%s", nsecs_str);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-- 
1.7.0.4

