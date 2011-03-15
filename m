Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab1COT2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:28:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364Ab1COT2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:28:09 -0400
Date: Tue, 15 Mar 2011 20:27:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/debugobjects changes for v2.6.39
Message-ID: <20110315192756.GA27149@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-debugobjects-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-debugobjects-for-linus

 Thanks,

	Ingo

------------------>
Stanislaw Gruszka (1):
      debugobjects: Add hint for better object identification


 include/linux/debugobjects.h |    5 ++++-
 kernel/hrtimer.c             |    6 ++++++
 kernel/timer.c               |    6 ++++++
 kernel/workqueue.c           |    6 ++++++
 lib/debugobjects.c           |    9 ++++++---
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 597692f..65970b8 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -34,7 +34,10 @@ struct debug_obj {
 
 /**
  * struct debug_obj_descr - object type specific debug description structure
+ *
  * @name:		name of the object typee
+ * @debug_hint:		function returning address, which have associated
+ *			kernel symbol, to allow identify the object
  * @fixup_init:		fixup function, which is called when the init check
  *			fails
  * @fixup_activate:	fixup function, which is called when the activate check
@@ -46,7 +49,7 @@ struct debug_obj {
  */
 struct debug_obj_descr {
 	const char		*name;
-
+	void *(*debug_hint)	(void *addr);
 	int (*fixup_init)	(void *addr, enum debug_obj_state state);
 	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
 	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..e38f5a0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -334,6 +334,11 @@ EXPORT_SYMBOL_GPL(ktime_add_safe);
 
 static struct debug_obj_descr hrtimer_debug_descr;
 
+static void *hrtimer_debug_hint(void *addr)
+{
+	return ((struct hrtimer *) addr)->function;
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -393,6 +398,7 @@ static int hrtimer_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr hrtimer_debug_descr = {
 	.name		= "hrtimer",
+	.debug_hint	= hrtimer_debug_hint,
 	.fixup_init	= hrtimer_fixup_init,
 	.fixup_activate	= hrtimer_fixup_activate,
 	.fixup_free	= hrtimer_fixup_free,
diff --git a/kernel/timer.c b/kernel/timer.c
index d645992..33a6792 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -404,6 +404,11 @@ static void timer_stats_account_timer(struct timer_list *timer) {}
 
 static struct debug_obj_descr timer_debug_descr;
 
+static void *timer_debug_hint(void *addr)
+{
+	return ((struct timer_list *) addr)->function;
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -477,6 +482,7 @@ static int timer_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr timer_debug_descr = {
 	.name		= "timer_list",
+	.debug_hint	= timer_debug_hint,
 	.fixup_init	= timer_fixup_init,
 	.fixup_activate	= timer_fixup_activate,
 	.fixup_free	= timer_fixup_free,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee6578b..b5fe4c0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -316,6 +316,11 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 
 static struct debug_obj_descr work_debug_descr;
 
+static void *work_debug_hint(void *addr)
+{
+	return ((struct work_struct *) addr)->func;
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -387,6 +392,7 @@ static int work_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr work_debug_descr = {
 	.name		= "work_struct",
+	.debug_hint	= work_debug_hint,
 	.fixup_init	= work_fixup_init,
 	.fixup_activate	= work_fixup_activate,
 	.fixup_free	= work_fixup_free,
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index deebcc5..9d86e45 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -249,14 +249,17 @@ static struct debug_bucket *get_bucket(unsigned long addr)
 
 static void debug_print_object(struct debug_obj *obj, char *msg)
 {
+	struct debug_obj_descr *descr = obj->descr;
 	static int limit;
 
-	if (limit < 5 && obj->descr != descr_test) {
+	if (limit < 5 && descr != descr_test) {
+		void *hint = descr->debug_hint ?
+			descr->debug_hint(obj->object) : NULL;
 		limit++;
 		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object type: %s\n",
+				 "object type: %s hint: %pS\n",
 			msg, obj_states[obj->state], obj->astate,
-			obj->descr->name);
+			descr->name, hint);
 	}
 	debug_objects_warnings++;
 }
