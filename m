Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2HIW0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:26:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48322 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868Ab2HIWWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:22:18 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 02/16] perf symbol: remove unused 'end' arg in kallsyms parse cb
Date: Thu,  9 Aug 2012 15:18:27 -0700
Message-Id: <1344550721-21024-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080922-7282-0000-0000-00000BD31985
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/event.c  |  2 +-
 tools/perf/util/symbol.c | 21 ++++++++++-----------
 tools/perf/util/symbol.h |  2 +-
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
index df4736d..b2f7597 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -574,7 +574,7 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start, u64 end))
+					  char type, u64 start))
 {
 	char *line = NULL;
 	size_t n;
@@ -614,13 +614,8 @@ int kallsyms__parse(const char *filename, void *arg,
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
@@ -647,7 +642,7 @@ static u8 kallsyms2elf_type(char type)
 }
 
 static int map__process_kallsym_symbol(void *arg, const char *name,
-				       char type, u64 start, u64 end)
+				       char type, u64 start)
 {
 	struct symbol *sym;
 	struct process_kallsyms_args *a = arg;
@@ -656,8 +651,12 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 	if (!symbol_type__is_a(type, a->map->type))
 		return 0;
 
-	sym = symbol__new(start, end - start + 1,
-			  kallsyms2elf_type(type), name);
+	/*
+	 * module symbols are not sorted so we add all
+	 * symbols, setting length to 1, and rely on
+	 * symbols__fixup_end() to fix it up.
+	 */
+	sym = symbol__new(start, 1, kallsyms2elf_type(type), name);
 	if (sym == NULL)
 		return -ENOMEM;
 	/*
@@ -2528,7 +2527,7 @@ struct process_args {
 };
 
 static int symbol__in_kernel(void *arg, const char *name,
-			     char type __used, u64 start, u64 end __used)
+			     char type __used, u64 start)
 {
 	struct process_args *args = arg;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1fe733a..c8ec1d7 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -297,7 +297,7 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 int build_id__sprintf(const u8 *build_id, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start, u64 end));
+					  char type, u64 start));
 
 void machine__destroy_kernel_maps(struct machine *machine);
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
-- 
1.7.11.3

