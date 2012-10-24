Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422738Ab2JXVvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:51:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:40977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422707Ab2JXVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:51:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/12] perf test: Align the 'Ok'/'FAILED!' test results
Date: Wed, 24 Oct 2012 19:50:17 -0200
Message-Id: <1351115423-9025-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And also print 'FAILED!' in red.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rkisq85w24il3e2yl3nzumhu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index e2d9872d..a04276e 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -6,6 +6,7 @@
 #include "builtin.h"
 
 #include "util/cache.h"
+#include "util/color.h"
 #include "util/debug.h"
 #include "util/debugfs.h"
 #include "util/evlist.h"
@@ -1485,18 +1486,31 @@ static bool perf_test__matches(int curr, int argc, const char *argv[])
 static int __cmd_test(int argc, const char *argv[])
 {
 	int i = 0;
+	int width = 0;
 
 	while (tests[i].func) {
+		int len = strlen(tests[i].desc);
+
+		if (width < len)
+			width = len;
+		++i;
+	}
+		
+	i = 0;
+	while (tests[i].func) {
 		int curr = i++, err;
 
 		if (!perf_test__matches(curr, argc, argv))
 			continue;
 
-		pr_info("%2d: %s:", i, tests[curr].desc);
+		pr_info("%2d: %-*s:", i, width, tests[curr].desc);
 		pr_debug("\n--- start ---\n");
 		err = tests[curr].func();
 		pr_debug("---- end ----\n%s:", tests[curr].desc);
-		pr_info(" %s\n", err ? "FAILED!\n" : "Ok");
+		if (err)
+			color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
+		else
+			pr_info(" Ok\n");
 	}
 
 	return 0;
-- 
1.7.9.2.358.g22243

