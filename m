Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1C3Cfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:35:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59536 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1C3Cfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:35:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf tools: Emit clearer message for sys_perf_event_open ENOENT return
Date: Tue, 29 Mar 2011 23:35:31 -0300
Message-Id: <1301452532-1260-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301452532-1260-1-git-send-email-acme@infradead.org>
References: <1301452532-1260-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <daahern@cisco.com>

Resend of patch sent back in January 2011 in light of recent confusion around
unsupported events for a given platform.

Improve sys_perf_event_open ENOENT return handling in top and record, just
like 5a3446b does for stat.

Retry of Arnaldo's patch using ui_warning instead of die which allows the
fallback from hardware cycles to software clock.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
LKML-Reference: <1301080271-20945-1-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
[ committer note: Some adjustments to make it apply to newer codebase ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   10 +++++++++-
 tools/perf/builtin-top.c    |    6 ++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 623695e..db6adec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -301,11 +301,19 @@ try_again:
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
-					warning(" ... trying to fall back to cpu-clock-ticks\n");
+					ui__warning("The cycles event is not supported, "
+						    "trying to fall back to cpu-clock-ticks\n");
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
+
+			if (err == ENOENT) {
+				ui__warning("The %s event is not supported.\n",
+					    event_name(pos));
+				exit(EXIT_FAILURE);
+			}
+
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 			      err, strerror(err));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 935fc4f..fc1273e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -870,6 +870,12 @@ try_again:
 				goto try_again;
 			}
 
+			if (err == ENOENT) {
+				ui__warning("The %s event is not supported.\n",
+					    event_name(counter));
+				goto out_err;
+			}
+
 			ui__warning("The sys_perf_event_open() syscall "
 				    "returned with %d (%s).  /bin/dmesg "
 				    "may provide additional information.\n"
-- 
1.6.2.5

