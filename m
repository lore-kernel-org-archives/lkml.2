Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0LGG6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:58:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:53522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0LGG6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:58:14 -0500
Date: Tue, 7 Dec 2010 06:57:46 GMT
From: tip-bot for Chris Samuel <chris@csamuel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        chris@csamuel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        chris@csamuel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4CDDF95A.1050400@csamuel.org>
References: <4CDDF95A.1050400@csamuel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Catch a few uncheck calloc/malloc's
Message-ID: <tip-ce47dc56a2241dc035160a85bc5e34283cdd622c@git.kernel.org>
Git-Commit-ID: ce47dc56a2241dc035160a85bc5e34283cdd622c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 06:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce47dc56a2241dc035160a85bc5e34283cdd622c
Gitweb:     http://git.kernel.org/tip/ce47dc56a2241dc035160a85bc5e34283cdd622c
Author:     Chris Samuel <chris@csamuel.org>
AuthorDate: Sat, 13 Nov 2010 13:35:06 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Dec 2010 12:52:35 -0200

perf tools: Catch a few uncheck calloc/malloc's

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
 
