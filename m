Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab1COUFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:38964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab1COUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 04/12] perf symbol: Move sym_entry->skip to symbol->ignore
Date: Tue, 15 Mar 2011 17:04:53 -0300
Message-Id: <1300219501-15085-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300219501-15085-1-git-send-email-acme@infradead.org>
References: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

While going thru each of the sym_entry fields looking to reduce it to
the set of entries needed when in an active symbols list, 'skip' should
really be in symbol, as we set it when loading the symtab.

And the space used by the basic symbol allocation remains the same as
we had 5 bytes of padding.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    4 ++--
 tools/perf/util/symbol.h |    5 +++++
 tools/perf/util/top.h    |    1 -
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31ea7a6..70f1075 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -676,7 +676,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
-			syme->skip = 1;
+			sym->ignore = true;
 			break;
 		}
 	}
@@ -779,7 +779,7 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 
 	syme = symbol__priv(al.sym);
-	if (!syme->skip) {
+	if (!al.sym->ignore) {
 		struct perf_evsel *evsel;
 
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index db39c0c..713b0b4 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -48,12 +48,17 @@ char *strxfrchar(char *s, char from, char to);
 
 #define BUILD_ID_SIZE 20
 
+/** struct symbol - symtab entry
+ *
+ * @ignore - resolvable but tools ignore it (e.g. idle routines)
+ */
 struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
 	u64		end;
 	u16		namelen;
 	u8		binding;
+	bool		ignore;
 	char		name[0];
 };
 
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index ba111b2..bfbf95b 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -16,7 +16,6 @@ struct sym_entry {
 	struct list_head	node;
 	unsigned long		snap_count;
 	double			weight;
-	int			skip;
 	struct map		*map;
 	unsigned long		count[0];
 };
-- 
1.6.2.5

