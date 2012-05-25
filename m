Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2EYNV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:21:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46303 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2EYNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:21:53 -0400
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: acme@infradead.org
Cc: dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] perf tools: fix thread_map__new_by_pid_str() memory leak in error path
Date: Fri, 25 May 2012 15:21:49 +0200
Message-Id: <1337952109-31995-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

namelist array (including its content) was not freed if we fail
to realloc a new 'threads' structure.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/thread_map.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 84d9bd78..9b5f856 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -188,28 +188,27 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 		nt = realloc(threads, (sizeof(*threads) +
 				       sizeof(pid_t) * total_tasks));
 		if (nt == NULL)
-			goto out_free_threads;
+			goto out_free_namelist;
 
 		threads = nt;
 
-		if (threads) {
-			for (i = 0; i < items; i++)
-				threads->map[j++] = atoi(namelist[i]->d_name);
-			threads->nr = total_tasks;
-		}
-
-		for (i = 0; i < items; i++)
+		for (i = 0; i < items; i++) {
+			threads->map[j++] = atoi(namelist[i]->d_name);
 			free(namelist[i]);
+		}
+		threads->nr = total_tasks;
 		free(namelist);
-
-		if (!threads)
-			break;
 	}
 
 out:
 	strlist__delete(slist);
 	return threads;
 
+out_free_namelist:
+	for (i = 0; i < items; i++)
+		free(namelist[i]);
+	free(namelist);
+
 out_free_threads:
 	free(threads);
 	threads = NULL;
-- 
1.7.7.4

