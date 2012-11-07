Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2KGH11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:27:27 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50186 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2KGH1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:27:24 -0500
X-AuditID: 9c930179-b7c8bae000003559-6a-509a0d59a4a4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/6] perf tools: Fix detection of stack area
Date: Wed,  7 Nov 2012 16:27:11 +0900
Message-Id: <1352273234-28912-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Output of /proc/<pid>/maps contains helpful information to anonymous
mappings like stack, heap, ...  For the case of stack, it can show
multiple stack area for each thread in the process:

  $ cat /proc/$(pidof gnome-shell)/maps | grep stack
  7fe019946000-7fe01a146000 rw-p 00000000 00:00 0          [stack:1624]
  7fe040e32000-7fe041632000 rw-p 00000000 00:00 0          [stack:1451]
  7fe041643000-7fe041e43000 rw-p 00000000 00:00 0          [stack:1450]
  7fe04204b000-7fe04284b000 rw-p 00000000 00:00 0          [stack:1449]
  7fe042a7e000-7fe04327e000 rw-p 00000000 00:00 0          [stack:1446]
  7fe0432ff000-7fe043aff000 rw-p 00000000 00:00 0          [stack:1445]
  7fe043b00000-7fe044300000 rw-p 00000000 00:00 0          [stack:1444]
  7fe044301000-7fe044b01000 rw-p 00000000 00:00 0          [stack:1443]
  7fe044b02000-7fe045302000 rw-p 00000000 00:00 0          [stack:1442]
  7fe045303000-7fe045b03000 rw-p 00000000 00:00 0          [stack:1441]
  7fe045b04000-7fe046304000 rw-p 00000000 00:00 0          [stack:1440]
  7fe046305000-7fe046b05000 rw-p 00000000 00:00 0          [stack:1439]
  7fe046b06000-7fe047306000 rw-p 00000000 00:00 0          [stack:1438]
  7fff4b16f000-7fff4b190000 rw-p 00000000 00:00 0          [stack]

However perf only knew about the main thread's.  Fix it.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b40c444039c..579187865f08 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -24,7 +24,7 @@ static inline int is_anon_memory(const char *filename)
 
 static inline int is_no_dso_memory(const char *filename)
 {
-	return !strcmp(filename, "[stack]") ||
+	return !strncmp(filename, "[stack", 6) ||
 	       !strcmp(filename, "[heap]");
 }
 
-- 
1.7.11.7

