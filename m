Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab0HEIBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:01:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759674Ab0HEIBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:01:16 -0400
Date: Thu, 5 Aug 2010 08:00:46 GMT
From: tip-bot for Dave Martin <dave.martin@linaro.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        hpa@zytor.com, mingo@redhat.com, nicolas.pitre@linaro.org,
        tglx@linutronix.de, Will.Deacon@arm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        nicolas.pitre@linaro.org, tglx@linutronix.de, Will.Deacon@arm.com
In-Reply-To: <1280836116-6654-2-git-send-email-dave.martin@linaro.org>
References: <1280836116-6654-2-git-send-email-dave.martin@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Fix mmap offset determination
Message-ID: <tip-b5a6325464b700c4bdac8799c495970516eed41c@git.kernel.org>
Git-Commit-ID: b5a6325464b700c4bdac8799c495970516eed41c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 08:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5a6325464b700c4bdac8799c495970516eed41c
Gitweb:     http://git.kernel.org/tip/b5a6325464b700c4bdac8799c495970516eed41c
Author:     Dave Martin <dave.martin@linaro.org>
AuthorDate: Tue, 3 Aug 2010 12:48:35 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Aug 2010 12:41:23 -0300

perf events: Fix mmap offset determination

Fix buggy-looking code which unnecessarily adjusts the file offset
fields read from /proc/*/maps.

This may have gone unnoticed since the offset is usually 0 (and the
logic in util/symbol.c may work incorrectly for other offset values).

Commiter note:

This fixes a bug introduced in 4af8b35, there is no need to shift pgoff
twice, the show_map_vma routine in fs/proc/task_mmu.c already converts
it from the number of pages to the size in bytes, and that is what
appears in /proc/PID/map.

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
