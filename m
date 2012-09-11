Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2IKXxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:53:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:42278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2IKXxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] perf tools: Back [vdso] DSO with real data
Date: Tue, 11 Sep 2012 20:53:04 -0300
Message-Id: <1347407590-30960-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Storing data for VDSO shared object, because we need it for the post
unwind processing.

The VDSO shared object is same for all process on a running system, so
it makes no difference when we store it inside the tracer - perf.

When [vdso] map memory is hit, we retrieve [vdso] DSO image and store it
into temporary file.

During the build-id processing phase, the [vdso] DSO image is stored in
build-id db, and build-id reference is made inside perf.data. The
build-id vdso file object is called '[vdso]'. We don't use temporary
file name which gets removed when record is finished.

During report phase the vdso build-id object is treated as any other
build-id DSO object.

Adding following API for vdso object:

  bool is_vdso_map(const char *filename)
    - returns true if the filename matches vdso map name

  struct dso *vdso__dso_findnew(struct list_head *head)
    - find/create proper vdso DSO object

  vdso__exit(void)
    - removes temporary VDSO image if there's any

This change makes backtrace dwarf post unwind possible from [vdso] maps.

Following output is current report of [vdso] sample dwarf backtrace:

  # Overhead  Command      Shared Object                         Symbol
  # ........  .......  .................  .............................
  #
      99.52%       ex  [vdso]             [.] 0x00007fff3ace89af
                   |
                   --- 0x7fff3ace89af

Following output is new report of [vdso] sample dwarf backtrace:

  # Overhead  Command      Shared Object                         Symbol
  # ........  .......  .................  .............................
  #
      99.52%       ex  [vdso]             [.] 0x00000000000009af
                   |
                   --- 0x7fff3ace89af
                       main
                       __libc_start_main
                       _start

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347295819-23177-5-git-send-email-jolsa@redhat.com
[ committer note: s/ALIGN/PERF_ALIGN/g to cope with the android build changes ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                |    2 +
 tools/perf/builtin-buildid-cache.c |    3 +-
 tools/perf/util/header.c           |   70 ++++++++++++++++-------
 tools/perf/util/header.h           |    2 +-
 tools/perf/util/map.c              |   12 +++-
 tools/perf/util/session.c          |    2 +
 tools/perf/util/vdso.c             |  111 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/vdso.h             |   18 ++++++
 8 files changed, 194 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/util/vdso.c
 create mode 100644 tools/perf/util/vdso.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1d2723c..209774b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -337,6 +337,7 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += ui/helpline.h
+LIB_H += util/vdso.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -404,6 +405,7 @@ LIB_OBJS += $(OUTPUT)util/cgroup.o
 LIB_OBJS += $(OUTPUT)util/target.o
 LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
+LIB_OBJS += $(OUTPUT)util/vdso.o
 
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 29ad20e..995368e 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -43,7 +43,8 @@ static int build_id_cache__add_file(const char *filename, const char *debugdir)
 	}
 
 	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
-	err = build_id_cache__add_s(sbuild_id, debugdir, filename, false);
+	err = build_id_cache__add_s(sbuild_id, debugdir, filename,
+				    false, false);
 	if (verbose)
 		pr_info("Adding %s %s: %s\n", sbuild_id, filename,
 			err ? "FAIL" : "Ok");
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 974e758..87996ca 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -21,6 +21,7 @@
 #include "debug.h"
 #include "cpumap.h"
 #include "pmu.h"
+#include "vdso.h"
 
 static bool no_buildid_cache = false;
 
@@ -207,6 +208,29 @@ perf_header__set_cmdline(int argc, const char **argv)
 			continue;		\
 		else
 
+static int write_buildid(char *name, size_t name_len, u8 *build_id,
+			 pid_t pid, u16 misc, int fd)
+{
+	int err;
+	struct build_id_event b;
+	size_t len;
+
+	len = name_len + 1;
+	len = PERF_ALIGN(len, NAME_ALIGN);
+
+	memset(&b, 0, sizeof(b));
+	memcpy(&b.build_id, build_id, BUILD_ID_SIZE);
+	b.pid = pid;
+	b.header.misc = misc;
+	b.header.size = sizeof(b) + len;
+
+	err = do_write(fd, &b, sizeof(b));
+	if (err < 0)
+		return err;
+
+	return write_padded(fd, name, name_len + 1, len);
+}
+
 static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 				u16 misc, int fd)
 {
@@ -214,24 +238,23 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 
 	dsos__for_each_with_build_id(pos, head) {
 		int err;
-		struct build_id_event b;
-		size_t len;
+		char  *name;
+		size_t name_len;
 
 		if (!pos->hit)
 			continue;
-		len = pos->long_name_len + 1;
-		len = PERF_ALIGN(len, NAME_ALIGN);
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
+
+		if (is_vdso_map(pos->short_name)) {
+			name = (char *) VDSO__MAP_NAME;
+			name_len = sizeof(VDSO__MAP_NAME) + 1;
+		} else {
+			name = pos->long_name;
+			name_len = pos->long_name_len + 1;
+		}
+
+		err = write_buildid(name, name_len, pos->build_id,
+				    pid, misc, fd);
+		if (err)
 			return err;
 	}
 
@@ -277,19 +300,20 @@ static int dsos__write_buildid_table(struct perf_header *header, int fd)
 }
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms)
+			  const char *name, bool is_kallsyms, bool is_vdso)
 {
 	const size_t size = PATH_MAX;
 	char *realname, *filename = zalloc(size),
 	     *linkname = zalloc(size), *targetname;
 	int len, err = -1;
+	bool slash = is_kallsyms || is_vdso;
 
 	if (is_kallsyms) {
 		if (symbol_conf.kptr_restrict) {
 			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
 			return 0;
 		}
-		realname = (char *)name;
+		realname = (char *) name;
 	} else
 		realname = realpath(name, NULL);
 
@@ -297,7 +321,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 		goto out_free;
 
 	len = scnprintf(filename, size, "%s%s%s",
-		       debugdir, is_kallsyms ? "/" : "", realname);
+		       debugdir, slash ? "/" : "",
+		       is_vdso ? VDSO__MAP_NAME : realname);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
@@ -333,13 +358,14 @@ out_free:
 
 static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
 				 const char *name, const char *debugdir,
-				 bool is_kallsyms)
+				 bool is_kallsyms, bool is_vdso)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
 	build_id__sprintf(build_id, build_id_size, sbuild_id);
 
-	return build_id_cache__add_s(sbuild_id, debugdir, name, is_kallsyms);
+	return build_id_cache__add_s(sbuild_id, debugdir, name,
+				     is_kallsyms, is_vdso);
 }
 
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
@@ -383,9 +409,11 @@ out_free:
 static int dso__cache_build_id(struct dso *dso, const char *debugdir)
 {
 	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
+	bool is_vdso = is_vdso_map(dso->short_name);
 
 	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id),
-				     dso->long_name, debugdir, is_kallsyms);
+				     dso->long_name, debugdir,
+				     is_kallsyms, is_vdso);
 }
 
 static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 9d5eedc..209dad4 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -96,7 +96,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms);
+			  const char *name, bool is_kallsyms, bool is_vdso);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 7d37159..b442ee4 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -9,6 +9,7 @@
 #include "map.h"
 #include "thread.h"
 #include "strlist.h"
+#include "vdso.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
@@ -23,7 +24,6 @@ static inline int is_anon_memory(const char *filename)
 static inline int is_no_dso_memory(const char *filename)
 {
 	return !strcmp(filename, "[stack]") ||
-	       !strcmp(filename, "[vdso]")  ||
 	       !strcmp(filename, "[heap]");
 }
 
@@ -52,9 +52,10 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (self != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon, no_dso;
+		int anon, no_dso, vdso;
 
 		anon = is_anon_memory(filename);
+		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
 
 		if (anon) {
@@ -62,7 +63,12 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			filename = newfilename;
 		}
 
-		dso = __dsos__findnew(dsos__list, filename);
+		if (vdso) {
+			pgoff = 0;
+			dso = vdso__dso_findnew(dsos__list);
+		} else
+			dso = __dsos__findnew(dsos__list, filename);
+
 		if (dso == NULL)
 			goto out_delete;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0ecd62b..e0fd6c7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -17,6 +17,7 @@
 #include "event-parse.h"
 #include "perf_regs.h"
 #include "unwind.h"
+#include "vdso.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -211,6 +212,7 @@ void perf_session__delete(struct perf_session *self)
 	machine__exit(&self->host_machine);
 	close(self->fd);
 	free(self);
+	vdso__exit();
 }
 
 void machine__remove_thread(struct machine *self, struct thread *th)
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
new file mode 100644
index 0000000..e60951f
--- /dev/null
+++ b/tools/perf/util/vdso.c
@@ -0,0 +1,111 @@
+
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <linux/kernel.h>
+
+#include "vdso.h"
+#include "util.h"
+#include "symbol.h"
+#include "linux/string.h"
+
+static bool vdso_found;
+static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
+
+static int find_vdso_map(void **start, void **end)
+{
+	FILE *maps;
+	char line[128];
+	int found = 0;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps) {
+		pr_err("vdso: cannot open maps\n");
+		return -1;
+	}
+
+	while (!found && fgets(line, sizeof(line), maps)) {
+		int m = -1;
+
+		/* We care only about private r-x mappings. */
+		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
+				start, end, &m))
+			continue;
+		if (m < 0)
+			continue;
+
+		if (!strncmp(&line[m], VDSO__MAP_NAME,
+			     sizeof(VDSO__MAP_NAME) - 1))
+			found = 1;
+	}
+
+	fclose(maps);
+	return !found;
+}
+
+static char *get_file(void)
+{
+	char *vdso = NULL;
+	char *buf = NULL;
+	void *start, *end;
+	size_t size;
+	int fd;
+
+	if (vdso_found)
+		return vdso_file;
+
+	if (find_vdso_map(&start, &end))
+		return NULL;
+
+	size = end - start;
+
+	buf = memdup(start, size);
+	if (!buf)
+		return NULL;
+
+	fd = mkstemp(vdso_file);
+	if (fd < 0)
+		goto out;
+
+	if (size == (size_t) write(fd, buf, size))
+		vdso = vdso_file;
+
+	close(fd);
+
+ out:
+	free(buf);
+
+	vdso_found = (vdso != NULL);
+	return vdso;
+}
+
+void vdso__exit(void)
+{
+	if (vdso_found)
+		unlink(vdso_file);
+}
+
+struct dso *vdso__dso_findnew(struct list_head *head)
+{
+	struct dso *dso = dsos__find(head, VDSO__MAP_NAME);
+
+	if (!dso) {
+		char *file;
+
+		file = get_file();
+		if (!file)
+			return NULL;
+
+		dso = dso__new(VDSO__MAP_NAME);
+		if (dso != NULL) {
+			dsos__add(head, dso);
+			dso__set_long_name(dso, file);
+		}
+	}
+
+	return dso;
+}
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
new file mode 100644
index 0000000..0f76e7c
--- /dev/null
+++ b/tools/perf/util/vdso.h
@@ -0,0 +1,18 @@
+#ifndef __PERF_VDSO__
+#define __PERF_VDSO__
+
+#include <linux/types.h>
+#include <string.h>
+#include <stdbool.h>
+
+#define VDSO__MAP_NAME "[vdso]"
+
+static inline bool is_vdso_map(const char *filename)
+{
+	return !strcmp(filename, VDSO__MAP_NAME);
+}
+
+struct dso *vdso__dso_findnew(struct list_head *head);
+void vdso__exit(void);
+
+#endif /* __PERF_VDSO__ */
-- 
1.7.9.2.358.g22243

