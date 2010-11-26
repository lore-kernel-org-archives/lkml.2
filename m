Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0KZKu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:50:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:42316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0KZKuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:24 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] ptrace: don't consume group count from ptrace_stop()
Date: Fri, 26 Nov 2010 11:49:25 +0100
Message-Id: <1290768569-16224-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that group stop pending and consumed states are properly tracked
per task, there is no need to consume group_stop_count from
ptrace_stop() which is inaccurate.

The only behavior change is the increased likelihood of missing
notifications for group stops if the thread group contains one or more
ptraced tasks, but they never were reliable in the presence of ptraced
tasks.  With this change, consume_group_stop() is called only if group
stop is pending.  Make sure it is so by adding WARN_ON_ONCE().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8341667..c084ea8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -225,6 +225,8 @@ static inline void print_dropped_signal(int sig)
 
 static bool consume_group_stop(void)
 {
+	WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_PENDING));
+
 	if (!(current->group_stop & GROUP_STOP_CONSUME))
 		return false;
 
@@ -1657,13 +1659,6 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 			return;
 	}
 
-	/*
-	 * If there is a group stop in progress,
-	 * we must participate in the bookkeeping.
-	 */
-	if (current->signal->group_stop_count > 0)
-		consume_group_stop();
-
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
 
-- 
1.7.1

