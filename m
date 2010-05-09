Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0EIXj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:39:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:45155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0EIXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:39:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: [PATCH 3/4] perf session: Embed the host machine data on perf_session
Date: Sun,  9 May 2010 20:39:28 -0300
Message-Id: <1273448369-7479-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273448369-7479-1-git-send-email-acme@infradead.org>
References: <1273448369-7479-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We have just one host on a given session, and that is the most common
setup right now, so embed a ->host_machine struct machine instance
directly in the perf_session class, check if we're looking for it before
going to the rb_tree.

This also fixes a problem found when we try to process old perf.data
files where we didn't have MMAP events for the kernel and modules and
thus don't create the kernel maps, do it in event__preprocess_sample if
it wasn't already.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   |   10 ++++++++++
 tools/perf/util/map.c     |   24 ------------------------
 tools/perf/util/session.c |    8 ++++++++
 tools/perf/util/session.h |   14 ++++++++------
 tools/perf/util/symbol.c  |    2 +-
 tools/perf/util/symbol.h  |    2 ++
 6 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index c44a5a8..4ebb51d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -653,6 +653,16 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 		goto out_filtered;
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	/*
+	 * Have we already created the kernel maps for the host machine?
+	 *
+	 * This should have happened earlier, when we processed the kernel MMAP
+	 * events, but for older perf.data files there was no such thing, so do
+	 * it now.
+	 */
+	if (cpumode == PERF_RECORD_MISC_KERNEL &&
+	    session->host_machine.vmlinux_maps[MAP__FUNCTION] == NULL)
+		machine__create_kernel_maps(&session->host_machine);
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      self->ip.pid, self->ip.ip, al);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 44a4df6..e672f2f 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -579,30 +579,6 @@ struct machine *machines__find(struct rb_root *self, pid_t pid)
 	return default_machine;
 }
 
-/*
- * FIXME: Why repeatedly search for this?
- */
-struct machine *machines__find_host(struct rb_root *self)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	struct machine *machine;
-	pid_t pid = HOST_KERNEL_ID;
-
-	while (*p != NULL) {
-		parent = *p;
-		machine = rb_entry(parent, struct machine, rb_node);
-		if (pid < machine->pid)
-			p = &(*p)->rb_left;
-		else if (pid > machine->pid)
-			p = &(*p)->rb_right;
-		else
-			return machine;
-	}
-
-	return NULL;
-}
-
 struct machine *machines__findnew(struct rb_root *self, pid_t pid)
 {
 	char path[PATH_MAX];
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5d353e7..71bc608 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -100,6 +100,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->repipe = repipe;
 	self->ordered_samples.flush_limit = ULLONG_MAX;
 	INIT_LIST_HEAD(&self->ordered_samples.samples_head);
+	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
 
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
@@ -870,3 +871,10 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct map **maps,
 
 	return 0;
 }
+
+size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
+{
+	return __dsos__fprintf(&self->host_machine.kernel_dsos, fp) +
+	       __dsos__fprintf(&self->host_machine.user_dsos, fp) +
+	       machines__fprintf_dsos(&self->machines, fp);
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index f2b2c6a..eb9f179 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -25,6 +25,7 @@ struct perf_session {
 	unsigned long		mmap_window;
 	struct rb_root		threads;
 	struct thread		*last_match;
+	struct machine		host_machine;
 	struct rb_root		machines;
 	struct events_stats	events_stats;
 	struct rb_root		stats_by_id;
@@ -107,18 +108,22 @@ int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 static inline
 struct machine *perf_session__find_host_machine(struct perf_session *self)
 {
-	return machines__find_host(&self->machines);
+	return &self->host_machine;
 }
 
 static inline
 struct machine *perf_session__find_machine(struct perf_session *self, pid_t pid)
 {
+	if (pid == HOST_KERNEL_ID)
+		return &self->host_machine;
 	return machines__find(&self->machines, pid);
 }
 
 static inline
 struct machine *perf_session__findnew_machine(struct perf_session *self, pid_t pid)
 {
+	if (pid == HOST_KERNEL_ID)
+		return &self->host_machine;
 	return machines__findnew(&self->machines, pid);
 }
 
@@ -126,14 +131,11 @@ static inline
 void perf_session__process_machines(struct perf_session *self,
 				    machine__process_t process)
 {
+	process(&self->host_machine, self);
 	return machines__process(&self->machines, process, self);
 }
 
-static inline
-size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp)
-{
-	return machines__fprintf_dsos(&self->machines, fp);
-}
+size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
 
 static inline
 size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4c0146a..994efdb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1889,7 +1889,7 @@ struct dso *__dsos__findnew(struct list_head *head, const char *name)
 	return dso;
 }
 
-static size_t __dsos__fprintf(struct list_head *head, FILE *fp)
+size_t __dsos__fprintf(struct list_head *head, FILE *fp)
 {
 	struct dso *pos;
 	size_t ret = 0;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index a517c17..edff866 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -167,6 +167,8 @@ int machine__load_kallsyms(struct machine *self, const char *filename,
 int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 			       symbol_filter_t filter);
 
+size_t __dsos__fprintf(struct list_head *head, FILE *fp);
+
 size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
-- 
1.6.2.5

