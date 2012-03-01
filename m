Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2CATFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:05:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2CATDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:48 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=HFVpj_IvKp4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=L4dDwNL1vE8Sdrb2iE4A:9 a=CRhKQBduhJzEogDZVG4A:7 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190345.374756214@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 3/9][RFC] [PATCH 3/9] lglock/rt: Use non-rt for_each_cpu() in -rt code
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0003-lglock-rt-Use-non-rt-for_each_cpu-in-rt-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the RT version of the lglocks() does a for_each_online_cpu()
in the name##_global_lock_online() functions. Non-rt uses its own
mask for this, and for good reason.

A task may grab a *_global_lock_online(), and in the mean time, one
of the CPUs goes offline. Now when that task does a *_global_unlock_online()
it releases all the locks *except* the one that went offline.

Now if that CPU were to come back on line, its lock is now owned by a
task that never released it when it should have.

This causes all sorts of fun errors. Like owners of a lock no longer
existing, or sleeping on IO, waiting to be woken up by a task that
happens to be blocked on the lock it never released.

Convert the RT versions to use the lglock specific cpumasks. As once
a CPU comes on line, the mask is set, and never cleared even when the
CPU goes offline. The locks for that CPU will still be taken and released.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/lglock.h |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index 52b289f..cdfcef3 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -203,9 +203,31 @@
 #else /* !PREEMPT_RT_FULL */
 #define DEFINE_LGLOCK(name)						\
 									\
- DEFINE_PER_CPU(struct rt_mutex, name##_lock);					\
+ DEFINE_PER_CPU(struct rt_mutex, name##_lock);				\
+ DEFINE_SPINLOCK(name##_cpu_lock);					\
+ cpumask_t name##_cpus __read_mostly;					\
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
@@ -214,6 +236,11 @@
 		lock = &per_cpu(name##_lock, i);			\
 		rt_mutex_init(lock);					\
 	}								\
+	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
+	get_online_cpus();						\
+	for_each_online_cpu(i)						\
+		cpu_set(i, name##_cpus);				\
+	put_online_cpus();						\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -254,7 +281,8 @@
  void name##_global_lock_online(void) {					\
 	int i;								\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	spin_lock(&name##_cpu_lock);					\
+	for_each_cpu(i, &name##_cpus) {					\
 		struct rt_mutex *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		__rt_spin_lock(lock);					\
@@ -265,11 +293,12 @@
  void name##_global_unlock_online(void) {				\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, &name##_cpus) {					\
 		struct rt_mutex *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		__rt_spin_unlock(lock);					\
 	}								\
+	spin_unlock(&name##_cpu_lock);					\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\
 									\
-- 
1.7.3.4


