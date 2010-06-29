Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0F2DMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:12:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0F2DKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:46 -0400
X-Authority-Analysis: v=1.1 cv=4GK1Slht3WUdSXXcSOu+TCe3GQnvEFDsQSvVHKX2gdo= c=1 sm=0 a=kCOdILz_--8A:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=DfNHnWVPAAAA:8 a=meVymXHHAAAA:8 a=OmWx_Ei-vZGLHS3O8-IA:9 a=8670kolLWbrwiF4xID4A:7 a=3uRNDRfgckDEUsPC8z8yy0H2-8MA:4 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031044.693053496@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH 8/9] tracing/function-graph: Use correct string size for snprintf
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-function-graph-Use-correct-string-size-for-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@canonical.com>

The nsecs_str string is a local variable defined as:

char nsecs_str[5];

It is possible for the snprintf call to use a size value larger than the
size of the string. This should not cause a buffer overrun as it is
written now due to the value for the string format "%03lu" can not be
larger than 1000. However, this change makes it correct. By making the
size correct we guard against potential future changes that could actually
cause a buffer overrun.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
LKML-Reference: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>

[ added 'UL' to number 8 to fix gcc warning comparing it to sizeof() ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..6bff236 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -641,7 +641,8 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
-		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+		snprintf(nsecs_str, min(sizeof(nsecs_str), 8UL - len), "%03lu",
+			 nsecs_rem);
 		ret = trace_seq_printf(s, ".%s", nsecs_str);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-- 
1.7.1


