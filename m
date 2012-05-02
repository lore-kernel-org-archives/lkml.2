Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2EBTd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:33:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2EBTcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:39 -0400
X-Authority-Analysis: v=2.0 cv=fvFelSEf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=q0FNn9v7LI4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=reo06KVvno3Mf215nIEA:9 a=Di4IDHX3orKPkm3snHAA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193237.608577260@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 7/9][RFC] ftrace: Make ftrace_modify_all_code() global for archs to use
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Make-ftrace_modify_all_code-global-for-archs-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Rename __ftrace_modify_code() to ftrace_modify_all_code() and make
it global for all archs to use. This will remove the duplication
of code, as archs that can modify code without stop_machine()
can use it directly outside of the stop_machine() call.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    2 ++
 kernel/trace/ftrace.c  |   21 +++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 211ae45..873ceea 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -319,6 +319,8 @@ extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
 
+void ftrace_modify_all_code(int command);
+
 #ifndef FTRACE_ADDR
 #define FTRACE_ADDR ((unsigned long)ftrace_caller)
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7e3c398..a4ef17d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1811,22 +1811,27 @@ int __weak ftrace_arch_code_modify_post_process(void)
 	return 0;
 }
 
-static int __ftrace_modify_code(void *data)
+void ftrace_modify_all_code(int command)
 {
-	int *command = data;
-
-	if (*command & FTRACE_UPDATE_CALLS)
+	if (command & FTRACE_UPDATE_CALLS)
 		ftrace_replace_code(1);
-	else if (*command & FTRACE_DISABLE_CALLS)
+	else if (command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
 
-	if (*command & FTRACE_UPDATE_TRACE_FUNC)
+	if (command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
 
-	if (*command & FTRACE_START_FUNC_RET)
+	if (command & FTRACE_START_FUNC_RET)
 		ftrace_enable_ftrace_graph_caller();
-	else if (*command & FTRACE_STOP_FUNC_RET)
+	else if (command & FTRACE_STOP_FUNC_RET)
 		ftrace_disable_ftrace_graph_caller();
+}
+
+static int __ftrace_modify_code(void *data)
+{
+	int *command = data;
+
+	ftrace_modify_all_code(*command);
 
 	return 0;
 }
-- 
1.7.9.5


