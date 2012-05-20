Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2ETCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:16:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37794 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2ETCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:16:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] Revert 'perf evlist: Fix creation of cpu map'
Date: Sat, 19 May 2012 23:16:32 -0300
Message-Id: <1337480196-761-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337480196-761-1-git-send-email-acme@infradead.org>
References: <1337480196-761-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 55261f46702c ("perf evlist: Fix creation of cpu map") changed
to create a per-task event when no cpu target is specified. However it
caused a problem since perf-task do not allow event inheritance due to
scalability issues so that the result will contain samples only from
parent, not from its children.

So we should use perf-task-per-cpu events anyway to get the right
result. Revert it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Analysed-by: Ingo Molnar <mingo@kernel.org>
Acked-and-tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337161549-9870-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 80bef28..87889f3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,10 +609,10 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (perf_target__has_cpu(target))
-		evlist->cpus = cpu_map__new(target->cpu_list);
-	else
+	if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
+	else
+		evlist->cpus = cpu_map__new(target->cpu_list);
 
 	if (evlist->cpus == NULL)
 		goto out_delete_threads;
-- 
1.7.9.2.358.g22243

