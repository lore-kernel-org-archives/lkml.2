Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2JEIqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:46:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2JEIqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:46:23 -0400
Date: Fri, 5 Oct 2012 01:46:04 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-6i7lqzm4hmkg35o1370lb7w4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid-cache: Don'
 t use globals where not needed to
Git-Commit-ID: 472cc83c3296cdc9248f1afbcfae8bba0f6f9707
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:46:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  472cc83c3296cdc9248f1afbcfae8bba0f6f9707
Gitweb:     http://git.kernel.org/tip/472cc83c3296cdc9248f1afbcfae8bba0f6f9707
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:35 -0300

perf buildid-cache: Don't use globals where not needed to

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6i7lqzm4hmkg35o1370lb7w4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c |   58 ++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 8365455..d37e077 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -15,22 +15,6 @@
 #include "util/strlist.h"
 #include "util/symbol.h"
 
-static char const *add_name_list_str, *remove_name_list_str;
-
-static const char * const buildid_cache_usage[] = {
-	"perf buildid-cache [<options>]",
-	NULL
-};
-
-static const struct option buildid_cache_options[] = {
-	OPT_STRING('a', "add", &add_name_list_str,
-		   "file list", "file(s) to add"),
-	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
-		    "file(s) to remove"),
-	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
-	OPT_END()
-};
-
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -51,8 +35,8 @@ static int build_id_cache__add_file(const char *filename, const char *debugdir)
 	return err;
 }
 
-static int build_id_cache__remove_file(const char *filename __maybe_unused,
-				       const char *debugdir __maybe_unused)
+static int build_id_cache__remove_file(const char *filename,
+				       const char *debugdir)
 {
 	u8 build_id[BUILD_ID_SIZE];
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -73,11 +57,34 @@ static int build_id_cache__remove_file(const char *filename __maybe_unused,
 	return err;
 }
 
-static int __cmd_buildid_cache(void)
+int cmd_buildid_cache(int argc, const char **argv,
+		      const char *prefix __maybe_unused)
 {
 	struct strlist *list;
 	struct str_node *pos;
 	char debugdir[PATH_MAX];
+	char const *add_name_list_str = NULL,
+		   *remove_name_list_str = NULL;
+	const struct option buildid_cache_options[] = {
+	OPT_STRING('a', "add", &add_name_list_str,
+		   "file list", "file(s) to add"),
+	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
+		    "file(s) to remove"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+	};
+	const char * const buildid_cache_usage[] = {
+		"perf buildid-cache [<options>]",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, buildid_cache_options,
+			     buildid_cache_usage, 0);
+
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_pager();
 
 	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
 
@@ -119,16 +126,3 @@ static int __cmd_buildid_cache(void)
 
 	return 0;
 }
-
-int cmd_buildid_cache(int argc, const char **argv,
-		      const char *prefix __maybe_unused)
-{
-	argc = parse_options(argc, argv, buildid_cache_options,
-			     buildid_cache_usage, 0);
-
-	if (symbol__init() < 0)
-		return -1;
-
-	setup_pager();
-	return __cmd_buildid_cache();
-}
