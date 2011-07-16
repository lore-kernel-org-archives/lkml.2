Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1GPLX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:23:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1GPLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:57 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=q9YcuSip_usA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=2BD_jbDVSw3bbrVNNnQA:9 a=H7PyG7W4uE13GQigV44A:7 a=EvKJbDF4Ut8A:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=DIKJ85Zm1CJpZc0h:21 a=qPuyR-6qAK3KJ3aN:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112254.421302197@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/20] tracing/kprobes: Support module init function probing
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-kprobes-Support-module-init-function-probing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

To support probing module init functions, kprobe-tracer allows
user to define a probe on non-existed function when it is given
with a module name. This also enables user to set a probe on
a function on a specific module, even if a same name (but different)
function is locally defined in another module.

The module name must be in the front of function name and separated
by a ':'. e.g. btrfs:btrfs_init_sysfs

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/20110627072656.6528.89970.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/kprobetrace.txt |    9 +-
 kernel/trace/trace_kprobe.c         |  164 +++++++++++++++++++++++++++++------
 2 files changed, 143 insertions(+), 30 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index c83bd6b..d0d0bb9 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -22,14 +22,15 @@ current_tracer. Instead of that, add probe points via
 
 Synopsis of kprobe_events
 -------------------------
-  p[:[GRP/]EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
-  r[:[GRP/]EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
+  p[:[GRP/]EVENT] [MOD:]SYM[+offs]|MEMADDR [FETCHARGS]	: Set a probe
+  r[:[GRP/]EVENT] [MOD:]SYM[+0] [FETCHARGS]		: Set a return probe
   -:[GRP/]EVENT						: Clear a probe
 
  GRP		: Group name. If omitted, use "kprobes" for it.
  EVENT		: Event name. If omitted, the event name is generated
-		  based on SYMBOL+offs or MEMADDR.
- SYMBOL[+offs]	: Symbol+offset where the probe is inserted.
+		  based on SYM+offs or MEMADDR.
+ MOD		: Module name which has given SYM.
+ SYM[+offs]	: Symbol+offset where the probe is inserted.
  MEMADDR	: Address where the probe is inserted.
 
  FETCHARGS	: Arguments. Each probe can have up to 128 args.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3be50c5..acc6664 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -536,6 +536,7 @@ struct probe_arg {
 /* Flags for trace_probe */
 #define TP_FLAG_TRACE	1
 #define TP_FLAG_PROFILE	2
+#define TP_FLAG_REGISTERED 4
 
 struct trace_probe {
 	struct list_head	list;
@@ -565,6 +566,39 @@ static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
+static __kprobes unsigned long trace_probe_offset(struct trace_probe *tp)
+{
+	return tp->rp.kp.offset;
+}
+
+static __kprobes bool trace_probe_is_enabled(struct trace_probe *tp)
+{
+	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
+}
+
+static __kprobes bool trace_probe_is_registered(struct trace_probe *tp)
+{
+	return !!(tp->flags & TP_FLAG_REGISTERED);
+}
+
+static __kprobes bool trace_probe_has_gone(struct trace_probe *tp)
+{
+	return !!(kprobe_gone(&tp->rp.kp));
+}
+
+static __kprobes bool trace_probe_within_module(struct trace_probe *tp,
+						struct module *mod)
+{
+	int len = strlen(mod->name);
+	const char *name = trace_probe_symbol(tp);
+	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
+}
+
+static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
+{
+	return !!strchr(trace_probe_symbol(tp), ':');
+}
+
 static int register_probe_event(struct trace_probe *tp);
 static void unregister_probe_event(struct trace_probe *tp);
 
@@ -689,7 +723,8 @@ static int enable_trace_probe(struct trace_probe *tp, int flag)
 	int ret = 0;
 
 	tp->flags |= flag;
-	if (tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE)) {
+	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
+	    !trace_probe_has_gone(tp)) {
 		if (trace_probe_is_return(tp))
 			ret = enable_kretprobe(&tp->rp);
 		else
@@ -703,7 +738,7 @@ static int enable_trace_probe(struct trace_probe *tp, int flag)
 static void disable_trace_probe(struct trace_probe *tp, int flag)
 {
 	tp->flags &= ~flag;
-	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
+	if (!trace_probe_is_enabled(tp) && trace_probe_is_registered(tp)) {
 		if (trace_probe_is_return(tp))
 			disable_kretprobe(&tp->rp);
 		else
@@ -711,13 +746,64 @@ static void disable_trace_probe(struct trace_probe *tp, int flag)
 	}
 }
 
-/* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static void unregister_trace_probe(struct trace_probe *tp)
+/* Internal register function - just handle k*probes and flags */
+static int __register_trace_probe(struct trace_probe *tp)
 {
+	int ret;
+
+	if (trace_probe_is_registered(tp))
+		return -EINVAL;
+
+	/* Set/clear disabled flag according to tp->flag */
+	if (trace_probe_is_enabled(tp))
+		tp->rp.kp.flags &= ~KPROBE_FLAG_DISABLED;
+	else
+		tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
+
 	if (trace_probe_is_return(tp))
-		unregister_kretprobe(&tp->rp);
+		ret = register_kretprobe(&tp->rp);
 	else
-		unregister_kprobe(&tp->rp.kp);
+		ret = register_kprobe(&tp->rp.kp);
+
+	if (ret == 0)
+		tp->flags |= TP_FLAG_REGISTERED;
+	else {
+		pr_warning("Could not insert probe at %s+%lu: %d\n",
+			   trace_probe_symbol(tp), trace_probe_offset(tp), ret);
+		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
+			pr_warning("This probe might be able to register after"
+				   "target module is loaded. Continue.\n");
+			ret = 0;
+		} else if (ret == -EILSEQ) {
+			pr_warning("Probing address(0x%p) is not an "
+				   "instruction boundary.\n",
+				   tp->rp.kp.addr);
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+/* Internal unregister function - just handle k*probes and flags */
+static void __unregister_trace_probe(struct trace_probe *tp)
+{
+	if (trace_probe_is_registered(tp)) {
+		if (trace_probe_is_return(tp))
+			unregister_kretprobe(&tp->rp);
+		else
+			unregister_kprobe(&tp->rp.kp);
+		tp->flags &= ~TP_FLAG_REGISTERED;
+		/* Cleanup kprobe for reuse */
+		if (tp->rp.kp.symbol_name)
+			tp->rp.kp.addr = NULL;
+	}
+}
+
+/* Unregister a trace_probe and probe_event: call with locking probe_lock */
+static void unregister_trace_probe(struct trace_probe *tp)
+{
+	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 	unregister_probe_event(tp);
 }
@@ -730,41 +816,65 @@ static int register_trace_probe(struct trace_probe *tp)
 
 	mutex_lock(&probe_lock);
 
-	/* register as an event */
+	/* Delete old (same name) event if exist */
 	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
 	if (old_tp) {
-		/* delete old event */
 		unregister_trace_probe(old_tp);
 		free_trace_probe(old_tp);
 	}
+
+	/* Register new event */
 	ret = register_probe_event(tp);
 	if (ret) {
 		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
-	tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
-	if (trace_probe_is_return(tp))
-		ret = register_kretprobe(&tp->rp);
-	else
-		ret = register_kprobe(&tp->rp.kp);
-
-	if (ret) {
-		pr_warning("Could not insert probe(%d)\n", ret);
-		if (ret == -EILSEQ) {
-			pr_warning("Probing address(0x%p) is not an "
-				   "instruction boundary.\n",
-				   tp->rp.kp.addr);
-			ret = -EINVAL;
-		}
+	/* Register k*probe */
+	ret = __register_trace_probe(tp);
+	if (ret < 0)
 		unregister_probe_event(tp);
-	} else
+	else
 		list_add_tail(&tp->list, &probe_list);
+
 end:
 	mutex_unlock(&probe_lock);
 	return ret;
 }
 
+/* Module notifier call back, checking event on the module */
+static int trace_probe_module_callback(struct notifier_block *nb,
+				       unsigned long val, void *data)
+{
+	struct module *mod = data;
+	struct trace_probe *tp;
+	int ret;
+
+	if (val != MODULE_STATE_COMING)
+		return NOTIFY_DONE;
+
+	/* Update probes on coming module */
+	mutex_lock(&probe_lock);
+	list_for_each_entry(tp, &probe_list, list) {
+		if (trace_probe_within_module(tp, mod)) {
+			__unregister_trace_probe(tp);
+			ret = __register_trace_probe(tp);
+			if (ret)
+				pr_warning("Failed to re-register probe %s on"
+					   "%s: %d\n",
+					   tp->call.name, mod->name, ret);
+		}
+	}
+	mutex_unlock(&probe_lock);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block trace_probe_module_nb = {
+	.notifier_call = trace_probe_module_callback,
+	.priority = 1	/* Invoked after kprobe module callback */
+};
+
 /* Split symbol and offset. */
 static int split_symbol_offset(char *symbol, unsigned long *offset)
 {
@@ -990,8 +1100,8 @@ static int create_trace_probe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
-	 *  - Add kprobe: p[:[GRP/]EVENT] KSYM[+OFFS]|KADDR [FETCHARGS]
-	 *  - Add kretprobe: r[:[GRP/]EVENT] KSYM[+0] [FETCHARGS]
+	 *  - Add kprobe: p[:[GRP/]EVENT] [MOD:]KSYM[+OFFS]|KADDR [FETCHARGS]
+	 *  - Add kretprobe: r[:[GRP/]EVENT] [MOD:]KSYM[+0] [FETCHARGS]
 	 * Fetch args:
 	 *  $retval	: fetch return value
 	 *  $stack	: fetch stack address
@@ -1186,7 +1296,6 @@ static void release_all_trace_probes(void)
 	mutex_unlock(&probe_lock);
 }
 
-
 /* Probes listing interfaces */
 static void *probes_seq_start(struct seq_file *m, loff_t *pos)
 {
@@ -1827,6 +1936,9 @@ static __init int init_kprobe_trace(void)
 	struct dentry *d_tracer;
 	struct dentry *entry;
 
+	if (register_module_notifier(&trace_probe_module_nb))
+		return -EINVAL;
+
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
 		return 0;
-- 
1.7.5.4


