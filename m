Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab2BNBxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:53:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:45717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2BNBxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/16] perf tools: Factor out feature op to process header sections
Date: Mon, 13 Feb 2012 23:52:54 -0200
Message-Id: <1329184375-27911-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

There is individual code for each feature to process header sections.

Adding a function pointer .process to struct feature_ops for keeping the
implementation in separate functions. Code to process header sections is
now a generic function.

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1328884916-5901-2-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   44 +++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5bb2d75..9f867d9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1466,25 +1466,48 @@ out:
 	return err;
 }
 
+static int process_trace_info(struct perf_file_section *section __unused,
+			      struct perf_header *ph __unused,
+			      int feat __unused, int fd)
+{
+	trace_report(fd, false);
+	return 0;
+}
+
+static int process_build_id(struct perf_file_section *section,
+			    struct perf_header *ph,
+			    int feat __unused, int fd)
+{
+	if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
+		pr_debug("Failed to read buildids, continuing...\n");
+	return 0;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	int (*process)(struct perf_file_section *section,
+		       struct perf_header *h, int feat, int fd);
 	const char *name;
 	bool full_only;
 };
 
 #define FEAT_OPA(n, func) \
 	[n] = { .name = #n, .write = write_##func, .print = print_##func }
+#define FEAT_OPP(n, func) \
+	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
+		.process = process_##func }
 #define FEAT_OPF(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func, .full_only = true }
+	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
+		.full_only = true }
 
 /* feature_ops not implemented: */
 #define print_trace_info		NULL
 #define print_build_id			NULL
 
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
-	FEAT_OPA(HEADER_TRACE_INFO,	trace_info),
-	FEAT_OPA(HEADER_BUILD_ID,	build_id),
+	FEAT_OPP(HEADER_TRACE_INFO,	trace_info),
+	FEAT_OPP(HEADER_BUILD_ID,	build_id),
 	FEAT_OPA(HEADER_HOSTNAME,	hostname),
 	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
 	FEAT_OPA(HEADER_VERSION,	version),
@@ -1900,19 +1923,10 @@ static int perf_file_section__process(struct perf_file_section *section,
 		return 0;
 	}
 
-	switch (feat) {
-	case HEADER_TRACE_INFO:
-		trace_report(fd, false);
-		break;
-	case HEADER_BUILD_ID:
-		if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
-			pr_debug("Failed to read buildids, continuing...\n");
-		break;
-	default:
-		break;
-	}
+	if (!feat_ops[feat].process)
+		return 0;
 
-	return 0;
+	return feat_ops[feat].process(section, ph, feat, fd);
 }
 
 static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
-- 
1.7.9.123.g65da0

