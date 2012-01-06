Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab2AFVQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:16:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:46102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2AFVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:16:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf kvm: Do guest-only counting by default
Date: Fri,  6 Jan 2012 19:16:02 -0200
Message-Id: <1325884564-23322-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325884564-23322-1-git-send-email-acme@infradead.org>
References: <1325884564-23322-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Make use of exclude_guest and exlude_host in perf-kvm to do only
guest-only counting by default.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[ committer note: Moved perf_{guest,host} & event_attr_init to util.c ]
[                 so as not to drag more stuff to the python binding]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c       |    6 ++----
 tools/perf/util/evlist.c       |    5 ++++-
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/util.c         |   15 +++++++++++++++
 tools/perf/util/util.h         |    4 ++++
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 032324a..9fc6e0f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -22,9 +22,6 @@
 static const char		*file_name;
 static char			name_buffer[256];
 
-bool				perf_host = 1;
-bool				perf_guest;
-
 static const char * const kvm_usage[] = {
 	"perf kvm [<options>] {top|record|report|diff|buildid-list}",
 	NULL
@@ -107,7 +104,8 @@ static int __cmd_buildid_list(int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __used)
 {
-	perf_host = perf_guest = 0;
+	perf_host  = 0;
+	perf_guest = 1;
 
 	argc = parse_options(argc, argv, kvm_options, kvm_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index fa18370..3f16e08 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,8 +111,11 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 		.type = PERF_TYPE_HARDWARE,
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
-	struct perf_evsel *evsel = perf_evsel__new(&attr, 0);
+	struct perf_evsel *evsel;
+
+	event_attr_init(&attr);
 
+	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL)
 		goto error;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 531c283..dcf999c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -838,6 +838,7 @@ int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
 	for (;;) {
 		ostr = str;
 		memset(&attr, 0, sizeof(attr));
+		event_attr_init(&attr);
 		ret = parse_event_symbols(evlist, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 5b3ea49..8131410 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,6 +1,21 @@
+#include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
 
+/*
+ * XXX We need to find a better place for these things...
+ */
+bool perf_host  = true;
+bool perf_guest = true;
+
+void event_attr_init(struct perf_event_attr *attr)
+{
+	if (!perf_host)
+		attr->exclude_host  = 1;
+	if (!perf_guest)
+		attr->exclude_guest = 1;
+}
+
 int mkdir_p(char *path, mode_t mode)
 {
 	struct stat st;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 37be34d..b9c530c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -242,6 +242,10 @@ int strtailcmp(const char *s1, const char *s2);
 unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
 
+struct perf_event_attr;
+
+void event_attr_init(struct perf_event_attr *attr);
+
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-- 
1.7.4.4

