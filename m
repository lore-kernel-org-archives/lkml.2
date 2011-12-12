Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1LLPRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1LLPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:41 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] perf evlist: Fix error handling on perf_event__mmap
Date: Tue, 13 Dec 2011 00:16:57 +0900
Message-Id: <1323703017-6060-9-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If mmap syscall fails for some reason, @evlist->mmap->base wil
have the value of MAP_FAILED. Since it is defined as -1, it'll
cause a subsequent munmap failure, so the original errno will
be lost. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/evlist.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8b19e7a1e881..5b7b3eeafb8d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -487,7 +487,9 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 
 out_unmap:
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
+		if (evlist->mmap[cpu].base == MAP_FAILED) {
+			evlist->mmap[cpu].base = NULL;
+		} else if (evlist->mmap[cpu].base != NULL) {
 			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
 			evlist->mmap[cpu].base = NULL;
 		}
@@ -526,7 +528,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 
 out_unmap:
 	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
+		if (evlist->mmap[thread].base == MAP_FAILED) {
+			evlist->mmap[thread].base = NULL;
+		} else if (evlist->mmap[thread].base != NULL) {
 			munmap(evlist->mmap[thread].base, evlist->mmap_len);
 			evlist->mmap[thread].base = NULL;
 		}
-- 
1.7.6

