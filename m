Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab1FGVaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:30:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab1FGVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:30:09 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=3Yp08V7tlJQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=enOvQawGAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=uYu6aynSuKuM8678MIoA:9 a=x2s00ahUVQyVQlg42cwA:7 a=jEp0ucaQiEUA:10 a=bkT6KWdcy0IA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110607213007.312394187@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Jun 2011 17:29:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 2/3 v2] kprobes/trace: Fix kprobe selftest for gcc 4.6
References: <20110607212937.662660421@goodmis.org>
Content-Disposition: inline; filename=0002-kprobes-trace-Fix-kprobe-selftest-for-gcc-4.6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With gcc 4.6, the self test kprobe function:

 kprobe_trace_selftest_target()

is optimized such that kallsyms does not list it. The kprobes
test uses this function to insert a probe and test it. But
it will fail the test if the function is not listed in kallsyms.

Adding a __used annotation keeps the symbol in the kallsyms table.

Suggested-by: David Daney <ddaney@caviumnetworks.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f925c45..27d13b3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1870,8 +1870,12 @@ fs_initcall(init_kprobe_trace);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 
-static int kprobe_trace_selftest_target(int a1, int a2, int a3,
-					int a4, int a5, int a6)
+/*
+ * The "__used" keeps gcc from removing the function symbol
+ * from the kallsyms table.
+ */
+static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
+					       int a4, int a5, int a6)
 {
 	return a1 + a2 + a3 + a4 + a5 + a6;
 }
-- 
1.7.4.4


