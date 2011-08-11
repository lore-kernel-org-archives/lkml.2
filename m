Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1HKN7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:59:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60205 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1HKN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:45 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 41/41] exit: Use __set_task_blocked()
Date: Thu, 11 Aug 2011 14:57:15 +0100
Message-Id: <1313071035-12047-42-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 kernel/exit.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..a47c0f3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -369,19 +369,22 @@ static void set_special_pids(struct pid *pid)
  */
 int allow_signal(int sig)
 {
+	sigset_t blocked;
+
 	if (!valid_signal(sig) || sig < 1)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
 	/* This is only needed for daemonize()'ed kthreads */
-	sigdelset(&current->blocked, sig);
+	siginitset(&blocked, current->blocked);
+	sigdelset(&blocked, sig);
 	/*
 	 * Kernel threads handle their own signals. Let the signal code
 	 * know it'll be handled, so that they don't get converted to
 	 * SIGKILL or just silently dropped.
 	 */
 	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	recalc_sigpending();
+	__set_task_blocked(current, &blocked);
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
 }
-- 
1.7.4.4

