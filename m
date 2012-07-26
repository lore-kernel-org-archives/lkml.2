Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2GZPKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:10:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2GZPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:10:36 -0400
Date: Thu, 26 Jul 2012 08:10:13 -0700
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-895dd92c032e1604aa0d7afaef7716e058343b67@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, avagin@openvz.org, rostedt@goodmis.org,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        avagin@openvz.org, asharma@fb.com
In-Reply-To: <1342088069-1005148-1-git-send-email-avagin@openvz.org>
References: <1342088069-1005148-1-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] sched:
  Deliver sched_switch events to the current task
Git-Commit-ID: 895dd92c032e1604aa0d7afaef7716e058343b67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:10:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  895dd92c032e1604aa0d7afaef7716e058343b67
Gitweb:     http://git.kernel.org/tip/895dd92c032e1604aa0d7afaef7716e058343b67
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Thu, 12 Jul 2012 14:14:29 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 12:23:10 +0200

sched: Deliver sched_switch events to the current task

Otherwise they can't be filtered for a defined task:

  perf record -e sched:sched_switch ./foo

This command doesn't report any events without this patch.

I think it isn't a security concern if someone knows who will
be executed next - this can already be observed by polling /proc
state. By default perf is disabled for non-root users in any case.

I need these events for profiling sleep times.  sched_switch is used for
getting callchains and sched_stat_* is used for getting time periods.
These events are combined in user space, then it can be analyzed by
perf tools.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/r/1342088069-1005148-1-git-send-email-avagin@openvz.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 468bdd4..ad732b5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1910,12 +1910,12 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	trace_sched_switch(prev, next);
 	sched_info_switch(prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
-	trace_sched_switch(prev, next);
 }
 
 /**
