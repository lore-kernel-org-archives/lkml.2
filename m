Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1BJMbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:31:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1BJMYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:38 -0500
From: stable-bot for Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 09:50:40 +0100
Subject: [PATCH 02/28] sched: Remove remaining USER_SCHED code
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 32bd7eb5a7f4596c8440dd9440322fe9e686634d upstream
Author: Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed Mar 24 13:17:19 2010 +0800

This is left over from commit 7c9414385e ("sched: Remove USER_SCHED"")

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>
LKML-Reference: <4BA9A05F.7010407@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/Kconfig            |    3 +--
 kernel/capability.c     |    1 -
 kernel/cred-internals.h |   21 ---------------------
 kernel/cred.c           |    3 ---
 kernel/exit.c           |    1 -
 kernel/sched_debug.c    |    5 -----
 kernel/user.c           |   10 +---------
 7 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index e83ea10..0d6388a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -568,8 +568,7 @@ config RT_GROUP_SCHED
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth
-	  to users or control groups (depending on the "Basis for grouping tasks"
-	  setting below. If enabled, it will also make it impossible to
+	  to task groups. If enabled, it will also make it impossible to
 	  schedule realtime tasks for non-root users until you allocate
 	  realtime bandwidth for them.
 	  See Documentation/scheduler/sched-rt-group.txt for more information.
diff --git a/kernel/capability.c b/kernel/capability.c
index 4e17041..8a944f5 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -15,7 +15,6 @@
 #include <linux/syscalls.h>
 #include <linux/pid_namespace.h>
 #include <asm/uaccess.h>
-#include "cred-internals.h"
 
 /*
  * Leveraged for setting/resetting capabilities
diff --git a/kernel/cred-internals.h b/kernel/cred-internals.h
deleted file mode 100644
index 2dc4fc2..0000000
--- a/kernel/cred-internals.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* Internal credentials stuff
- *
- * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-/*
- * user.c
- */
-static inline void sched_switch_user(struct task_struct *p)
-{
-#ifdef CONFIG_USER_SCHED
-	sched_move_task(p);
-#endif	/* CONFIG_USER_SCHED */
-}
-
diff --git a/kernel/cred.c b/kernel/cred.c
index 099f5e6..5fce398 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -16,7 +16,6 @@
 #include <linux/init_task.h>
 #include <linux/security.h>
 #include <linux/cn_proc.h>
-#include "cred-internals.h"
 
 #if 0
 #define kdebug(FMT, ...) \
@@ -553,8 +552,6 @@ int commit_creds(struct cred *new)
 		atomic_dec(&old->user->processes);
 	alter_cred_subscribers(old, -2);
 
-	sched_switch_user(task);
-
 	/* send notifications */
 	if (new->uid   != old->uid  ||
 	    new->euid  != old->euid ||
diff --git a/kernel/exit.c b/kernel/exit.c
index d890628..0f8fae3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -54,7 +54,6 @@
 #include <asm/unistd.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include "cred-internals.h"
 
 static void exit_mm(struct task_struct * tsk);
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 6f836a8..f9724c0 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -173,11 +173,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	task_group_path(tg, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
-#elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
-	{
-		uid_t uid = cfs_rq->tg->uid;
-		SEQ_printf(m, "\ncfs_rq[%d] for UID: %u\n", cpu, uid);
-	}
 #else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #endif
diff --git a/kernel/user.c b/kernel/user.c
index 766467b..65be394 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/user_namespace.h>
-#include "cred-internals.h"
 
 struct user_namespace init_user_ns = {
 	.kref = {
@@ -137,9 +136,7 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up, *new;
 
-	/* Make uid_hash_find() + uids_user_create() + uid_hash_insert()
-	 * atomic.
-	 */
+	/* Make uid_hash_find() + uid_hash_insert() atomic. */
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
 	spin_unlock_irq(&uidhash_lock);
@@ -161,11 +158,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
-			/* This case is not possible when CONFIG_USER_SCHED
-			 * is defined, since we serialize alloc_uid() using
-			 * uids_mutex. Hence no need to call
-			 * sched_destroy_user() or remove_user_sysfs_dir().
-			 */
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
-- 
1.7.4


