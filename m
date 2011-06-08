Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1FHMt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:49:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65157 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1FHMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=niN6DF3O5188l30+agL8oSY7r+HSxkhItQ+Vysr7LP5BC7haubDIKmG1S+ljZbx2wt
         ySqT1Ex6aNCaDU2/xV7kGqR9CIpzk393Cw/wEEDKkqZdYozy1SJ1Ji56qp+gxnyHNxXq
         ayNBPF1UWmwzsxu+7YvSXZxB69JU/CVjJnyiQ=
MIME-Version: 1.0
Date: Wed, 8 Jun 2011 20:49:53 +0800
Message-ID: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
Subject: [PATCH] sched: remove unreliable pointer in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dereference of unreliable owner pointer is unnecessary in owner_running(),
though under RCU protection, because the true result is only determined by
checking the validity of lock owner, as the comment says, due to likely heavy
lock contention, which has little to do with whether owner->on_cpu is false.

If owner->on_cpu is really false, only the owner_running loop is shortened,
but also returns incorrect result, since the lock owner is not changed, though
maybe changed soon.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched.c |   36 +-----------------------------------
 1 files changed, 1 insertions(+), 35 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd18f39..2c32616 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4293,52 +4293,18 @@ EXPORT_SYMBOL(schedule);

 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER

-static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
-{
-	bool ret = false;
-
-	rcu_read_lock();
-	if (lock->owner != owner)
-		goto fail;
-
-	/*
-	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
-	 * lock->owner still matches owner, if that fails, owner might
-	 * point to free()d memory, if it still matches, the rcu_read_lock()
-	 * ensures the memory stays valid.
-	 */
-	barrier();
-
-	ret = owner->on_cpu;
-fail:
-	rcu_read_unlock();
-
-	return ret;
-}
-
-/*
- * Look out! "owner" is an entirely speculative pointer
- * access and not reliable.
- */
 int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 {
 	if (!sched_feat(OWNER_SPIN))
 		return 0;

-	while (owner_running(lock, owner)) {
+	while (lock->owner != NULL) {
 		if (need_resched())
 			return 0;

 		arch_mutex_cpu_relax();
 	}

-	/*
-	 * If the owner changed to another task there is likely
-	 * heavy contention, stop spinning.
-	 */
-	if (lock->owner)
-		return 0;
-
 	return 1;
 }
 #endif
