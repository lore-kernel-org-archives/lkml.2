Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1GQJah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:30:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39346 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1GQJac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:30:32 -0400
X-AuditID: b753bd60-a467eba0000050a4-83-4e22abb6a050
X-AuditID: b753bd60-a467eba0000050a4-83-4e22abb6a050
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 6/6] perf script: add option resolving vmlinux path
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Sun, 17 Jul 2011 18:31:15 +0900
Message-ID: <20110717093115.3447.11599.stgit@linux3>
In-Reply-To: <20110717093031.3447.52715.stgit@linux3>
References: <20110717093031.3447.52715.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the option get the path of [kernel.kallsyms].
Specify '--show-kernel-path' option to use this function.
This patch enables other applications to use this output easily.

Without --show-kernel-path  option

# perf script -f ip,dso
ffffffff81467612 irq_return ([kernel.kallsyms])
ffffffff81467612 irq_return ([kernel.kallsyms])
    7f24fc02a6b3 _start (/lib64/ld-2.14.so)
[snip]

With --show-kernel-path option

# perf script -f ip,dso --show-kernel-path
ffffffff81467612 irq_return (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
ffffffff81467612 irq_return (/lib/modules/3.0.0-rc6-tip+/build/vmlinux)
    7f24fc02a6b3 _start (/lib64/ld-2.14.so)
[snip]

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/Documentation/perf-script.txt |    3 +++
 tools/perf/builtin-script.c              |    2 ++
 tools/perf/util/map.c                    |    7 +++++--
 tools/perf/util/session.c                |    2 ++
 tools/perf/util/symbol.c                 |    1 +
 tools/perf/util/symbol.h                 |    1 +
 6 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index ee4d477..5383671 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -188,6 +188,9 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+--show-kernel-path::
+	Try to resolve the path of [kernel.kallsyms]
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fd68185..0d04788 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1099,6 +1099,8 @@ static const struct option options[] = {
 		     "addr,offs",
 		     parse_output_fields),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_BOOLEAN('\0', "show-kernel-path", &show_kernel_path,
+		    "Show the path of [kernel.kallsyms]"),
 
 	OPT_END()
 };
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index dddc0f3..1645967 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -204,9 +204,12 @@ void map__print_dsoname(struct map *self)
 {
 	const char *dsoname;
 
-	if (self && self->dso && self->dso->name)
+	if (self && self->dso && (self->dso->name || self->dso->long_name)) {
+		if (show_kernel_path && self->dso->long_name)
+			dsoname = self->dso->long_name;
+		else if (self->dso->name)
 			dsoname = self->dso->name;
-	else
+	} else
 		dsoname = "[unknown]";
 
 	printf("%s", dsoname);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3728e67..34c5887 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,6 +14,8 @@
 #include "util.h"
 #include "cpumap.h"
 
+bool show_kernel_path;
+
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index abfecf6..3356d6e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -41,6 +41,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 			symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
+bool show_kernel_path;
 
 struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 554b2fe..88000e5 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -96,6 +96,7 @@ struct symbol_conf {
 };
 
 extern struct symbol_conf symbol_conf;
+extern bool show_kernel_path;
 
 static inline void *symbol__priv(struct symbol *sym)
 {

