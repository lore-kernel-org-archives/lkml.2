Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0D1Bwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:52:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0D1Bwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:52:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: [PATCH 4/5] perf machines: Make the machines class adopt the dsos__fprintf methods
Date: Tue, 27 Apr 2010 22:52:39 -0300
Message-Id: <1272419560-4332-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272419560-4332-1-git-send-email-acme@infradead.org>
References: <1272419560-4332-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now those methods don't operate on a global list of dsos, but on lists
of machines, so make this clear by renaming the functions.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-buildid-list.c |    2 +-
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-top.c          |    2 +-
 tools/perf/util/session.h         |   13 +++++++++++++
 tools/perf/util/symbol.c          |   22 ++++++++++++++--------
 tools/perf/util/symbol.h          |    5 ++---
 7 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 986b2ef..b57dbcf 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -571,7 +571,7 @@ static int __cmd_annotate(void)
 		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
-		dsos__fprintf(&session->machines, stdout);
+		perf_session__fprintf_dsos(session, stdout);
 
 	perf_session__collapse_resort(&session->hists);
 	perf_session__output_resort(&session->hists, session->event_total[0]);
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index b4a265a..7dc3b2e 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -46,7 +46,7 @@ static int __cmd_buildid_list(void)
 	if (with_hits)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
-	dsos__fprintf_buildid(&session->machines, stdout, with_hits);
+	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
 
 	perf_session__delete(session);
 	return err;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 49cc367..f1b46eb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -313,7 +313,7 @@ static int __cmd_report(void)
 		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
-		dsos__fprintf(&session->machines, stdout);
+		perf_session__fprintf_dsos(session, stdout);
 
 	next = rb_first(&session->stats_by_id);
 	while (next) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c390f34..d95281f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -854,7 +854,7 @@ static void handle_keypress(struct perf_session *session, int c)
 		case 'Q':
 			printf("exiting.\n");
 			if (dump_symtab)
-				dsos__fprintf(&session->machines, stderr);
+				perf_session__fprintf_dsos(session, stderr);
 			exit(0);
 		case 's':
 			prompt_symbol(&sym_filter_entry, "Enter details symbol");
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7125272..61ca92e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -127,4 +127,17 @@ void perf_session__process_machines(struct perf_session *self,
 {
 	return machines__process(&self->machines, process, self);
 }
+
+static inline
+size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
+{
+	return machines__fprintf_dsos(&self->machines, fp);
+}
+
+static inline
+size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
+					  bool with_hits)
+{
+	return machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
+}
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 12359c3..caa890f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1889,26 +1889,32 @@ struct dso *__dsos__findnew(struct list_head *head, const char *name)
 	return dso;
 }
 
-static void __dsos__fprintf(struct list_head *head, FILE *fp)
+static size_t __dsos__fprintf(struct list_head *head, FILE *fp)
 {
 	struct dso *pos;
+	size_t ret = 0;
 
 	list_for_each_entry(pos, head, node) {
 		int i;
 		for (i = 0; i < MAP__NR_TYPES; ++i)
-			dso__fprintf(pos, i, fp);
+			ret += dso__fprintf(pos, i, fp);
 	}
+
+	return ret;
 }
 
-void dsos__fprintf(struct rb_root *machines, FILE *fp)
+size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp)
 {
 	struct rb_node *nd;
+	size_t ret = 0;
 
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		__dsos__fprintf(&pos->kernel_dsos, fp);
-		__dsos__fprintf(&pos->user_dsos, fp);
+		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
+		ret += __dsos__fprintf(&pos->user_dsos, fp);
 	}
+
+	return ret;
 }
 
 static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
@@ -1926,12 +1932,12 @@ static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
 	return ret;
 }
 
-size_t dsos__fprintf_buildid(struct rb_root *machines, FILE *fp, bool with_hits)
+size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
 {
 	struct rb_node *nd;
 	size_t ret = 0;
 
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += __dsos__fprintf_buildid(&pos->kernel_dsos, fp, with_hits);
 		ret += __dsos__fprintf_buildid(&pos->user_dsos, fp, with_hits);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 37b717b..2cec6a1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -162,9 +162,8 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			   symbol_filter_t filter);
 int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
 		       symbol_filter_t filter);
-void dsos__fprintf(struct rb_root *kerninfo_root, FILE *fp);
-size_t dsos__fprintf_buildid(struct rb_root *kerninfo_root,
-		FILE *fp, bool with_hits);
+size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
+size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
-- 
1.6.2.5

