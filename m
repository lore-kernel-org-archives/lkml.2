Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2AaBYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:24:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:44361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2AaBYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf script: Add option resolving vmlinux path
Date: Mon, 30 Jan 2012 23:24:35 -0200
Message-Id: <1327973079-29426-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

Add the option get the path of [kernel.kallsyms].
Specify '--show-kernel-path' option to use this function.
This patch enables other applications to use this output easily.

Without --show-kernel-path  option

ffffffff81467612 irq_return ([kernel.kallsyms])
ffffffff81467612 irq_return ([kernel.kallsyms])
    7f24fc02a6b3 _start (/lib64/ld-2.14.so)
[snip]

With --show-kernel-path option

ffffffff81467612 irq_return (/lib/modules/3.2.0+/build/vmlinux)
ffffffff81467612 irq_return (/lib/modules/3.2.0+/build/vmlinux)
    7f24fc02a6b3 _start (/lib64/ld-2.14.so)
[snip]

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20120130044320.2384.73322.stgit@linux3
Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |    3 +++
 tools/perf/builtin-script.c              |    3 +++
 tools/perf/util/map.c                    |    9 ++++++---
 tools/perf/util/symbol.h                 |    1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 228c7bb..e9cbfcd 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -200,6 +200,9 @@ OPTIONS
 	It currently includes: cpu and numa topology of the host system.
 	It can only be used with the perf script report mode.
 
+--show-kernel-path::
+	Try to resolve the path of [kernel.kallsyms]
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 752d401..d4ce733 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1155,6 +1155,9 @@ static const struct option options[] = {
 		   "only display events for these comms"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
+	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
+		    "Show the path of [kernel.kallsyms]"),
+
 	OPT_END()
 };
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 1107960..dea6d1c 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -216,9 +216,12 @@ size_t map__fprintf_dsoname(struct map *map, FILE *fp)
 {
 	const char *dsoname;
 
-	if (map && map->dso && map->dso->name)
-		dsoname = map->dso->name;
-	else
+	if (map && map->dso && (map->dso->name || map->dso->long_name)) {
+		if (symbol_conf.show_kernel_path && map->dso->long_name)
+			dsoname = map->dso->long_name;
+		else if (map->dso->name)
+			dsoname = map->dso->name;
+	} else
 		dsoname = "[unknown]";
 
 	return fprintf(fp, "%s", dsoname);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ba909c9..2a683d4 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -70,6 +70,7 @@ struct symbol_conf {
 	unsigned short	priv_size;
 	unsigned short	nr_events;
 	bool		try_vmlinux_path,
+			show_kernel_path,
 			use_modules,
 			sort_by_name,
 			show_nr_samples,
-- 
1.7.9.rc2.1.g69204

