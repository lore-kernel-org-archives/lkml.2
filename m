Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab1LPUJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:09:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760504Ab1LPTsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:56 2011
Message-Id: <20111216194556.461886931@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yong Zhang <yong.zhang0@gmail.com>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [15/53] lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Zhang <yong.zhang0@gmail.com>

commit a33caeb118198286309859f014c0662f3ed54ed4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/lockdep.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -44,6 +44,7 @@
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/sections.h>
 
@@ -2874,7 +2875,12 @@ static int mark_lock(struct task_struct
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


