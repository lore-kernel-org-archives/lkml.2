Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1CJTaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:30:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:57602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1CJTaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:30:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf header: Stop using 'self'
Date: Thu, 10 Mar 2011 16:29:46 -0300
Message-Id: <1299785386-22234-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299785386-22234-1-git-send-email-acme@infradead.org>
References: <1299785386-22234-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Stop using this python/OOP convention, doesn't really helps. Will do
more from time to time till we get it cleaned up in all of tools/perf.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |  199 +++++++++++++++++++++++-----------------------
 tools/perf/util/header.h |   12 ++--
 2 files changed, 105 insertions(+), 106 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 40b10e4..5a72d42 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -66,19 +66,19 @@ struct perf_file_attr {
 	struct perf_file_section	ids;
 };
 
-void perf_header__set_feat(struct perf_header *self, int feat)
+void perf_header__set_feat(struct perf_header *header, int feat)
 {
-	set_bit(feat, self->adds_features);
+	set_bit(feat, header->adds_features);
 }
 
-void perf_header__clear_feat(struct perf_header *self, int feat)
+void perf_header__clear_feat(struct perf_header *header, int feat)
 {
-	clear_bit(feat, self->adds_features);
+	clear_bit(feat, header->adds_features);
 }
 
-bool perf_header__has_feat(const struct perf_header *self, int feat)
+bool perf_header__has_feat(const struct perf_header *header, int feat)
 {
-	return test_bit(feat, self->adds_features);
+	return test_bit(feat, header->adds_features);
 }
 
 static int do_write(int fd, const void *buf, size_t size)
@@ -147,22 +147,22 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 	return 0;
 }
 
-static int machine__write_buildid_table(struct machine *self, int fd)
+static int machine__write_buildid_table(struct machine *machine, int fd)
 {
 	int err;
 	u16 kmisc = PERF_RECORD_MISC_KERNEL,
 	    umisc = PERF_RECORD_MISC_USER;
 
-	if (!machine__is_host(self)) {
+	if (!machine__is_host(machine)) {
 		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
 		umisc = PERF_RECORD_MISC_GUEST_USER;
 	}
 
-	err = __dsos__write_buildid_table(&self->kernel_dsos, self->pid,
+	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine->pid,
 					  kmisc, fd);
 	if (err == 0)
-		err = __dsos__write_buildid_table(&self->user_dsos,
-						  self->pid, umisc, fd);
+		err = __dsos__write_buildid_table(&machine->user_dsos,
+						  machine->pid, umisc, fd);
 	return err;
 }
 
@@ -280,12 +280,12 @@ out_free:
 	return err;
 }
 
-static int dso__cache_build_id(struct dso *self, const char *debugdir)
+static int dso__cache_build_id(struct dso *dso, const char *debugdir)
 {
-	bool is_kallsyms = self->kernel && self->long_name[0] != '/';
+	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
 
-	return build_id_cache__add_b(self->build_id, sizeof(self->build_id),
-				     self->long_name, debugdir, is_kallsyms);
+	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id),
+				     dso->long_name, debugdir, is_kallsyms);
 }
 
 static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
@@ -300,14 +300,14 @@ static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
 	return err;
 }
 
-static int machine__cache_build_ids(struct machine *self, const char *debugdir)
+static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
 {
-	int ret = __dsos__cache_build_ids(&self->kernel_dsos, debugdir);
-	ret |= __dsos__cache_build_ids(&self->user_dsos, debugdir);
+	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, debugdir);
+	ret |= __dsos__cache_build_ids(&machine->user_dsos, debugdir);
 	return ret;
 }
 
-static int perf_session__cache_build_ids(struct perf_session *self)
+static int perf_session__cache_build_ids(struct perf_session *session)
 {
 	struct rb_node *nd;
 	int ret;
@@ -318,28 +318,28 @@ static int perf_session__cache_build_ids(struct perf_session *self)
 	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
 		return -1;
 
-	ret = machine__cache_build_ids(&self->host_machine, debugdir);
+	ret = machine__cache_build_ids(&session->host_machine, debugdir);
 
-	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret |= machine__cache_build_ids(pos, debugdir);
 	}
 	return ret ? -1 : 0;
 }
 
-static bool machine__read_build_ids(struct machine *self, bool with_hits)
+static bool machine__read_build_ids(struct machine *machine, bool with_hits)
 {
-	bool ret = __dsos__read_build_ids(&self->kernel_dsos, with_hits);
-	ret |= __dsos__read_build_ids(&self->user_dsos, with_hits);
+	bool ret = __dsos__read_build_ids(&machine->kernel_dsos, with_hits);
+	ret |= __dsos__read_build_ids(&machine->user_dsos, with_hits);
 	return ret;
 }
 
-static bool perf_session__read_build_ids(struct perf_session *self, bool with_hits)
+static bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
 {
 	struct rb_node *nd;
-	bool ret = machine__read_build_ids(&self->host_machine, with_hits);
+	bool ret = machine__read_build_ids(&session->host_machine, with_hits);
 
-	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret |= machine__read_build_ids(pos, with_hits);
 	}
@@ -347,7 +347,7 @@ static bool perf_session__read_build_ids(struct perf_session *self, bool with_hi
 	return ret;
 }
 
-static int perf_header__adds_write(struct perf_header *self,
+static int perf_header__adds_write(struct perf_header *header,
 				   struct perf_evlist *evlist, int fd)
 {
 	int nr_sections;
@@ -357,13 +357,13 @@ static int perf_header__adds_write(struct perf_header *self,
 	u64 sec_start;
 	int idx = 0, err;
 
-	session = container_of(self, struct perf_session, header);
+	session = container_of(header, struct perf_session, header);
 
-	if (perf_header__has_feat(self, HEADER_BUILD_ID &&
+	if (perf_header__has_feat(header, HEADER_BUILD_ID &&
 	    !perf_session__read_build_ids(session, true)))
-		perf_header__clear_feat(self, HEADER_BUILD_ID);
+		perf_header__clear_feat(header, HEADER_BUILD_ID);
 
-	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
+	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
 		return 0;
 
@@ -373,10 +373,10 @@ static int perf_header__adds_write(struct perf_header *self,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	sec_start = self->data_offset + self->data_size;
+	sec_start = header->data_offset + header->data_size;
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
-	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
+	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
 		struct perf_file_section *trace_sec;
 
 		trace_sec = &feat_sec[idx++];
@@ -387,14 +387,14 @@ static int perf_header__adds_write(struct perf_header *self,
 		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
-	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
+	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
 		struct perf_file_section *buildid_sec;
 
 		buildid_sec = &feat_sec[idx++];
 
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		err = dsos__write_buildid_table(self, fd);
+		err = dsos__write_buildid_table(header, fd);
 		if (err < 0) {
 			pr_debug("failed to write buildid table\n");
 			goto out_free;
@@ -439,7 +439,7 @@ int perf_session__write_header(struct perf_session *session,
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
-	struct perf_header *self = &session->header;
+	struct perf_header *header = &session->header;
 	struct perf_evsel *attr, *pair = NULL;
 	int err;
 
@@ -465,7 +465,7 @@ out_err_write:
 		}
 	}
 
-	self->attr_offset = lseek(fd, 0, SEEK_CUR);
+	header->attr_offset = lseek(fd, 0, SEEK_CUR);
 
 	list_for_each_entry(attr, &evlist->entries, node) {
 		f_attr = (struct perf_file_attr){
@@ -482,20 +482,20 @@ out_err_write:
 		}
 	}
 
-	self->event_offset = lseek(fd, 0, SEEK_CUR);
-	self->event_size = event_count * sizeof(struct perf_trace_event_type);
+	header->event_offset = lseek(fd, 0, SEEK_CUR);
+	header->event_size = event_count * sizeof(struct perf_trace_event_type);
 	if (events) {
-		err = do_write(fd, events, self->event_size);
+		err = do_write(fd, events, header->event_size);
 		if (err < 0) {
 			pr_debug("failed to write perf header events\n");
 			return err;
 		}
 	}
 
-	self->data_offset = lseek(fd, 0, SEEK_CUR);
+	header->data_offset = lseek(fd, 0, SEEK_CUR);
 
 	if (at_exit) {
-		err = perf_header__adds_write(self, evlist, fd);
+		err = perf_header__adds_write(header, evlist, fd);
 		if (err < 0)
 			return err;
 	}
@@ -505,20 +505,20 @@ out_err_write:
 		.size	   = sizeof(f_header),
 		.attr_size = sizeof(f_attr),
 		.attrs = {
-			.offset = self->attr_offset,
+			.offset = header->attr_offset,
 			.size   = evlist->nr_entries * sizeof(f_attr),
 		},
 		.data = {
-			.offset = self->data_offset,
-			.size	= self->data_size,
+			.offset = header->data_offset,
+			.size	= header->data_size,
 		},
 		.event_types = {
-			.offset = self->event_offset,
-			.size	= self->event_size,
+			.offset = header->event_offset,
+			.size	= header->event_size,
 		},
 	};
 
-	memcpy(&f_header.adds_features, &self->adds_features, sizeof(self->adds_features));
+	memcpy(&f_header.adds_features, &header->adds_features, sizeof(header->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
 	err = do_write(fd, &f_header, sizeof(f_header));
@@ -526,26 +526,26 @@ out_err_write:
 		pr_debug("failed to write perf header\n");
 		return err;
 	}
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
 
-	self->frozen = 1;
+	header->frozen = 1;
 	return 0;
 }
 
-static int perf_header__getbuffer64(struct perf_header *self,
+static int perf_header__getbuffer64(struct perf_header *header,
 				    int fd, void *buf, size_t size)
 {
 	if (readn(fd, buf, size) <= 0)
 		return -1;
 
-	if (self->needs_swap)
+	if (header->needs_swap)
 		mem_bswap_64(buf, size);
 
 	return 0;
 }
 
-int perf_header__process_sections(struct perf_header *self, int fd,
-				  int (*process)(struct perf_file_section *self,
+int perf_header__process_sections(struct perf_header *header, int fd,
+				  int (*process)(struct perf_file_section *section,
 						 struct perf_header *ph,
 						 int feat, int fd))
 {
@@ -555,7 +555,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 	int idx = 0;
 	int err = -1, feat = 1;
 
-	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
+	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
 		return 0;
 
@@ -565,17 +565,17 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
 
-	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
+	if (perf_header__getbuffer64(header, fd, feat_sec, sec_size))
 		goto out_free;
 
 	err = 0;
 	while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
-		if (perf_header__has_feat(self, feat)) {
+		if (perf_header__has_feat(header, feat)) {
 			struct perf_file_section *sec = &feat_sec[idx++];
 
-			err = process(sec, self, feat, fd);
+			err = process(sec, header, feat, fd);
 			if (err < 0)
 				break;
 		}
@@ -586,35 +586,35 @@ out_free:
 	return err;
 }
 
-int perf_file_header__read(struct perf_file_header *self,
+int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd)
 {
 	lseek(fd, 0, SEEK_SET);
 
-	if (readn(fd, self, sizeof(*self)) <= 0 ||
-	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
+	if (readn(fd, header, sizeof(*header)) <= 0 ||
+	    memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
 		return -1;
 
-	if (self->attr_size != sizeof(struct perf_file_attr)) {
-		u64 attr_size = bswap_64(self->attr_size);
+	if (header->attr_size != sizeof(struct perf_file_attr)) {
+		u64 attr_size = bswap_64(header->attr_size);
 
 		if (attr_size != sizeof(struct perf_file_attr))
 			return -1;
 
-		mem_bswap_64(self, offsetof(struct perf_file_header,
+		mem_bswap_64(header, offsetof(struct perf_file_header,
 					    adds_features));
 		ph->needs_swap = true;
 	}
 
-	if (self->size != sizeof(*self)) {
+	if (header->size != sizeof(*header)) {
 		/* Support the previous format */
-		if (self->size == offsetof(typeof(*self), adds_features))
-			bitmap_zero(self->adds_features, HEADER_FEAT_BITS);
+		if (header->size == offsetof(typeof(*header), adds_features))
+			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
 		else
 			return -1;
 	}
 
-	memcpy(&ph->adds_features, &self->adds_features,
+	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
 	/*
 	 * FIXME: hack that assumes that if we need swap the perf.data file
@@ -628,10 +628,10 @@ int perf_file_header__read(struct perf_file_header *self,
 		perf_header__set_feat(ph, HEADER_BUILD_ID);
 	}
 
-	ph->event_offset = self->event_types.offset;
-	ph->event_size   = self->event_types.size;
-	ph->data_offset  = self->data.offset;
-	ph->data_size	 = self->data.size;
+	ph->event_offset = header->event_types.offset;
+	ph->event_size   = header->event_types.size;
+	ph->data_offset  = header->data.offset;
+	ph->data_size	 = header->data.size;
 	return 0;
 }
 
@@ -690,11 +690,10 @@ out:
 	return err;
 }
 
-static int perf_header__read_build_ids(struct perf_header *self,
-			int input, u64 offset, u64 size)
+static int perf_header__read_build_ids(struct perf_header *header,
+				       int input, u64 offset, u64 size)
 {
-	struct perf_session *session = container_of(self,
-			struct perf_session, header);
+	struct perf_session *session = container_of(header, struct perf_session, header);
 	struct build_id_event bev;
 	char filename[PATH_MAX];
 	u64 limit = offset + size;
@@ -706,7 +705,7 @@ static int perf_header__read_build_ids(struct perf_header *self,
 		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
 			goto out;
 
-		if (self->needs_swap)
+		if (header->needs_swap)
 			perf_event_header__bswap(&bev.header);
 
 		len = bev.header.size - sizeof(bev);
@@ -722,13 +721,13 @@ out:
 	return err;
 }
 
-static int perf_file_section__process(struct perf_file_section *self,
+static int perf_file_section__process(struct perf_file_section *section,
 				      struct perf_header *ph,
 				      int feat, int fd)
 {
-	if (lseek(fd, self->offset, SEEK_SET) == (off_t)-1) {
+	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
-			  "%d, continuing...\n", self->offset, feat);
+			  "%d, continuing...\n", section->offset, feat);
 		return 0;
 	}
 
@@ -738,7 +737,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 		break;
 
 	case HEADER_BUILD_ID:
-		if (perf_header__read_build_ids(ph, fd, self->offset, self->size))
+		if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
 			pr_debug("Failed to read buildids, continuing...\n");
 		break;
 	default:
@@ -748,21 +747,21 @@ static int perf_file_section__process(struct perf_file_section *self,
 	return 0;
 }
 
-static int perf_file_header__read_pipe(struct perf_pipe_file_header *self,
+static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 				       struct perf_header *ph, int fd,
 				       bool repipe)
 {
-	if (readn(fd, self, sizeof(*self)) <= 0 ||
-	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
+	if (readn(fd, header, sizeof(*header)) <= 0 ||
+	    memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
 		return -1;
 
-	if (repipe && do_write(STDOUT_FILENO, self, sizeof(*self)) < 0)
+	if (repipe && do_write(STDOUT_FILENO, header, sizeof(*header)) < 0)
 		return -1;
 
-	if (self->size != sizeof(*self)) {
-		u64 size = bswap_64(self->size);
+	if (header->size != sizeof(*header)) {
+		u64 size = bswap_64(header->size);
 
-		if (size != sizeof(*self))
+		if (size != sizeof(*header))
 			return -1;
 
 		ph->needs_swap = true;
@@ -773,10 +772,10 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *self,
 
 static int perf_header__read_pipe(struct perf_session *session, int fd)
 {
-	struct perf_header *self = &session->header;
+	struct perf_header *header = &session->header;
 	struct perf_pipe_file_header f_header;
 
-	if (perf_file_header__read_pipe(&f_header, self, fd,
+	if (perf_file_header__read_pipe(&f_header, header, fd,
 					session->repipe) < 0) {
 		pr_debug("incompatible file format\n");
 		return -EINVAL;
@@ -789,7 +788,7 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 
 int perf_session__read_header(struct perf_session *session, int fd)
 {
-	struct perf_header *self = &session->header;
+	struct perf_header *header = &session->header;
 	struct perf_file_header	f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
@@ -802,7 +801,7 @@ int perf_session__read_header(struct perf_session *session, int fd)
 	if (session->fd_pipe)
 		return perf_header__read_pipe(session, fd);
 
-	if (perf_file_header__read(&f_header, self, fd) < 0) {
+	if (perf_file_header__read(&f_header, header, fd) < 0) {
 		pr_debug("incompatible file format\n");
 		return -EINVAL;
 	}
@@ -814,7 +813,7 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		struct perf_evsel *evsel;
 		off_t tmp;
 
-		if (perf_header__getbuffer64(self, fd, &f_attr, sizeof(f_attr)))
+		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
 			goto out_errno;
 
 		tmp = lseek(fd, 0, SEEK_CUR);
@@ -840,7 +839,7 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
 
 		for (j = 0; j < nr_ids; j++) {
-			if (perf_header__getbuffer64(self, fd, &f_id, sizeof(f_id)))
+			if (perf_header__getbuffer64(header, fd, &f_id, sizeof(f_id)))
 				goto out_errno;
 
 			perf_evlist__id_add(session->evlist, evsel, 0, j, f_id);
@@ -854,17 +853,17 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		events = malloc(f_header.event_types.size);
 		if (events == NULL)
 			return -ENOMEM;
-		if (perf_header__getbuffer64(self, fd, events,
+		if (perf_header__getbuffer64(header, fd, events,
 					     f_header.event_types.size))
 			goto out_errno;
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	perf_header__process_sections(self, fd, perf_file_section__process);
+	perf_header__process_sections(header, fd, perf_file_section__process);
 
-	lseek(fd, self->data_offset, SEEK_SET);
+	lseek(fd, header->data_offset, SEEK_SET);
 
-	self->frozen = 1;
+	header->frozen = 1;
 	return 0;
 out_errno:
 	return -errno;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 4cc2675..456661d 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -39,7 +39,7 @@ struct perf_pipe_file_header {
 
 struct perf_header;
 
-int perf_file_header__read(struct perf_file_header *self,
+int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd);
 
 struct perf_header {
@@ -66,12 +66,12 @@ char *perf_header__find_event(u64 id);
 
 u64 perf_evlist__sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const struct perf_evlist *evlist);
-void perf_header__set_feat(struct perf_header *self, int feat);
-void perf_header__clear_feat(struct perf_header *self, int feat);
-bool perf_header__has_feat(const struct perf_header *self, int feat);
+void perf_header__set_feat(struct perf_header *header, int feat);
+void perf_header__clear_feat(struct perf_header *header, int feat);
+bool perf_header__has_feat(const struct perf_header *header, int feat);
 
-int perf_header__process_sections(struct perf_header *self, int fd,
-				  int (*process)(struct perf_file_section *self,
+int perf_header__process_sections(struct perf_header *header, int fd,
+				  int (*process)(struct perf_file_section *section,
 						 struct perf_header *ph,
 						 int feat, int fd));
 
-- 
1.6.2.5

