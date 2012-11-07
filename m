Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2KGH2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:28:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50186 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2KGH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:27:23 -0500
X-AuditID: 9c930179-b7c8bae000003559-66-509a0d5924b3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/6] perf tools: Set kernel data mapping length
Date: Wed,  7 Nov 2012 16:27:10 +0900
Message-Id: <1352273234-28912-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently only text (function) mapping was set, so that the kernel
data addresses couldn't parsed correctly.  Fix it.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 34d8dfeaa2b2..fc471704af12 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -84,15 +84,19 @@ int machine__process_lost_event(struct machine *machine __maybe_unused,
 static void machine__set_kernel_mmap_len(struct machine *machine,
 					 union perf_event *event)
 {
-	machine->vmlinux_maps[MAP__FUNCTION]->start = event->mmap.start;
-	machine->vmlinux_maps[MAP__FUNCTION]->end   = (event->mmap.start +
-						       event->mmap.len);
-	/*
-	 * Be a bit paranoid here, some perf.data file came with
-	 * a zero sized synthesized MMAP event for the kernel.
-	 */
-	if (machine->vmlinux_maps[MAP__FUNCTION]->end == 0)
-		machine->vmlinux_maps[MAP__FUNCTION]->end = ~0ULL;
+	int i;
+
+	for (i = 0; i < MAP__NR_TYPES; i++) {
+		machine->vmlinux_maps[i]->start = event->mmap.start;
+		machine->vmlinux_maps[i]->end   = (event->mmap.start +
+						   event->mmap.len);
+		/*
+		 * Be a bit paranoid here, some perf.data file came with
+		 * a zero sized synthesized MMAP event for the kernel.
+		 */
+		if (machine->vmlinux_maps[i]->end == 0)
+			machine->vmlinux_maps[i]->end = ~0ULL;
+	}
 }
 
 static int machine__process_kernel_mmap_event(struct machine *machine,
-- 
1.7.11.7

