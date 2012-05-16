Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966816Ab2EPJsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:48:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51193 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2EPJrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:47:43 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-4d-4fb377bbad27
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Revert 'perf evlist: Fix creation of cpu map'
Date: Wed, 16 May 2012 18:45:48 +0900
Message-Id: <1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 55261f46702c ("perf evlist: Fix creation of cpu
map") changed to create a per-task event when no cpu target
is specified. However it caused a problem since perf-task do
not allow event inheritance due to scalability issues so
that the result will contain samples only from parent, not
from its children.

So we should use perf-task-per-cpu events anyway to get the
right result. Revert it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Analysed-by: Ingo Molnar <mingo@kernel.org>
Acked-and-tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/evlist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 80bef281eee0..87889f325678 100644
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
1.7.10.1

