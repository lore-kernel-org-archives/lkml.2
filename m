Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761Ab2JYICz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:02:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2JYICv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:02:51 -0400
Date: Thu, 25 Oct 2012 01:02:29 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rkisq85w24il3e2yl3nzumhu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Align the 'Ok'/'FAILED!' test results
Git-Commit-ID: 9a8e85ad0b61ec0720df7d24392163c2a12626d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 01:02:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a8e85ad0b61ec0720df7d24392163c2a12626d0
Gitweb:     http://git.kernel.org/tip/9a8e85ad0b61ec0720df7d24392163c2a12626d0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 24 Oct 2012 15:44:41 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 15:44:41 -0200

perf test: Align the 'Ok'/'FAILED!' test results

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
 1 files changed, 16 insertions(+), 2 deletions(-)

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
