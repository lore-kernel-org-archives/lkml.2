Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2JJNiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:38:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2JJNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:38:43 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JeV_2a4GC2EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0XAreQrArBoA:10 a=VwQbUJbxAAAA:8 a=ZZu7y38RQH-epXu9WawA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121010133842.809440374@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 10 Oct 2012 09:38:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/6] mm: slab: Fix potential deadlock
References: <20121010133801.331863565@goodmis.org>
Content-Disposition: inline; filename=0002-mm-slab-Fix-potential-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

 =============================================
[ INFO: possible recursive locking detected ]
 3.6.0-rt1+ #49 Not tainted
 ---------------------------------------------
 swapper/0/1 is trying to acquire lock:
 lock_slab_on+0x72/0x77

 but task is already holding lock:
 __local_lock_irq+0x24/0x77

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&per_cpu(slab_lock, __cpu).lock);
   lock(&per_cpu(slab_lock, __cpu).lock);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 2 locks held by swapper/0/1:
 kmem_cache_create+0x33/0x89
 __local_lock_irq+0x24/0x77

 stack backtrace:
 Pid: 1, comm: swapper/0 Not tainted 3.6.0-rt1+ #49
 Call Trace:
 __lock_acquire+0x9a4/0xdc4
 ? __local_lock_irq+0x24/0x77
 ? lock_slab_on+0x72/0x77
 lock_acquire+0xc4/0x108
 ? lock_slab_on+0x72/0x77
 ? unlock_slab_on+0x5b/0x5b
 rt_spin_lock+0x36/0x3d
 ? lock_slab_on+0x72/0x77
 ? migrate_disable+0x85/0x93
 lock_slab_on+0x72/0x77
 do_ccupdate_local+0x19/0x44
 slab_on_each_cpu+0x36/0x5a
 do_tune_cpucache+0xc1/0x305
 enable_cpucache+0x8c/0xb5
 setup_cpu_cache+0x28/0x182
 __kmem_cache_create+0x34b/0x380
 ? shmem_mount+0x1a/0x1a
 kmem_cache_create+0x4a/0x89
 ? shmem_mount+0x1a/0x1a
 shmem_init+0x3e/0xd4
 kernel_init+0x11c/0x214
 kernel_thread_helper+0x4/0x10
 ? retint_restore_args+0x13/0x13
 ? start_kernel+0x3bc/0x3bc
 ? gs_change+0x13/0x13

It's not a missing annotation. It's simply wrong code and needs to be
fixed. Instead of nesting the local and the remote cpu lock simply
acquire only the remote cpu lock, which is sufficient protection for
this procedure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/locallock.h |    8 ++++++++
 mm/slab.c                 |   10 ++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index 8fbc393..0161fbb 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -96,6 +96,9 @@ static inline void __local_lock_irq(struct local_irq_lock *lv)
 #define local_lock_irq(lvar)						\
 	do { __local_lock_irq(&get_local_var(lvar)); } while (0)
 
+#define local_lock_irq_on(lvar, cpu)					\
+	do { __local_lock_irq(&per_cpu(lvar, cpu)); } while (0)
+
 static inline void __local_unlock_irq(struct local_irq_lock *lv)
 {
 	LL_WARN(!lv->nestcnt);
@@ -111,6 +114,11 @@ static inline void __local_unlock_irq(struct local_irq_lock *lv)
 		put_local_var(lvar);					\
 	} while (0)
 
+#define local_unlock_irq_on(lvar, cpu)					\
+	do {								\
+		__local_unlock_irq(&per_cpu(lvar, cpu));		\
+	} while (0)
+
 static inline int __local_lock_irqsave(struct local_irq_lock *lv)
 {
 	if (lv->owner != current) {
diff --git a/mm/slab.c b/mm/slab.c
index f451650..d7cdccb 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -745,18 +745,12 @@ slab_on_each_cpu(void (*func)(void *arg, int this_cpu), void *arg)
 
 static void lock_slab_on(unsigned int cpu)
 {
-	if (cpu == smp_processor_id())
-		local_lock_irq(slab_lock);
-	else
-		local_spin_lock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
+	local_lock_irq_on(slab_lock, cpu);
 }
 
 static void unlock_slab_on(unsigned int cpu)
 {
-	if (cpu == smp_processor_id())
-		local_unlock_irq(slab_lock);
-	else
-		local_spin_unlock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
+	local_unlock_irq_on(slab_lock, cpu);
 }
 #endif
 
-- 
1.7.10.4


