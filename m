Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1E1PmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:42:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:50289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1E1Pl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:41:59 -0400
Date: Sat, 28 May 2011 15:41:46 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-cj2g81hn64wv2bipmqk4fy2m@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Don't stop if no kernel symtab is found
Git-Commit-ID: e4a338d05df93ab1ebf291aca1e753064319d301
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 15:41:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4a338d05df93ab1ebf291aca1e753064319d301
Gitweb:     http://git.kernel.org/tip/e4a338d05df93ab1ebf291aca1e753064319d301
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 27 May 2011 13:42:16 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 May 2011 16:02:29 -0300

perf top: Don't stop if no kernel symtab is found

We now just warn the user about the fact and go on providing just
userspace samples.

This fixes a problem when no vmlinux is explicetely passed by the user,
thus symbol_conf.vmlinux_name is NULL, no suitable vmlinux is found, and
then we get:

 aldebaran:~> perf top -p 7557
 [kernel.kallsyms] with build id 44d9a989eabbd79e486bc079d6b743d397c204e0
 not found, continuing without symbols
 The (null) file can't be used

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-cj2g81hn64wv2bipmqk4fy2m@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 472f627..f2f3f49 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -81,6 +81,7 @@ static bool			use_tui, use_stdio;
 static int			default_interval		=      0;
 
 static bool			kptr_restrict_warned;
+static bool			vmlinux_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
@@ -754,6 +755,7 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 
 	if (al.sym == NULL) {
+		const char *msg = "Kernel samples will not be resolved.\n";
 		/*
 		 * As we do lazy loading of symtabs we only will know if the
 		 * specified vmlinux file is invalid when we actually have a
@@ -765,12 +767,20 @@ static void perf_event__process_sample(const union perf_event *event,
 		 * --hide-kernel-symbols, even if the user specifies an
 		 * invalid --vmlinux ;-)
 		 */
-		if (al.map == machine->vmlinux_maps[MAP__FUNCTION] &&
+		if (!kptr_restrict_warned && !vmlinux_warned &&
+		    al.map == machine->vmlinux_maps[MAP__FUNCTION] &&
 		    RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION])) {
-			ui__warning("The %s file can't be used\n",
-				    symbol_conf.vmlinux_name);
-			exit_browser(0);
-			exit(1);
+			if (symbol_conf.vmlinux_name) {
+				ui__warning("The %s file can't be used.\n%s",
+					    symbol_conf.vmlinux_name, msg);
+			} else {
+				ui__warning("A vmlinux file was not found.\n%s",
+					    msg);
+			}
+
+			if (use_browser <= 0)
+				sleep(5);
+			vmlinux_warned = true;
 		}
 
 		return;
