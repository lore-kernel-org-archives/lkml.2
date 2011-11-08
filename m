Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1KHDtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:49:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32085 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab1KHDsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:48:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6523"; a="135611803"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Christine Chan <cschan@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCHv2 2/3] debugobjects: Extend to assert that an object is initialized
Date: Mon,  7 Nov 2011 19:48:27 -0800
Message-Id: <1320724108-20788-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
References: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christine Chan <cschan@codeaurora.org>

Calling del_timer_sync() on an uninitialized timer leads to a
never ending loop in lock_timer_base() that spins checking for a
non-NULL timer base. Add an assertion to debugobjects to catch
usage of uninitialized objects so that we can initialize timers
in the del_timer_sync() path before it calls lock_timer_base().

Signed-off-by: Christine Chan <cschan@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[sboyd: Clarify commit message]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/DocBook/debugobjects.tmpl |   50 +++++++++++++++++++++++++++++++
 include/linux/debugobjects.h            |    6 ++++
 lib/debugobjects.c                      |   38 +++++++++++++++++++++++
 3 files changed, 94 insertions(+), 0 deletions(-)

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
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 0b07cc5..be066fa 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -570,6 +570,44 @@ out_unlock:
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
+				ODEBUG_STATE_NOTAVAILABLE))
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
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

