Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2BQJze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:55:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38756 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2BQJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:55:33 -0500
Date: Fri, 17 Feb 2012 01:54:47 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-f1c67db7e351bf9fd328e368ba045cbeca11d513@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1328884916-5901-2-git-send-email-robert.richter@amd.com>
References: <1328884916-5901-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Factor out feature op to process header sections
Git-Commit-ID: f1c67db7e351bf9fd328e368ba045cbeca11d513
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:55:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1c67db7e351bf9fd328e368ba045cbeca11d513
Gitweb:     http://git.kernel.org/tip/f1c67db7e351bf9fd328e368ba045cbeca11d513
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 10 Feb 2012 15:41:56 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:33:36 -0200

perf tools: Factor out feature op to process header sections

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
