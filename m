Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2G3CxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 22:53:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44143 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2G3CxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 22:53:10 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf top: error handling for counter creation should parallel perf-record
Date: Sun, 29 Jul 2012 20:53:03 -0600
Message-Id: <1343616783-6360-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5a7ed29 fixed up perf-record but not perf-top. Similar argument
holds for it -- fallback to PMU only if it does not exist and handle
invalid attributes separately.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-top.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 35e86c6..534ac3a 100644
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
-- 
1.7.10.1

