Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab1CWKHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:07:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab1CWKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=SQLU5ZvvCWFtkQiFYe+g6lptdFAPhX/4l/FYfIzM/sB1xINE4TJUNe6HkS79g1EH98
         Vh7ls5iP9LjmqnaAXuY5JUuilYXyWmMDi+zFgJ69npxvIFFMZYkIbY55MgMxv7+Srd+A
         MgZyhI4hMty6ZScB5YF231rZF4C9/YT8s72+U=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 08/20] ptrace: Participate in group stop from ptrace_stop() iff the task is trapping for group stop
Date: Wed, 23 Mar 2011 11:05:54 +0100
Message-Id: <1300874766-12941-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
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
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index a2e7a65..9f36dd2 100644
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

