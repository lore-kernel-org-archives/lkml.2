Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0LFQ6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:59731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0LFQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:43 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/16] ptrace: make sure SIGNAL_NOTIFY_CONT is checked after ptrace_signal()
Date: Mon,  6 Dec 2010 17:57:03 +0100
Message-Id: <1291654624-6230-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_signal() releases siglock and signal delivery may continue
afterwards.  SIGNAL_NOTIFY_CONT can be set inbetween and should be
checked after returning from the function.

* Restart from the top if ptrace_signal() returns 0.

* Factor out CLD_CONTINUED check code into notify_parent_cont() and
  check before returning from get_signal_to_deliver() too.

With the latter, the former isn't strictly necessary but it's still
better to do it to document what's going on if for nothing else.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7b6f972..5eddda6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2019,6 +2019,19 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	return signr;
 }
 
+static inline void notify_parent_cont(void)
+{
+	/*
+	 * Every stopped thread should go through this function after
+	 * waking up.  Check to see if we should notify the parent.
+	 */
+	if (unlikely(current->signal->flags & SIGNAL_NOTIFY_CONT)) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current->group_leader, CLD_CONTINUED);
+		read_unlock(&tasklist_lock);
+	}
+}
+
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -2035,15 +2048,7 @@ relock:
 	 */
 	try_to_freeze();
 
-	/*
-	 * Every stopped thread should go through this function after
-	 * waking up.  Check to see if we should notify the parent.
-	 */
-	if (unlikely(current->signal->flags & SIGNAL_NOTIFY_CONT)) {
-		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current, CLD_CONTINUED);
-		read_unlock(&tasklist_lock);
-	}
+	notify_parent_cont();
 
 	spin_lock_irq(&sighand->siglock);
 
@@ -2073,8 +2078,11 @@ relock:
 			if (signr != SIGKILL) {
 				signr = ptrace_signal(signr, info,
 						      regs, cookie);
-				if (!signr)
-					continue;
+				if (!signr) {
+					/* siglock was released, restart */
+					spin_unlock_irq(&sighand->siglock);
+					goto relock;
+				}
 			}
 
 			ka = &sighand->action[signr-1];
@@ -2177,6 +2185,14 @@ relock:
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
+
+	/*
+	 * If ptrace_signal() returned a non-zero signal, control can reach
+	 * here without other pending signals or going through relocking
+	 * and a CONT notification may be left pending.  Check it.
+	 */
+	notify_parent_cont();
+
 	return signr;
 }
 
-- 
1.7.1

