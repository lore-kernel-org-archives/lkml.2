Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0KIJNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:13:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:2993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0KIJMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:12:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="855641160"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        chris@chris-wilson.co.uk, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 3/4] tracing: update trace-events-sample.c
Date: Tue,  9 Nov 2010 17:12:46 +0800
Message-Id: <1289293967-31761-3-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the samples/trace_events/trace-events-sample.c to show how to use
trace_set_clr_module_event to enable some events at module load time.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 samples/trace_events/trace-events-sample.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index aabc4e9..b7212e1 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -9,7 +9,10 @@
  */
 #define CREATE_TRACE_POINTS
 #include "trace-events-sample.h"
+#include <linux/ftrace_event.h>
 
+char *sample_trace = NULL;
+module_param_named(trace, sample_trace, charp, 0400);
 
 static void simple_thread_func(int cnt)
 {
@@ -32,11 +35,18 @@ static struct task_struct *simple_tsk;
 
 static int __init trace_event_init(void)
 {
+	int ret = 0;
+
+        if (sample_trace) {
+                ret = trace_set_clr_module_event(THIS_MODULE, sample_trace, 1);
+		if (ret)
+			return ret;
+	}
+
 	simple_tsk = kthread_run(simple_thread, NULL, "event-sample");
-	if (IS_ERR(simple_tsk))
-		return -1;
+	ret = PTR_ERR(simple_tsk);
 
-	return 0;
+	return ret;
 }
 
 static void __exit trace_event_exit(void)
-- 
1.7.2.3

