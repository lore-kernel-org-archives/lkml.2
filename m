Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2EBTcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:32:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab2EBTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:40 -0400
X-Authority-Analysis: v=2.0 cv=bcnpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=jmiI158Cp2wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=fOM_VpNnRYehBkQn8CUA:9 a=GihG3io9dNuPoLFiR2kA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193237.871176027@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 8/9][RFC] ftrace/x86: Have x86 ftrace use the ftrace_modify_all_code()
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-x86-Have-x86-ftrace-use-the-ftrace_modify_all.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

To remove duplicate code, have the ftrace arch_ftrace_update_code()
use the generic ftrace_modify_all_code(). This requires that the
default ftrace_replace_code() becomes a weak function so that an
arch may override it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   15 ++-------------
 include/linux/ftrace.h   |    1 +
 kernel/trace/ftrace.c    |    4 ++--
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cf2d03e..06cfc67 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -435,7 +435,7 @@ static void run_sync(void)
 		local_irq_disable();
 }
 
-static void ftrace_replace_code(int enable)
+void ftrace_replace_code(int enable)
 {
 	struct ftrace_rec_iter *iter;
 	struct dyn_ftrace *rec;
@@ -493,18 +493,7 @@ void arch_ftrace_update_code(int command)
 {
 	modifying_ftrace_code++;
 
-	if (command & FTRACE_UPDATE_CALLS)
-		ftrace_replace_code(1);
-	else if (command & FTRACE_DISABLE_CALLS)
-		ftrace_replace_code(0);
-
-	if (command & FTRACE_UPDATE_TRACE_FUNC)
-		ftrace_update_ftrace_func(ftrace_trace_function);
-
-	if (command & FTRACE_START_FUNC_RET)
-		ftrace_enable_ftrace_graph_caller();
-	else if (command & FTRACE_STOP_FUNC_RET)
-		ftrace_disable_ftrace_graph_caller();
+	ftrace_modify_all_code(command);
 
 	modifying_ftrace_code--;
 }
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 873ceea..760845f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -314,6 +314,7 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable);
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
+extern void ftrace_replace_code(int enable);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a4ef17d..9e9eebd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1683,7 +1683,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	return -1; /* unknow ftrace bug */
 }
 
-static void ftrace_replace_code(int update)
+void __weak ftrace_replace_code(int enable)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
@@ -1693,7 +1693,7 @@ static void ftrace_replace_code(int update)
 		return;
 
 	do_for_each_ftrace_rec(pg, rec) {
-		failed = __ftrace_replace_code(rec, update);
+		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
 			ftrace_bug(failed, rec->ip);
 			/* Stop processing */
-- 
1.7.9.5


