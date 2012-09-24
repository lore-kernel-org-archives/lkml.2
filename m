Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2IXQA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab2IXQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/30] perf header: Remove perf_header__read_feature
Date: Mon, 24 Sep 2012 12:59:30 -0300
Message-Id: <1348502384-14442-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Because its only user builtin-kvm::get_cpu_isa() has gone, It can be
removed safely.  In general, we have the feature information in
perf_session_env already, no need to read it again.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1348474503-15070-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   60 +---------------------------------------------
 tools/perf/util/header.h |    1 -
 2 files changed, 1 insertions(+), 60 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4b028df..6aae329 100644
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
index 5867c7d..99bdd3a 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -118,7 +118,6 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 				  int feat, int fd, void *data));
 
 int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
-char *perf_header__read_feature(struct perf_session *session, int feat);
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms, bool is_vdso);
-- 
1.7.1

