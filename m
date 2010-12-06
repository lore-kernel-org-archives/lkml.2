Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0LFU2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:28:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:58320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab0LFU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:28:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Chris Samuel <chris@csamuel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf tools: Catch a few uncheck calloc/malloc's
Date: Mon,  6 Dec 2010 18:28:18 -0200
Message-Id: <1291667298-7238-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291667298-7238-1-git-send-email-acme@infradead.org>
References: <1291667298-7238-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Samuel <chris@csamuel.org>

There were a few stray calloc()'s and malloc()'s which were not having
their return values checked for success.

As the calling code either already coped with failure or didn't actually
care we just return -ENOMEM at that point.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Chris Samuel <chris@csamuel.org>
LKML-Reference: <4CDDF95A.1050400@csamuel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c      |    3 +++
 tools/perf/builtin-lock.c      |    3 +++
 tools/perf/builtin-sched.c     |    3 +++
 tools/perf/builtin-timechart.c |    3 +++
 tools/perf/util/header.c       |    3 +++
 5 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index d0a652e..c9620ff 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -736,6 +736,9 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = strdup(record_args[i]);
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 92d3da5..b41b449 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -943,6 +943,9 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = strdup(record_args[i]);
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 73d1e30..c775394 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1860,6 +1860,9 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
+	if (rec_argv)
+		return -ENOMEM;
+
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = strdup(record_args[i]);
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 1f158dc..d2fc461 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -989,6 +989,9 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = strdup(record_args[i]);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 073f0e1..76e949a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1005,6 +1005,9 @@ int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 
 	ev = malloc(size);
 
+	if (ev == NULL)
+		return -ENOMEM;
+
 	ev->attr.attr = *attr;
 	memcpy(ev->attr.id, id, ids * sizeof(u64));
 
-- 
1.6.2.5

