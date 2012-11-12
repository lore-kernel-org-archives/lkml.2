Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2KLUwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:52:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23577 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2KLUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:52:48 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, penberg@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] lockdep: be nice about building from userspace
Date: Mon, 12 Nov 2012 15:50:46 -0500
Message-Id: <1352753446-24109-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep is an awesome piece of code which detects locking issues which are
relevant both to userspace and kernelspace. We can easily make lockdep
work in userspace since there is really no kernel spacific magic going
on in the code.

All we need is to wrap two functions which are used by lockdep and are
very kernel specific.

Doing that will allow tools located in tools/ to easily utilize lockdep's
code for their own use.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/lockdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..e898cfe 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -584,6 +584,7 @@ static int very_verbose(struct lock_class *class)
 /*
  * Is this the address of a static object:
  */
+#ifdef __KERNEL__
 static int static_obj(void *obj)
 {
 	unsigned long start = (unsigned long) &_stext,
@@ -610,6 +611,7 @@ static int static_obj(void *obj)
 	 */
 	return is_module_address(addr) || is_module_percpu_address(addr);
 }
+#endif
 
 /*
  * To make lock name printouts unique, we calculate a unique
@@ -4109,6 +4111,7 @@ void debug_check_no_locks_held(struct task_struct *task)
 		print_held_locks_bug(task);
 }
 
+#ifdef __KERNEL__
 void debug_show_all_locks(void)
 {
 	struct task_struct *g, *p;
@@ -4166,6 +4169,7 @@ retry:
 		read_unlock(&tasklist_lock);
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
+#endif
 
 /*
  * Careful: only use this function if you are sure that
-- 
1.8.0

