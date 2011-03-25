Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1CYTLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:11:18 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:21180 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1CYTLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:11:16 -0400
X-IronPort-AV: E=Sophos;i="4.63,244,1299456000"; 
   d="scan'208";a="282735513"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH] perf tools: Emit clearer message for sys_perf_event_open ENOENT return
Date: Fri, 25 Mar 2011 13:11:11 -0600
Message-Id: <1301080271-20945-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend of patch sent back in January 2011 in light of recent confusion around
unsupported events for a given platform.

Improve sys_perf_event_open ENOENT return handling in top and record, just
like 5a3446b does for stat.

Retry of Arnaldo's patch using ui_warning instead of die which allows the
fallback from hardware cycles to software clock.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-record.c |    7 +++++++
 tools/perf/builtin-top.c    |    8 ++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6febcc1..cac275e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -282,6 +282,9 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
+			} else if (err ==  ENOENT) {
+				ui__warning("%s event is not supported.\n",
+					    event_name(pos));
 			} else if (err == EINVAL && sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
@@ -307,6 +310,10 @@ try_again:
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
+
+			if (err == ENOENT)
+				exit(1);
+
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 			      err, strerror(err));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 80c9e06..109e1a0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -852,6 +852,10 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
+			else if (err == ENOENT)
+				ui__warning("%s event is not supported.\n",
+					    event_name(counter));
+
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
@@ -867,6 +871,10 @@ try_again:
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
+
+			if (err == ENOENT)
+				exit(1);
+
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d "
 			      "(%s).  /bin/dmesg may provide additional information.\n",
-- 
1.7.4

