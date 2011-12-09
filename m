Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1LIRa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1LIRa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:30:56 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] perf, tool: Factor evlist code to use global unmap function
Date: Fri,  9 Dec 2011 18:30:36 +0100
Message-Id: <1323451838-23081-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
References: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __perf_evlist__munmap in case of map failure rather
than duplicate the unmap code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f3178bc..56f1d34 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -416,7 +416,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 	return event;
 }
 
-void perf_evlist__munmap(struct perf_evlist *evlist)
+static void __perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int i;
 
@@ -426,7 +426,11 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 			evlist->mmap[i].base = NULL;
 		}
 	}
+}
 
+void perf_evlist__munmap(struct perf_evlist *evlist)
+{
+	__perf_evlist__munmap(evlist);
 	free(evlist->mmap);
 	evlist->mmap = NULL;
 }
@@ -494,12 +498,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist)
 	return 0;
 
 out_unmap:
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
-	}
+	__perf_evlist__munmap(evlist);
 	return -1;
 }
 
@@ -533,12 +532,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist)
 	return 0;
 
 out_unmap:
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
-			munmap(evlist->mmap[thread].base, evlist->mmap_len);
-			evlist->mmap[thread].base = NULL;
-		}
-	}
+	__perf_evlist__munmap(evlist);
 	return -1;
 }
 
-- 
1.7.4

