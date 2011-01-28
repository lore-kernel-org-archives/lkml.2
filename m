Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1A1PJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1A1PJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sMVTpg1E7cYW8qGHOSkQEYLNvllZ4F85l16dZ0AIMmtzpgyK3W3EcrsuTK9Y7E10UQ
         l5hDOFiaaTLVP4+21TfMSuA4rHRFUSEyRM2EGjK0HJikhlGoz8ijDBXibGTKUkXupD6c
         n7BJUUXalTVZDo/aL5+ygaPHaQshjFrJ8JNXs=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] ptrace: participate in group stop from ptrace_stop() iff the task is trapping for group stop
Date: Fri, 28 Jan 2011 16:08:42 +0100
Message-Id: <1296227324-25295-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
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
index 7527778..2e20dad 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1694,10 +1694,13 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
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

