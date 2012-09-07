Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab2IGGKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:10:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab2IGGKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:10:21 -0400
Date: Thu, 6 Sep 2012 23:10:08 -0700
From: tip-bot for Maciek Borzecki <maciek.borzecki@gmail.com>
Message-ID: <tip-7a4ec938857cf534270b23545495300fbac7f5de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, maciek.borzecki@gmail.com,
        hpa@zytor.com, mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, maciek.borzecki@gmail.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1346754750.16299.3.camel@localhost.localdomain>
References: <1346754750.16299.3.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow user to indicate path to objdump in command line
Git-Commit-ID: 7a4ec938857cf534270b23545495300fbac7f5de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:10:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a4ec938857cf534270b23545495300fbac7f5de
Gitweb:     http://git.kernel.org/tip/7a4ec938857cf534270b23545495300fbac7f5de
Author:     Maciek Borzecki <maciek.borzecki@gmail.com>
AuthorDate: Tue, 4 Sep 2012 12:32:30 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 19:41:55 -0300

perf tools: Allow user to indicate path to objdump in command line

When analyzing perf data from hosts of other architecture than one of
the local host it's useful to call objdump that is part of a toolchain
for that architecture. Instead of calling regular objdump, call one that
user specified in command line.

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1346754750.16299.3.camel@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    3 +++
 tools/perf/Documentation/perf-report.txt   |    3 +++
 tools/perf/builtin-annotate.c              |    2 ++
 tools/perf/builtin-report.c                |    2 ++
 tools/perf/util/annotate.c                 |    4 +++-
 tools/perf/util/annotate.h                 |    1 +
 6 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index c89f9e1..c8ffd9f 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -85,6 +85,9 @@ OPTIONS
 -M::
 --disassembler-style=:: Set disassembler style for objdump.
 
+--objdump=<path>::
+        Path to objdump binary.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 495210a..f4d91be 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -168,6 +168,9 @@ OPTIONS
 	branch stacks and it will automatically switch to the branch view mode,
 	unless --no-branch-stack is used.
 
+--objdump=<path>::
+        Path to objdump binary.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 67522cf..2f3f002 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -282,6 +282,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
+	OPT_STRING(0, "objdump", &objdump_path, "path",
+		   "objdump binary to use for disassembly and annotations"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d618253..1f8d11b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -638,6 +638,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "Show a column with the sum of periods"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
+	OPT_STRING(0, "objdump", &objdump_path, "path",
+		   "objdump binary to use for disassembly and annotations"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3a282c0..51ef69c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -17,6 +17,7 @@
 #include <pthread.h>
 
 const char 	*disassembler_style;
+const char	*objdump_path;
 
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
@@ -820,9 +821,10 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump %s%s --start-address=0x%016" PRIx64
+		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -d %s %s -C %s|grep -v %s|expand",
+		 objdump_path ? objdump_path : "objdump",
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 78a5692..a6d6bc5 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -152,5 +152,6 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 #endif
 
 extern const char	*disassembler_style;
+extern const char	*objdump_path;
 
 #endif	/* __PERF_ANNOTATE_H */
