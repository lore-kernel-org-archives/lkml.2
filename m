Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2AXXIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2AXXIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/9] perf tools: Add fprintf methods for thread_map and cpu_map classes
Date: Tue, 24 Jan 2012 21:07:53 -0200
Message-Id: <1327446481-5505-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For helping with debugging.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-m06n4rp7pwr6dlzwoq89cl69@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cpumap.c     |   11 +++++++++++
 tools/perf/util/cpumap.h     |    4 ++++
 tools/perf/util/thread_map.c |   11 +++++++++++
 tools/perf/util/thread_map.h |    4 ++++
 4 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 6893eec..adc72f0 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -166,6 +166,17 @@ out:
 	return cpus;
 }
 
+size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp)
+{
+	int i;
+	size_t printed = fprintf(fp, "%d cpu%s: ",
+				 map->nr, map->nr > 1 ? "s" : "");
+	for (i = 0; i < map->nr; ++i)
+		printed += fprintf(fp, "%s%d", i ? ", " : "", map->map[i]);
+
+	return printed + fprintf(fp, "\n");
+}
+
 struct cpu_map *cpu_map__dummy_new(void)
 {
 	struct cpu_map *cpus = malloc(sizeof(*cpus) + sizeof(int));
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 072c0a3..c415185 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -1,6 +1,8 @@
 #ifndef __PERF_CPUMAP_H
 #define __PERF_CPUMAP_H
 
+#include <stdio.h>
+
 struct cpu_map {
 	int nr;
 	int map[];
@@ -10,4 +12,6 @@ struct cpu_map *cpu_map__new(const char *cpu_list);
 struct cpu_map *cpu_map__dummy_new(void);
 void cpu_map__delete(struct cpu_map *map);
 
+size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
+
 #endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index a5df131..894d52f 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -62,3 +62,14 @@ void thread_map__delete(struct thread_map *threads)
 {
 	free(threads);
 }
+
+size_t thread_map__fprintf(struct thread_map *threads, FILE *fp)
+{
+	int i;
+	size_t printed = fprintf(fp, "%d thread%s: ",
+				 threads->nr, threads->nr > 1 ? "s" : "");
+	for (i = 0; i < threads->nr; ++i)
+		printed += fprintf(fp, "%s%d", i ? ", " : "", threads->map[i]);
+
+	return printed + fprintf(fp, "\n");
+}
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 3cb9073..736ab4a26 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -2,6 +2,7 @@
 #define __PERF_THREAD_MAP_H
 
 #include <sys/types.h>
+#include <stdio.h>
 
 struct thread_map {
 	int nr;
@@ -12,4 +13,7 @@ struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new(pid_t pid, pid_t tid);
 void thread_map__delete(struct thread_map *threads);
+
+size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
+
 #endif	/* __PERF_THREAD_MAP_H */
-- 
1.7.9.rc2.1.g69204

