Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab0FLHfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:35:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65087 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0FLHfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=aOoGQCvzH1uclRbXEKoU7gi2Fl9zCPXZgbo64iqChUS5iZW0ji3DPn7ePn/GCY06Au
         2aVdzh2y6d0RqcrZmiPksIXBpuF+HG5pLdsRedR2ASyXyqh1KFNuf/ZAnz/CPTVikmU3
         +eMNwvFLdvfPFz54zzJx5xceGONO1KA/+bEMU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/5] perf: Support for task/softirq/hardirq exclusion on tools
Date: Sat, 12 Jun 2010 09:34:58 +0200
Message-Id: <1276328098-24114-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring the following new flags on perf events:

- t = Profile task context
- s = Profile softirq context
- i = Profile hardirq context

Example:

	perf record -a -g -e cycles:i ls -R /usr > /dev/null

         3.11%           ls  [kernel.kallsyms]  [k] __lock_acquire
                         |
                         --- __lock_acquire
                            |
                            |--95.83%-- lock_acquire
                            |          _raw_spin_lock
                            |          |
                            |          |--30.43%-- perf_ctx_adjust_freq
                            |          |          perf_event_task_tick
                            |          |          scheduler_tick
                            |          |          update_process_times
                            |          |          tick_sched_timer
                            |          |          __run_hrtimer
                            |          |          hrtimer_interrupt
                            |          |          smp_apic_timer_interrupt
                            |          |          apic_timer_interrupt

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/parse-events.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9bf0f40..7a18e71 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -688,24 +688,36 @@ static enum event_result
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
-	int exclude = 0;
-	int eu = 0, ek = 0, eh = 0, precise = 0;
+	int exclude_ring = 0, exclude_context = 0;
+	int eu = 0, ek = 0, eh = 0, et = 0, es = 0, ei = 0, precise = 0;
 
 	if (*str++ != ':')
 		return 0;
 	while (*str) {
 		if (*str == 'u') {
-			if (!exclude)
-				exclude = eu = ek = eh = 1;
+			if (!exclude_ring)
+				exclude_ring = eu = ek = eh = 1;
 			eu = 0;
 		} else if (*str == 'k') {
-			if (!exclude)
-				exclude = eu = ek = eh = 1;
+			if (!exclude_ring)
+				exclude_ring = eu = ek = eh = 1;
 			ek = 0;
 		} else if (*str == 'h') {
-			if (!exclude)
-				exclude = eu = ek = eh = 1;
+			if (!exclude_ring)
+				exclude_ring = eu = ek = eh = 1;
 			eh = 0;
+		} else if (*str == 't') {
+			if (!exclude_context)
+				exclude_context = et = es = ei = 1;
+			et = 0;
+		} else if (*str == 's') {
+			if (!exclude_context)
+				exclude_context = et = es = ei = 1;
+			es = 0;
+		} else if (*str == 'i') {
+			if (!exclude_context)
+				exclude_context = et = es = ei = 1;
+			ei = 0;
 		} else if (*str == 'p') {
 			precise++;
 		} else
@@ -715,9 +727,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	}
 	if (str >= *strp + 2) {
 		*strp = str;
-		attr->exclude_user   = eu;
-		attr->exclude_kernel = ek;
-		attr->exclude_hv     = eh;
+		attr->exclude_user	= eu;
+		attr->exclude_kernel	= ek;
+		attr->exclude_hv	= eh;
+		attr->exclude_task	= et;
+		attr->exclude_softirq	= es;
+		attr->exclude_hardirq	= ei;
 		attr->precise_ip     = precise;
 		return 1;
 	}
-- 
1.6.2.3

