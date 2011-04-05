Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1DETWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:22:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34071 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab1DETV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:21:56 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [RFC][PATCH 3/5] ia64: Catch up with new sighand action spinlock
Date: Tue,  5 Apr 2011 20:21:48 +0100
Message-Id: <1302031310-1765-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

Also delete the comment that says holding siglock might not be
necessary - it is, parts of signal code require that the handlers for
a sighand do not change.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/ia64/kernel/signal.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 7bdafc8..d3b37c4 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -308,18 +308,9 @@ force_sigsegv_info (int sig, void __user *addr)
 	struct siginfo si;
 
 	if (sig == SIGSEGV) {
-		/*
-		 * Acquiring siglock around the sa_handler-update is almost
-		 * certainly overkill, but this isn't a
-		 * performance-critical path and I'd rather play it safe
-		 * here than having to debug a nasty race if and when
-		 * something changes in kernel/signal.c that would make it
-		 * no longer safe to modify sa_handler without holding the
-		 * lock.
-		 */
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		write_lock_irqsave(&current->sighand->action_lock, flags);
 		current->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		write_unlock_irqrestore(&current->sighand->action_lock, flags);
 	}
 	si.si_signo = SIGSEGV;
 	si.si_errno = 0;
-- 
1.7.4

