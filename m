Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab2JLBWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:22:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab2JLBV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:21:28 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QR-o9JM4IVQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oHo0cinKwKoA:10 a=VwQbUJbxAAAA:8 a=00CX1lbMB8ObnoKVni4A:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121012012126.374055723@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Oct 2012 21:20:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 5/8] rt: rwsem/rwlock: lockdep annotations
References: <20121012012024.056658930@goodmis.org>
Content-Disposition: inline; filename=0005-rt-rwsem-rwlock-lockdep-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

rwlocks and rwsems on RT do not allow multiple readers. Annotate the
lockdep acquire functions accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rt.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/kernel/rt.c b/kernel/rt.c
index 092d6b3..aa10504 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -216,15 +216,17 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * write locked.
 	 */
 	migrate_disable();
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(lock);
-	else if (!rwlock->read_depth)
+		if (ret)
+			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
+	} else if (!rwlock->read_depth) {
 		ret = 0;
+	}
 
-	if (ret) {
+	if (ret)
 		rwlock->read_depth++;
-		rwlock_acquire_read(&rwlock->dep_map, 0, 1, _RET_IP_);
-	} else
+	else
 		migrate_enable();
 
 	return ret;
@@ -242,13 +244,13 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 {
 	struct rt_mutex *lock = &rwlock->lock;
 
-	rwlock_acquire_read(&rwlock->dep_map, 0, 0, _RET_IP_);
-
 	/*
 	 * recursive read locks succeed when current owns the lock
 	 */
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
+		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
 		__rt_spin_lock(lock);
+	}
 	rwlock->read_depth++;
 }
 
@@ -264,11 +266,11 @@ EXPORT_SYMBOL(rt_write_unlock);
 
 void __lockfunc rt_read_unlock(rwlock_t *rwlock)
 {
-	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
-
 	/* Release the lock only when read_depth is down to 0 */
-	if (--rwlock->read_depth == 0)
+	if (--rwlock->read_depth == 0) {
+		rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 		__rt_spin_unlock(&rwlock->lock);
+	}
 }
 EXPORT_SYMBOL(rt_read_unlock);
 
@@ -315,9 +317,10 @@ EXPORT_SYMBOL(rt_up_write);
 
 void  rt_up_read(struct rw_semaphore *rwsem)
 {
-	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	if (--rwsem->read_depth == 0)
+	if (--rwsem->read_depth == 0) {
+		rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
 		rt_mutex_unlock(&rwsem->lock);
+	}
 }
 EXPORT_SYMBOL(rt_up_read);
 
@@ -366,15 +369,16 @@ int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 	 * but not when read_depth == 0 which means that the rwsem is
 	 * write locked.
 	 */
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(&rwsem->lock);
-	else if (!rwsem->read_depth)
+		if (ret)
+			rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
+	} else if (!rwsem->read_depth) {
 		ret = 0;
+	}
 
-	if (ret) {
+	if (ret)
 		rwsem->read_depth++;
-		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
-	}
 	return ret;
 }
 EXPORT_SYMBOL(rt_down_read_trylock);
@@ -383,10 +387,10 @@ static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 {
 	struct rt_mutex *lock = &rwsem->lock;
 
-	rwsem_acquire_read(&rwsem->dep_map, subclass, 0, _RET_IP_);
-
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
+		rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
 		rt_mutex_lock(&rwsem->lock);
+	}
 	rwsem->read_depth++;
 }
 
-- 
1.7.10.4


