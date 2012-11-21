Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2KUEnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:43:41 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53993 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2KUEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:43:40 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-b8-50ac5bf9d60c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Feng Tang <feng.tang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2 1/3] perf session: Free environment information when deleting session
Date: Wed, 21 Nov 2012 13:43:19 +0900
Message-Id: <1353472999-23042-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353424854.1512.5.camel@leonhard>
References: <1353424854.1512.5.camel@leonhard>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf session environment information was saved (so allocated)
during perf_session__open, but was not freed.  As free(3) handles NULL
pointer input properly it won't cause a issue for writing modes -
e.g. perf record

Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/session.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce6f51162386..d5fb60760bac 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -204,11 +204,28 @@ static void perf_session__delete_threads(struct perf_session *session)
 	machine__delete_threads(&session->host_machine);
 }
 
+static void perf_session_env__delete(struct perf_session_env *env)
+{
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
+	perf_session_env__delete(&self->header.env);
 	machine__exit(&self->host_machine);
 	close(self->fd);
 	free(self);
-- 
1.7.11.7

