Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1ABHYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:36020 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1ABHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 141/260] KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
Date: Sun,  2 Jan 2011 02:17:17 -0500
Message-Id: <1293952756-15010-142-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:44.0556 (UTC) FILETIME=[D95410C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 9d1ac65a9698513d00e5608d93fca0c53f536c14 upstream.

There's an protected access to the parent process's credentials in the middle
of keyctl_session_to_parent().  This results in the following RCU warning:

  ===================================================
  [ INFO: suspicious rcu_dereference_check() usage. ]
  ---------------------------------------------------
  security/keys/keyctl.c:1291 invoked rcu_dereference_check() without protection!

  other info that might help us debug this:

  rcu_scheduler_active = 1, debug_locks = 0
  1 lock held by keyctl-session-/2137:
   #0:  (tasklist_lock){.+.+..}, at: [<ffffffff811ae2ec>] keyctl_session_to_parent+0x60/0x236

  stack backtrace:
  Pid: 2137, comm: keyctl-session- Not tainted 2.6.36-rc2-cachefs+ #1
  Call Trace:
   [<ffffffff8105606a>] lockdep_rcu_dereference+0xaa/0xb3
   [<ffffffff811ae379>] keyctl_session_to_parent+0xed/0x236
   [<ffffffff811af77e>] sys_keyctl+0xb4/0xb6
   [<ffffffff81001eab>] system_call_fastpath+0x16/0x1b

The code should take the RCU read lock to make sure the parents credentials
don't go away, even though it's holding a spinlock and has IRQ disabled.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 security/keys/keyctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index e9c2e7c..d29e022 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1259,6 +1259,7 @@ long keyctl_session_to_parent(void)
 	keyring_r = NULL;
 
 	me = current;
+	rcu_read_lock();
 	write_lock_irq(&tasklist_lock);
 
 	parent = me->real_parent;
@@ -1313,6 +1314,7 @@ long keyctl_session_to_parent(void)
 	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
 
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	if (oldcred)
 		put_cred(oldcred);
 	return 0;
@@ -1321,6 +1323,7 @@ already_same:
 	ret = 0;
 not_permitted:
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	put_cred(cred);
 	return ret;
 
-- 
1.7.3.3

