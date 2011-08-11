Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1HKN7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:59:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60194 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab1HKN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:42 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [PATCH 38/41] coda: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:12 +0100
Message-Id: <1313071035-12047-39-git-send-email-matt@console-pimps.org>
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

