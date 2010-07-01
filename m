Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0GAP4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:56:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47064 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab0GAPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:07 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/21] perf: Carve out perf bits for general usage, p1
Date: Thu,  1 Jul 2010 17:55:54 +0200
Message-Id: <1277999763-20357-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

That is, take perf-specific compilation units used by other tools and
put them in tools/lib/perf/.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile                     |   17 +-
 tools/lib/Makefile                 |    4 +
 tools/lib/perf/header.c            | 1199 ++++++++++++++++++++++++++++++++++++
 tools/lib/perf/header.h            |  110 ++++
 tools/lib/perf/parse-events.c      |  957 ++++++++++++++++++++++++++++
 tools/lib/perf/parse-events.h      |   38 ++
 tools/perf/Makefile                |   21 +-
 tools/perf/bench/mem-memcpy.c      |    2 +-
 tools/perf/builtin-annotate.c      |    2 +-
 tools/perf/builtin-buildid-cache.c |    2 +-
 tools/perf/builtin-inject.c        |    1 +
 tools/perf/builtin-kmem.c          |    2 +-
 tools/perf/builtin-kvm.c           |    2 +-
 tools/perf/builtin-list.c          |    2 +-
 tools/perf/builtin-lock.c          |    2 +-
 tools/perf/builtin-record.c        |    4 +-
 tools/perf/builtin-report.c        |    4 +-
 tools/perf/builtin-sched.c         |    2 +-
 tools/perf/builtin-stat.c          |    4 +-
 tools/perf/builtin-timechart.c     |    4 +-
 tools/perf/builtin-top.c           |    2 +-
 tools/perf/builtin-trace.c         |    2 +-
 tools/perf/perf.c                  |    2 +-
 tools/perf/util/header.c           | 1199 ------------------------------------
 tools/perf/util/header.h           |  127 ----
 tools/perf/util/parse-events.c     |  957 ----------------------------
 tools/perf/util/parse-events.h     |   36 --
 tools/perf/util/session.h          |   17 +-
 tools/perf/util/sort.h             |    4 +-
 tools/perf/util/trace-event.h      |    2 +-
 30 files changed, 2364 insertions(+), 2363 deletions(-)
 create mode 100644 tools/lib/perf/header.c
 create mode 100644 tools/lib/perf/header.h
 create mode 100644 tools/lib/perf/parse-events.c
 create mode 100644 tools/lib/perf/parse-events.h
 delete mode 100644 tools/perf/util/header.c
 delete mode 100644 tools/perf/util/header.h
 delete mode 100644 tools/perf/util/parse-events.c
 delete mode 100644 tools/perf/util/parse-events.h

diff --git a/tools/Makefile b/tools/Makefile
index e645761..9949133 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -43,7 +43,22 @@ endif
 # lib includes for submake
 BASIC_CFLAGS = -I$(CURDIR)/lib -I$(CURDIR)/perf -I$(CURDIR)/perf/util/include
 
-export BASIC_CFLAGS
+ifdef NO_NEWT
+	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
+else
+	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
+	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
+		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
+		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
+	else
+		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
+		BASIC_CFLAGS += -I/usr/include/slang
+		EXTLIBS += -lnewt -lslang
+		LIB_OBJS += $(OUTPUT)util/newt.o
+	endif
+endif
+
+export BASIC_CFLAGS EXTLIBS
 
 perf: lib .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 818be02..ed81953 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -13,6 +13,8 @@ LIB_H += lk/strbuf.h
 LIB_H += lk/color.h
 LIB_H += lk/debug.h
 LIB_H += lk/strlist.h
+LIB_H += perf/parse-events.h
+LIB_H += perf/header.h
 
 LIB_OBJS += $(OUTPUT)lk/bitmap.o
 LIB_OBJS += $(OUTPUT)lk/cpumap.o
@@ -29,6 +31,8 @@ LIB_OBJS += $(OUTPUT)lk/debug.o
 LIB_OBJS += $(OUTPUT)lk/string.o
 LIB_OBJS += $(OUTPUT)lk/rbtree.o
 LIB_OBJS += $(OUTPUT)lk/strlist.o
+LIB_OBJS += $(OUTPUT)perf/parse-events.o
+LIB_OBJS += $(OUTPUT)perf/header.o
 
 LIBFILE = lklib.a
 
diff --git a/tools/lib/perf/header.c b/tools/lib/perf/header.c
new file mode 100644
index 0000000..6804546
--- /dev/null
+++ b/tools/lib/perf/header.c
@@ -0,0 +1,1199 @@
+#define _FILE_OFFSET_BITS 64
+
+#include <sys/types.h>
+#include <byteswap.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+
+#include <lk/util.h>
+#include "header.h"
+#include <perf.h>
+#include <util/trace-event.h>
+#include <util/session.h>
+#include <util/symbol.h>
+#include <lk/debug.h>
+
+static bool no_buildid_cache = false;
+
+/*
+ * Create new perf.data header attribute:
+ */
+struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr)
+{
+	struct perf_header_attr *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->attr = *attr;
+		self->ids  = 0;
+		self->size = 1;
+		self->id   = malloc(sizeof(u64));
+		if (self->id == NULL) {
+			free(self);
+			self = NULL;
+		}
+	}
+
+	return self;
+}
+
+void perf_header_attr__delete(struct perf_header_attr *self)
+{
+	free(self->id);
+	free(self);
+}
+
+int perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
+{
+	int pos = self->ids;
+
+	self->ids++;
+	if (self->ids > self->size) {
+		int nsize = self->size * 2;
+		u64 *nid = realloc(self->id, nsize * sizeof(u64));
+
+		if (nid == NULL)
+			return -1;
+
+		self->size = nsize;
+		self->id = nid;
+	}
+	self->id[pos] = id;
+	return 0;
+}
+
+int perf_header__init(struct perf_header *self)
+{
+	self->size = 1;
+	self->attr = malloc(sizeof(void *));
+	return self->attr == NULL ? -ENOMEM : 0;
+}
+
+void perf_header__exit(struct perf_header *self)
+{
+	int i;
+	for (i = 0; i < self->attrs; ++i)
+                perf_header_attr__delete(self->attr[i]);
+	free(self->attr);
+}
+
+int perf_header__add_attr(struct perf_header *self,
+			  struct perf_header_attr *attr)
+{
+	if (self->frozen)
+		return -1;
+
+	if (self->attrs == self->size) {
+		int nsize = self->size * 2;
+		struct perf_header_attr **nattr;
+
+		nattr = realloc(self->attr, nsize * sizeof(void *));
+		if (nattr == NULL)
+			return -1;
+
+		self->size = nsize;
+		self->attr = nattr;
+	}
+
+	self->attr[self->attrs++] = attr;
+	return 0;
+}
+
+static int event_count;
+static struct perf_trace_event_type *events;
+
+int perf_header__push_event(u64 id, const char *name)
+{
+	if (strlen(name) > MAX_EVENT_NAME)
+		pr_warning("Event %s will be truncated\n", name);
+
+	if (!events) {
+		events = malloc(sizeof(struct perf_trace_event_type));
+		if (events == NULL)
+			return -ENOMEM;
+	} else {
+		struct perf_trace_event_type *nevents;
+
+		nevents = realloc(events, (event_count + 1) * sizeof(*events));
+		if (nevents == NULL)
+			return -ENOMEM;
+		events = nevents;
+	}
+	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
+	events[event_count].event_id = id;
+	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
+	event_count++;
+	return 0;
+}
+
+char *perf_header__find_event(u64 id)
+{
+	int i;
+	for (i = 0 ; i < event_count; i++) {
+		if (events[i].event_id == id)
+			return events[i].name;
+	}
+	return NULL;
+}
+
+static const char *__perf_magic = "PERFFILE";
+
+#define PERF_MAGIC	(*(u64 *)__perf_magic)
+
+struct perf_file_attr {
+	struct perf_event_attr	attr;
+	struct perf_file_section	ids;
+};
+
+void perf_header__set_feat(struct perf_header *self, int feat)
+{
+	set_bit(feat, self->adds_features);
+}
+
+bool perf_header__has_feat(const struct perf_header *self, int feat)
+{
+	return test_bit(feat, self->adds_features);
+}
+
+static int do_write(int fd, const void *buf, size_t size)
+{
+	while (size) {
+		int ret = write(fd, buf, size);
+
+		if (ret < 0)
+			return -errno;
+
+		size -= ret;
+		buf += ret;
+	}
+
+	return 0;
+}
+
+#define NAME_ALIGN 64
+
+static int write_padded(int fd, const void *bf, size_t count,
+			size_t count_aligned)
+{
+	static const char zero_buf[NAME_ALIGN];
+	int err = do_write(fd, bf, count);
+
+	if (!err)
+		err = do_write(fd, zero_buf, count_aligned - count);
+
+	return err;
+}
+
+#define dsos__for_each_with_build_id(pos, head)	\
+	list_for_each_entry(pos, head, node)	\
+		if (!pos->has_build_id)		\
+			continue;		\
+		else
+
+static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
+				u16 misc, int fd)
+{
+	struct dso *pos;
+
+	dsos__for_each_with_build_id(pos, head) {
+		int err;
+		struct build_id_event b;
+		size_t len;
+
+		if (!pos->hit)
+			continue;
+		len = pos->long_name_len + 1;
+		len = ALIGN(len, NAME_ALIGN);
+		memset(&b, 0, sizeof(b));
+		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
+		b.pid = pid;
+		b.header.misc = misc;
+		b.header.size = sizeof(b) + len;
+		err = do_write(fd, &b, sizeof(b));
+		if (err < 0)
+			return err;
+		err = write_padded(fd, pos->long_name,
+				   pos->long_name_len + 1, len);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
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
+static int dsos__write_buildid_table(struct perf_header *header, int fd)
+{
+	struct perf_session *session = container_of(header,
+			struct perf_session, header);
+	struct rb_node *nd;
+	int err = machine__write_buildid_table(&session->host_machine, fd);
+
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		err = machine__write_buildid_table(pos, fd);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms)
+{
+	const size_t size = PATH_MAX;
+	char *filename = malloc(size),
+	     *linkname = malloc(size), *targetname;
+	int len, err = -1;
+
+	if (filename == NULL || linkname == NULL)
+		goto out_free;
+
+	len = snprintf(filename, size, "%s%s%s",
+		       debugdir, is_kallsyms ? "/" : "", name);
+	if (mkdir_p(filename, 0755))
+		goto out_free;
+
+	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
+
+	if (access(filename, F_OK)) {
+		if (is_kallsyms) {
+			 if (copyfile("/proc/kallsyms", filename))
+				goto out_free;
+		} else if (link(name, filename) && copyfile(name, filename))
+			goto out_free;
+	}
+
+	len = snprintf(linkname, size, "%s/.build-id/%.2s",
+		       debugdir, sbuild_id);
+
+	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
+		goto out_free;
+
+	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
+	targetname = filename + strlen(debugdir) - 5;
+	memcpy(targetname, "../..", 5);
+
+	if (symlink(targetname, linkname) == 0)
+		err = 0;
+out_free:
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
+				 const char *name, const char *debugdir,
+				 bool is_kallsyms)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	build_id__sprintf(build_id, build_id_size, sbuild_id);
+
+	return build_id_cache__add_s(sbuild_id, debugdir, name, is_kallsyms);
+}
+
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
+{
+	const size_t size = PATH_MAX;
+	char *filename = malloc(size),
+	     *linkname = malloc(size);
+	int err = -1;
+
+	if (filename == NULL || linkname == NULL)
+		goto out_free;
+
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, sbuild_id + 2);
+
+	if (access(linkname, F_OK))
+		goto out_free;
+
+	if (readlink(linkname, filename, size) < 0)
+		goto out_free;
+
+	if (unlink(linkname))
+		goto out_free;
+
+	/*
+	 * Since the link is relative, we must make it absolute:
+	 */
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, filename);
+
+	if (unlink(linkname))
+		goto out_free;
+
+	err = 0;
+out_free:
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int dso__cache_build_id(struct dso *self, const char *debugdir)
+{
+	bool is_kallsyms = self->kernel && self->long_name[0] != '/';
+
+	return build_id_cache__add_b(self->build_id, sizeof(self->build_id),
+				     self->long_name, debugdir, is_kallsyms);
+}
+
+static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
+{
+	struct dso *pos;
+	int err = 0;
+
+	dsos__for_each_with_build_id(pos, head)
+		if (dso__cache_build_id(pos, debugdir))
+			err = -1;
+
+	return err;
+}
+
+static int machine__cache_build_ids(struct machine *self, const char *debugdir)
+{
+	int ret = __dsos__cache_build_ids(&self->kernel_dsos, debugdir);
+	ret |= __dsos__cache_build_ids(&self->user_dsos, debugdir);
+	return ret;
+}
+
+static int perf_session__cache_build_ids(struct perf_session *self)
+{
+	struct rb_node *nd;
+	int ret;
+	char debugdir[PATH_MAX];
+
+	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
+
+	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
+		return -1;
+
+	ret = machine__cache_build_ids(&self->host_machine, debugdir);
+
+	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__cache_build_ids(pos, debugdir);
+	}
+	return ret ? -1 : 0;
+}
+
+static bool machine__read_build_ids(struct machine *self, bool with_hits)
+{
+	bool ret = __dsos__read_build_ids(&self->kernel_dsos, with_hits);
+	ret |= __dsos__read_build_ids(&self->user_dsos, with_hits);
+	return ret;
+}
+
+static bool perf_session__read_build_ids(struct perf_session *self, bool with_hits)
+{
+	struct rb_node *nd;
+	bool ret = machine__read_build_ids(&self->host_machine, with_hits);
+
+	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__read_build_ids(pos, with_hits);
+	}
+
+	return ret;
+}
+
+static int perf_header__adds_write(struct perf_header *self, int fd)
+{
+	int nr_sections;
+	struct perf_session *session;
+	struct perf_file_section *feat_sec;
+	int sec_size;
+	u64 sec_start;
+	int idx = 0, err;
+
+	session = container_of(self, struct perf_session, header);
+	if (perf_session__read_build_ids(session, true))
+		perf_header__set_feat(self, HEADER_BUILD_ID);
+
+	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
+	if (!nr_sections)
+		return 0;
+
+	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
+	if (feat_sec == NULL)
+		return -ENOMEM;
+
+	sec_size = sizeof(*feat_sec) * nr_sections;
+
+	sec_start = self->data_offset + self->data_size;
+	lseek(fd, sec_start + sec_size, SEEK_SET);
+
+	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
+		struct perf_file_section *trace_sec;
+
+		trace_sec = &feat_sec[idx++];
+
+		/* Write trace info */
+		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
+		read_tracing_data(fd, attrs, nr_counters);
+		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
+	}
+
+	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
+		struct perf_file_section *buildid_sec;
+
+		buildid_sec = &feat_sec[idx++];
+
+		/* Write build-ids */
+		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
+		err = dsos__write_buildid_table(self, fd);
+		if (err < 0) {
+			pr_debug("failed to write buildid table\n");
+			goto out_free;
+		}
+		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
+					  buildid_sec->offset;
+		if (!no_buildid_cache)
+			perf_session__cache_build_ids(session);
+	}
+
+	lseek(fd, sec_start, SEEK_SET);
+	err = do_write(fd, feat_sec, sec_size);
+	if (err < 0)
+		pr_debug("failed to write feature section\n");
+out_free:
+	free(feat_sec);
+	return err;
+}
+
+int perf_header__write_pipe(int fd)
+{
+	struct perf_pipe_file_header f_header;
+	int err;
+
+	f_header = (struct perf_pipe_file_header){
+		.magic	   = PERF_MAGIC,
+		.size	   = sizeof(f_header),
+	};
+
+	err = do_write(fd, &f_header, sizeof(f_header));
+	if (err < 0) {
+		pr_debug("failed to write perf pipe header\n");
+		return err;
+	}
+
+	return 0;
+}
+
+int perf_header__write(struct perf_header *self, int fd, bool at_exit)
+{
+	struct perf_file_header f_header;
+	struct perf_file_attr   f_attr;
+	struct perf_header_attr	*attr;
+	int i, err;
+
+	lseek(fd, sizeof(f_header), SEEK_SET);
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		attr->id_offset = lseek(fd, 0, SEEK_CUR);
+		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		if (err < 0) {
+			pr_debug("failed to write perf header\n");
+			return err;
+		}
+	}
+
+
+	self->attr_offset = lseek(fd, 0, SEEK_CUR);
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		f_attr = (struct perf_file_attr){
+			.attr = attr->attr,
+			.ids  = {
+				.offset = attr->id_offset,
+				.size   = attr->ids * sizeof(u64),
+			}
+		};
+		err = do_write(fd, &f_attr, sizeof(f_attr));
+		if (err < 0) {
+			pr_debug("failed to write perf header attribute\n");
+			return err;
+		}
+	}
+
+	self->event_offset = lseek(fd, 0, SEEK_CUR);
+	self->event_size = event_count * sizeof(struct perf_trace_event_type);
+	if (events) {
+		err = do_write(fd, events, self->event_size);
+		if (err < 0) {
+			pr_debug("failed to write perf header events\n");
+			return err;
+		}
+	}
+
+	self->data_offset = lseek(fd, 0, SEEK_CUR);
+
+	if (at_exit) {
+		err = perf_header__adds_write(self, fd);
+		if (err < 0)
+			return err;
+	}
+
+	f_header = (struct perf_file_header){
+		.magic	   = PERF_MAGIC,
+		.size	   = sizeof(f_header),
+		.attr_size = sizeof(f_attr),
+		.attrs = {
+			.offset = self->attr_offset,
+			.size   = self->attrs * sizeof(f_attr),
+		},
+		.data = {
+			.offset = self->data_offset,
+			.size	= self->data_size,
+		},
+		.event_types = {
+			.offset = self->event_offset,
+			.size	= self->event_size,
+		},
+	};
+
+	memcpy(&f_header.adds_features, &self->adds_features, sizeof(self->adds_features));
+
+	lseek(fd, 0, SEEK_SET);
+	err = do_write(fd, &f_header, sizeof(f_header));
+	if (err < 0) {
+		pr_debug("failed to write perf header\n");
+		return err;
+	}
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	self->frozen = 1;
+	return 0;
+}
+
+static int perf_header__getbuffer64(struct perf_header *self,
+				    int fd, void *buf, size_t size)
+{
+	if (do_read(fd, buf, size) <= 0)
+		return -1;
+
+	if (self->needs_swap)
+		mem_bswap_64(buf, size);
+
+	return 0;
+}
+
+int perf_header__process_sections(struct perf_header *self, int fd,
+				  int (*process)(struct perf_file_section *self,
+						 struct perf_header *ph,
+						 int feat, int fd))
+{
+	struct perf_file_section *feat_sec;
+	int nr_sections;
+	int sec_size;
+	int idx = 0;
+	int err = -1, feat = 1;
+
+	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
+	if (!nr_sections)
+		return 0;
+
+	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
+	if (!feat_sec)
+		return -1;
+
+	sec_size = sizeof(*feat_sec) * nr_sections;
+
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
+		goto out_free;
+
+	err = 0;
+	while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
+		if (perf_header__has_feat(self, feat)) {
+			struct perf_file_section *sec = &feat_sec[idx++];
+
+			err = process(sec, self, feat, fd);
+			if (err < 0)
+				break;
+		}
+		++feat;
+	}
+out_free:
+	free(feat_sec);
+	return err;
+}
+
+int perf_file_header__read(struct perf_file_header *self,
+			   struct perf_header *ph, int fd)
+{
+	lseek(fd, 0, SEEK_SET);
+
+	if (do_read(fd, self, sizeof(*self)) <= 0 ||
+	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
+		return -1;
+
+	if (self->attr_size != sizeof(struct perf_file_attr)) {
+		u64 attr_size = bswap_64(self->attr_size);
+
+		if (attr_size != sizeof(struct perf_file_attr))
+			return -1;
+
+		mem_bswap_64(self, offsetof(struct perf_file_header,
+					    adds_features));
+		ph->needs_swap = true;
+	}
+
+	if (self->size != sizeof(*self)) {
+		/* Support the previous format */
+		if (self->size == offsetof(typeof(*self), adds_features))
+			bitmap_zero(self->adds_features, HEADER_FEAT_BITS);
+		else
+			return -1;
+	}
+
+	memcpy(&ph->adds_features, &self->adds_features,
+	       sizeof(ph->adds_features));
+	/*
+	 * FIXME: hack that assumes that if we need swap the perf.data file
+	 * may be coming from an arch with a different word-size, ergo different
+	 * DEFINE_BITMAP format, investigate more later, but for now its mostly
+	 * safe to assume that we have a build-id section. Trace files probably
+	 * have several other issues in this realm anyway...
+	 */
+	if (ph->needs_swap) {
+		memset(&ph->adds_features, 0, sizeof(ph->adds_features));
+		perf_header__set_feat(ph, HEADER_BUILD_ID);
+	}
+
+	ph->event_offset = self->event_types.offset;
+	ph->event_size   = self->event_types.size;
+	ph->data_offset  = self->data.offset;
+	ph->data_size	 = self->data.size;
+	return 0;
+}
+
+static int __event_process_build_id(struct build_id_event *bev,
+				    char *filename,
+				    struct perf_session *session)
+{
+	int err = -1;
+	struct list_head *head;
+	struct machine *machine;
+	u16 misc;
+	struct dso *dso;
+	enum dso_kernel_type dso_type;
+
+	machine = perf_session__findnew_machine(session, bev->pid);
+	if (!machine)
+		goto out;
+
+	misc = bev->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	switch (misc) {
+	case PERF_RECORD_MISC_KERNEL:
+		dso_type = DSO_TYPE_KERNEL;
+		head = &machine->kernel_dsos;
+		break;
+	case PERF_RECORD_MISC_GUEST_KERNEL:
+		dso_type = DSO_TYPE_GUEST_KERNEL;
+		head = &machine->kernel_dsos;
+		break;
+	case PERF_RECORD_MISC_USER:
+	case PERF_RECORD_MISC_GUEST_USER:
+		dso_type = DSO_TYPE_USER;
+		head = &machine->user_dsos;
+		break;
+	default:
+		goto out;
+	}
+
+	dso = __dsos__findnew(head, filename);
+	if (dso != NULL) {
+		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+		dso__set_build_id(dso, &bev->build_id);
+
+		if (filename[0] == '[')
+			dso->kernel = dso_type;
+
+		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
+				  sbuild_id);
+		pr_debug("build id event received for %s: %s\n",
+			 dso->long_name, sbuild_id);
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
+static int perf_header__read_build_ids(struct perf_header *self,
+			int input, u64 offset, u64 size)
+{
+	struct perf_session *session = container_of(self,
+			struct perf_session, header);
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	u64 limit = offset + size;
+	int err = -1;
+
+	while (offset < limit) {
+		ssize_t len;
+
+		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
+			goto out;
+
+		if (self->needs_swap)
+			perf_event_header__bswap(&bev.header);
+
+		len = bev.header.size - sizeof(bev);
+		if (read(input, filename, len) != len)
+			goto out;
+
+		__event_process_build_id(&bev, filename, session);
+
+		offset += bev.header.size;
+	}
+	err = 0;
+out:
+	return err;
+}
+
+static int perf_file_section__process(struct perf_file_section *self,
+				      struct perf_header *ph,
+				      int feat, int fd)
+{
+	if (lseek(fd, self->offset, SEEK_SET) == (off_t)-1) {
+		pr_debug("Failed to lseek to %Ld offset for feature %d, "
+			 "continuing...\n", self->offset, feat);
+		return 0;
+	}
+
+	switch (feat) {
+	case HEADER_TRACE_INFO:
+		trace_report(fd, false);
+		break;
+
+	case HEADER_BUILD_ID:
+		if (perf_header__read_build_ids(ph, fd, self->offset, self->size))
+			pr_debug("Failed to read buildids, continuing...\n");
+		break;
+	default:
+		pr_debug("unknown feature %d, continuing...\n", feat);
+	}
+
+	return 0;
+}
+
+static int perf_file_header__read_pipe(struct perf_pipe_file_header *self,
+				       struct perf_header *ph, int fd,
+				       bool repipe)
+{
+	if (do_read(fd, self, sizeof(*self)) <= 0 ||
+	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
+		return -1;
+
+	if (repipe && do_write(STDOUT_FILENO, self, sizeof(*self)) < 0)
+		return -1;
+
+	if (self->size != sizeof(*self)) {
+		u64 size = bswap_64(self->size);
+
+		if (size != sizeof(*self))
+			return -1;
+
+		ph->needs_swap = true;
+	}
+
+	return 0;
+}
+
+static int perf_header__read_pipe(struct perf_session *session, int fd)
+{
+	struct perf_header *self = &session->header;
+	struct perf_pipe_file_header f_header;
+
+	if (perf_file_header__read_pipe(&f_header, self, fd,
+					session->repipe) < 0) {
+		pr_debug("incompatible file format\n");
+		return -EINVAL;
+	}
+
+	session->fd = fd;
+
+	return 0;
+}
+
+int perf_header__read(struct perf_session *session, int fd)
+{
+	struct perf_header *self = &session->header;
+	struct perf_file_header	f_header;
+	struct perf_file_attr	f_attr;
+	u64			f_id;
+	int nr_attrs, nr_ids, i, j;
+
+	if (session->fd_pipe)
+		return perf_header__read_pipe(session, fd);
+
+	if (perf_file_header__read(&f_header, self, fd) < 0) {
+		pr_debug("incompatible file format\n");
+		return -EINVAL;
+	}
+
+	nr_attrs = f_header.attrs.size / sizeof(f_attr);
+	lseek(fd, f_header.attrs.offset, SEEK_SET);
+
+	for (i = 0; i < nr_attrs; i++) {
+		struct perf_header_attr *attr;
+		off_t tmp;
+
+		if (perf_header__getbuffer64(self, fd, &f_attr, sizeof(f_attr)))
+			goto out_errno;
+
+		tmp = lseek(fd, 0, SEEK_CUR);
+
+		attr = perf_header_attr__new(&f_attr.attr);
+		if (attr == NULL)
+			 return -ENOMEM;
+
+		nr_ids = f_attr.ids.size / sizeof(u64);
+		lseek(fd, f_attr.ids.offset, SEEK_SET);
+
+		for (j = 0; j < nr_ids; j++) {
+			if (perf_header__getbuffer64(self, fd, &f_id, sizeof(f_id)))
+				goto out_errno;
+
+			if (perf_header_attr__add_id(attr, f_id) < 0) {
+				perf_header_attr__delete(attr);
+				return -ENOMEM;
+			}
+		}
+		if (perf_header__add_attr(self, attr) < 0) {
+			perf_header_attr__delete(attr);
+			return -ENOMEM;
+		}
+
+		lseek(fd, tmp, SEEK_SET);
+	}
+
+	if (f_header.event_types.size) {
+		lseek(fd, f_header.event_types.offset, SEEK_SET);
+		events = malloc(f_header.event_types.size);
+		if (events == NULL)
+			return -ENOMEM;
+		if (perf_header__getbuffer64(self, fd, events,
+					     f_header.event_types.size))
+			goto out_errno;
+		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
+	}
+
+	perf_header__process_sections(self, fd, perf_file_section__process);
+
+	lseek(fd, self->data_offset, SEEK_SET);
+
+	self->frozen = 1;
+	return 0;
+out_errno:
+	return -errno;
+}
+
+u64 perf_header__sample_type(struct perf_header *header)
+{
+	u64 type = 0;
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (!type)
+			type = attr->attr.sample_type;
+		else if (type != attr->attr.sample_type)
+			die("non matching sample_type");
+	}
+
+	return type;
+}
+
+struct perf_event_attr *
+perf_header__find_attr(u64 id, struct perf_header *header)
+{
+	int i;
+
+	/*
+	 * We set id to -1 if the data file doesn't contain sample
+	 * ids. Check for this and avoid walking through the entire
+	 * list of ids which may be large.
+	 */
+	if (id == -1ULL)
+		return NULL;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+		int j;
+
+		for (j = 0; j < attr->ids; j++) {
+			if (attr->id[j] == id)
+				return &attr->attr;
+		}
+	}
+
+	return NULL;
+}
+
+int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+			   event__handler_t process,
+			   struct perf_session *session)
+{
+	event_t *ev;
+	size_t size;
+	int err;
+
+	size = sizeof(struct perf_event_attr);
+	size = ALIGN(size, sizeof(u64));
+	size += sizeof(struct perf_event_header);
+	size += ids * sizeof(u64);
+
+	ev = malloc(size);
+
+	ev->attr.attr = *attr;
+	memcpy(ev->attr.id, id, ids * sizeof(u64));
+
+	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
+	ev->attr.header.size = size;
+
+	err = process(ev, session);
+
+	free(ev);
+
+	return err;
+}
+
+int event__synthesize_attrs(struct perf_header *self,
+			    event__handler_t process,
+			    struct perf_session *session)
+{
+	struct perf_header_attr	*attr;
+	int i, err = 0;
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		err = event__synthesize_attr(&attr->attr, attr->ids, attr->id,
+					     process, session);
+		if (err) {
+			pr_debug("failed to create perf header attribute\n");
+			return err;
+		}
+	}
+
+	return err;
+}
+
+int event__process_attr(event_t *self, struct perf_session *session)
+{
+	struct perf_header_attr *attr;
+	unsigned int i, ids, n_ids;
+
+	attr = perf_header_attr__new(&self->attr.attr);
+	if (attr == NULL)
+		return -ENOMEM;
+
+	ids = self->header.size;
+	ids -= (void *)&self->attr.id - (void *)self;
+	n_ids = ids / sizeof(u64);
+
+	for (i = 0; i < n_ids; i++) {
+		if (perf_header_attr__add_id(attr, self->attr.id[i]) < 0) {
+			perf_header_attr__delete(attr);
+			return -ENOMEM;
+		}
+	}
+
+	if (perf_header__add_attr(&session->header, attr) < 0) {
+		perf_header_attr__delete(attr);
+		return -ENOMEM;
+	}
+
+	perf_session__update_sample_type(session);
+
+	return 0;
+}
+
+int event__synthesize_event_type(u64 event_id, char *name,
+				 event__handler_t process,
+				 struct perf_session *session)
+{
+	event_t ev;
+	size_t size = 0;
+	int err = 0;
+
+	memset(&ev, 0, sizeof(ev));
+
+	ev.event_type.event_type.event_id = event_id;
+	memset(ev.event_type.event_type.name, 0, MAX_EVENT_NAME);
+	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
+
+	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
+	size = strlen(name);
+	size = ALIGN(size, sizeof(u64));
+	ev.event_type.header.size = sizeof(ev.event_type) -
+		(sizeof(ev.event_type.event_type.name) - size);
+
+	err = process(&ev, session);
+
+	return err;
+}
+
+int event__synthesize_event_types(event__handler_t process,
+				  struct perf_session *session)
+{
+	struct perf_trace_event_type *type;
+	int i, err = 0;
+
+	for (i = 0; i < event_count; i++) {
+		type = &events[i];
+
+		err = event__synthesize_event_type(type->event_id, type->name,
+						   process, session);
+		if (err) {
+			pr_debug("failed to create perf header event type\n");
+			return err;
+		}
+	}
+
+	return err;
+}
+
+int event__process_event_type(event_t *self,
+			      struct perf_session *session __unused)
+{
+	if (perf_header__push_event(self->event_type.event_type.event_id,
+				    self->event_type.event_type.name) < 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
+				   int nb_events,
+				   event__handler_t process,
+				   struct perf_session *session __unused)
+{
+	event_t ev;
+	ssize_t size = 0, aligned_size = 0, padding;
+	int err = 0;
+
+	memset(&ev, 0, sizeof(ev));
+
+	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
+	size = read_tracing_data_size(fd, pattrs, nb_events);
+	if (size <= 0)
+		return size;
+	aligned_size = ALIGN(size, sizeof(u64));
+	padding = aligned_size - size;
+	ev.tracing_data.header.size = sizeof(ev.tracing_data);
+	ev.tracing_data.size = aligned_size;
+
+	process(&ev, session);
+
+	err = read_tracing_data(fd, pattrs, nb_events);
+	write_padded(fd, NULL, 0, padding);
+
+	return aligned_size;
+}
+
+int event__process_tracing_data(event_t *self,
+				struct perf_session *session)
+{
+	ssize_t size_read, padding, size = self->tracing_data.size;
+	off_t offset = lseek(session->fd, 0, SEEK_CUR);
+	char buf[BUFSIZ];
+
+	/* setup for reading amidst mmap */
+	lseek(session->fd, offset + sizeof(struct tracing_data_event),
+	      SEEK_SET);
+
+	size_read = trace_report(session->fd, session->repipe);
+
+	padding = ALIGN(size_read, sizeof(u64)) - size_read;
+
+	if (read(session->fd, buf, padding) < 0)
+		die("reading input file");
+	if (session->repipe) {
+		int retw = write(STDOUT_FILENO, buf, padding);
+		if (retw <= 0 || retw != padding)
+			die("repiping tracing data padding");
+	}
+
+	if (size_read + padding != size)
+		die("tracing data size mismatch");
+
+	return size_read + padding;
+}
+
+int event__synthesize_build_id(struct dso *pos, u16 misc,
+			       event__handler_t process,
+			       struct machine *machine,
+			       struct perf_session *session)
+{
+	event_t ev;
+	size_t len;
+	int err = 0;
+
+	if (!pos->hit)
+		return err;
+
+	memset(&ev, 0, sizeof(ev));
+
+	len = pos->long_name_len + 1;
+	len = ALIGN(len, NAME_ALIGN);
+	memcpy(&ev.build_id.build_id, pos->build_id, sizeof(pos->build_id));
+	ev.build_id.header.type = PERF_RECORD_HEADER_BUILD_ID;
+	ev.build_id.header.misc = misc;
+	ev.build_id.pid = machine->pid;
+	ev.build_id.header.size = sizeof(ev.build_id) + len;
+	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
+
+	err = process(&ev, session);
+
+	return err;
+}
+
+int event__process_build_id(event_t *self,
+			    struct perf_session *session)
+{
+	__event_process_build_id(&self->build_id,
+				 self->build_id.filename,
+				 session);
+	return 0;
+}
+
+void disable_buildid_cache(void)
+{
+	no_buildid_cache = true;
+}
diff --git a/tools/lib/perf/header.h b/tools/lib/perf/header.h
new file mode 100644
index 0000000..e8cdb86
--- /dev/null
+++ b/tools/lib/perf/header.h
@@ -0,0 +1,110 @@
+#ifndef __PERF_HEADER_H
+#define __PERF_HEADER_H
+
+#include "../../../include/linux/perf_event.h"
+#include <sys/types.h>
+#include <stdbool.h>
+#include <lk/types.h>
+#include <util/event.h>
+#include <util/session.h>
+
+#include <linux/bitmap.h>
+
+struct perf_header_attr {
+	struct perf_event_attr attr;
+	int ids, size;
+	u64 *id;
+	off_t id_offset;
+};
+
+enum {
+	HEADER_TRACE_INFO = 1,
+	HEADER_BUILD_ID,
+	HEADER_LAST_FEATURE,
+};
+
+struct perf_file_section {
+	u64 offset;
+	u64 size;
+};
+
+struct perf_file_header {
+	u64				magic;
+	u64				size;
+	u64				attr_size;
+	struct perf_file_section	attrs;
+	struct perf_file_section	data;
+	struct perf_file_section	event_types;
+	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+};
+
+struct perf_pipe_file_header {
+	u64				magic;
+	u64				size;
+};
+
+int perf_file_header__read(struct perf_file_header *self,
+			   struct perf_header *ph, int fd);
+int perf_header__init(struct perf_header *self);
+void perf_header__exit(struct perf_header *self);
+
+int perf_header__read(struct perf_session *session, int fd);
+int perf_header__write(struct perf_header *self, int fd, bool at_exit);
+int perf_header__write_pipe(int fd);
+
+int perf_header__add_attr(struct perf_header *self,
+			  struct perf_header_attr *attr);
+
+int perf_header__push_event(u64 id, const char *name);
+char *perf_header__find_event(u64 id);
+
+struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
+void perf_header_attr__delete(struct perf_header_attr *self);
+
+int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
+
+u64 perf_header__sample_type(struct perf_header *header);
+struct perf_event_attr *
+perf_header__find_attr(u64 id, struct perf_header *header);
+void perf_header__set_feat(struct perf_header *self, int feat);
+bool perf_header__has_feat(const struct perf_header *self, int feat);
+
+int perf_header__process_sections(struct perf_header *self, int fd,
+				  int (*process)(struct perf_file_section *self,
+						 struct perf_header *ph,
+						 int feat, int fd));
+
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms);
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
+
+int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+			   event__handler_t process,
+			   struct perf_session *session);
+int event__synthesize_attrs(struct perf_header *self,
+			    event__handler_t process,
+			    struct perf_session *session);
+int event__process_attr(event_t *self, struct perf_session *session);
+
+int event__synthesize_event_type(u64 event_id, char *name,
+				 event__handler_t process,
+				 struct perf_session *session);
+int event__synthesize_event_types(event__handler_t process,
+				  struct perf_session *session);
+int event__process_event_type(event_t *self,
+			      struct perf_session *session);
+
+int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
+				   int nb_events,
+				   event__handler_t process,
+				   struct perf_session *session);
+int event__process_tracing_data(event_t *self,
+				struct perf_session *session);
+
+int event__synthesize_build_id(struct dso *pos, u16 misc,
+			       event__handler_t process,
+			       struct machine *machine,
+			       struct perf_session *session);
+int event__process_build_id(event_t *self, struct perf_session *session);
+
+#endif /* __PERF_HEADER_H */
diff --git a/tools/lib/perf/parse-events.c b/tools/lib/perf/parse-events.c
new file mode 100644
index 0000000..f028838
--- /dev/null
+++ b/tools/lib/perf/parse-events.c
@@ -0,0 +1,957 @@
+#include "../../../include/linux/hw_breakpoint.h"
+#include <lk/util.h>
+#include <lk/debug.h>
+#include <perf.h>
+#include <util/parse-options.h>
+#include "parse-events.h"
+#include <util/exec_cmd.h>
+#include "string.h"
+#include <util/symbol.h>
+#include <util/cache.h>
+#include "header.h"
+#include <lk/debugfs.h>
+
+int				nr_counters;
+
+struct perf_event_attr		attrs[MAX_COUNTERS];
+char				*filters[MAX_COUNTERS];
+
+struct event_symbol {
+	u8		type;
+	u64		config;
+	const char	*symbol;
+	const char	*alias;
+};
+
+enum event_result {
+	EVT_FAILED,
+	EVT_HANDLED,
+	EVT_HANDLED_ALL
+};
+
+#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
+#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
+
+static struct event_symbol event_symbols[] = {
+  { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
+  { CHW(INSTRUCTIONS),		"instructions",		""		},
+  { CHW(CACHE_REFERENCES),	"cache-references",	""		},
+  { CHW(CACHE_MISSES),		"cache-misses",		""		},
+  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
+  { CHW(BRANCH_MISSES),		"branch-misses",	""		},
+  { CHW(BUS_CYCLES),		"bus-cycles",		""		},
+
+  { CSW(CPU_CLOCK),		"cpu-clock",		""		},
+  { CSW(TASK_CLOCK),		"task-clock",		""		},
+  { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
+  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
+  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
+  { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
+  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
+  { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
+  { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
+};
+
+#define __PERF_EVENT_FIELD(config, name) \
+	((config & PERF_EVENT_##name##_MASK) >> PERF_EVENT_##name##_SHIFT)
+
+#define PERF_EVENT_RAW(config)	__PERF_EVENT_FIELD(config, RAW)
+#define PERF_EVENT_CONFIG(config)	__PERF_EVENT_FIELD(config, CONFIG)
+#define PERF_EVENT_TYPE(config)	__PERF_EVENT_FIELD(config, TYPE)
+#define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
+
+static const char *hw_event_names[] = {
+	"cycles",
+	"instructions",
+	"cache-references",
+	"cache-misses",
+	"branches",
+	"branch-misses",
+	"bus-cycles",
+};
+
+static const char *sw_event_names[] = {
+	"cpu-clock-msecs",
+	"task-clock-msecs",
+	"page-faults",
+	"context-switches",
+	"CPU-migrations",
+	"minor-faults",
+	"major-faults",
+	"alignment-faults",
+	"emulation-faults",
+};
+
+#define MAX_ALIASES 8
+
+static const char *hw_cache[][MAX_ALIASES] = {
+ { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
+ { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
+ { "LLC",	"L2"							},
+ { "dTLB",	"d-tlb",	"Data-TLB",				},
+ { "iTLB",	"i-tlb",	"Instruction-TLB",			},
+ { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
+};
+
+static const char *hw_cache_op[][MAX_ALIASES] = {
+ { "load",	"loads",	"read",					},
+ { "store",	"stores",	"write",				},
+ { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
+};
+
+static const char *hw_cache_result[][MAX_ALIASES] = {
+ { "refs",	"Reference",	"ops",		"access",		},
+ { "misses",	"miss",							},
+};
+
+#define C(x)		PERF_COUNT_HW_CACHE_##x
+#define CACHE_READ	(1 << C(OP_READ))
+#define CACHE_WRITE	(1 << C(OP_WRITE))
+#define CACHE_PREFETCH	(1 << C(OP_PREFETCH))
+#define COP(x)		(1 << x)
+
+/*
+ * cache operartion stat
+ * L1I : Read and prefetch only
+ * ITLB and BPU : Read-only
+ */
+static unsigned long hw_cache_stat[C(MAX)] = {
+ [C(L1D)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(L1I)]	= (CACHE_READ | CACHE_PREFETCH),
+ [C(LL)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(ITLB)]	= (CACHE_READ),
+ [C(BPU)]	= (CACHE_READ),
+};
+
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
+	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
+	if (sys_dirent.d_type == DT_DIR &&				       \
+	   (strcmp(sys_dirent.d_name, ".")) &&				       \
+	   (strcmp(sys_dirent.d_name, "..")))
+
+static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
+{
+	char evt_path[MAXPATHLEN];
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+			sys_dir->d_name, evt_dir->d_name);
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return -EINVAL;
+	close(fd);
+
+	return 0;
+}
+
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)	       \
+	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
+	if (evt_dirent.d_type == DT_DIR &&				       \
+	   (strcmp(evt_dirent.d_name, ".")) &&				       \
+	   (strcmp(evt_dirent.d_name, "..")) &&				       \
+	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
+
+#define MAX_EVENT_LENGTH 512
+
+
+struct tracepoint_path *tracepoint_id_to_path(u64 config)
+{
+	struct tracepoint_path *path = NULL;
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	char id_buf[4];
+	int fd;
+	u64 id;
+	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
+
+	if (debugfs_valid_mountpoint(debugfs_path))
+		return NULL;
+
+	sys_dir = opendir(debugfs_path);
+	if (!sys_dir)
+		return NULL;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
+			continue;
+
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
+				 evt_dirent.d_name);
+			fd = open(evt_path, O_RDONLY);
+			if (fd < 0)
+				continue;
+			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+				close(fd);
+				continue;
+			}
+			close(fd);
+			id = atoll(id_buf);
+			if (id == config) {
+				closedir(evt_dir);
+				closedir(sys_dir);
+				path = zalloc(sizeof(*path));
+				path->system = malloc(MAX_EVENT_LENGTH);
+				if (!path->system) {
+					free(path);
+					return NULL;
+				}
+				path->name = malloc(MAX_EVENT_LENGTH);
+				if (!path->name) {
+					free(path->system);
+					free(path);
+					return NULL;
+				}
+				strncpy(path->system, sys_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				strncpy(path->name, evt_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				return path;
+			}
+		}
+		closedir(evt_dir);
+	}
+
+	closedir(sys_dir);
+	return NULL;
+}
+
+#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
+static const char *tracepoint_id_to_name(u64 config)
+{
+	static char buf[TP_PATH_LEN];
+	struct tracepoint_path *path;
+
+	path = tracepoint_id_to_path(config);
+	if (path) {
+		snprintf(buf, TP_PATH_LEN, "%s:%s", path->system, path->name);
+		free(path->name);
+		free(path->system);
+		free(path);
+	} else
+		snprintf(buf, TP_PATH_LEN, "%s:%s", "unknown", "unknown");
+
+	return buf;
+}
+
+static int is_cache_op_valid(u8 cache_type, u8 cache_op)
+{
+	if (hw_cache_stat[cache_type] & COP(cache_op))
+		return 1;	/* valid */
+	else
+		return 0;	/* invalid */
+}
+
+static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
+{
+	static char name[50];
+
+	if (cache_result) {
+		sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][0],
+			hw_cache_result[cache_result][0]);
+	} else {
+		sprintf(name, "%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][1]);
+	}
+
+	return name;
+}
+
+const char *event_name(int counter)
+{
+	u64 config = attrs[counter].config;
+	int type = attrs[counter].type;
+
+	return __event_name(type, config);
+}
+
+const char *__event_name(int type, u64 config)
+{
+	static char buf[32];
+
+	if (type == PERF_TYPE_RAW) {
+		sprintf(buf, "raw 0x%llx", config);
+		return buf;
+	}
+
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+		if (config < PERF_COUNT_HW_MAX)
+			return hw_event_names[config];
+		return "unknown-hardware";
+
+	case PERF_TYPE_HW_CACHE: {
+		u8 cache_type, cache_op, cache_result;
+
+		cache_type   = (config >>  0) & 0xff;
+		if (cache_type > PERF_COUNT_HW_CACHE_MAX)
+			return "unknown-ext-hardware-cache-type";
+
+		cache_op     = (config >>  8) & 0xff;
+		if (cache_op > PERF_COUNT_HW_CACHE_OP_MAX)
+			return "unknown-ext-hardware-cache-op";
+
+		cache_result = (config >> 16) & 0xff;
+		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
+			return "unknown-ext-hardware-cache-result";
+
+		if (!is_cache_op_valid(cache_type, cache_op))
+			return "invalid-cache";
+
+		return event_cache_name(cache_type, cache_op, cache_result);
+	}
+
+	case PERF_TYPE_SOFTWARE:
+		if (config < PERF_COUNT_SW_MAX)
+			return sw_event_names[config];
+		return "unknown-software";
+
+	case PERF_TYPE_TRACEPOINT:
+		return tracepoint_id_to_name(config);
+
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
+static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
+{
+	int i, j;
+	int n, longest = -1;
+
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
+			n = strlen(names[i][j]);
+			if (n > longest && !strncasecmp(*str, names[i][j], n))
+				longest = n;
+		}
+		if (longest > 0) {
+			*str += longest;
+			return i;
+		}
+	}
+
+	return -1;
+}
+
+static enum event_result
+parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
+{
+	const char *s = *str;
+	int cache_type = -1, cache_op = -1, cache_result = -1;
+
+	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
+	/*
+	 * No fallback - if we cannot get a clear cache type
+	 * then bail out:
+	 */
+	if (cache_type == -1)
+		return EVT_FAILED;
+
+	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
+		++s;
+
+		if (cache_op == -1) {
+			cache_op = parse_aliases(&s, hw_cache_op,
+						PERF_COUNT_HW_CACHE_OP_MAX);
+			if (cache_op >= 0) {
+				if (!is_cache_op_valid(cache_type, cache_op))
+					return 0;
+				continue;
+			}
+		}
+
+		if (cache_result == -1) {
+			cache_result = parse_aliases(&s, hw_cache_result,
+						PERF_COUNT_HW_CACHE_RESULT_MAX);
+			if (cache_result >= 0)
+				continue;
+		}
+
+		/*
+		 * Can't parse this as a cache op or result, so back up
+		 * to the '-'.
+		 */
+		--s;
+		break;
+	}
+
+	/*
+	 * Fall back to reads:
+	 */
+	if (cache_op == -1)
+		cache_op = PERF_COUNT_HW_CACHE_OP_READ;
+
+	/*
+	 * Fall back to accesses:
+	 */
+	if (cache_result == -1)
+		cache_result = PERF_COUNT_HW_CACHE_RESULT_ACCESS;
+
+	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
+	attr->type = PERF_TYPE_HW_CACHE;
+
+	*str = s;
+	return EVT_HANDLED;
+}
+
+static enum event_result
+parse_single_tracepoint_event(char *sys_name,
+			      const char *evt_name,
+			      unsigned int evt_length,
+			      struct perf_event_attr *attr,
+			      const char **strp)
+{
+	char evt_path[MAXPATHLEN];
+	char id_buf[4];
+	u64 id;
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+		 sys_name, evt_name);
+
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return EVT_FAILED;
+
+	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+		close(fd);
+		return EVT_FAILED;
+	}
+
+	close(fd);
+	id = atoll(id_buf);
+	attr->config = id;
+	attr->type = PERF_TYPE_TRACEPOINT;
+	*strp = evt_name + evt_length;
+
+	attr->sample_type |= PERF_SAMPLE_RAW;
+	attr->sample_type |= PERF_SAMPLE_TIME;
+	attr->sample_type |= PERF_SAMPLE_CPU;
+
+	attr->sample_period = 1;
+
+
+	return EVT_HANDLED;
+}
+
+/* sys + ':' + event + ':' + flags*/
+#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
+static enum event_result
+parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
+				char *flags)
+{
+	char evt_path[MAXPATHLEN];
+	struct dirent *evt_ent;
+	DIR *evt_dir;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s", debugfs_path, sys_name);
+	evt_dir = opendir(evt_path);
+
+	if (!evt_dir) {
+		perror("Can't open event dir");
+		return EVT_FAILED;
+	}
+
+	while ((evt_ent = readdir(evt_dir))) {
+		char event_opt[MAX_EVOPT_LEN + 1];
+		int len;
+
+		if (!strcmp(evt_ent->d_name, ".")
+		    || !strcmp(evt_ent->d_name, "..")
+		    || !strcmp(evt_ent->d_name, "enable")
+		    || !strcmp(evt_ent->d_name, "filter"))
+			continue;
+
+		if (!strglobmatch(evt_ent->d_name, evt_exp))
+			continue;
+
+		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
+			       evt_ent->d_name, flags ? ":" : "",
+			       flags ?: "");
+		if (len < 0)
+			return EVT_FAILED;
+
+		if (parse_events(NULL, event_opt, 0))
+			return EVT_FAILED;
+	}
+
+	return EVT_HANDLED_ALL;
+}
+
+
+static enum event_result parse_tracepoint_event(const char **strp,
+				    struct perf_event_attr *attr)
+{
+	const char *evt_name;
+	char *flags;
+	char sys_name[MAX_EVENT_LENGTH];
+	unsigned int sys_length, evt_length;
+
+	if (debugfs_valid_mountpoint(debugfs_path))
+		return 0;
+
+	evt_name = strchr(*strp, ':');
+	if (!evt_name)
+		return EVT_FAILED;
+
+	sys_length = evt_name - *strp;
+	if (sys_length >= MAX_EVENT_LENGTH)
+		return 0;
+
+	strncpy(sys_name, *strp, sys_length);
+	sys_name[sys_length] = '\0';
+	evt_name = evt_name + 1;
+
+	flags = strchr(evt_name, ':');
+	if (flags) {
+		/* split it out: */
+		evt_name = strndup(evt_name, flags - evt_name);
+		flags++;
+	}
+
+	evt_length = strlen(evt_name);
+	if (evt_length >= MAX_EVENT_LENGTH)
+		return EVT_FAILED;
+
+	if (strpbrk(evt_name, "*?")) {
+		*strp = evt_name + evt_length;
+		return parse_multiple_tracepoint_event(sys_name, evt_name,
+						       flags);
+	} else
+		return parse_single_tracepoint_event(sys_name, evt_name,
+						     evt_length, attr, strp);
+}
+
+static enum event_result
+parse_breakpoint_type(const char *type, const char **strp,
+		      struct perf_event_attr *attr)
+{
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		if (!type[i])
+			break;
+
+		switch (type[i]) {
+		case 'r':
+			attr->bp_type |= HW_BREAKPOINT_R;
+			break;
+		case 'w':
+			attr->bp_type |= HW_BREAKPOINT_W;
+			break;
+		case 'x':
+			attr->bp_type |= HW_BREAKPOINT_X;
+			break;
+		default:
+			return EVT_FAILED;
+		}
+	}
+	if (!attr->bp_type) /* Default */
+		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
+
+	*strp = type + i;
+
+	return EVT_HANDLED;
+}
+
+static enum event_result
+parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
+{
+	const char *target;
+	const char *type;
+	char *endaddr;
+	u64 addr;
+	enum event_result err;
+
+	target = strchr(*strp, ':');
+	if (!target)
+		return EVT_FAILED;
+
+	if (strncmp(*strp, "mem", target - *strp) != 0)
+		return EVT_FAILED;
+
+	target++;
+
+	addr = strtoull(target, &endaddr, 0);
+	if (target == endaddr)
+		return EVT_FAILED;
+
+	attr->bp_addr = addr;
+	*strp = endaddr;
+
+	type = strchr(target, ':');
+
+	/* If no type is defined, just rw as default */
+	if (!type) {
+		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
+	} else {
+		err = parse_breakpoint_type(++type, strp, attr);
+		if (err == EVT_FAILED)
+			return EVT_FAILED;
+	}
+
+	/* We should find a nice way to override the access type */
+	attr->bp_len = HW_BREAKPOINT_LEN_4;
+	attr->type = PERF_TYPE_BREAKPOINT;
+
+	return EVT_HANDLED;
+}
+
+static int check_events(const char *str, unsigned int i)
+{
+	int n;
+
+	n = strlen(event_symbols[i].symbol);
+	if (!strncmp(str, event_symbols[i].symbol, n))
+		return n;
+
+	n = strlen(event_symbols[i].alias);
+	if (n)
+		if (!strncmp(str, event_symbols[i].alias, n))
+			return n;
+	return 0;
+}
+
+static enum event_result
+parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
+{
+	const char *str = *strp;
+	unsigned int i;
+	int n;
+
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		n = check_events(str, i);
+		if (n > 0) {
+			attr->type = event_symbols[i].type;
+			attr->config = event_symbols[i].config;
+			*strp = str + n;
+			return EVT_HANDLED;
+		}
+	}
+	return EVT_FAILED;
+}
+
+static enum event_result
+parse_raw_event(const char **strp, struct perf_event_attr *attr)
+{
+	const char *str = *strp;
+	u64 config;
+	int n;
+
+	if (*str != 'r')
+		return EVT_FAILED;
+	n = hex2u64(str + 1, &config);
+	if (n > 0) {
+		*strp = str + n + 1;
+		attr->type = PERF_TYPE_RAW;
+		attr->config = config;
+		return EVT_HANDLED;
+	}
+	return EVT_FAILED;
+}
+
+static enum event_result
+parse_numeric_event(const char **strp, struct perf_event_attr *attr)
+{
+	const char *str = *strp;
+	char *endp;
+	unsigned long type;
+	u64 config;
+
+	type = strtoul(str, &endp, 0);
+	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
+		str = endp + 1;
+		config = strtoul(str, &endp, 0);
+		if (endp > str) {
+			attr->type = type;
+			attr->config = config;
+			*strp = endp;
+			return EVT_HANDLED;
+		}
+	}
+	return EVT_FAILED;
+}
+
+static enum event_result
+parse_event_modifier(const char **strp, struct perf_event_attr *attr)
+{
+	const char *str = *strp;
+	int exclude = 0;
+	int eu = 0, ek = 0, eh = 0, precise = 0;
+
+	if (*str++ != ':')
+		return 0;
+	while (*str) {
+		if (*str == 'u') {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
+			eu = 0;
+		} else if (*str == 'k') {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
+			ek = 0;
+		} else if (*str == 'h') {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
+			eh = 0;
+		} else if (*str == 'p') {
+			precise++;
+		} else
+			break;
+
+		++str;
+	}
+	if (str >= *strp + 2) {
+		*strp = str;
+		attr->exclude_user   = eu;
+		attr->exclude_kernel = ek;
+		attr->exclude_hv     = eh;
+		attr->precise_ip     = precise;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Each event can have multiple symbolic names.
+ * Symbolic names are (almost) exactly matched.
+ */
+static enum event_result
+parse_event_symbols(const char **str, struct perf_event_attr *attr)
+{
+	enum event_result ret;
+
+	ret = parse_tracepoint_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_raw_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_numeric_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_symbolic_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_generic_hw_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_breakpoint_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
+	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
+	return EVT_FAILED;
+
+modifier:
+	parse_event_modifier(str, attr);
+
+	return ret;
+}
+
+static int store_event_type(const char *orgname)
+{
+	char filename[PATH_MAX], *c;
+	FILE *file;
+	int id, n;
+
+	sprintf(filename, "%s/", debugfs_path);
+	strncat(filename, orgname, strlen(orgname));
+	strcat(filename, "/id");
+
+	c = strchr(filename, ':');
+	if (c)
+		*c = '/';
+
+	file = fopen(filename, "r");
+	if (!file)
+		return 0;
+	n = fscanf(file, "%i", &id);
+	fclose(file);
+	if (n < 1) {
+		pr_err("cannot store event ID\n");
+		return -EINVAL;
+	}
+	return perf_header__push_event(id, orgname);
+}
+
+int parse_events(const struct option *opt __used, const char *str, int unset __used)
+{
+	struct perf_event_attr attr;
+	enum event_result ret;
+
+	if (strchr(str, ':'))
+		if (store_event_type(str) < 0)
+			return -1;
+
+	for (;;) {
+		if (nr_counters == MAX_COUNTERS)
+			return -1;
+
+		memset(&attr, 0, sizeof(attr));
+		ret = parse_event_symbols(&str, &attr);
+		if (ret == EVT_FAILED)
+			return -1;
+
+		if (!(*str == 0 || *str == ',' || isspace(*str)))
+			return -1;
+
+		if (ret != EVT_HANDLED_ALL) {
+			attrs[nr_counters] = attr;
+			nr_counters++;
+		}
+
+		if (*str == 0)
+			break;
+		if (*str == ',')
+			++str;
+		while (isspace(*str))
+			++str;
+	}
+
+	return 0;
+}
+
+int parse_filter(const struct option *opt __used, const char *str,
+		 int unset __used)
+{
+	int i = nr_counters - 1;
+	int len = strlen(str);
+
+	if (i < 0 || attrs[i].type != PERF_TYPE_TRACEPOINT) {
+		fprintf(stderr,
+			"-F option should follow a -e tracepoint option\n");
+		return -1;
+	}
+
+	filters[i] = malloc(len + 1);
+	if (!filters[i]) {
+		fprintf(stderr, "not enough memory to hold filter string\n");
+		return -1;
+	}
+	strcpy(filters[i], str);
+
+	return 0;
+}
+
+static const char * const event_type_descriptors[] = {
+	"Hardware event",
+	"Software event",
+	"Tracepoint event",
+	"Hardware cache event",
+	"Raw hardware event descriptor",
+	"Hardware breakpoint",
+};
+
+/*
+ * Print the events from <debugfs_mount_point>/tracing/events
+ */
+
+static void print_tracepoint_events(void)
+{
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
+
+	if (debugfs_valid_mountpoint(debugfs_path))
+		return;
+
+	sys_dir = opendir(debugfs_path);
+	if (!sys_dir)
+		return;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
+			continue;
+
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+			snprintf(evt_path, MAXPATHLEN, "%s:%s",
+				 sys_dirent.d_name, evt_dirent.d_name);
+			printf("  %-42s [%s]\n", evt_path,
+				event_type_descriptors[PERF_TYPE_TRACEPOINT]);
+		}
+		closedir(evt_dir);
+	}
+	closedir(sys_dir);
+}
+
+/*
+ * Print the help text for the event symbols:
+ */
+void print_events(void)
+{
+	struct event_symbol *syms = event_symbols;
+	unsigned int i, type, op, prev_type = -1;
+	char name[40];
+
+	printf("\n");
+	printf("List of pre-defined events (to be used in -e):\n");
+
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
+		type = syms->type;
+
+		if (type != prev_type)
+			printf("\n");
+
+		if (strlen(syms->alias))
+			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+		else
+			strcpy(name, syms->symbol);
+		printf("  %-42s [%s]\n", name,
+			event_type_descriptors[type]);
+
+		prev_type = type;
+	}
+
+	printf("\n");
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				printf("  %-42s [%s]\n",
+					event_cache_name(type, op, i),
+					event_type_descriptors[PERF_TYPE_HW_CACHE]);
+			}
+		}
+	}
+
+	printf("\n");
+	printf("  %-42s [%s]\n",
+		"rNNN (see 'perf list --help' on how to encode it)",
+	       event_type_descriptors[PERF_TYPE_RAW]);
+	printf("\n");
+
+	printf("  %-42s [%s]\n",
+			"mem:<addr>[:access]",
+			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
+	printf("\n");
+
+	print_tracepoint_events();
+
+	exit(129);
+}
diff --git a/tools/lib/perf/parse-events.h b/tools/lib/perf/parse-events.h
new file mode 100644
index 0000000..8c55d6c
--- /dev/null
+++ b/tools/lib/perf/parse-events.h
@@ -0,0 +1,38 @@
+#ifndef __PERF_PARSE_EVENTS_H
+#define __PERF_PARSE_EVENTS_H
+/*
+ * Parse symbolic events/counts passed in as options:
+ */
+#include "../../../include/linux/perf_event.h"
+#include <perf.h>
+
+struct option;
+
+struct tracepoint_path {
+	char *system;
+	char *name;
+	struct tracepoint_path *next;
+};
+
+extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+extern bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events);
+
+extern int			nr_counters;
+
+extern struct perf_event_attr attrs[MAX_COUNTERS];
+extern char *filters[MAX_COUNTERS];
+
+extern const char *event_name(int ctr);
+extern const char *__event_name(int type, u64 config);
+
+extern int parse_events(const struct option *opt, const char *str, int unset);
+extern int parse_filter(const struct option *opt, const char *str, int unset);
+
+#define EVENTS_HELP_MAX (128*1024)
+
+extern void print_events(void);
+
+extern int valid_debugfs_mount(const char *debugfs);
+
+
+#endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 65a8a7b..0a5b00f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -197,7 +197,7 @@ ifndef PERF_DEBUG
 endif
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS += -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -360,9 +360,7 @@ LIB_H += util/exec_cmd.h
 LIB_H += util/levenshtein.h
 LIB_H += util/map.h
 LIB_H += util/parse-options.h
-LIB_H += util/parse-events.h
 LIB_H += util/quote.h
-LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
 LIB_H += util/svghelper.h
@@ -387,7 +385,6 @@ LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
-LIB_OBJS += $(OUTPUT)util/parse-events.o
 LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
@@ -395,7 +392,6 @@ LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/pager.o
-LIB_OBJS += $(OUTPUT)util/header.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
 LIB_OBJS += $(OUTPUT)util/map.o
@@ -508,21 +504,6 @@ else
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
-ifdef NO_NEWT
-	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
-else
-	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
-	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
-		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
-		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
-	else
-		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
-		BASIC_CFLAGS += -I/usr/include/slang
-		EXTLIBS += -lnewt -lslang
-		LIB_OBJS += $(OUTPUT)util/newt.o
-	endif
-endif
-
 ifdef NO_LIBPERL
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 86db09e..4bda7d1 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -10,7 +10,7 @@
 #include "../perf.h"
 #include <lk/util.h>
 #include "../util/parse-options.h"
-#include "../util/header.h"
+#include <perf/header.h>
 #include "bench.h"
 
 #include <stdio.h>
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 04afd8a..a4d9620 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -20,7 +20,7 @@
 
 #include "util/event.h"
 #include "util/parse-options.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 3cac2d6..5fe42b6 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -10,7 +10,7 @@
 #include "perf.h"
 #include "util/cache.h"
 #include <lk/debug.h>
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/parse-options.h"
 #include <lk/strlist.h>
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index c9127a9..a6c3caa 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -10,6 +10,7 @@
 #include "perf.h"
 #include "util/session.h"
 #include <lk/debug.h>
+#include <perf/header.h>
 
 #include "util/parse-options.h"
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index a31c848..6003678 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -5,7 +5,7 @@
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/session.h"
 
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 173dd9f..1a110fa 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -5,7 +5,7 @@
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/session.h"
 
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index d88c696..c1a802b 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -10,7 +10,7 @@
 
 #include "perf.h"
 
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 #include "util/cache.h"
 
 int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 80327f1..dc229ab 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -5,7 +5,7 @@
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
+#include <perf/header.h>
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1dee3a0..34bc049 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -14,9 +14,9 @@
 #include "util/build-id.h"
 #include <lk/util.h>
 #include "util/parse-options.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/event.h"
 #include <lk/debug.h>
 #include "util/session.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 57fe707..266f721 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -20,11 +20,11 @@
 
 #include "perf.h"
 #include <lk/debug.h>
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 
 #include "util/thread.h"
 #include "util/sort.h"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6bbc31a..6af08bf 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -5,7 +5,7 @@
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/session.h"
 
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b4cc93e..56c47bc 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -41,10 +41,10 @@
 #include "builtin.h"
 #include <lk/util.h>
 #include "util/parse-options.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 #include "util/event.h"
 #include <lk/debug.h>
-#include "util/header.h"
+#include <perf/header.h>
 #include <lk/cpumap.h>
 #include "util/thread.h"
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 6e2dd8f..1699cf6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -25,9 +25,9 @@
 #include <lk/strlist.h>
 
 #include "perf.h"
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/parse-options.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 #include "util/event.h"
 #include "util/session.h"
 #include "util/svghelper.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e402ba4..e4a5783 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -27,7 +27,7 @@
 #include <lk/util.h>
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 #include <lk/cpumap.h>
 
 #include <lk/debug.h>
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index be67b73..6c3bc42 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -5,7 +5,7 @@
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
+#include <perf/header.h>
 #include "util/exec_cmd.h"
 #include "util/trace-event.h"
 #include "util/session.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 58c1a56..4d57b28 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,7 +14,7 @@
 #include "util/quote.h"
 #include "util/build-id.h"
 #include "util/run-command.h"
-#include "util/parse-events.h"
+#include <perf/parse-events.h>
 #include <lk/debugfs.h>
 #include <lk/config.h>
 #include <lk/debug.h>
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
deleted file mode 100644
index 2177cfb..0000000
--- a/tools/perf/util/header.c
+++ /dev/null
@@ -1,1199 +0,0 @@
-#define _FILE_OFFSET_BITS 64
-
-#include <sys/types.h>
-#include <byteswap.h>
-#include <unistd.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <linux/list.h>
-#include <linux/kernel.h>
-
-#include <lk/util.h>
-#include "header.h"
-#include "../perf.h"
-#include "trace-event.h"
-#include "session.h"
-#include "symbol.h"
-#include <lk/debug.h>
-
-static bool no_buildid_cache = false;
-
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
-static int event_count;
-static struct perf_trace_event_type *events;
-
-int perf_header__push_event(u64 id, const char *name)
-{
-	if (strlen(name) > MAX_EVENT_NAME)
-		pr_warning("Event %s will be truncated\n", name);
-
-	if (!events) {
-		events = malloc(sizeof(struct perf_trace_event_type));
-		if (events == NULL)
-			return -ENOMEM;
-	} else {
-		struct perf_trace_event_type *nevents;
-
-		nevents = realloc(events, (event_count + 1) * sizeof(*events));
-		if (nevents == NULL)
-			return -ENOMEM;
-		events = nevents;
-	}
-	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
-	events[event_count].event_id = id;
-	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
-	event_count++;
-	return 0;
-}
-
-char *perf_header__find_event(u64 id)
-{
-	int i;
-	for (i = 0 ; i < event_count; i++) {
-		if (events[i].event_id == id)
-			return events[i].name;
-	}
-	return NULL;
-}
-
-static const char *__perf_magic = "PERFFILE";
-
-#define PERF_MAGIC	(*(u64 *)__perf_magic)
-
-struct perf_file_attr {
-	struct perf_event_attr	attr;
-	struct perf_file_section	ids;
-};
-
-void perf_header__set_feat(struct perf_header *self, int feat)
-{
-	set_bit(feat, self->adds_features);
-}
-
-bool perf_header__has_feat(const struct perf_header *self, int feat)
-{
-	return test_bit(feat, self->adds_features);
-}
-
-static int do_write(int fd, const void *buf, size_t size)
-{
-	while (size) {
-		int ret = write(fd, buf, size);
-
-		if (ret < 0)
-			return -errno;
-
-		size -= ret;
-		buf += ret;
-	}
-
-	return 0;
-}
-
-#define NAME_ALIGN 64
-
-static int write_padded(int fd, const void *bf, size_t count,
-			size_t count_aligned)
-{
-	static const char zero_buf[NAME_ALIGN];
-	int err = do_write(fd, bf, count);
-
-	if (!err)
-		err = do_write(fd, zero_buf, count_aligned - count);
-
-	return err;
-}
-
-#define dsos__for_each_with_build_id(pos, head)	\
-	list_for_each_entry(pos, head, node)	\
-		if (!pos->has_build_id)		\
-			continue;		\
-		else
-
-static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
-				u16 misc, int fd)
-{
-	struct dso *pos;
-
-	dsos__for_each_with_build_id(pos, head) {
-		int err;
-		struct build_id_event b;
-		size_t len;
-
-		if (!pos->hit)
-			continue;
-		len = pos->long_name_len + 1;
-		len = ALIGN(len, NAME_ALIGN);
-		memset(&b, 0, sizeof(b));
-		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
-		b.pid = pid;
-		b.header.misc = misc;
-		b.header.size = sizeof(b) + len;
-		err = do_write(fd, &b, sizeof(b));
-		if (err < 0)
-			return err;
-		err = write_padded(fd, pos->long_name,
-				   pos->long_name_len + 1, len);
-		if (err < 0)
-			return err;
-	}
-
-	return 0;
-}
-
-static int machine__write_buildid_table(struct machine *self, int fd)
-{
-	int err;
-	u16 kmisc = PERF_RECORD_MISC_KERNEL,
-	    umisc = PERF_RECORD_MISC_USER;
-
-	if (!machine__is_host(self)) {
-		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-		umisc = PERF_RECORD_MISC_GUEST_USER;
-	}
-
-	err = __dsos__write_buildid_table(&self->kernel_dsos, self->pid,
-					  kmisc, fd);
-	if (err == 0)
-		err = __dsos__write_buildid_table(&self->user_dsos,
-						  self->pid, umisc, fd);
-	return err;
-}
-
-static int dsos__write_buildid_table(struct perf_header *header, int fd)
-{
-	struct perf_session *session = container_of(header,
-			struct perf_session, header);
-	struct rb_node *nd;
-	int err = machine__write_buildid_table(&session->host_machine, fd);
-
-	if (err)
-		return err;
-
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		err = machine__write_buildid_table(pos, fd);
-		if (err)
-			break;
-	}
-	return err;
-}
-
-int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms)
-{
-	const size_t size = PATH_MAX;
-	char *filename = malloc(size),
-	     *linkname = malloc(size), *targetname;
-	int len, err = -1;
-
-	if (filename == NULL || linkname == NULL)
-		goto out_free;
-
-	len = snprintf(filename, size, "%s%s%s",
-		       debugdir, is_kallsyms ? "/" : "", name);
-	if (mkdir_p(filename, 0755))
-		goto out_free;
-
-	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
-
-	if (access(filename, F_OK)) {
-		if (is_kallsyms) {
-			 if (copyfile("/proc/kallsyms", filename))
-				goto out_free;
-		} else if (link(name, filename) && copyfile(name, filename))
-			goto out_free;
-	}
-
-	len = snprintf(linkname, size, "%s/.build-id/%.2s",
-		       debugdir, sbuild_id);
-
-	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
-		goto out_free;
-
-	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
-	targetname = filename + strlen(debugdir) - 5;
-	memcpy(targetname, "../..", 5);
-
-	if (symlink(targetname, linkname) == 0)
-		err = 0;
-out_free:
-	free(filename);
-	free(linkname);
-	return err;
-}
-
-static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
-				 const char *name, const char *debugdir,
-				 bool is_kallsyms)
-{
-	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-	build_id__sprintf(build_id, build_id_size, sbuild_id);
-
-	return build_id_cache__add_s(sbuild_id, debugdir, name, is_kallsyms);
-}
-
-int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
-{
-	const size_t size = PATH_MAX;
-	char *filename = malloc(size),
-	     *linkname = malloc(size);
-	int err = -1;
-
-	if (filename == NULL || linkname == NULL)
-		goto out_free;
-
-	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
-		 debugdir, sbuild_id, sbuild_id + 2);
-
-	if (access(linkname, F_OK))
-		goto out_free;
-
-	if (readlink(linkname, filename, size) < 0)
-		goto out_free;
-
-	if (unlink(linkname))
-		goto out_free;
-
-	/*
-	 * Since the link is relative, we must make it absolute:
-	 */
-	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
-		 debugdir, sbuild_id, filename);
-
-	if (unlink(linkname))
-		goto out_free;
-
-	err = 0;
-out_free:
-	free(filename);
-	free(linkname);
-	return err;
-}
-
-static int dso__cache_build_id(struct dso *self, const char *debugdir)
-{
-	bool is_kallsyms = self->kernel && self->long_name[0] != '/';
-
-	return build_id_cache__add_b(self->build_id, sizeof(self->build_id),
-				     self->long_name, debugdir, is_kallsyms);
-}
-
-static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
-{
-	struct dso *pos;
-	int err = 0;
-
-	dsos__for_each_with_build_id(pos, head)
-		if (dso__cache_build_id(pos, debugdir))
-			err = -1;
-
-	return err;
-}
-
-static int machine__cache_build_ids(struct machine *self, const char *debugdir)
-{
-	int ret = __dsos__cache_build_ids(&self->kernel_dsos, debugdir);
-	ret |= __dsos__cache_build_ids(&self->user_dsos, debugdir);
-	return ret;
-}
-
-static int perf_session__cache_build_ids(struct perf_session *self)
-{
-	struct rb_node *nd;
-	int ret;
-	char debugdir[PATH_MAX];
-
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
-	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
-		return -1;
-
-	ret = machine__cache_build_ids(&self->host_machine, debugdir);
-
-	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__cache_build_ids(pos, debugdir);
-	}
-	return ret ? -1 : 0;
-}
-
-static bool machine__read_build_ids(struct machine *self, bool with_hits)
-{
-	bool ret = __dsos__read_build_ids(&self->kernel_dsos, with_hits);
-	ret |= __dsos__read_build_ids(&self->user_dsos, with_hits);
-	return ret;
-}
-
-static bool perf_session__read_build_ids(struct perf_session *self, bool with_hits)
-{
-	struct rb_node *nd;
-	bool ret = machine__read_build_ids(&self->host_machine, with_hits);
-
-	for (nd = rb_first(&self->machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__read_build_ids(pos, with_hits);
-	}
-
-	return ret;
-}
-
-static int perf_header__adds_write(struct perf_header *self, int fd)
-{
-	int nr_sections;
-	struct perf_session *session;
-	struct perf_file_section *feat_sec;
-	int sec_size;
-	u64 sec_start;
-	int idx = 0, err;
-
-	session = container_of(self, struct perf_session, header);
-	if (perf_session__read_build_ids(session, true))
-		perf_header__set_feat(self, HEADER_BUILD_ID);
-
-	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
-	if (!nr_sections)
-		return 0;
-
-	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
-	if (feat_sec == NULL)
-		return -ENOMEM;
-
-	sec_size = sizeof(*feat_sec) * nr_sections;
-
-	sec_start = self->data_offset + self->data_size;
-	lseek(fd, sec_start + sec_size, SEEK_SET);
-
-	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
-		struct perf_file_section *trace_sec;
-
-		trace_sec = &feat_sec[idx++];
-
-		/* Write trace info */
-		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
-		read_tracing_data(fd, attrs, nr_counters);
-		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
-	}
-
-	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
-		struct perf_file_section *buildid_sec;
-
-		buildid_sec = &feat_sec[idx++];
-
-		/* Write build-ids */
-		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		err = dsos__write_buildid_table(self, fd);
-		if (err < 0) {
-			pr_debug("failed to write buildid table\n");
-			goto out_free;
-		}
-		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
-					  buildid_sec->offset;
-		if (!no_buildid_cache)
-			perf_session__cache_build_ids(session);
-	}
-
-	lseek(fd, sec_start, SEEK_SET);
-	err = do_write(fd, feat_sec, sec_size);
-	if (err < 0)
-		pr_debug("failed to write feature section\n");
-out_free:
-	free(feat_sec);
-	return err;
-}
-
-int perf_header__write_pipe(int fd)
-{
-	struct perf_pipe_file_header f_header;
-	int err;
-
-	f_header = (struct perf_pipe_file_header){
-		.magic	   = PERF_MAGIC,
-		.size	   = sizeof(f_header),
-	};
-
-	err = do_write(fd, &f_header, sizeof(f_header));
-	if (err < 0) {
-		pr_debug("failed to write perf pipe header\n");
-		return err;
-	}
-
-	return 0;
-}
-
-int perf_header__write(struct perf_header *self, int fd, bool at_exit)
-{
-	struct perf_file_header f_header;
-	struct perf_file_attr   f_attr;
-	struct perf_header_attr	*attr;
-	int i, err;
-
-	lseek(fd, sizeof(f_header), SEEK_SET);
-
-	for (i = 0; i < self->attrs; i++) {
-		attr = self->attr[i];
-
-		attr->id_offset = lseek(fd, 0, SEEK_CUR);
-		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
-		if (err < 0) {
-			pr_debug("failed to write perf header\n");
-			return err;
-		}
-	}
-
-
-	self->attr_offset = lseek(fd, 0, SEEK_CUR);
-
-	for (i = 0; i < self->attrs; i++) {
-		attr = self->attr[i];
-
-		f_attr = (struct perf_file_attr){
-			.attr = attr->attr,
-			.ids  = {
-				.offset = attr->id_offset,
-				.size   = attr->ids * sizeof(u64),
-			}
-		};
-		err = do_write(fd, &f_attr, sizeof(f_attr));
-		if (err < 0) {
-			pr_debug("failed to write perf header attribute\n");
-			return err;
-		}
-	}
-
-	self->event_offset = lseek(fd, 0, SEEK_CUR);
-	self->event_size = event_count * sizeof(struct perf_trace_event_type);
-	if (events) {
-		err = do_write(fd, events, self->event_size);
-		if (err < 0) {
-			pr_debug("failed to write perf header events\n");
-			return err;
-		}
-	}
-
-	self->data_offset = lseek(fd, 0, SEEK_CUR);
-
-	if (at_exit) {
-		err = perf_header__adds_write(self, fd);
-		if (err < 0)
-			return err;
-	}
-
-	f_header = (struct perf_file_header){
-		.magic	   = PERF_MAGIC,
-		.size	   = sizeof(f_header),
-		.attr_size = sizeof(f_attr),
-		.attrs = {
-			.offset = self->attr_offset,
-			.size   = self->attrs * sizeof(f_attr),
-		},
-		.data = {
-			.offset = self->data_offset,
-			.size	= self->data_size,
-		},
-		.event_types = {
-			.offset = self->event_offset,
-			.size	= self->event_size,
-		},
-	};
-
-	memcpy(&f_header.adds_features, &self->adds_features, sizeof(self->adds_features));
-
-	lseek(fd, 0, SEEK_SET);
-	err = do_write(fd, &f_header, sizeof(f_header));
-	if (err < 0) {
-		pr_debug("failed to write perf header\n");
-		return err;
-	}
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
-
-	self->frozen = 1;
-	return 0;
-}
-
-static int perf_header__getbuffer64(struct perf_header *self,
-				    int fd, void *buf, size_t size)
-{
-	if (do_read(fd, buf, size) <= 0)
-		return -1;
-
-	if (self->needs_swap)
-		mem_bswap_64(buf, size);
-
-	return 0;
-}
-
-int perf_header__process_sections(struct perf_header *self, int fd,
-				  int (*process)(struct perf_file_section *self,
-						 struct perf_header *ph,
-						 int feat, int fd))
-{
-	struct perf_file_section *feat_sec;
-	int nr_sections;
-	int sec_size;
-	int idx = 0;
-	int err = -1, feat = 1;
-
-	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
-	if (!nr_sections)
-		return 0;
-
-	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
-	if (!feat_sec)
-		return -1;
-
-	sec_size = sizeof(*feat_sec) * nr_sections;
-
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
-
-	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
-		goto out_free;
-
-	err = 0;
-	while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
-		if (perf_header__has_feat(self, feat)) {
-			struct perf_file_section *sec = &feat_sec[idx++];
-
-			err = process(sec, self, feat, fd);
-			if (err < 0)
-				break;
-		}
-		++feat;
-	}
-out_free:
-	free(feat_sec);
-	return err;
-}
-
-int perf_file_header__read(struct perf_file_header *self,
-			   struct perf_header *ph, int fd)
-{
-	lseek(fd, 0, SEEK_SET);
-
-	if (do_read(fd, self, sizeof(*self)) <= 0 ||
-	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
-		return -1;
-
-	if (self->attr_size != sizeof(struct perf_file_attr)) {
-		u64 attr_size = bswap_64(self->attr_size);
-
-		if (attr_size != sizeof(struct perf_file_attr))
-			return -1;
-
-		mem_bswap_64(self, offsetof(struct perf_file_header,
-					    adds_features));
-		ph->needs_swap = true;
-	}
-
-	if (self->size != sizeof(*self)) {
-		/* Support the previous format */
-		if (self->size == offsetof(typeof(*self), adds_features))
-			bitmap_zero(self->adds_features, HEADER_FEAT_BITS);
-		else
-			return -1;
-	}
-
-	memcpy(&ph->adds_features, &self->adds_features,
-	       sizeof(ph->adds_features));
-	/*
-	 * FIXME: hack that assumes that if we need swap the perf.data file
-	 * may be coming from an arch with a different word-size, ergo different
-	 * DEFINE_BITMAP format, investigate more later, but for now its mostly
-	 * safe to assume that we have a build-id section. Trace files probably
-	 * have several other issues in this realm anyway...
-	 */
-	if (ph->needs_swap) {
-		memset(&ph->adds_features, 0, sizeof(ph->adds_features));
-		perf_header__set_feat(ph, HEADER_BUILD_ID);
-	}
-
-	ph->event_offset = self->event_types.offset;
-	ph->event_size   = self->event_types.size;
-	ph->data_offset  = self->data.offset;
-	ph->data_size	 = self->data.size;
-	return 0;
-}
-
-static int __event_process_build_id(struct build_id_event *bev,
-				    char *filename,
-				    struct perf_session *session)
-{
-	int err = -1;
-	struct list_head *head;
-	struct machine *machine;
-	u16 misc;
-	struct dso *dso;
-	enum dso_kernel_type dso_type;
-
-	machine = perf_session__findnew_machine(session, bev->pid);
-	if (!machine)
-		goto out;
-
-	misc = bev->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	switch (misc) {
-	case PERF_RECORD_MISC_KERNEL:
-		dso_type = DSO_TYPE_KERNEL;
-		head = &machine->kernel_dsos;
-		break;
-	case PERF_RECORD_MISC_GUEST_KERNEL:
-		dso_type = DSO_TYPE_GUEST_KERNEL;
-		head = &machine->kernel_dsos;
-		break;
-	case PERF_RECORD_MISC_USER:
-	case PERF_RECORD_MISC_GUEST_USER:
-		dso_type = DSO_TYPE_USER;
-		head = &machine->user_dsos;
-		break;
-	default:
-		goto out;
-	}
-
-	dso = __dsos__findnew(head, filename);
-	if (dso != NULL) {
-		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-		dso__set_build_id(dso, &bev->build_id);
-
-		if (filename[0] == '[')
-			dso->kernel = dso_type;
-
-		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
-				  sbuild_id);
-		pr_debug("build id event received for %s: %s\n",
-			 dso->long_name, sbuild_id);
-	}
-
-	err = 0;
-out:
-	return err;
-}
-
-static int perf_header__read_build_ids(struct perf_header *self,
-			int input, u64 offset, u64 size)
-{
-	struct perf_session *session = container_of(self,
-			struct perf_session, header);
-	struct build_id_event bev;
-	char filename[PATH_MAX];
-	u64 limit = offset + size;
-	int err = -1;
-
-	while (offset < limit) {
-		ssize_t len;
-
-		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
-			goto out;
-
-		if (self->needs_swap)
-			perf_event_header__bswap(&bev.header);
-
-		len = bev.header.size - sizeof(bev);
-		if (read(input, filename, len) != len)
-			goto out;
-
-		__event_process_build_id(&bev, filename, session);
-
-		offset += bev.header.size;
-	}
-	err = 0;
-out:
-	return err;
-}
-
-static int perf_file_section__process(struct perf_file_section *self,
-				      struct perf_header *ph,
-				      int feat, int fd)
-{
-	if (lseek(fd, self->offset, SEEK_SET) == (off_t)-1) {
-		pr_debug("Failed to lseek to %Ld offset for feature %d, "
-			 "continuing...\n", self->offset, feat);
-		return 0;
-	}
-
-	switch (feat) {
-	case HEADER_TRACE_INFO:
-		trace_report(fd, false);
-		break;
-
-	case HEADER_BUILD_ID:
-		if (perf_header__read_build_ids(ph, fd, self->offset, self->size))
-			pr_debug("Failed to read buildids, continuing...\n");
-		break;
-	default:
-		pr_debug("unknown feature %d, continuing...\n", feat);
-	}
-
-	return 0;
-}
-
-static int perf_file_header__read_pipe(struct perf_pipe_file_header *self,
-				       struct perf_header *ph, int fd,
-				       bool repipe)
-{
-	if (do_read(fd, self, sizeof(*self)) <= 0 ||
-	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
-		return -1;
-
-	if (repipe && do_write(STDOUT_FILENO, self, sizeof(*self)) < 0)
-		return -1;
-
-	if (self->size != sizeof(*self)) {
-		u64 size = bswap_64(self->size);
-
-		if (size != sizeof(*self))
-			return -1;
-
-		ph->needs_swap = true;
-	}
-
-	return 0;
-}
-
-static int perf_header__read_pipe(struct perf_session *session, int fd)
-{
-	struct perf_header *self = &session->header;
-	struct perf_pipe_file_header f_header;
-
-	if (perf_file_header__read_pipe(&f_header, self, fd,
-					session->repipe) < 0) {
-		pr_debug("incompatible file format\n");
-		return -EINVAL;
-	}
-
-	session->fd = fd;
-
-	return 0;
-}
-
-int perf_header__read(struct perf_session *session, int fd)
-{
-	struct perf_header *self = &session->header;
-	struct perf_file_header	f_header;
-	struct perf_file_attr	f_attr;
-	u64			f_id;
-	int nr_attrs, nr_ids, i, j;
-
-	if (session->fd_pipe)
-		return perf_header__read_pipe(session, fd);
-
-	if (perf_file_header__read(&f_header, self, fd) < 0) {
-		pr_debug("incompatible file format\n");
-		return -EINVAL;
-	}
-
-	nr_attrs = f_header.attrs.size / sizeof(f_attr);
-	lseek(fd, f_header.attrs.offset, SEEK_SET);
-
-	for (i = 0; i < nr_attrs; i++) {
-		struct perf_header_attr *attr;
-		off_t tmp;
-
-		if (perf_header__getbuffer64(self, fd, &f_attr, sizeof(f_attr)))
-			goto out_errno;
-
-		tmp = lseek(fd, 0, SEEK_CUR);
-
-		attr = perf_header_attr__new(&f_attr.attr);
-		if (attr == NULL)
-			 return -ENOMEM;
-
-		nr_ids = f_attr.ids.size / sizeof(u64);
-		lseek(fd, f_attr.ids.offset, SEEK_SET);
-
-		for (j = 0; j < nr_ids; j++) {
-			if (perf_header__getbuffer64(self, fd, &f_id, sizeof(f_id)))
-				goto out_errno;
-
-			if (perf_header_attr__add_id(attr, f_id) < 0) {
-				perf_header_attr__delete(attr);
-				return -ENOMEM;
-			}
-		}
-		if (perf_header__add_attr(self, attr) < 0) {
-			perf_header_attr__delete(attr);
-			return -ENOMEM;
-		}
-
-		lseek(fd, tmp, SEEK_SET);
-	}
-
-	if (f_header.event_types.size) {
-		lseek(fd, f_header.event_types.offset, SEEK_SET);
-		events = malloc(f_header.event_types.size);
-		if (events == NULL)
-			return -ENOMEM;
-		if (perf_header__getbuffer64(self, fd, events,
-					     f_header.event_types.size))
-			goto out_errno;
-		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
-	}
-
-	perf_header__process_sections(self, fd, perf_file_section__process);
-
-	lseek(fd, self->data_offset, SEEK_SET);
-
-	self->frozen = 1;
-	return 0;
-out_errno:
-	return -errno;
-}
-
-u64 perf_header__sample_type(struct perf_header *header)
-{
-	u64 type = 0;
-	int i;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-
-		if (!type)
-			type = attr->attr.sample_type;
-		else if (type != attr->attr.sample_type)
-			die("non matching sample_type");
-	}
-
-	return type;
-}
-
-struct perf_event_attr *
-perf_header__find_attr(u64 id, struct perf_header *header)
-{
-	int i;
-
-	/*
-	 * We set id to -1 if the data file doesn't contain sample
-	 * ids. Check for this and avoid walking through the entire
-	 * list of ids which may be large.
-	 */
-	if (id == -1ULL)
-		return NULL;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-		int j;
-
-		for (j = 0; j < attr->ids; j++) {
-			if (attr->id[j] == id)
-				return &attr->attr;
-		}
-	}
-
-	return NULL;
-}
-
-int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
-			   event__handler_t process,
-			   struct perf_session *session)
-{
-	event_t *ev;
-	size_t size;
-	int err;
-
-	size = sizeof(struct perf_event_attr);
-	size = ALIGN(size, sizeof(u64));
-	size += sizeof(struct perf_event_header);
-	size += ids * sizeof(u64);
-
-	ev = malloc(size);
-
-	ev->attr.attr = *attr;
-	memcpy(ev->attr.id, id, ids * sizeof(u64));
-
-	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
-	ev->attr.header.size = size;
-
-	err = process(ev, session);
-
-	free(ev);
-
-	return err;
-}
-
-int event__synthesize_attrs(struct perf_header *self,
-			    event__handler_t process,
-			    struct perf_session *session)
-{
-	struct perf_header_attr	*attr;
-	int i, err = 0;
-
-	for (i = 0; i < self->attrs; i++) {
-		attr = self->attr[i];
-
-		err = event__synthesize_attr(&attr->attr, attr->ids, attr->id,
-					     process, session);
-		if (err) {
-			pr_debug("failed to create perf header attribute\n");
-			return err;
-		}
-	}
-
-	return err;
-}
-
-int event__process_attr(event_t *self, struct perf_session *session)
-{
-	struct perf_header_attr *attr;
-	unsigned int i, ids, n_ids;
-
-	attr = perf_header_attr__new(&self->attr.attr);
-	if (attr == NULL)
-		return -ENOMEM;
-
-	ids = self->header.size;
-	ids -= (void *)&self->attr.id - (void *)self;
-	n_ids = ids / sizeof(u64);
-
-	for (i = 0; i < n_ids; i++) {
-		if (perf_header_attr__add_id(attr, self->attr.id[i]) < 0) {
-			perf_header_attr__delete(attr);
-			return -ENOMEM;
-		}
-	}
-
-	if (perf_header__add_attr(&session->header, attr) < 0) {
-		perf_header_attr__delete(attr);
-		return -ENOMEM;
-	}
-
-	perf_session__update_sample_type(session);
-
-	return 0;
-}
-
-int event__synthesize_event_type(u64 event_id, char *name,
-				 event__handler_t process,
-				 struct perf_session *session)
-{
-	event_t ev;
-	size_t size = 0;
-	int err = 0;
-
-	memset(&ev, 0, sizeof(ev));
-
-	ev.event_type.event_type.event_id = event_id;
-	memset(ev.event_type.event_type.name, 0, MAX_EVENT_NAME);
-	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
-
-	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
-	size = strlen(name);
-	size = ALIGN(size, sizeof(u64));
-	ev.event_type.header.size = sizeof(ev.event_type) -
-		(sizeof(ev.event_type.event_type.name) - size);
-
-	err = process(&ev, session);
-
-	return err;
-}
-
-int event__synthesize_event_types(event__handler_t process,
-				  struct perf_session *session)
-{
-	struct perf_trace_event_type *type;
-	int i, err = 0;
-
-	for (i = 0; i < event_count; i++) {
-		type = &events[i];
-
-		err = event__synthesize_event_type(type->event_id, type->name,
-						   process, session);
-		if (err) {
-			pr_debug("failed to create perf header event type\n");
-			return err;
-		}
-	}
-
-	return err;
-}
-
-int event__process_event_type(event_t *self,
-			      struct perf_session *session __unused)
-{
-	if (perf_header__push_event(self->event_type.event_type.event_id,
-				    self->event_type.event_type.name) < 0)
-		return -ENOMEM;
-
-	return 0;
-}
-
-int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
-				   int nb_events,
-				   event__handler_t process,
-				   struct perf_session *session __unused)
-{
-	event_t ev;
-	ssize_t size = 0, aligned_size = 0, padding;
-	int err = 0;
-
-	memset(&ev, 0, sizeof(ev));
-
-	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
-	size = read_tracing_data_size(fd, pattrs, nb_events);
-	if (size <= 0)
-		return size;
-	aligned_size = ALIGN(size, sizeof(u64));
-	padding = aligned_size - size;
-	ev.tracing_data.header.size = sizeof(ev.tracing_data);
-	ev.tracing_data.size = aligned_size;
-
-	process(&ev, session);
-
-	err = read_tracing_data(fd, pattrs, nb_events);
-	write_padded(fd, NULL, 0, padding);
-
-	return aligned_size;
-}
-
-int event__process_tracing_data(event_t *self,
-				struct perf_session *session)
-{
-	ssize_t size_read, padding, size = self->tracing_data.size;
-	off_t offset = lseek(session->fd, 0, SEEK_CUR);
-	char buf[BUFSIZ];
-
-	/* setup for reading amidst mmap */
-	lseek(session->fd, offset + sizeof(struct tracing_data_event),
-	      SEEK_SET);
-
-	size_read = trace_report(session->fd, session->repipe);
-
-	padding = ALIGN(size_read, sizeof(u64)) - size_read;
-
-	if (read(session->fd, buf, padding) < 0)
-		die("reading input file");
-	if (session->repipe) {
-		int retw = write(STDOUT_FILENO, buf, padding);
-		if (retw <= 0 || retw != padding)
-			die("repiping tracing data padding");
-	}
-
-	if (size_read + padding != size)
-		die("tracing data size mismatch");
-
-	return size_read + padding;
-}
-
-int event__synthesize_build_id(struct dso *pos, u16 misc,
-			       event__handler_t process,
-			       struct machine *machine,
-			       struct perf_session *session)
-{
-	event_t ev;
-	size_t len;
-	int err = 0;
-
-	if (!pos->hit)
-		return err;
-
-	memset(&ev, 0, sizeof(ev));
-
-	len = pos->long_name_len + 1;
-	len = ALIGN(len, NAME_ALIGN);
-	memcpy(&ev.build_id.build_id, pos->build_id, sizeof(pos->build_id));
-	ev.build_id.header.type = PERF_RECORD_HEADER_BUILD_ID;
-	ev.build_id.header.misc = misc;
-	ev.build_id.pid = machine->pid;
-	ev.build_id.header.size = sizeof(ev.build_id) + len;
-	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
-
-	err = process(&ev, session);
-
-	return err;
-}
-
-int event__process_build_id(event_t *self,
-			    struct perf_session *session)
-{
-	__event_process_build_id(&self->build_id,
-				 self->build_id.filename,
-				 session);
-	return 0;
-}
-
-void disable_buildid_cache(void)
-{
-	no_buildid_cache = true;
-}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
deleted file mode 100644
index fb6f0eb..0000000
--- a/tools/perf/util/header.h
+++ /dev/null
@@ -1,127 +0,0 @@
-#ifndef __PERF_HEADER_H
-#define __PERF_HEADER_H
-
-#include "../../../include/linux/perf_event.h"
-#include <sys/types.h>
-#include <stdbool.h>
-#include <lk/types.h>
-#include "event.h"
-
-#include <linux/bitmap.h>
-
-struct perf_header_attr {
-	struct perf_event_attr attr;
-	int ids, size;
-	u64 *id;
-	off_t id_offset;
-};
-
-enum {
-	HEADER_TRACE_INFO = 1,
-	HEADER_BUILD_ID,
-	HEADER_LAST_FEATURE,
-};
-
-#define HEADER_FEAT_BITS			256
-
-struct perf_file_section {
-	u64 offset;
-	u64 size;
-};
-
-struct perf_file_header {
-	u64				magic;
-	u64				size;
-	u64				attr_size;
-	struct perf_file_section	attrs;
-	struct perf_file_section	data;
-	struct perf_file_section	event_types;
-	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
-};
-
-struct perf_pipe_file_header {
-	u64				magic;
-	u64				size;
-};
-
-struct perf_header;
-
-int perf_file_header__read(struct perf_file_header *self,
-			   struct perf_header *ph, int fd);
-
-struct perf_header {
-	int			frozen;
-	int			attrs, size;
-	bool			needs_swap;
-	struct perf_header_attr **attr;
-	s64			attr_offset;
-	u64			data_offset;
-	u64			data_size;
-	u64			event_offset;
-	u64			event_size;
-	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
-};
-
-int perf_header__init(struct perf_header *self);
-void perf_header__exit(struct perf_header *self);
-
-int perf_header__read(struct perf_session *session, int fd);
-int perf_header__write(struct perf_header *self, int fd, bool at_exit);
-int perf_header__write_pipe(int fd);
-
-int perf_header__add_attr(struct perf_header *self,
-			  struct perf_header_attr *attr);
-
-int perf_header__push_event(u64 id, const char *name);
-char *perf_header__find_event(u64 id);
-
-struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
-void perf_header_attr__delete(struct perf_header_attr *self);
-
-int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
-
-u64 perf_header__sample_type(struct perf_header *header);
-struct perf_event_attr *
-perf_header__find_attr(u64 id, struct perf_header *header);
-void perf_header__set_feat(struct perf_header *self, int feat);
-bool perf_header__has_feat(const struct perf_header *self, int feat);
-
-int perf_header__process_sections(struct perf_header *self, int fd,
-				  int (*process)(struct perf_file_section *self,
-						 struct perf_header *ph,
-						 int feat, int fd));
-
-int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms);
-int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
-
-int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
-			   event__handler_t process,
-			   struct perf_session *session);
-int event__synthesize_attrs(struct perf_header *self,
-			    event__handler_t process,
-			    struct perf_session *session);
-int event__process_attr(event_t *self, struct perf_session *session);
-
-int event__synthesize_event_type(u64 event_id, char *name,
-				 event__handler_t process,
-				 struct perf_session *session);
-int event__synthesize_event_types(event__handler_t process,
-				  struct perf_session *session);
-int event__process_event_type(event_t *self,
-			      struct perf_session *session);
-
-int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
-				   int nb_events,
-				   event__handler_t process,
-				   struct perf_session *session);
-int event__process_tracing_data(event_t *self,
-				struct perf_session *session);
-
-int event__synthesize_build_id(struct dso *pos, u16 misc,
-			       event__handler_t process,
-			       struct machine *machine,
-			       struct perf_session *session);
-int event__process_build_id(event_t *self, struct perf_session *session);
-
-#endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
deleted file mode 100644
index 215d4f3..0000000
--- a/tools/perf/util/parse-events.c
+++ /dev/null
@@ -1,957 +0,0 @@
-#include "../../../include/linux/hw_breakpoint.h"
-#include <lk/util.h>
-#include <lk/debug.h>
-#include "../perf.h"
-#include "parse-options.h"
-#include "parse-events.h"
-#include "exec_cmd.h"
-#include "string.h"
-#include "symbol.h"
-#include "cache.h"
-#include "header.h"
-#include <lk/debugfs.h>
-
-int				nr_counters;
-
-struct perf_event_attr		attrs[MAX_COUNTERS];
-char				*filters[MAX_COUNTERS];
-
-struct event_symbol {
-	u8		type;
-	u64		config;
-	const char	*symbol;
-	const char	*alias;
-};
-
-enum event_result {
-	EVT_FAILED,
-	EVT_HANDLED,
-	EVT_HANDLED_ALL
-};
-
-#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
-#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
-
-static struct event_symbol event_symbols[] = {
-  { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
-  { CHW(INSTRUCTIONS),		"instructions",		""		},
-  { CHW(CACHE_REFERENCES),	"cache-references",	""		},
-  { CHW(CACHE_MISSES),		"cache-misses",		""		},
-  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
-  { CHW(BRANCH_MISSES),		"branch-misses",	""		},
-  { CHW(BUS_CYCLES),		"bus-cycles",		""		},
-
-  { CSW(CPU_CLOCK),		"cpu-clock",		""		},
-  { CSW(TASK_CLOCK),		"task-clock",		""		},
-  { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
-  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
-  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
-  { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
-  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
-  { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
-  { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
-};
-
-#define __PERF_EVENT_FIELD(config, name) \
-	((config & PERF_EVENT_##name##_MASK) >> PERF_EVENT_##name##_SHIFT)
-
-#define PERF_EVENT_RAW(config)	__PERF_EVENT_FIELD(config, RAW)
-#define PERF_EVENT_CONFIG(config)	__PERF_EVENT_FIELD(config, CONFIG)
-#define PERF_EVENT_TYPE(config)	__PERF_EVENT_FIELD(config, TYPE)
-#define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
-
-static const char *hw_event_names[] = {
-	"cycles",
-	"instructions",
-	"cache-references",
-	"cache-misses",
-	"branches",
-	"branch-misses",
-	"bus-cycles",
-};
-
-static const char *sw_event_names[] = {
-	"cpu-clock-msecs",
-	"task-clock-msecs",
-	"page-faults",
-	"context-switches",
-	"CPU-migrations",
-	"minor-faults",
-	"major-faults",
-	"alignment-faults",
-	"emulation-faults",
-};
-
-#define MAX_ALIASES 8
-
-static const char *hw_cache[][MAX_ALIASES] = {
- { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
- { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
- { "LLC",	"L2"							},
- { "dTLB",	"d-tlb",	"Data-TLB",				},
- { "iTLB",	"i-tlb",	"Instruction-TLB",			},
- { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
-};
-
-static const char *hw_cache_op[][MAX_ALIASES] = {
- { "load",	"loads",	"read",					},
- { "store",	"stores",	"write",				},
- { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
-};
-
-static const char *hw_cache_result[][MAX_ALIASES] = {
- { "refs",	"Reference",	"ops",		"access",		},
- { "misses",	"miss",							},
-};
-
-#define C(x)		PERF_COUNT_HW_CACHE_##x
-#define CACHE_READ	(1 << C(OP_READ))
-#define CACHE_WRITE	(1 << C(OP_WRITE))
-#define CACHE_PREFETCH	(1 << C(OP_PREFETCH))
-#define COP(x)		(1 << x)
-
-/*
- * cache operartion stat
- * L1I : Read and prefetch only
- * ITLB and BPU : Read-only
- */
-static unsigned long hw_cache_stat[C(MAX)] = {
- [C(L1D)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
- [C(L1I)]	= (CACHE_READ | CACHE_PREFETCH),
- [C(LL)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
- [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
- [C(ITLB)]	= (CACHE_READ),
- [C(BPU)]	= (CACHE_READ),
-};
-
-#define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
-	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
-	if (sys_dirent.d_type == DT_DIR &&				       \
-	   (strcmp(sys_dirent.d_name, ".")) &&				       \
-	   (strcmp(sys_dirent.d_name, "..")))
-
-static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
-{
-	char evt_path[MAXPATHLEN];
-	int fd;
-
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
-			sys_dir->d_name, evt_dir->d_name);
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return -EINVAL;
-	close(fd);
-
-	return 0;
-}
-
-#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)	       \
-	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
-	if (evt_dirent.d_type == DT_DIR &&				       \
-	   (strcmp(evt_dirent.d_name, ".")) &&				       \
-	   (strcmp(evt_dirent.d_name, "..")) &&				       \
-	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
-
-#define MAX_EVENT_LENGTH 512
-
-
-struct tracepoint_path *tracepoint_id_to_path(u64 config)
-{
-	struct tracepoint_path *path = NULL;
-	DIR *sys_dir, *evt_dir;
-	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	char id_buf[4];
-	int fd;
-	u64 id;
-	char evt_path[MAXPATHLEN];
-	char dir_path[MAXPATHLEN];
-
-	if (debugfs_valid_mountpoint(debugfs_path))
-		return NULL;
-
-	sys_dir = opendir(debugfs_path);
-	if (!sys_dir)
-		return NULL;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-
-		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
-			 sys_dirent.d_name);
-		evt_dir = opendir(dir_path);
-		if (!evt_dir)
-			continue;
-
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-
-			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
-				 evt_dirent.d_name);
-			fd = open(evt_path, O_RDONLY);
-			if (fd < 0)
-				continue;
-			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-				close(fd);
-				continue;
-			}
-			close(fd);
-			id = atoll(id_buf);
-			if (id == config) {
-				closedir(evt_dir);
-				closedir(sys_dir);
-				path = zalloc(sizeof(*path));
-				path->system = malloc(MAX_EVENT_LENGTH);
-				if (!path->system) {
-					free(path);
-					return NULL;
-				}
-				path->name = malloc(MAX_EVENT_LENGTH);
-				if (!path->name) {
-					free(path->system);
-					free(path);
-					return NULL;
-				}
-				strncpy(path->system, sys_dirent.d_name,
-					MAX_EVENT_LENGTH);
-				strncpy(path->name, evt_dirent.d_name,
-					MAX_EVENT_LENGTH);
-				return path;
-			}
-		}
-		closedir(evt_dir);
-	}
-
-	closedir(sys_dir);
-	return NULL;
-}
-
-#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
-static const char *tracepoint_id_to_name(u64 config)
-{
-	static char buf[TP_PATH_LEN];
-	struct tracepoint_path *path;
-
-	path = tracepoint_id_to_path(config);
-	if (path) {
-		snprintf(buf, TP_PATH_LEN, "%s:%s", path->system, path->name);
-		free(path->name);
-		free(path->system);
-		free(path);
-	} else
-		snprintf(buf, TP_PATH_LEN, "%s:%s", "unknown", "unknown");
-
-	return buf;
-}
-
-static int is_cache_op_valid(u8 cache_type, u8 cache_op)
-{
-	if (hw_cache_stat[cache_type] & COP(cache_op))
-		return 1;	/* valid */
-	else
-		return 0;	/* invalid */
-}
-
-static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
-{
-	static char name[50];
-
-	if (cache_result) {
-		sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
-			hw_cache_op[cache_op][0],
-			hw_cache_result[cache_result][0]);
-	} else {
-		sprintf(name, "%s-%s", hw_cache[cache_type][0],
-			hw_cache_op[cache_op][1]);
-	}
-
-	return name;
-}
-
-const char *event_name(int counter)
-{
-	u64 config = attrs[counter].config;
-	int type = attrs[counter].type;
-
-	return __event_name(type, config);
-}
-
-const char *__event_name(int type, u64 config)
-{
-	static char buf[32];
-
-	if (type == PERF_TYPE_RAW) {
-		sprintf(buf, "raw 0x%llx", config);
-		return buf;
-	}
-
-	switch (type) {
-	case PERF_TYPE_HARDWARE:
-		if (config < PERF_COUNT_HW_MAX)
-			return hw_event_names[config];
-		return "unknown-hardware";
-
-	case PERF_TYPE_HW_CACHE: {
-		u8 cache_type, cache_op, cache_result;
-
-		cache_type   = (config >>  0) & 0xff;
-		if (cache_type > PERF_COUNT_HW_CACHE_MAX)
-			return "unknown-ext-hardware-cache-type";
-
-		cache_op     = (config >>  8) & 0xff;
-		if (cache_op > PERF_COUNT_HW_CACHE_OP_MAX)
-			return "unknown-ext-hardware-cache-op";
-
-		cache_result = (config >> 16) & 0xff;
-		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
-			return "unknown-ext-hardware-cache-result";
-
-		if (!is_cache_op_valid(cache_type, cache_op))
-			return "invalid-cache";
-
-		return event_cache_name(cache_type, cache_op, cache_result);
-	}
-
-	case PERF_TYPE_SOFTWARE:
-		if (config < PERF_COUNT_SW_MAX)
-			return sw_event_names[config];
-		return "unknown-software";
-
-	case PERF_TYPE_TRACEPOINT:
-		return tracepoint_id_to_name(config);
-
-	default:
-		break;
-	}
-
-	return "unknown";
-}
-
-static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
-{
-	int i, j;
-	int n, longest = -1;
-
-	for (i = 0; i < size; i++) {
-		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
-			n = strlen(names[i][j]);
-			if (n > longest && !strncasecmp(*str, names[i][j], n))
-				longest = n;
-		}
-		if (longest > 0) {
-			*str += longest;
-			return i;
-		}
-	}
-
-	return -1;
-}
-
-static enum event_result
-parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
-{
-	const char *s = *str;
-	int cache_type = -1, cache_op = -1, cache_result = -1;
-
-	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
-	/*
-	 * No fallback - if we cannot get a clear cache type
-	 * then bail out:
-	 */
-	if (cache_type == -1)
-		return EVT_FAILED;
-
-	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
-		++s;
-
-		if (cache_op == -1) {
-			cache_op = parse_aliases(&s, hw_cache_op,
-						PERF_COUNT_HW_CACHE_OP_MAX);
-			if (cache_op >= 0) {
-				if (!is_cache_op_valid(cache_type, cache_op))
-					return 0;
-				continue;
-			}
-		}
-
-		if (cache_result == -1) {
-			cache_result = parse_aliases(&s, hw_cache_result,
-						PERF_COUNT_HW_CACHE_RESULT_MAX);
-			if (cache_result >= 0)
-				continue;
-		}
-
-		/*
-		 * Can't parse this as a cache op or result, so back up
-		 * to the '-'.
-		 */
-		--s;
-		break;
-	}
-
-	/*
-	 * Fall back to reads:
-	 */
-	if (cache_op == -1)
-		cache_op = PERF_COUNT_HW_CACHE_OP_READ;
-
-	/*
-	 * Fall back to accesses:
-	 */
-	if (cache_result == -1)
-		cache_result = PERF_COUNT_HW_CACHE_RESULT_ACCESS;
-
-	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
-	attr->type = PERF_TYPE_HW_CACHE;
-
-	*str = s;
-	return EVT_HANDLED;
-}
-
-static enum event_result
-parse_single_tracepoint_event(char *sys_name,
-			      const char *evt_name,
-			      unsigned int evt_length,
-			      struct perf_event_attr *attr,
-			      const char **strp)
-{
-	char evt_path[MAXPATHLEN];
-	char id_buf[4];
-	u64 id;
-	int fd;
-
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
-		 sys_name, evt_name);
-
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return EVT_FAILED;
-
-	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-		close(fd);
-		return EVT_FAILED;
-	}
-
-	close(fd);
-	id = atoll(id_buf);
-	attr->config = id;
-	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp = evt_name + evt_length;
-
-	attr->sample_type |= PERF_SAMPLE_RAW;
-	attr->sample_type |= PERF_SAMPLE_TIME;
-	attr->sample_type |= PERF_SAMPLE_CPU;
-
-	attr->sample_period = 1;
-
-
-	return EVT_HANDLED;
-}
-
-/* sys + ':' + event + ':' + flags*/
-#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
-static enum event_result
-parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
-				char *flags)
-{
-	char evt_path[MAXPATHLEN];
-	struct dirent *evt_ent;
-	DIR *evt_dir;
-
-	snprintf(evt_path, MAXPATHLEN, "%s/%s", debugfs_path, sys_name);
-	evt_dir = opendir(evt_path);
-
-	if (!evt_dir) {
-		perror("Can't open event dir");
-		return EVT_FAILED;
-	}
-
-	while ((evt_ent = readdir(evt_dir))) {
-		char event_opt[MAX_EVOPT_LEN + 1];
-		int len;
-
-		if (!strcmp(evt_ent->d_name, ".")
-		    || !strcmp(evt_ent->d_name, "..")
-		    || !strcmp(evt_ent->d_name, "enable")
-		    || !strcmp(evt_ent->d_name, "filter"))
-			continue;
-
-		if (!strglobmatch(evt_ent->d_name, evt_exp))
-			continue;
-
-		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
-			       evt_ent->d_name, flags ? ":" : "",
-			       flags ?: "");
-		if (len < 0)
-			return EVT_FAILED;
-
-		if (parse_events(NULL, event_opt, 0))
-			return EVT_FAILED;
-	}
-
-	return EVT_HANDLED_ALL;
-}
-
-
-static enum event_result parse_tracepoint_event(const char **strp,
-				    struct perf_event_attr *attr)
-{
-	const char *evt_name;
-	char *flags;
-	char sys_name[MAX_EVENT_LENGTH];
-	unsigned int sys_length, evt_length;
-
-	if (debugfs_valid_mountpoint(debugfs_path))
-		return 0;
-
-	evt_name = strchr(*strp, ':');
-	if (!evt_name)
-		return EVT_FAILED;
-
-	sys_length = evt_name - *strp;
-	if (sys_length >= MAX_EVENT_LENGTH)
-		return 0;
-
-	strncpy(sys_name, *strp, sys_length);
-	sys_name[sys_length] = '\0';
-	evt_name = evt_name + 1;
-
-	flags = strchr(evt_name, ':');
-	if (flags) {
-		/* split it out: */
-		evt_name = strndup(evt_name, flags - evt_name);
-		flags++;
-	}
-
-	evt_length = strlen(evt_name);
-	if (evt_length >= MAX_EVENT_LENGTH)
-		return EVT_FAILED;
-
-	if (strpbrk(evt_name, "*?")) {
-		*strp = evt_name + evt_length;
-		return parse_multiple_tracepoint_event(sys_name, evt_name,
-						       flags);
-	} else
-		return parse_single_tracepoint_event(sys_name, evt_name,
-						     evt_length, attr, strp);
-}
-
-static enum event_result
-parse_breakpoint_type(const char *type, const char **strp,
-		      struct perf_event_attr *attr)
-{
-	int i;
-
-	for (i = 0; i < 3; i++) {
-		if (!type[i])
-			break;
-
-		switch (type[i]) {
-		case 'r':
-			attr->bp_type |= HW_BREAKPOINT_R;
-			break;
-		case 'w':
-			attr->bp_type |= HW_BREAKPOINT_W;
-			break;
-		case 'x':
-			attr->bp_type |= HW_BREAKPOINT_X;
-			break;
-		default:
-			return EVT_FAILED;
-		}
-	}
-	if (!attr->bp_type) /* Default */
-		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
-
-	*strp = type + i;
-
-	return EVT_HANDLED;
-}
-
-static enum event_result
-parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
-{
-	const char *target;
-	const char *type;
-	char *endaddr;
-	u64 addr;
-	enum event_result err;
-
-	target = strchr(*strp, ':');
-	if (!target)
-		return EVT_FAILED;
-
-	if (strncmp(*strp, "mem", target - *strp) != 0)
-		return EVT_FAILED;
-
-	target++;
-
-	addr = strtoull(target, &endaddr, 0);
-	if (target == endaddr)
-		return EVT_FAILED;
-
-	attr->bp_addr = addr;
-	*strp = endaddr;
-
-	type = strchr(target, ':');
-
-	/* If no type is defined, just rw as default */
-	if (!type) {
-		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
-	} else {
-		err = parse_breakpoint_type(++type, strp, attr);
-		if (err == EVT_FAILED)
-			return EVT_FAILED;
-	}
-
-	/* We should find a nice way to override the access type */
-	attr->bp_len = HW_BREAKPOINT_LEN_4;
-	attr->type = PERF_TYPE_BREAKPOINT;
-
-	return EVT_HANDLED;
-}
-
-static int check_events(const char *str, unsigned int i)
-{
-	int n;
-
-	n = strlen(event_symbols[i].symbol);
-	if (!strncmp(str, event_symbols[i].symbol, n))
-		return n;
-
-	n = strlen(event_symbols[i].alias);
-	if (n)
-		if (!strncmp(str, event_symbols[i].alias, n))
-			return n;
-	return 0;
-}
-
-static enum event_result
-parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
-{
-	const char *str = *strp;
-	unsigned int i;
-	int n;
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		n = check_events(str, i);
-		if (n > 0) {
-			attr->type = event_symbols[i].type;
-			attr->config = event_symbols[i].config;
-			*strp = str + n;
-			return EVT_HANDLED;
-		}
-	}
-	return EVT_FAILED;
-}
-
-static enum event_result
-parse_raw_event(const char **strp, struct perf_event_attr *attr)
-{
-	const char *str = *strp;
-	u64 config;
-	int n;
-
-	if (*str != 'r')
-		return EVT_FAILED;
-	n = hex2u64(str + 1, &config);
-	if (n > 0) {
-		*strp = str + n + 1;
-		attr->type = PERF_TYPE_RAW;
-		attr->config = config;
-		return EVT_HANDLED;
-	}
-	return EVT_FAILED;
-}
-
-static enum event_result
-parse_numeric_event(const char **strp, struct perf_event_attr *attr)
-{
-	const char *str = *strp;
-	char *endp;
-	unsigned long type;
-	u64 config;
-
-	type = strtoul(str, &endp, 0);
-	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
-		str = endp + 1;
-		config = strtoul(str, &endp, 0);
-		if (endp > str) {
-			attr->type = type;
-			attr->config = config;
-			*strp = endp;
-			return EVT_HANDLED;
-		}
-	}
-	return EVT_FAILED;
-}
-
-static enum event_result
-parse_event_modifier(const char **strp, struct perf_event_attr *attr)
-{
-	const char *str = *strp;
-	int exclude = 0;
-	int eu = 0, ek = 0, eh = 0, precise = 0;
-
-	if (*str++ != ':')
-		return 0;
-	while (*str) {
-		if (*str == 'u') {
-			if (!exclude)
-				exclude = eu = ek = eh = 1;
-			eu = 0;
-		} else if (*str == 'k') {
-			if (!exclude)
-				exclude = eu = ek = eh = 1;
-			ek = 0;
-		} else if (*str == 'h') {
-			if (!exclude)
-				exclude = eu = ek = eh = 1;
-			eh = 0;
-		} else if (*str == 'p') {
-			precise++;
-		} else
-			break;
-
-		++str;
-	}
-	if (str >= *strp + 2) {
-		*strp = str;
-		attr->exclude_user   = eu;
-		attr->exclude_kernel = ek;
-		attr->exclude_hv     = eh;
-		attr->precise_ip     = precise;
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static enum event_result
-parse_event_symbols(const char **str, struct perf_event_attr *attr)
-{
-	enum event_result ret;
-
-	ret = parse_tracepoint_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	ret = parse_raw_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	ret = parse_numeric_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	ret = parse_symbolic_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	ret = parse_generic_hw_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	ret = parse_breakpoint_event(str, attr);
-	if (ret != EVT_FAILED)
-		goto modifier;
-
-	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
-	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
-	return EVT_FAILED;
-
-modifier:
-	parse_event_modifier(str, attr);
-
-	return ret;
-}
-
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
-int parse_events(const struct option *opt __used, const char *str, int unset __used)
-{
-	struct perf_event_attr attr;
-	enum event_result ret;
-
-	if (strchr(str, ':'))
-		if (store_event_type(str) < 0)
-			return -1;
-
-	for (;;) {
-		if (nr_counters == MAX_COUNTERS)
-			return -1;
-
-		memset(&attr, 0, sizeof(attr));
-		ret = parse_event_symbols(&str, &attr);
-		if (ret == EVT_FAILED)
-			return -1;
-
-		if (!(*str == 0 || *str == ',' || isspace(*str)))
-			return -1;
-
-		if (ret != EVT_HANDLED_ALL) {
-			attrs[nr_counters] = attr;
-			nr_counters++;
-		}
-
-		if (*str == 0)
-			break;
-		if (*str == ',')
-			++str;
-		while (isspace(*str))
-			++str;
-	}
-
-	return 0;
-}
-
-int parse_filter(const struct option *opt __used, const char *str,
-		 int unset __used)
-{
-	int i = nr_counters - 1;
-	int len = strlen(str);
-
-	if (i < 0 || attrs[i].type != PERF_TYPE_TRACEPOINT) {
-		fprintf(stderr,
-			"-F option should follow a -e tracepoint option\n");
-		return -1;
-	}
-
-	filters[i] = malloc(len + 1);
-	if (!filters[i]) {
-		fprintf(stderr, "not enough memory to hold filter string\n");
-		return -1;
-	}
-	strcpy(filters[i], str);
-
-	return 0;
-}
-
-static const char * const event_type_descriptors[] = {
-	"Hardware event",
-	"Software event",
-	"Tracepoint event",
-	"Hardware cache event",
-	"Raw hardware event descriptor",
-	"Hardware breakpoint",
-};
-
-/*
- * Print the events from <debugfs_mount_point>/tracing/events
- */
-
-static void print_tracepoint_events(void)
-{
-	DIR *sys_dir, *evt_dir;
-	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	char evt_path[MAXPATHLEN];
-	char dir_path[MAXPATHLEN];
-
-	if (debugfs_valid_mountpoint(debugfs_path))
-		return;
-
-	sys_dir = opendir(debugfs_path);
-	if (!sys_dir)
-		return;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-
-		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
-			 sys_dirent.d_name);
-		evt_dir = opendir(dir_path);
-		if (!evt_dir)
-			continue;
-
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-			snprintf(evt_path, MAXPATHLEN, "%s:%s",
-				 sys_dirent.d_name, evt_dirent.d_name);
-			printf("  %-42s [%s]\n", evt_path,
-				event_type_descriptors[PERF_TYPE_TRACEPOINT]);
-		}
-		closedir(evt_dir);
-	}
-	closedir(sys_dir);
-}
-
-/*
- * Print the help text for the event symbols:
- */
-void print_events(void)
-{
-	struct event_symbol *syms = event_symbols;
-	unsigned int i, type, op, prev_type = -1;
-	char name[40];
-
-	printf("\n");
-	printf("List of pre-defined events (to be used in -e):\n");
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
-		type = syms->type;
-
-		if (type != prev_type)
-			printf("\n");
-
-		if (strlen(syms->alias))
-			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
-		else
-			strcpy(name, syms->symbol);
-		printf("  %-42s [%s]\n", name,
-			event_type_descriptors[type]);
-
-		prev_type = type;
-	}
-
-	printf("\n");
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				printf("  %-42s [%s]\n",
-					event_cache_name(type, op, i),
-					event_type_descriptors[PERF_TYPE_HW_CACHE]);
-			}
-		}
-	}
-
-	printf("\n");
-	printf("  %-42s [%s]\n",
-		"rNNN (see 'perf list --help' on how to encode it)",
-	       event_type_descriptors[PERF_TYPE_RAW]);
-	printf("\n");
-
-	printf("  %-42s [%s]\n",
-			"mem:<addr>[:access]",
-			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
-	printf("\n");
-
-	print_tracepoint_events();
-
-	exit(129);
-}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
deleted file mode 100644
index 436c831..0000000
--- a/tools/perf/util/parse-events.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef __PERF_PARSE_EVENTS_H
-#define __PERF_PARSE_EVENTS_H
-/*
- * Parse symbolic events/counts passed in as options:
- */
-
-struct option;
-
-struct tracepoint_path {
-	char *system;
-	char *name;
-	struct tracepoint_path *next;
-};
-
-extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
-extern bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events);
-
-extern int			nr_counters;
-
-extern struct perf_event_attr attrs[MAX_COUNTERS];
-extern char *filters[MAX_COUNTERS];
-
-extern const char *event_name(int ctr);
-extern const char *__event_name(int type, u64 config);
-
-extern int parse_events(const struct option *opt, const char *str, int unset);
-extern int parse_filter(const struct option *opt, const char *str, int unset);
-
-#define EVENTS_HELP_MAX (128*1024)
-
-extern void print_events(void);
-
-extern int valid_debugfs_mount(const char *debugfs);
-
-
-#endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 55c6881..bf3b5c4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -3,16 +3,31 @@
 
 #include "hist.h"
 #include "event.h"
-#include "header.h"
 #include "symbol.h"
 #include "thread.h"
+#include <linux/bitops.h>
 #include <linux/rbtree.h>
 #include "../../../include/linux/perf_event.h"
 
+#define HEADER_FEAT_BITS			256
+
 struct sample_queue;
 struct ip_callchain;
 struct thread;
 
+struct perf_header {
+	int			frozen;
+	int			attrs, size;
+	bool			needs_swap;
+	struct perf_header_attr **attr;
+	s64			attr_offset;
+	u64			data_offset;
+	u64			data_size;
+	u64			event_offset;
+	u64			event_size;
+	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+};
+
 struct ordered_samples {
 	u64			last_flush;
 	u64			next_flush;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 7a266b8..0d6ed4c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -16,10 +16,10 @@
 
 #include "../perf.h"
 #include <lk/debug.h>
-#include "header.h"
+#include <perf/header.h>
 
 #include "parse-options.h"
-#include "parse-events.h"
+#include <perf/parse-events.h>
 
 #include "thread.h"
 #include "sort.h"
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b3e86b1..428383b 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -2,7 +2,7 @@
 #define __PERF_TRACE_EVENTS_H
 
 #include <stdbool.h>
-#include "parse-events.h"
+#include <perf/parse-events.h>
 
 #define __unused __attribute__((unused))
 
-- 
1.7.1

