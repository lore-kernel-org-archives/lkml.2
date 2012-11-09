Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2KIR3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:29:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab2KIR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:57 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 06/13] perf annotate: Factor out disasm__calc_percent()
Date: Sat, 10 Nov 2012 02:27:17 +0900
Message-Id: <1352482044-3443-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Factor out calculation of histogram of a symbol into
disasm__calc_percent.  It'll be used for event group view.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c |   52 +++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3a088a367c52..f985866304ff 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -635,6 +635,38 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
+static void disasm__calc_percent(struct symbol *sym, struct perf_evsel *evsel,
+				 s64 from, s64 to, const char **path,
+				 double *percent)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct source_line *src_line = notes->src->lines;
+	struct sym_hist *h;
+	unsigned int hits = 0;
+	s64 offset = from;
+
+	*percent = 0.0;
+
+	if (src_line) {
+		while (offset < to) {
+			if (*path == NULL)
+				*path = src_line[offset].path;
+
+			*percent += src_line[offset].percent;
+			++offset;
+		}
+	} else {
+		h = annotation__histogram(notes, evsel->idx);
+
+		while (offset < to) {
+			hits += h->addr[offset];
+		}
+
+		if (h->sum)
+			*percent = 100.0 * hits / h->sum;
+	}
+}
+
 static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 start,
 		      struct perf_evsel *evsel, u64 len, int min_pcnt, int printed,
 		      int max_lines, struct disasm_line *queue)
@@ -644,32 +676,18 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 	if (dl->offset != -1) {
 		const char *path = NULL;
-		unsigned int hits = 0;
 		double percent = 0.0;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				if (path == NULL)
-					path = src_line[offset].path;
-				percent += src_line[offset].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
-		}
-
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
+		disasm__calc_percent(sym, evsel, offset,
+				     next ? next->offset : (s64) len,
+				     &path, &percent);
 
 		if (percent < min_pcnt)
 			return -1;
-- 
1.7.9.2

