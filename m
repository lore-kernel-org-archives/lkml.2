Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1HPOl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:41:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1HPOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:41:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf annotate: Make output more readable
Date: Tue, 16 Aug 2011 11:41:33 -0300
Message-Id: <1313505695-20724-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313505695-20724-1-git-send-email-acme@infradead.org>
References: <1313505695-20724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch adds two new options to perf annotate:
	- --no-asm-raw : Do not display raw instruction encodings
	- --no-source  : Do not interleave source code with assembly code

We believe those options make the output of annotate more readable.

Systematically displaying source can make it hard to follow code and
especially optimized code.

Raw encodings are not useful in most cases.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110517153207.GA9834@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
[committer note: Use the 'no-' option inverting logic]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    8 ++++++++
 tools/perf/builtin-annotate.c              |    4 ++++
 tools/perf/util/annotate.c                 |    5 ++++-
 tools/perf/util/symbol.c                   |    2 ++
 tools/perf/util/symbol.h                   |    4 +++-
 5 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 85c5f02..5bc0600 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -72,6 +72,14 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+--asm-raw::
+	Show raw instruction encoding of assembly instructions. They
+	are displayed by default, disable with --no-asm-raw.
+
+--source::
+	Interleave source code with assembly code. Enabled by default,
+	disable with --no-source.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 555aefd..5015e04 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -267,6 +267,10 @@ static const struct option options[] = {
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_BOOLEAN('0', "source", &symbol_conf.annotate_src,
+		    "Interleave source code with assembly code (default)"),
+	OPT_BOOLEAN('0', "asm-raw", &symbol_conf.annotate_asm_raw,
+		    "Display raw encoding of assembly instructions (default)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e01af2b..01d36ba 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -324,9 +324,12 @@ fallback:
 
 	snprintf(command, sizeof(command),
 		 "objdump --start-address=0x%016" PRIx64
-		 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
+		 " --stop-address=0x%016" PRIx64
+		 " -d %s %s -C %s|grep -v %s|expand",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
+		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
+		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
 
 	pr_debug("Executing: %s\n", command);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 469c026..245e60d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -46,6 +46,8 @@ struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
+	.annotate_asm_raw = true,
+	.annotate_src	  = true,
 	.symfs            = "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4f377d9..7733f0b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -76,7 +76,9 @@ struct symbol_conf {
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
-			kptr_restrict;
+			kptr_restrict,
+			annotate_asm_raw,
+			annotate_src;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.6.2.5

