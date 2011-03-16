Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1CPNxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:53:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:32946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1CPNx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:53:28 -0400
Date: Wed, 16 Mar 2011 13:52:56 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbol: Move sym_entry->skip to symbol->ignore
Message-ID: <tip-171b3be9c42e97cd4530706654242f6a3efb6ac3@git.kernel.org>
Git-Commit-ID: 171b3be9c42e97cd4530706654242f6a3efb6ac3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:52:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  171b3be9c42e97cd4530706654242f6a3efb6ac3
Gitweb:     http://git.kernel.org/tip/171b3be9c42e97cd4530706654242f6a3efb6ac3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Mar 2011 13:36:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Mar 2011 13:36:01 -0300

perf symbol: Move sym_entry->skip to symbol->ignore

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
