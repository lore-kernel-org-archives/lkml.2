Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab2HXJBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab2HXJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/13] perf test: Add attr tests under builtin test command
Date: Fri, 24 Aug 2012 11:00:44 +0200
Message-Id: <1345798844-27423-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test attr suite is run only if it's run under perf source
directory, because test attr files are not installed.

If run elsewhere, tests are ommited (notification is displayed)
and finished as successfull.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c   |  4 ++++
 tools/perf/perf.h           |  1 +
 tools/perf/util/test-attr.c | 14 ++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 381d5ab..f2d3c50 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1135,6 +1135,10 @@ static struct test {
 		.func = dso__test_data,
 	},
 	{
+		.desc = "Test perf attr",
+		.func = test_attr__run,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a67bb75..2039774 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -174,6 +174,7 @@ void test_attr__init(void);
 int  test_attr__open(struct perf_event_attr *attr,
 		     pid_t pid, int cpu, int group_fd,
 		     unsigned long flags);
+int test_attr__run(void);
 
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
diff --git a/tools/perf/util/test-attr.c b/tools/perf/util/test-attr.c
index dd83954..eb610f7 100644
--- a/tools/perf/util/test-attr.c
+++ b/tools/perf/util/test-attr.c
@@ -126,3 +126,17 @@ int test_attr__open(struct perf_event_attr *attr,
 
 	return fd;
 }
+
+int test_attr__run(void)
+{
+	struct stat st;
+	const char *run;
+
+	run = "python ./util/test-attr.py -d ./util/test-attr/ -p ./perf";
+
+	if (!lstat("./util/", &st))
+		return system(run);
+
+	fprintf(stderr, " (ommitted)");
+	return 0;
+}
-- 
1.7.11.4

