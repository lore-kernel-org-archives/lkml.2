Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab2DYNrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:47:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2DYNrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:47:18 -0400
Date: Wed, 25 Apr 2012 06:46:41 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-9e755756e4a22784abfb001688357745ea8ca97c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1334544855-55021-1-git-send-email-dsahern@gmail.com>
References: <1334544855-55021-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report:
  Fix crash showing warning related to kernel maps
Git-Commit-ID: 9e755756e4a22784abfb001688357745ea8ca97c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:46:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e755756e4a22784abfb001688357745ea8ca97c
Gitweb:     http://git.kernel.org/tip/9e755756e4a22784abfb001688357745ea8ca97c
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 15 Apr 2012 20:54:15 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Apr 2012 11:18:22 -0300

perf report: Fix crash showing warning related to kernel maps

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
 1 files changed, 12 insertions(+), 5 deletions(-)

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
