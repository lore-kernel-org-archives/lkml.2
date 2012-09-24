Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2IXIYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:24:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42779 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2IXIXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:23:39 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-f6-50601887c1de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 6/6] perf header: Remove perf_header__read_feature
Date: Mon, 24 Sep 2012 17:15:03 +0900
Message-Id: <1348474503-15070-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Because its only user builtin-kvm::get_cpu_isa() has gone, It can be
removed safely.  In general, we have the feature information in
perf_session_env already, no need to read it again.

Cc: David Ahern <dsahern@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 60 +-----------------------------------------------
 tools/perf/util/header.h |  1 -
 2 files changed, 1 insertion(+), 60 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4b028df83a40..6aae3290358e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1690,11 +1690,6 @@ static int process_total_mem(struct perf_file_section *section __maybe_unused,
 	return 0;
 }
 
-static char *read_cpuid(struct perf_header *ph, int fd)
-{
-	return do_read_string(fd, ph);
-}
-
 static struct perf_evsel *
 perf_evlist__find_by_index(struct perf_evlist *evlist, int idx)
 {
@@ -1952,7 +1947,6 @@ error:
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
-	char *(*read)(struct perf_header *h, int fd);
 	int (*process)(struct perf_file_section *section,
 		       struct perf_header *h, int fd, void *data);
 	const char *name;
@@ -1967,10 +1961,6 @@ struct feature_ops {
 #define FEAT_OPF(n, func) \
 	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
 		.process = process_##func, .full_only = true }
-#define FEAT_OPA_R(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
-		.read  = read_##func, .process = process_##func, \
-		.full_only = true }
 
 /* feature_ops not implemented: */
 #define print_tracing_data	NULL
@@ -1985,7 +1975,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPP(HEADER_ARCH,		arch),
 	FEAT_OPP(HEADER_NRCPUS,		nrcpus),
 	FEAT_OPP(HEADER_CPUDESC,	cpudesc),
-	FEAT_OPA_R(HEADER_CPUID,	cpuid),
+	FEAT_OPP(HEADER_CPUID,		cpuid),
 	FEAT_OPP(HEADER_TOTAL_MEM,	total_mem),
 	FEAT_OPP(HEADER_EVENT_DESC,	event_desc),
 	FEAT_OPP(HEADER_CMDLINE,	cmdline),
@@ -2040,54 +2030,6 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 	return 0;
 }
 
-struct header_read_data {
-	int feat;
-	char *result;
-};
-
-static int perf_file_section__read_feature(struct perf_file_section *section,
-				struct perf_header *ph,
-				int feat, int fd, void *data)
-{
-	struct header_read_data *hd = data;
-
-	if (feat != hd->feat)
-		return 0;
-
-	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
-		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
-				"%d, continuing...\n", section->offset, feat);
-	return 0;
-	}
-
-	if (feat >= HEADER_LAST_FEATURE) {
-		pr_warning("unknown feature %d\n", feat);
-		return 0;
-	}
-
-	if (!feat_ops[feat].read) {
-		pr_warning("read is not supported for feature %d\n", feat);
-		return 0;
-	}
-
-	hd->result = feat_ops[feat].read(ph, fd);
-	return 0;
-}
-
-char *perf_header__read_feature(struct perf_session *session, int feat)
-{
-	struct perf_header *header = &session->header;
-	struct header_read_data hd;
-	int fd = session->fd;
-
-	hd.feat = feat;
-	hd.result = NULL;
-
-	perf_header__process_sections(header, fd, &hd,
-				perf_file_section__read_feature);
-	return hd.result;
-}
-
 static int do_write_feat(int fd, struct perf_header *h, int type,
 			 struct perf_file_section **p,
 			 struct perf_evlist *evlist)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 5867c7d74f97..99bdd3abce59 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -118,7 +118,6 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 				  int feat, int fd, void *data));
 
 int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
-char *perf_header__read_feature(struct perf_session *session, int feat);
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms, bool is_vdso);
-- 
1.7.11.4

