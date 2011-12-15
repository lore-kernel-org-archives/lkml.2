Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137Ab1LOQk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:40:59 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35071 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1LOQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:40:57 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LW97AV-01-5FG-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/4] perf tools: Factor out feature op to process header sections
Date: Thu, 15 Dec 2011 17:32:42 +0100
Message-ID: <1323966762-8574-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
References: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is individual code for each feature to process header sections.
Adding a function pointer .process to struct feature_ops for keeping
the implementation in separate functions. Code to process header
sections is now a generic function.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   44 +++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 65cfabc..1e38c10 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1455,25 +1455,48 @@ out:
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
@@ -1857,19 +1880,10 @@ static int perf_file_section__process(struct perf_file_section *section,
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
1.7.7


