Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0HYNtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:49:12 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51523 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0HYNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:49:08 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
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
Date: Wed, 25 Aug 2010 19:14:21 +0530
Message-Id: <20100825134421.5447.50150.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 15/15] 15: perf: Show Potential probe points.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduces an option to list potential probes to probe using perf probe
command. Also introduces an option to limit the dso to list the potential
probes. Listing of potential probes is sorted by dso and
alphabetical order.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from V9:
	Filter labels, weak, and local binding functions from listing
as suggested by Christoph Hellwig.
	Incorporated comments from Arnaldo on Version 9 of patchset.

Show all potential probes in the current running kernel and limit to
the last 10 functions.
# perf probe -S | tail
zlib_inflateInit2
zlib_inflateReset
zlib_inflate_blob
zlib_inflate_table
zlib_inflate_workspacesize
zone_pcp_update
zone_reclaim
zone_reclaimable_pages
zone_statistics
zone_watermark_ok

Show all potential probes in a process by pid 3104 across all dsos
and limit to the last 10 functions.
# perf probe -S -p 3104 | tail
_nss_files_setgrent
_nss_files_sethostent
_nss_files_setnetent
_nss_files_setnetgrent
_nss_files_setprotoent
_nss_files_setpwent
_nss_files_setrpcent
_nss_files_setservent
_nss_files_setspent
_nss_netgroup_parseline

Show all potentail probes in a process by pid 3104 limit to zsh dso
and limit to the last 10 functions.
# perf probe -S -p 3104 -D zsh | tail
zstrtol
ztrcmp
ztrdup
ztrduppfx
ztrftime
ztrlen
ztrncpy
ztrsub
zwarn
zwarnnam

 tools/perf/builtin-probe.c    |    2 +
 tools/perf/util/probe-event.c |   68 +++++++++++++++++++++++++++++++++--------
 tools/perf/util/probe-event.h |    4 +-
 3 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index afca6ae..f5893d9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -274,7 +274,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 					" --line.\n");
 			usage_with_options(probe_usage, options);
 		}
-		ret = show_possible_probes(params.limitlist);
+		ret = show_possible_probes(params.limitlist, params.upid);
 		if (ret < 0)
 			pr_err("  Error: Failed to show possible"
 					" probes (%d).\n", ret);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 17a89b1..58146a7 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1923,7 +1923,6 @@ int del_perf_probe_events(struct strlist *dellist, pid_t pid)
 	struct str_node *ent;
 	struct strlist *namelist = NULL, *unamelist = NULL;
 
-
 	/* Get current event names */
 	if (!pid) {
 		kfd = open_kprobe_events(true);
@@ -2014,27 +2013,46 @@ static int print_list_available_symbols(struct map *map,
 	return 0;
 }
 
-int show_possible_probes(struct strlist *limitlist)
+int show_possible_probes(struct strlist *limitlist, pid_t pid)
 {
+	struct perf_session *session = NULL;
+	struct thread *thread = NULL;
 	struct str_node *ent;
 	struct map *map = NULL;
-	char *str;
+	char *name = NULL, *tmpname = NULL, *str;
 	int ret = -EINVAL;
 
-	if (!limitlist) { /* Show functions in kernel */
+	if (!pid && !limitlist) { /* Show functions in kernel */
 		ret = init_vmlinux();
 		if (ret < 0)
 			return ret;
 		return print_list_available_symbols(
 				machine.vmlinux_maps[MAP__FUNCTION], NULL);
+	} else {
+		ret = init_perf_uprobes();
+		if (ret < 0)
+			return ret;
 	}
-
-	symbol_conf.try_vmlinux_path = false;
-	symbol_conf.sort_by_name = true;
-	ret = symbol__init();
-	if (ret < 0) {
-		pr_debug("Failed to init symbol map.\n");
-		return ret;
+	if (pid)  {
+		session = perf_session__new(NULL, O_WRONLY, false, false);
+		if (!session) {
+			ret = -ENOMEM;
+			goto out_delete;
+		}
+		event__synthesize_thread(pid, event__process, session);
+		thread = perf_session__findnew(session, pid);
+		if (!thread)
+			goto out_delete;
+		if (!limitlist) {
+			map_groups__for_each_map(map, MAP__FUNCTION,
+								&thread->mg) {
+				ret = print_list_available_symbols(map, NULL);
+				if (ret)
+					pr_warning("No Symbols in dso %s.\n",
+							map->dso->short_name);
+			}
+			goto out_delete;
+		}
 	}
 
 	strlist__for_each(ent, limitlist) {
@@ -2044,18 +2062,40 @@ int show_possible_probes(struct strlist *limitlist)
 			goto out_delete;
 		}
 
-		map = dso__new_map(str);
+		if (pid) {
+			tmpname = realpath(str, NULL);
+			if (tmpname)
+				name = basename(tmpname);
+			if (!name)
+				name = str;
+			map = map_groups__find_by_name(&thread->mg,
+							MAP__FUNCTION, name);
+			if (tmpname)
+				free(tmpname);
+			if (!map) {
+				pr_warning("Skip probe listing in %s DSO.\n",
+							str);
+				free(str);
+				continue;
+			}
+		} else
+			map = dso__new_map(str);
+
 		ret = print_list_available_symbols(map, NULL);
 		if (ret)
 			pr_warning("No Symbols in dso %s.\n", str);
 
-		dso__delete(map->dso);
-		map__delete(map);
+		if (!pid) {
+			dso__delete(map->dso);
+			map__delete(map);
+		}
 		free(str);
 	}
 
 out_delete:
 	if (ret)
 		pr_warning("Failed to list available probes.\n");
+	if (session)
+		perf_session__delete(session);
 	return ret;
 }
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 9cf1bcc..4a40d2c 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -111,14 +111,12 @@ extern void clear_perf_probe_event(struct perf_probe_event *pev);
 /* Command string to line-range */
 extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
-
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 				 bool force_add, int max_probe_points);
 extern int del_perf_probe_events(struct strlist *dellist, pid_t pid);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
-extern int show_possible_probes(struct strlist *availlist);
-
+extern int show_possible_probes(struct strlist *availlist, pid_t pid);
 
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
