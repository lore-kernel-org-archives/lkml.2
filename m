Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab0IXQ2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:51 -0400
Received: from kroah.org ([198.145.64.141]:38504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794Ab0IXQ2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:20 2010
Message-Id: <20100924162620.291849536@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, dann frazier <dannf@debian.org>
Subject: [62/80] KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/keyctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1259,6 +1259,7 @@ long keyctl_session_to_parent(void)
 	keyring_r = NULL;
 
 	me = current;
+	rcu_read_lock();
 	write_lock_irq(&tasklist_lock);
 
 	parent = me->real_parent;
@@ -1306,6 +1307,7 @@ long keyctl_session_to_parent(void)
 	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
 
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	if (oldcred)
 		put_cred(oldcred);
 	return 0;
@@ -1314,6 +1316,7 @@ already_same:
 	ret = 0;
 not_permitted:
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	put_cred(cred);
 	return ret;
 


