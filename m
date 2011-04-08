Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1DHU6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:58:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1DHU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nqqf/Y+p3xmTV88W1GpjoNBC5xrmvUQMQIvbjsk9NZOHY7N0ZM/JDjOV9hAl6TtdC0
         NZSgYg6PT0aHtDruNMqve48quwGa9NQoydjYXvfbdz/FudjvnC/+MwSJ/9DXqLlwttDC
         RBt/8ejL1nokIEvAjFZtSKQN+7zgZSyUZrHpo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf: Don't schedule tracepoints when exclude_kernel is set
Date: Fri,  8 Apr 2011 22:57:55 +0200
Message-Id: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking attr.exclude_kernel anytime a tracepoint
event triggers, simply don't schedule the tracepoint it that
attribute is set. This makes one test less in the tracing
path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/perf_event.c             |    5 -----
 kernel/trace/trace_event_perf.c |    6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..2f3fb90 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5491,11 +5491,6 @@ static int perf_tp_event_match(struct perf_event *event,
 {
 	if (event->hw.state & PERF_HES_STOPPED)
 		return 0;
-	/*
-	 * All tracepoints are from kernel-space.
-	 */
-	if (event->attr.exclude_kernel)
-		return 0;
 
 	if (!perf_tp_filter_match(event, data))
 		return 0;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 19a359d..427314b 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -136,6 +136,10 @@ int perf_trace_add(struct perf_event *p_event, int flags)
 	struct hlist_head __percpu *pcpu_list;
 	struct hlist_head *list;
 
+	/* Tracepoints always trigger in the kernel */
+	if (p_event->attr.exclude_kernel)
+		return 0;
+
 	pcpu_list = tp_event->perf_events;
 	if (WARN_ON_ONCE(!pcpu_list))
 		return -EINVAL;
@@ -151,7 +155,7 @@ int perf_trace_add(struct perf_event *p_event, int flags)
 
 void perf_trace_del(struct perf_event *p_event, int flags)
 {
-	hlist_del_rcu(&p_event->hlist_entry);
+	hlist_del_init_rcu(&p_event->hlist_entry);
 }
 
 void perf_trace_destroy(struct perf_event *p_event)
-- 
1.7.3.2

