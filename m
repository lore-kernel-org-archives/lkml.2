Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235Ab2FVFlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:41:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43654 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761205Ab2FVFlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:24 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-73-4fe405837bab
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/8] perf evsel: Fix a build failure on cross compilation
Date: Fri, 22 Jun 2012 14:37:35 +0900
Message-Id: <1340343462-15556-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit c410431cefefd ("perf tools: Reconstruct event
with modifiers from perf_event_attr") added the line, but
it's broken since it needs to go up 3 directories to get
to the kernel root directory, not 2.

However host gcc contains /usr/local/include in its
search path, so that it can find the perf_event.h in
/usr/include/linux. This is why we didn't notice the
problem yet. But when I tried to cross compile, it
appears like:

      CC util/evsel.o
  util/evsel.c:18:44: error: ../../include/linux/perf_event.h: No such file or directory
  make: *** [util/evsel.o] Error 1

Looking at the source, it isn't needed at all as evsel.h
already included the perf_event.h. So simply removing it
would solve the problem.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 876f639d69ed..3d1f6968f175 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,7 +15,6 @@
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
-#include "../../include/linux/perf_event.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
-- 
1.7.10.2

