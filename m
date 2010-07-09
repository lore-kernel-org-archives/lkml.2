Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0GIEz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 00:55:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60056 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0GIEzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 00:55:24 -0400
Date: Fri, 9 Jul 2010 10:17:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv8 2.6.35-rc4-tip 11/12]  perf: perf interface for
 uprobes
Message-ID: <20100709044735.GB26884@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
 <20100708171215.29165.7352.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100708171215.29165.7352.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: perf interface for uprobes

Changelog:
  Fixed a compilation issue reported by Christoph Hellwig.

Changelog from v6: Changelog from v6: Fixed a bug reported by Masami.
  i.e Throw an error message and exit if perf probe is for a dwarf
  based probes.

Changelog from v4: Merged to 2.6.35-rc3-tip.

Changelog from v3: (addressed comments from Masami Hiramatsu)
	* Every process id has a different group name.
	* event name starts with function name.
	* If vaddr is specified, event name has vaddr appended
	  along with function name, (this is to avoid subsequent probes
	  using same event name.)
	* warning if -p and --list options are used together.

	Also dso can either be a short name or absolute path.

Enhances perf probe to accept pid and user vaddr.
Provides very basic support for uprobes.

TODO:
Update perf-probes.txt.
Global tracing.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Here is a terminal snapshot of placing, using and removing a probe on a
process with pid 3591 (corresponding to zsh)

[ Probing a function in the executable using function name  ]
-------------------------------------------------------------
[root@ABCD]# perf probe -p 3591 zfree@zsh
Added new event:
  probe_3591:zfree                       (on 0x446420)

You can now use it on all perf tools, such as:

	perf record -e probe_3591:zfree -a sleep 1
[root@ABCD]# perf probe --list
probe_3591:zfree                       (on 3591:0x0000000000446420)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe_3591/zfree 3591:0x0000000000446420
[root@ABCD]# perf record -f -e probe_3591:zfree -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.039 MB perf.data (~1716 samples) ]
[root@ABCD]# perf probe -p 3591 --del probe_3591:zfree
Remove event: probe_3591:zfree
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
[root@ABCD]# perf probe -p 3591 zfree@zsh+5
Added new event:
  probe_3591:zfree                         (on 0x446425)

You can now use it on all perf tools, such as:

	perf record -e probe_3591:zfree -a sleep 1
[root@ABCD]# perf probe --list
probe_3591:zfree                       (on 3591:0x0000000000446425)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe_3591/zfree 3591:0x0000000000446425
[root@ABCD]# perf record -f -e probe_3591:zfree -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.036 MB perf.data (~1590 samples) ]
[root@ABCD]# perf probe -p 3591 --del probe_3591:zfree
Remove event: probe_3591:zfree
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
[root@ABCD]# perf probe -p 3591 write@libc-2.5.so
Added new event:
  probe_3591:write                       (on 0x36010c6060)

You can now use it on all perf tools, such as:

	perf record -e probe_3591:write -a sleep 1
[root@ABCD]# perf probe --list
probe_3591:write                       (on 3591:0x00000036010c6060)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe_3591/write 3591:0x00000036010c6060
[root@ABCD]# perf record -f -e probe_3591:write -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.040 MB perf.data (~1738 samples) ]
[root@ABCD]# perf probe -p 3591 --del probe_3591:write
Remove event: probe_3591:write
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

[ Probing a library function using function name and absolute path ]
---------------------------------------------------------------------
[root@ABCD]# perf probe -p 3591 write@/lib64/libc-2.5.so
Added new event:
  probe_3591:write                       (on 0x36010c6060)

You can now use it on all perf tools, such as:

	perf record -e probe_3591:write -a sleep 1
[root@ABCD]# perf probe --list
probe_3591:write                       (on 3591:0x00000036010c6060)
[root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
p:probe_3591/write 3591:0x00000036010c6060
[root@ABCD]# perf record -f -e probe_3591:write -a sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.040 MB perf.data (~1738 samples) ]
[root@ABCD]# perf probe -p 3591 --del probe_3591:write
Remove event: probe_3591:write
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

[ Probing using vaddr 0x0000000000446420 (corresponding to zfree)]
-------------------------------------------------------------------
[root@ABCD]# perf probe -p 3591 0x0000000000446420
Added new event:
  probe_3591:zfree_446420          (on 0x0000000000446420)

You can now use it on all perf tools, such as:

        perf record -e probe_3591:zfree_446420 -a sleep 1

[root@ABCD]# perf record -e probe_3591:zfree_446420 -a sleep 10
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
  probe_3591:zfree_446420          (on 3591:0x0000000000446420)
[root@ABCD]#  perf list | grep probe
  probe_3591:zfree_446420            [Tracepoint event]
[root@ABCD]# perf probe -p 3591 --del probe_3591:zfree_446420
Remove event: probe_3591:zfree_446420
[root@ABCD]#


Another example for a shared library: write stub in libc. (corresponds to
0x00000036010c6060)

on a vaddr
[ Probing a libc vaddr 0x00000036010c6060 (corresponding to write) ]
[root@ABCD]# perf probe -p 3591 0x00000036010c6060
dded new event:
  probe_3591:__GI___libc_write_36010c6060          (on 0x00000036010c6060)

You can now use it on all perf tools, such as:

        perf record -e probe_3591:__GI___libc_write_36010c6060 -a sleep 1

[root@ABCD]# perf record -f -e probe_3591:__GI___libc_write_36010c6060 -a sleep 10
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

[ Probing using a function without specifying a dso (corresponding to zfree)]
-------------------------------------------------------------------
[root@ABCD]# perf probe -p 3591 zfree
Added new event:
  probe_3591:zfree		          (on 0x0000000000446420)

You can now use it on all perf tools, such as:

        perf record -e probe_3591:zfree -a sleep 1

[root@ABCD]# perf record -e probe_3591:zfree -a sleep 10
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
[root@ABCD]#

 tools/perf/builtin-probe.c     |   13 +
 tools/perf/builtin-top.c       |   20 --
 tools/perf/util/event.c        |   20 ++
 tools/perf/util/event.h        |    1 
 tools/perf/util/probe-event.c  |  520 +++++++++++++++++++++++++++++-----------
 tools/perf/util/probe-event.h  |   37 +--
 tools/perf/util/probe-finder.c |   34 +--
 tools/perf/util/probe-finder.h |   10 -
 8 files changed, 445 insertions(+), 210 deletions(-)


diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5455186..cb915a5 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -55,6 +55,7 @@ static struct {
 	struct strlist *dellist;
 	struct line_range line_range;
 	int max_probe_points;
+	pid_t upid;
 } params;
 
 
@@ -73,6 +74,7 @@ static int parse_probe_event(const char *str)
 	/* Parse a perf-probe command into event */
 	ret = parse_perf_probe_command(str, pev);
 	pr_debug("%d arguments\n", pev->nargs);
+	pev->upid = params.upid;
 
 	return ret;
 }
@@ -188,6 +190,8 @@ static const struct option options[] = {
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
 		 "Set how many probe points can be found for a probe."),
+	OPT_INTEGER('p', "pid", &params.upid,
+			"specify a pid for a uprobes based probe"),
 	OPT_END()
 };
 
@@ -225,6 +229,10 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_err("  Error: Don't use --list with --line.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (params.upid) {
+			pr_warning("  Error: Don't use --list with --pid.\n");
+			usage_with_options(probe_usage, options);
+		}
 		ret = show_perf_probe_events();
 		if (ret < 0)
 			pr_err("  Error: Failed to show event list. (%d)\n",
@@ -233,7 +241,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 
 #ifdef DWARF_SUPPORT
-	if (params.show_lines) {
+	if (params.show_lines && !params.upid) {
 		if (params.nevents != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --line with"
 				   " --add/--del.\n");
@@ -248,7 +256,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 #endif
 
 	if (params.dellist) {
-		ret = del_perf_probe_events(params.dellist);
+		ret = del_perf_probe_events(params.dellist, params.upid);
 		strlist__delete(params.dellist);
 		if (ret < 0) {
 			pr_err("  Error: Failed to delete events. (%d)\n", ret);
@@ -267,4 +275,3 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 	return 0;
 }
-
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1e8e92e..b513e40 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1082,26 +1082,6 @@ static void event__process_sample(const event_t *self,
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
index d7f21d7..d93e0bb 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -552,6 +552,26 @@ int event__process_task(event_t *self, struct perf_session *session)
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
 			   enum map_type type, pid_t pid, u64 addr,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 887ee63..8e790da 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -154,6 +154,7 @@ int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
 int event__process_mmap(event_t *self, struct perf_session *session);
 int event__process_task(event_t *self, struct perf_session *session);
+int event__process(event_t *event, struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 09cf546..ef7c2d5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1,5 +1,5 @@
 /*
- * probe-event.c : perf-probe definition to kprobe_events format converter
+ * probe-event.c : perf-probe definition to probe_events format converter
  *
  * Written by Masami Hiramatsu <mhiramat@redhat.com>
  *
@@ -46,6 +46,7 @@
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
+#include "session.h"
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -72,6 +73,7 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 }
 
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
+static int convert_name_to_addr(struct perf_probe_event *pev);
 static struct machine machine;
 
 /* Initialize symbol maps and path of vmlinux */
@@ -109,6 +111,18 @@ out:
 	return ret;
 }
 
+static int convert_to_perf_probe_point(struct probe_trace_point *tp,
+					struct perf_probe_point *pp)
+{
+	pp->function = strdup(tp->symbol);
+	if (pp->function == NULL)
+		return -ENOMEM;
+	pp->offset = tp->offset;
+	pp->retprobe = tp->retprobe;
+
+	return 0;
+}
+
 #ifdef DWARF_SUPPORT
 static int open_vmlinux(void)
 {
@@ -120,8 +134,12 @@ static int open_vmlinux(void)
 	return open(machine.vmlinux_maps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
 }
 
-/* Convert trace point to probe point with debuginfo */
-static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
+/*
+ * Convert trace point to probe point with debuginfo
+ * Currently only handles kprobes.
+ */
+
+static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 				       struct perf_probe_point *pp)
 {
 	struct symbol *sym;
@@ -151,13 +169,21 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 }
 
 /* Try to find perf_probe_event with debuginfo */
-static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
-					   struct kprobe_trace_event **tevs,
+static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
+					   struct probe_trace_event **tevs,
 					   int max_tevs)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
 	int fd, ntevs;
 
+	if (pev->upid) {
+		if (need_dwarf) {
+			pr_warning("Debuginfo-analysis is not supported.\n");
+			return -ENOSYS;
+		}
+		return convert_name_to_addr(pev);
+	}
+
 	fd = open_vmlinux();
 	if (fd < 0) {
 		if (need_dwarf) {
@@ -169,11 +195,11 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Searching trace events corresponding to probe event */
-	ntevs = find_kprobe_trace_events(fd, pev, tevs, max_tevs);
+	ntevs = find_probe_trace_events(fd, pev, tevs, max_tevs);
 	close(fd);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
-		pr_debug("find %d kprobe_trace_events.\n", ntevs);
+		pr_debug("find %d probe_trace_events.\n", ntevs);
 		return ntevs;
 	}
 
@@ -308,26 +334,23 @@ end:
 
 #else	/* !DWARF_SUPPORT */
 
-static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
-					struct perf_probe_point *pp)
+static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
+				       struct perf_probe_point *pp)
 {
-	pp->function = strdup(tp->symbol);
-	if (pp->function == NULL)
-		return -ENOMEM;
-	pp->offset = tp->offset;
-	pp->retprobe = tp->retprobe;
-
-	return 0;
+	return convert_to_perf_probe_point(tp, pp);
 }
 
-static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
-				struct kprobe_trace_event **tevs __unused,
+static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
+				struct probe_trace_event **tevs __unused,
 				int max_tevs __unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
 		pr_warning("Debuginfo-analysis is not supported.\n");
 		return -ENOSYS;
 	}
+	if (pev->upid)
+		return convert_name_to_addr(pev);
+
 	return 0;
 }
 
@@ -403,6 +426,115 @@ static bool check_event_name(const char *name)
 	return true;
 }
 
+/*
+ * uprobe_events only accepts address:
+ * Convert function and any offset to address
+ */
+static int convert_name_to_addr(struct perf_probe_event *pev)
+{
+	struct perf_probe_point *pp = &pev->point;
+	struct perf_session *session;
+	struct thread *thread;
+	struct symbol *sym;
+	struct map *map;
+	char *name;
+	int ret = -EINVAL;
+	unsigned long long vaddr;
+
+	/* check if user has specifed a virtual address */
+	vaddr = strtoul(pp->function, NULL, 0);
+	session = perf_session__new(NULL, O_WRONLY, false, false);
+	if (!session) {
+		pr_warning("Cannot initialize perf session.\n");
+		return -ENOMEM;
+	}
+
+	symbol_conf.try_vmlinux_path = false;
+	if (!vaddr)
+		symbol_conf.sort_by_name = true;
+	if (symbol__init() < 0) {
+		pr_warning("Cannot initialize symbols.\n");
+		goto free_session;
+	}
+
+	event__synthesize_thread(pev->upid, event__process, session);
+	thread = perf_session__findnew(session, pev->upid);
+	if (!thread) {
+		pr_warning("Cannot initialize perf session.\n");
+		goto free_session;
+	}
+
+	if (vaddr) {
+		if (pev->event) {
+			ret = 0;
+			goto free_session;
+		}
+
+		pev->event = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
+		if (!pev->event) {
+			ret = -ENOMEM;
+			pr_warning("Cannot allocate memory for event.\n");
+			goto free_session;
+		}
+
+		sym = map_groups__find_symbol(&thread->mg, MAP__FUNCTION,
+							vaddr, NULL, NULL);
+		if (!sym)
+			snprintf(pev->event, MAX_PROBE_ARGS, "p_%llx", vaddr);
+		else
+			snprintf(pev->event, MAX_PROBE_ARGS, "%s_%llx",
+							sym->name, vaddr);
+		ret = 0;
+		goto free_session;
+	}
+
+	if (!pp->file)
+		/* Lets find the function in the executable. */
+		name = thread->comm;
+	else
+		name = basename(make_absolute_path(pp->file));
+
+	if (!name) {
+		pr_debug("Please check DSO and retry\n");
+		goto free_session;
+	}
+
+	map = map_groups__find_by_name(&thread->mg, MAP__FUNCTION, name);
+	if (!map) {
+		pr_warning("Cannot find appropriate DSO.\n");
+		goto free_session;
+	}
+
+	sym = map__find_symbol_by_name(map, pp->function, NULL);
+	if (!sym) {
+		pr_warning("Cannot find appropriate DSO.\n");
+		goto free_session;
+	}
+
+	if (map->start > sym->start)
+		vaddr = map->start;
+	vaddr += sym->start + pp->offset + map->pgoff;
+	pp->offset = 0;
+
+	if (!pev->event)
+		pev->event = pp->function;
+	else
+		free(pp->function);
+	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
+	if (!pp->function) {
+		ret = -ENOMEM;
+		pr_warning("Failed to allocate memory by zalloc.\n");
+		goto free_session;
+	}
+	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
+	ret = 0;
+
+free_session:
+	if (session)
+		perf_session__delete(session);
+	return ret;
+}
+
 /* Parse probepoint definition. */
 static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 {
@@ -542,6 +674,11 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 		return -EINVAL;
 	}
 
+	if (pev->upid && !pp->function) {
+		semantic_error("No function specified for uprobes");
+		return -EINVAL;
+	}
+
 	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe) {
 		semantic_error("Offset/Line/Lazy pattern can't be used with "
 			       "return probe.");
@@ -551,6 +688,14 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 	pr_debug("symbol:%s file:%s line:%d offset:%lu return:%d lazy:%s\n",
 		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
 		 pp->lazy_line);
+
+	if (pev->upid && perf_probe_event_need_dwarf(pev)) {
+		semantic_error("no dwarf based probes for uprobes.");
+		return -EINVAL;
+	}
+
+	if (pev->upid)
+		return convert_name_to_addr(pev);
 	return 0;
 }
 
@@ -702,7 +847,8 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 {
 	int i;
 
-	if (pev->point.file || pev->point.line || pev->point.lazy_line)
+	if ((pev->point.file && !pev->upid) || pev->point.line ||
+					pev->point.lazy_line)
 		return true;
 
 	for (i = 0; i < pev->nargs; i++)
@@ -712,16 +858,17 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 	return false;
 }
 
-/* Parse kprobe_events event into struct probe_point */
-int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
+/* Parse probe_events (uprobe_events) event into struct probe_point */
+static int parse_probe_trace_command(const char *cmd,
+					struct probe_trace_event *tev)
 {
-	struct kprobe_trace_point *tp = &tev->point;
+	struct probe_trace_point *tp = &tev->point;
 	char pr;
 	char *p;
 	int ret, i, argc;
 	char **argv;
 
-	pr_debug("Parsing kprobe_events: %s\n", cmd);
+	pr_debug("Parsing probe_events: %s\n", cmd);
 	argv = argv_split(cmd, &argc);
 	if (!argv) {
 		pr_debug("Failed to split arguments.\n");
@@ -753,7 +900,7 @@ int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 		tp->offset = 0;
 
 	tev->nargs = argc - 2;
-	tev->args = zalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
 	if (tev->args == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -899,13 +1046,13 @@ char *synthesize_perf_probe_command(struct perf_probe_event *pev)
 }
 #endif
 
-static int __synthesize_kprobe_trace_arg_ref(struct kprobe_trace_arg_ref *ref,
+static int __synthesize_probe_trace_arg_ref(struct probe_trace_arg_ref *ref,
 					     char **buf, size_t *buflen,
 					     int depth)
 {
 	int ret;
 	if (ref->next) {
-		depth = __synthesize_kprobe_trace_arg_ref(ref->next, buf,
+		depth = __synthesize_probe_trace_arg_ref(ref->next, buf,
 							 buflen, depth + 1);
 		if (depth < 0)
 			goto out;
@@ -923,10 +1070,10 @@ out:
 
 }
 
-static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
+static int synthesize_probe_trace_arg(struct probe_trace_arg *arg,
 				       char *buf, size_t buflen)
 {
-	struct kprobe_trace_arg_ref *ref = arg->ref;
+	struct probe_trace_arg_ref *ref = arg->ref;
 	int ret, depth = 0;
 	char *tmp = buf;
 
@@ -946,7 +1093,7 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 
 	/* Dereferencing arguments */
 	if (ref) {
-		depth = __synthesize_kprobe_trace_arg_ref(ref, &buf,
+		depth = __synthesize_probe_trace_arg_ref(ref, &buf,
 							  &buflen, 1);
 		if (depth < 0)
 			return depth;
@@ -982,9 +1129,9 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 	return buf - tmp;
 }
 
-char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev)
+char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 {
-	struct kprobe_trace_point *tp = &tev->point;
+	struct probe_trace_point *tp = &tev->point;
 	char *buf;
 	int i, len, ret;
 
@@ -992,15 +1139,27 @@ char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev)
 	if (buf == NULL)
 		return NULL;
 
-	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
-			 tp->retprobe ? 'r' : 'p',
-			 tev->group, tev->event,
-			 tp->symbol, tp->offset);
+	if (tev->upid)
+		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %d:%s\n",
+				 tp->retprobe ? 'r' : 'p',
+				 tev->group, tev->event,
+				 tev->upid, tp->symbol);
+	else if (tp->offset)
+		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
+				 tp->retprobe ? 'r' : 'p',
+				 tev->group, tev->event,
+				 tp->symbol, tp->offset);
+	else
+		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s",
+				 tp->retprobe ? 'r' : 'p',
+				 tev->group, tev->event,
+				 tp->symbol);
+
 	if (len <= 0)
 		goto error;
 
 	for (i = 0; i < tev->nargs; i++) {
-		ret = synthesize_kprobe_trace_arg(&tev->args[i], buf + len,
+		ret = synthesize_probe_trace_arg(&tev->args[i], buf + len,
 						  MAX_CMDLEN - len);
 		if (ret <= 0)
 			goto error;
@@ -1013,8 +1172,8 @@ error:
 	return NULL;
 }
 
-int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
-				struct perf_probe_event *pev)
+static int convert_to_perf_probe_event(struct probe_trace_event *tev,
+				struct perf_probe_event *pev, bool is_kprobe)
 {
 	char buf[64] = "";
 	int i, ret;
@@ -1026,7 +1185,11 @@ int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 		return -ENOMEM;
 
 	/* Convert trace_point to probe_point */
-	ret = convert_to_perf_probe_point(&tev->point, &pev->point);
+	if (is_kprobe)
+		ret = kprobe_convert_to_perf_probe(&tev->point, &pev->point);
+	else
+		ret = convert_to_perf_probe_point(&tev->point, &pev->point);
+
 	if (ret < 0)
 		return ret;
 
@@ -1039,7 +1202,7 @@ int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 		if (tev->args[i].name)
 			pev->args[i].name = strdup(tev->args[i].name);
 		else {
-			ret = synthesize_kprobe_trace_arg(&tev->args[i],
+			ret = synthesize_probe_trace_arg(&tev->args[i],
 							  buf, 64);
 			pev->args[i].name = strdup(buf);
 		}
@@ -1090,9 +1253,9 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 	memset(pev, 0, sizeof(*pev));
 }
 
-void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
+static void clear_probe_trace_event(struct probe_trace_event *tev)
 {
-	struct kprobe_trace_arg_ref *ref, *next;
+	struct probe_trace_arg_ref *ref, *next;
 	int i;
 
 	if (tev->event)
@@ -1120,7 +1283,7 @@ void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
 	memset(tev, 0, sizeof(*tev));
 }
 
-static int open_kprobe_events(bool readwrite)
+static int open_probe_events(bool readwrite, bool is_kprobe)
 {
 	char buf[PATH_MAX];
 	const char *__debugfs;
@@ -1131,8 +1294,13 @@ static int open_kprobe_events(bool readwrite)
 		pr_warning("Debugfs is not mounted.\n");
 		return -ENOENT;
 	}
+	if (is_kprobe)
+		ret = e_snprintf(buf, PATH_MAX, "%stracing/kprobe_events",
+							__debugfs);
+	else
+		ret = e_snprintf(buf, PATH_MAX, "%stracing/uprobe_events",
+							__debugfs);
 
-	ret = e_snprintf(buf, PATH_MAX, "%stracing/kprobe_events", __debugfs);
 	if (ret >= 0) {
 		pr_debug("Opening %s write=%d\n", buf, readwrite);
 		if (readwrite && !probe_event_dry_run)
@@ -1143,17 +1311,30 @@ static int open_kprobe_events(bool readwrite)
 
 	if (ret < 0) {
 		if (errno == ENOENT)
-			pr_warning("kprobe_events file does not exist - please"
-				 " rebuild kernel with CONFIG_KPROBE_EVENT.\n");
+			pr_warning("%s file does not exist - please"
+				" rebuild kernel with CONFIG_%s_EVENT.\n",
+				is_kprobe ? "kprobe_events" : "uprobe_events",
+				is_kprobe ? "KPROBE" : "UPROBE");
 		else
-			pr_warning("Failed to open kprobe_events file: %s\n",
-				   strerror(errno));
+			pr_warning("Failed to open %s file: %s\n",
+				is_kprobe ? "kprobe_events" : "uprobe_events",
+				strerror(errno));
 	}
 	return ret;
 }
 
-/* Get raw string list of current kprobe_events */
-static struct strlist *get_kprobe_trace_command_rawlist(int fd)
+static int open_kprobe_events(bool readwrite)
+{
+	return open_probe_events(readwrite, 1);
+}
+
+static int open_uprobe_events(bool readwrite)
+{
+	return open_probe_events(readwrite, 0);
+}
+
+/* Get raw string list of current kprobe_events  or uprobe_events */
+static struct strlist *get_probe_trace_command_rawlist(int fd)
 {
 	int ret, idx;
 	FILE *fp;
@@ -1217,64 +1398,78 @@ static int show_perf_probe_event(struct perf_probe_event *pev)
 	return ret;
 }
 
-/* List up current perf-probe events */
-int show_perf_probe_events(void)
+static int __show_perf_probe_events(int fd, bool is_kprobe)
 {
-	int fd, ret;
-	struct kprobe_trace_event tev;
+	int ret = 0;
+	struct probe_trace_event tev;
 	struct perf_probe_event pev;
 	struct strlist *rawlist;
 	struct str_node *ent;
 
-	setup_pager();
-	ret = init_vmlinux();
-	if (ret < 0)
-		return ret;
-
 	memset(&tev, 0, sizeof(tev));
 	memset(&pev, 0, sizeof(pev));
 
-	fd = open_kprobe_events(false);
-	if (fd < 0)
-		return fd;
-
-	rawlist = get_kprobe_trace_command_rawlist(fd);
-	close(fd);
+	rawlist = get_probe_trace_command_rawlist(fd);
 	if (!rawlist)
 		return -ENOENT;
 
 	strlist__for_each(ent, rawlist) {
-		ret = parse_kprobe_trace_command(ent->s, &tev);
+		ret = parse_probe_trace_command(ent->s, &tev);
 		if (ret >= 0) {
-			ret = convert_to_perf_probe_event(&tev, &pev);
+			ret = convert_to_perf_probe_event(&tev, &pev,
+								is_kprobe);
 			if (ret >= 0)
 				ret = show_perf_probe_event(&pev);
 		}
 		clear_perf_probe_event(&pev);
-		clear_kprobe_trace_event(&tev);
+		clear_probe_trace_event(&tev);
 		if (ret < 0)
 			break;
 	}
 	strlist__delete(rawlist);
+	return ret;
+}
+
+/* List up current perf-probe events */
+int show_perf_probe_events(void)
+{
+	int fd, ret;
+
+	setup_pager();
+	fd = open_kprobe_events(false);
+	if (fd < 0)
+		return fd;
+
+	ret = init_vmlinux();
+	if (ret < 0)
+		return ret;
+
+	ret = __show_perf_probe_events(fd, true);
+	close(fd);
+
+	fd = open_uprobe_events(false);
+	if (fd >= 0) {
+		ret = __show_perf_probe_events(fd, false);
+		close(fd);
+	}
 
 	return ret;
 }
 
 /* Get current perf-probe event names */
-static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
+static struct strlist *get_probe_trace_event_names(int fd, bool include_group)
 {
 	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
-	struct kprobe_trace_event tev;
+	struct probe_trace_event tev;
 	int ret = 0;
 
 	memset(&tev, 0, sizeof(tev));
-
-	rawlist = get_kprobe_trace_command_rawlist(fd);
+	rawlist = get_probe_trace_command_rawlist(fd);
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
-		ret = parse_kprobe_trace_command(ent->s, &tev);
+		ret = parse_probe_trace_command(ent->s, &tev);
 		if (ret < 0)
 			break;
 		if (include_group) {
@@ -1284,7 +1479,7 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 				ret = strlist__add(sl, buf);
 		} else
 			ret = strlist__add(sl, tev.event);
-		clear_kprobe_trace_event(&tev);
+		clear_probe_trace_event(&tev);
 		if (ret < 0)
 			break;
 	}
@@ -1297,13 +1492,13 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 	return sl;
 }
 
-static int write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
+static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 {
 	int ret = 0;
-	char *buf = synthesize_kprobe_trace_command(tev);
+	char *buf = synthesize_probe_trace_command(tev);
 
 	if (!buf) {
-		pr_debug("Failed to synthesize kprobe trace event.\n");
+		pr_debug("Failed to synthesize probe trace event.\n");
 		return -EINVAL;
 	}
 
@@ -1356,21 +1551,24 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
 	return ret;
 }
 
-static int __add_kprobe_trace_events(struct perf_probe_event *pev,
-				     struct kprobe_trace_event *tevs,
+static int __add_probe_trace_events(struct perf_probe_event *pev,
+				     struct probe_trace_event *tevs,
 				     int ntevs, bool allow_suffix)
 {
 	int i, fd, ret;
-	struct kprobe_trace_event *tev = NULL;
+	struct probe_trace_event *tev = NULL;
 	char buf[64];
 	const char *event, *group;
 	struct strlist *namelist;
 
-	fd = open_kprobe_events(true);
+	if (pev->upid)
+		fd = open_uprobe_events(true);
+	else
+		fd = open_kprobe_events(true);
 	if (fd < 0)
 		return fd;
 	/* Get current event names */
-	namelist = get_kprobe_trace_event_names(fd, false);
+	namelist = get_probe_trace_event_names(fd, false);
 	if (!namelist) {
 		pr_debug("Failed to get current event list.\n");
 		return -EIO;
@@ -1380,17 +1578,28 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 	printf("Add new event%s\n", (ntevs > 1) ? "s:" : ":");
 	for (i = 0; i < ntevs; i++) {
 		tev = &tevs[i];
-		if (pev->event)
-			event = pev->event;
-		else
-			if (pev->point.function)
-				event = pev->point.function;
-			else
-				event = tev->point.symbol;
+
 		if (pev->group)
 			group = pev->group;
-		else
+		else if (!pev->upid)
 			group = PERFPROBE_GROUP;
+		else {
+			/*
+			 * For uprobes based probes create a group
+			 * probe_<pid>.
+			 */
+			snprintf(buf, 64, "%s_%d", PERFPROBE_GROUP, pev->upid);
+			group = buf;
+		}
+
+		tev->group = strdup(group);
+
+		if (pev->event)
+			event = pev->event;
+		else if (pev->point.function)
+			event = pev->point.function;
+		else
+			event = tev->point.symbol;
 
 		/* Get an unused new event name */
 		ret = get_new_event_name(buf, 64, event,
@@ -1398,14 +1607,13 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 		if (ret < 0)
 			break;
 		event = buf;
-
 		tev->event = strdup(event);
-		tev->group = strdup(group);
+
 		if (tev->event == NULL || tev->group == NULL) {
 			ret = -ENOMEM;
 			break;
 		}
-		ret = write_kprobe_trace_event(fd, tev);
+		ret = write_probe_trace_event(fd, tev);
 		if (ret < 0)
 			break;
 		/* Add added event name to namelist */
@@ -1442,21 +1650,21 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
-					  struct kprobe_trace_event **tevs,
+static int convert_to_probe_trace_events(struct perf_probe_event *pev,
+					  struct probe_trace_event **tevs,
 					  int max_tevs)
 {
 	struct symbol *sym;
 	int ret = 0, i;
-	struct kprobe_trace_event *tev;
+	struct probe_trace_event *tev;
 
 	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_kprobe_trace_events(pev, tevs, max_tevs);
+	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs);
 	if (ret != 0)
 		return ret;
 
 	/* Allocate trace event buffer */
-	tev = *tevs = zalloc(sizeof(struct kprobe_trace_event));
+	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
 	if (tev == NULL)
 		return -ENOMEM;
 
@@ -1469,7 +1677,7 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	tev->point.offset = pev->point.offset;
 	tev->nargs = pev->nargs;
 	if (tev->nargs) {
-		tev->args = zalloc(sizeof(struct kprobe_trace_arg)
+		tev->args = zalloc(sizeof(struct probe_trace_arg)
 				   * tev->nargs);
 		if (tev->args == NULL) {
 			ret = -ENOMEM;
@@ -1498,6 +1706,11 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 		}
 	}
 
+	if (pev->upid) {
+		tev->upid = pev->upid;
+		return 1;
+	}
+
 	/* Currently just checking function name from symbol map */
 	sym = map__find_symbol_by_name(machine.vmlinux_maps[MAP__FUNCTION],
 				       tev->point.symbol, NULL);
@@ -1510,7 +1723,7 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 
 	return 1;
 error:
-	clear_kprobe_trace_event(tev);
+	clear_probe_trace_event(tev);
 	free(tev);
 	*tevs = NULL;
 	return ret;
@@ -1518,30 +1731,32 @@ error:
 
 struct __event_package {
 	struct perf_probe_event		*pev;
-	struct kprobe_trace_event	*tevs;
+	struct probe_trace_event	*tevs;
 	int				ntevs;
 };
 
 int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 			  bool force_add, int max_tevs)
 {
-	int i, j, ret;
+	int i, j, ret = 0;
 	struct __event_package *pkgs;
 
 	pkgs = zalloc(sizeof(struct __event_package) * npevs);
 	if (pkgs == NULL)
 		return -ENOMEM;
 
-	/* Init vmlinux path */
-	ret = init_vmlinux();
-	if (ret < 0)
-		return ret;
+	if (!pevs->upid) {
+		/* Init vmlinux path */
+		ret = init_vmlinux();
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Loop 1: convert all events */
 	for (i = 0; i < npevs; i++) {
 		pkgs[i].pev = &pevs[i];
 		/* Convert with or without debuginfo */
-		ret  = convert_to_kprobe_trace_events(pkgs[i].pev,
+		ret  = convert_to_probe_trace_events(pkgs[i].pev,
 						      &pkgs[i].tevs, max_tevs);
 		if (ret < 0)
 			goto end;
@@ -1550,24 +1765,24 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 
 	/* Loop 2: add all events */
 	for (i = 0; i < npevs && ret >= 0; i++)
-		ret = __add_kprobe_trace_events(pkgs[i].pev, pkgs[i].tevs,
+		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
 						pkgs[i].ntevs, force_add);
 end:
 	/* Loop 3: cleanup trace events  */
 	for (i = 0; i < npevs; i++)
 		for (j = 0; j < pkgs[i].ntevs; j++)
-			clear_kprobe_trace_event(&pkgs[i].tevs[j]);
+			clear_probe_trace_event(&pkgs[i].tevs[j]);
 
 	return ret;
 }
 
-static int __del_trace_kprobe_event(int fd, struct str_node *ent)
+static int __del_trace_probe_event(int fd, struct str_node *ent)
 {
 	char *p;
 	char buf[128];
 	int ret;
 
-	/* Convert from perf-probe event to trace-kprobe event */
+	/* Convert from perf-probe event to trace-probe event */
 	ret = e_snprintf(buf, 128, "-:%s", ent->s);
 	if (ret < 0)
 		goto error;
@@ -1593,24 +1808,16 @@ error:
 	return ret;
 }
 
-static int del_trace_kprobe_event(int fd, const char *group,
-				  const char *event, struct strlist *namelist)
+static int del_trace_probe_event(int fd, const char *buf,
+						  struct strlist *namelist)
 {
-	char buf[128];
 	struct str_node *ent, *n;
-	int found = 0, ret = 0;
-
-	ret = e_snprintf(buf, 128, "%s:%s", group, event);
-	if (ret < 0) {
-		pr_err("Failed to copy event.");
-		return ret;
-	}
+	int ret = -1;
 
 	if (strpbrk(buf, "*?")) { /* Glob-exp */
 		strlist__for_each_safe(ent, n, namelist)
 			if (strglobmatch(ent->s, buf)) {
-				found++;
-				ret = __del_trace_kprobe_event(fd, ent);
+				ret = __del_trace_probe_event(fd, ent);
 				if (ret < 0)
 					break;
 				strlist__remove(namelist, ent);
@@ -1618,40 +1825,44 @@ static int del_trace_kprobe_event(int fd, const char *group,
 	} else {
 		ent = strlist__find(namelist, buf);
 		if (ent) {
-			found++;
-			ret = __del_trace_kprobe_event(fd, ent);
+			ret = __del_trace_probe_event(fd, ent);
 			if (ret >= 0)
 				strlist__remove(namelist, ent);
 		}
 	}
-	if (found == 0 && ret >= 0)
-		pr_info("Info: Event \"%s\" does not exist.\n", buf);
-
 	return ret;
 }
 
-int del_perf_probe_events(struct strlist *dellist)
+int del_perf_probe_events(struct strlist *dellist, pid_t pid)
 {
-	int fd, ret = 0;
+	int ret = -1, ufd = -1, kfd = -1;
+	char buf[128];
 	const char *group, *event;
 	char *p, *str;
 	struct str_node *ent;
-	struct strlist *namelist;
+	struct strlist *namelist = NULL, *unamelist = NULL;
 
-	fd = open_kprobe_events(true);
-	if (fd < 0)
-		return fd;
 
 	/* Get current event names */
-	namelist = get_kprobe_trace_event_names(fd, true);
-	if (namelist == NULL)
-		return -EINVAL;
+	if (!pid) {
+		kfd = open_kprobe_events(true);
+		if (kfd < 0)
+			return kfd;
+		namelist = get_probe_trace_event_names(kfd, true);
+	}
+
+	ufd = open_uprobe_events(true);
+	if (ufd >= 0)
+		unamelist = get_probe_trace_event_names(ufd, true);
+
+	if (namelist == NULL && unamelist == NULL)
+		goto error;
 
 	strlist__for_each(ent, dellist) {
 		str = strdup(ent->s);
 		if (str == NULL) {
 			ret = -ENOMEM;
-			break;
+			goto error;
 		}
 		pr_debug("Parsing: %s\n", str);
 		p = strchr(str, ':');
@@ -1663,15 +1874,36 @@ int del_perf_probe_events(struct strlist *dellist)
 			group = "*";
 			event = str;
 		}
+
+		ret = e_snprintf(buf, 128, "%s:%s", group, event);
+		if (ret < 0) {
+			pr_err("Failed to copy event.");
+			free(str);
+			goto error;
+		}
+
 		pr_debug("Group: %s, Event: %s\n", group, event);
-		ret = del_trace_kprobe_event(fd, group, event, namelist);
+		if (!pid && namelist)
+			ret = del_trace_probe_event(kfd, buf, namelist);
+		if (unamelist && ret != 0)
+			ret = del_trace_probe_event(ufd, buf, unamelist);
+
 		free(str);
-		if (ret < 0)
-			break;
+		if (ret != 0)
+			pr_info("Info: Event \"%s\" does not exist.\n", buf);
 	}
-	strlist__delete(namelist);
-	close(fd);
 
+error:
+	if (kfd >= 0) {
+		if (namelist)
+			strlist__delete(namelist);
+		close(kfd);
+	}
+
+	if (ufd >= 0) {
+		if (unamelist)
+			strlist__delete(unamelist);
+		close(ufd);
+	}
 	return ret;
 }
-
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index bc06d3e..f69f98e 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -6,34 +6,35 @@
 
 extern bool probe_event_dry_run;
 
-/* kprobe-tracer tracing point */
-struct kprobe_trace_point {
+/* kprobe-tracer and uprobe-tracer tracing point */
+struct probe_trace_point {
 	char		*symbol;	/* Base symbol */
 	unsigned long	offset;		/* Offset from symbol */
 	bool		retprobe;	/* Return probe flag */
 };
 
-/* kprobe-tracer tracing argument referencing offset */
-struct kprobe_trace_arg_ref {
-	struct kprobe_trace_arg_ref	*next;	/* Next reference */
+/* probe-tracer tracing argument referencing offset */
+struct probe_trace_arg_ref {
+	struct probe_trace_arg_ref	*next;	/* Next reference */
 	long				offset;	/* Offset value */
 };
 
-/* kprobe-tracer tracing argument */
-struct kprobe_trace_arg {
+/* kprobe-tracer and uprobe-tracer tracing argument */
+struct probe_trace_arg {
 	char				*name;	/* Argument name */
 	char				*value;	/* Base value */
 	char				*type;	/* Type name */
-	struct kprobe_trace_arg_ref	*ref;	/* Referencing offset */
+	struct probe_trace_arg_ref	*ref;	/* Referencing offset */
 };
 
-/* kprobe-tracer tracing event (point + arg) */
-struct kprobe_trace_event {
+/* kprobe-tracer and uprobe-tracer tracing event (point + arg) */
+struct probe_trace_event {
 	char				*event;	/* Event name */
 	char				*group;	/* Group name */
-	struct kprobe_trace_point	point;	/* Trace point */
+	struct probe_trace_point	point;	/* Trace point */
 	int				nargs;	/* Number of args */
-	struct kprobe_trace_arg		*args;	/* Arguments */
+	pid_t				upid;	/* uprobes only */
+	struct probe_trace_arg		*args;	/* Arguments */
 };
 
 /* Perf probe probing point */
@@ -68,6 +69,7 @@ struct perf_probe_event {
 	char			*group;	/* Group name */
 	struct perf_probe_point	point;	/* Probe point */
 	int			nargs;	/* Number of arguments */
+	pid_t			upid;
 	struct perf_probe_arg	*args;	/* Arguments */
 };
 
@@ -92,25 +94,18 @@ struct line_range {
 /* Command string to events */
 extern int parse_perf_probe_command(const char *cmd,
 				    struct perf_probe_event *pev);
-extern int parse_kprobe_trace_command(const char *cmd,
-				      struct kprobe_trace_event *tev);
 
 /* Events to command string */
 extern char *synthesize_perf_probe_command(struct perf_probe_event *pev);
-extern char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev);
+extern char *synthesize_probe_trace_command(struct probe_trace_event *tev);
 extern int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf,
 				     size_t len);
 
 /* Check the perf_probe_event needs debuginfo */
 extern bool perf_probe_event_need_dwarf(struct perf_probe_event *pev);
 
-/* Convert from kprobe_trace_event to perf_probe_event */
-extern int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
-				       struct perf_probe_event *pev);
-
 /* Release event contents */
 extern void clear_perf_probe_event(struct perf_probe_event *pev);
-extern void clear_kprobe_trace_event(struct kprobe_trace_event *tev);
 
 /* Command string to line-range */
 extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
@@ -118,7 +113,7 @@ extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 				 bool force_add, int max_probe_points);
-extern int del_perf_probe_events(struct strlist *dellist);
+extern int del_perf_probe_events(struct strlist *dellist, pid_t pid);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3e64e1f..f3a024a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -406,10 +406,10 @@ static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
  * Probe finder related functions
  */
 
-static struct kprobe_trace_arg_ref *alloc_trace_arg_ref(long offs)
+static struct probe_trace_arg_ref *alloc_trace_arg_ref(long offs)
 {
-	struct kprobe_trace_arg_ref *ref;
-	ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+	struct probe_trace_arg_ref *ref;
+	ref = zalloc(sizeof(struct probe_trace_arg_ref));
 	if (ref != NULL)
 		ref->offset = offs;
 	return ref;
@@ -425,7 +425,7 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 	Dwarf_Word offs = 0;
 	bool ref = false;
 	const char *regs;
-	struct kprobe_trace_arg *tvar = pf->tvar;
+	struct probe_trace_arg *tvar = pf->tvar;
 	int ret;
 
 	/* TODO: handle more than 1 exprs */
@@ -499,10 +499,10 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 }
 
 static int convert_variable_type(Dwarf_Die *vr_die,
-				 struct kprobe_trace_arg *tvar,
+				 struct probe_trace_arg *tvar,
 				 const char *cast)
 {
-	struct kprobe_trace_arg_ref **ref_ptr = &tvar->ref;
+	struct probe_trace_arg_ref **ref_ptr = &tvar->ref;
 	Dwarf_Die type;
 	char buf[16];
 	int ret;
@@ -540,7 +540,7 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 			while (*ref_ptr)
 				ref_ptr = &(*ref_ptr)->next;
 			/* Add new reference with offset +0 */
-			*ref_ptr = zalloc(sizeof(struct kprobe_trace_arg_ref));
+			*ref_ptr = zalloc(sizeof(struct probe_trace_arg_ref));
 			if (*ref_ptr == NULL) {
 				pr_warning("Out of memory error\n");
 				return -ENOMEM;
@@ -585,10 +585,10 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 
 static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 				    struct perf_probe_arg_field *field,
-				    struct kprobe_trace_arg_ref **ref_ptr,
+				    struct probe_trace_arg_ref **ref_ptr,
 				    Dwarf_Die *die_mem)
 {
-	struct kprobe_trace_arg_ref *ref = *ref_ptr;
+	struct probe_trace_arg_ref *ref = *ref_ptr;
 	Dwarf_Die type;
 	Dwarf_Word offs;
 	int ret, tag;
@@ -614,7 +614,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 		pr_debug2("Array real type: (%x)\n",
 			 (unsigned)dwarf_dieoffset(&type));
 		if (tag == DW_TAG_pointer_type) {
-			ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+			ref = zalloc(sizeof(struct probe_trace_arg_ref));
 			if (ref == NULL)
 				return -ENOMEM;
 			if (*ref_ptr)
@@ -645,7 +645,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			return -EINVAL;
 		}
 
-		ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+		ref = zalloc(sizeof(struct probe_trace_arg_ref));
 		if (ref == NULL)
 			return -ENOMEM;
 		if (*ref_ptr)
@@ -778,7 +778,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 /* Show a probe point to output buffer */
 static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
-	struct kprobe_trace_event *tev;
+	struct probe_trace_event *tev;
 	Dwarf_Addr eaddr;
 	Dwarf_Die die_mem;
 	const char *name;
@@ -843,7 +843,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* Find each argument */
 	tev->nargs = pf->pev->nargs;
-	tev->args = zalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
 	if (tev->args == NULL)
 		return -ENOMEM;
 	for (i = 0; i < pf->pev->nargs; i++) {
@@ -1100,9 +1100,9 @@ static int find_probe_point_by_func(struct probe_finder *pf)
 	return _param.retval;
 }
 
-/* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
-int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
-			     struct kprobe_trace_event **tevs, int max_tevs)
+/* Find probe_trace_events specified by perf_probe_event from debuginfo */
+int find_probe_trace_events(int fd, struct perf_probe_event *pev,
+			     struct probe_trace_event **tevs, int max_tevs)
 {
 	struct probe_finder pf = {.pev = pev, .max_tevs = max_tevs};
 	struct perf_probe_point *pp = &pev->point;
@@ -1112,7 +1112,7 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	Dwarf *dbg;
 	int ret = 0;
 
-	pf.tevs = zalloc(sizeof(struct kprobe_trace_event) * max_tevs);
+	pf.tevs = zalloc(sizeof(struct probe_trace_event) * max_tevs);
 	if (pf.tevs == NULL)
 		return -ENOMEM;
 	*tevs = pf.tevs;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index e1f61dc..4507d51 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -16,9 +16,9 @@ static inline int is_c_varname(const char *name)
 }
 
 #ifdef DWARF_SUPPORT
-/* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
-extern int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
-				    struct kprobe_trace_event **tevs,
+/* Find probe_trace_events specified by perf_probe_event from debuginfo */
+extern int find_probe_trace_events(int fd, struct perf_probe_event *pev,
+				    struct probe_trace_event **tevs,
 				    int max_tevs);
 
 /* Find a perf_probe_point from debuginfo */
@@ -33,7 +33,7 @@ extern int find_line_range(int fd, struct line_range *lr);
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
-	struct kprobe_trace_event *tevs;	/* Result trace events */
+	struct probe_trace_event *tevs;		/* Result trace events */
 	int			ntevs;		/* Number of trace events */
 	int			max_tevs;	/* Max number of trace events */
 
@@ -50,7 +50,7 @@ struct probe_finder {
 #endif
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
-	struct kprobe_trace_arg	*tvar;		/* Current result variable */
+	struct probe_trace_arg	*tvar;		/* Current result variable */
 };
 
 struct line_finder {
