Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1CEKit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:38:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61048 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1CEKhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q9YxEbLlukFw5ZvdKdBQPL639LfRaYOi0wX8Ts6+pG0gF9Q44l4B2Zo1ZXjrZBMGe6
         y57FVE0V5m3V6L9rFLizKCG2OhFlhl3JcPtlNBFyNNNF59SysUTnSwpjO114Wnhac4Ey
         U61Qk4kd98ekoFHeR0V1oRCrE+xNN0m37mDIU=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] ptrace: remove the extra wake_up_state() from ptrace_detach()
Date: Sat,  5 Mar 2011 11:36:59 +0100
Message-Id: <1299321427-15051-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299321427-15051-1-git-send-email-tj@kernel.org>
References: <1299321427-15051-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wake_up_state() has a turbulent history.  This is a remnant from
ancient ptrace implementation and patently wrong.  Commit 95a3540d
(ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic) removed
it but the change was reverted later by commit edaba2c5 (ptrace:
revert "ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic")
citing compatibility breakage and general brokeness of the whole group
stop / ptrace interaction.  Then, recently, it got converted from
wake_up_process() to wake_up_state() to make it less dangerous.

Digging through the mailing archives, the compatibility breakage
doesn't seem to be critical in the sense that the behavior isn't well
defined or reliable to begin with and it seems to have been agreed to
remove the wakeup with proper cleanup of the whole thing.

Now that the group stop and its interaction with ptrace are being
cleaned up, it's high time to finally kill this silliness.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index e2302e4..6acf895 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -312,8 +312,6 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 	if (child->ptrace) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
-		if (!child->exit_state)
-			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 
-- 
1.7.1

