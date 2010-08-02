Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0HBHvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:51:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:60316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab0HBHvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:51:40 -0400
Date: Mon, 2 Aug 2010 07:51:23 GMT
From: tip-bot for Dave Martin <dave.martin@linaro.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unneeded code for tracking the cwd in perf sessions
Message-ID: <tip-88ca895dd4e0e64ebd942adb7925fa60ca5b2a98@git.kernel.org>
Git-Commit-ID: 88ca895dd4e0e64ebd942adb7925fa60ca5b2a98
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:51:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88ca895dd4e0e64ebd942adb7925fa60ca5b2a98
Gitweb:     http://git.kernel.org/tip/88ca895dd4e0e64ebd942adb7925fa60ca5b2a98
Author:     Dave Martin <dave.martin@linaro.org>
AuthorDate: Tue, 27 Jul 2010 11:46:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Jul 2010 11:46:12 -0300

perf tools: Remove unneeded code for tracking the cwd in perf sessions

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
