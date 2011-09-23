Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1IWU3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:29:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1IWU3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:29:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Eric B Munson <emunson@mgebm.net>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/12] perf symbols: Synthesize anonymous mmap events
Date: Fri, 23 Sep 2011 17:26:21 -0300
Message-Id: <1316809586-28529-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

perf_event__synthesize_mmap_events does not create anonymous mmap events
even though the kernel does. As a result an already running application
with dynamically created code will not get profiled - all samples end up
in the unknown bucket.

This patch skips any entries with '[' in the name to avoid adding events
for special regions (eg the vsyscall page). All other executable mmaps
are assumed to be anonymous and an event is synthesized.

Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Link: http://lkml.kernel.org/r/20110830091506.60b51fe8@kryten
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3c1b8a6..437f8ca 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -169,12 +169,17 @@ static int perf_event__synthesize_mmap_events(union perf_event *event,
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
+			char anonstr[] = "//anon\n";
 			char *execname = strchr(bf, '/');
 
 			/* Catch VDSO */
 			if (execname == NULL)
 				execname = strstr(bf, "[vdso]");
 
+			/* Catch anonymous mmaps */
+			if ((execname == NULL) && !strstr(bf, "["))
+				execname = anonstr;
+
 			if (execname == NULL)
 				continue;
 
-- 
1.6.2.5

