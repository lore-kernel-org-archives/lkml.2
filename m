Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab0HDV0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:26:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab0HDV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:26:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf events: Fix mmap offset determination
Date: Wed,  4 Aug 2010 18:26:02 -0300
Message-Id: <1280957164-14274-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280957164-14274-1-git-send-email-acme@infradead.org>
References: <1280957164-14274-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

Fix buggy-looking code which unnecessarily adjusts the file offset
fields read from /proc/*/maps.

This may have gone unnoticed since the offset is usually 0 (and the
logic in util/symbol.c may work incorrectly for other offset values).

Commiter note:

This fixes a bug introduced in 4af8b35, there is no need to shift pgoff
twice, the show_map_vma routine in fs/proc/task_mmu.c already converts
it from the number of pages to the size in bytes, and that is what
appears in /proc/PID/map.

Cc: Anton Blanchard <anton@samba.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>
LKML-Reference: <1280836116-6654-2-git-send-email-dave.martin@linaro.org>
Signed-off-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6b0db55..db8a1d4 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -151,7 +151,6 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
-			u64 vm_pgoff;
 			char *execname = strchr(bf, '/');
 
 			/* Catch VDSO */
@@ -162,12 +161,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 				continue;
 
 			pbf += 3;
-			n = hex2u64(pbf, &vm_pgoff);
-			/* pgoff is in bytes, not pages */
-			if (n >= 0)
-				ev.mmap.pgoff = vm_pgoff << getpagesize();
-			else
-				ev.mmap.pgoff = 0;
+			n = hex2u64(pbf, &ev.mmap.pgoff);
 
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
-- 
1.6.2.5

