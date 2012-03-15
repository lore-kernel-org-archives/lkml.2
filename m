Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555Ab2COOuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:50:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55023 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2COOtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:49:52 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dennis1.Chen@amd.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/7] module: take rcu_read_lock_sched for find_module
Date: Thu, 15 Mar 2012 22:48:57 +0800
Message-Id: <1331822941-19938-3-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to find_symbol(), find_module() also iterates module list,
should use list_for_each_entry_rcu() too, thus its callers should
hold rcu_read_lock_sched before calling it.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b31b23f..f210d74 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -413,7 +413,7 @@ struct module *find_module(const char *name)
 {
 	struct module *mod;
 
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (strcmp(mod->name, name) == 0)
 			return mod;
 	}
@@ -778,14 +778,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
-
+	rcu_read_lock_sched();
 	mod = find_module(name);
 	if (!mod) {
-		ret = -ENOENT;
-		goto out;
+		rcu_read_unlock_sched();
+		return -ENOENT;
 	}
+	rcu_read_unlock_sched();
+
+	if (mutex_lock_interruptible(&module_mutex) != 0)
+		return -EINTR;
 
 	if (!list_empty(&mod->source_list)) {
 		/* Other modules depend on us: get rid of them first. */
@@ -2899,18 +2901,13 @@ static struct module *load_module(void __user *umod,
 	/* Mark state as coming so strong_try_module_get() ignores us. */
 	mod->state = MODULE_STATE_COMING;
 
-	/* Now sew it into the lists so we can get lockdep and oops
-	 * info during argument parsing.  No one should access us, since
-	 * strong_try_module_get() will fail.
-	 * lockdep/oops can run asynchronous, so use the RCU list insertion
-	 * function to insert in a way safe to concurrent readers.
-	 * The mutex protects against concurrent writers.
-	 */
-	mutex_lock(&module_mutex);
+	rcu_read_lock_sched();
 	if (find_module(mod->name)) {
 		err = -EEXIST;
-		goto unlock;
+		rcu_read_unlock_sched();
+		goto free_args;
 	}
+	rcu_read_unlock_sched();
 
 	/* This has to be done once we're sure module name is unique. */
 	dynamic_debug_setup(info.debug, info.num_debug);
@@ -2920,6 +2917,14 @@ static struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto ddebug;
 
+	/* Now sew it into the lists so we can get lockdep and oops
+	 * info during argument parsing.  No one should access us, since
+	 * strong_try_module_get() will fail.
+	 * lockdep/oops can run asynchronous, so use the RCU list insertion
+	 * function to insert in a way safe to concurrent readers.
+	 * The mutex protects against concurrent writers.
+	 */
+	mutex_lock(&module_mutex);
 	module_bug_finalize(info.hdr, info.sechdrs, mod);
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
@@ -2946,12 +2951,11 @@ static struct module *load_module(void __user *umod,
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	module_bug_cleanup(mod);
-
- ddebug:
-	dynamic_debug_remove(info.debug);
- unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
+ ddebug:
+	dynamic_debug_remove(info.debug);
+ free_args:
 	kfree(mod->args);
  free_arch_cleanup:
 	module_arch_cleanup(mod);
-- 
1.7.7.6

