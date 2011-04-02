Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1DBK0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:26:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1DBK0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:26:19 -0400
Date: Sat, 2 Apr 2011 12:25:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fixes
Message-ID: <20110402102559.GA17557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      oprofile, x86: Allow setting EDGE/INV/CMASK for counter events

Andrew Lutomirski (1):
      perf symbols: Fix vsyscall symbol lookup

Arnaldo Carvalho de Melo (1):
      perf tools: Fixup exit path when not able to open events

David Ahern (1):
      perf tools: Emit clearer message for sys_perf_event_open ENOENT return

David S. Miller (1):
      perf symbols: Properly align symbol_conf.priv_size

Frederic Weisbecker (2):
      perf: Rebase max unprivileged mlock threshold on top of page size
      perf: mmap 512 kiB by default

Peter Zijlstra (2):
      perf: Fix task context scheduling
      perf: Fix task_struct reference leak

Robert Richter (1):
      perf tools: Fix NO_NEWT=1 python build error


 arch/x86/oprofile/nmi_int.c    |    5 ++++
 arch/x86/oprofile/op_counter.h |    1 +
 include/linux/perf_event.h     |    2 +-
 kernel/perf_event.c            |    9 ++++++-
 tools/perf/Makefile            |    8 +++++-
 tools/perf/builtin-record.c    |   25 ++++++++++++++++------
 tools/perf/builtin-top.c       |   44 +++++++++++++++++++++++++++------------
 tools/perf/util/debug.c        |   10 +++++++++
 tools/perf/util/debug.h        |    1 +
 tools/perf/util/event.c        |    2 +-
 tools/perf/util/setup.py       |    7 +++++-
 tools/perf/util/symbol.c       |    5 ++++
 12 files changed, 91 insertions(+), 28 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 8dace18..cf97500 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -49,6 +49,10 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 	val |= counter_config->user ? ARCH_PERFMON_EVENTSEL_USR : 0;
 	val |= counter_config->kernel ? ARCH_PERFMON_EVENTSEL_OS : 0;
 	val |= (counter_config->unit_mask & 0xFF) << 8;
+	counter_config->extra &= (ARCH_PERFMON_EVENTSEL_INV |
+				  ARCH_PERFMON_EVENTSEL_EDGE |
+				  ARCH_PERFMON_EVENTSEL_CMASK);
+	val |= counter_config->extra;
 	event &= model->event_mask ? model->event_mask : 0xFF;
 	val |= event & 0xFF;
 	val |= (event & 0x0F00) << 24;
@@ -440,6 +444,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
 		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
 		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
+		oprofilefs_create_ulong(sb, dir, "extra", &counter_config[i].extra);
 	}
 
 	return 0;
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index e28398d..0b7b7b1 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -22,6 +22,7 @@ struct op_counter_config {
 	unsigned long kernel;
 	unsigned long user;
 	unsigned long unit_mask;
+	unsigned long extra;
 };
 
 extern struct op_counter_config counter_config[];
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 311b4dc..04d75a8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1086,7 +1086,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
+	__perf_event_task_sched_out(task, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..27960f1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -145,8 +145,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-/* Minimum for 128 pages + 1 for the user control page */
-int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
+/* Minimum for 512 kiB + 1 user control page */
+int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
 
 /*
  * max perf event sample rate
@@ -6531,6 +6531,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	if (task) {
+		put_task_struct(task);
+		task = NULL;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 158c30e..207dee5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -165,8 +165,12 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
-						--build-temp='$(OUTPUT)python/temp'
+	$(QUIET_GEN)( \
+		export CFLAGS="$(BASIC_CFLAGS)"; \
+		python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+			--build-temp='$(OUTPUT)python/temp' \
+	)
+
 #
 # No Perl scripts right now:
 #
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6febcc1..17d1dcb 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,7 +41,7 @@ static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 
 static unsigned int		page_size;
-static unsigned int		mmap_pages			=    128;
+static unsigned int		mmap_pages			= UINT_MAX;
 static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
 static int			output;
@@ -275,11 +275,10 @@ try_again:
 				     !no_inherit) < 0) {
 			int err = errno;
 
-			if (err == EPERM || err == EACCES)
-				die("Permission error - are you root?\n"
-					"\t Consider tweaking"
-					" /proc/sys/kernel/perf_event_paranoid.\n");
-			else if (err ==  ENODEV && cpu_list) {
+			if (err == EPERM || err == EACCES) {
+				ui__warning_paranoid();
+				exit(EXIT_FAILURE);
+			} else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
 			} else if (err == EINVAL && sample_id_all_avail) {
@@ -302,11 +301,19 @@ try_again:
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
-					warning(" ... trying to fall back to cpu-clock-ticks\n");
+					ui__warning("The cycles event is not supported, "
+						    "trying to fall back to cpu-clock-ticks\n");
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
+
+			if (err == ENOENT) {
+				ui__warning("The %s event is not supported.\n",
+					    event_name(pos));
+				exit(EXIT_FAILURE);
+			}
+
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 			      err, strerror(err));
@@ -506,6 +513,10 @@ static int __cmd_record(int argc, const char **argv)
 	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
+	/* 512 kiB: default amount of unprivileged mlocked memory */
+	if (mmap_pages == UINT_MAX)
+		mmap_pages = (512 * 1024) / page_size;
+
 	if (forks) {
 		child_pid = fork();
 		if (child_pid < 0) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 676b4fb..fc1273e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -850,10 +850,10 @@ try_again:
 				     top.evlist->threads, group, inherit) < 0) {
 			int err = errno;
 
-			if (err == EPERM || err == EACCES)
-				die("Permission error - are you root?\n"
-					"\t Consider tweaking"
-					" /proc/sys/kernel/perf_event_paranoid.\n");
+			if (err == EPERM || err == EACCES) {
+				ui__warning_paranoid();
+				goto out_err;
+			}
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
@@ -861,25 +861,41 @@ try_again:
 			 */
 			if (attr->type == PERF_TYPE_HARDWARE &&
 			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
-
 				if (verbose)
-					warning(" ... trying to fall back to cpu-clock-ticks\n");
+					ui__warning("Cycles event not supported,\n"
+						    "trying to fall back to cpu-clock-ticks\n");
 
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
-			printf("\n");
-			error("sys_perf_event_open() syscall returned with %d "
-			      "(%s).  /bin/dmesg may provide additional information.\n",
-			      err, strerror(err));
-			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-			exit(-1);
+
+			if (err == ENOENT) {
+				ui__warning("The %s event is not supported.\n",
+					    event_name(counter));
+				goto out_err;
+			}
+
+			ui__warning("The sys_perf_event_open() syscall "
+				    "returned with %d (%s).  /bin/dmesg "
+				    "may provide additional information.\n"
+				    "No CONFIG_PERF_EVENTS=y kernel support "
+				    "configured?\n", err, strerror(err));
+			goto out_err;
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
-		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0) {
+		ui__warning("Failed to mmap with %d (%s)\n",
+			    errno, strerror(errno));
+		goto out_err;
+	}
+
+	return;
+
+out_err:
+	exit_browser(0);
+	exit(0);
 }
 
 static int __cmd_top(void)
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index d4536a9..155749d 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -57,6 +57,16 @@ void ui__warning(const char *format, ...)
 }
 #endif
 
+void ui__warning_paranoid(void)
+{
+	ui__warning("Permission error - are you root?\n"
+		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
+		    " -1 - Not paranoid at all\n"
+		    "  0 - Disallow raw tracepoint access for unpriv\n"
+		    "  1 - Disallow cpu events for unpriv\n"
+		    "  2 - Disallow kernel profiling for unpriv\n");
+}
+
 void trace_event(union perf_event *event)
 {
 	unsigned char *raw_event = (void *)event;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 93516cf4..fd53db4 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -36,5 +36,6 @@ int ui_helpline__show_help(const char *format, va_list ap);
 #endif
 
 void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
+void ui__warning_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2b15c36..1023f67 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -710,7 +710,7 @@ try_again:
 		 * in the whole kernel symbol list.
 		 */
 		if ((long long)al->addr < 0 &&
-		    cpumode == PERF_RECORD_MISC_KERNEL &&
+		    cpumode == PERF_RECORD_MISC_USER &&
 		    machine && mg != &machine->kmaps) {
 			mg = &machine->kmaps;
 			goto try_again;
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index e24ffad..bbc982f 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,13 +1,18 @@
 #!/usr/bin/python2
 
 from distutils.core import setup, Extension
+from os import getenv
+
+cflags = ['-fno-strict-aliasing', '-Wno-write-strings']
+cflags += getenv('CFLAGS', '').split()
 
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
 			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include'],
-		  extra_compile_args = ['-fno-strict-aliasing', '-Wno-write-strings'])
+		  extra_compile_args = cflags,
+                 )
 
 setup(name='perf',
       version='0.1',
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 17df793..f06c10f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1196,6 +1196,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				if (curr_dso == NULL)
 					goto out_elf_end;
 				curr_dso->kernel = self->kernel;
+				curr_dso->long_name = self->long_name;
+				curr_dso->long_name_len = self->long_name_len;
 				curr_map = map__new2(start, curr_dso,
 						     map->type);
 				if (curr_map == NULL) {
@@ -1842,6 +1844,7 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	if (fd < 0)
 		return -1;
 
+	dso__set_long_name(self, (char *)vmlinux);
 	dso__set_loaded(self, map->type);
 	err = dso__load_sym(self, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
@@ -2403,6 +2406,8 @@ int symbol__init(void)
 	if (symbol_conf.initialized)
 		return 0;
 
+	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
+
 	elf_version(EV_CURRENT);
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
