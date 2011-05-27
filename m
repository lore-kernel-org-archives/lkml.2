Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1E0W6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:58:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56109
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130Ab1E0W6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:58:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/5] perf top: Don't stop if no kernel symtab is found
Date: Fri, 27 May 2011 18:45:36 -0300
Message-Id: <1306532736-3790-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1306532736-3790-1-git-send-email-acme@infradead.org>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

