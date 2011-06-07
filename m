Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab1FGRIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:08:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab1FGRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:08:29 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=fXGGLInXz8AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=uYu6aynSuKuM8678MIoA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110607170827.295368694@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Jun 2011 13:07:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 2/3] kprobes/trace: Fix kprobe selftest for gcc 4.6
References: <20110607170740.235441001@goodmis.org>
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

Because the name is rather unique, converting it from static to
global should not be a problem. This prevents gcc from removing
it from kallsyms.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f925c45..2c14378 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1870,8 +1870,12 @@ fs_initcall(init_kprobe_trace);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 
-static int kprobe_trace_selftest_target(int a1, int a2, int a3,
-					int a4, int a5, int a6)
+/*
+ * Can't be static, otherwise gcc might optimize this to
+ * not be in the kallsyms table.
+ */
+int kprobe_trace_selftest_target(int a1, int a2, int a3,
+				 int a4, int a5, int a6)
 {
 	return a1 + a2 + a3 + a4 + a5 + a6;
 }
-- 
1.7.4.4


