Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0LFQ6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:59703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0LFQ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:16 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] ptrace: remove the extra wake_up_process() from ptrace_detach()
Date: Mon,  6 Dec 2010 17:57:04 +0100
Message-Id: <1291654624-6230-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:41 +0000 (UTC)
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
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index dba6aeb..575bf8f 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -391,8 +391,6 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
 	if (child->ptrace) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
-		if (!child->exit_state)
-			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
-- 
1.7.1

