Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2KTJcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:32:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:25592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2KTJcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:32:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,284,1352102400"; 
   d="scan'208";a="222064174"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] perf session: Add perf_session__delete_env
Date: Tue, 20 Nov 2012 17:31:15 +0800
Message-Id: <1353403877-10730-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
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
 tools/perf/util/session.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce6f511..e9ce524 100644
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
1.7.9.5

