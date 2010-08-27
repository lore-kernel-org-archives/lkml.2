Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0H0LhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:37:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35345 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0H0LhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:37:07 -0400
X-AuditID: b753bd60-a7adaba000000a18-95-4c77a360fbb9
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  2/5] perf probe: Fix return probe support
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 20:38:53 +0900
Message-ID: <20100827113852.22882.87447.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20100827113837.22882.92630.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113837.22882.92630.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug to support %return probe syntax again. Previous commit
4235b04 has a bug which disables the %return syntax on perf probe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
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
 

