Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab2F0TVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:21:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37269 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2F0TVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:21:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/7] perf evsel: Fix a build failure on cross compilation
Date: Wed, 27 Jun 2012 16:20:48 -0300
Message-Id: <1340824854-3005-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340824854-3005-1-git-send-email-acme@infradead.org>
References: <1340824854-3005-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit c410431cefefd ("perf tools: Reconstruct event with modifiers
from perf_event_attr") added the line, but it's broken since it needs to
go up 3 directories to get to the kernel root directory, not 2.

However host gcc contains /usr/local/include in its search path, so that
it can find the perf_event.h in /usr/include. This why we didn't notice
the problem yet.  But when I tried to cross compile it appears like:

      CC util/evsel.o
  util/evsel.c:18:44: error: ../../include/linux/perf_event.h: No such file or directory
  make: *** [util/evsel.o] Error 1

Looking at the source, it isn't needed at all as evsel.h already
included the perf_event.h. So simply remove it would solve the problem.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340268772-5737-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 876f639..3d1f696 100644
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
1.7.1

