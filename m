Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2KIVng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/21] perf machine: Set kernel data mapping length
Date: Fri,  9 Nov 2012 18:42:50 -0300
Message-Id: <1352497390-17716-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently only text (function) mapping was set, so that the kernel data
addresses couldn't parsed correctly.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352273234-28912-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 502eec0..4c6754a 100644
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
1.7.9.2.358.g22243

