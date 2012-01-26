Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2AZNaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:30:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2AZNap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:30:45 -0500
Date: Thu, 26 Jan 2012 05:30:01 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-m06n4rp7pwr6dlzwoq89cl69@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add fprintf methods for thread_map and cpu_map classes
Git-Commit-ID: 9ae7d3351aac238eef9646479693105688fd9cc9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:30:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ae7d3351aac238eef9646479693105688fd9cc9
Gitweb:     http://git.kernel.org/tip/9ae7d3351aac238eef9646479693105688fd9cc9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Jan 2012 14:07:23 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Jan 2012 19:46:48 -0200

perf tools: Add fprintf methods for thread_map and cpu_map classes

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
