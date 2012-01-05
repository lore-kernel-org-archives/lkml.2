Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2AEN0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:26:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2AEN0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:26:36 -0500
Date: Thu, 5 Jan 2012 14:24:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/debugobjects changes for v3.3
Message-ID: <20120105132430.GA26575@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-debugobjects-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-debugobjects-for-linus

(This actually caught a few real bugs, so it is worth doing.)

 Thanks,

	Ingo

------------------>
Christine Chan (2):
      debugobjects: Extend to assert that an object is initialized
      timer: Use debugobjects to catch deletion of uninitialized timers

Stephen Boyd (2):
      debugobjects: Be smarter about static objects
      timer: Setup uninitialized timer with a stub callback


 Documentation/DocBook/debugobjects.tmpl |   50 +++++++++++++++++++++++++
 include/linux/debugobjects.h            |    6 +++
 kernel/timer.c                          |   62 ++++++++++++++++++++++++++++---
 lib/debugobjects.c                      |   54 +++++++++++++++++++++++++--
 4 files changed, 162 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/debugobjects.tmpl b/Documentation/DocBook/debugobjects.tmpl
index 08ff908..24979f6 100644
--- a/Documentation/DocBook/debugobjects.tmpl
+++ b/Documentation/DocBook/debugobjects.tmpl
@@ -96,6 +96,7 @@
 	<listitem><para>debug_object_deactivate</para></listitem>
 	<listitem><para>debug_object_destroy</para></listitem>
 	<listitem><para>debug_object_free</para></listitem>
+	<listitem><para>debug_object_assert_init</para></listitem>
       </itemizedlist>
       Each of these functions takes the address of the real object and
       a pointer to the object type specific debug description
@@ -273,6 +274,26 @@
 	debug checks.
       </para>
     </sect1>
+
+    <sect1 id="debug_object_assert_init">
+      <title>debug_object_assert_init</title>
+      <para>
+	This function is called to assert that an object has been
+	initialized.
+      </para>
+      <para>
+	When the real object is not tracked by debugobjects, it calls
+	fixup_assert_init of the object type description structure
+	provided by the caller, with the hardcoded object state
+	ODEBUG_NOT_AVAILABLE. The fixup function can correct the problem
+	by calling debug_object_init and other specific initializing
+	functions.
+      </para>
+      <para>
+	When the real object is already tracked by debugobjects it is
+	ignored.
+      </para>
+    </sect1>
   </chapter>
   <chapter id="fixupfunctions">
     <title>Fixup functions</title>
@@ -381,6 +402,35 @@
 	statistics.
       </para>
     </sect1>
+    <sect1 id="fixup_assert_init">
+      <title>fixup_assert_init</title>
+      <para>
+	This function is called from the debug code whenever a problem
+	in debug_object_assert_init is detected.
+      </para>
+      <para>
+	Called from debug_object_assert_init() with a hardcoded state
+	ODEBUG_STATE_NOTAVAILABLE when the object is not found in the
+	debug bucket.
+      </para>
+      <para>
+	The function returns 1 when the fixup was successful,
+	otherwise 0. The return value is used to update the
+	statistics.
+      </para>
+      <para>
+	Note, this function should make sure debug_object_init() is
+	called before returning.
+      </para>
+      <para>
+	The handling of statically initialized objects is a special
+	case. The fixup function should check if this is a legitimate
+	case of a statically initialized object or not. In this case only
+	debug_object_init() should be called to make the object known to
+	the tracker. Then the function should return 0 because this is not
+	a real fixup.
+      </para>
+    </sect1>
   </chapter>
   <chapter id="bugs">
     <title>Known Bugs And Assumptions</title>
diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 65970b8..0e5f578 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -46,6 +46,8 @@ struct debug_obj {
  *			fails
  * @fixup_free:		fixup function, which is called when the free check
  *			fails
+ * @fixup_assert_init:  fixup function, which is called when the assert_init
+ *			check fails
  */
 struct debug_obj_descr {
 	const char		*name;
@@ -54,6 +56,7 @@ struct debug_obj_descr {
 	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
 	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
 	int (*fixup_free)	(void *addr, enum debug_obj_state state);
+	int (*fixup_assert_init)(void *addr, enum debug_obj_state state);
 };
 
 #ifdef CONFIG_DEBUG_OBJECTS
@@ -64,6 +67,7 @@ extern void debug_object_activate  (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
+extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
 
 /*
  * Active state:
@@ -89,6 +93,8 @@ static inline void
 debug_object_destroy   (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_free      (void *addr, struct debug_obj_descr *descr) { }
+static inline void
+debug_object_assert_init(void *addr, struct debug_obj_descr *descr) { }
 
 static inline void debug_objects_early_init(void) { }
 static inline void debug_objects_mem_init(void) { }
diff --git a/kernel/timer.c b/kernel/timer.c
index dbaa624..5fc5a76 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -427,6 +427,12 @@ static int timer_fixup_init(void *addr, enum debug_obj_state state)
 	}
 }
 
+/* Stub timer callback for improperly used timers. */
+static void stub_timer(unsigned long data)
+{
+	WARN_ON(1);
+}
+
 /*
  * fixup_activate is called when:
  * - an active object is activated
@@ -450,7 +456,8 @@ static int timer_fixup_activate(void *addr, enum debug_obj_state state)
 			debug_object_activate(timer, &timer_debug_descr);
 			return 0;
 		} else {
-			WARN_ON_ONCE(1);
+			setup_timer(timer, stub_timer, 0);
+			return 1;
 		}
 		return 0;
 
@@ -480,12 +487,40 @@ static int timer_fixup_free(void *addr, enum debug_obj_state state)
 	}
 }
 
+/*
+ * fixup_assert_init is called when:
+ * - an untracked/uninit-ed object is found
+ */
+static int timer_fixup_assert_init(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_NOTAVAILABLE:
+		if (timer->entry.prev == TIMER_ENTRY_STATIC) {
+			/*
+			 * This is not really a fixup. The timer was
+			 * statically initialized. We just make sure that it
+			 * is tracked in the object tracker.
+			 */
+			debug_object_init(timer, &timer_debug_descr);
+			return 0;
+		} else {
+			setup_timer(timer, stub_timer, 0);
+			return 1;
+		}
+	default:
+		return 0;
+	}
+}
+
 static struct debug_obj_descr timer_debug_descr = {
-	.name		= "timer_list",
-	.debug_hint	= timer_debug_hint,
-	.fixup_init	= timer_fixup_init,
-	.fixup_activate	= timer_fixup_activate,
-	.fixup_free	= timer_fixup_free,
+	.name			= "timer_list",
+	.debug_hint		= timer_debug_hint,
+	.fixup_init		= timer_fixup_init,
+	.fixup_activate		= timer_fixup_activate,
+	.fixup_free		= timer_fixup_free,
+	.fixup_assert_init	= timer_fixup_assert_init,
 };
 
 static inline void debug_timer_init(struct timer_list *timer)
@@ -508,6 +543,11 @@ static inline void debug_timer_free(struct timer_list *timer)
 	debug_object_free(timer, &timer_debug_descr);
 }
 
+static inline void debug_timer_assert_init(struct timer_list *timer)
+{
+	debug_object_assert_init(timer, &timer_debug_descr);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key);
@@ -531,6 +571,7 @@ EXPORT_SYMBOL_GPL(destroy_timer_on_stack);
 static inline void debug_timer_init(struct timer_list *timer) { }
 static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
+static inline void debug_timer_assert_init(struct timer_list *timer) { }
 #endif
 
 static inline void debug_init(struct timer_list *timer)
@@ -552,6 +593,11 @@ static inline void debug_deactivate(struct timer_list *timer)
 	trace_timer_cancel(timer);
 }
 
+static inline void debug_assert_init(struct timer_list *timer)
+{
+	debug_timer_assert_init(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -902,6 +948,8 @@ int del_timer(struct timer_list *timer)
 	unsigned long flags;
 	int ret = 0;
 
+	debug_assert_init(timer);
+
 	timer_stats_timer_clear_start_info(timer);
 	if (timer_pending(timer)) {
 		base = lock_timer_base(timer, &flags);
@@ -932,6 +980,8 @@ int try_to_del_timer_sync(struct timer_list *timer)
 	unsigned long flags;
 	int ret = -1;
 
+	debug_assert_init(timer);
+
 	base = lock_timer_base(timer, &flags);
 
 	if (base->running_timer == timer)
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a78b7c6..77cb245 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -268,12 +268,16 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
  * Try to repair the damage, so we have a better chance to get useful
  * debug output.
  */
-static void
+static int
 debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
 		   void * addr, enum debug_obj_state state)
 {
+	int fixed = 0;
+
 	if (fixup)
-		debug_objects_fixups += fixup(addr, state);
+		fixed = fixup(addr, state);
+	debug_objects_fixups += fixed;
+	return fixed;
 }
 
 static void debug_object_is_on_stack(void *addr, int onstack)
@@ -386,6 +390,9 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	struct debug_obj o = { .object = addr,
+			       .state = ODEBUG_STATE_NOTAVAILABLE,
+			       .descr = descr };
 
 	if (!debug_objects_enabled)
 		return;
@@ -425,8 +432,9 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	 * let the type specific code decide whether this is
 	 * true or not.
 	 */
-	debug_object_fixup(descr->fixup_activate, addr,
-			   ODEBUG_STATE_NOTAVAILABLE);
+	if (debug_object_fixup(descr->fixup_activate, addr,
+			   ODEBUG_STATE_NOTAVAILABLE))
+		debug_print_object(&o, "activate");
 }
 
 /**
@@ -563,6 +571,44 @@ out_unlock:
 }
 
 /**
+ * debug_object_assert_init - debug checks when object should be init-ed
+ * @addr:	address of the object
+ * @descr:	pointer to an object specific debug description structure
+ */
+void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+
+	if (!debug_objects_enabled)
+		return;
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+
+	obj = lookup_object(addr, db);
+	if (!obj) {
+		struct debug_obj o = { .object = addr,
+				       .state = ODEBUG_STATE_NOTAVAILABLE,
+				       .descr = descr };
+
+		raw_spin_unlock_irqrestore(&db->lock, flags);
+		/*
+		 * Maybe the object is static.  Let the type specific
+		 * code decide what to do.
+		 */
+		if (debug_object_fixup(descr->fixup_assert_init, addr,
+				       ODEBUG_STATE_NOTAVAILABLE))
+			debug_print_object(&o, "assert_init");
+		return;
+	}
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+}
+
+/**
  * debug_object_active_state - debug checks object usage state machine
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
