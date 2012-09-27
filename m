Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2I0FfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:35:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2I0FfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:35:00 -0400
Date: Wed, 26 Sep 2012 22:34:39 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-37e9d750e672d6fa8c25463bd76240410bbbc786@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, haodong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1348474503-15070-7-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Remove perf_header__read_feature
Git-Commit-ID: 37e9d750e672d6fa8c25463bd76240410bbbc786
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:34:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37e9d750e672d6fa8c25463bd76240410bbbc786
Gitweb:     http://git.kernel.org/tip/37e9d750e672d6fa8c25463bd76240410bbbc786
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 24 Sep 2012 17:15:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 11:47:46 -0300

perf header: Remove perf_header__read_feature

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
