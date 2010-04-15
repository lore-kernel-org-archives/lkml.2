Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0DOHbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:31:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:38267 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0DOHbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:31:49 -0400
Date: Thu, 15 Apr 2010 07:31:16 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100414223942.14630.72730.stgit@localhost6.localdomain6>
References: <20100414223942.14630.72730.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix a bug that --line range can be overflow
Message-ID: <tip-d3b63d7ae04879a817bac5c0bf09749f73629d32@git.kernel.org>
Git-Commit-ID: d3b63d7ae04879a817bac5c0bf09749f73629d32
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:31:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3b63d7ae04879a817bac5c0bf09749f73629d32
Gitweb:     http://git.kernel.org/tip/d3b63d7ae04879a817bac5c0bf09749f73629d32
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 14 Apr 2010 18:39:42 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:41:21 -0300

perf probe: Fix a bug that --line range can be overflow

Since line_finder.lno_s/e are signed int but line_range.start/end
are unsigned int, it is possible to be overflow when converting
line_range->start/end to line_finder->lno_s/e.
This changes line_range.start/end and line_list.line to signed int
and adds overflow checks when setting line_finder.lno_s/e.

LKML-Reference: <20100414223942.14630.72730.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |   23 ++++++++++++-----------
 tools/perf/util/probe-event.h  |    6 +++---
 tools/perf/util/probe-finder.c |   19 +++++++++----------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 6d43839..954ca21 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -189,7 +189,7 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 #define LINEBUF_SIZE 256
 #define NR_ADDITIONAL_LINES 2
 
-static int show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
+static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
 	const char *color = PERF_COLOR_BLUE;
@@ -198,7 +198,7 @@ static int show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 		goto error;
 	if (!skip) {
 		if (show_num)
-			fprintf(stdout, "%7u  %s", l, buf);
+			fprintf(stdout, "%7d  %s", l, buf);
 		else
 			color_fprintf(stdout, color, "         %s", buf);
 	}
@@ -231,7 +231,7 @@ error:
  */
 int show_line_range(struct line_range *lr)
 {
-	unsigned int l = 1;
+	int l = 1;
 	struct line_node *ln;
 	FILE *fp;
 	int fd, ret;
@@ -340,16 +340,15 @@ int parse_line_range_desc(const char *arg, struct line_range *lr)
 	 */
 	ptr = strchr(arg, ':');
 	if (ptr) {
-		lr->start = (unsigned int)strtoul(ptr + 1, &tmp, 0);
+		lr->start = (int)strtoul(ptr + 1, &tmp, 0);
 		if (*tmp == '+')
-			lr->end = lr->start + (unsigned int)strtoul(tmp + 1,
-								    &tmp, 0);
+			lr->end = lr->start + (int)strtoul(tmp + 1, &tmp, 0);
 		else if (*tmp == '-')
-			lr->end = (unsigned int)strtoul(tmp + 1, &tmp, 0);
+			lr->end = (int)strtoul(tmp + 1, &tmp, 0);
 		else
-			lr->end = 0;
-		pr_debug("Line range is %u to %u\n", lr->start, lr->end);
-		if (lr->end && lr->start > lr->end) {
+			lr->end = INT_MAX;
+		pr_debug("Line range is %d to %d\n", lr->start, lr->end);
+		if (lr->start > lr->end) {
 			semantic_error("Start line must be smaller"
 				       " than end line.\n");
 			return -EINVAL;
@@ -360,8 +359,10 @@ int parse_line_range_desc(const char *arg, struct line_range *lr)
 			return -EINVAL;
 		}
 		tmp = strndup(arg, (ptr - arg));
-	} else
+	} else {
 		tmp = strdup(arg);
+		lr->end = INT_MAX;
+	}
 
 	if (tmp == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index ab54929..e7ff0d0 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -74,15 +74,15 @@ struct perf_probe_event {
 /* Line number container */
 struct line_node {
 	struct list_head	list;
-	unsigned int		line;
+	int			line;
 };
 
 /* Line range */
 struct line_range {
 	char			*file;		/* File name */
 	char			*function;	/* Function name */
-	unsigned int		start;		/* Start line number */
-	unsigned int		end;		/* End line number */
+	int			start;		/* Start line number */
+	int			end;		/* End line number */
 	int			offset;		/* Start line offset */
 	char			*path;		/* Real path name */
 	struct list_head	line_list;	/* Visible lines */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e443e69..b4c9365 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -111,7 +111,7 @@ static int strtailcmp(const char *s1, const char *s2)
 /* Line number list operations */
 
 /* Add a line to line number list */
-static int line_list__add_line(struct list_head *head, unsigned int line)
+static int line_list__add_line(struct list_head *head, int line)
 {
 	struct line_node *ln;
 	struct list_head *p;
@@ -138,7 +138,7 @@ found:
 }
 
 /* Check if the line in line number list */
-static int line_list__has_line(struct list_head *head, unsigned int line)
+static int line_list__has_line(struct list_head *head, int line)
 {
 	struct line_node *ln;
 
@@ -1146,7 +1146,7 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 			if (lf->lr->path == NULL)
 				return -ENOMEM;
 		}
-		line_list__add_line(&lf->lr->line_list, (unsigned int)lineno);
+		line_list__add_line(&lf->lr->line_list, lineno);
 	}
 	/* Update status */
 	if (!list_empty(&lf->lr->line_list))
@@ -1179,10 +1179,12 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 		dwarf_decl_line(sp_die, &lr->offset);
 		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);
 		lf->lno_s = lr->offset + lr->start;
-		if (!lr->end)
+		if (lf->lno_s < 0)	/* Overflow */
+			lf->lno_s = INT_MAX;
+		lf->lno_e = lr->offset + lr->end;
+		if (lf->lno_e < 0)	/* Overflow */
 			lf->lno_e = INT_MAX;
-		else
-			lf->lno_e = lr->offset + lr->end;
+		pr_debug("New line range: %d to %d\n", lf->lno_s, lf->lno_e);
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
 		if (dwarf_func_inline(sp_die)) {
@@ -1244,10 +1246,7 @@ int find_line_range(int fd, struct line_range *lr)
 				ret = find_line_range_by_func(&lf);
 			else {
 				lf.lno_s = lr->start;
-				if (!lr->end)
-					lf.lno_e = INT_MAX;
-				else
-					lf.lno_e = lr->end;
+				lf.lno_e = lr->end;
 				ret = find_line_range_by_line(NULL, &lf);
 			}
 		}
