Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1KIIFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:05:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58320 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1KIIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:05:04 -0500
Date: Wed, 9 Nov 2011 16:04:51 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Subject: [PATCH 1/2] lockdep: kmemcheck: annotate ->lock in lockdep_init_map()
Message-ID: <20111109080451.GB8124@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
 <1320682230.17809.11.camel@twins>
 <20111108025847.GB11439@zhy>
 <1320739015.2244.0.camel@twins>
 <20111108081433.GA3746@zhy>
 <1320741980.2244.4.camel@twins>
 <20111108090735.GA4038@zhy>
 <1320745246.2244.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1320745246.2244.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:40:46AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-08 at 17:07 +0800, Yong Zhang wrote:
> > So something like below?
> 
> that fails to clear/init the class_cache, leading to all sorts of
> problems.
> 
> Wiping the class_cache just reduces performance somewhat, not wiping
> them is disastrous since it can results in wild pointer derefs.
> 
> Now we could fix up register_lock_class() to reset the class_cache,
> although that's a little tricky and I'm not sure its worth it.

Yeah, I have done some benchmark which show it's worthful, please
check patch#2.

And below is the one which cure the current problem.

Thanks,
Yong

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 1/2] lockdep: kmemcheck: annotate ->lock in lockdep_init_map()

Since commit f59de89 [lockdep: Clear whole lockdep_map on initialization],
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
---
 kernel/lockdep.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e69434b..21ea1dc 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2948,7 +2948,12 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
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
-- 
1.7.5.4

