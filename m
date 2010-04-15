Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0DOHch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:32:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:38362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab0DOHcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:32:33 -0400
Date: Thu, 15 Apr 2010 07:32:07 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100414224007.14630.96915.stgit@localhost6.localdomain6>
References: <20100414224007.14630.96915.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Show function entry line as probe-able
Message-ID: <tip-f6c903f5856ffa75ae19dcee4dbb5093e320d45c@git.kernel.org>
Git-Commit-ID: f6c903f5856ffa75ae19dcee4dbb5093e320d45c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:32:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6c903f5856ffa75ae19dcee4dbb5093e320d45c
Gitweb:     http://git.kernel.org/tip/f6c903f5856ffa75ae19dcee4dbb5093e320d45c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 14 Apr 2010 18:40:07 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:45:39 -0300

perf probe: Show function entry line as probe-able

Function entry line should be shown as probe-able line,
because each function has declared line attribute.

LKML-Reference: <20100414224007.14630.96915.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   74 ++++++++++++++++++++++++++++++++++------
 1 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 03b4691..3e79775 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1127,6 +1127,45 @@ end:
 	return ret;
 }
 
+/* Add a line and store the src path */
+static int line_range_add_line(const char *src, unsigned int lineno,
+			       struct line_range *lr)
+{
+	/* Copy real path */
+	if (!lr->path) {
+		lr->path = strdup(src);
+		if (lr->path == NULL)
+			return -ENOMEM;
+	}
+	return line_list__add_line(&lr->line_list, lineno);
+}
+
+/* Search function declaration lines */
+static int line_range_funcdecl_cb(Dwarf_Die *sp_die, void *data)
+{
+	struct dwarf_callback_param *param = data;
+	struct line_finder *lf = param->data;
+	const char *src;
+	int lineno;
+
+	src = dwarf_decl_file(sp_die);
+	if (src && strtailcmp(src, lf->fname) != 0)
+		return DWARF_CB_OK;
+
+	if (dwarf_decl_line(sp_die, &lineno) != 0 ||
+	    (lf->lno_s > lineno || lf->lno_e < lineno))
+		return DWARF_CB_OK;
+
+	param->retval = line_range_add_line(src, lineno, lf->lr);
+	return DWARF_CB_OK;
+}
+
+static int find_line_range_func_decl_lines(struct line_finder *lf)
+{
+	struct dwarf_callback_param param = {.data = (void *)lf, .retval = 0};
+	dwarf_getfuncs(&lf->cu_die, line_range_funcdecl_cb, &param, 0);
+	return param.retval;
+}
 
 /* Find line range from its line number */
 static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
@@ -1135,7 +1174,7 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 	Dwarf_Line *line;
 	size_t nlines, i;
 	Dwarf_Addr addr;
-	int lineno;
+	int lineno, ret = 0;
 	const char *src;
 	Dwarf_Die die_mem;
 
@@ -1145,6 +1184,7 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 		return -ENOENT;
 	}
 
+	/* Search probable lines on lines list */
 	for (i = 0; i < nlines; i++) {
 		line = dwarf_onesrcline(lines, i);
 		if (dwarf_lineno(line, &lineno) != 0 ||
@@ -1167,22 +1207,34 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 		if (strtailcmp(src, lf->fname) != 0)
 			continue;
 
-		/* Copy real path */
-		if (!lf->lr->path) {
-			lf->lr->path = strdup(src);
-			if (lf->lr->path == NULL)
-				return -ENOMEM;
-		}
-		line_list__add_line(&lf->lr->line_list, lineno);
+		ret = line_range_add_line(src, lineno, lf->lr);
+		if (ret < 0)
+			return ret;
 	}
+
+	/*
+	 * Dwarf lines doesn't include function declarations. We have to
+	 * check functions list or given function.
+	 */
+	if (sp_die) {
+		src = dwarf_decl_file(sp_die);
+		if (src && dwarf_decl_line(sp_die, &lineno) == 0 &&
+		    (lf->lno_s <= lineno && lf->lno_e >= lineno))
+			ret = line_range_add_line(src, lineno, lf->lr);
+	} else
+		ret = find_line_range_func_decl_lines(lf);
+
 	/* Update status */
-	if (!list_empty(&lf->lr->line_list))
-		lf->found = 1;
+	if (ret >= 0)
+		if (!list_empty(&lf->lr->line_list))
+			ret = lf->found = 1;
+		else
+			ret = 0;	/* Lines are not found */
 	else {
 		free(lf->lr->path);
 		lf->lr->path = NULL;
 	}
-	return lf->found;
+	return ret;
 }
 
 static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
