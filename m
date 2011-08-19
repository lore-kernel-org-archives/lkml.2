Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1HSQtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:49:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57402 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932119Ab1HSQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:38 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: [PATCH v2 40/43] autofs4: Use set_current_blocked()
Date: Fri, 19 Aug 2011 17:46:56 +0100
Message-Id: <1313772419-21951-41-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/autofs4/waitq.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index e1fbdee..58ba49a 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -458,21 +458,16 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	 */
 	if (wq->name.name) {
 		/* Block all but "shutdown" signals while waiting */
-		sigset_t oldset;
+		sigset_t oldset, blocked;
 		unsigned long irqflags;
 
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
 		oldset = current->blocked;
-		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
+		siginitsetinv(&blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
+		set_current_blocked(&blocked);
 
 		wait_event_interruptible(wq->queue, wq->name.name == NULL);
 
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
-		current->blocked = oldset;
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
+		set_current_blocked(&oldset);
 	} else {
 		DPRINTK("skipped sleeping");
 	}
-- 
1.7.4.4

