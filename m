Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0HCLs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:48:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52235 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab0HCLs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:48:58 -0400
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, kernel-team@lists.ubuntu.com,
        Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 1/2] perf events: Fix mmap offset determination
Date: Tue,  3 Aug 2010 12:48:35 +0100
Message-Id: <1280836116-6654-2-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
References: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix buggy-looking code which unnecessarily adjusts the file offset
fields read from /proc/*/maps.

This may have gone unnoticed since the offset is usually 0 (and the
logic in util/symbol.c may work incorrectly for other offset values).

I make assumptions about the intended design here.  The cover note
accompanying this patch contains a more detailed explanation.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
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
1.7.0.4

