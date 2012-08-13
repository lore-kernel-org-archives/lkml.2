Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2HMSlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:41:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:45073 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab2HMSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/38] perf symbols: Remove unused 'end' arg in kallsyms parse cb
Date: Mon, 13 Aug 2012 15:37:08 -0300
Message-Id: <1344883039-13495-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

kallsyms__parse() takes a callback that is called on every discovered
symbol. As /proc/kallsyms does not supply symbol sizes, the callback was
simply called with end=start, faking the symbol size to 1.

All of the callbacks (there are 2) used in calls to kallsyms__parse()
are _only_ used as callbacks for kallsyms__parse().

Given that kallsyms__parse() lacks real information about what
end/length should be, don't make up a length in kallsyms__parse().
Instead have the callbacks handle guessing the length.

Also relocate a comment regarding symbol creation to the callback which
does symbol creation (kallsyms__parse() is not in general used to create
symbols).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-3-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    2 +-
 tools/perf/util/symbol.c |   21 ++++++++++-----------
 tools/perf/util/symbol.h |    2 +-
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2a6f33c..3a0f1a5 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -412,7 +412,7 @@ struct process_symbol_args {
 };
 
 static int find_symbol_cb(void *arg, const char *name, char type,
-			  u64 start, u64 end __used)
+			  u64 start)
 {
 	struct process_symbol_args *args = arg;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9f181a8..2127002 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -563,7 +563,7 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start, u64 end))
+					  char type, u64 start))
 {
 	char *line = NULL;
 	size_t n;
@@ -603,13 +603,8 @@ int kallsyms__parse(const char *filename, void *arg,
 			break;
 		}
 
-		/*
-		 * module symbols are not sorted so we add all
-		 * symbols, setting length to 1, and rely on
-		 * symbols__fixup_end() to fix it up.
-		 */
 		err = process_symbol(arg, symbol_name,
-				     symbol_type, start, start);
+				     symbol_type, start);
 		if (err)
 			break;
 	}
@@ -636,7 +631,7 @@ static u8 kallsyms2elf_type(char type)
 }
 
 static int map__process_kallsym_symbol(void *arg, const char *name,
-				       char type, u64 start, u64 end)
+				       char type, u64 start)
 {
 	struct symbol *sym;
 	struct process_kallsyms_args *a = arg;
@@ -645,8 +640,12 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 	if (!symbol_type__is_a(type, a->map->type))
 		return 0;
 
-	sym = symbol__new(start, end - start + 1,
-			  kallsyms2elf_type(type), name);
+	/*
+	 * module symbols are not sorted so we add all
+	 * symbols, setting length to 0, and rely on
+	 * symbols__fixup_end() to fix it up.
+	 */
+	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
 	if (sym == NULL)
 		return -ENOMEM;
 	/*
@@ -1729,7 +1728,7 @@ struct process_args {
 };
 
 static int symbol__in_kernel(void *arg, const char *name,
-			     char type __used, u64 start, u64 end __used)
+			     char type __used, u64 start)
 {
 	struct process_args *args = arg;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 38ccbbb..c9534fe 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -299,7 +299,7 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 int build_id__sprintf(const u8 *build_id, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start, u64 end));
+					  char type, u64 start));
 int filename__read_debuglink(const char *filename, char *debuglink,
 			     size_t size);
 
-- 
1.7.1

