Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2APF0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:26:22 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:44793 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2APF0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:26:19 -0500
X-AuditID: b753bd60-9f483ba000000655-5b-4f13b461b2ba
X-AuditID: b753bd60-9f483ba000000655-5b-4f13b461b2ba
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 5/5] perf script: add option resolving vmlinux path
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
Date: Mon, 16 Jan 2012 14:22:34 +0900
Message-ID: <20120116052234.2485.15256.stgit@linux3>
In-Reply-To: <20120116052146.2485.48349.stgit@linux3>
References: <20120116052146.2485.48349.stgit@linux3>
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
ffffffff81467612 irq_return (/lib/modules/3.2.0+/build/vmlinux)
ffffffff81467612 irq_return (/lib/modules/3.2.0+/build/vmlinux)
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
 tools/perf/builtin-script.c              |    3 +++
 tools/perf/util/map.c                    |    9 ++++++---
 tools/perf/util/symbol.h                 |    1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 477638a..818f6f7 100644
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
index e79ec7d..8e1d632 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1118,6 +1118,9 @@ static const struct option options[] = {
 		   "only display events for these comms"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
+	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
+		    "Show the path of [kernel.kallsyms]"),
+
 	OPT_END()
 };
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 4c95fac..9e47ba0 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -216,9 +216,12 @@ void map__print_dsoname(struct map *self)
 {
 	const char *dsoname;
 
-	if (self && self->dso && self->dso->name)
-		dsoname = self->dso->name;
-	else
+	if (self && self->dso && (self->dso->name || self->dso->long_name)) {
+		if (symbol_conf.show_kernel_path && self->dso->long_name)
+			dsoname = self->dso->long_name;
+		else if (self->dso->name)
+			dsoname = self->dso->name;
+	} else
 		dsoname = "[unknown]";
 
 	printf("%s", dsoname);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 280f477..cfb16ce 100644
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

