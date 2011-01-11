Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1AKA2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:28:51 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40141 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab1AKA21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:28:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/6] perf tools: Emit clearer message for sys_perf_event_open ENOENT return
Date: Mon, 10 Jan 2011 22:28:09 -0200
Message-Id: <1294705692-9537-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294705692-9537-1-git-send-email-acme@infradead.org>
References: <1294705692-9537-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Improve sys_perf_event_open ENOENT return handling in top and record, just
like 5a3446b does for stat.

Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/builtin-top.c    |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7bc0490..7069bd3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -331,6 +331,9 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
+			} else if (err == ENOENT) {
+				die("%s event is not supported. ",
+				     event_name(evsel));
 			} else if (err == EINVAL && sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1e67ab9..6ce4042 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1247,6 +1247,8 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
+			if (err == ENOENT)
+				die("%s event is not supported. ", event_name(evsel));
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
-- 
1.6.2.5

