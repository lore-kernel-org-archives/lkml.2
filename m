Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2KTErs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:47:48 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57417 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2KTErr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:47:47 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-08-50ab0b718412
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] perf buildid-cache: Add --update option
Date: Tue, 20 Nov 2012 13:47:21 +0900
Message-Id: <1353386842-9547-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When adding vmlinux file to build-id cache, it'd be fail since
kallsyms dso with a same build-id was already added by perf record.
So one needs to remove the kallsyms first to add vmlinux into the
cache.  Add --update option for doing it at once.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-buildid-cache.txt |  4 ++
 tools/perf/builtin-buildid-cache.c              | 49 ++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index c1057701a7dc..3b0caf745964 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -24,6 +24,10 @@ OPTIONS
 -r::
 --remove=::
         Remove specified file from the cache.
+-u::
+--update::
+	Update specified file of the cache. It can be used to update kallsyms
+	kernel dso to vmlinux in order to support annotation.
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index fae8b250b2ca..855d9941f49a 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -58,6 +58,32 @@ static int build_id_cache__remove_file(const char *filename,
 	return err;
 }
 
+static int build_id_cache__update_file(const char *filename,
+				       const char *debugdir)
+{
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	int err;
+
+	if (filename__read_build_id(filename, &build_id, sizeof(build_id)) < 0) {
+		pr_debug("Couldn't read a build-id in %s\n", filename);
+		return -1;
+	}
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	err = build_id_cache__remove_s(sbuild_id, debugdir);
+	if (!err) {
+		err = build_id_cache__add_s(sbuild_id, debugdir, filename,
+					    false, false);
+	}
+	if (verbose)
+		pr_info("Updating %s %s: %s\n", sbuild_id, filename,
+			err ? "FAIL" : "Ok");
+
+	return err;
+}
+
 int cmd_buildid_cache(int argc, const char **argv,
 		      const char *prefix __maybe_unused)
 {
@@ -65,12 +91,15 @@ int cmd_buildid_cache(int argc, const char **argv,
 	struct str_node *pos;
 	char debugdir[PATH_MAX];
 	char const *add_name_list_str = NULL,
-		   *remove_name_list_str = NULL;
+		   *remove_name_list_str = NULL,
+		   *update_name_list_str = NULL;
 	const struct option buildid_cache_options[] = {
 	OPT_STRING('a', "add", &add_name_list_str,
 		   "file list", "file(s) to add"),
 	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
 		    "file(s) to remove"),
+	OPT_STRING('u', "update", &update_name_list_str, "file list",
+		    "file(s) to update"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_END()
 	};
@@ -125,5 +154,23 @@ int cmd_buildid_cache(int argc, const char **argv,
 		}
 	}
 
+	if (update_name_list_str) {
+		list = strlist__new(true, update_name_list_str);
+		if (list) {
+			strlist__for_each(pos, list)
+				if (build_id_cache__update_file(pos->s, debugdir)) {
+					if (errno == ENOENT) {
+						pr_debug("%s wasn't in the cache\n",
+							 pos->s);
+						continue;
+					}
+					pr_warning("Couldn't update %s: %s\n",
+						   pos->s, strerror(errno));
+				}
+
+			strlist__delete(list);
+		}
+	}
+
 	return 0;
 }
-- 
1.7.11.7

