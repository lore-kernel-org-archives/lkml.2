Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab0DOHcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:32:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0DOHcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:32:00 -0400
Date: Thu, 15 Apr 2010 07:31:33 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100414223950.14630.42263.stgit@localhost6.localdomain6>
References: <20100414223950.14630.42263.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix line range to show end line
Message-ID: <tip-dda4ab34fe1905d3d590572b776dd92aa0866558@git.kernel.org>
Git-Commit-ID: dda4ab34fe1905d3d590572b776dd92aa0866558
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:31:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dda4ab34fe1905d3d590572b776dd92aa0866558
Gitweb:     http://git.kernel.org/tip/dda4ab34fe1905d3d590572b776dd92aa0866558
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 14 Apr 2010 18:39:50 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:41:30 -0300

perf probe: Fix line range to show end line

Line range should reject the range if the number of lines is 0
(e.g. "sched.c:1024+0"), and it should show the lines include
the end of line number (e.g. "sched.c:1024-2048" should show
2048th line).

LKML-Reference: <20100414223950.14630.42263.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 954ca21..5bf8ab0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -290,7 +290,7 @@ int show_line_range(struct line_range *lr)
 
 	if (lr->end == INT_MAX)
 		lr->end = l + NR_ADDITIONAL_LINES;
-	while (l < lr->end && !feof(fp) && ret >= 0)
+	while (l <= lr->end && !feof(fp) && ret >= 0)
 		ret = show_one_line(fp, (l++) - lr->offset, false, false);
 end:
 	fclose(fp);
@@ -341,9 +341,15 @@ int parse_line_range_desc(const char *arg, struct line_range *lr)
 	ptr = strchr(arg, ':');
 	if (ptr) {
 		lr->start = (int)strtoul(ptr + 1, &tmp, 0);
-		if (*tmp == '+')
+		if (*tmp == '+') {
 			lr->end = lr->start + (int)strtoul(tmp + 1, &tmp, 0);
-		else if (*tmp == '-')
+			lr->end--;	/*
+					 * Adjust the number of lines here.
+					 * If the number of lines == 1, the
+					 * the end of line should be equal to
+					 * the start of line.
+					 */
+		} else if (*tmp == '-')
 			lr->end = (int)strtoul(tmp + 1, &tmp, 0);
 		else
 			lr->end = INT_MAX;
