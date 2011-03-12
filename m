Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1CLXA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 18:00:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab1CLW7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:59:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
Date: Sat, 12 Mar 2011 23:59:46 +0100
Message-Id: <1299970786-8075-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding cond_resched call to the tracing_read_pipe while loop.
Plus check for signal to leave the loop.

This will protect us from soft lockup on NON preemptive kernels
and improve latency.

Thanks a lot to Oleg Nestorov for helping me to nail this down.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 20d84f8..7d66476 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3237,10 +3237,23 @@ waitagain:
 		 * One of the trace_seq_* functions is not used properly.
 		 */
 		WARN_ON(iter->seq.full);
+
+		/*
+		 * There's a chance this loop might get quite tight,
+		 * causing latency in non preemptive kernel.
+		 */
+		cond_resched();
+		if (signal_pending(current)) {
+			sret = -EINTR;
+			break;
+		}
 	}
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 
+	if (sret == -EINTR)
+		goto out;
+
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
-- 
1.7.1

