Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab1CISda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:33:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab1CISbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:31:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 02/10] perf evsel: Assume rest of perf_header_attr functions
Date: Wed,  9 Mar 2011 15:31:23 -0300
Message-Id: <1299695491-15786-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299695491-15786-1-git-send-email-acme@infradead.org>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The append code in record can be made smarter, i.e. allowing merging of
different sets of events, but that is left for the future.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   92 +++++++++----------------
 tools/perf/util/evlist.c    |   26 +++++---
 tools/perf/util/evlist.h    |    4 +-
 tools/perf/util/evsel.c     |   21 +++++-
 tools/perf/util/evsel.h     |    9 ++-
 tools/perf/util/header.c    |  161 ++++++++++++------------------------------
 tools/perf/util/header.h    |   30 ++-------
 tools/perf/util/session.c   |   10 +---
 8 files changed, 128 insertions(+), 225 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9d236e8..81dbe27 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,7 +31,6 @@
 #include <sys/mman.h>
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define SID(e, x, y) xyarray__entry(e->id, x, y)
 
 enum write_mode_t {
 	WRITE_FORCE,
@@ -160,54 +159,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int nr)
-{
-	struct perf_header_attr *h_attr;
-
-	if (nr < session->header.attrs) {
-		h_attr = session->header.attr[nr];
-	} else {
-		h_attr = perf_header_attr__new(a);
-		if (h_attr != NULL)
-			if (perf_header__add_attr(&session->header, h_attr) < 0) {
-				perf_header_attr__delete(h_attr);
-				h_attr = NULL;
-			}
-	}
-
-	return h_attr;
-}
-
-static void create_counter(struct perf_evsel *evsel, int cpu)
-{
-	struct perf_event_attr *attr = &evsel->attr;
-	struct perf_header_attr *h_attr;
-	struct perf_sample_id *sid;
-	int thread_index;
-
-	for (thread_index = 0; thread_index < evsel_list->threads->nr; thread_index++) {
-		h_attr = get_header_attr(attr, evsel->idx);
-		if (h_attr == NULL)
-			die("nomem\n");
-
-		if (!file_new) {
-			if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
-				fprintf(stderr, "incompatible append\n");
-				exit(-1);
-			}
-		}
-
-		sid = SID(evsel, cpu, thread_index);
-		if (perf_header_attr__add_id(h_attr, sid->id) < 0) {
-			pr_warning("Not enough memory to add id\n");
-			exit(-1);
-		}
-	}
-
-	if (!sample_type)
-		sample_type = attr->sample_type;
-}
-
 static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 {
 	struct perf_event_attr *attr = &evsel->attr;
@@ -278,10 +229,28 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	}
 }
 
+static bool perf_evlist__equal(struct perf_evlist *evlist,
+			       struct perf_evlist *other)
+{
+	struct perf_evsel *pos, *pair;
+
+	if (evlist->nr_entries != other->nr_entries)
+		return false;
+
+	pair = list_entry(other->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr) != 0))
+			return false;
+		pair = list_entry(pair->node.next, struct perf_evsel, node);
+	}
+
+	return true;
+}
+
 static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
-	int cpu;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
@@ -364,10 +333,16 @@ try_again:
 	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
-	for (cpu = 0; cpu < evsel_list->cpus->nr; ++cpu) {
-		list_for_each_entry(pos, &evlist->entries, node)
-			create_counter(pos, cpu);
+	if (file_new)
+		session->evlist = evlist;
+	else {
+		if (!perf_evlist__equal(session->evlist, evlist)) {
+			fprintf(stderr, "incompatible append\n");
+			exit(-1);
+		}
 	}
+
+	sample_type = pos->attr.sample_type;
 }
 
 static int process_buildids(void)
@@ -390,7 +365,7 @@ static void atexit_header(void)
 
 		if (!no_buildid)
 			process_buildids();
-		perf_header__write(&session->header, evsel_list, output, true);
+		perf_session__write_header(session, evsel_list, output, true);
 		perf_session__delete(session);
 		perf_evlist__delete(evsel_list);
 		symbol__exit();
@@ -600,8 +575,8 @@ static int __cmd_record(int argc, const char **argv)
 		if (err < 0)
 			return err;
 	} else if (file_new) {
-		err = perf_header__write(&session->header, evsel_list,
-					 output, false);
+		err = perf_session__write_header(session, evsel_list,
+						 output, false);
 		if (err < 0)
 			return err;
 	}
@@ -611,9 +586,8 @@ static int __cmd_record(int argc, const char **argv)
 	perf_session__set_sample_id_all(session, sample_id_all_avail);
 
 	if (pipe_output) {
-		err = perf_event__synthesize_attrs(&session->header,
-						   process_synthesized_event,
-						   session);
+		err = perf_session__synthesize_attrs(session,
+						     process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
 			return err;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 190c64c..d852cef 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -19,7 +19,7 @@
 #include <linux/hash.h>
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define SID(e, x, y) xyarray__entry(e->id, x, y)
+#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
@@ -106,8 +106,9 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
-void perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
-			  int cpu, int thread, u64 id)
+static void perf_evlist__id_hash(struct perf_evlist *evlist,
+				 struct perf_evsel *evsel,
+				 int cpu, int thread, u64 id)
 {
 	int hash;
 	struct perf_sample_id *sid = SID(evsel, cpu, thread);
@@ -118,9 +119,16 @@ void perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
 	hlist_add_head(&sid->node, &evlist->heads[hash]);
 }
 
-static int perf_evlist__id_hash_fd(struct perf_evlist *evlist,
-				   struct perf_evsel *evsel,
-				   int cpu, int thread, int fd)
+void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			 int cpu, int thread, u64 id)
+{
+	perf_evlist__id_hash(evlist, evsel, cpu, thread, id);
+	evsel->id[evsel->ids++] = id;
+}
+
+static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
+				  struct perf_evsel *evsel,
+				  int cpu, int thread, int fd)
 {
 	u64 read_data[4] = { 0, };
 	int id_idx = 1; /* The first entry is the counter value */
@@ -134,7 +142,7 @@ static int perf_evlist__id_hash_fd(struct perf_evlist *evlist,
 	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		++id_idx;
 
-	perf_evlist__id_hash(evlist, evsel, cpu, thread, read_data[id_idx]);
+	perf_evlist__id_add(evlist, evsel, cpu, thread, read_data[id_idx]);
 	return 0;
 }
 
@@ -292,7 +300,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-		    evsel->id == NULL &&
+		    evsel->sample_id == NULL &&
 		    perf_evsel__alloc_id(evsel, cpus->nr, threads->nr) < 0)
 			return -ENOMEM;
 
@@ -308,7 +316,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 					goto out_unmap;
 
 				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-				    perf_evlist__id_hash_fd(evlist, evsel, cpu, thread, fd) < 0)
+				    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
 					goto out_unmap;
 			}
 		}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 078d512..8b1cb7a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -38,8 +38,8 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 
-void perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
-			  int cpu, int thread, u64 id);
+void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			 int cpu, int thread, u64 id);
 
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist);
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8083d51..662596a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -41,8 +41,18 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
-	evsel->id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
-	return evsel->id != NULL ? 0 : -ENOMEM;
+	evsel->sample_id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
+	if (evsel->sample_id == NULL)
+		return -ENOMEM;
+
+	evsel->id = zalloc(ncpus * nthreads * sizeof(u64));
+	if (evsel->id == NULL) {
+		xyarray__delete(evsel->sample_id);
+		evsel->sample_id = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
@@ -60,7 +70,9 @@ void perf_evsel__free_fd(struct perf_evsel *evsel)
 
 void perf_evsel__free_id(struct perf_evsel *evsel)
 {
-	xyarray__delete(evsel->id);
+	xyarray__delete(evsel->sample_id);
+	evsel->sample_id = NULL;
+	free(evsel->id);
 	evsel->id = NULL;
 }
 
@@ -79,7 +91,8 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
-	xyarray__delete(evsel->id);
+	xyarray__delete(evsel->sample_id);
+	free(evsel->id);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 281b60e..6710ab5 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -49,12 +49,17 @@ struct perf_evsel {
 	struct perf_event_attr	attr;
 	char			*filter;
 	struct xyarray		*fd;
-	struct xyarray		*id;
+	struct xyarray		*sample_id;
+	u64			*id;
 	struct perf_counts	*counts;
 	int			idx;
+	int			ids;
 	struct hists		hists;
 	char			*name;
-	void			*priv;
+	union {
+		void		*priv;
+		off_t		id_offset;
+	};
 	struct cgroup_sel	*cgrp;
 };
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3457ec6..40b10e4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -20,89 +20,6 @@
 
 static bool no_buildid_cache = false;
 
-/*
- * Create new perf.data header attribute:
- */
-struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr)
-{
-	struct perf_header_attr *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->attr = *attr;
-		self->ids  = 0;
-		self->size = 1;
-		self->id   = malloc(sizeof(u64));
-		if (self->id == NULL) {
-			free(self);
-			self = NULL;
-		}
-	}
-
-	return self;
-}
-
-void perf_header_attr__delete(struct perf_header_attr *self)
-{
-	free(self->id);
-	free(self);
-}
-
-int perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
-{
-	int pos = self->ids;
-
-	self->ids++;
-	if (self->ids > self->size) {
-		int nsize = self->size * 2;
-		u64 *nid = realloc(self->id, nsize * sizeof(u64));
-
-		if (nid == NULL)
-			return -1;
-
-		self->size = nsize;
-		self->id = nid;
-	}
-	self->id[pos] = id;
-	return 0;
-}
-
-int perf_header__init(struct perf_header *self)
-{
-	self->size = 1;
-	self->attr = malloc(sizeof(void *));
-	return self->attr == NULL ? -ENOMEM : 0;
-}
-
-void perf_header__exit(struct perf_header *self)
-{
-	int i;
-	for (i = 0; i < self->attrs; ++i)
-                perf_header_attr__delete(self->attr[i]);
-	free(self->attr);
-}
-
-int perf_header__add_attr(struct perf_header *self,
-			  struct perf_header_attr *attr)
-{
-	if (self->frozen)
-		return -1;
-
-	if (self->attrs == self->size) {
-		int nsize = self->size * 2;
-		struct perf_header_attr **nattr;
-
-		nattr = realloc(self->attr, nsize * sizeof(void *));
-		if (nattr == NULL)
-			return -1;
-
-		self->size = nsize;
-		self->attr = nattr;
-	}
-
-	self->attr[self->attrs++] = attr;
-	return 0;
-}
-
 static int event_count;
 static struct perf_trace_event_type *events;
 
@@ -516,33 +433,41 @@ int perf_header__write_pipe(int fd)
 	return 0;
 }
 
-int perf_header__write(struct perf_header *self, struct perf_evlist *evlist,
-		       int fd, bool at_exit)
+int perf_session__write_header(struct perf_session *session,
+			       struct perf_evlist *evlist,
+			       int fd, bool at_exit)
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
-	struct perf_header_attr	*attr;
-	int i, err;
+	struct perf_header *self = &session->header;
+	struct perf_evsel *attr, *pair = NULL;
+	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
-	for (i = 0; i < self->attrs; i++) {
-		attr = self->attr[i];
+	if (session->evlist != evlist)
+		pair = list_entry(session->evlist->entries.next, struct perf_evsel, node);
 
+	list_for_each_entry(attr, &evlist->entries, node) {
 		attr->id_offset = lseek(fd, 0, SEEK_CUR);
 		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
 		if (err < 0) {
+out_err_write:
 			pr_debug("failed to write perf header\n");
 			return err;
 		}
+		if (session->evlist != evlist) {
+			err = do_write(fd, pair->id, pair->ids * sizeof(u64));
+			if (err < 0)
+				goto out_err_write;
+			attr->ids += pair->ids;
+			pair = list_entry(pair->node.next, struct perf_evsel, node);
+		}
 	}
 
-
 	self->attr_offset = lseek(fd, 0, SEEK_CUR);
 
-	for (i = 0; i < self->attrs; i++) {
-		attr = self->attr[i];
-
+	list_for_each_entry(attr, &evlist->entries, node) {
 		f_attr = (struct perf_file_attr){
 			.attr = attr->attr,
 			.ids  = {
@@ -581,7 +506,7 @@ int perf_header__write(struct perf_header *self, struct perf_evlist *evlist,
 		.attr_size = sizeof(f_attr),
 		.attrs = {
 			.offset = self->attr_offset,
-			.size   = self->attrs * sizeof(f_attr),
+			.size   = evlist->nr_entries * sizeof(f_attr),
 		},
 		.data = {
 			.offset = self->data_offset,
@@ -918,7 +843,7 @@ int perf_session__read_header(struct perf_session *session, int fd)
 			if (perf_header__getbuffer64(self, fd, &f_id, sizeof(f_id)))
 				goto out_errno;
 
-			perf_evlist__id_hash(session->evlist, evsel, 0, j, f_id);
+			perf_evlist__id_add(session->evlist, evsel, 0, j, f_id);
 		}
 
 		lseek(fd, tmp, SEEK_SET);
@@ -1012,16 +937,13 @@ int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 	return err;
 }
 
-int perf_event__synthesize_attrs(struct perf_header *self,
-				 perf_event__handler_t process,
-				 struct perf_session *session)
+int perf_session__synthesize_attrs(struct perf_session *session,
+				   perf_event__handler_t process)
 {
-	struct perf_header_attr	*attr;
-	int i, err = 0;
-
-	for (i = 0; i < self->attrs; i++) {
-		attr = self->attr[i];
+	struct perf_evsel *attr;
+	int err = 0;
 
+	list_for_each_entry(attr, &session->evlist->entries, node) {
 		err = perf_event__synthesize_attr(&attr->attr, attr->ids,
 						  attr->id, process, session);
 		if (err) {
@@ -1036,27 +958,36 @@ int perf_event__synthesize_attrs(struct perf_header *self,
 int perf_event__process_attr(union perf_event *event,
 			     struct perf_session *session)
 {
-	struct perf_header_attr *attr;
 	unsigned int i, ids, n_ids;
+	struct perf_evsel *evsel;
 
-	attr = perf_header_attr__new(&event->attr.attr);
-	if (attr == NULL)
+	if (session->evlist == NULL) {
+		session->evlist = perf_evlist__new(NULL, NULL);
+		if (session->evlist == NULL)
+			return -ENOMEM;
+	}
+
+	evsel = perf_evsel__new(&event->attr.attr,
+				session->evlist->nr_entries);
+	if (evsel == NULL)
 		return -ENOMEM;
 
+	perf_evlist__add(session->evlist, evsel);
+
 	ids = event->header.size;
 	ids -= (void *)&event->attr.id - (void *)event;
 	n_ids = ids / sizeof(u64);
+	/*
+	 * We don't have the cpu and thread maps on the header, so
+	 * for allocating the perf_sample_id table we fake 1 cpu and
+	 * hattr->ids threads.
+	 */
+	if (perf_evsel__alloc_id(evsel, 1, n_ids))
+		return -ENOMEM;
 
 	for (i = 0; i < n_ids; i++) {
-		if (perf_header_attr__add_id(attr, event->attr.id[i]) < 0) {
-			perf_header_attr__delete(attr);
-			return -ENOMEM;
-		}
-	}
-
-	if (perf_header__add_attr(&session->header, attr) < 0) {
-		perf_header_attr__delete(attr);
-		return -ENOMEM;
+		perf_evlist__id_add(session->evlist, evsel, 0, i,
+				    event->attr.id[i]);
 	}
 
 	perf_session__update_sample_type(session);
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 73b84eb..4cc2675 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -9,13 +9,6 @@
 
 #include <linux/bitmap.h>
 
-struct perf_header_attr {
-	struct perf_event_attr attr;
-	int ids, size;
-	u64 *id;
-	off_t id_offset;
-};
-
 enum {
 	HEADER_TRACE_INFO = 1,
 	HEADER_BUILD_ID,
@@ -51,9 +44,7 @@ int perf_file_header__read(struct perf_file_header *self,
 
 struct perf_header {
 	int			frozen;
-	int			attrs, size;
 	bool			needs_swap;
-	struct perf_header_attr **attr;
 	s64			attr_offset;
 	u64			data_offset;
 	u64			data_size;
@@ -62,27 +53,17 @@ struct perf_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
-int perf_header__init(struct perf_header *self);
-void perf_header__exit(struct perf_header *self);
-
 struct perf_evlist;
 
 int perf_session__read_header(struct perf_session *session, int fd);
-int perf_header__write(struct perf_header *self, struct perf_evlist *evlist,
-		       int fd, bool at_exit);
+int perf_session__write_header(struct perf_session *session,
+			       struct perf_evlist *evlist,
+			       int fd, bool at_exit);
 int perf_header__write_pipe(int fd);
 
-int perf_header__add_attr(struct perf_header *self,
-			  struct perf_header_attr *attr);
-
 int perf_header__push_event(u64 id, const char *name);
 char *perf_header__find_event(u64 id);
 
-struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
-void perf_header_attr__delete(struct perf_header_attr *self);
-
-int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
-
 u64 perf_evlist__sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const struct perf_evlist *evlist);
 void perf_header__set_feat(struct perf_header *self, int feat);
@@ -101,9 +82,8 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process,
 				struct perf_session *session);
-int perf_event__synthesize_attrs(struct perf_header *self,
-				 perf_event__handler_t process,
-				 struct perf_session *session);
+int perf_session__synthesize_attrs(struct perf_session *session,
+				   perf_event__handler_t process);
 int perf_event__process_attr(union perf_event *event, struct perf_session *session);
 
 int perf_event__synthesize_event_type(u64 event_id, char *name,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 26b24c5..f642615 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -137,9 +137,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	if (self == NULL)
 		goto out;
 
-	if (perf_header__init(&self->header) < 0)
-		goto out_free;
-
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
 	INIT_LIST_HEAD(&self->dead_threads);
@@ -163,6 +160,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
 			goto out_delete;
+		perf_session__update_sample_type(self);
 	} else if (mode == O_WRONLY) {
 		/*
 		 * In O_RDONLY mode this will be performed when reading the
@@ -172,8 +170,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 			goto out_delete;
 	}
 
-	perf_session__update_sample_type(self);
-
 	if (ops && ops->ordering_requires_timestamps &&
 	    ops->ordered_samples && !self->sample_id_all) {
 		dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
@@ -182,9 +178,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 
 out:
 	return self;
-out_free:
-	free(self);
-	return NULL;
 out_delete:
 	perf_session__delete(self);
 	return NULL;
@@ -215,7 +208,6 @@ static void perf_session__delete_threads(struct perf_session *self)
 
 void perf_session__delete(struct perf_session *self)
 {
-	perf_header__exit(&self->header);
 	perf_session__destroy_kernel_maps(self);
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
-- 
1.6.2.5

