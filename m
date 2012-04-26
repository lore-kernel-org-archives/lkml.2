Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab2DZSgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:36:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab2DZSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:11 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=y7GcWl15xuwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=OqTQCXyy1yd9_HH2JnIA:9 a=BNVjqk_ySr-8pj7t4CsA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426183508.749515835@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 26 Apr 2012 14:31:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/3][RFC] ftrace/ppc: Have PPC skip updating with stop_machine()
References: <20120426183116.857877522@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-ppc-Have-PPC-skip-updating-with-stop_machine.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

PPC does not have the synchronization issues that x86 has with
modifying code on one CPU while another CPU is executing it.
The other CPU will either see the old or new code without any
issues, unlike x86 which may issue a GPF.

Instead of calling the heavy stop_machine, just update the code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/ftrace.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index bf99cfa..84a5ddd 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -484,6 +484,58 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
+static int __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr = (unsigned long)FTRACE_ADDR;
+	int ret;
+
+	ret = ftrace_update_record(rec, enable);
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+	case FTRACE_UPDATE_MAKE_CALL:
+		return ftrace_make_call(rec, ftrace_addr);
+	case FTRACE_UPDATE_MAKE_NOP:
+		return ftrace_make_nop(NULL, rec, ftrace_addr);
+	}
+
+	return 0;
+}
+
+static void ftrace_replace_code(int enable)
+{
+	struct ftrace_rec_iter *iter;
+	struct dyn_ftrace *rec;
+	int ret;
+
+	for (iter = ftrace_rec_iter_start(); iter;
+	     iter = ftrace_rec_iter_next(iter)) {
+		rec = ftrace_rec_iter_record(iter);
+		ret = __ftrace_replace_code(rec, enable);
+		if (ret) {
+			ftrace_bug(ret, rec->ip);
+			return;
+		}
+	}
+}
+
+void arch_ftrace_update_code(int command)
+{
+	if (command & FTRACE_UPDATE_CALLS)
+		ftrace_replace_code(1);
+	else if (command & FTRACE_DISABLE_CALLS)
+		ftrace_replace_code(0);
+
+	if (command & FTRACE_UPDATE_TRACE_FUNC)
+		ftrace_update_ftrace_func(ftrace_trace_function);
+
+	if (command & FTRACE_START_FUNC_RET)
+		ftrace_enable_ftrace_graph_caller();
+	else if (command & FTRACE_STOP_FUNC_RET)
+		ftrace_disable_ftrace_graph_caller();
+}
+
 int __init ftrace_dyn_arch_init(void *data)
 {
 	/* caller expects data to be zero */
-- 
1.7.9.5


