Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1GPLXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:23:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1GPLW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:56 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Wy9HXXmUy0YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=LLea6Ft-gPtGswe3wi4A:9 a=FaOcuZ_Y4NCV_UzgG0sA:7 a=EvKJbDF4Ut8A:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112254.700623532@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/20] tracing/kprobe: Update symbol reference when loading module
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-kprobe-Update-symbol-reference-when-loading-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Since the address of a module-local variable can only be
solved after the target module is loaded, the symbol
fetch-argument should be updated when loading target
module.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/20110627072703.6528.75042.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index acc6664..5fb3697 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -343,6 +343,14 @@ DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
 DEFINE_FETCH_deref(string_size)
 
+static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
+{
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
+		update_deref_fetch_param(data->orig.data);
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
+		update_symbol_cache(data->orig.data);
+}
+
 static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 {
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
@@ -377,6 +385,19 @@ DEFINE_BASIC_FETCH_FUNCS(bitfield)
 #define fetch_bitfield_string_size NULL
 
 static __kprobes void
+update_bitfield_fetch_param(struct bitfield_fetch_param *data)
+{
+	/*
+	 * Don't check the bitfield itself, because this must be the
+	 * last fetch function.
+	 */
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
+		update_deref_fetch_param(data->orig.data);
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
+		update_symbol_cache(data->orig.data);
+}
+
+static __kprobes void
 free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
@@ -389,6 +410,7 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 		free_symbol_cache(data->orig.data);
 	kfree(data);
 }
+
 /* Default (unsigned long) fetch type */
 #define __DEFAULT_FETCH_TYPE(t) u##t
 #define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
@@ -680,6 +702,16 @@ error:
 	return ERR_PTR(ret);
 }
 
+static void update_probe_arg(struct probe_arg *arg)
+{
+	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
+		update_bitfield_fetch_param(arg->fetch.data);
+	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
+		update_deref_fetch_param(arg->fetch.data);
+	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
+		update_symbol_cache(arg->fetch.data);
+}
+
 static void free_probe_arg(struct probe_arg *arg)
 {
 	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
@@ -749,11 +781,14 @@ static void disable_trace_probe(struct trace_probe *tp, int flag)
 /* Internal register function - just handle k*probes and flags */
 static int __register_trace_probe(struct trace_probe *tp)
 {
-	int ret;
+	int i, ret;
 
 	if (trace_probe_is_registered(tp))
 		return -EINVAL;
 
+	for (i = 0; i < tp->nr_args; i++)
+		update_probe_arg(&tp->args[i]);
+
 	/* Set/clear disabled flag according to tp->flag */
 	if (trace_probe_is_enabled(tp))
 		tp->rp.kp.flags &= ~KPROBE_FLAG_DISABLED;
-- 
1.7.5.4


