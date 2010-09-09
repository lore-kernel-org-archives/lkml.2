Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0IIToR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:44:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40517 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab0IIToP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:44:15 -0400
Date: Thu, 9 Sep 2010 19:43:36 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100827113852.22882.87447.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113852.22882.87447.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix return probe support
Message-ID: <tip-04ddd04b044d8896a4f8a921b23ba09d365df196@git.kernel.org>
Git-Commit-ID: 04ddd04b044d8896a4f8a921b23ba09d365df196
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:43:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04ddd04b044d8896a4f8a921b23ba09d365df196
Gitweb:     http://git.kernel.org/tip/04ddd04b044d8896a4f8a921b23ba09d365df196
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 27 Aug 2010 20:38:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Sep 2010 11:47:18 -0300

perf probe: Fix return probe support

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
 
