Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab0FJDt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:49:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35474 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab0FJDtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=amJgJXpKRTRhfU9RHVb10bCz4lpQKJKkFTpNrhVs9PES5AIDTYw/RUoYlDStkqEI7r
         fhpQxCR6D80pN2yKteWve4sstEz9bdIiDiA9J9E1vGa0Y2rpTOot/8Dqs7A4ovDSkA69
         sLToKsYqWr2nj6SlsxDaHKWoGAoPAEI5bYWcM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/5] perf: Provide a proper stop action for software events
Date: Thu, 10 Jun 2010 05:49:16 +0200
Message-Id: <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to introduce new context exclusions, software events will
have to eventually stop when needed. We'll want perf_event_stop() to
act on every events.

To achieve this, remove the stub stop/start pmu callbacks of software
and tracepoint events.

This may even optimize the case of hardware and software events
running at the same time: now we only stop/start all hardware
events if we reset a hardware event period, not anymore with
software events.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/perf_event.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c772a3d..5c004f7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1541,11 +1541,23 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		perf_disable();
-		perf_event_stop(event);
+		bool software_event = is_software_event(event);
+
+		/*
+		 * Only hardware events need their irq period to be
+		 * reprogrammed
+		 */
+		if (!software_event) {
+			perf_disable();
+			perf_event_stop(event);
+		}
+
 		local64_set(&hwc->period_left, 0);
-		perf_event_start(event);
-		perf_enable();
+
+		if (!software_event) {
+			perf_event_start(event);
+			perf_enable();
+		}
 	}
 }
 
@@ -4286,16 +4298,9 @@ static void perf_swevent_void(struct perf_event *event)
 {
 }
 
-static int perf_swevent_int(struct perf_event *event)
-{
-	return 0;
-}
-
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
 	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
 };
@@ -4578,8 +4583,6 @@ static int swevent_hlist_get(struct perf_event *event)
 static const struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
 	.unthrottle	= perf_swevent_void,
 };
-- 
1.6.2.3

