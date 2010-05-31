Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0EaHUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:20:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:44440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0EaHUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:20:34 -0400
Date: Mon, 31 May 2010 07:20:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1274451913.1674.1707.camel@laptop>
References: <1274451913.1674.1707.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events, trace: Fix perf_trace_destroy(), mutex went missing
Message-ID: <tip-2e97942fe57864588774f173cf4cd7bb68968b76@git.kernel.org>
Git-Commit-ID: 2e97942fe57864588774f173cf4cd7bb68968b76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:20:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e97942fe57864588774f173cf4cd7bb68968b76
Gitweb:     http://git.kernel.org/tip/2e97942fe57864588774f173cf4cd7bb68968b76
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 16:22:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:46:09 +0200

perf_events, trace: Fix perf_trace_destroy(), mutex went missing

Steve spotted I forgot to do the destroy under event_mutex.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1274451913.1674.1707.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_event_perf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 49c7abf..e6f6588 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -132,8 +132,9 @@ void perf_trace_destroy(struct perf_event *p_event)
 	struct ftrace_event_call *tp_event = p_event->tp_event;
 	int i;
 
+	mutex_lock(&event_mutex);
 	if (--tp_event->perf_refcount > 0)
-		return;
+		goto out;
 
 	if (tp_event->class->reg)
 		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
@@ -157,6 +158,8 @@ void perf_trace_destroy(struct perf_event *p_event)
 			perf_trace_buf[i] = NULL;
 		}
 	}
+out:
+	mutex_unlock(&event_mutex);
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
