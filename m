Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2ITWPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:15:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60035 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2ITWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:15:08 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 1/4] perf tools: configure tmp path at build time
Date: Fri, 21 Sep 2012 01:13:32 +0300
Message-Id: <1348179215-11160-2-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com>
References: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com>
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
 tools/perf/Makefile                |   16 +++++++++++++++-
 tools/perf/perf-archive.sh         |   13 +++++++++++--
 tools/perf/util/dso-test-data.c    |    2 +-
 tools/perf/util/map.c              |    3 ++-
 tools/perf/util/pmu.c              |    2 +-
 tools/perf/util/symbol.c           |    2 +-
 tools/perf/util/trace-event-info.c |    2 +-
 7 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5077f8e..eab4a36 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -139,6 +139,7 @@ sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
+PERF_TMP_DIR = /tmp
 
 export prefix bindir sharedir sysconfdir
 
@@ -246,7 +247,8 @@ $(OUTPUT)util/pmu-bison.c: util/pmu.y
 	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
 
 $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
-$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
+$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu.c $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
 
 LIB_FILE=$(OUTPUT)libperf.a
 
@@ -880,6 +882,18 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/dso-test-data.o: util/dso-test-data.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
+
+$(OUTPUT)util/map.o: util/map.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
+
+$(OUTPUT)util/symbol.o: util/symbol.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
+
+$(OUTPUT)util/trace-event-info.o: util/trace-event-info.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
+
 $(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
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
index b442ee4..c5b4632 100644
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
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e2e8c69..eb671d5 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1051,7 +1051,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 	dso->adjust_symbols = 0;
 
-	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
+	if (strncmp(dso->name, PERF_TMP_DIR "/perf-", 10) == 0) {
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
 
-- 
1.7.9.5

