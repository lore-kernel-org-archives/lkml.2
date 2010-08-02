Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0HBBJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0HBBJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/19] perf tools: Remove unneeded code for tracking the cwd in perf sessions
Date: Sun,  1 Aug 2010 22:08:44 -0300
Message-Id: <1280711334-30000-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

Tidy-up patch to remove some code and struct perf_session data members
which are no longer needed due to the previous patch: "perf tools: Don't
abbreviate file paths relative to the cwd".

LKML-Reference: <new-submission>
Signed-off-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |    4 +---
 tools/perf/builtin-diff.c         |    2 --
 tools/perf/builtin-report.c       |    2 --
 tools/perf/util/session.c         |   22 +---------------------
 tools/perf/util/symbol.h          |    1 -
 5 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 9989072..44a47e1 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -43,10 +43,8 @@ static int __cmd_buildid_list(void)
 	if (session == NULL)
 		return -1;
 
-	if (with_hits) {
-		symbol_conf.full_paths = true;
+	if (with_hits)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
-	}
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 39e6627..fca1d44 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -180,8 +180,6 @@ static const struct option options[] = {
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
-	OPT_BOOLEAN('P', "full-paths", &symbol_conf.full_paths,
-		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ce42bba..2f4b929 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -441,8 +441,6 @@ static const struct option options[] = {
 		   "pretty printing style key: normal raw"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
-	OPT_BOOLEAN('P', "full-paths", &symbol_conf.full_paths,
-		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0307918..8cbea12 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -96,8 +96,6 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->hists_tree = RB_ROOT;
 	self->last_match = NULL;
 	self->mmap_window = 32;
-	self->cwd = NULL;
-	self->cwdlen = 0;
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples_head);
@@ -130,7 +128,6 @@ void perf_session__delete(struct perf_session *self)
 {
 	perf_header__exit(&self->header);
 	close(self->fd);
-	free(self->cwd);
 	free(self);
 }
 
@@ -832,23 +829,6 @@ int perf_session__process_events(struct perf_session *self,
 	if (perf_session__register_idle_thread(self) == NULL)
 		return -ENOMEM;
 
-	if (!symbol_conf.full_paths) {
-		char bf[PATH_MAX];
-
-		if (getcwd(bf, sizeof(bf)) == NULL) {
-			err = -errno;
-out_getcwd_err:
-			pr_err("failed to get the current directory\n");
-			goto out_err;
-		}
-		self->cwd = strdup(bf);
-		if (self->cwd == NULL) {
-			err = -ENOMEM;
-			goto out_getcwd_err;
-		}
-		self->cwdlen = strlen(self->cwd);
-	}
-
 	if (!self->fd_pipe)
 		err = __perf_session__process_events(self,
 						     self->header.data_offset,
@@ -856,7 +836,7 @@ out_getcwd_err:
 						     self->size, ops);
 	else
 		err = __perf_session__process_pipe_events(self, ops);
-out_err:
+
 	return err;
 }
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index bb1aab9..6452a07 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -68,7 +68,6 @@ struct symbol_conf {
 			show_nr_samples,
 			use_callchain,
 			exclude_other,
-			full_paths,
 			show_cpu_utilization;
 	const char	*vmlinux_name,
 			*source_prefix,
-- 
1.6.2.5

