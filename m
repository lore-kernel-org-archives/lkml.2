Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0GAPzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:55:03 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47057 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab0GAPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:10 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/21] perf: Split build-id.c
Date: Thu,  1 Jul 2010 17:56:00 +0200
Message-Id: <1277999763-20357-19-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... into perf-specific and generic part.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/perf/build-id.c  |   49 --------------------------------------------
 tools/lib/perf/build-id.h  |    4 +++
 tools/perf/Makefile        |    1 +
 tools/perf/util/build-id.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 49 deletions(-)
 create mode 100644 tools/perf/util/build-id.c

diff --git a/tools/lib/perf/build-id.c b/tools/lib/perf/build-id.c
index 5969758..c4c1267 100644
--- a/tools/lib/perf/build-id.c
+++ b/tools/lib/perf/build-id.c
@@ -60,52 +60,3 @@ char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
 			 build_id_hex, build_id_hex + 2);
 	return bf;
 }
-
-struct buildid_dir_config {
-	char *dir;
-};
-
-static int buildid_dir_command_config(const char *var, const char *value,
-				      void *data)
-{
-	struct buildid_dir_config *c = data;
-	const char *v;
-
-	/* same dir for all commands */
-	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
-		v = lk_config_dirname(var, value);
-		if (!v)
-			return -1;
-		strncpy(c->dir, v, MAXPATHLEN-1);
-		c->dir[MAXPATHLEN-1] = '\0';
-	}
-	return 0;
-}
-static void check_buildid_dir_config(void)
-{
-	struct buildid_dir_config c;
-	c.dir = buildid_dir;
-	perf_config(buildid_dir_command_config, &c);
-}
-
-void set_buildid_dir(void)
-{
-	buildid_dir[0] = '\0';
-
-	/* try config file */
-	check_buildid_dir_config();
-
-	/* default to $HOME/.debug */
-	if (buildid_dir[0] == '\0') {
-		char *v = getenv("HOME");
-		if (v) {
-			snprintf(buildid_dir, MAXPATHLEN-1, "%s/%s",
-				 v, DEBUG_CACHE_DIR);
-		} else {
-			strncpy(buildid_dir, DEBUG_CACHE_DIR, MAXPATHLEN-1);
-		}
-		buildid_dir[MAXPATHLEN-1] = '\0';
-	}
-	/* for communicating with external commands */
-	setenv("PERF_BUILDID_DIR", buildid_dir, 1);
-}
diff --git a/tools/lib/perf/build-id.h b/tools/lib/perf/build-id.h
index 1b73726..224c90b 100644
--- a/tools/lib/perf/build-id.h
+++ b/tools/lib/perf/build-id.h
@@ -6,6 +6,10 @@
 
 extern struct perf_event_ops build_id__mark_dso_hit_ops;
 
+struct buildid_dir_config {
+	char *dir;
+};
+
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
 extern void set_buildid_dir(void);
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 590c8f6..7d6ee06 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,6 +387,7 @@ LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/config.o
+LIB_OBJS += $(OUTPUT)util/build-id.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
new file mode 100644
index 0000000..af2f840
--- /dev/null
+++ b/tools/perf/util/build-id.c
@@ -0,0 +1,48 @@
+#include <lk/strbuf.h>
+#include <perf/build-id.h>
+
+static int buildid_dir_command_config(const char *var, const char *value,
+				      void *data)
+{
+	struct buildid_dir_config *c = data;
+	const char *v;
+
+	/* same dir for all commands */
+	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
+		v = lk_config_dirname(var, value);
+		if (!v)
+			return -1;
+		strncpy(c->dir, v, MAXPATHLEN-1);
+		c->dir[MAXPATHLEN-1] = '\0';
+	}
+	return 0;
+}
+
+static void check_buildid_dir_config(void)
+{
+	struct buildid_dir_config c;
+	c.dir = buildid_dir;
+	perf_config(buildid_dir_command_config, &c);
+}
+
+void set_buildid_dir(void)
+{
+	buildid_dir[0] = '\0';
+
+	/* try config file */
+	check_buildid_dir_config();
+
+	/* default to $HOME/.debug */
+	if (buildid_dir[0] == '\0') {
+		char *v = getenv("HOME");
+		if (v) {
+			snprintf(buildid_dir, MAXPATHLEN-1, "%s/%s",
+				 v, DEBUG_CACHE_DIR);
+		} else {
+			strncpy(buildid_dir, DEBUG_CACHE_DIR, MAXPATHLEN-1);
+		}
+		buildid_dir[MAXPATHLEN-1] = '\0';
+	}
+	/* for communicating with external commands */
+	setenv("PERF_BUILDID_DIR", buildid_dir, 1);
+}
-- 
1.7.1

