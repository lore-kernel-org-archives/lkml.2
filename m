Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2KIVno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2KIVn1 (ORCPT
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
Subject: [PATCH 02/21] perf tools: Fix detection of stack area
Date: Fri,  9 Nov 2012 18:42:51 -0300
Message-Id: <1352497390-17716-3-git-send-email-acme@infradead.org>
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352273234-28912-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b40c44..5791878 100644
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
1.7.9.2.358.g22243

