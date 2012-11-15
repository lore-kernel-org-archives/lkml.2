Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768244Ab2KOPdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:33:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30773 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423668Ab2KOPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:36 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Yz3Bi5mCXbAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xSQHIVwy9PUA:10 a=20KFwNOVAAAA:8 a=FmuBU-rodUV_qrTzYOYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121115153334.733070585@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 15 Nov 2012 10:30:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/8][RFC] ftrace: Fix global function tracers that are not recursion safe
References: <20121115153036.550942394@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Fix-global-function-tracers-that-are-not-recu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If one of the function tracers set by the global ops is not recursion
safe, it can still be called directly without the added recursion
supplied by the ftrace infrastructure.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4451aa3..67e886e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -221,10 +221,24 @@ static void update_global_ops(void)
 	 * registered callers.
 	 */
 	if (ftrace_global_list == &ftrace_list_end ||
-	    ftrace_global_list->next == &ftrace_list_end)
+	    ftrace_global_list->next == &ftrace_list_end) {
 		func = ftrace_global_list->func;
-	else
+		/*
+		 * As we are calling the function directly.
+		 * If it does not have recursion protection,
+		 * the function_trace_op needs to be updated
+		 * accordingly.
+		 */
+		if (ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE)
+			global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
+		else
+			global_ops.flags &= ~FTRACE_OPS_FL_RECURSION_SAFE;
+	} else {
 		func = ftrace_global_list_func;
+		/* The list has its own recursion protection. */
+		global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
+	}
+
 
 	/* If we filter on pids, update to use the pid function */
 	if (!list_empty(&ftrace_pids)) {
-- 
1.7.10.4


