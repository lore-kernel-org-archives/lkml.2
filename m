Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2I1Qhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:37:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab2I1Qhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:37:46 -0400
Date: Fri, 28 Sep 2012 09:37:20 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9ec60972a38011ad8a5676f4cd5e51ac508c36b6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1348645663-25303-2-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Add missing period_* fields when collapsing a hist entry
Git-Commit-ID: 9ec60972a38011ad8a5676f4cd5e51ac508c36b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:37:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ec60972a38011ad8a5676f4cd5e51ac508c36b6
Gitweb:     http://git.kernel.org/tip/9ec60972a38011ad8a5676f4cd5e51ac508c36b6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 26 Sep 2012 16:47:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 26 Sep 2012 20:44:11 -0300

perf hists: Add missing period_* fields when collapsing a hist entry

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1348645663-25303-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6ec5398..236bc9d 100644
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
