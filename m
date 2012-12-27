Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2L0JMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:12:33 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45445 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2L0JM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:29 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-0f-50dc10fb99a1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/10] perf sort: Move misplaced sort entry functions
Date: Thu, 27 Dec 2012 18:11:38 +0900
Message-Id: <1356599507-14226-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some functions are misplaced along with other entries.  Move them to a
right place so that it can be found together with related functions.

No functional change intended.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 119 +++++++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 59 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index dbaded90312c..ce5d40456c07 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -97,6 +97,16 @@ static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
 }
 
+struct sort_entry sort_comm = {
+	.se_header	= "Command",
+	.se_cmp		= sort__comm_cmp,
+	.se_collapse	= sort__comm_collapse,
+	.se_snprintf	= hist_entry__comm_snprintf,
+	.se_width_idx	= HISTC_COMM,
+};
+
+/* --sort dso */
+
 static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 {
 	struct dso *dso_l = map_l ? map_l->dso : NULL;
@@ -117,22 +127,38 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 	return strcmp(dso_name_l, dso_name_r);
 }
 
-struct sort_entry sort_comm = {
-	.se_header	= "Command",
-	.se_cmp		= sort__comm_cmp,
-	.se_collapse	= sort__comm_collapse,
-	.se_snprintf	= hist_entry__comm_snprintf,
-	.se_width_idx	= HISTC_COMM,
-};
-
-/* --sort dso */
-
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	return _sort__dso_cmp(left->ms.map, right->ms.map);
 }
 
+static int _hist_entry__dso_snprintf(struct map *map, char *bf,
+				     size_t size, unsigned int width)
+{
+	if (map && map->dso) {
+		const char *dso_name = !verbose ? map->dso->short_name :
+			map->dso->long_name;
+		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
+	}
+
+	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
+}
+
+static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return _hist_entry__dso_snprintf(self->ms.map, bf, size, width);
+}
+
+struct sort_entry sort_dso = {
+	.se_header	= "Shared Object",
+	.se_cmp		= sort__dso_cmp,
+	.se_snprintf	= hist_entry__dso_snprintf,
+	.se_width_idx	= HISTC_DSO,
+};
+
+/* --sort symbol */
 
 static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 			      u64 ip_l, u64 ip_r)
@@ -149,22 +175,24 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 	return (int64_t)(ip_r - ip_l);
 }
 
-static int _hist_entry__dso_snprintf(struct map *map, char *bf,
-				     size_t size, unsigned int width)
+static int64_t
+sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	if (map && map->dso) {
-		const char *dso_name = !verbose ? map->dso->short_name :
-			map->dso->long_name;
-		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
-	}
+	u64 ip_l, ip_r;
 
-	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
-}
+	if (!left->ms.sym && !right->ms.sym)
+		return right->level - left->level;
 
-static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width)
-{
-	return _hist_entry__dso_snprintf(self->ms.map, bf, size, width);
+	if (!left->ms.sym || !right->ms.sym)
+		return cmp_null(left->ms.sym, right->ms.sym);
+
+	if (left->ms.sym == right->ms.sym)
+		return 0;
+
+	ip_l = left->ms.sym->start;
+	ip_r = right->ms.sym->start;
+
+	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
 }
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
@@ -195,14 +223,6 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	return ret;
 }
 
-
-struct sort_entry sort_dso = {
-	.se_header	= "Shared Object",
-	.se_cmp		= sort__dso_cmp,
-	.se_snprintf	= hist_entry__dso_snprintf,
-	.se_width_idx	= HISTC_DSO,
-};
-
 static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 				    size_t size,
 				    unsigned int width __maybe_unused)
@@ -211,27 +231,6 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 					 self->level, bf, size, width);
 }
 
-/* --sort symbol */
-static int64_t
-sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	u64 ip_l, ip_r;
-
-	if (!left->ms.sym && !right->ms.sym)
-		return right->level - left->level;
-
-	if (!left->ms.sym || !right->ms.sym)
-		return cmp_null(left->ms.sym, right->ms.sym);
-
-	if (left->ms.sym == right->ms.sym)
-		return 0;
-
-	ip_l = left->ms.sym->start;
-	ip_r = right->ms.sym->start;
-
-	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
-}
-
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
@@ -343,6 +342,8 @@ struct sort_entry sort_cpu = {
 	.se_width_idx	= HISTC_CPU,
 };
 
+/* sort keys for branch stacks */
+
 static int64_t
 sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -357,13 +358,6 @@ static int hist_entry__dso_from_snprintf(struct hist_entry *self, char *bf,
 					 bf, size, width);
 }
 
-struct sort_entry sort_dso_from = {
-	.se_header	= "Source Shared Object",
-	.se_cmp		= sort__dso_from_cmp,
-	.se_snprintf	= hist_entry__dso_from_snprintf,
-	.se_width_idx	= HISTC_DSO_FROM,
-};
-
 static int64_t
 sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -423,6 +417,13 @@ static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
 
 }
 
+struct sort_entry sort_dso_from = {
+	.se_header	= "Source Shared Object",
+	.se_cmp		= sort__dso_from_cmp,
+	.se_snprintf	= hist_entry__dso_from_snprintf,
+	.se_width_idx	= HISTC_DSO_FROM,
+};
+
 struct sort_entry sort_dso_to = {
 	.se_header	= "Target Shared Object",
 	.se_cmp		= sort__dso_to_cmp,
-- 
1.7.11.7

