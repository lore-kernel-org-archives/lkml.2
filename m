Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab1LFKdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:18 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:25447
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933279Ab1LFKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:14 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVS2N6-01-BO3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/10] perf tool: Moving code in some files
Date: Tue, 6 Dec 2011 11:32:35 +0100
Message-ID: <1323167560-2282-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for later changes. No modified functionality.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-buildid-list.c |   36 ++--
 tools/perf/util/header.c          |  495 ++++++++++++++++++-------------------
 2 files changed, 264 insertions(+), 267 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index cb690a6..4895668 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -39,24 +39,6 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static int perf_session__list_build_ids(void)
-{
-	struct perf_session *session;
-
-	session = perf_session__new(input_name, O_RDONLY, force, false,
-				    &build_id__mark_dso_hit_ops);
-	if (session == NULL)
-		return -1;
-
-	if (with_hits)
-		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
-
-	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
-
-	perf_session__delete(session);
-	return 0;
-}
-
 static int sysfs__fprintf_build_id(FILE *fp)
 {
 	u8 kallsyms_build_id[BUILD_ID_SIZE];
@@ -85,6 +67,24 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	return fprintf(fp, "%s\n", sbuild_id);
 }
 
+static int perf_session__list_build_ids(void)
+{
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, O_RDONLY, force, false,
+				    &build_id__mark_dso_hit_ops);
+	if (session == NULL)
+		return -1;
+
+	if (with_hits)
+		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
+
+	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
+
+	perf_session__delete(session);
+	return 0;
+}
+
 static int __cmd_buildid_list(void)
 {
 	if (show_kernel)
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 95c3ab1..dda3c5f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -28,9 +28,6 @@ static struct perf_trace_event_type *events;
 static u32 header_argc;
 static const char **header_argv;
 
-static int dsos__write_buildid_table(struct perf_header *header, int fd);
-static int perf_session__cache_build_ids(struct perf_session *session);
-
 int perf_header__push_event(u64 id, const char *name)
 {
 	if (strlen(name) > MAX_EVENT_NAME)
@@ -187,6 +184,252 @@ perf_header__set_cmdline(int argc, const char **argv)
 	return 0;
 }
 
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
+static int machine__write_buildid_table(struct machine *machine, int fd)
+{
+	int err;
+	u16 kmisc = PERF_RECORD_MISC_KERNEL,
+	    umisc = PERF_RECORD_MISC_USER;
+
+	if (!machine__is_host(machine)) {
+		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
+		umisc = PERF_RECORD_MISC_GUEST_USER;
+	}
+
+	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine->pid,
+					  kmisc, fd);
+	if (err == 0)
+		err = __dsos__write_buildid_table(&machine->user_dsos,
+						  machine->pid, umisc, fd);
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
+	char *realname, *filename = zalloc(size),
+	     *linkname = zalloc(size), *targetname;
+	int len, err = -1;
+
+	if (is_kallsyms) {
+		if (symbol_conf.kptr_restrict) {
+			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
+			return 0;
+		}
+		realname = (char *)name;
+	} else
+		realname = realpath(name, NULL);
+
+	if (realname == NULL || filename == NULL || linkname == NULL)
+		goto out_free;
+
+	len = snprintf(filename, size, "%s%s%s",
+		       debugdir, is_kallsyms ? "/" : "", realname);
+	if (mkdir_p(filename, 0755))
+		goto out_free;
+
+	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
+
+	if (access(filename, F_OK)) {
+		if (is_kallsyms) {
+			 if (copyfile("/proc/kallsyms", filename))
+				goto out_free;
+		} else if (link(realname, filename) && copyfile(name, filename))
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
+	if (!is_kallsyms)
+		free(realname);
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
+	char *filename = zalloc(size),
+	     *linkname = zalloc(size);
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
+	if (readlink(linkname, filename, size - 1) < 0)
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
+static int dso__cache_build_id(struct dso *dso, const char *debugdir)
+{
+	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
+
+	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id),
+				     dso->long_name, debugdir, is_kallsyms);
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
+static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
+{
+	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, debugdir);
+	ret |= __dsos__cache_build_ids(&machine->user_dsos, debugdir);
+	return ret;
+}
+
+static int perf_session__cache_build_ids(struct perf_session *session)
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
+	ret = machine__cache_build_ids(&session->host_machine, debugdir);
+
+	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__cache_build_ids(pos, debugdir);
+	}
+	return ret ? -1 : 0;
+}
+
+static bool machine__read_build_ids(struct machine *machine, bool with_hits)
+{
+	bool ret = __dsos__read_build_ids(&machine->kernel_dsos, with_hits);
+	ret |= __dsos__read_build_ids(&machine->user_dsos, with_hits);
+	return ret;
+}
+
+static bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
+{
+	struct rb_node *nd;
+	bool ret = machine__read_build_ids(&session->host_machine, with_hits);
+
+	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__read_build_ids(pos, with_hits);
+	}
+
+	return ret;
+}
+
 static int write_trace_info(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
@@ -1132,252 +1375,6 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 	return 0;
 }
 
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
-static int machine__write_buildid_table(struct machine *machine, int fd)
-{
-	int err;
-	u16 kmisc = PERF_RECORD_MISC_KERNEL,
-	    umisc = PERF_RECORD_MISC_USER;
-
-	if (!machine__is_host(machine)) {
-		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-		umisc = PERF_RECORD_MISC_GUEST_USER;
-	}
-
-	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine->pid,
-					  kmisc, fd);
-	if (err == 0)
-		err = __dsos__write_buildid_table(&machine->user_dsos,
-						  machine->pid, umisc, fd);
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
-	char *realname, *filename = zalloc(size),
-	     *linkname = zalloc(size), *targetname;
-	int len, err = -1;
-
-	if (is_kallsyms) {
-		if (symbol_conf.kptr_restrict) {
-			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
-			return 0;
-		}
-		realname = (char *)name;
-	} else
-		realname = realpath(name, NULL);
-
-	if (realname == NULL || filename == NULL || linkname == NULL)
-		goto out_free;
-
-	len = snprintf(filename, size, "%s%s%s",
-		       debugdir, is_kallsyms ? "/" : "", realname);
-	if (mkdir_p(filename, 0755))
-		goto out_free;
-
-	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
-
-	if (access(filename, F_OK)) {
-		if (is_kallsyms) {
-			 if (copyfile("/proc/kallsyms", filename))
-				goto out_free;
-		} else if (link(realname, filename) && copyfile(name, filename))
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
-	if (!is_kallsyms)
-		free(realname);
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
-	char *filename = zalloc(size),
-	     *linkname = zalloc(size);
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
-	if (readlink(linkname, filename, size - 1) < 0)
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
-static int dso__cache_build_id(struct dso *dso, const char *debugdir)
-{
-	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
-
-	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id),
-				     dso->long_name, debugdir, is_kallsyms);
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
-static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
-{
-	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, debugdir);
-	ret |= __dsos__cache_build_ids(&machine->user_dsos, debugdir);
-	return ret;
-}
-
-static int perf_session__cache_build_ids(struct perf_session *session)
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
-	ret = machine__cache_build_ids(&session->host_machine, debugdir);
-
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__cache_build_ids(pos, debugdir);
-	}
-	return ret ? -1 : 0;
-}
-
-static bool machine__read_build_ids(struct machine *machine, bool with_hits)
-{
-	bool ret = __dsos__read_build_ids(&machine->kernel_dsos, with_hits);
-	ret |= __dsos__read_build_ids(&machine->user_dsos, with_hits);
-	return ret;
-}
-
-static bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
-{
-	struct rb_node *nd;
-	bool ret = machine__read_build_ids(&session->host_machine, with_hits);
-
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__read_build_ids(pos, with_hits);
-	}
-
-	return ret;
-}
-
 static int do_write_feat(int fd, struct perf_header *h, int type,
 			 struct perf_file_section **p,
 			 struct perf_evlist *evlist)
-- 
1.7.7


