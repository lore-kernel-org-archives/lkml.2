Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab2EJRVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:21:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:60483 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab2EJRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/16] perf record: Fix fallback to cpu-clock on ppc
Date: Thu, 10 May 2012 14:17:40 -0300
Message-Id: <1336670265-20401-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1336490937-57106-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

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
1.7.9.2.358.g22243

