Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1C3Jcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:35 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51494 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab1C3Jcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:32 -0400
X-AuditID: b753bd60-a1eb6ba000004916-5d-4d92f8ae7501
X-AuditID: b753bd60-a1eb6ba000004916-5d-4d92f8ae7501
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 02/12] [BUGFIX]perf probe: Fix to remove redundant close
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:25:47 +0900
Message-ID: <20110330092547.2132.93728.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since dwfl_end() closes given fd with dwfl, caller doesn't need
to close its fd when finishing process.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
index 30915bb..8bb50b9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1487,6 +1487,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 	if (!dbg) {
 		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		close(fd);	/* Without dwfl_end(), fd isn't closed. */
 		return -EBADF;
 	}
 
@@ -1951,6 +1952,7 @@ int find_line_range(int fd, struct line_range *lr)
 	if (!dbg) {
 		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		close(fd);	/* Without dwfl_end(), fd isn't closed. */
 		return -EBADF;
 	}
 

