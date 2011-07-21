Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1GUKDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:03:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:55931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1GUKD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:03:28 -0400
Date: Thu, 21 Jul 2011 10:02:59 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-7f6878a3d707b947603e09d95df0c3a98987e3a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110627072703.6528.75042.stgit@fedora15>
References: <20110627072703.6528.75042.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Update symbol reference when loading module
Git-Commit-ID: 7f6878a3d707b947603e09d95df0c3a98987e3a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:03:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f6878a3d707b947603e09d95df0c3a98987e3a4
Gitweb:     http://git.kernel.org/tip/7f6878a3d707b947603e09d95df0c3a98987e3a4
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:27:03 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 15 Jul 2011 15:45:32 -0400

tracing/kprobe: Update symbol reference when loading module

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
