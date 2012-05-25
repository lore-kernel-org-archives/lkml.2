Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2EYT7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:59:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41909 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2EYT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:59:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf tools: fix thread_map__new_by_pid_str() memory leak in error path
Date: Fri, 25 May 2012 16:59:16 -0300
Message-Id: <1337975958-24047-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337975958-24047-1-git-send-email-acme@infradead.org>
References: <1337975958-24047-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

The namelist array (including its content) was not freed if we fail to
realloc a new 'threads' structure.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1337952109-31995-1-git-send-email-fbuihuu@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread_map.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

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
1.7.9.2.358.g22243

