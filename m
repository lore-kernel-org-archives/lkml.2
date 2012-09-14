Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2INHK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:10:27 -0400
Received: from ozlabs.org ([203.10.76.45]:40998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2INHKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:10:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Jon Masters" <jonathan@jonmasters.org>
Subject: [PATCH 1/2] module: fix symbol waiting when module fails before init
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 14 Sep 2012 16:39:49 +0930
Message-ID: <87obl9rsg2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use resolve_symbol_wait(), which blocks if the module containing
the symbol is still loading.  However:

1) The module_wq we use is only woken after calling the modules' init
   function, but there are other failure paths after the module is
   placed in the linked list where we need to do the same thing.

2) wake_up() only wakes one waiter, and our waitqueue is shared by all
   modules, so we need to wake them all.

3) wake_up_all() doesn't imply a memory barrier: I feel happier calling
   it after we've grabbed and dropped the module_mutex, not just after
   the state assignment.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2959,7 +2959,7 @@ static struct module *load_module(void _
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	module_bug_cleanup(mod);
-
+	wake_up_all(&module_wq);
  ddebug:
 	dynamic_debug_remove(info.debug);
  unlock:
@@ -3034,7 +3034,7 @@ SYSCALL_DEFINE3(init_module, void __user
 		blocking_notifier_call_chain(&module_notify_list,
 					     MODULE_STATE_GOING, mod);
 		free_module(mod);
-		wake_up(&module_wq);
+		wake_up_all(&module_wq);
 		return ret;
 	}
 	if (ret > 0) {
@@ -3046,9 +3046,8 @@ SYSCALL_DEFINE3(init_module, void __user
 		dump_stack();
 	}
 
-	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
+	/* Now it's a first class citizen! */
 	mod->state = MODULE_STATE_LIVE;
-	wake_up(&module_wq);
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
@@ -3071,6 +3070,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	mod->init_ro_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
+	wake_up_all(&module_wq);
 
 	return 0;
 }
