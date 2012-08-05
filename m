Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2HEQzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:55:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:55:48 -0400
Date: Sun, 5 Aug 2012 09:52:11 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-1a31fc904f1c897e4aaf7c3176e6aafa49f5d395@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, robert.richter@amd.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, robert.richter@amd.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1343616783-6360-1-git-send-email-dsahern@gmail.com>
References: <1343616783-6360-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top:
  Error handling for counter creation should parallel perf-record
Git-Commit-ID: 1a31fc904f1c897e4aaf7c3176e6aafa49f5d395
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:52:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a31fc904f1c897e4aaf7c3176e6aafa49f5d395
Gitweb:     http://git.kernel.org/tip/1a31fc904f1c897e4aaf7c3176e6aafa49f5d395
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 29 Jul 2012 20:53:03 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Aug 2012 10:30:18 -0300

perf top: Error handling for counter creation should parallel perf-record

5a7ed29 fixed up perf-record but not perf-top. Similar argument holds
for it -- fallback to PMU only if it does not exist and handle invalid
attributes separately.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1343616783-6360-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 40264ea..3409627 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -943,8 +943,10 @@ try_again:
 			 * based cpu-clock-tick sw counter, which
 			 * is always available even if no PMU support:
 			 */
-			if (attr->type == PERF_TYPE_HARDWARE &&
-			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+			if ((err == ENOENT || err == ENXIO) &&
+			    (attr->type == PERF_TYPE_HARDWARE) &&
+			    (attr->config == PERF_COUNT_HW_CPU_CYCLES)) {
+
 				if (verbose)
 					ui__warning("Cycles event not supported,\n"
 						    "trying to fall back to cpu-clock-ticks\n");
