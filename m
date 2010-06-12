Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0FLHfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:35:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65087 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0FLHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=aQbzPDfdgIEovHfAh5beLDQbEhIRucafghnmHSfpxlOCttbGqHcHQtW+iYR1jeIv0W
         Ojo/zZAFw6SNplPkskkIfAbvJoTlQhxTMr7SlEWHZNlTKyfHwwziJtj9zgy/92tg7GKp
         631kU14/AaHYDGp0nCMtll2znkU4c6QJGqsnA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/5] perf: Support disable() after stop() on software events
Date: Sat, 12 Jun 2010 09:34:55 +0200
Message-Id: <1276328098-24114-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we call perf_event_stop() on a software event and then the
disable() pmu callback on them after that, we'll call twice
hlist_del_rcu() on the same hlist node and then bring a crash
by dereferencing LIST_POISON2.

Just use hlist_del_init_rcu() instead to fix this problem.

This preparates for new context exclusions.

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
 kernel/perf_event.c             |    2 +-
 kernel/trace/trace_event_perf.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 95a56ed..c5f2306 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4292,7 +4292,7 @@ static int perf_swevent_enable(struct perf_event *event)
 
 static void perf_swevent_disable(struct perf_event *event)
 {
-	hlist_del_rcu(&event->hlist_entry);
+	hlist_del_init_rcu(&event->hlist_entry);
 }
 
 static void perf_swevent_void(struct perf_event *event)
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 4799d70..7bc1f26 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -122,7 +122,7 @@ int perf_trace_enable(struct perf_event *p_event)
 
 void perf_trace_disable(struct perf_event *p_event)
 {
-	hlist_del_rcu(&p_event->hlist_entry);
+	hlist_del_init_rcu(&p_event->hlist_entry);
 }
 
 void perf_trace_destroy(struct perf_event *p_event)
-- 
1.6.2.3

