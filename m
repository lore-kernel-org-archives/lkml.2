Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0ESRBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:01:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0ESRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:01:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf session: Make read_build_id routines look at the host_machine too
Date: Wed, 19 May 2010 14:01:33 -0300
Message-Id: <1274288493-15523-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274288493-15523-1-git-send-email-acme@infradead.org>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The changes made to support host and guest machines in a session, that
started when the 'perf kvm' tool was introduced ended up introducing a
bug where the host_machine was not having its DSOs traversed for
build-id processing.

Fix it by moving some methods to the right classes and considering the
host_machine when processing build-ids.

Reported-by: Tom Zanussi <tzanussi@gmail.com>
Reported-by: Stephane Eranian <eranian@google.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  |   84 ++++++++++++++++++++++++++++-----------------
 tools/perf/util/session.c |    7 ++++
 tools/perf/util/session.h |    8 +---
 tools/perf/util/symbol.c  |    9 ++++-
 tools/perf/util/symbol.h  |    1 +
 5 files changed, 69 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8847bec..1f62435 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -221,29 +221,38 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 	return 0;
 }
 
+static int machine__write_buildid_table(struct machine *self, int fd)
+{
+	int err;
+	u16 kmisc = PERF_RECORD_MISC_KERNEL,
+	    umisc = PERF_RECORD_MISC_USER;
+
+	if (!machine__is_host(self)) {
+		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
+		umisc = PERF_RECORD_MISC_GUEST_USER;
+	}
+
+	err = __dsos__write_buildid_table(&self->kernel_dsos, self->pid,
+					  kmisc, fd);
+	if (err == 0)
+		err = __dsos__write_buildid_table(&self->user_dsos,
+						  self->pid, umisc, fd);
+	return err;
+}
+
 static int dsos__write_buildid_table(struct perf_header *header, int fd)
 {
 	struct perf_session *session = container_of(header,
 			struct perf_session, header);
 	struct rb_node *nd;
-	int err = 0;
-	u16 kmisc, umisc;
+	int err = machine__write_buildid_table(&session->host_machine, fd);
+
+	if (err)
+		return err;
 
 	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		if (machine__is_host(pos)) {
-			kmisc = PERF_RECORD_MISC_KERNEL;
-			umisc = PERF_RECORD_MISC_USER;
-		} else {
-			kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-			umisc = PERF_RECORD_MISC_GUEST_USER;
-		}
-
-		err = __dsos__write_buildid_table(&pos->kernel_dsos, pos->pid,
-						  kmisc, fd);
-		if (err == 0)
-			err = __dsos__write_buildid_table(&pos->user_dsos,
-							  pos->pid, umisc, fd);
+		err = machine__write_buildid_table(pos, fd);
 		if (err)
 			break;
 	}
@@ -363,12 +372,17 @@ static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
 	return err;
 }
 
-static int dsos__cache_build_ids(struct perf_header *self)
+static int machine__cache_build_ids(struct machine *self, const char *debugdir)
+{
+	int ret = __dsos__cache_build_ids(&self->kernel_dsos, debugdir);
+	ret |= __dsos__cache_build_ids(&self->user_dsos, debugdir);
+	return ret;
+}
+
+static int perf_session__cache_build_ids(struct perf_session *self)
 {
-	struct perf_session *session = container_of(self,
-			struct perf_session, header);
 	struct rb_node *nd;
-	int ret = 0;
+	int ret;
 	char debugdir[PATH_MAX];
 
 	snprintf(debugdir, sizeof(debugdir), "%s/%s", getenv("HOME"),
@@ -377,25 +391,30 @@ static int dsos__cache_build_ids(struct perf_header *self)
 	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
 		return -1;
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	ret = machine__cache_build_ids(&self->host_machine, debugdir);
+
+	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= __dsos__cache_build_ids(&pos->kernel_dsos, debugdir);
-		ret |= __dsos__cache_build_ids(&pos->user_dsos, debugdir);
+		ret |= machine__cache_build_ids(pos, debugdir);
 	}
 	return ret ? -1 : 0;
 }
 
-static bool dsos__read_build_ids(struct perf_header *self, bool with_hits)
+static bool machine__read_build_ids(struct machine *self, bool with_hits)
+{
+	bool ret = __dsos__read_build_ids(&self->kernel_dsos, with_hits);
+	ret |= __dsos__read_build_ids(&self->user_dsos, with_hits);
+	return ret;
+}
+
+static bool perf_session__read_build_ids(struct perf_session *self, bool with_hits)
 {
-	bool ret = false;
-	struct perf_session *session = container_of(self,
-			struct perf_session, header);
 	struct rb_node *nd;
+	bool ret = machine__read_build_ids(&self->host_machine, with_hits);
 
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= __dsos__read_build_ids(&pos->kernel_dsos, with_hits);
-		ret |= __dsos__read_build_ids(&pos->user_dsos, with_hits);
+		ret |= machine__read_build_ids(pos, with_hits);
 	}
 
 	return ret;
@@ -404,12 +423,14 @@ static bool dsos__read_build_ids(struct perf_header *self, bool with_hits)
 static int perf_header__adds_write(struct perf_header *self, int fd)
 {
 	int nr_sections;
+	struct perf_session *session;
 	struct perf_file_section *feat_sec;
 	int sec_size;
 	u64 sec_start;
 	int idx = 0, err;
 
-	if (dsos__read_build_ids(self, true))
+	session = container_of(self, struct perf_session, header);
+	if (perf_session__read_build_ids(session, true))
 		perf_header__set_feat(self, HEADER_BUILD_ID);
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
@@ -450,7 +471,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		}
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
 					  buildid_sec->offset;
-		dsos__cache_build_ids(self);
+		perf_session__cache_build_ids(session);
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
@@ -490,7 +511,6 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
-
 	for (i = 0; i < self->attrs; i++) {
 		attr = self->attr[i];
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e4eaa6d..8f83a18 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -895,3 +895,10 @@ size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
 	       __dsos__fprintf(&self->host_machine.user_dsos, fp) +
 	       machines__fprintf_dsos(&self->machines, fp);
 }
+
+size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
+					  bool with_hits)
+{
+	size_t ret = machine__fprintf_dsos_buildid(&self->host_machine, fp, with_hits);
+	return ret + machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index e7fce48..55c6881 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -132,12 +132,8 @@ void perf_session__process_machines(struct perf_session *self,
 
 size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
 
-static inline
-size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
-					  bool with_hits)
-{
-	return machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
-}
+size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
+					  FILE *fp, bool with_hits);
 
 static inline
 size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 87d9b1b..96bff0e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1937,6 +1937,12 @@ static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
 	return ret;
 }
 
+size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits)
+{
+	return __dsos__fprintf_buildid(&self->kernel_dsos, fp, with_hits) +
+	       __dsos__fprintf_buildid(&self->user_dsos, fp, with_hits);
+}
+
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
 {
 	struct rb_node *nd;
@@ -1944,8 +1950,7 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_
 
 	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += __dsos__fprintf_buildid(&pos->kernel_dsos, fp, with_hits);
-		ret += __dsos__fprintf_buildid(&pos->user_dsos, fp, with_hits);
+		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
 	}
 	return ret;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 032469e..5d25b5e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -170,6 +170,7 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 
 size_t __dsos__fprintf(struct list_head *head, FILE *fp);
 
+size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits);
 size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
-- 
1.6.2.5

