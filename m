Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1DETWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:22:02 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34078 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949Ab1DETV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:21:57 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [RFC][PATCH 4/5] signals: Introduce __dequeue_private_signal helper function
Date: Tue,  5 Apr 2011 20:21:49 +0100
Message-Id: <1302031310-1765-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

To keep things symmetric with __dequeue_shared_signal() create a
__dequeue_private_signal() function which helps to hide the required
locking for accessing tsk->pending.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 kernel/signal.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c67f27a..db0ce0e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -642,6 +642,18 @@ static int __dequeue_shared_signal(struct task_struct *tsk,
 	return signr;
 }
 
+static int __dequeue_private_signal(struct task_struct *tsk,
+				    sigset_t *mask, siginfo_t *info)
+{
+	int signr;
+
+	spin_lock_irq(&tsk->siglock);
+	signr = __dequeue_signal(&tsk->pending, mask, info);
+	spin_unlock_irq(&tsk->siglock);
+
+	return signr;
+}
+
 /*
  * Dequeue a signal and return the element to the caller, which is 
  * expected to free it.
@@ -665,11 +677,8 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	if (!signr) {
-		spin_lock(&tsk->siglock);
-		signr = __dequeue_signal(&tsk->pending, mask, info);
-		spin_unlock(&tsk->siglock);
-	}
+	if (!signr)
+		signr = __dequeue_private_signal(tsk, mask, info);
 
 	recalc_sigpending();
 	if (!signr)
-- 
1.7.4

