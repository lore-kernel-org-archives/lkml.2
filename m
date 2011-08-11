Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1HKISR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:18:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1HKISK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:18:10 -0400
Date: Thu, 11 Aug 2011 10:17:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110811081704.GA8141@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (4):
      perf evlist: Introduce 'disable' method
      perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables
      perf report: Use ui__warning in some more places
      perf tools: Check $HOME/.perfconfig ownership

Han Pingtian (1):
      perf buildid-cache: Zero out buffer of filenames when adding/removing buildid

Jason Baron (1):
      jump label: Reduce the cycle count by changing the link order

Jesper Juhl (1):
      trace events: Update version number reference to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED

Jiri Olsa (3):
      perf tools: Add support to install perf python extension
      perf sched: Do not delete session object prematurely
      perf sched: Usage leftover from trace -> script rename

Jonathan Nieder (1):
      perf tools: do not look at ./config for configuration

Jovi Zhang (1):
      perf probe: Fix coredump introduced by probe module option

Kusanagi Kouichi (1):
      perf tools: Make clean leaves some files

Pekka Enberg (1):
      perf symbols: Check '/tmp/perf-' symbol file ownership

Youquan Song (1):
      perf, x86: Add model 45 SandyBridge support

Zhu Yanhai (1):
      perf lock: Dropping unsupported ':r' modifier


 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 kernel/Makefile                        |    3 +-
 kernel/trace/Kconfig                   |    2 +-
 tools/perf/Makefile                    |   21 ++++--
 tools/perf/builtin-lock.c              |    8 +-
 tools/perf/builtin-record.c            |   19 +-----
 tools/perf/builtin-report.c            |   15 ++--
 tools/perf/builtin-sched.c             |   24 +++++--
 tools/perf/util/config.c               |   32 ++++++---
 tools/perf/util/evlist.c               |   13 ++++
 tools/perf/util/evlist.h               |    2 +
 tools/perf/util/header.c               |    8 +-
 tools/perf/util/probe-event.c          |   12 ++-
 tools/perf/util/python.c               |  115 +++++++++++++++++++++++++++++++-
 tools/perf/util/setup.py               |   21 ++++++-
 tools/perf/util/symbol.c               |   11 +++
 16 files changed, 239 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 45fbb8f..f88af2c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1590,6 +1590,7 @@ static __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
+	case 45: /* SandyBridge, "Romely-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
diff --git a/kernel/Makefile b/kernel/Makefile
index d06467f..eca595e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
@@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
+obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2ad39e5..cd31345 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -82,7 +82,7 @@ config EVENT_POWER_TRACING_DEPRECATED
 	  power:power_frequency
 	  This is for userspace compatibility
 	  and will vanish after 5 kernel iterations,
-	  namely 2.6.41.
+	  namely 3.1.
 
 config CONTEXT_SWITCH_TRACER
 	bool
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 56d62d3..3b8f7b8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -181,9 +181,9 @@ strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
-	  --quiet build_ext \
-	  --build-lib='$(OUTPUT)python' \
-	  --build-temp='$(OUTPUT)python/temp'
+	  --quiet build_ext; \
+	mkdir -p $(OUTPUT)python && \
+	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
 #
 # No Perl scripts right now:
 #
@@ -509,9 +509,13 @@ else
 
   PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  python-clean := $(PYTHON_WORD) util/setup.py clean \
-    --build-lib='$(OUTPUT)python' \
-    --build-temp='$(OUTPUT)python/temp'
+  # python extension build directories
+  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+  PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+  PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+  export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+
+  python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
   ifdef NO_LIBPYTHON
     $(call disable-python)
@@ -868,6 +872,9 @@ install: all
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 
+install-python_ext:
+	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
+
 install-doc:
 	$(MAKE) -C Documentation install
 
@@ -895,7 +902,7 @@ quick-install-html:
 ### Cleaning rules
 
 clean:
-	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9ac05aa..899080a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -942,10 +942,10 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "lock:lock_acquire:r",
-	"-e", "lock:lock_acquired:r",
-	"-e", "lock:lock_contended:r",
-	"-e", "lock:lock_release:r",
+	"-e", "lock:lock_acquire",
+	"-e", "lock:lock_acquired",
+	"-e", "lock:lock_contended",
+	"-e", "lock:lock_release",
 };
 
 static int __cmd_record(int argc, const char **argv)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 80dc5b7..f6426b4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,8 +30,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -438,7 +436,6 @@ static void mmap_read_all(void)
 
 static int __cmd_record(int argc, const char **argv)
 {
-	int i;
 	struct stat st;
 	int flags;
 	int err;
@@ -682,7 +679,6 @@ static int __cmd_record(int argc, const char **argv)
 
 	for (;;) {
 		int hits = samples;
-		int thread;
 
 		mmap_read_all();
 
@@ -693,19 +689,8 @@ static int __cmd_record(int argc, const char **argv)
 			waking++;
 		}
 
-		if (done) {
-			for (i = 0; i < evsel_list->cpus->nr; i++) {
-				struct perf_evsel *pos;
-
-				list_for_each_entry(pos, &evsel_list->entries, node) {
-					for (thread = 0;
-						thread < evsel_list->threads->nr;
-						thread++)
-						ioctl(FD(pos, i, thread),
-							PERF_EVENT_IOC_DISABLE);
-				}
-			}
-		}
+		if (done)
+			perf_evlist__disable(evsel_list);
 	}
 
 	if (quiet || signr == SIGUSR1)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f854efd..d7ff277 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -162,23 +162,22 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 {
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
-			fprintf(stderr, "selected --sort parent, but no"
-					" callchain data. Did you call"
-					" perf record without -g?\n");
+			ui__warning("Selected --sort parent, but no "
+				    "callchain data. Did you call "
+				    "'perf record' without -g?\n");
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			fprintf(stderr, "selected -g but no callchain data."
-					" Did you call perf record without"
-					" -g?\n");
+			ui__warning("Selected -g but no callchain data. Did "
+				    "you call 'perf record' without -g?\n");
 			return -1;
 		}
 	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE &&
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (callchain_register_param(&callchain_param) < 0) {
-				fprintf(stderr, "Can't register callchain"
-						" params\n");
+				ui__warning("Can't register callchain "
+					    "params.\n");
 				return -EINVAL;
 			}
 	}
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index dcfe887..5177964 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1637,23 +1637,29 @@ static struct perf_event_ops event_ops = {
 	.ordered_samples	= true,
 };
 
-static int read_events(void)
+static void read_events(bool destroy, struct perf_session **psession)
 {
 	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 0, false, &event_ops);
 	if (session == NULL)
-		return -ENOMEM;
+		die("No Memory");
 
 	if (perf_session__has_traces(session, "record -R")) {
 		err = perf_session__process_events(session, &event_ops);
+		if (err)
+			die("Failed to process events, error %d", err);
+
 		nr_events      = session->hists.stats.nr_events[0];
 		nr_lost_events = session->hists.stats.total_lost;
 		nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
 	}
 
-	perf_session__delete(session);
-	return err;
+	if (destroy)
+		perf_session__delete(session);
+
+	if (psession)
+		*psession = session;
 }
 
 static void print_bad_events(void)
@@ -1689,9 +1695,10 @@ static void print_bad_events(void)
 static void __cmd_lat(void)
 {
 	struct rb_node *next;
+	struct perf_session *session;
 
 	setup_pager();
-	read_events();
+	read_events(false, &session);
 	sort_lat();
 
 	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
@@ -1717,6 +1724,7 @@ static void __cmd_lat(void)
 	print_bad_events();
 	printf("\n");
 
+	perf_session__delete(session);
 }
 
 static struct trace_sched_handler map_ops  = {
@@ -1731,7 +1739,7 @@ static void __cmd_map(void)
 	max_cpu = sysconf(_SC_NPROCESSORS_CONF);
 
 	setup_pager();
-	read_events();
+	read_events(true, NULL);
 	print_bad_events();
 }
 
@@ -1744,7 +1752,7 @@ static void __cmd_replay(void)
 
 	test_calibrations();
 
-	read_events();
+	read_events(true, NULL);
 
 	printf("nr_run_events:        %ld\n", nr_run_events);
 	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
@@ -1769,7 +1777,7 @@ static void __cmd_replay(void)
 
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|map|replay|trace}",
+	"perf sched [<options>] {record|latency|map|replay|script}",
 	NULL
 };
 
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index e02d78c..fe02903 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -399,7 +399,6 @@ static int perf_config_global(void)
 int perf_config(config_fn_t fn, void *data)
 {
 	int ret = 0, found = 0;
-	char *repo_config = NULL;
 	const char *home = NULL;
 
 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
@@ -414,19 +413,32 @@ int perf_config(config_fn_t fn, void *data)
 	home = getenv("HOME");
 	if (perf_config_global() && home) {
 		char *user_config = strdup(mkpath("%s/.perfconfig", home));
-		if (!access(user_config, R_OK)) {
-			ret += perf_config_from_file(fn, user_config, data);
-			found += 1;
+		struct stat st;
+
+		if (user_config == NULL) {
+			warning("Not enough memory to process %s/.perfconfig, "
+				"ignoring it.", home);
+			goto out;
 		}
-		free(user_config);
-	}
 
-	repo_config = perf_pathdup("config");
-	if (!access(repo_config, R_OK)) {
-		ret += perf_config_from_file(fn, repo_config, data);
+		if (stat(user_config, &st) < 0)
+			goto out_free;
+
+		if (st.st_uid && (st.st_uid != geteuid())) {
+			warning("File %s not owned by current user or root, "
+				"ignoring it.", user_config);
+			goto out_free;
+		}
+
+		if (!st.st_size)
+			goto out_free;
+
+		ret += perf_config_from_file(fn, user_config, data);
 		found += 1;
+out_free:
+		free(user_config);
 	}
-	free(repo_config);
+out:
 	if (found == 0)
 		return -1;
 	return ret;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b021ea9..e03e7bc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -91,6 +91,19 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	return 0;
 }
 
+void perf_evlist__disable(struct perf_evlist *evlist)
+{
+	int cpu, thread;
+	struct perf_evsel *pos;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		list_for_each_entry(pos, &evlist->entries, node) {
+			for (thread = 0; thread < evlist->threads->nr; thread++)
+				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+		}
+	}
+}
+
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b2b8623..ce85ae9 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -53,6 +53,8 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
+void perf_evlist__disable(struct perf_evlist *evlist);
+
 static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 					 struct cpu_map *cpus,
 					 struct thread_map *threads)
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index cb2959a..d4f3101 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -189,8 +189,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
-	char *realname, *filename = malloc(size),
-	     *linkname = malloc(size), *targetname;
+	char *realname, *filename = zalloc(size),
+	     *linkname = zalloc(size), *targetname;
 	int len, err = -1;
 
 	if (is_kallsyms) {
@@ -254,8 +254,8 @@ static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 {
 	const size_t size = PATH_MAX;
-	char *filename = malloc(size),
-	     *linkname = malloc(size);
+	char *filename = zalloc(size),
+	     *linkname = zalloc(size);
 	int err = -1;
 
 	if (filename == NULL || linkname == NULL)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b82d54f..1c7bfa5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1820,11 +1820,15 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		ret = -ENOMEM;
 		goto error;
 	}
-	tev->point.module = strdup(module);
-	if (tev->point.module == NULL) {
-		ret = -ENOMEM;
-		goto error;
+
+	if (module) {
+		tev->point.module = strdup(module);
+		if (tev->point.module == NULL) {
+			ret = -ENOMEM;
+			goto error;
+		}
 	}
+
 	tev->point.offset = pev->point.offset;
 	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 8e0b5a3..cbc8f21 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -187,16 +187,119 @@ static PyTypeObject pyrf_throttle_event__type = {
 	.tp_repr	= (reprfunc)pyrf_throttle_event__repr,
 };
 
+static char pyrf_lost_event__doc[] = PyDoc_STR("perf lost event object.");
+
+static PyMemberDef pyrf_lost_event__members[] = {
+	sample_members
+	member_def(lost_event, id, T_ULONGLONG, "event id"),
+	member_def(lost_event, lost, T_ULONGLONG, "number of lost events"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_lost_event__repr(struct pyrf_event *pevent)
+{
+	PyObject *ret;
+	char *s;
+
+	if (asprintf(&s, "{ type: lost, id: %#" PRIx64 ", "
+			 "lost: %#" PRIx64 " }",
+		     pevent->event.lost.id, pevent->event.lost.lost) < 0) {
+		ret = PyErr_NoMemory();
+	} else {
+		ret = PyString_FromString(s);
+		free(s);
+	}
+	return ret;
+}
+
+static PyTypeObject pyrf_lost_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.lost_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_lost_event__doc,
+	.tp_members	= pyrf_lost_event__members,
+	.tp_repr	= (reprfunc)pyrf_lost_event__repr,
+};
+
+static char pyrf_read_event__doc[] = PyDoc_STR("perf read event object.");
+
+static PyMemberDef pyrf_read_event__members[] = {
+	sample_members
+	member_def(read_event, pid, T_UINT, "event pid"),
+	member_def(read_event, tid, T_UINT, "event tid"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_read_event__repr(struct pyrf_event *pevent)
+{
+	return PyString_FromFormat("{ type: read, pid: %u, tid: %u }",
+				   pevent->event.read.pid,
+				   pevent->event.read.tid);
+	/*
+ 	 * FIXME: return the array of read values,
+ 	 * making this method useful ;-)
+ 	 */
+}
+
+static PyTypeObject pyrf_read_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.read_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_read_event__doc,
+	.tp_members	= pyrf_read_event__members,
+	.tp_repr	= (reprfunc)pyrf_read_event__repr,
+};
+
+static char pyrf_sample_event__doc[] = PyDoc_STR("perf sample event object.");
+
+static PyMemberDef pyrf_sample_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_sample_event__repr(struct pyrf_event *pevent)
+{
+	PyObject *ret;
+	char *s;
+
+	if (asprintf(&s, "{ type: sample }") < 0) {
+		ret = PyErr_NoMemory();
+	} else {
+		ret = PyString_FromString(s);
+		free(s);
+	}
+	return ret;
+}
+
+static PyTypeObject pyrf_sample_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.sample_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_sample_event__doc,
+	.tp_members	= pyrf_sample_event__members,
+	.tp_repr	= (reprfunc)pyrf_sample_event__repr,
+};
+
 static int pyrf_event__setup_types(void)
 {
 	int err;
 	pyrf_mmap_event__type.tp_new =
 	pyrf_task_event__type.tp_new =
 	pyrf_comm_event__type.tp_new =
+	pyrf_lost_event__type.tp_new =
+	pyrf_read_event__type.tp_new =
+	pyrf_sample_event__type.tp_new =
 	pyrf_throttle_event__type.tp_new = PyType_GenericNew;
 	err = PyType_Ready(&pyrf_mmap_event__type);
 	if (err < 0)
 		goto out;
+	err = PyType_Ready(&pyrf_lost_event__type);
+	if (err < 0)
+		goto out;
 	err = PyType_Ready(&pyrf_task_event__type);
 	if (err < 0)
 		goto out;
@@ -206,20 +309,26 @@ static int pyrf_event__setup_types(void)
 	err = PyType_Ready(&pyrf_throttle_event__type);
 	if (err < 0)
 		goto out;
+	err = PyType_Ready(&pyrf_read_event__type);
+	if (err < 0)
+		goto out;
+	err = PyType_Ready(&pyrf_sample_event__type);
+	if (err < 0)
+		goto out;
 out:
 	return err;
 }
 
 static PyTypeObject *pyrf_event__type[] = {
 	[PERF_RECORD_MMAP]	 = &pyrf_mmap_event__type,
-	[PERF_RECORD_LOST]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_LOST]	 = &pyrf_lost_event__type,
 	[PERF_RECORD_COMM]	 = &pyrf_comm_event__type,
 	[PERF_RECORD_EXIT]	 = &pyrf_task_event__type,
 	[PERF_RECORD_THROTTLE]	 = &pyrf_throttle_event__type,
 	[PERF_RECORD_UNTHROTTLE] = &pyrf_throttle_event__type,
 	[PERF_RECORD_FORK]	 = &pyrf_task_event__type,
-	[PERF_RECORD_READ]	 = &pyrf_mmap_event__type,
-	[PERF_RECORD_SAMPLE]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_READ]	 = &pyrf_read_event__type,
+	[PERF_RECORD_SAMPLE]	 = &pyrf_sample_event__type,
 };
 
 static PyObject *pyrf_event__new(union perf_event *event)
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index bbc982f..95d3700 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -3,9 +3,27 @@
 from distutils.core import setup, Extension
 from os import getenv
 
+from distutils.command.build_ext   import build_ext   as _build_ext
+from distutils.command.install_lib import install_lib as _install_lib
+
+class build_ext(_build_ext):
+    def finalize_options(self):
+        _build_ext.finalize_options(self)
+        self.build_lib  = build_lib
+        self.build_temp = build_tmp
+
+class install_lib(_install_lib):
+    def finalize_options(self):
+        _install_lib.finalize_options(self)
+        self.build_dir = build_lib
+
+
 cflags = ['-fno-strict-aliasing', '-Wno-write-strings']
 cflags += getenv('CFLAGS', '').split()
 
+build_lib = getenv('PYTHON_EXTBUILD_LIB')
+build_tmp = getenv('PYTHON_EXTBUILD_TMP')
+
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
@@ -21,4 +39,5 @@ setup(name='perf',
       author_email='acme@redhat.com',
       license='GPLv2',
       url='http://perf.wiki.kernel.org',
-      ext_modules=[perf])
+      ext_modules=[perf],
+      cmdclass={'build_ext': build_ext, 'install_lib': install_lib})
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index eec1963..a8b5371 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1504,6 +1504,17 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	dso->adjust_symbols = 0;
 
 	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
+		struct stat st;
+
+		if (stat(dso->name, &st) < 0)
+			return -1;
+
+		if (st.st_uid && (st.st_uid != geteuid())) {
+			pr_warning("File %s not owned by current user or root, "
+				"ignoring it.\n", dso->name);
+			return -1;
+		}
+
 		ret = dso__load_perf_map(dso, map, filter);
 		dso->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
 					      SYMTAB__NOT_FOUND;
