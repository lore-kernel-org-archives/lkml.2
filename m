Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2DPUeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:34:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37251 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab2DPUeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:34:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf report: Fix crash showing warning related to kernel maps
Date: Mon, 16 Apr 2012 17:29:06 -0300
Message-Id: <1334608147-30588-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334608147-30588-1-git-send-email-acme@infradead.org>
References: <1334608147-30588-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

While testing https://lkml.org/lkml/2012/4/10/123 I hit this crash:

(gdb) bt
 0  0x000000000042000f in __cmd_report (rep=0x7fff80cec580) at builtin-report.c:380
 1  cmd_report (argc=0, argv=<optimized out>, prefix=<optimized out>) at builtin-report.c:759
 2  0x0000000000414513 in run_builtin (p=0x7724a8, argc=3, argv=0x7fff80ceca70) at perf.c:273
 3  0x0000000000413d41 in handle_internal_command (argv=0x7fff80ceca70, argc=3) at perf.c:345
 4  run_argv (argv=0x7fff80cec880, argcp=0x7fff80cec88c) at perf.c:389
 5  main (argc=3, argv=0x7fff80ceca70) at perf.c:487

kernel_map can be NULL, so need to handle it while dumping a warning
to user.

v2:
- fixed RB_EMPTY_ROOT check -- desc takes the altnerative output when RB_EMPTY_ROOT is false.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/1334544855-55021-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2e31743..cdae9b2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -374,16 +374,23 @@ static int __cmd_report(struct perf_report *rep)
 	    (kernel_map->dso->hit &&
 	     (kernel_kmap->ref_reloc_sym == NULL ||
 	      kernel_kmap->ref_reloc_sym->addr == 0))) {
-		const struct dso *kdso = kernel_map->dso;
+		const char *desc =
+		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
+		    "can't be resolved.";
+
+		if (kernel_map) {
+			const struct dso *kdso = kernel_map->dso;
+			if (!RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
+				desc = "If some relocation was applied (e.g. "
+				       "kexec) symbols may be misresolved.";
+			}
+		}
 
 		ui__warning(
 "Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
 "Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
 "Samples in kernel modules can't be resolved as well.\n\n",
-			    RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION]) ?
-"As no suitable kallsyms nor vmlinux was found, kernel samples\n"
-"can't be resolved." :
-"If some relocation was applied (e.g. kexec) symbols may be misresolved.");
+		desc);
 	}
 
 	if (dump_trace) {
-- 
1.7.9.2.358.g22243

