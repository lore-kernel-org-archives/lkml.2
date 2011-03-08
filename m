Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1CHPQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:16:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:49664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab1CHPQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:16:07 -0500
Date: Tue, 8 Mar 2011 15:15:50 GMT
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, sgruszka@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sgruszka@redhat.com
In-Reply-To: <20110307085809.GA9334@redhat.com>
References: <20110307085809.GA9334@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debugobjects] debugobjects: Add hint for better object identification
Message-ID: <tip-997772884036e6e121de39322179989154437d9f@git.kernel.org>
Git-Commit-ID: 997772884036e6e121de39322179989154437d9f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 15:15:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  997772884036e6e121de39322179989154437d9f
Gitweb:     http://git.kernel.org/tip/997772884036e6e121de39322179989154437d9f
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Mon, 7 Mar 2011 09:58:33 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 Mar 2011 16:10:38 +0100

debugobjects: Add hint for better object identification

In complex subsystems like mac80211 structures can contain several
timers and work structs, so identifying a specific instance from the
call trace and object type output of debugobjects can be hard.

Allow the subsystems which support debugobjects to provide a hint
function. This function returns a pointer to a kernel address
(preferrably the objects callback function) which is printed along
with the debugobjects type.

Add hint methods for timer_list, work_struct and hrtimer.

[ tglx: Massaged changelog, made it compile ]

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
LKML-Reference: <20110307085809.GA9334@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
