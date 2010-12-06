Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0LFQ7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:59:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:59734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0LFQ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:45 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/16] ptrace: participate in group stop from ptrace_stop() iff the task is trapping for group stop
Date: Mon,  6 Dec 2010 17:56:56 +0100
Message-Id: <1291654624-6230-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ptrace_stop() unconditionally participates in group stop
bookkeeping.  This is unnecessary and inaccurate.  Make it only
participate if the task is trapping for group stop - ie. if @why is
CLD_STOPPED.  As ptrace_stop() currently is not used when trapping for
group stop, this equals to disabling group stop participation from
ptrace_stop().

A visible behavior change is increased likelihood of delayed group
stop completion if the thread group contains one or more ptraced
tasks.

This is to preapre for further cleanup of the interaction between
group stop and ptrace.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bff46ed..faf218b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1696,10 +1696,13 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	}
 
 	/*
-	 * If there is a group stop in progress,
-	 * we must participate in the bookkeeping.
+	 * If @why is CLD_STOPPED, we're trapping to participate in a group
+	 * stop.  Do the bookkeeping.  Note that if SIGCONT was delievered
+	 * while siglock was released for the arch hook, PENDING could be
+	 * clear now.  We act as if SIGCONT is received after TASK_TRACED
+	 * is entered - ignore it.
 	 */
-	if (current->group_stop & GROUP_STOP_PENDING)
+	if (why == CLD_STOPPED && (current->group_stop & GROUP_STOP_PENDING))
 		task_participate_group_stop(current);
 
 	current->last_siginfo = info;
-- 
1.7.1

