Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0HBHzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:55:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab0HBHzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:55:11 -0400
Date: Mon, 2 Aug 2010 07:54:31 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Release session and symbol resources on exit
Message-ID: <tip-d65a458b348cd458413b3cfec66e43ebd0367646@git.kernel.org>
Git-Commit-ID: d65a458b348cd458413b3cfec66e43ebd0367646
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:54:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d65a458b348cd458413b3cfec66e43ebd0367646
Gitweb:     http://git.kernel.org/tip/d65a458b348cd458413b3cfec66e43ebd0367646
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 30 Jul 2010 18:31:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 30 Jul 2010 18:31:28 -0300

perf tools: Release session and symbol resources on exit

So that we reduce the noise when looking for leaks using tools such as
valgrind.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    5 ++++-
 tools/perf/util/event.c     |    5 +++--
 tools/perf/util/map.c       |   26 ++++++++++++++++++++++++++
 tools/perf/util/map.h       |    1 +
 tools/perf/util/session.c   |   26 ++++++++++++++++++++++++++
 tools/perf/util/symbol.c    |    9 +++++++++
 tools/perf/util/symbol.h    |    1 +
 7 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5ae0d93..ff77b80 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -440,6 +440,7 @@ static void atexit_header(void)
 		process_buildids();
 		perf_header__write(&session->header, output, true);
 		perf_session__delete(session);
+		symbol__exit();
 	}
 }
 
@@ -871,7 +872,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	} else {
 		all_tids=malloc(sizeof(pid_t));
 		if (!all_tids)
-			return -ENOMEM;
+			goto out_symbol_exit;
 
 		all_tids[0] = target_tid;
 		thread_num = 1;
@@ -918,5 +919,7 @@ out_free_fd:
 	}
 	free(all_tids);
 	all_tids = NULL;
+out_symbol_exit:
+	symbol__exit();
 	return err;
 }
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 8151d23..6b0db55 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -515,12 +515,13 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 	if (machine == NULL)
 		goto out_problem;
 	thread = perf_session__findnew(session, self->mmap.pid);
+	if (thread == NULL)
+		goto out_problem;
 	map = map__new(&machine->user_dsos, self->mmap.start,
 			self->mmap.len, self->mmap.pgoff,
 			self->mmap.pid, self->mmap.filename,
 			MAP__FUNCTION);
-
-	if (thread == NULL || map == NULL)
+	if (map == NULL)
 		goto out_problem;
 
 	thread__insert_map(thread, map);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 2ddbae3..15d6a6d 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -539,6 +539,32 @@ int machine__init(struct machine *self, const char *root_dir, pid_t pid)
 	return self->root_dir == NULL ? -ENOMEM : 0;
 }
 
+static void dsos__delete(struct list_head *self)
+{
+	struct dso *pos, *n;
+
+	list_for_each_entry_safe(pos, n, self, node) {
+		list_del(&pos->node);
+		dso__delete(pos);
+	}
+}
+
+void machine__exit(struct machine *self)
+{
+	struct kmap *kmap = map__kmap(self->vmlinux_maps[MAP__FUNCTION]);
+
+	if (kmap->ref_reloc_sym) {
+		free((char *)kmap->ref_reloc_sym->name);
+		free(kmap->ref_reloc_sym);
+	}
+
+	map_groups__exit(&self->kmaps);
+	dsos__delete(&self->user_dsos);
+	dsos__delete(&self->kernel_dsos);
+	free(self->root_dir);
+	self->root_dir = NULL;
+}
+
 struct machine *machines__add(struct rb_root *self, pid_t pid,
 			      const char *root_dir)
 {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 20eba42..0e0984e 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -143,6 +143,7 @@ struct machine *machines__find(struct rb_root *self, pid_t pid);
 struct machine *machines__findnew(struct rb_root *self, pid_t pid);
 char *machine__mmap_name(struct machine *self, char *bf, size_t size);
 int machine__init(struct machine *self, const char *root_dir, pid_t pid);
+void machine__exit(struct machine *self);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8cbea12..04a3b3d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -124,9 +124,35 @@ out_delete:
 	return NULL;
 }
 
+static void perf_session__delete_dead_threads(struct perf_session *self)
+{
+	struct thread *n, *t;
+
+	list_for_each_entry_safe(t, n, &self->dead_threads, node) {
+		list_del(&t->node);
+		thread__delete(t);
+	}
+}
+
+static void perf_session__delete_threads(struct perf_session *self)
+{
+	struct rb_node *nd = rb_first(&self->threads);
+
+	while (nd) {
+		struct thread *t = rb_entry(nd, struct thread, rb_node);
+
+		rb_erase(&t->rb_node, &self->threads);
+		nd = rb_next(nd);
+		thread__delete(t);
+	}
+}
+
 void perf_session__delete(struct perf_session *self)
 {
 	perf_header__exit(&self->header);
+	perf_session__delete_dead_threads(self);
+	perf_session__delete_threads(self);
+	machine__exit(&self->host_machine);
 	close(self->fd);
 	free(self);
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d99497e..94cdf68 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2245,6 +2245,15 @@ out_free_comm_list:
 	return -1;
 }
 
+void symbol__exit(void)
+{
+	strlist__delete(symbol_conf.sym_list);
+	strlist__delete(symbol_conf.dso_list);
+	strlist__delete(symbol_conf.comm_list);
+	vmlinux_path__exit();
+	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
+}
+
 int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
 {
 	struct machine *machine = machines__findnew(self, pid);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f29f73c..33d53ce 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -219,6 +219,7 @@ int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
 int machines__create_guest_kernel_maps(struct rb_root *self);
 
 int symbol__init(void);
+void symbol__exit(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
