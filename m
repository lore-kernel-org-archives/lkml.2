Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1DFLNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:13:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:42869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab1DFLNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:13:35 -0400
Date: Wed, 6 Apr 2011 11:13:14 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110330092547.2132.93728.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092547.2132.93728.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix to remove redundant close
Message-ID: <tip-f0c4801a17cb1a762bed39a6a9d5e5be33d8a340@git.kernel.org>
Git-Commit-ID: f0c4801a17cb1a762bed39a6a9d5e5be33d8a340
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 11:13:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0c4801a17cb1a762bed39a6a9d5e5be33d8a340
Gitweb:     http://git.kernel.org/tip/f0c4801a17cb1a762bed39a6a9d5e5be33d8a340
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 30 Mar 2011 18:25:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Apr 2011 15:35:16 -0300

perf probe: Fix to remove redundant close

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
 
