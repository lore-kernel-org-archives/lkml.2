Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1LTTSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:18:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1LTTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@nelhage.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf evlist: Fix errno value reporting on failed mmap
Date: Tue, 20 Dec 2011 17:18:05 -0200
Message-Id: <1324408691-28296-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@nelhage.com>

On failure, perf_evlist__mmap_per_{cpu,thread} will try to munmap()
every map that doesn't have a NULL base. This will fail with EINVAL if
one of them has base == MAP_FAILED, clobbering errno, so that
perf_evlist__map will return EINVAL on any failure regardless of the
root cause.

Fix this by resetting failed maps to a NULL base.

Acked-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1324301972-22740-2-git-send-email-nelhage@nelhage.com
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8b19e7a..963d63d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -447,8 +447,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 	evlist->mmap[idx].mask = mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED)
+	if (evlist->mmap[idx].base == MAP_FAILED) {
+		evlist->mmap[idx].base = NULL;
 		return -1;
+	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
-- 
1.7.8.rc0.35.gee6df

