Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2AaNUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:20:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2AaNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:20:28 -0500
Date: Tue, 31 Jan 2012 05:20:08 -0800
From: tip-bot for Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Message-ID: <tip-0bc8d20580af74c9a8a39c200e269261e5cded05@git.kernel.org>
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
In-Reply-To: <20120130044320.2384.73322.stgit@linux3>
References: <20120130044320.2384.73322.stgit@linux3>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add option resolving vmlinux path
Git-Commit-ID: 0bc8d20580af74c9a8a39c200e269261e5cded05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:20:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bc8d20580af74c9a8a39c200e269261e5cded05
Gitweb:     http://git.kernel.org/tip/0bc8d20580af74c9a8a39c200e269261e5cded05
Author:     Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
AuthorDate: Mon, 30 Jan 2012 13:43:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 18:13:07 -0200

perf script: Add option resolving vmlinux path

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
