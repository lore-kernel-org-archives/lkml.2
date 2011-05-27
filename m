Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1E0VqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:46:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:45727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab1E0Vpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:45:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf top: Handle kptr_restrict
Date: Fri, 27 May 2011 18:45:35 -0300
Message-Id: <1306532736-3790-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1306532736-3790-1-git-send-email-acme@infradead.org>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-cyl5zmi1nu35vyu7l5im2pyv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 375ed16..472f627 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -80,6 +80,7 @@ static bool			use_tui, use_stdio;
 
 static int			default_interval		=      0;
 
+static bool			kptr_restrict_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
@@ -738,6 +739,20 @@ static void perf_event__process_sample(const union perf_event *event,
 	    al.filtered)
 		return;
 
+	if (!kptr_restrict_warned &&
+	    symbol_conf.kptr_restrict &&
+	    al.cpumode == PERF_RECORD_MISC_KERNEL) {
+		ui__warning(
+"Kernel address maps (/proc/{kallsyms,modules}) are restricted.\n\n"
+"Check /proc/sys/kernel/kptr_restrict.\n\n"
+"Kernel%s samples will not be resolved.\n",
+			  !RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION]) ?
+			  " modules" : "");
+		if (use_browser <= 0)
+			sleep(5);
+		kptr_restrict_warned = true;
+	}
+
 	if (al.sym == NULL) {
 		/*
 		 * As we do lazy loading of symtabs we only will know if the
-- 
1.6.2.5

