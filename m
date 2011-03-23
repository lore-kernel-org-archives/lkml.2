Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1CWKGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:06:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50823 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab1CWKGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rBkIW2pFR0G/bJdA2QwklNXmh2a3EsabMiUm07HPZ4OJ175fdP+E6G3wpGh+yNjwHy
         KPjDgqxSvstV2d1omfagk+hr2k3Zcrq+3QPPWQ15BArCxUxuYKRJtt3E0Dqzp8vv/9uT
         g84fjTRv8LZiTQ/ljn+pFzYfKSC82NziZu0XU=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 02/20] ptrace: Remove the extra wake_up_state() from ptrace_detach()
Date: Wed, 23 Mar 2011 11:05:48 +0100
Message-Id: <1300874766-12941-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
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

