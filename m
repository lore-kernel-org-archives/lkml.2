Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab2BUUDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab2BUUDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:40 -0500
Date: Tue, 21 Feb 2012 15:03:17 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        pjt@google.com, linux-kernel@vger.kernel.org
Message-Id: <cb1eabd442308d9407c01a6656457282574e6990.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 07/10] sched: update to use very_[un]likely()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update scheduler with api change: static_branch() -> very_unlikely().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |    2 --
 kernel/sched/core.c        |   12 ++++++------
 kernel/sched/fair.c        |    2 +-
 kernel/sched/sched.h       |    4 ++--
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index fdf6fff..757d8dc 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -221,8 +221,6 @@ jump_label_rate_limit(struct jump_label_key_deferred *key,
 
 #endif	/* HAVE_JUMP_LABEL */
 
-#define jump_label_key_enabled JUMP_LABEL_INIT_TRUE
-#define jump_label_key_disabled JUMP_LABEL_INIT_FALSE
 #define JUMP_LABEL_INIT JUMP_LABEL_INIT_FALSE
 #define jump_label_enabled jump_label_true
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..a357dbf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -162,8 +162,8 @@ static int sched_feat_show(struct seq_file *m, void *v)
 
 #ifdef HAVE_JUMP_LABEL
 
-#define jump_label_key__true  jump_label_key_enabled
-#define jump_label_key__false jump_label_key_disabled
+#define jump_label_key__true  JUMP_LABEL_INIT_TRUE
+#define jump_label_key__false JUMP_LABEL_INIT_FALSE
 
 #define SCHED_FEAT(name, enabled)	\
 	jump_label_key__##enabled ,
@@ -176,13 +176,13 @@ struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
 
 static void sched_feat_disable(int i)
 {
-	if (jump_label_enabled(&sched_feat_keys[i]))
+	if (jump_label_true(&sched_feat_keys[i]))
 		jump_label_dec(&sched_feat_keys[i]);
 }
 
 static void sched_feat_enable(int i)
 {
-	if (!jump_label_enabled(&sched_feat_keys[i]))
+	if (!jump_label_true(&sched_feat_keys[i]))
 		jump_label_inc(&sched_feat_keys[i]);
 }
 #else
@@ -894,7 +894,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	delta -= irq_delta;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	if (static_branch((&paravirt_steal_rq_enabled))) {
+	if (very_unlikely((&paravirt_steal_rq_enabled))) {
 		u64 st;
 
 		steal = paravirt_steal_clock(cpu_of(rq));
@@ -2756,7 +2756,7 @@ void account_idle_time(cputime_t cputime)
 static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
-	if (static_branch(&paravirt_steal_enabled)) {
+	if (very_unlikely(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
 		steal = paravirt_steal_clock(smp_processor_id());
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..67206ae 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1403,7 +1403,7 @@ static struct jump_label_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
 {
-	return static_branch(&__cfs_bandwidth_used);
+	return very_unlikely(&__cfs_bandwidth_used);
 }
 
 void account_cfs_bandwidth_used(int enabled, int was_enabled)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..addeb9e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -632,12 +632,12 @@ enum {
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
 static __always_inline bool static_branch__true(struct jump_label_key *key)
 {
-	return likely(static_branch(key)); /* Not out of line branch. */
+	return very_likely(key); /* Not out of line branch. */
 }
 
 static __always_inline bool static_branch__false(struct jump_label_key *key)
 {
-	return unlikely(static_branch(key)); /* Out of line branch. */
+	return very_unlikely(key); /* Out of line branch. */
 }
 
 #define SCHED_FEAT(name, enabled)					\
-- 
1.7.7.5

