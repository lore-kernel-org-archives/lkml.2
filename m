Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0IIRH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:07:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:38055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0IIRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:06:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] perf probe: Fix return probe support
Date: Thu,  9 Sep 2010 14:06:42 -0300
Message-Id: <1284052005-25658-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1284052005-25658-1-git-send-email-acme@infradead.org>
References: <1284052005-25658-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix a bug to support %return probe syntax again. Previous commit 4235b04 has a
bug which disables the %return syntax on perf probe.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100827113852.22882.87447.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |    1 +
 tools/perf/util/probe-finder.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e72f05c..fcc16e4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1539,6 +1539,7 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		goto error;
 	}
 	tev->point.offset = pev->point.offset;
+	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
 	if (tev->nargs) {
 		tev->args = zalloc(sizeof(struct probe_trace_arg)
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5251366..9b0e1b1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -783,6 +783,16 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 		/* This function has no name. */
 		tev->point.offset = (unsigned long)pf->addr;
 
+	/* Return probe must be on the head of a subprogram */
+	if (pf->pev->point.retprobe) {
+		if (tev->point.offset != 0) {
+			pr_warning("Return probe must be on the head of"
+				   " a real function\n");
+			return -EINVAL;
+		}
+		tev->point.retprobe = true;
+	}
+
 	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
 		 tev->point.offset);
 
-- 
1.6.2.5

