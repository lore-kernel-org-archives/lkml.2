Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1HSQtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:49:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57406 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126Ab1HSQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:39 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [PATCH v2 41/43] coda: Use set_current_blocked()
Date: Fri, 19 Aug 2011 17:46:57 +0100
Message-Id: <1313772419-21951-42-git-send-email-matt@console-pimps.org>
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
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/coda/upcall.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 9727e0c..ce5925d 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -575,24 +575,21 @@ int venus_statfs(struct dentry *dentry, struct kstatfs *sfs)
  */
 static void coda_block_signals(sigset_t *old)
 {
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	*old = current->blocked;
 
-	sigfillset(&current->blocked);
-	sigdelset(&current->blocked, SIGKILL);
-	sigdelset(&current->blocked, SIGSTOP);
-	sigdelset(&current->blocked, SIGINT);
+	sigfillset(&blocked);
+	sigdelset(&blocked, SIGKILL);
+	sigdelset(&blocked, SIGSTOP);
+	sigdelset(&blocked, SIGINT);
 
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&blocked);
 }
 
 static void coda_unblock_signals(sigset_t *old)
 {
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = *old;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(old);
 }
 
 /* Don't allow signals to interrupt the following upcalls before venus
-- 
1.7.4.4

