Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1LSNk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:40:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19111 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab1LSNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:40:30 -0500
From: Nelson Elhage <nelhage@nelhage.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@nelhage.com>
Subject: [PATCH 1/3] perf: __perf_evlist__mmap: Fix errno value on failed map.
Date: Mon, 19 Dec 2011 08:39:30 -0500
Message-Id: <1324301972-22740-2-git-send-email-nelhage@nelhage.com>
X-Mailer: git-send-email 1.7.4.41.g50b8f
In-Reply-To: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
References: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EEF3EA5.011F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On failure, perf_evlist__mmap_per_{cpu,thread} will try to munmap()
every map that doesn't have a NULL base. This will fail with EINVAL if
one of them has base == MAP_FAILED, clobbering errno, so that
perf_evlist__map will return EINVAL on any failure regardless of the
root cause.

Fix this by resetting failed maps to a NULL base.

Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
---
 tools/perf/util/evlist.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index fbb4b4a..271c849 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -298,8 +298,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
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
1.7.4.41.g50b8f

