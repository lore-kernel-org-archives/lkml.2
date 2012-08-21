Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2HUQIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:08:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab2HUQH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:07:57 -0400
Date: Tue, 21 Aug 2012 09:01:30 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-82151520938ec79e5e3adb7e61977f002031c38c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-3-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-3-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Remove unused 'end'
  arg in kallsyms parse cb
Git-Commit-ID: 82151520938ec79e5e3adb7e61977f002031c38c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:01:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82151520938ec79e5e3adb7e61977f002031c38c
Gitweb:     http://git.kernel.org/tip/82151520938ec79e5e3adb7e61977f002031c38c
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:48 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:10:31 -0300

perf symbols: Remove unused 'end' arg in kallsyms parse cb

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
 
