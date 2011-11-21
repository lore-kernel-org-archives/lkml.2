Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1KUNRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:17:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab1KUNRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:17:54 -0500
Date: Mon, 21 Nov 2011 15:17:39 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111121131739.GF16853@redhat.com>
References: <20111117123029.GB16853@redhat.com>
 <1321534159.27735.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321534159.27735.33.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 01:49:19PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-17 at 14:30 +0200, Gleb Natapov wrote:
> > jump_lable patching is very expensive operation that involves pausing all
> > cpus. The patching of perf_sched_events jump_label is easily controllable
> > from userspace by unprivileged user. When user runs loop like this
> > "while true; do perf stat -e cycles true; done" the performance of my
> > test application that just increments a counter for one second drops by
> > 4%. This is on a 16 cpu box with my test application using only one of
> > them. An impact on a real server doing real work will be much worse.
> > Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
> > record" since KVM PMU implementation creates and destroys perf event
> > frequently.
> 
> Ideally we'd fix text_poke to not use stop_machine() we know how to, but
> we haven't had the green light from Intel/AMD yet.
> 
> Rostedt was going to implement it anyway and see if anything breaks.
> 
> Also, virt might be able to pull something smart on text_poke() dunno.
> 
> That said, I'd much rather throttle this particular jump label than
> remove it altogether, some people really don't like all this scheduler
> hot path crap.
> 
So how about throttling it like the patch below does until stop_machine()
no longer needed for patching (and it is possible that new way of patching
will still have significant overhead).

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 66f23dc..a4687f6 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -3,12 +3,15 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/workqueue.h>
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
 struct jump_label_key {
 	atomic_t enabled;
 	struct jump_entry *entries;
+	unsigned long rl_timeout;
+	struct delayed_work rl_work;
 #ifdef CONFIG_MODULES
 	struct jump_label_mod *next;
 #endif
@@ -28,9 +31,18 @@ struct module;
 #ifdef HAVE_JUMP_LABEL
 
 #ifdef CONFIG_MODULES
-#define JUMP_LABEL_INIT {{ 0 }, NULL, NULL}
+#define JUMP_LABEL_INIT {	\
+	.enabled = { 0 },	\
+	.entries = NULL,	\
+	.rl_timeout = 0,	\
+	.next = NULL,		\
+	}
 #else
-#define JUMP_LABEL_INIT {{ 0 }, NULL}
+#define JUMP_LABEL_INIT {	\
+	.enabled = { 0 },	\
+	.entries = NULL,	\
+	.rl_timeout = 0,	\
+	}
 #endif
 
 static __always_inline bool static_branch(struct jump_label_key *key)
@@ -51,6 +63,7 @@ extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
+extern void jump_label_rate_limit(struct jump_label_key *key, unsigned long rl);
 
 #else
 
@@ -97,6 +110,10 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
+static inline void jump_label_rate_limit(struct jump_label_key *key,
+		unsigned long rl)
+{
+}
 #endif
 
 #endif
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bdcd413..50bb631 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7071,6 +7091,9 @@ void __init perf_event_init(void)
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
+
+	/* do not patch jump label more than once per second */
+	jump_label_rate_limit(&perf_sched_events, HZ);
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index e6f1f24..88a82d2 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -72,15 +72,39 @@ void jump_label_inc(struct jump_label_key *key)
 	jump_label_unlock();
 }
 
-void jump_label_dec(struct jump_label_key *key)
+static void __jump_label_dec(struct jump_label_key *key,
+		unsigned long rate_limit)
 {
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
 		return;
 
-	jump_label_update(key, JUMP_LABEL_DISABLE);
+	if (rate_limit) {
+		atomic_inc(&key->enabled);
+		schedule_delayed_work(&key->rl_work, rate_limit);
+	} else
+		jump_label_update(key, JUMP_LABEL_DISABLE);
+
 	jump_label_unlock();
 }
 
+static void jump_label_update_timeout(struct work_struct *work)
+{
+	struct jump_label_key *key =
+		container_of(work, struct jump_label_key, rl_work.work);
+	__jump_label_dec(key, 0);
+}
+
+void jump_label_dec(struct jump_label_key *key)
+{
+	__jump_label_dec(key, key->rl_timeout);
+}
+
+void jump_label_rate_limit(struct jump_label_key *key, unsigned long rl)
+{
+	key->rl_timeout = rl;
+	INIT_DELAYED_WORK(&key->rl_work, jump_label_update_timeout);
+}
+
 static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 {
 	if (entry->code <= (unsigned long)end &&
--
			Gleb.
