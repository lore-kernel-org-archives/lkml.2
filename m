Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1A1PJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1A1PJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=U0cWhkK3kETsiznDH/Cw5CbbjLVT5fee9RUWxqK2zU3OftJlb+Srr+6BvgjnZUhf1i
         vVcaoRzhsMvN16XnztEOsK2Ff93dktuzHp/DRV/JXjqxH9kbgDINXTdSkiwy6SDgSB8T
         4Dj7V0Xo7RbvPYwjLb6mAEEtrNcwFPQPLu+/w=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] ptrace: remove the extra wake_up_process() from ptrace_detach()
Date: Fri, 28 Jan 2011 16:08:36 +0100
Message-Id: <1296227324-25295-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wake_up_process() has a turbulent history.  This is a remnant
from ancient ptrace implementation and patently wrong.  Commit
95a3540d (ptrace_detach: the wrong wakeup breaks the ERESTARTxxx
logic) removed it but the change was reverted later by commit edaba2c5
(ptrace: revert "ptrace_detach: the wrong wakeup breaks the
ERESTARTxxx logic ") citing compatibility breakage and general
brokeness of the whole group stop / ptrace interaction.

Digging through the mailing archives, the compatibility breakage
doesn't seem to be critical in the sense that the behavior isn't well
defined or reliable to begin with and it seems to have been agreed to
remove the wakeup with proper cleanup of the whole thing.

Now that the group stop and its interaction with ptrace are cleaned up
and well defined, it's high time to finally kill this silliness.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99bbaa3..a8c9f26 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -312,8 +312,6 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
 	if (child->ptrace) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
-		if (!child->exit_state)
-			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
-- 
1.7.1

