Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467Ab2EKGqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761115Ab2EKGqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:46:38 -0400
Date: Thu, 10 May 2012 23:46:17 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-028d455b12719a48b1c4b51ce07a074135726f8f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1336490937-57106-1-git-send-email-dsahern@gmail.com>
References: <1336490937-57106-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix fallback to cpu-clock on ppc
Git-Commit-ID: 028d455b12719a48b1c4b51ce07a074135726f8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:46:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  028d455b12719a48b1c4b51ce07a074135726f8f
Gitweb:     http://git.kernel.org/tip/028d455b12719a48b1c4b51ce07a074135726f8f
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 8 May 2012 09:28:57 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 May 2012 11:57:29 -0300

perf record: Fix fallback to cpu-clock on ppc

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
