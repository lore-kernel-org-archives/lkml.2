Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1LTT6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:58:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40968 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1LTT6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:58:13 -0500
Date: Tue, 20 Dec 2011 19:58:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220195806.GF23916@ZenIV.linux.org.uk>
References: <20111220062710.GC23916@ZenIV.linux.org.uk>
 <4EF03915.60902@linux.vnet.ibm.com>
 <1324373854.21588.16.camel@mengcong>
 <4EF0654B.4060904@linux.vnet.ibm.com>
 <4EF06C9B.4010703@linux.vnet.ibm.com>
 <4EF084A4.3000106@linux.vnet.ibm.com>
 <20111220140628.GD23916@ZenIV.linux.org.uk>
 <4EF09D34.1060607@linux.vnet.ibm.com>
 <20111220175919.GE23916@ZenIV.linux.org.uk>
 <4EF0DE04.6030604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF0DE04.6030604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 12:42:04AM +0530, Srivatsa S. Bhat wrote:
> register_hotcpu_notifier(...);
> grab spinlock
> for_each_online_cpu(N)
>   add N to bitmap
> release spinlock
> 
> because the latter code is not fully race-free (because we don't handle
> CPU_DOWN_PREPARE event in the callback and hence cpu_online_mask can get
> updated in-between). But it would still work since cpus going down don't
> really pose problems for us.

Um?  Sure, that loop can end up adding CPUs on their way down into the set.
And as soon as they get their CPU_DEAD, notifier will prune them out...  Or
is there something I'm missing here?  Anyway, the variant I have here
(untested) follows:

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..1951f67 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
 #define br_lock_init(name)	name##_lock_init()
@@ -72,9 +73,31 @@
 
 #define DEFINE_LGLOCK(name)						\
 									\
+ DEFINE_SPINLOCK(name##_cpu_lock);					\
+ cpumask_t name##_cpus __read_mostly;					\
  DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
  DEFINE_LGLOCK_LOCKDEP(name);						\
 									\
+ static int								\
+ name##_lg_cpu_callback(struct notifier_block *nb,			\
+				unsigned long action, void *hcpu)	\
+ {									\
+	switch (action & ~CPU_TASKS_FROZEN) {				\
+	case CPU_UP_PREPARE:						\
+		spin_lock(&name##_cpu_lock);				\
+		cpu_set((unsigned long)hcpu, name##_cpus);		\
+		spin_unlock(&name##_cpu_lock);				\
+		break;							\
+	case CPU_UP_CANCELED: case CPU_DEAD:				\
+		spin_lock(&name##_cpu_lock);				\
+		cpu_clear((unsigned long)hcpu, name##_cpus);		\
+		spin_unlock(&name##_cpu_lock);				\
+	}								\
+	return NOTIFY_OK;						\
+ }									\
+ static struct notifier_block name##_lg_cpu_notifier = {		\
+	.notifier_call = name##_lg_cpu_callback,			\
+ };									\
  void name##_lock_init(void) {						\
 	int i;								\
 	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
@@ -83,6 +106,11 @@
 		lock = &per_cpu(name##_lock, i);			\
 		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
 	}								\
+	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
+	spin_lock(&name##_cpu_lock);					\
+	for_each_online_cpu(i)						\
+		cpu_set(i, name##_cpus);				\
+	spin_unlock(&name##_cpu_lock);					\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -124,9 +152,9 @@
 									\
  void name##_global_lock_online(void) {					\
 	int i;								\
-	preempt_disable();						\
+	spin_lock(&name##_cpu_lock);					\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, &name##_cpus) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_lock(lock);					\
@@ -137,12 +165,12 @@
  void name##_global_unlock_online(void) {				\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, &name##_cpus) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\
 	}								\
-	preempt_enable();						\
+	spin_unlock(&name##_cpu_lock);					\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\
 									\
