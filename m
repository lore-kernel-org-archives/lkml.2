Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0GLKne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:43:34 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:51001 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab0GLKna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:43:30 -0400
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
Date: Mon, 12 Jul 2010 16:04:42 +0530
Message-Id: <20100712103442.27491.88806.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv9 2.6.35-rc4-tip 13/13]  [RFC] perf: show functions in a file without using pid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[RFC] perf: show functions in a file without using pid

Lists function names in a dso. Dso needs to a filename.
However passing Dso short name will not work.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

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

 tools/perf/util/probe-event.c |   56 ++++++++++++++++++++++++-----------------
 tools/perf/util/symbol.c      |    9 +++++++
 tools/perf/util/symbol.h      |    1 +
 3 files changed, 43 insertions(+), 23 deletions(-)


diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 05b0748..df7cbe8 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1922,13 +1922,13 @@ static int print_list_available_symbols(struct map *map,
 int show_possible_probes(struct strlist *limitlist, pid_t pid)
 {
 	struct perf_session *session;
-	struct thread *thread;
+	struct thread *thread = NULL;
 	struct str_node *ent;
 	struct map *map = NULL;
 	char *name, *str;
 	int ret = -EINVAL;
 
-	if (!pid) {
+	if (!pid && !limitlist) { /* Show functions in kernel */
 		ret = init_vmlinux();
 		if (ret < 0)
 			return ret;
@@ -1947,16 +1947,20 @@ int show_possible_probes(struct strlist *limitlist, pid_t pid)
 	if (symbol__init() < 0)
 		semantic_error("Cannot initialize symbols.");
 
-	event__synthesize_thread(pid, event__process, session);
+	if (pid)  {
+		event__synthesize_thread(pid, event__process, session);
 
-	thread = perf_session__findnew(session, pid);
-	if (!thread)
-		goto out_delete;
+		thread = perf_session__findnew(session, pid);
+		if (!thread)
+			goto out_delete;
+		if (!limitlist) {
+			ret = map_groups__iterate_maps(&thread->mg,
+					MAP__FUNCTION, NULL,
+					print_list_available_symbols);
+			goto out_delete;
+		}
+	}
 
-	if (!limitlist)
-		ret = map_groups__iterate_maps(&thread->mg,
-				MAP__FUNCTION, NULL,
-				print_list_available_symbols);
 	strlist__for_each(ent, limitlist) {
 		str = strdup(ent->s);
 		if (!str) {
@@ -1964,19 +1968,25 @@ int show_possible_probes(struct strlist *limitlist, pid_t pid)
 			goto out_delete;
 		}
 
-		name = basename(make_absolute_path(str));
-		if (!name) {
-			pr_warning("Skip probe listing in %s DSO.", str);
-			free(str);
-			continue;
-		}
-		map = map_groups__find_by_name(&thread->mg,
-						MAP__FUNCTION, name);
-		if (!map) {
-			pr_warning("Skip probe listing in %s DSO.", str);
-			free(str);
-			continue;
-		}
+		if (pid) {
+			name = basename(make_absolute_path(str));
+			if (!name) {
+				pr_warning("Skip probe listing in %s DSO.",
+							str);
+				free(str);
+				continue;
+			}
+			map = map_groups__find_by_name(&thread->mg,
+							MAP__FUNCTION, name);
+			if (!map) {
+				pr_warning("Skip probe listing in %s DSO.",
+							str);
+				free(str);
+				continue;
+			}
+		} else
+			map = dso__new_map(str);
+
 		ret = print_list_available_symbols(map, NULL);
 		if (ret)
 			pr_warning("Unknown dso %s .\n", str);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 18bb1d8..d2e9123 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2381,3 +2381,12 @@ void dso__list_available_symbols(struct dso *self, enum map_type type)
 		printf("%s\n", pos->sym.name);
 	}
 }
+
+
+struct map *dso__new_map(char *name)
+{
+	struct dso *dso = dso__new(name);
+	struct map *map = map__new2(0, dso, MAP__FUNCTION);
+
+	return map;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 04614b0..34e046c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -196,6 +196,7 @@ void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
 void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
 void dso__list_available_symbols(struct dso *self, enum map_type type);
+struct map *dso__new_map(char *name);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 					const char *name);
