Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab1LFJk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:40:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:40:27 -0500
Date: Tue, 6 Dec 2011 01:39:42 -0800
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-d3d03d4fc5b1bec3a579112de170a9676e9d97cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
        sergey.senozhatsky@gmail.com, bp@alien8.de, tj@kernel.org,
        tglx@linutronix.de, yong.zhang0@gmail.com, rientjes@google.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
        sergey.senozhatsky@gmail.com, bp@alien8.de, tj@kernel.org,
        yong.zhang0@gmail.com, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu
In-Reply-To: <20111109080451.GB8124@zhy>
References: <20111109080451.GB8124@zhy>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()
Git-Commit-ID: d3d03d4fc5b1bec3a579112de170a9676e9d97cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:39:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3d03d4fc5b1bec3a579112de170a9676e9d97cb
Gitweb:     http://git.kernel.org/tip/d3d03d4fc5b1bec3a579112de170a9676e9d97cb
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Wed, 9 Nov 2011 16:04:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:16:51 +0100

lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()

Since commit f59de89 ("lockdep: Clear whole lockdep_map on initialization"),
lockdep_init_map() will clear all the struct. But it will break
lock_set_class()/lock_set_subclass(). A typical race condition
is like below:

     CPU A                                   CPU B
lock_set_subclass(lockA);
 lock_set_class(lockA);
   lockdep_init_map(lockA);
     /* lockA->name is cleared */
     memset(lockA);
                                     __lock_acquire(lockA);
                                       /* lockA->class_cache[] is cleared */
                                       register_lock_class(lockA);
                                         look_up_lock_class(lockA);
                                           WARN_ON_ONCE(class->name !=
                                                     lock->name);

     lock->name = name;

So restore to what we have done before commit f59de89 but annotate
->lock with kmemcheck_mark_initialized() to suppress the kmemcheck
warning reported in commit f59de89.

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Suggested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111109080451.GB8124@zhy
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index a2ab30c..54cc0dc 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -44,6 +44,7 @@
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/sections.h>
 
@@ -2950,7 +2951,12 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	memset(lock, 0, sizeof(*lock));
+	int i;
+
+	kmemcheck_mark_initialized(lock, sizeof(*lock));
+
+	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
+		lock->class_cache[i] = NULL;
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
