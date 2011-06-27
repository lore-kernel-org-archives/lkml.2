Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1F1MDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:03:42 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55215 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab1F1L5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:57:34 -0400
X-AuditID: b753bd60-a0a78ba0000050a4-67-4e09c1abbd0a
X-AuditID: b753bd60-a0a78ba0000050a4-67-4e09c1abbd0a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 05/13] tracing/kprobe: Update symbol reference when
 loading module
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 27 Jun 2011 16:27:03 +0900
Message-ID: <20110627072703.6528.75042.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the address of a module-local variable can only be
solved after the target module is loaded, the symbol
fetch-argument should be updated when loading target
module.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 kernel/trace/trace_kprobe.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5a385ec..bdb8030 100644
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

