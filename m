Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1HKN6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:58:47 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60190 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab1HKN6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:41 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: [PATCH 37/41] autofs4: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:11 +0100
Message-Id: <1313071035-12047-38-git-send-email-matt@console-pimps.org>
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
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/autofs4/waitq.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index e1fbdee..64ff15a 100644
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
-
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
-		current->blocked = oldset;
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
+		
+		set_current_blocked(&oldset);
 	} else {
 		DPRINTK("skipped sleeping");
 	}
-- 
1.7.4.4

