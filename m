Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0LVL3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:29:18 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:61671 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0LVL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:29:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Z9L1KcFb3uLMWsvTXID0bPSTAMh8KgOCiGgRw/DC+OR4H2YrqK6fJ4KJrYMXMTV9Y8
         aFRolsXG4G23cu7dqlimmspA62MaVdVslDg9l3AkH9fjxBwHtt0BWGBBzSlngZdi2Bbf
         ya/scEIVbJhmoINfyF26xOoUzJZ9tbrfmlcuo=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] ptrace: remove the extra wake_up_process() from ptrace_detach()
Date: Wed, 22 Dec 2010 12:13:16 +0100
Message-Id: <1293016398-18001-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293016398-18001-1-git-send-email-tj@kernel.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
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

