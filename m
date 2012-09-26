Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2IZH76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:59:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55720 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2IZH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:06 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-21-5062b5138986
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/16] perf hists: Add missing period_* fields when collapsing a hist entry
Date: Wed, 26 Sep 2012 16:47:28 +0900
Message-Id: <1348645663-25303-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that the perf report won't lost the cpu utilization information.

For example, if there're two process that have same name.

  $ perf report --stdio --showcpuutilization -s pid
  [SNIP]
  #   Overhead       sys        us  Command:  Pid
  #   ........  ........  ........  .............
  #
        55.12%     0.01%    55.10%  noploop:28781
        44.88%     0.06%    44.83%  noploop:28782

Before:
  $ perf report --stdio --showcpuutilization -s comm
  [SNIP]
  #   Overhead       sys        us
  #   ........  ........  ........
  #
       100.00%     0.06%    44.83%

After:
  $ perf report --stdio --showcpuutilization -s comm
  [SNIP]
  #   Overhead       sys        us
  #   ........  ........  ........
  #
       100.00%     0.07%    99.93%

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6ec5398de89d..236bc9d98ff2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -410,8 +410,13 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->period += he->period;
-			iter->nr_events += he->nr_events;
+			iter->period		+= he->period;
+			iter->period_sys	+= he->period_sys;
+			iter->period_us		+= he->period_us;
+			iter->period_guest_sys	+= he->period_guest_sys;
+			iter->period_guest_us	+= he->period_guest_us;
+			iter->nr_events		+= he->nr_events;
+
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
 				callchain_merge(&callchain_cursor,
-- 
1.7.11.4

