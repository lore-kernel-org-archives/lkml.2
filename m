Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab1AMSQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:16:24 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:59822 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab1AMSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:16:22 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
From: David Ahern <daahern@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, fweisbec@gmail.com, mingo@elte.hu, efault@gmx.de,
        paulus@samba.org, peterz@infradead.org, eranian@google.com,
        tzanussi@gmail.com, David Ahern <daahern@cisco.com>
Subject: [PATCH] perf tools: Emit clearer message for sys_perf_event_open ENOENT return
Date: Thu, 13 Jan 2011 11:16:16 -0700
Message-Id: <1294942576-9203-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve sys_perf_event_open ENOENT return handling in top and record, just
like 5a3446b does for stat.

Retry of Arnaldo's patch using error instead of die which allows the fallback
from hardware cycles to software clock.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-record.c |    2 ++
 tools/perf/builtin-top.c    |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7bc0490..fe24c19 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -331,6 +331,8 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
+			} else if (err ==  ENOENT) {
+				error("%s event is not supported.", event_name(evsel));
 			} else if (err == EINVAL && sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1e67ab9..b144353 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1247,6 +1247,9 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
+			else if (err == ENOENT)
+				error("%s event is not supported.", event_name(evsel));
+
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
-- 
1.7.3.4

