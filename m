Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1LUTJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:09:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab1LUTJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:09:27 -0500
Date: Wed, 21 Dec 2011 14:09:18 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        mingo@elte.hu, davem@davemloft.net, ddaney.cavm@gmail.com,
        pjt@google.com, rth@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <88d060de71b09bc05249c87b21972fce38d54d87.1324493360.git.jbaron@redhat.com>
In-Reply-To: <cover.1324493360.git.jbaron@redhat.com>
References: <cover.1324493360.git.jbaron@redhat.com>
Subject: [PATCH 4/4] sched: Make use of new jump label API.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update scheduler.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/sched/core.c  |   12 ++++++------
 kernel/sched/fair.c  |    2 +-
 kernel/sched/sched.h |   11 +----------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7ea688..9b8c4fd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -161,8 +161,8 @@ static int sched_feat_show(struct seq_file *m, void *v)
 
 #ifdef HAVE_JUMP_LABEL
 
-#define jump_label_key__true  jump_label_key_enabled
-#define jump_label_key__false jump_label_key_disabled
+#define jump_label_key__true  JUMP_LABEL_INIT_TRUE
+#define jump_label_key__false JUMP_LABEL_INIT_FALSE
 
 #define SCHED_FEAT(name, enabled)	\
 	jump_label_key__##enabled ,
@@ -175,13 +175,13 @@ struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
 
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
@@ -899,7 +899,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	delta -= irq_delta;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	if (static_branch((&paravirt_steal_rq_enabled))) {
+	if (static_branch_def_false((&paravirt_steal_rq_enabled))) {
 		u64 st;
 
 		steal = paravirt_steal_clock(cpu_of(rq));
@@ -2760,7 +2760,7 @@ void account_idle_time(cputime_t cputime)
 static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
-	if (static_branch(&paravirt_steal_enabled)) {
+	if (static_branch_def_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
 		steal = paravirt_steal_clock(smp_processor_id());
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..877c2ec 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1405,7 +1405,7 @@ static struct jump_label_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
 {
-	return static_branch(&__cfs_bandwidth_used);
+	return static_branch_def_false(&__cfs_bandwidth_used);
 }
 
 void account_cfs_bandwidth_used(int enabled, int was_enabled)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d8d3613..d2f930c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -600,20 +600,11 @@ enum {
 #undef SCHED_FEAT
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
-static __always_inline bool static_branch__true(struct jump_label_key *key)
-{
-	return likely(static_branch(key)); /* Not out of line branch. */
-}
-
-static __always_inline bool static_branch__false(struct jump_label_key *key)
-{
-	return unlikely(static_branch(key)); /* Out of line branch. */
-}
 
 #define SCHED_FEAT(name, enabled)					\
 static __always_inline bool static_branch_##name(struct jump_label_key *key) \
 {									\
-	return static_branch__##enabled(key);				\
+	return static_branch_def_##enabled(key);				\
 }
 
 #include "features.h"
-- 
1.7.7.3

