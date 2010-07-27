Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab0G0LNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:13:34 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33905 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab0G0LNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:13:31 -0400
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
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 27 Jul 2010 16:41:48 +0530
Message-Id: <20100727111148.24690.77378.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv10 2.6.35-rc6-tip 14/14]  [RFC] perf: show functions in a file without using pid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lists function names in a dso. Dso needs to a filename.
However passing Dso short name will not work.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from V9: Filter labels, weak, and local binding functions
from listing as suggested by Christoph Hellwig.

Show last 10 functions in /bin/zsh.

# perf probe -S -D /bin/zsh | tail
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

Show first 10 functions in /lib/libc.so.6

# perf probe -S -D /lib/libc.so.6 | head
_IO_adjust_column
_IO_adjust_wcolumn
_IO_default_doallocate
_IO_default_finish
_IO_default_pbackfail
_IO_default_uflow
_IO_default_xsgetn
_IO_default_xsputn
_IO_do_write@@GLIBC_2.2.5
_IO_doallocbuf

 tools/perf/util/probe-event.c |   75 ++++++++++++++++++++++-------------------
 tools/perf/util/symbol.c      |    8 ++++
 tools/perf/util/symbol.h      |    1 +
 3 files changed, 50 insertions(+), 34 deletions(-)


diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d0636e1..a079ecc 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2018,14 +2018,14 @@ static int print_list_available_symbols(struct map *map,
 
 int show_possible_probes(struct strlist *limitlist, pid_t pid)
 {
-	struct perf_session *session;
-	struct thread *thread;
+	struct perf_session *session = NULL;
+	struct thread *thread = NULL;
 	struct str_node *ent;
 	struct map *map = NULL;
 	char *name = NULL, *tmpname = NULL, *str;
 	int ret = -EINVAL;
 
-	if (!pid) {
+	if (!pid && !limitlist) { /* Show functions in kernel */
 		ret = init_vmlinux();
 		if (ret < 0)
 			return ret;
@@ -2036,26 +2036,28 @@ int show_possible_probes(struct strlist *limitlist, pid_t pid)
 		if (ret < 0)
 			return ret;
 	}
-	session = perf_session__new(NULL, O_WRONLY, false, false);
-	if (!session) {
-		ret = -ENOMEM;
-		goto out_delete;
-	}
-	event__synthesize_thread(pid, event__process, session);
-
-	thread = perf_session__findnew(session, pid);
-	if (!thread)
-		goto out_delete;
-
-	if (!limitlist) {
-		map_groups__for_each_map(map, MAP__FUNCTION, &thread->mg) {
-			ret = print_list_available_symbols(map, NULL);
-			if (ret)
-				pr_warning("No Symbols in dso %s.\n",
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
 							map->dso->short_name);
+			}
+			goto out_delete;
 		}
-		goto out_delete;
 	}
+
 	strlist__for_each(ent, limitlist) {
 		str = strdup(ent->s);
 		if (!str) {
@@ -2063,20 +2065,25 @@ int show_possible_probes(struct strlist *limitlist, pid_t pid)
 			goto out_delete;
 		}
 
-		tmpname = realpath(str, NULL);
-		if (tmpname)
-			name = basename(tmpname);
-		if (!name)
-			name = str;
-		map = map_groups__find_by_name(&thread->mg,
-						MAP__FUNCTION, name);
-		if (tmpname)
-			free(tmpname);
-		if (!map) {
-			pr_warning("Skip probe listing in %s DSO.", str);
-			free(str);
-			continue;
-		}
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
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 674b95a..3ec57a8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2360,3 +2360,11 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 
 	return ret;
 }
+
+struct map *dso__new_map(char *name)
+{
+	struct dso *dso = dso__new(name);
+	struct map *map = map__new2(0, dso, MAP__FUNCTION);
+
+	return map;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 93f1058..b1f608e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -196,6 +196,7 @@ char dso__symtab_origin(const struct dso *self);
 void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
 void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
+struct map *dso__new_map(char *name);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 					const char *name);
