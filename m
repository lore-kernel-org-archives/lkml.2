Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2AaNTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:19:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2AaNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:19:42 -0500
Date: Tue, 31 Jan 2012 05:19:20 -0800
From: tip-bot for Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Message-ID: <tip-a978f2ab4166a84c77d0f846f59690f2a892d058@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, akihiro.nagai.hw@hitachi.com,
        peterz@infradead.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        akihiro.nagai.hw@hitachi.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120130044314.2384.67094.stgit@linux3>
References: <20120130044314.2384.67094.stgit@linux3>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add the offset field specifier
Git-Commit-ID: a978f2ab4166a84c77d0f846f59690f2a892d058
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:19:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a978f2ab4166a84c77d0f846f59690f2a892d058
Gitweb:     http://git.kernel.org/tip/a978f2ab4166a84c77d0f846f59690f2a892d058
Author:     Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
AuthorDate: Mon, 30 Jan 2012 13:43:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 18:09:21 -0200

perf script: Add the offset field specifier

Add the offset field specifier 'symoff' to show the offset from
the symbols in the output of perf-script. We can get the more
detailed address information.

Output sample:
ffffffff81467612 irq_return+0x0 => 301ec016b0 _start+0x0
ffffffff81467612 irq_return+0x0 => 301ec016b0 _start+0x0
      301ec016b3 _start+0x3     => 301ec04b70 _dl_start+0x0
ffffffff81467612 irq_return+0x0 => 301ec04b70 _dl_start+0x0
ffffffff81467612 irq_return+0x0 => 301ec04b96 _dl_start+0x26
ffffffff81467612 irq_return+0x0 => 301ec04b9d _dl_start+0x2d
      301ec04beb _dl_start+0x7b => 301ec04c0d _dl_start+0x9d
      301ec04c11 _dl_start+0xa1 => 301ec04bf0 _dl_start+0x80
[snip]

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20120130044314.2384.67094.stgit@linux3
Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |    2 +-
 tools/perf/builtin-script.c              |   23 +++++++++++++++++++----
 tools/perf/util/session.c                |    8 ++++++--
 tools/perf/util/session.h                |    2 +-
 tools/perf/util/symbol.c                 |   26 ++++++++++++++++++--------
 tools/perf/util/symbol.h                 |    2 ++
 6 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 2f6cef4..228c7bb 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr.
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 414d49a..752d401 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -40,6 +40,7 @@ enum perf_output_field {
 	PERF_OUTPUT_SYM             = 1U << 8,
 	PERF_OUTPUT_DSO             = 1U << 9,
 	PERF_OUTPUT_ADDR            = 1U << 10,
+	PERF_OUTPUT_SYMOFFSET       = 1U << 11,
 };
 
 struct output_option {
@@ -57,6 +58,7 @@ struct output_option {
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
 	{.str = "dso",   .field = PERF_OUTPUT_DSO},
 	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
+	{.str = "symoff", .field = PERF_OUTPUT_SYMOFFSET},
 };
 
 /* default set to maintain compatibility with current format */
@@ -193,6 +195,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		       "to symbols.\n");
 		return -EINVAL;
 	}
+	if (PRINT_FIELD(SYMOFFSET) && !PRINT_FIELD(SYM)) {
+		pr_err("Display of offsets requested but symbol is not"
+		       "selected.\n");
+		return -EINVAL;
+	}
 	if (PRINT_FIELD(DSO) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
 		pr_err("Display of DSO requested but neither sample IP nor "
 			   "sample address\nis selected. Hence, no addresses to convert "
@@ -353,7 +360,10 @@ static void print_sample_addr(union perf_event *event,
 
 	if (PRINT_FIELD(SYM)) {
 		printf(" ");
-		symbol__fprintf_symname(al.sym, stdout);
+		if (PRINT_FIELD(SYMOFFSET))
+			symbol__fprintf_symname_offs(al.sym, &al, stdout);
+		else
+			symbol__fprintf_symname(al.sym, stdout);
 	}
 
 	if (PRINT_FIELD(DSO)) {
@@ -378,7 +388,8 @@ static void print_sample_bts(union perf_event *event,
 		else
 			printf("\n");
 		perf_event__print_ip(event, sample, machine, evsel,
-				     PRINT_FIELD(SYM), PRINT_FIELD(DSO));
+				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
+				     PRINT_FIELD(SYMOFFSET));
 	}
 
 	printf(" => ");
@@ -421,7 +432,8 @@ static void process_event(union perf_event *event __unused,
 		else
 			printf("\n");
 		perf_event__print_ip(event, sample, machine, evsel,
-				     PRINT_FIELD(SYM), PRINT_FIELD(DSO));
+				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
+				     PRINT_FIELD(SYMOFFSET));
 	}
 
 	printf("\n");
@@ -1131,7 +1143,10 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
+		     "comma separated output fields prepend with 'type:'. "
+		     "Valid types: hw,sw,trace,raw. "
+		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
+		     "addr,symoff",
 		     parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		     "system-wide collection from all CPUs"),
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e5334a9..552c1c5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1293,7 +1293,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			  struct machine *machine, struct perf_evsel *evsel,
-			  int print_sym, int print_dso)
+			  int print_sym, int print_dso, int print_symoffset)
 {
 	struct addr_location al;
 	struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
@@ -1340,7 +1340,11 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 		printf("%16" PRIx64, sample->ip);
 		if (print_sym) {
 			printf(" ");
-			symbol__fprintf_symname(al.sym, stdout);
+			if (print_symoffset)
+				symbol__fprintf_symname_offs(al.sym, &al,
+							     stdout);
+			else
+				symbol__fprintf_symname(al.sym, stdout);
 		}
 
 		if (print_dso) {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 37bc383..c8d9017 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -147,7 +147,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			  struct machine *machine, struct perf_evsel *evsel,
-			  int print_sym, int print_dso);
+			  int print_sym, int print_dso, int print_symoffset);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b580fa8..fc6e12f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -263,16 +263,26 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 		       sym->name);
 }
 
-size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp)
+size_t symbol__fprintf_symname_offs(const struct symbol *sym,
+				    const struct addr_location *al, FILE *fp)
 {
-	const char *symname;
+	unsigned long offset;
+	size_t length;
 
-	if (sym && sym->name)
-		symname = sym->name;
-	else
-		symname = "[unknown]";
+	if (sym && sym->name) {
+		length = fprintf(fp, "%s", sym->name);
+		if (al) {
+			offset = al->addr - sym->start;
+			length += fprintf(fp, "+0x%lx", offset);
+		}
+		return length;
+	} else
+		return fprintf(fp, "[unknown]");
+}
 
-	return fprintf(fp, "%s", symname);
+size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp)
+{
+	return symbol__fprintf_symname_offs(sym, NULL, fp);
 }
 
 void dso__set_long_name(struct dso *dso, char *name)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d349c7a..ba909c9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -241,6 +241,8 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
+size_t symbol__fprintf_symname_offs(const struct symbol *sym,
+				    const struct addr_location *al, FILE *fp);
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
