Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab1LFJtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:49:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab1LFJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:49:23 -0500
Date: Tue, 6 Dec 2011 01:48:52 -0800
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-b781a602ac745ee3d5d745276f1e1905a2c101f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org,
        mingo@elte.hu
In-Reply-To: <1322471015-107825-8-git-send-email-avagin@openvz.org>
References: <1322471015-107825-8-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] events, sched: Add tracepoint for accounting blocked time
Git-Commit-ID: b781a602ac745ee3d5d745276f1e1905a2c101f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:48:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b781a602ac745ee3d5d745276f1e1905a2c101f9
Gitweb:     http://git.kernel.org/tip/b781a602ac745ee3d5d745276f1e1905a2c101f9
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Mon, 28 Nov 2011 12:03:35 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:51:23 +0100

events, sched: Add tracepoint for accounting blocked time

This tracepoint shows how long a task is sleeping in uninterruptible state.

E.g. it may show how long and where a mutex is waited for.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1322471015-107825-8-git-send-email-avagin@openvz.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/sched.h |    7 +++++++
 kernel/sched/fair.c          |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..e33ed1b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -331,6 +331,13 @@ DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
 	     TP_ARGS(tsk, delay));
 
 /*
+ * Tracepoint for accounting blocked time (time the task is in uninterruptible).
+ */
+DEFINE_EVENT(sched_stat_template, sched_stat_blocked,
+	     TP_PROTO(struct task_struct *tsk, u64 delay),
+	     TP_ARGS(tsk, delay));
+
+/*
  * Tracepoint for accounting runtime (time the task is executing
  * on a CPU).
  */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd3b642..7c62e2b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1030,6 +1030,8 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 				trace_sched_stat_iowait(tsk, delta);
 			}
 
+			trace_sched_stat_blocked(tsk, delta);
+
 			/*
 			 * Blocking time is in units of nanosecs, so shift by
 			 * 20 to get a milliseconds-range estimation of the
