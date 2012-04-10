Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2DJQPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:15:35 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55835 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2DJQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:15:34 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, eranian@google.com,
        namhyung.kim@lge.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf report: fix crash showing warning related to kernel maps
Date: Tue, 10 Apr 2012 10:15:26 -0600
Message-Id: <1334074526-67905-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-report.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2e31743..002c644 100644
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
+			if (RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
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
1.7.5.4

