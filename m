Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1HRUNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:13:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:47018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab1HRUN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:13:27 -0400
Date: Thu, 18 Aug 2011 20:13:16 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-3e6a2a7f3b9d0e521bb3284573b696d0cbe1952c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110517153207.GA9834@quad>
References: <20110517153207.GA9834@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Make output more readable
Git-Commit-ID: 3e6a2a7f3b9d0e521bb3284573b696d0cbe1952c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:13:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e6a2a7f3b9d0e521bb3284573b696d0cbe1952c
Gitweb:     http://git.kernel.org/tip/3e6a2a7f3b9d0e521bb3284573b696d0cbe1952c
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 17 May 2011 17:32:07 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:38:21 -0300

perf annotate: Make output more readable

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
