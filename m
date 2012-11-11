Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2KKOVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 09:21:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45628 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2KKOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 09:21:21 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf tools: Synthesize data mmap events for threads
Date: Sun, 11 Nov 2012 23:20:51 +0900
Message-Id: <1352643651-13891-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352643651-13891-1-git-send-email-namhyung@kernel.org>
References: <1352643651-13891-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current perf_event__synthesize_mmap_events() only deals with
executable mappings.  With recently added memory access sampling,
non-executable data mappings are needed also.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3cf2c3e0605f..06e4d57a9e29 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -210,11 +210,15 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.start, &event->mmap.len, prot,
 		       &event->mmap.pgoff, execname);
 
-		if (prot[2] != 'x')
-			continue;
+		if (prot[2] == 'x' && !strcmp(execname, ""))
+			strcpy(execname, anonstr);
 
+		/* ignore non-executable anon mappings */
 		if (!strcmp(execname, ""))
-			strcpy(execname, anonstr);
+			continue;
+
+		if (prot[2] != 'x')
+			event->header.misc |= PERF_RECORD_MISC_MMAP_USER;
 
 		size = strlen(execname) + 1;
 		memcpy(event->mmap.filename, execname, size);
-- 
1.7.9.2

