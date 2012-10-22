Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2JVJq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:46:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54597 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2JVJqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:46:54 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v5 1/6] perf tools: configure tmp path at build time
Date: Mon, 22 Oct 2012 12:46:07 +0300
Message-Id: <1350899172-16965-2-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
References: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Temporary perf files are hardcoded to point to /tmp. Android does not have
a /tmp directory so it needs to set this path at compile time.

Add a compile-time definition (PERF_TMP_DIR) in the Makefile that sets the path
to temp directory. By default it points to /tmp.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Documentation/android.txt       |    1 +
 tools/perf/Documentation/jit-interface.txt |    4 +++-
 tools/perf/Makefile                        |    4 +++-
 tools/perf/perf-archive.sh                 |   13 +++++++++++--
 tools/perf/util/dso-test-data.c            |    2 +-
 tools/perf/util/map.c                      |    3 ++-
 tools/perf/util/pmu.c                      |    2 +-
 tools/perf/util/sort.c                     |    4 +++-
 tools/perf/util/symbol.c                   |    4 +++-
 tools/perf/util/trace-event-info.c         |    2 +-
 tools/perf/util/vdso.c                     |    2 +-
 11 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
index a39dbbb..24fd01c 100644
--- a/tools/perf/Documentation/android.txt
+++ b/tools/perf/Documentation/android.txt
@@ -68,6 +68,7 @@ Some perf features need environment variables to run properly.
 You need to set these before running perf on the target:
   adb shell
   # PERF_PAGER=cat
+  # PERF_TMP_DIR=/data/local/tmp
 
 IV. Run perf
 ------------------------------------------------
diff --git a/tools/perf/Documentation/jit-interface.txt b/tools/perf/Documentation/jit-interface.txt
index a8656f5..10cb6ec 100644
--- a/tools/perf/Documentation/jit-interface.txt
+++ b/tools/perf/Documentation/jit-interface.txt
@@ -1,7 +1,9 @@
 perf supports a simple JIT interface to resolve symbols for dynamic code generated
 by a JIT.
 
-The JIT has to write a /tmp/perf-%d.map  (%d = pid of process) file
+The JIT has to write a $PERF_TMP_DIR/perf-%d.map  (%d = pid of process) file.
+You can set $PERF_TMP_DIR at compile time in the Makefile.
+By default it is /tmp.
 
 This is a text file.
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 76190a7..5429b5b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -141,6 +141,7 @@ sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
+PERF_TMP_DIR = /tmp
 
 export prefix bindir sharedir sysconfdir
 
@@ -169,7 +170,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"'
 BASIC_LDFLAGS =
 
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
@@ -177,6 +178,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
+	PERF_TMP_DIR = /data/local/tmp
 endif
 
 # Guard against environment variables
diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index e919306..058c3b7 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -18,7 +18,16 @@ else
         PERF_BUILDID_DIR=$PERF_BUILDID_DIR/
 fi
 
-BUILDIDS=$(mktemp /tmp/perf-archive-buildids.XXXXXX)
+#
+# PERF_TMP_DIR environment variable set by perf
+# path to temp directory, default to /tmp
+#
+if [ -z $PERF_TMP_DIR ]; then
+	PERF_TMP_DIR=/tmp
+fi
+
+
+BUILDIDS=$(mktemp $PERF_TMP_DIR/perf-archive-buildids.XXXXXX)
 NOBUILDID=0000000000000000000000000000000000000000
 
 perf buildid-list -i $PERF_DATA --with-hits | grep -v "^$NOBUILDID " > $BUILDIDS
@@ -28,7 +37,7 @@ if [ ! -s $BUILDIDS ] ; then
 	exit 1
 fi
 
-MANIFEST=$(mktemp /tmp/perf-archive-manifest.XXXXXX)
+MANIFEST=$(mktemp $PERF_TMP_DIR/perf-archive-manifest.XXXXXX)
 PERF_BUILDID_LINKDIR=$(readlink -f $PERF_BUILDID_DIR)/
 
 cut -d ' ' -f 1 $BUILDIDS | \
diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
index c6caede..ca81e65 100644
--- a/tools/perf/util/dso-test-data.c
+++ b/tools/perf/util/dso-test-data.c
@@ -18,7 +18,7 @@ do { \
 
 static char *test_file(int size)
 {
-	static char buf_templ[] = "/tmp/test-XXXXXX";
+	static char buf_templ[] = PERF_TMP_DIR "/test-XXXXXX";
 	char *templ = buf_templ;
 	int fd, i;
 	unsigned char *buf;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6109fa4..4e69b57 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -59,7 +59,8 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		no_dso = is_no_dso_memory(filename);
 
 		if (anon) {
-			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
+			snprintf(newfilename, sizeof(newfilename),
+				 PERF_TMP_DIR "/perf-%d.map", pid);
 			filename = newfilename;
 		}
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8a2229d..5ebde18 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -637,7 +637,7 @@ static char *test_format_dir_get(void)
 	static char dir[PATH_MAX];
 	unsigned int i;
 
-	snprintf(dir, PATH_MAX, "/tmp/perf-pmu-test-format-XXXXXX");
+	snprintf(dir, PATH_MAX, PERF_TMP_DIR "/perf-pmu-test-format-XXXXXX");
 	if (!mkdtemp(dir))
 		return NULL;
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cfd1c0f..d579406 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -263,7 +263,9 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
-	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
+	if (!strncmp
+	    (self->ms.map->dso->long_name, PERF_TMP_DIR "/perf-",
+	     strlen(PERF_TMP_DIR "/perf-")))
 		goto out_ip;
 
 	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e2e8c69..d8aca82 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1051,7 +1051,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 	dso->adjust_symbols = 0;
 
-	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
+	if (strncmp
+	    (dso->name, PERF_TMP_DIR "/perf-",
+	     strlen(PERF_TMP_DIR "/perf-")) == 0) {
 		struct stat st;
 
 		if (lstat(dso->name, &st) < 0)
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index a8d81c3..e50ea61 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -481,7 +481,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 		int temp_fd;
 
 		snprintf(tdata->temp_file, sizeof(tdata->temp_file),
-			 "/tmp/perf-XXXXXX");
+			 PERF_TMP_DIR "/perf-XXXXXX");
 		if (!mkstemp(tdata->temp_file))
 			die("Can't make temp file");
 
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index e60951f..8b9613b 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -14,7 +14,7 @@
 #include "linux/string.h"
 
 static bool vdso_found;
-static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
+static char vdso_file[] = PERF_TMP_DIR "/perf-vdso.so-XXXXXX";
 
 static int find_vdso_map(void **start, void **end)
 {
-- 
1.7.9.5

