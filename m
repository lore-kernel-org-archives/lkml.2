Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1F1MDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:03:38 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54225 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab1F1L51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:57:27 -0400
X-AuditID: b753bd60-a287bba0000050a4-4f-4e09c1a502f0
X-AuditID: b753bd60-a287bba0000050a4-4f-4e09c1a502f0
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 04/13] tracing/kprobes: Support module init function
 probing
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
Date: Mon, 27 Jun 2011 16:26:56 +0900
Message-ID: <20110627072656.6528.89970.stgit@fedora15>
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

To support probing module init functions, kprobe-tracer allows
user to define a probe on non-existed function when it is given
with a module name. This also enables user to set a probe on
a function on a specific module, even if a same name (but different)
function is locally defined in another module.

The module name must be in the front of function name and separated
by a ':'. e.g. btrfs:btrfs_init_sysfs

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index ce5e6aa..5a385ec 100644
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
@@ -1825,6 +1934,9 @@ static __init int init_kprobe_trace(void)
 	struct dentry *d_tracer;
 	struct dentry *entry;
 
+	if (register_module_notifier(&trace_probe_module_nb))
+		return -EINVAL;
+
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
 		return 0;

