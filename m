Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2LKWyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:14 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53849
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab2LKWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Frank Eigler <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Kushal Das <kdas@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 23/37] perf buildid-cache: Add option to show build ids that are missing in the cache
Date: Tue, 11 Dec 2012 19:48:09 -0300
Message-Id: <1355266103-17238-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This will allow to connect with services being put in place by distros such as
Fedora, where one can retrieve DSOs by their build-id.

Example usage:

	for buildid in $(perf buildid-cache --missing perf.data | cut -d' ' -f1) ; do
		echo "trying to get $buildid"
		wget -q https://darkserver.fedoraproject.org/buildids/$buildid
		cat $buildid ; echo
		rm -f $buildid
	done

Now its just a matter of some porcelain to get the details provided by such a
service, retrieve the file and use 'perf buildid-cache --add $FILE' to insert
it in the cache, then use 'perf report' or 'annotate' that will find the
required files in the cache.

More information about the darkserver service at:

	https://darkserver.fedoraproject.org/

Cc: David Ahern <dsahern@gmail.com>
Cc: Frank Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kushal Das <kdas@redhat.com>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6fuktuiyjn4jykxmt7c9f7xq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |    3 ++
 tools/perf/builtin-buildid-cache.c              |   48 ++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index c105770..8e798ba 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -24,6 +24,9 @@ OPTIONS
 -r::
 --remove=::
         Remove specified file from the cache.
+-M::
+--missing=:: 
+	List missing build ids in the cache for the specified file.
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index fae8b25..a336014 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/strlist.h"
 #include "util/build-id.h"
+#include "util/session.h"
 #include "util/symbol.h"
 
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
@@ -58,19 +59,59 @@ static int build_id_cache__remove_file(const char *filename,
 	return err;
 }
 
+static bool dso__missing_buildid_cache(struct dso *dso, int parm __maybe_unused)
+{
+	char filename[PATH_MAX];
+	u8 build_id[BUILD_ID_SIZE];
+
+	if (dso__build_id_filename(dso, filename, sizeof(filename)) &&
+	    filename__read_build_id(filename, build_id,
+				    sizeof(build_id)) != sizeof(build_id)) {
+		if (errno == ENOENT)
+			return false;
+
+		pr_warning("Problems with %s file, consider removing it from the cache\n", 
+			   filename);
+	} else if (memcmp(dso->build_id, build_id, sizeof(dso->build_id))) {
+		pr_warning("Problems with %s file, consider removing it from the cache\n", 
+			   filename);
+	}
+
+	return true;
+}
+
+static int build_id_cache__fprintf_missing(const char *filename, bool force, FILE *fp)
+{
+	struct perf_session *session = perf_session__new(filename, O_RDONLY,
+							 force, false, NULL);
+	if (session == NULL)
+		return -1;
+
+	perf_session__fprintf_dsos_buildid(session, fp, dso__missing_buildid_cache, 0);
+	perf_session__delete(session);
+
+	return 0;
+}
+
 int cmd_buildid_cache(int argc, const char **argv,
 		      const char *prefix __maybe_unused)
 {
 	struct strlist *list;
 	struct str_node *pos;
+	int ret = 0;
+	bool force = false;
 	char debugdir[PATH_MAX];
 	char const *add_name_list_str = NULL,
-		   *remove_name_list_str = NULL;
+		   *remove_name_list_str = NULL,
+		   *missing_filename = NULL;
 	const struct option buildid_cache_options[] = {
 	OPT_STRING('a', "add", &add_name_list_str,
 		   "file list", "file(s) to add"),
 	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
 		    "file(s) to remove"),
+	OPT_STRING('M', "missing", &missing_filename, "file",
+		   "to find missing build ids in the cache"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_END()
 	};
@@ -125,5 +166,8 @@ int cmd_buildid_cache(int argc, const char **argv,
 		}
 	}
 
-	return 0;
+	if (missing_filename)
+		ret = build_id_cache__fprintf_missing(missing_filename, force, stdout);
+
+	return ret;
 }
-- 
1.7.9.2.358.g22243

