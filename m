Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab0EFSD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:03:56 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38378 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab0EFSDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:03:48 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:33:40 +0530
Message-Id: <20100506180340.28877.25709.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 10/10] perf: perf interface for uprobes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-events.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

This patch enhances perf probe to accept pid and user vaddr.
This patch provides very basic support for uprobes.

TODO:
Update perf-probes.txt.
Global tracing.

Here is a terminal snapshot of placing, using and removing a probe on a
process with pid 3329 (corresponding to zsh)

[ Probing a function in the executable using function name  ]
-------------------------------------------------------------
[root@ABCD]# perf probe -p 3329 zfree@zsh
Added new event:
  probe:p_3329_zfree                       (on 0x446420)

You can now use it on all perf tools, such as:

	perf record -e probe:p_3329_zfree -a sleep 1
[root@ABCD]# perf probe --list
probe:p_3329_zfree                       (on 3329:0x0000000000446420)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe/p_3329_zfree 3329:0x0000000000446420
[root@ABCD]# perf record -f -e probe:p_3329_zfree -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.039 MB perf.data (~1716 samples) ]
[root@ABCD]# perf probe -p 3329 --del probe:p_3329_zfree
Remove event: probe:p_3329_zfree
[root@ABCD]# perf report
# Samples: 447
#
# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
   100.00%              zsh  zsh            [.] zfree


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

[ Probing a function + offset ]
-------------------------------
[root@ABCD]# perf probe -p 3329 zfree@zsh+5
Added new event:
  probe:p_3329_zfree                       (on 0x446425)

You can now use it on all perf tools, such as:

	perf record -e probe:p_3329_zfree -a sleep 1
[root@ABCD]# perf probe --list
probe:p_3329_zfree                       (on 3329:0x0000000000446425)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe/p_3329_zfree 3329:0x0000000000446425
[root@ABCD]# perf record -f -e probe:p_3329_zfree -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.036 MB perf.data (~1590 samples) ]
[root@ABCD]# perf probe -p 3329 --del probe:p_3329_zfree
Remove event: probe:p_3329_zfree
[root@ABCD]# perf report
# Samples: 18
#
# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
   100.00%              zsh  zsh            [.] zfree


#
# (For a higher level overview, try: perf report --sort comm,dso)
#


[ Probing a library function using function name ]
--------------------------------------------------
[root@ABCD]# perf probe -p 3329 write@libc-2.5.so
Added new event:
  probe:p_3329_write                       (on 0x36010c6060)

You can now use it on all perf tools, such as:

	perf record -e probe:p_3329_write -a sleep 1
[root@ABCD]# perf probe --list
probe:p_3329_write                       (on 3329:0x00000036010c6060)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe/p_3329_write 3329:0x00000036010c6060
[root@ABCD]# perf record -f -e probe:p_3329_write -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.040 MB perf.data (~1738 samples) ]
[root@ABCD]# perf probe -p 3329 --del probe:p_3329_write
Remove event: probe:p_3329_write
[root@ABCD]# perf report
# Samples: 11
#
# Overhead          Command       Shared Object  Symbol
# ........  ...............  ..................  ......
#
   100.00%              zsh  libc-2.5.so         [.] __GI___libc_write


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
Adding a probe for a process

[ Probing using vaddr 0x0000000000446420 (corresponding to zfree)]
-------------------------------------------------------------------
[root@ABCD]# perf probe -p 3329 0x0000000000446420
Added new event:
  probe:p_3329_0x0000000000446420          (on 0x0000000000446420)

You can now use it on all perf tools, such as:

        perf record -e probe:p_3329_0x0000000000446420 -a sleep 1

[root@ABCD]# perf record -e probe:p_3329_0x0000000000446420 -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.041 MB perf.data (~1797 samples) ]
[root@ABCD]# perf report
#
# Samples: 628
#
# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
   100.00%              zsh  zsh            [.] zfree


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[root@ABCD]# perf report --sort comm,dso
# Samples: 628
#
# Overhead          Command  Shared Object
# ........  ...............  .............
#
   100.00%              zsh  zsh


[root@ABCD]# perf probe --list
  probe:p_3329_0x0000000000446420          (on 3329:0x0000000000446420)
[root@ABCD]#  perf list | grep probe
  probe:p_3329_0x0000000000446420            [Tracepoint event]
[root@ABCD]# perf probe -p 3329 --del probe:p_3329_0x0000000000446420
Remove event: probe:p_3329_0x0000000000446420
[root@ABCD]#


Another example for a shared library: write stub in libc. (corresponds to
0x00000036010c6060)

on a vaddr
[ Probing a libc vaddr 0x00000036010c6060 (corresponding to write) ]
[root@ABCD]# perf probe -p 3329 0x00000036010c6060
dded new event:
  probe:p_3329_0x00000036010c6060          (on 0x00000036010c6060)

You can now use it on all perf tools, such as:

        perf record -e probe:p_3329_0x00000036010c6060 -a sleep 1

[root@ABCD]# perf record -f -e probe:p_3329_0x00000036010c6060 -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.040 MB perf.data (~1748 samples) ]
[root@ABCD]# perf report
# Samples: 24
#
# Overhead          Command       Shared Object  Symbol
# ........  ...............  ..................  ......
#
   100.00%              zsh  libc-2.5.so         [.] __GI___libc_write


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[root@ABCD]#


Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c     |   34 +++++--
 tools/perf/builtin-top.c       |   20 ----
 tools/perf/util/event.c        |   20 ++++
 tools/perf/util/event.h        |    1 
 tools/perf/util/probe-event.c  |  207 ++++++++++++++++++++++++++++++++--------
 tools/perf/util/probe-event.h  |    9 +-
 tools/perf/util/probe-finder.h |    1 
 tools/perf/util/symbol.c       |    6 +
 8 files changed, 224 insertions(+), 74 deletions(-)


diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 152d6c9..9f867ad 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -55,6 +55,7 @@ static struct {
 	bool force_add;
 	bool show_lines;
 	int nr_probe;
+	pid_t pid;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
 	struct map_groups kmap_groups;
@@ -73,7 +74,7 @@ static void parse_probe_event(const char *str)
 		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
 	/* Parse perf-probe event into probe_point */
-	parse_perf_probe_event(str, pp, &session.need_dwarf);
+	parse_perf_probe_event(str, pp, &session.need_dwarf, session.pid);
 
 	pr_debug("%d arguments\n", pp->nr_args);
 }
@@ -203,6 +204,8 @@ static const struct option options[] = {
 		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
 		     "Show source code lines.", opt_show_lines),
 #endif
+	OPT_INTEGER('p', "pid", &session.pid,
+	"specify a pid for a uprobes based probe"),
 	OPT_END()
 };
 
@@ -263,7 +266,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 
 #ifndef NO_DWARF_SUPPORT
-	if (session.show_lines) {
+	if (session.show_lines && !session.pid) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --line with"
 				   " --add/--del.\n");
@@ -283,12 +286,19 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 #endif
 
 	if (session.dellist) {
-		del_trace_kprobe_events(session.dellist);
+		if (session.pid)
+			del_trace_uprobe_events(session.dellist);
+		else
+			del_trace_kprobe_events(session.dellist);
+
 		strlist__delete(session.dellist);
 		if (session.nr_probe == 0)
 			return 0;
 	}
 
+	if (session.pid)
+		goto end_dwarf;
+
 	/* Add probes */
 	init_vmlinux();
 
@@ -334,18 +344,19 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		break;
 	}
 	close(fd);
-
-end_dwarf:
 #endif /* !NO_DWARF_SUPPORT */
 
+end_dwarf:
 	/* Synthesize probes without dwarf */
 	for (i = 0; i < session.nr_probe; i++) {
 		pp = &session.probes[i];
 		if (pp->found)	/* This probe is already found. */
 			continue;
 
-		evaluate_probe_point(pp);
-		ret = synthesize_trace_kprobe_event(pp);
+		if (!session.pid)
+			evaluate_probe_point(pp);
+
+		ret = synthesize_trace_probe_event(pp);
 		if (ret == -E2BIG)
 			die("probe point definition becomes too long.");
 		else if (ret < 0)
@@ -353,8 +364,11 @@ end_dwarf:
 	}
 
 	/* Settng up probe points */
-	add_trace_kprobe_events(session.probes, session.nr_probe,
-				session.force_add);
+	if (session.pid)
+		add_trace_uprobe_events(session.probes, session.nr_probe,
+					session.force_add, session.pid);
+	else
+		add_trace_kprobe_events(session.probes, session.nr_probe,
+					session.force_add);
 	return 0;
 }
-
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1f52932..430d910 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1005,26 +1005,6 @@ static void event__process_sample(const event_t *self,
 	}
 }
 
-static int event__process(event_t *event, struct perf_session *session)
-{
-	switch (event->header.type) {
-	case PERF_RECORD_COMM:
-		event__process_comm(event, session);
-		break;
-	case PERF_RECORD_MMAP:
-		event__process_mmap(event, session);
-		break;
-	case PERF_RECORD_FORK:
-	case PERF_RECORD_EXIT:
-		event__process_task(event, session);
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 struct mmap_data {
 	int			counter;
 	void			*base;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 705ec63..e5190f2 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -432,6 +432,26 @@ int event__process_task(event_t *self, struct perf_session *session)
 	return 0;
 }
 
+int event__process(event_t *event, struct perf_session *session)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_COMM:
+		event__process_comm(event, session);
+		break;
+	case PERF_RECORD_MMAP:
+		event__process_mmap(event, session);
+		break;
+	case PERF_RECORD_FORK:
+	case PERF_RECORD_EXIT:
+		event__process_task(event, session);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 void thread__find_addr_map(struct thread *self,
 			   struct perf_session *session, u8 cpumode,
 			   enum map_type type, u64 addr,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a33b949..282486b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -128,6 +128,7 @@ int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
 int event__process_mmap(event_t *self, struct perf_session *session);
 int event__process_task(event_t *self, struct perf_session *session);
+int event__process(event_t *event, struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7c004b6..743a72b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -41,6 +41,7 @@
 #include "color.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
+#include "session.h"
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -112,6 +113,64 @@ static bool check_event_name(const char *name)
 	return true;
 }
 
+/*
+ * uprobe_events only accepts address:
+ * Convert function and any offset to address
+ */
+static void convert_name_to_addr(struct probe_point *pp)
+{
+	struct perf_session *session;
+	struct thread *thread;
+	struct symbol *sym;
+	struct map *map;
+	char *name = pp->file;
+	unsigned long long vaddr;
+
+	/* check if user has specifed a virtual address */
+	vaddr = strtoul(pp->function, NULL, 0);
+	if (vaddr)
+		return;
+
+	session = perf_session__new(NULL, O_WRONLY, false);
+	DIE_IF(session == NULL);
+	symbol_conf.sort_by_name = true;
+	symbol_conf.try_vmlinux_path = false;
+	if (symbol__init() < 0)
+		semantic_error("Cannot initialize symbols.");
+
+	event__synthesize_thread(pp->upid, event__process, session);
+
+	thread = perf_session__findnew(session, pp->upid);
+	DIE_IF(thread == NULL);
+
+	if (!name)
+		/* Lets find the function in the executable. */
+		name = thread->comm;
+	DIE_IF(name == NULL);
+
+	map = map_groups__find_by_name(&thread->mg, MAP__FUNCTION, name);
+	if (!map)
+		semantic_error("Cannot find appropriate DSO.");
+
+	sym = map__find_symbol_by_name(map, pp->function, NULL);
+	if (!sym)
+		semantic_error("Cannot find appropriate Symbol.");
+
+	if (map->start > sym->start)
+		vaddr = map->start;
+	vaddr += sym->start + pp->offset + map->pgoff;
+	pp->offset = 0;
+
+	if (!pp->event)
+		pp->event = pp->function;
+	else
+		free(pp->function);
+	pp->function = zalloc(sizeof(char *) * 20);
+	if (!pp->function)
+		die("Failed to allocate memory by zalloc.");
+	e_snprintf(pp->function, 20, "0x%llx", vaddr);
+}
+
 /* Parse probepoint definition. */
 static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 {
@@ -166,7 +225,8 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 			*ptr++ = '\0';
 		}
 		switch (c) {
-		case ':':	/* Line number */
+		case ':':
+			/* Line number */
 			pp->line = strtoul(arg, &tmp, 0);
 			if (*tmp != '\0')
 				semantic_error("There is non-digit char"
@@ -216,6 +276,9 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	if (pp->retprobe && !pp->function)
 		semantic_error("Return probe requires an entry function.");
 
+	if (pp->upid && !pp->function)
+		semantic_error("No function specified for uprobes");
+
 	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe)
 		semantic_error("Offset/Line/Lazy pattern can't be used with "
 			       "return probe.");
@@ -223,11 +286,14 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	pr_debug("symbol:%s file:%s line:%d offset:%d return:%d lazy:%s\n",
 		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
 		 pp->lazy_line);
+
+	if (pp->upid)
+		convert_name_to_addr(pp);
 }
 
 /* Parse perf-probe event definition */
 void parse_perf_probe_event(const char *str, struct probe_point *pp,
-			    bool *need_dwarf)
+			    bool *need_dwarf, pid_t pid)
 {
 	char **argv;
 	int argc, i;
@@ -241,6 +307,7 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 		semantic_error("Too many arguments");
 
 	/* Parse probe point */
+	pp->upid = pid;
 	parse_perf_probe_probepoint(argv[0], pp);
 	if (pp->file || pp->line || pp->lazy_line)
 		*need_dwarf = true;
@@ -263,15 +330,15 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 	argv_free(argv);
 }
 
-/* Parse kprobe_events event into struct probe_point */
-void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
+/* Parse kprobe_events (uprobe_events) event into struct probe_point */
+void parse_trace_probe_event(const char *str, struct probe_point *pp)
 {
 	char pr;
 	char *p;
 	int ret, i, argc;
 	char **argv;
 
-	pr_debug("Parsing kprobe_events: %s\n", str);
+	pr_debug("Parsing probe_events: %s\n", str);
 	argv = argv_split(str, &argc);
 	if (!argv)
 		die("argv_split failed.");
@@ -375,7 +442,7 @@ error:
 	return ret;
 }
 
-int synthesize_trace_kprobe_event(struct probe_point *pp)
+int synthesize_trace_probe_event(struct probe_point *pp)
 {
 	char *buf;
 	int i, len, ret;
@@ -383,7 +450,11 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
 	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
 	if (!buf)
 		die("Failed to allocate memory by zalloc.");
-	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
+	if (pp->offset)
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function,
+					pp->offset);
+	else
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s", pp->function);
 	if (ret <= 0)
 		goto error;
 	len = ret;
@@ -426,8 +497,8 @@ static int open_kprobe_events(int flags, int mode)
 	return ret;
 }
 
-/* Get raw string list of current kprobe_events */
-static struct strlist *get_trace_kprobe_event_rawlist(int fd)
+/* Get raw string list of current kprobe_events  or uprobe_events */
+static struct strlist *get_trace_probe_event_rawlist(int fd)
 {
 	int ret, idx;
 	FILE *fp;
@@ -455,6 +526,27 @@ static struct strlist *get_trace_kprobe_event_rawlist(int fd)
 	return sl;
 }
 
+static int open_uprobe_events(int flags, int mode)
+{
+	char buf[PATH_MAX];
+	int ret;
+
+	ret = e_snprintf(buf, PATH_MAX, "%s/../uprobe_events", debugfs_path);
+	if (ret < 0)
+		die("Failed to make uprobe_events path.");
+
+	ret = open(buf, flags, mode);
+	if (ret < 0) {
+		if (errno == ENOENT)
+			die("uprobe_events file does not exist -"
+			    " please rebuild with CONFIG_UPROBE_EVENT.");
+		else
+			die("Could not open uprobe_events file: %s",
+			    strerror(errno));
+	}
+	return ret;
+}
+
 /* Free and zero clear probe_point */
 static void clear_probe_point(struct probe_point *pp)
 {
@@ -500,9 +592,8 @@ static void show_perf_probe_event(const char *event, const char *place,
 }
 
 /* List up current perf-probe events */
-void show_perf_probe_events(void)
+static void __show_perf_probe_events(int fd)
 {
-	int fd;
 	struct probe_point pp;
 	struct strlist *rawlist;
 	struct str_node *ent;
@@ -510,22 +601,30 @@ void show_perf_probe_events(void)
 	setup_pager();
 	memset(&pp, 0, sizeof(pp));
 
-	fd = open_kprobe_events(O_RDONLY, 0);
-	rawlist = get_trace_kprobe_event_rawlist(fd);
-	close(fd);
-
+	rawlist = get_trace_probe_event_rawlist(fd);
 	strlist__for_each(ent, rawlist) {
-		parse_trace_kprobe_event(ent->s, &pp);
+		parse_trace_probe_event(ent->s, &pp);
 		/* Synthesize only event probe point */
 		synthesize_perf_probe_point(&pp);
 		/* Show an event */
 		show_perf_probe_event(pp.event, pp.probes[0], &pp);
 		clear_probe_point(&pp);
 	}
-
 	strlist__delete(rawlist);
 }
 
+void show_perf_probe_events(void)
+{
+	int fd;
+	fd = open_kprobe_events(O_RDONLY, 0);
+	__show_perf_probe_events(fd);
+	close(fd);
+
+	fd = open_uprobe_events(O_RDONLY, 0);
+	__show_perf_probe_events(fd);
+	close(fd);
+}
+
 /* Get current perf-probe event names */
 static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
@@ -535,11 +634,11 @@ static struct strlist *get_perf_event_names(int fd, bool include_group)
 	struct probe_point pp;
 
 	memset(&pp, 0, sizeof(pp));
-	rawlist = get_trace_kprobe_event_rawlist(fd);
+	rawlist = get_trace_probe_event_rawlist(fd);
 
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
-		parse_trace_kprobe_event(ent->s, &pp);
+		parse_trace_probe_event(ent->s, &pp);
 		if (include_group) {
 			if (e_snprintf(buf, 128, "%s:%s", pp.group,
 				       pp.event) < 0)
@@ -555,7 +654,7 @@ static struct strlist *get_perf_event_names(int fd, bool include_group)
 	return sl;
 }
 
-static void write_trace_kprobe_event(int fd, const char *buf)
+static void write_trace_probe_event(int fd, const char *buf)
 {
 	int ret;
 
@@ -566,12 +665,15 @@ static void write_trace_kprobe_event(int fd, const char *buf)
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
-			       struct strlist *namelist, bool allow_suffix)
+	       struct strlist *namelist, bool allow_suffix, pid_t pid)
 {
 	int i, ret;
 
 	/* Try no suffix */
-	ret = e_snprintf(buf, len, "%s", base);
+	if (pid)
+		ret = e_snprintf(buf, len, "p_%d_%s", pid, base);
+	else
+		ret = e_snprintf(buf, len, "%s", base);
 	if (ret < 0)
 		die("snprintf() failed: %s", strerror(-ret));
 	if (!strlist__has_entry(namelist, buf))
@@ -595,22 +697,25 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 		die("Too many events are on the same function.");
 }
 
-void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
-			     bool force_add)
+static void add_trace_probe_events(int fd, struct probe_point *probes,
+		int nr_probes, bool force_add, pid_t pid)
 {
-	int i, j, fd;
+	int i, j;
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
+	char tempbuf[MAX_CMDLEN];
 	char event[64];
 	struct strlist *namelist;
 	bool allow_suffix;
 
-	fd = open_kprobe_events(O_RDWR, O_APPEND);
 	/* Get current event names */
 	namelist = get_perf_event_names(fd, false);
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
+		pp->upid = pid;
+		if (pid)
+			snprintf(tempbuf, MAX_CMDLEN, "%d:", pid);
 		if (!pp->event)
 			pp->event = strdup(pp->function);
 		if (!pp->group)
@@ -621,12 +726,13 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 		for (i = 0; i < pp->found; i++) {
 			/* Get an unused new event name */
 			get_new_event_name(event, 64, pp->event, namelist,
-					   allow_suffix);
-			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
+					   allow_suffix, pid);
+			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s\n",
 				 pp->retprobe ? 'r' : 'p',
 				 pp->group, event,
+				 pp->upid ? tempbuf : " ",
 				 pp->probes[i]);
-			write_trace_kprobe_event(fd, buf);
+			write_trace_probe_event(fd, buf);
 			printf("Added new event:\n");
 			/* Get the first parameter (probe-point) */
 			sscanf(pp->probes[i], "%s", buf);
@@ -650,7 +756,21 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 	close(fd);
 }
 
-static void __del_trace_kprobe_event(int fd, struct str_node *ent)
+void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
+			     bool force_add)
+{
+	int fd = open_kprobe_events(O_RDWR, O_APPEND);
+	add_trace_probe_events(fd, probes, nr_probes, force_add, 0);
+}
+
+void add_trace_uprobe_events(struct probe_point *probes, int nr_probes,
+			     bool force_add, pid_t pid)
+{
+	int fd = open_uprobe_events(O_RDWR, O_APPEND);
+	add_trace_probe_events(fd, probes, nr_probes, force_add, pid);
+}
+
+static void __del_trace_probe_event(int fd, struct str_node *ent)
 {
 	char *p;
 	char buf[128];
@@ -663,11 +783,11 @@ static void __del_trace_kprobe_event(int fd, struct str_node *ent)
 		die("Internal error: %s should have ':' but not.", ent->s);
 	*p = '/';
 
-	write_trace_kprobe_event(fd, buf);
+	write_trace_probe_event(fd, buf);
 	printf("Remove event: %s\n", ent->s);
 }
 
-static void del_trace_kprobe_event(int fd, const char *group,
+static void del_trace_probe_event(int fd, const char *group,
 				   const char *event, struct strlist *namelist)
 {
 	char buf[128];
@@ -681,14 +801,14 @@ static void del_trace_kprobe_event(int fd, const char *group,
 		strlist__for_each_safe(ent, n, namelist)
 			if (strglobmatch(ent->s, buf)) {
 				found++;
-				__del_trace_kprobe_event(fd, ent);
+				__del_trace_probe_event(fd, ent);
 				strlist__remove(namelist, ent);
 			}
 	} else {
 		ent = strlist__find(namelist, buf);
 		if (ent) {
 			found++;
-			__del_trace_kprobe_event(fd, ent);
+			__del_trace_probe_event(fd, ent);
 			strlist__remove(namelist, ent);
 		}
 	}
@@ -696,16 +816,13 @@ static void del_trace_kprobe_event(int fd, const char *group,
 		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
 }
 
-void del_trace_kprobe_events(struct strlist *dellist)
+static void del_trace_probe_events(int fd, struct strlist *dellist)
 {
-	int fd;
 	const char *group, *event;
 	char *p, *str;
 	struct str_node *ent;
 	struct strlist *namelist;
 
-	fd = open_kprobe_events(O_RDWR, O_APPEND);
-	/* Get current event names */
 	namelist = get_perf_event_names(fd, true);
 
 	strlist__for_each(ent, dellist) {
@@ -723,13 +840,25 @@ void del_trace_kprobe_events(struct strlist *dellist)
 			event = str;
 		}
 		pr_debug("Group: %s, Event: %s\n", group, event);
-		del_trace_kprobe_event(fd, group, event, namelist);
+		del_trace_probe_event(fd, group, event, namelist);
 		free(str);
 	}
 	strlist__delete(namelist);
 	close(fd);
 }
 
+void del_trace_kprobe_events(struct strlist *dellist)
+{
+	int fd = open_kprobe_events(O_RDWR, O_APPEND);
+	del_trace_probe_events(fd, dellist);
+}
+
+void del_trace_uprobe_events(struct strlist *dellist)
+{
+	int fd = open_uprobe_events(O_RDWR, O_APPEND);
+	del_trace_probe_events(fd, dellist);
+}
+
 #define LINEBUF_SIZE 256
 #define NR_ADDITIONAL_LINES 2
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 711287d..bcb7ab2 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -7,14 +7,17 @@
 
 extern void parse_line_range_desc(const char *arg, struct line_range *lr);
 extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
-				   bool *need_dwarf);
+				   bool *need_dwarf, pid_t pid);
 extern int synthesize_perf_probe_point(struct probe_point *pp);
 extern int synthesize_perf_probe_event(struct probe_point *pp);
-extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
-extern int synthesize_trace_kprobe_event(struct probe_point *pp);
+extern int synthesize_trace_probe_event(struct probe_point *pp);
+extern void parse_trace_probe_event(const char *str, struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 				    bool force_add);
 extern void del_trace_kprobe_events(struct strlist *dellist);
+extern void add_trace_uprobe_events(struct probe_point *probes, int nr_probes,
+				    bool force_add, pid_t pid);
+extern void del_trace_uprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 extern void show_line_range(struct line_range *lr);
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 21f7354..b4d8ebc 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -33,6 +33,7 @@ struct probe_point {
 
 	/* Output */
 	int			found;			/* Number of found probe points */
+	pid_t			upid;			/* uprobes only */
 	char			*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c458c4a..7267050 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -958,12 +958,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (!self->kernel) {
+	if (self->kernel || symbol_conf.sort_by_name)
+		self->adjust_symbols = 0;
+	else {
 		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
-	} else self->adjust_symbols = 0;
+	}
 
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
