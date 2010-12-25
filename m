Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0LYI62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 03:58:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:51238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0LYI61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 03:58:27 -0500
Date: Sat, 25 Dec 2010 08:57:51 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Improve kallsyms symbol end addr calculation
Message-ID: <tip-3b01a413c196c91040d41c86e5b56f76bb369f74@git.kernel.org>
Git-Commit-ID: 3b01a413c196c91040d41c86e5b56f76bb369f74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 25 Dec 2010 08:57:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b01a413c196c91040d41c86e5b56f76bb369f74
Gitweb:     http://git.kernel.org/tip/3b01a413c196c91040d41c86e5b56f76bb369f74
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 22 Dec 2010 01:08:36 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Dec 2010 20:31:45 -0200

perf symbols: Improve kallsyms symbol end addr calculation

For kallsyms we don't have the symbol address end, so we do an extra pass and
set the symbol end addr as being the start of the next minus one.

But this was being done just after we filtered the symbols of a
particular type (functions, variables), so the symbol end was sometimes
after what it really is.

Fixing up symbol end also was falling apart when we have symbol aliases,
then the end address of all but the last alias was being set to be
before its start.

Fix it up by checking for symbol aliases and making the kallsyms__parse
routine use the next symbol, whatever its type, as the limit for the
previous symbol, passing that end address to the callback.

This was detected by the 'perf test' synthetic paranoid regression
tests, fix it up so that even that case doesn't mislead us.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    3 +-
 tools/perf/util/symbol.c |   56 ++++++++++++++++++++++++++++++++++-----------
 tools/perf/util/symbol.h |    2 +-
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 183aedd..2302ec0 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -332,7 +332,8 @@ struct process_symbol_args {
 	u64	   start;
 };
 
-static int find_symbol_cb(void *arg, const char *name, char type, u64 start)
+static int find_symbol_cb(void *arg, const char *name, char type,
+			  u64 start, u64 end __used)
 {
 	struct process_symbol_args *args = arg;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 561db63..2ea1a2e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -22,6 +22,10 @@
 #include <limits.h>
 #include <sys/utsname.h>
 
+#ifndef KSYM_NAME_LEN
+#define KSYM_NAME_LEN 128
+#endif
+
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
 #endif
@@ -93,7 +97,7 @@ static void symbols__fixup_end(struct rb_root *self)
 		prev = curr;
 		curr = rb_entry(nd, struct symbol, rb_node);
 
-		if (prev->end == prev->start)
+		if (prev->end == prev->start && prev->end != curr->start)
 			prev->end = curr->start - 1;
 	}
 
@@ -426,16 +430,25 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-						     char type, u64 start))
+					  char type, u64 start, u64 end))
 {
 	char *line = NULL;
 	size_t n;
-	int err = 0;
+	int err = -1;
+	u64 prev_start = 0;
+	char prev_symbol_type = 0;
+	char *prev_symbol_name;
 	FILE *file = fopen(filename, "r");
 
 	if (file == NULL)
 		goto out_failure;
 
+	prev_symbol_name = malloc(KSYM_NAME_LEN);
+	if (prev_symbol_name == NULL)
+		goto out_close;
+
+	err = 0;
+
 	while (!feof(file)) {
 		u64 start;
 		int line_len, len;
@@ -455,14 +468,33 @@ int kallsyms__parse(const char *filename, void *arg,
 			continue;
 
 		symbol_type = toupper(line[len]);
-		symbol_name = line + len + 2;
+		len += 2;
+		symbol_name = line + len;
+		len = line_len - len;
 
-		err = process_symbol(arg, symbol_name, symbol_type, start);
-		if (err)
+		if (len >= KSYM_NAME_LEN) {
+			err = -1;
 			break;
+		}
+
+		if (prev_symbol_type) {
+			u64 end = start;
+			if (end != prev_start)
+				--end;
+			err = process_symbol(arg, prev_symbol_name,
+					     prev_symbol_type, prev_start, end);
+			if (err)
+				break;
+		}
+
+		memcpy(prev_symbol_name, symbol_name, len + 1);
+		prev_symbol_type = symbol_type;
+		prev_start = start;
 	}
 
+	free(prev_symbol_name);
 	free(line);
+out_close:
 	fclose(file);
 	return err;
 
@@ -484,7 +516,7 @@ static u8 kallsyms2elf_type(char type)
 }
 
 static int map__process_kallsym_symbol(void *arg, const char *name,
-				       char type, u64 start)
+				       char type, u64 start, u64 end)
 {
 	struct symbol *sym;
 	struct process_kallsyms_args *a = arg;
@@ -493,11 +525,8 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 	if (!symbol_type__is_a(type, a->map->type))
 		return 0;
 
-	/*
-	 * Will fix up the end later, when we have all symbols sorted.
-	 */
-	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
-
+	sym = symbol__new(start, end - start + 1,
+			  kallsyms2elf_type(type), name);
 	if (sym == NULL)
 		return -ENOMEM;
 	/*
@@ -650,7 +679,6 @@ int dso__load_kallsyms(struct dso *self, const char *filename,
 	if (dso__load_all_kallsyms(self, filename, map) < 0)
 		return -1;
 
-	symbols__fixup_end(&self->symbols[map->type]);
 	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
 		self->origin = DSO__ORIG_GUEST_KERNEL;
 	else
@@ -2162,7 +2190,7 @@ struct process_args {
 };
 
 static int symbol__in_kernel(void *arg, const char *name,
-			     char type __used, u64 start)
+			     char type __used, u64 start, u64 end __used)
 {
 	struct process_args *args = arg;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index bcd2f98..7b8c27b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -215,7 +215,7 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 int build_id__sprintf(const u8 *self, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start));
+					  char type, u64 start, u64 end));
 
 void machine__destroy_kernel_maps(struct machine *self);
 int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
