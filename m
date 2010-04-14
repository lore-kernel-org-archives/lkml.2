Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0DNWdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:33:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab0DNWdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:33:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 4/6] perf probe: Fix line range to show end line
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Apr 2010 18:39:50 -0400
Message-ID: <20100414223950.14630.42263.stgit@localhost6.localdomain6>
In-Reply-To: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
References: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line range should reject the range if the number of lines is 0
(e.g. "sched.c:1024+0"), and it should show the lines include
the end of line number (e.g. "sched.c:1024-2048" should show
2048th line).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
