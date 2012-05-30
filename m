Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2E3Hou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:44:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2E3Hot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:44:49 -0400
Date: Wed, 30 May 2012 00:44:37 -0700
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Message-ID: <tip-e8cdd947776300f962d5b699c34087af45a8aea7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fbuihuu@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1337952109-31995-1-git-send-email-fbuihuu@gmail.com>
References: <1337952109-31995-1-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: fix thread_map__new_by_pid_str()
  memory leak in error path
Git-Commit-ID: e8cdd947776300f962d5b699c34087af45a8aea7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:44:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8cdd947776300f962d5b699c34087af45a8aea7
Gitweb:     http://git.kernel.org/tip/e8cdd947776300f962d5b699c34087af45a8aea7
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Fri, 25 May 2012 15:21:49 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 May 2012 11:40:59 -0300

perf tools: fix thread_map__new_by_pid_str() memory leak in error path

The namelist array (including its content) was not freed if we fail to
realloc a new 'threads' structure.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1337952109-31995-1-git-send-email-fbuihuu@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
