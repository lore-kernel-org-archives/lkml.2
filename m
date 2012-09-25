Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2IYCrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:47:35 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53681 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2IYCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:47:34 -0400
X-AuditID: 9c930197-b7b6dae000000e70-d5-50611b44b2ee
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf session: Add perf_session__delete_env
Date: Tue, 25 Sep 2012 11:39:08 +0900
Message-Id: <1348540748-4750-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf session environment information was saved (so allocated)
during perf_session__open, but was not freed.  As free(3) handles NULL
pointer input properly it won't cause a issue for writing modes -
e.g. perf record.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/session.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3049b0ae7003..568037750d12 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -204,11 +204,30 @@ static void perf_session__delete_threads(struct perf_session *session)
 	machine__delete_threads(&session->host_machine);
 }
 
+static void perf_session__delete_env(struct perf_session *self)
+{
+	struct perf_session_env *env = &self->header.env;
+
+	free(env->hostname);
+	free(env->os_release);
+	free(env->version);
+	free(env->arch);
+	free(env->cpu_desc);
+	free(env->cpuid);
+
+	free(env->cmdline);
+	free(env->sibling_cores);
+	free(env->sibling_threads);
+	free(env->numa_nodes);
+	free(env->pmu_mappings);
+}
+
 void perf_session__delete(struct perf_session *self)
 {
 	perf_session__destroy_kernel_maps(self);
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
+	perf_session__delete_env(self);
 	machine__exit(&self->host_machine);
 	close(self->fd);
 	free(self);
-- 
1.7.11.4

