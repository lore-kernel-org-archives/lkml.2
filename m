Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2ATQje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:39:34 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38109 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab2ATQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:39:32 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] If init dies, log a signal which killed it, if any.
Date: Fri, 20 Jan 2012 17:39:07 +0100
Message-Id: <1327077547-3925-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just received another user's pleas for help when their
init mystriously dies. I again explained that they need to check
whether it dies because of bad instruction, a segv, or something else.

Which prompted me to make kernel do this first step automatically.
We can easily detect when the death is from e.g. SIGILL,
and let user know that.

The code is fairly self-explanatory. Compile-tested.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 kernel/exit.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 294b170..89d0892 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -710,8 +710,29 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
-		if (unlikely(pid_ns == &init_pid_ns))
+		if (unlikely(pid_ns == &init_pid_ns)) {
+			/*
+			 * The situation when init segfaults is rather typical.
+			 * Give some useful diagnostics: do we die on signal?
+			 */
+			if (fatal_signal_pending(father)) {
+				const char *msg = "";
+				sigset_t *mask = &father->pending.signal;
+				/* Only force_sig()ned signals kill init */
+				if (sigismember(mask, SIGSEGV))
+					msg = " SIGSEGV";
+				if (sigismember(mask, SIGBUS))
+					msg = " SIGBUS";
+				if (sigismember(mask, SIGILL))
+					msg = " SIGILL";
+				if (sigismember(mask, SIGFPE))
+					msg = " SIGFPE";
+				/* (do we want to check SIGTRAP too?) */
+				printk(KERN_ERR
+					"init received fatal signal%s\n", msg);
+			}
 			panic("Attempted to kill init!");
+		}
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
-- 
1.7.7.5

