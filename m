Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0HBMni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:43:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50986 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:43:37 -0400
Date: Mon, 2 Aug 2010 18:11:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
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
Subject: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for uprobes
Message-ID: <20100802124103.GE22812@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
 <20100730191903.GD12166@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100730191903.GD12166@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhances perf probe to accept pid and user vaddr.
Provides very basic support for uprobes.

TODO:
Update perf-probes.txt.
Global tracing.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from v10: moving of event__process moved to a new patch.
	Also addressed other comments from Arnaldo.

Changelog from v9: Renaming common fields/functions to refer to
probe instead of kprobe. This was suggested by Arnaldo.

Changelog from v8: Fixed a build break reported by Christoph Hellwig.

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

 tools/perf/builtin-probe.c    |   12 +
 tools/perf/util/probe-event.c |  391 +++++++++++++++++++++++++++++++++--------
 tools/perf/util/probe-event.h |   10 +
 3 files changed, 329 insertions(+), 84 deletions(-)


diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 199d5e1..a98ef8a 100644
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
+			"Specify pid of process where probe will be added"),
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
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2e665cb..7fd175f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
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
@@ -109,6 +111,32 @@ out:
 	return ret;
 }
 
+static int init_perf_uprobes(void)
+{
+	int ret = 0;
+
+	symbol_conf.try_vmlinux_path = false;
+	symbol_conf.sort_by_name = true;
+	ret = symbol__init();
+	if (ret < 0)
+		pr_debug("Failed to init symbol map.\n");
+
+	return ret;
+}
+
+
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
@@ -161,6 +189,15 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
 	int fd, ntevs;
 
+	if (pev->upid) {
+		if (need_dwarf) {
+			pr_warning("Debuginfo-analysis is not yet supported"
+					" with -p/--pid option.\n");
+			return -ENOSYS;
+		}
+		return convert_name_to_addr(pev);
+	}
+
 	fd = open_vmlinux();
 	if (fd < 0) {
 		if (need_dwarf) {
@@ -383,13 +420,7 @@ end:
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 				       struct perf_probe_point *pp)
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
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
@@ -400,6 +431,9 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 		pr_warning("Debuginfo-analysis is not supported.\n");
 		return -ENOSYS;
 	}
+	if (pev->upid)
+		return convert_name_to_addr(pev);
+
 	return 0;
 }
 
@@ -475,6 +509,109 @@ static bool check_event_name(const char *name)
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
+	char *name = NULL, *tmpname = NULL;
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
+	else {
+		tmpname = realpath(pp->file, NULL);
+		if (tmpname)
+			name = basename(tmpname);
+		else
+			name = pp->file;
+	}
+
+	map = map_groups__find_by_name(&thread->mg, MAP__FUNCTION, name);
+	if (pp->file && tmpname)
+		free(tmpname);
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
@@ -614,6 +751,11 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
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
@@ -623,6 +765,11 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 	pr_debug("symbol:%s file:%s line:%d offset:%lu return:%d lazy:%s\n",
 		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
 		 pp->lazy_line);
+
+	if (pev->upid && perf_probe_event_need_dwarf(pev)) {
+		semantic_error("no dwarf based probes for uprobes.");
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -774,7 +921,8 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 {
 	int i;
 
-	if (pev->point.file || pev->point.line || pev->point.lazy_line)
+	if ((pev->point.file && !pev->upid) || pev->point.line ||
+					pev->point.lazy_line)
 		return true;
 
 	for (i = 0; i < pev->nargs; i++)
@@ -1065,10 +1213,22 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 	if (buf == NULL)
 		return NULL;
 
-	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
-			 tp->retprobe ? 'r' : 'p',
-			 tev->group, tev->event,
-			 tp->symbol, tp->offset);
+	if (tev->upid)
+		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %d:%s",
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
 
@@ -1087,7 +1247,7 @@ error:
 }
 
 static int convert_to_perf_probe_event(struct probe_trace_event *tev,
-				struct perf_probe_event *pev)
+				struct perf_probe_event *pev, bool is_kprobe)
 {
 	char buf[64] = "";
 	int i, ret;
@@ -1099,7 +1259,11 @@ static int convert_to_perf_probe_event(struct probe_trace_event *tev,
 		return -ENOMEM;
 
 	/* Convert trace_point to probe_point */
-	ret = kprobe_convert_to_perf_probe(&tev->point, &pev->point);
+	if (is_kprobe)
+		ret = kprobe_convert_to_perf_probe(&tev->point, &pev->point);
+	else
+		ret = convert_to_perf_probe_point(&tev->point, &pev->point);
+
 	if (ret < 0)
 		return ret;
 
@@ -1193,7 +1357,7 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 	memset(tev, 0, sizeof(*tev));
 }
 
-static int open_kprobe_events(bool readwrite)
+static int open_probe_events(bool readwrite, bool is_kprobe)
 {
 	char buf[PATH_MAX];
 	const char *__debugfs;
@@ -1204,8 +1368,13 @@ static int open_kprobe_events(bool readwrite)
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
@@ -1216,16 +1385,29 @@ static int open_kprobe_events(bool readwrite)
 
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
 static struct strlist *get_probe_trace_command_rawlist(int fd)
 {
 	int ret, idx;
@@ -1290,36 +1472,26 @@ static int show_perf_probe_event(struct perf_probe_event *pev)
 	return ret;
 }
 
-/* List up current perf-probe events */
-int show_perf_probe_events(void)
+static int __show_perf_probe_events(int fd, bool is_kprobe)
 {
-	int fd, ret;
+	int ret = 0;
 	struct probe_trace_event tev;
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
 	rawlist = get_probe_trace_command_rawlist(fd);
-	close(fd);
 	if (!rawlist)
 		return -ENOENT;
 
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);
 		if (ret >= 0) {
-			ret = convert_to_perf_probe_event(&tev, &pev);
+			ret = convert_to_perf_probe_event(&tev, &pev,
+								is_kprobe);
 			if (ret >= 0)
 				ret = show_perf_probe_event(&pev);
 		}
@@ -1329,6 +1501,31 @@ int show_perf_probe_events(void)
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
@@ -1438,7 +1635,10 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
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
@@ -1452,17 +1652,26 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
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
+		if (pev->event)
+			event = pev->event;
+		else if (pev->point.function)
+			event = pev->point.function;
+		else
+			event = tev->point.symbol;
 
 		/* Get an unused new event name */
 		ret = get_new_event_name(buf, 64, event,
@@ -1570,6 +1779,11 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
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
@@ -1597,15 +1811,19 @@ struct __event_package {
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
+	if (!pevs->upid)
+		/* Init vmlinux path */
+		ret = init_vmlinux();
+	else
+		ret = init_perf_uprobes();
+
 	if (ret < 0)
 		return ret;
 
@@ -1665,23 +1883,15 @@ error:
 	return ret;
 }
 
-static int del_trace_probe_event(int fd, const char *group,
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
 				ret = __del_trace_probe_event(fd, ent);
 				if (ret < 0)
 					break;
@@ -1690,40 +1900,44 @@ static int del_trace_probe_event(int fd, const char *group,
 	} else {
 		ent = strlist__find(namelist, buf);
 		if (ent) {
-			found++;
 			ret = __del_trace_probe_event(fd, ent);
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
-	namelist = get_probe_trace_event_names(fd, true);
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
@@ -1735,15 +1949,36 @@ int del_perf_probe_events(struct strlist *dellist)
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
-		ret = del_trace_probe_event(fd, group, event, namelist);
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
index 5af3924..27f052c 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -6,7 +6,7 @@
 
 extern bool probe_event_dry_run;
 
-/* kprobe-tracer tracing point */
+/* kprobe-tracer and uprobe-tracer tracing point */
 struct probe_trace_point {
 	char		*symbol;	/* Base symbol */
 	unsigned long	offset;		/* Offset from symbol */
@@ -19,7 +19,7 @@ struct probe_trace_arg_ref {
 	long				offset;	/* Offset value */
 };
 
-/* kprobe-tracer tracing argument */
+/* kprobe-tracer and uprobe-tracer tracing argument */
 struct probe_trace_arg {
 	char				*name;	/* Argument name */
 	char				*value;	/* Base value */
@@ -27,12 +27,13 @@ struct probe_trace_arg {
 	struct probe_trace_arg_ref	*ref;	/* Referencing offset */
 };
 
-/* kprobe-tracer tracing event (point + arg) */
+/* kprobe-tracer and uprobe-tracer tracing event (point + arg) */
 struct probe_trace_event {
 	char				*event;	/* Event name */
 	char				*group;	/* Group name */
 	struct probe_trace_point	point;	/* Trace point */
 	int				nargs;	/* Number of args */
+	pid_t				upid;	/* uprobes only */
 	struct probe_trace_arg		*args;	/* Arguments */
 };
 
@@ -68,6 +69,7 @@ struct perf_probe_event {
 	char			*group;	/* Group name */
 	struct perf_probe_point	point;	/* Probe point */
 	int			nargs;	/* Number of arguments */
+	pid_t			upid;
 	struct perf_probe_arg	*args;	/* Arguments */
 };
 
@@ -112,7 +114,7 @@ extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 				 bool force_add, int max_probe_points);
-extern int del_perf_probe_events(struct strlist *dellist);
+extern int del_perf_probe_events(struct strlist *dellist, pid_t pid);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
 
