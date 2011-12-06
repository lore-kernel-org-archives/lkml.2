Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab1LFJsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:48:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:48:22 -0500
Date: Tue, 6 Dec 2011 01:48:06 -0800
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-b202952075f62603bea9bfb6ebc6b0420db11949@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, jbaron@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <20111127155909.GO2557@redhat.com>
References: <20111127155909.GO2557@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, core: Rate limit perf_sched_events jump_label patching
Git-Commit-ID: b202952075f62603bea9bfb6ebc6b0420db11949
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:48:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b202952075f62603bea9bfb6ebc6b0420db11949
Gitweb:     http://git.kernel.org/tip/b202952075f62603bea9bfb6ebc6b0420db11949
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Sun, 27 Nov 2011 17:59:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:34:02 +0100

perf, core: Rate limit perf_sched_events jump_label patching

jump_lable patching is very expensive operation that involves pausing all
cpus. The patching of perf_sched_events jump_label is easily controllable
from userspace by unprivileged user.

When te user runs a loop like this:

  "while true; do perf stat -e cycles true; done"

... the performance of my test application that just increments a counter
for one second drops by 4%.

This is on a 16 cpu box with my test application using only one of
them. An impact on a real server doing real work will be worse.

Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
record" since KVM PMU implementation creates and destroys perf event
frequently.

This patch introduces a way to rate limit jump_label patching and uses
it to fix the above problem.

I believe that as jump_label use will spread the problem will become more
common and thus solving it in a generic code is appropriate. Also fixing
it in the perf code would result in moving jump_label accounting logic to
perf code with all the ifdefs in case of JUMP_LABEL=n kernel. With this
patch all details are nicely hidden inside jump_label code.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111127155909.GO2557@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label.h |   24 ++++++++++++++++++++++++
 include/linux/perf_event.h |    6 +++---
 kernel/events/core.c       |   13 ++++++++-----
 kernel/jump_label.c        |   35 +++++++++++++++++++++++++++++++++--
 4 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 388b0d4..a1e7f90 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/workqueue.h>
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
@@ -14,6 +15,12 @@ struct jump_label_key {
 #endif
 };
 
+struct jump_label_key_deferred {
+	struct jump_label_key key;
+	unsigned long timeout;
+	struct delayed_work work;
+};
+
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
@@ -51,8 +58,11 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
+extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
+extern void jump_label_rate_limit(struct jump_label_key_deferred *key,
+		unsigned long rl);
 
 #else  /* !HAVE_JUMP_LABEL */
 
@@ -68,6 +78,10 @@ static __always_inline void jump_label_init(void)
 {
 }
 
+struct jump_label_key_deferred {
+	struct jump_label_key  key;
+};
+
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
@@ -85,6 +99,11 @@ static inline void jump_label_dec(struct jump_label_key *key)
 	atomic_dec(&key->enabled);
 }
 
+static inline void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+{
+	jump_label_dec(&key->key);
+}
+
 static inline int jump_label_text_reserved(void *start, void *end)
 {
 	return 0;
@@ -102,6 +121,11 @@ static inline int jump_label_apply_nops(struct module *mod)
 {
 	return 0;
 }
+
+static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
+		unsigned long rl)
+{
+}
 #endif	/* HAVE_JUMP_LABEL */
 
 #endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cb44c9e..564769c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1064,12 +1064,12 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 	}
 }
 
-extern struct jump_label_key perf_sched_events;
+extern struct jump_label_key_deferred perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_branch(&perf_sched_events))
+	if (static_branch(&perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1078,7 +1078,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (static_branch(&perf_sched_events))
+	if (static_branch(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
 }
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3c1541d..3a3b1a1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -128,7 +128,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-struct jump_label_key perf_sched_events __read_mostly;
+struct jump_label_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -2748,7 +2748,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_sched_events);
+			jump_label_dec_deferred(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2759,7 +2759,7 @@ static void free_event(struct perf_event *event)
 			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			jump_label_dec(&perf_sched_events);
+			jump_label_dec_deferred(&perf_sched_events);
 		}
 	}
 
@@ -5784,7 +5784,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_sched_events);
+			jump_label_inc(&perf_sched_events.key);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -6022,7 +6022,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * - that may need work on context switch
 		 */
 		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events);
+		jump_label_inc(&perf_sched_events.key);
 	}
 
 	/*
@@ -6868,6 +6868,9 @@ void __init perf_event_init(void)
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
+
+	/* do not patch jump label more than once per second */
+	jump_label_rate_limit(&perf_sched_events, HZ);
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 66ff710..51a175a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -72,15 +72,46 @@ void jump_label_inc(struct jump_label_key *key)
 	jump_label_unlock();
 }
 
-void jump_label_dec(struct jump_label_key *key)
+static void __jump_label_dec(struct jump_label_key *key,
+		unsigned long rate_limit, struct delayed_work *work)
 {
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
 		return;
 
-	jump_label_update(key, JUMP_LABEL_DISABLE);
+	if (rate_limit) {
+		atomic_inc(&key->enabled);
+		schedule_delayed_work(work, rate_limit);
+	} else
+		jump_label_update(key, JUMP_LABEL_DISABLE);
+
 	jump_label_unlock();
 }
 
+static void jump_label_update_timeout(struct work_struct *work)
+{
+	struct jump_label_key_deferred *key =
+		container_of(work, struct jump_label_key_deferred, work.work);
+	__jump_label_dec(&key->key, 0, NULL);
+}
+
+void jump_label_dec(struct jump_label_key *key)
+{
+	__jump_label_dec(key, 0, NULL);
+}
+
+void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+{
+	__jump_label_dec(&key->key, key->timeout, &key->work);
+}
+
+
+void jump_label_rate_limit(struct jump_label_key_deferred *key,
+		unsigned long rl)
+{
+	key->timeout = rl;
+	INIT_DELAYED_WORK(&key->work, jump_label_update_timeout);
+}
+
 static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 {
 	if (entry->code <= (unsigned long)end &&
