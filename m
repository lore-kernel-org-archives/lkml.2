Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989Ab0HFSgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:36:35 -0400
Received: from kroah.org ([198.145.64.141]:48716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964947Ab0HFSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:06 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:02 2010
Message-Id: <20100806183202.679209582@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [30/38] CRED: Fix RCU warning due to previous patch fixing __task_cred()s checks
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -637,7 +637,7 @@ static inline bool si_fromuser(const str
 
 /*
  * Bad permissions for sending the signal
- * - the caller must hold at least the RCU read lock
+ * - the caller must hold the RCU read lock
  */
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
@@ -1127,11 +1127,14 @@ struct sighand_struct *lock_task_sighand
 
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


