Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0DNRJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:09:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55689 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab0DNRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=TaMksJa8AWTCEGLGc2txIuUOdyJiWGDZv+n6OdCm5ax148oNpb4E3IP6B+pmMT5Q94
         dxunvZOIshEUyJG2xLCkSwYN66dJN5BsRAaX6qoAg10VPnkTxhiuskzReQ2leIiX83l+
         XtFiuCLWt3axQ1X/0Py63GZRild4m98aayBSM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] struct sort_entry has a callback named snprintf that turns an entry into a string result.
Date: Wed, 14 Apr 2010 19:09:36 +0200
Message-Id: <1271264976-1817-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20100414022800.GE25649@ghostprotocols.net>
References: <20100414022800.GE25649@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But there are glibc versions that implement snprintf through a
macro. The following expression is then going to get the snprintf
call preprocessed:

        ent->snprintf(...)

to finally end up in a build error:

        util/hist.c: Dans la fonction «hist_entry__snprintf» :
        util/hist.c:539: erreur: «struct sort_entry» has no member named «__builtin___snprintf_chk»

To fix this, prepend struct sort_entry callbacks with an "se_"
prefix.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/hist.c |   28 ++++++++++++++--------------
 tools/perf/util/sort.c |   42 +++++++++++++++++++++---------------------
 tools/perf/util/sort.h |   12 ++++++------
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 18cf8b3..9c2b874 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -68,7 +68,7 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->cmp(left, right);
+		cmp = se->se_cmp(left, right);
 		if (cmp)
 			break;
 	}
@@ -85,7 +85,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		int64_t (*f)(struct hist_entry *, struct hist_entry *);
 
-		f = se->collapse ?: se->cmp;
+		f = se->se_collapse ?: se->se_cmp;
 
 		cmp = f(left, right);
 		if (cmp)
@@ -536,8 +536,8 @@ int hist_entry__snprintf(struct hist_entry *self,
 			continue;
 
 		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->snprintf(self, s + ret, size - ret,
-				    se->width ? *se->width : 0);
+		ret += se->se_snprintf(self, s + ret, size - ret,
+				       se->se_width ? *se->se_width : 0);
 	}
 
 	return ret;
@@ -564,7 +564,7 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
 	if (sort__first_dimension == SORT_COMM) {
 		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
 							 typeof(*se), list);
-		left_margin = se->width ? *se->width : 0;
+		left_margin = se->se_width ? *se->se_width : 0;
 		left_margin -= thread__comm_len(self->thread);
 	}
 
@@ -615,22 +615,22 @@ size_t perf_session__fprintf_hists(struct rb_root *hists,
 		if (se->elide)
 			continue;
 		if (sep) {
-			fprintf(fp, "%c%s", *sep, se->header);
+			fprintf(fp, "%c%s", *sep, se->se_header);
 			continue;
 		}
-		width = strlen(se->header);
-		if (se->width) {
+		width = strlen(se->se_header);
+		if (se->se_width) {
 			if (symbol_conf.col_width_list_str) {
 				if (col_width) {
-					*se->width = atoi(col_width);
+					*se->se_width = atoi(col_width);
 					col_width = strchr(col_width, ',');
 					if (col_width)
 						++col_width;
 				}
 			}
-			width = *se->width = max(*se->width, width);
+			width = *se->se_width = max(*se->se_width, width);
 		}
-		fprintf(fp, "  %*s", width, se->header);
+		fprintf(fp, "  %*s", width, se->se_header);
 	}
 	fprintf(fp, "\n");
 
@@ -652,10 +652,10 @@ size_t perf_session__fprintf_hists(struct rb_root *hists,
 			continue;
 
 		fprintf(fp, "  ");
-		if (se->width)
-			width = *se->width;
+		if (se->se_width)
+			width = *se->se_width;
 		else
-			width = strlen(se->header);
+			width = strlen(se->se_header);
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9d24d4b..da30b30 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -30,38 +30,38 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width);
 
 struct sort_entry sort_thread = {
-	.header = "Command:  Pid",
-	.cmp	= sort__thread_cmp,
-	.snprintf = hist_entry__thread_snprintf,
-	.width	= &threads__col_width,
+	.se_header	= "Command:  Pid",
+	.se_cmp		= sort__thread_cmp,
+	.se_snprintf	= hist_entry__thread_snprintf,
+	.se_width	= &threads__col_width,
 };
 
 struct sort_entry sort_comm = {
-	.header		= "Command",
-	.cmp		= sort__comm_cmp,
-	.collapse	= sort__comm_collapse,
-	.snprintf	= hist_entry__comm_snprintf,
-	.width		= &comms__col_width,
+	.se_header	= "Command",
+	.se_cmp		= sort__comm_cmp,
+	.se_collapse	= sort__comm_collapse,
+	.se_snprintf	= hist_entry__comm_snprintf,
+	.se_width	= &comms__col_width,
 };
 
 struct sort_entry sort_dso = {
-	.header = "Shared Object",
-	.cmp	= sort__dso_cmp,
-	.snprintf = hist_entry__dso_snprintf,
-	.width	= &dsos__col_width,
+	.se_header	= "Shared Object",
+	.se_cmp		= sort__dso_cmp,
+	.se_snprintf	= hist_entry__dso_snprintf,
+	.se_width	= &dsos__col_width,
 };
 
 struct sort_entry sort_sym = {
-	.header = "Symbol",
-	.cmp	= sort__sym_cmp,
-	.snprintf = hist_entry__sym_snprintf,
+	.se_header	= "Symbol",
+	.se_cmp		= sort__sym_cmp,
+	.se_snprintf	= hist_entry__sym_snprintf,
 };
 
 struct sort_entry sort_parent = {
-	.header = "Parent symbol",
-	.cmp	= sort__parent_cmp,
-	.snprintf = hist_entry__parent_snprintf,
-	.width	= &parent_symbol__col_width,
+	.se_header	= "Parent symbol",
+	.se_cmp		= sort__parent_cmp,
+	.se_snprintf	= hist_entry__parent_snprintf,
+	.se_width	= &parent_symbol__col_width,
 };
 
 struct sort_dimension {
@@ -255,7 +255,7 @@ int sort_dimension__add(const char *tok)
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sd->entry->collapse)
+		if (sd->entry->se_collapse)
 			sort__need_collapse = 1;
 
 		if (sd->entry == &sort_parent) {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 6d7b4be..1d857aa 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -78,13 +78,13 @@ enum sort_type {
 struct sort_entry {
 	struct list_head list;
 
-	const char *header;
+	const char *se_header;
 
-	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
-	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
-	int	(*snprintf)(struct hist_entry *self, char *bf, size_t size,
-			    unsigned int width);
-	unsigned int *width;
+	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
+	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int	(*se_snprintf)(struct hist_entry *self, char *bf, size_t size,
+			       unsigned int width);
+	unsigned int *se_width;
 	bool	elide;
 };
 
-- 
1.6.2.3

