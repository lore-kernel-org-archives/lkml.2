Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2C1MhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab2C1MhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:37:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/15] perf, tool: Back [vdso] DSO with real data
Date: Wed, 28 Mar 2012 14:35:53 +0200
Message-Id: <1332938158-5244-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
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
processing the [vdso] DSO image is stored as in build-id db,
and build-id refference is made inside perf.data. The temporary
file is removed when record is finished.

The report command:
We read build-id from perf.data and store [vdso] DSO object.
This object is refferenced and attached to map when the MMAP
events are processed. Thus during the SAMPLE event processing
we have correct mmap/dso attached.

Adding following functions for vdso object:
  vdso__get_filename
    - finds and store VDSO image into temp file,
      the temp file path is returned

  vdso__exit
    - removes temporary VDSO image if there's any

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile         |    2 +
 tools/perf/builtin-record.c |    3 +
 tools/perf/util/map.c       |   16 +++++++-
 tools/perf/util/vdso.c      |   92 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/vdso.h      |    7 +++
 5 files changed, 119 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/util/vdso.c
 create mode 100644 tools/perf/util/vdso.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2f42886..1097d1d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -317,6 +317,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
+LIB_H += util/vdso.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -378,6 +379,7 @@ LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
+LIB_OBJS += $(OUTPUT)util/vdso.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be4e1ee..7b98fa9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,6 +26,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include "util/vdso.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -336,6 +337,7 @@ static void perf_record__exit(int status __used, void *arg)
 		perf_session__delete(rec->session);
 		perf_evlist__delete(rec->evlist);
 		symbol__exit();
+		vdso__exit();
 	}
 }
 
@@ -924,5 +926,6 @@ out_free_fd:
 	perf_evlist__delete_maps(evsel_list);
 out_symbol_exit:
 	symbol__exit();
+	vdso__exit();
 	return err;
 }
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index dea6d1c..f47dd80 100644
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
 
@@ -63,6 +68,15 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		if (dso == NULL)
 			goto out_delete;
 
+		if (is_vdso_memory(filename) && !dso->has_build_id) {
+			char *vdso = vdso__get_filename();
+			if (vdso) {
+				dso__set_long_name(dso, vdso);
+				pgoff = 0;
+			} else
+				no_dso = 1;
+		}
+
 		map__init(self, type, start, start + len, pgoff, dso);
 
 		if (anon || no_dso) {
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
new file mode 100644
index 0000000..62dcdd0
--- /dev/null
+++ b/tools/perf/util/vdso.c
@@ -0,0 +1,92 @@
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
+static const char vdso_path[] = "/tmp/perf-vdso.so";
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
+		pr_debug("vdso: start %p, end %p\n", *start, *end);
+
+		if (!strncmp(&line[m], "[vdso]", 6))
+			found = 1;
+	}
+
+	fclose(maps);
+	return !found;
+}
+
+char *vdso__get_filename(void)
+{
+	char *vdso = NULL;
+	char *buf = NULL;
+	void *start, *end;
+
+	do {
+		int fd, size;
+
+		if (vdso_found) {
+			vdso = (char *) vdso_path;
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
+		fd = open(vdso_path, O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
+		if (fd < 0)
+			break;
+
+		if (size == write(fd, buf, size))
+			vdso = (char *) vdso_path;
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
+		unlink(vdso_path);
+}
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
new file mode 100644
index 0000000..188fa9f
--- /dev/null
+++ b/tools/perf/util/vdso.h
@@ -0,0 +1,7 @@
+#ifndef __VDSO__
+#define __VDSO__
+
+char *vdso__get_filename(void);
+void  vdso__exit(void);
+
+#endif /* __VDSO__ */
-- 
1.7.1

