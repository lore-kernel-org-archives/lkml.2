Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1CGI6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab1CGI6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:58:49 -0500
Date: Mon, 7 Mar 2011 09:58:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v5 repost] debugobjects: print more data
Message-ID: <20110307085809.GA9334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On complex subsystems like mac80211, structures may include many timers
and works. In such case, based only on call trace and object type is
hard to conclude where bug could possibly be.

Patch extend debug object descriptor to additional debug hint function.
If defined, it return address, which have associated kernel symbol (i.e.
hrtimer->function pointer). We print that symbol when bug is detected,
to identify the object.

Patch contains debug hint methods for timer_list, work_struct
and hrtimer.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Cc Andrew, perhaps this could be merged through mm?

v1 -> v2:
 - do not invent custom functions for print symbols
 - remove not necessary null check, use same call convention like other
   methods
 - fix stray whitespace
 - print only symbol name (no function pointer)
v2 -> v3:
 - remove remaining kallsyms changes
v3 -> v4:
 - make callbacks static
v4 -> v5:
 - do not drop WARN
 - change "print" method to "debug_hint"

 include/linux/debugobjects.h |    5 ++++-
 kernel/hrtimer.c             |    6 ++++++
 kernel/timer.c               |    6 ++++++
 kernel/workqueue.c           |    6 ++++++
 lib/debugobjects.c           |    9 ++++++---
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 597692f..5580c4e 100644
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
index 11869fa..5f7c49f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -314,6 +314,11 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 
 static struct debug_obj_descr work_debug_descr;
 
+static void *work_debug_hint(void *addr)
+{
+	return ((struct work_struct *work) addr)->func;
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -385,6 +390,7 @@ static int work_fixup_free(void *addr, enum debug_obj_state state)
 
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
-- 
1.7.1


