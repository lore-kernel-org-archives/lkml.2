Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2L0JPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:15:02 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50609 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2L0JMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:30 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-14-50dc10fb4cd2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/10] perf sort: Fix --sort pid output
Date: Thu, 27 Dec 2012 18:11:40 +0900
Message-Id: <1356599507-14226-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The "pid" sort key prints "Command: Pid" output but it's misaligned.
It's because of the offset of 6 was added to the column length during
the calculation in order to reserve an space for Pid part but it isn't
honored when printed.  The output before this patch was like this:

  # Overhead  Command:  Pid      Shared Object
  # ........  .............  .................
  #
      99.70%        noploop:17814  noploop
       0.29%        noploop:17814  [kernel.kallsyms]
       0.01%        noploop:17814  ld-2.15.so

Fix it by subtracting 6 for printing comm part.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c2836eeafb5..8b6d70bd749b 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -60,7 +60,7 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s:%5d", width,
+	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
 			      self->thread->comm ?: "", self->thread->pid);
 }
 
-- 
1.7.11.7

