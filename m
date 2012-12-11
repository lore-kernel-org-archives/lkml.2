Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2LKWwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:52:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43879 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab2LKWsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Feng Tang <feng.tang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/37] perf session: Free environment information when deleting session
Date: Tue, 11 Dec 2012 19:47:51 -0300
Message-Id: <1355266103-17238-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf session environment information was saved (so allocated) during
perf_session__open, but was not freed.  As free(3) handles NULL pointer
input properly it won't cause a issue for writing modes - e.g. perf
record

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1353472999-23042-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce6f511..d5fb607 100644
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
1.7.9.2.358.g22243

