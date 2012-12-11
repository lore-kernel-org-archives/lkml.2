Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2LKWsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2LKWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 22/37] perf symbols: Generalize filter in __fprintf_buildid methods
Date: Tue, 11 Dec 2012 19:48:08 -0300
Message-Id: <1355266103-17238-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We had that 'with_hits' filter to show just the build ids for DSOs that
had samples, make that generic so that we can use it in the upcoming
buildid-cache --missing feature, to show just the build ids that are not
in the cache.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9nfesdfpnx7zp96yn3tmfbx0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |    7 ++++++-
 tools/perf/util/dso.c             |    4 ++--
 tools/perf/util/dso.h             |    2 +-
 tools/perf/util/machine.h         |    8 ++++----
 tools/perf/util/session.c         |    6 +++---
 tools/perf/util/session.h         |    4 ++--
 tools/perf/util/symbol.c          |   12 ++++++------
 7 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 4c770d2..e74366a 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -44,6 +44,11 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	return fprintf(fp, "%s\n", sbuild_id);
 }
 
+static bool dso__skip_buildid(struct dso *dso, int with_hits)
+{
+	return with_hits && !dso->hit;
+}
+
 static int perf_session__list_build_ids(bool force, bool with_hits)
 {
 	struct perf_session *session;
@@ -66,7 +71,7 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	if (with_hits || session->fd_pipe)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
-	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
+	perf_session__fprintf_dsos_buildid(session, stdout, dso__skip_buildid, with_hits);
 	perf_session__delete(session);
 out:
 	return 0;
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index be43785..6f7d5a9 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -539,13 +539,13 @@ struct dso *__dsos__findnew(struct list_head *head, const char *name)
 }
 
 size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
-			       bool with_hits)
+			       bool (skip)(struct dso *dso, int parm), int parm)
 {
 	struct dso *pos;
 	size_t ret = 0;
 
 	list_for_each_entry(pos, head, node) {
-		if (with_hits && !pos->hit)
+		if (skip && skip(pos, parm))
 			continue;
 		ret += dso__fprintf_buildid(pos, fp);
 		ret += fprintf(fp, " %s\n", pos->long_name);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index e032769..450199a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -138,7 +138,7 @@ struct dso *__dsos__findnew(struct list_head *head, const char *name);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 
 size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
-			       bool with_hits);
+			       bool (skip)(struct dso *dso, int parm), int parm);
 size_t __dsos__fprintf(struct list_head *head, FILE *fp);
 
 size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index b7cde74..646ad13 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -129,11 +129,11 @@ int machine__load_kallsyms(struct machine *machine, const char *filename,
 int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 			       symbol_filter_t filter);
 
-size_t machine__fprintf_dsos_buildid(struct machine *machine,
-				     FILE *fp, bool with_hits);
+size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
+				     bool (skip)(struct dso *dso, int parm), int parm);
 size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
-size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
-				      FILE *fp, bool with_hits);
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines, FILE *fp,
+				     bool (skip)(struct dso *dso, int parm), int parm);
 
 void machine__destroy_kernel_maps(struct machine *machine);
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index aa5e582..8d04dfb 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1552,10 +1552,10 @@ size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
 }
 
 size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
-					  bool with_hits)
+					  bool (skip)(struct dso *dso, int parm), int parm)
 {
-	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
-	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
+	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, skip, parm);
+	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, skip, parm);
 }
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index c18fabd..8c23025 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -115,8 +115,8 @@ size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
 
 size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
 
-size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
-					  FILE *fp, bool with_hits);
+size_t perf_session__fprintf_dsos_buildid(struct perf_session *session, FILE *fp,
+					  bool (fn)(struct dso *dso, int parm), int parm);
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 295f8d4..e5ba984 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1315,21 +1315,21 @@ size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
 }
 
 size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
-				     bool with_hits)
+				     bool (skip)(struct dso *dso, int parm), int parm)
 {
-	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, with_hits) +
-	       __dsos__fprintf_buildid(&machine->user_dsos, fp, with_hits);
+	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, skip, parm) +
+	       __dsos__fprintf_buildid(&machine->user_dsos, fp, skip, parm);
 }
 
-size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
-				      FILE *fp, bool with_hits)
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines, FILE *fp,
+				     bool (skip)(struct dso *dso, int parm), int parm)
 {
 	struct rb_node *nd;
 	size_t ret = 0;
 
 	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
+		ret += machine__fprintf_dsos_buildid(pos, fp, skip, parm);
 	}
 	return ret;
 }
-- 
1.7.9.2.358.g22243

