Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1BVJp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:45:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab1BVJp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:45:26 -0500
Date: Tue, 22 Feb 2011 10:45:29 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3] debugobjects: print more data
Message-ID: <20110222094504.GA21489@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On complex subsystems like mac80211, structures may include many timers
and works. In such case, based only on call trace and object type is hard
to conclude where bug could possibly be.

Patch extend debug object descriptor to additional print function.
If defined, it provide per object debugging data. Patch contains print
methods for timer_list, work_struct and hrtimer. They print object
pointer, and (what is most useful) corresponding function callback
symbol name.

On main print function I changed WARN to printk to avoid "cut off" lines
and keep all informations together.

I tested patch with timer_list bug in mac80211, I get following output
wen bug was triggered:

ODEBUG: free active (active state 0) object type: timer_list
Pid: 8195, comm: rmmod Not tainted 2.6.38-rc5-wl+ #29
Call Trace:
 [<ffffffff8122783f>] ? debug_print_object+0x5f/0x80
 [<ffffffff81227ee5>] ? debug_check_no_obj_freed+0x125/0x210
 [<ffffffff8109ecd7>] ? debug_check_no_locks_freed+0xf7/0x170
 [<ffffffff81156942>] ? kfree+0xc2/0x2f0
 [<ffffffff813ecf95>] ? netdev_release+0x45/0x60
 [<ffffffff812f1927>] ? device_release+0x27/0xa0
 [<ffffffff812176dd>] ? kobject_release+0x8d/0x1a0
 [<ffffffff81217650>] ? kobject_release+0x0/0x1a0
 [<ffffffff81218cb7>] ? kref_put+0x37/0x70
 [<ffffffff81217557>] ? kobject_put+0x27/0x60
 [<ffffffff813d66db>] ? netdev_run_todo+0x1ab/0x270
 [<ffffffff813e80ee>] ? rtnl_unlock+0xe/0x10
 [<ffffffffa0565188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa062ced7>] ? iwl_pci_remove+0xdb/0x22a [iwlagn]
 [<ffffffff8123d562>] ? pci_device_remove+0x52/0x120
 [<ffffffff812f5ac5>] ? __device_release_driver+0x75/0xe0
 [<ffffffff812f5c08>] ? driver_detach+0xd8/0xe0
 [<ffffffff812f49d1>] ? bus_remove_driver+0x91/0x100
 [<ffffffff812f6422>] ? driver_unregister+0x62/0xa0
 [<ffffffff8123d914>] ? pci_unregister_driver+0x44/0xa0
 [<ffffffffa062cdf5>] ? iwl_exit+0x15/0x1c [iwlagn]
 [<ffffffff810ab592>] ? sys_delete_module+0x1a2/0x270
 [<ffffffff814992c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100bf42>] ? system_call_fastpath+0x16/0x1b
ODEBUG timer_list: ffff8801230cf138 function: ieee80211_sta_conn_mon_timer+0x0/0x40 [mac80211]

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
 - do not invent custom functions for print symbols
 - remove not necessary null check, use same call convention like other
   methods
 - fix stray whitespace
 - print only symbol name (no function pointer)
v2 -> v3:
 - remove remaining kallsyms changes

 include/linux/debugobjects.h |    4 +++-
 kernel/hrtimer.c             |    9 +++++++++
 kernel/timer.c               |    9 +++++++++
 kernel/workqueue.c           |    8 ++++++++
 lib/debugobjects.c           |    7 +++++--
 5 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 597692f..89f115e 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -34,7 +34,9 @@ struct debug_obj {
 
 /**
  * struct debug_obj_descr - object type specific debug description structure
+ *
  * @name:		name of the object typee
+ * @print:		function printing extra debug data
  * @fixup_init:		fixup function, which is called when the init check
  *			fails
  * @fixup_activate:	fixup function, which is called when the activate check
@@ -46,7 +48,7 @@ struct debug_obj {
  */
 struct debug_obj_descr {
 	const char		*name;
-
+	void (*print)		(void *addr);
 	int (*fixup_init)	(void *addr, enum debug_obj_state state);
 	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
 	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..ea518c4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -334,6 +334,14 @@ EXPORT_SYMBOL_GPL(ktime_add_safe);
 
 static struct debug_obj_descr hrtimer_debug_descr;
 
+void hrtimer_debug_print(void *addr)
+{
+	struct hrtimer *hrtimer = addr;
+
+	printk(KERN_ERR "ODEBUG hrtimer: %p function: %pS\n",
+	       hrtimer, hrtimer->function);
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -393,6 +401,7 @@ static int hrtimer_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr hrtimer_debug_descr = {
 	.name		= "hrtimer",
+	.print		= hrtimer_debug_print,
 	.fixup_init	= hrtimer_fixup_init,
 	.fixup_activate	= hrtimer_fixup_activate,
 	.fixup_free	= hrtimer_fixup_free,
diff --git a/kernel/timer.c b/kernel/timer.c
index d645992..7d2b7ee 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -404,6 +404,14 @@ static void timer_stats_account_timer(struct timer_list *timer) {}
 
 static struct debug_obj_descr timer_debug_descr;
 
+void timer_debug_print(void *addr)
+{
+	struct timer_list *timer = addr;
+
+	printk(KERN_ERR "ODEBUG timer_list: %p function: %pS\n",
+	       timer, timer->function);
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -477,6 +485,7 @@ static int timer_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr timer_debug_descr = {
 	.name		= "timer_list",
+	.print		= timer_debug_print,
 	.fixup_init	= timer_fixup_init,
 	.fixup_activate	= timer_fixup_activate,
 	.fixup_free	= timer_fixup_free,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11869fa..e4d6a4c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -314,6 +314,13 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 
 static struct debug_obj_descr work_debug_descr;
 
+void work_debug_print(void *addr)
+{
+	struct work_struct *work = addr;
+
+	printk(KERN_ERR "ODEBUG work_struct: %p func: %pS\n", work, work->func);
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -385,6 +392,7 @@ static int work_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr work_debug_descr = {
 	.name		= "work_struct",
+	.print		= work_debug_print,
 	.fixup_init	= work_fixup_init,
 	.fixup_activate	= work_fixup_activate,
 	.fixup_free	= work_fixup_free,
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index deebcc5..c755c0f 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -253,10 +253,13 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 
 	if (limit < 5 && obj->descr != descr_test) {
 		limit++;
-		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object type: %s\n",
+		printk(KERN_ERR "ODEBUG: %s %s (active state %u) "
+				"object type: %s\n",
 			msg, obj_states[obj->state], obj->astate,
 			obj->descr->name);
+		dump_stack();
+		if (obj->descr->print)
+			obj->descr->print(obj->object);
 	}
 	debug_objects_warnings++;
 }
-- 
1.7.1

