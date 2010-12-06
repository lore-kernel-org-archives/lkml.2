Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0LFWF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:58 -0500
Received: from mail.perches.com ([173.55.12.10]:2334 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/29] lib: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:15 -0800
Message-Id: <4b85296eb343671f14eac51ecc191f597096d797.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Remove KERN_<level>.
Use %s, __func__

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/debugobjects.c   |   21 ++++++++++-----------
 lib/iomap.c          |    2 +-
 lib/kobject.c        |    9 ++++-----
 lib/kobject_uevent.c |    4 ++--
 lib/list_debug.c     |   24 ++++++++++--------------
 lib/plist.c          |   12 ++++++------
 6 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index deebcc5..f9f33fe 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -253,10 +253,9 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 
 	if (limit < 5 && obj->descr != descr_test) {
 		limit++;
-		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object type: %s\n",
-			msg, obj_states[obj->state], obj->astate,
-			obj->descr->name);
+		WARN(1, "ODEBUG: %s %s (active state %u) object type: %s\n",
+		     msg, obj_states[obj->state], obj->astate,
+		     obj->descr->name);
 	}
 	debug_objects_warnings++;
 }
@@ -841,22 +840,22 @@ check_results(void *addr, enum debug_obj_state state, int fixups, int warnings)
 
 	obj = lookup_object(addr, db);
 	if (!obj && state != ODEBUG_STATE_NONE) {
-		WARN(1, KERN_ERR "ODEBUG: selftest object not found\n");
+		WARN(1, "ODEBUG: selftest object not found\n");
 		goto out;
 	}
 	if (obj && obj->state != state) {
-		WARN(1, KERN_ERR "ODEBUG: selftest wrong state: %d != %d\n",
-		       obj->state, state);
+		WARN(1, "ODEBUG: selftest wrong state: %d != %d\n",
+		     obj->state, state);
 		goto out;
 	}
 	if (fixups != debug_objects_fixups) {
-		WARN(1, KERN_ERR "ODEBUG: selftest fixups failed %d != %d\n",
-		       fixups, debug_objects_fixups);
+		WARN(1, "ODEBUG: selftest fixups failed %d != %d\n",
+		     fixups, debug_objects_fixups);
 		goto out;
 	}
 	if (warnings != debug_objects_warnings) {
-		WARN(1, KERN_ERR "ODEBUG: selftest warnings failed %d != %d\n",
-		       warnings, debug_objects_warnings);
+		WARN(1, "ODEBUG: selftest warnings failed %d != %d\n",
+		     warnings, debug_objects_warnings);
 		goto out;
 	}
 	res = 0;
diff --git a/lib/iomap.c b/lib/iomap.c
index d322293..08b4c8d 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -40,7 +40,7 @@ static void bad_io_access(unsigned long port, const char *access)
 	static int count = 10;
 	if (count) {
 		count--;
-		WARN(1, KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
+		WARN(1, "Bad IO access at port %#lx (%s)\n", port, access);
 	}
 }
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 82dc34c..26b808e 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -164,8 +164,8 @@ static int kobject_add_internal(struct kobject *kobj)
 		return -ENOENT;
 
 	if (!kobj->name || !kobj->name[0]) {
-		WARN(1, "kobject: (%p): attempted to be registered with empty "
-			 "name!\n", kobj);
+		WARN(1, "kobject: (%p): attempted to be registered with empty name!\n",
+		     kobj);
 		return -EINVAL;
 	}
 
@@ -590,9 +590,8 @@ void kobject_put(struct kobject *kobj)
 {
 	if (kobj) {
 		if (!kobj->state_initialized)
-			WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
-			       "initialized, yet kobject_put() is being "
-			       "called.\n", kobject_name(kobj), kobj);
+			WARN(1, "kobject: '%s' (%p): is not initialized, yet kobject_put() is being called\n",
+			     kobject_name(kobj), kobj);
 		kref_put(&kobj->kref, kobject_release);
 	}
 }
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 70af0a7..78f0a74 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -345,7 +345,7 @@ int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 	int len;
 
 	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
-		WARN(1, KERN_ERR "add_uevent_var: too many keys\n");
+		WARN(1, "%s(): too many keys\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -356,7 +356,7 @@ int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 	va_end(args);
 
 	if (len >= (sizeof(env->buf) - env->buflen)) {
-		WARN(1, KERN_ERR "add_uevent_var: buffer size too small\n");
+		WARN(1, "%s(): buffer size too small\n", __func__);
 		return -ENOMEM;
 	}
 
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 344c710..b574054 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -21,13 +21,11 @@ void __list_add(struct list_head *new,
 			      struct list_head *next)
 {
 	WARN(next->prev != prev,
-		"list_add corruption. next->prev should be "
-		"prev (%p), but was %p. (next=%p).\n",
-		prev, next->prev, next);
+	     "list_add corruption. next->prev should be prev (%p), but was %p. (next=%p)\n",
+	     prev, next->prev, next);
 	WARN(prev->next != next,
-		"list_add corruption. prev->next should be "
-		"next (%p), but was %p. (prev=%p).\n",
-		next, prev->next, prev);
+	     "list_add corruption. prev->next should be next (%p), but was %p. (prev=%p)\n",
+	     next, prev->next, prev);
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
@@ -44,17 +42,15 @@ EXPORT_SYMBOL(__list_add);
 void list_del(struct list_head *entry)
 {
 	WARN(entry->next == LIST_POISON1,
-		"list_del corruption, next is LIST_POISON1 (%p)\n",
-		LIST_POISON1);
+	     "list_del corruption, next is LIST_POISON1 (%p)\n", LIST_POISON1);
 	WARN(entry->next != LIST_POISON1 && entry->prev == LIST_POISON2,
-		"list_del corruption, prev is LIST_POISON2 (%p)\n",
-		LIST_POISON2);
+	     "list_del corruption, prev is LIST_POISON2 (%p)\n", LIST_POISON2);
 	WARN(entry->prev->next != entry,
-		"list_del corruption. prev->next should be %p, "
-		"but was %p\n", entry, entry->prev->next);
+	     "list_del corruption. prev->next should be %p, but was %p\n",
+	     entry, entry->prev->next);
 	WARN(entry->next->prev != entry,
-		"list_del corruption. next->prev should be %p, "
-		"but was %p\n", entry, entry->next->prev);
+	     "list_del corruption. next->prev should be %p, but was %p\n",
+	     entry, entry->next->prev);
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
diff --git a/lib/plist.c b/lib/plist.c
index 1471988..8923f3a 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -32,12 +32,12 @@ static void plist_check_prev_next(struct list_head *t, struct list_head *p,
 				  struct list_head *n)
 {
 	WARN(n->prev != p || p->next != n,
-			"top: %p, n: %p, p: %p\n"
-			"prev: %p, n: %p, p: %p\n"
-			"next: %p, n: %p, p: %p\n",
-			 t, t->next, t->prev,
-			p, p->next, p->prev,
-			n, n->next, n->prev);
+	     "top: %p, n: %p, p: %p\n"
+	     "prev: %p, n: %p, p: %p\n"
+	     "next: %p, n: %p, p: %p\n",
+	     t, t->next, t->prev,
+	     p, p->next, p->prev,
+	     n, n->next, n->prev);
 }
 
 static void plist_check_list(struct list_head *top)
-- 
1.7.3.2.245.g03276.dirty

