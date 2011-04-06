Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1DFLAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:00:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:51560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1DFLAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:00:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf probe: Fix to remove redundant close
Date: Wed,  6 Apr 2011 08:00:20 -0300
Message-Id: <1302087623-14724-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1302087623-14724-1-git-send-email-acme@infradead.org>
References: <1302087623-14724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Since dwfl_end() closes given fd with dwfl, caller doesn't need to close its fd
when finishing process.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110330092547.2132.93728.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |    3 ---
 tools/perf/util/probe-finder.c |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 5ddee66..a372d74 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -234,7 +234,6 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 
 	/* Searching trace events corresponding to probe event */
 	ntevs = find_probe_trace_events(fd, pev, tevs, max_tevs);
-	close(fd);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("find %d probe_trace_events.\n", ntevs);
@@ -388,7 +387,6 @@ int show_line_range(struct line_range *lr, const char *module)
 	}
 
 	ret = find_line_range(fd, lr);
-	close(fd);
 	if (ret == 0) {
 		pr_warning("Specified source line is not found.\n");
 		return -ENOENT;
@@ -524,7 +522,6 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 		ret = show_available_vars_at(fd, &pevs[i], max_vls, _filter,
 					     externs);
 
-	close(fd);
 	return ret;
 }
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3bcd140..5473f11 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1455,6 +1455,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 	if (!dbg) {
 		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		close(fd);	/* Without dwfl_end(), fd isn't closed. */
 		return -EBADF;
 	}
 
@@ -1900,6 +1901,7 @@ int find_line_range(int fd, struct line_range *lr)
 	if (!dbg) {
 		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		close(fd);	/* Without dwfl_end(), fd isn't closed. */
 		return -EBADF;
 	}
 
-- 
1.6.2.5

