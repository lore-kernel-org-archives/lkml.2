Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab1DNScf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:32:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:37572 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab1DNRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 003/209] CRED: Fix RCU warning due to previous patch fixing __task_cred()'s checks
Date: Thu, 14 Apr 2011 13:40:33 -0400
Message-Id: <1302803039-9400-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 694f690d27dadccc8cb9d90532e76593b61fe098 upstream.

Commit 8f92054e7ca1 ("CRED: Fix __task_cred()'s lockdep check and banner
comment") fixed the lockdep checks on __task_cred().  This has shown up
a place in the signalling code where a lock should be held - namely that
check_kill_permission() requires its callers to hold the RCU lock.

Fix group_send_sig_info() to get the RCU read lock around its call to
check_kill_permission().

Without this patch, the following warning can occur:

  ===================================================
  [ INFO: suspicious rcu_dereference_check() usage. ]
  ---------------------------------------------------
  kernel/signal.c:660 invoked rcu_dereference_check() without protection!
  ...

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/signal.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 48f2130..edabc2f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -637,7 +637,7 @@ static inline bool si_fromuser(const struct siginfo *info)
 
 /*
  * Bad permissions for sending the signal
- * - the caller must hold at least the RCU read lock
+ * - the caller must hold the RCU read lock
  */
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
@@ -1126,11 +1126,14 @@ struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long
 
 /*
  * send signal info to all the members of a group
- * - the caller must hold the RCU read lock at least
  */
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret = check_kill_permission(sig, info, p);
+	int ret;
+
+	rcu_read_lock();
+	ret = check_kill_permission(sig, info, p);
+	rcu_read_unlock();
 
 	if (!ret && sig)
 		ret = do_send_sig_info(sig, info, p, true);
-- 
1.7.4.4

