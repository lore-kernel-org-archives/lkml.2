Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2DQLSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab2DQLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/16] perf, tool: Back [vdso] DSO with real data
Date: Tue, 17 Apr 2012 13:17:14 +0200
Message-Id: <1334661441-4420-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Storing data for VDSO shared object, because we need it for
the unwind process.

The idea is that VDSO shared object is same for all process
on a running system, so it makes no difference if we store
it inside the tracer - perf.

The record command:
When [vdso] map memory is hit, we retrieve [vdso] DSO image
and store it into temporary file. During the build-id
processing the [vdso] DSO image is stored in build-id db,
and build-id refference is made inside perf.data. The temporary
file is removed when record is finished.

The report command:
We read build-id from perf.data and store [vdso] DSO object.
This object is refferenced and attached to map when the MMAP
events are processed. Thus during the SAMPLE event processing
we have correct mmap/dso attached.

Adding following API for vdso object:
  vdso__file
    - vdso temp file path

  vdso__get_file
    - finds and store VDSO image into temp file,
      the temp file path is returned

  vdso__exit
    - removes temporary VDSO image if there's any

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile       |    2 +
 tools/perf/util/map.c     |   23 ++++++++++-
 tools/perf/util/session.c |    2 +
 tools/perf/util/vdso.c    |   90 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/vdso.h    |    8 ++++
 5 files changed, 123 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/util/vdso.c
 create mode 100644 tools/perf/util/vdso.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c..d82af48 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -300,6 +300,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
+LIB_H += util/vdso.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -361,6 +362,7 @@ LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
+LIB_OBJS += $(OUTPUT)util/vdso.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 35ae568..1649ea0 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -7,6 +7,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include "map.h"
+#include "vdso.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
@@ -18,10 +19,14 @@ static inline int is_anon_memory(const char *filename)
 	return strcmp(filename, "//anon") == 0;
 }
 
+static inline int is_vdso_memory(const char *filename)
+{
+	return !strcmp(filename, "[vdso]");
+}
+
 static inline int is_no_dso_memory(const char *filename)
 {
 	return !strcmp(filename, "[stack]") ||
-	       !strcmp(filename, "[vdso]")  ||
 	       !strcmp(filename, "[heap]");
 }
 
@@ -50,9 +55,10 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (self != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon, no_dso;
+		int anon, no_dso, vdso;
 
 		anon = is_anon_memory(filename);
+		vdso = is_vdso_memory(filename);
 		no_dso = is_no_dso_memory(filename);
 
 		if (anon) {
@@ -60,10 +66,23 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			filename = newfilename;
 		}
 
+		if (vdso) {
+			filename = (char *) vdso__file;
+			pgoff = 0;
+		}
+
 		dso = __dsos__findnew(dsos__list, filename);
 		if (dso == NULL)
 			goto out_delete;
 
+		if (vdso && !dso->has_build_id) {
+			char *file_vdso = vdso__get_file();
+			if (file_vdso)
+				dso__set_long_name(dso, file_vdso);
+			else
+				no_dso = 1;
+		}
+
 		map__init(self, type, start, start + len, pgoff, dso);
 
 		if (anon || no_dso) {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1efd3be..ae30ca5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,6 +14,7 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
+#include "vdso.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -209,6 +210,7 @@ void perf_session__delete(struct perf_session *self)
 	machine__exit(&self->host_machine);
 	close(self->fd);
 	free(self);
+	vdso__exit();
 }
 
 void machine__remove_thread(struct machine *self, struct thread *th)
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
new file mode 100644
index 0000000..e964482
--- /dev/null
+++ b/tools/perf/util/vdso.c
@@ -0,0 +1,90 @@
+
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <linux/kernel.h>
+#include "vdso.h"
+#include "util.h"
+
+const char vdso__file[] = "/tmp/vdso.so";
+static bool vdso_found;
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
+		if (!strncmp(&line[m], "[vdso]", 6))
+			found = 1;
+	}
+
+	fclose(maps);
+	return !found;
+}
+
+char *vdso__get_file(void)
+{
+	char *vdso = NULL;
+	char *buf = NULL;
+	void *start, *end;
+
+	do {
+		int fd, size;
+
+		if (vdso_found) {
+			vdso = (char *) vdso__file;
+			break;
+		}
+
+		if (find_vdso_map(&start, &end))
+			break;
+
+		size = end - start;
+		buf = malloc(size);
+		if (!buf)
+			break;
+
+		memcpy(buf, start, size);
+
+		fd = open(vdso__file, O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
+		if (fd < 0)
+			break;
+
+		if (size == write(fd, buf, size))
+			vdso = (char *) vdso__file;
+
+		close(fd);
+	} while (0);
+
+	if (buf)
+		free(buf);
+
+	vdso_found = (vdso != NULL);
+	return vdso;
+}
+
+void vdso__exit(void)
+{
+	if (vdso_found)
+		unlink(vdso__file);
+}
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
new file mode 100644
index 0000000..908b041
--- /dev/null
+++ b/tools/perf/util/vdso.h
@@ -0,0 +1,8 @@
+#ifndef __VDSO__
+#define __VDSO__
+
+extern const char vdso__file[];
+char *vdso__get_file(void);
+void  vdso__exit(void);
+
+#endif /* __VDSO__ */
-- 
1.7.7.6

