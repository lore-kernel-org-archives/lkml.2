Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2INGTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:19:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49023 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2INGTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:19:03 -0400
Date: Thu, 13 Sep 2012 23:18:46 -0700
From: tip-bot for Maarten Lankhorst <maarten.lankhorst@canonical.com>
Message-ID: <tip-d094595078d00b63839d0c5ccb8b184ef242cb45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
In-Reply-To: <5051A9E7.5040501@canonical.com>
References: <5051A9E7.5040501@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Check if nested lock is actually held
Git-Commit-ID: d094595078d00b63839d0c5ccb8b184ef242cb45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:18:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d094595078d00b63839d0c5ccb8b184ef242cb45
Gitweb:     http://git.kernel.org/tip/d094595078d00b63839d0c5ccb8b184ef242cb45
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Thu, 13 Sep 2012 11:39:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:00:44 +0200

lockdep: Check if nested lock is actually held

It is considered good form to lock the lock you claim to be nested in.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

[ removed nest_lock arg to print_lock_nested_lock_not_held in favour
  of hlock->nest_lock, also renamed the lock arg to hlock since its
  a held_lock type ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/5051A9E7.5040501@canonical.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ea9ee45..7981e5b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2998,6 +2998,42 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
 
+static int
+print_lock_nested_lock_not_held(struct task_struct *curr,
+				struct held_lock *hlock,
+				unsigned long ip)
+{
+	if (!debug_locks_off())
+		return 0;
+	if (debug_locks_silent)
+		return 0;
+
+	printk("\n");
+	printk("==================================\n");
+	printk("[ BUG: Nested lock was not taken ]\n");
+	print_kernel_ident();
+	printk("----------------------------------\n");
+
+	printk("%s/%d is trying to lock:\n", curr->comm, task_pid_nr(curr));
+	print_lock(hlock);
+
+	printk("\nbut this task is not holding:\n");
+	printk("%s\n", hlock->nest_lock->name);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	printk("\nother info that might help us debug this:\n");
+	lockdep_print_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	return 0;
+}
+
+static int __lock_is_held(struct lockdep_map *lock);
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -3139,6 +3175,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	}
 	chain_key = iterate_chain_key(chain_key, id);
 
+	if (nest_lock && !__lock_is_held(nest_lock))
+		return print_lock_nested_lock_not_held(curr, hlock, ip);
+
 	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
 
