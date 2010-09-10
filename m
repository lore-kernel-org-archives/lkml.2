Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab0IJO0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:26:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab0IJO0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:26:35 -0400
Date: Fri, 10 Sep 2010 16:26:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100910142618.GA13155@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

Jovi Zhang (1):
      perf symbols: Fix multiple initialization of symbol system

Li Zefan (1):
      perf, trace: Fix module leak

Masami Hiramatsu (5):
      tracing/kprobe: Fix a memory leak in error case
      perf probe: Fix return probe support
      perf probe: Fix handling of arguments names
      tracing/kprobes: Fix handling of argument names
      tracing/kprobe: Fix handling of C-unlike argument names

Peter Zijlstra (1):
      perf: Fix CPU hotplug

Steven Rostedt (1):
      tracing: Do not allow llseek to set_ftrace_filter


 kernel/perf_event.c             |    6 ++--
 kernel/trace/ftrace.c           |    4 ++-
 kernel/trace/trace_event_perf.c |    3 ++
 kernel/trace/trace_kprobe.c     |   43 ++++++++++++++++++++++----------------
 tools/perf/util/probe-event.c   |    1 +
 tools/perf/util/probe-finder.c  |   42 ++++++++++++++++++++++++++-----------
 tools/perf/util/symbol.c        |    7 ++++++
 tools/perf/util/symbol.h        |    3 +-
 8 files changed, 73 insertions(+), 36 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 657555a..db5b560 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5761,15 +5761,15 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
 		perf_event_init_cpu(cpu);
 		break;
 
+	case CPU_UP_CANCELED:
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		perf_event_exit_cpu(cpu);
 		break;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7cb1f45..fa7ece6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1510,6 +1510,8 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
+		/* reset in case of seek/pread */
+		iter->flags &= ~FTRACE_ITER_HASH;
 		return iter;
 	}
 
@@ -2416,7 +2418,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = no_llseek,
 	.release = ftrace_filter_release,
 };
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 000e6e8..31cc4cb 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -91,6 +91,8 @@ int perf_trace_init(struct perf_event *p_event)
 		    tp_event->class && tp_event->class->reg &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
+			if (ret)
+				module_put(tp_event->mod);
 			break;
 		}
 	}
@@ -146,6 +148,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 		}
 	}
 out:
+	module_put(tp_event->mod);
 	mutex_unlock(&event_mutex);
 }
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 8b27c98..544301d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -514,8 +514,8 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
-/* Check the name is good for event/group */
-static int check_event_name(const char *name)
+/* Check the name is good for event/group/fields */
+static int is_good_name(const char *name)
 {
 	if (!isalpha(*name) && *name != '_')
 		return 0;
@@ -557,7 +557,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	else
 		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
-	if (!event || !check_event_name(event)) {
+	if (!event || !is_good_name(event)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -567,7 +567,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	if (!tp->call.name)
 		goto error;
 
-	if (!group || !check_event_name(group)) {
+	if (!group || !is_good_name(group)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -883,7 +883,7 @@ static int create_trace_probe(int argc, char **argv)
 	int i, ret = 0;
 	int is_return = 0, is_delete = 0;
 	char *symbol = NULL, *event = NULL, *group = NULL;
-	char *arg, *tmp;
+	char *arg;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
@@ -992,26 +992,36 @@ static int create_trace_probe(int argc, char **argv)
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		/* Increment count for freeing args in error case */
+		tp->nr_args++;
+
 		/* Parse argument name */
 		arg = strchr(argv[i], '=');
-		if (arg)
+		if (arg) {
 			*arg++ = '\0';
-		else
+			tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+		} else {
 			arg = argv[i];
+			/* If argument name is omitted, set "argN" */
+			snprintf(buf, MAX_EVENT_NAME_LEN, "arg%d", i + 1);
+			tp->args[i].name = kstrdup(buf, GFP_KERNEL);
+		}
 
-		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
 		if (!tp->args[i].name) {
-			pr_info("Failed to allocate argument%d name '%s'.\n",
-				i, argv[i]);
+			pr_info("Failed to allocate argument[%d] name.\n", i);
 			ret = -ENOMEM;
 			goto error;
 		}
-		tmp = strchr(tp->args[i].name, ':');
-		if (tmp)
-			*tmp = '_';	/* convert : to _ */
+
+		if (!is_good_name(tp->args[i].name)) {
+			pr_info("Invalid argument[%d] name: %s\n",
+				i, tp->args[i].name);
+			ret = -EINVAL;
+			goto error;
+		}
 
 		if (conflict_field_name(tp->args[i].name, tp->args, i)) {
-			pr_info("Argument%d name '%s' conflicts with "
+			pr_info("Argument[%d] name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
 			goto error;
@@ -1020,12 +1030,9 @@ static int create_trace_probe(int argc, char **argv)
 		/* Parse fetch argument */
 		ret = parse_probe_arg(arg, tp, &tp->args[i], is_return);
 		if (ret) {
-			pr_info("Parse error at argument%d. (%d)\n", i, ret);
-			kfree(tp->args[i].name);
+			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
 		}
-
-		tp->nr_args++;
 	}
 
 	ret = register_trace_probe(tp);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e72f05c..fcc16e4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1539,6 +1539,7 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		goto error;
 	}
 	tev->point.offset = pev->point.offset;
+	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
 	if (tev->nargs) {
 		tev->args = zalloc(sizeof(struct probe_trace_arg)
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5251366..32b81f7 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -686,6 +686,25 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	char buf[32], *ptr;
 	int ret, nscopes;
 
+	if (!is_c_varname(pf->pvar->var)) {
+		/* Copy raw parameters */
+		pf->tvar->value = strdup(pf->pvar->var);
+		if (pf->tvar->value == NULL)
+			return -ENOMEM;
+		if (pf->pvar->type) {
+			pf->tvar->type = strdup(pf->pvar->type);
+			if (pf->tvar->type == NULL)
+				return -ENOMEM;
+		}
+		if (pf->pvar->name) {
+			pf->tvar->name = strdup(pf->pvar->name);
+			if (pf->tvar->name == NULL)
+				return -ENOMEM;
+		} else
+			pf->tvar->name = NULL;
+		return 0;
+	}
+
 	if (pf->pvar->name)
 		pf->tvar->name = strdup(pf->pvar->name);
 	else {
@@ -700,19 +719,6 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (pf->tvar->name == NULL)
 		return -ENOMEM;
 
-	if (!is_c_varname(pf->pvar->var)) {
-		/* Copy raw parameters */
-		pf->tvar->value = strdup(pf->pvar->var);
-		if (pf->tvar->value == NULL)
-			return -ENOMEM;
-		if (pf->pvar->type) {
-			pf->tvar->type = strdup(pf->pvar->type);
-			if (pf->tvar->type == NULL)
-				return -ENOMEM;
-		}
-		return 0;
-	}
-
 	pr_debug("Searching '%s' variable in context.\n",
 		 pf->pvar->var);
 	/* Search child die for local variables and parameters. */
@@ -783,6 +789,16 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 		/* This function has no name. */
 		tev->point.offset = (unsigned long)pf->addr;
 
+	/* Return probe must be on the head of a subprogram */
+	if (pf->pev->point.retprobe) {
+		if (tev->point.offset != 0) {
+			pr_warning("Return probe must be on the head of"
+				   " a real function\n");
+			return -EINVAL;
+		}
+		tev->point.retprobe = true;
+	}
+
 	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
 		 tev->point.offset);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1a36773..b2f5ae9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2268,6 +2268,9 @@ static int setup_list(struct strlist **list, const char *list_str,
 
 int symbol__init(void)
 {
+	if (symbol_conf.initialized)
+		return 0;
+
 	elf_version(EV_CURRENT);
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
@@ -2293,6 +2296,7 @@ int symbol__init(void)
 		       symbol_conf.sym_list_str, "symbol") < 0)
 		goto out_free_comm_list;
 
+	symbol_conf.initialized = true;
 	return 0;
 
 out_free_dso_list:
@@ -2304,11 +2308,14 @@ out_free_comm_list:
 
 void symbol__exit(void)
 {
+	if (!symbol_conf.initialized)
+		return;
 	strlist__delete(symbol_conf.sym_list);
 	strlist__delete(symbol_conf.dso_list);
 	strlist__delete(symbol_conf.comm_list);
 	vmlinux_path__exit();
 	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
+	symbol_conf.initialized = false;
 }
 
 int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b7a8da4..ea95c27 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -69,7 +69,8 @@ struct symbol_conf {
 			show_nr_samples,
 			use_callchain,
 			exclude_other,
-			show_cpu_utilization;
+			show_cpu_utilization,
+			initialized;
 	const char	*vmlinux_name,
 			*source_prefix,
 			*field_sep;
