Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2EHP3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:29:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2EHP3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:29:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf record: fix fallback to cpu-clock on ppc
Date: Tue,  8 May 2012 09:28:57 -0600
Message-Id: <1336490937-57106-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-record on PPC is not falling back to cpu-clock:

$ perf record -ag -fo /tmp/perf.data -- sleep 1

  Error: sys_perf_event_open() syscall returned with 6 (No such device or address).  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

The problem is that until 2.6.37 (behavior changed with commit b0a873e)
perf on PPC returns ENXIO when hw_perf_event_init() fails. With this
patch we get the expected behavior:

$ perf record -ag -fo /tmp/perf.data -v -- sleep 1
Old kernel, cannot exclude guest or host samples.
The cycles event is not supported, trying to fall back to cpu-clock-ticks
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.151 MB /tmp/perf.data (~6592 samples) ]

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 42e2414..1a9098c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -242,9 +242,13 @@ try_again:
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
-			 * is always available even if no PMU support:
+			 * is always available even if no PMU support.
+			 *
+			 * PPC returns ENXIO until 2.6.37 (behavior changed
+			 * with commit b0a873e).
 			 */
-			if (err == ENOENT && attr->type == PERF_TYPE_HARDWARE
+			if ((err == ENOENT || err == ENXIO)
+					&& attr->type == PERF_TYPE_HARDWARE
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
-- 
1.7.5.4

