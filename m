Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1BULYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:24:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1BULYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:24:50 -0500
Date: Mon, 21 Feb 2011 12:24:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] debugobjects: print more data
Message-ID: <20110221112440.GA5140@redhat.com>
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
pointer, corresponding function callback pointer and (what is most
useful) function symbol name.

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
ODEBUG timer_list: ffff8801230cf138 function: [<ffffffffa05703d0>] ieee80211_sta_conn_mon_timer+0x0/0x40 [mac80211]

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 597692f..c22eebf 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -31,10 +31,11 @@ struct debug_obj {
 	void			*object;
 	struct debug_obj_descr	*descr;
 };
-
 /**
  * struct debug_obj_descr - object type specific debug description structure
+ *
  * @name:		name of the object typee
+ * @print:		function printing extra debug data
  * @fixup_init:		fixup function, which is called when the init check
  *			fails
  * @fixup_activate:	fixup function, which is called when the activate check
@@ -46,7 +47,7 @@ struct debug_obj {
  */
 struct debug_obj_descr {
 	const char		*name;
-
+	void (*print)		(struct debug_obj *obj);
 	int (*fixup_init)	(void *addr, enum debug_obj_state state);
 	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
 	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
@@ -73,6 +74,8 @@ debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 
 extern void debug_objects_early_init(void);
 extern void debug_objects_mem_init(void);
+
+extern char *debug_func_str(void *func_addr);
 #else
 static inline void
 debug_object_init      (void *addr, struct debug_obj_descr *descr) { }
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d..dee0148 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..2a50e62 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -334,6 +334,17 @@ EXPORT_SYMBOL_GPL(ktime_add_safe);
 
 static struct debug_obj_descr hrtimer_debug_descr;
 
+void hrtimer_debug_print(struct debug_obj *obj)
+{
+	struct hrtimer *hrtimer = obj->object;
+
+	if (hrtimer == NULL)
+		return;
+
+	printk(KERN_ERR "ODEBUG hrtimer: %p function: [<%p>] %s\n",
+	       hrtimer, hrtimer->function, debug_func_str(hrtimer->function));
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -393,6 +404,7 @@ static int hrtimer_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr hrtimer_debug_descr = {
 	.name		= "hrtimer",
+	.print		= hrtimer_debug_print,
 	.fixup_init	= hrtimer_fixup_init,
 	.fixup_activate	= hrtimer_fixup_activate,
 	.fixup_free	= hrtimer_fixup_free,
diff --git a/kernel/timer.c b/kernel/timer.c
index d645992..a7c6bc5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -404,6 +404,17 @@ static void timer_stats_account_timer(struct timer_list *timer) {}
 
 static struct debug_obj_descr timer_debug_descr;
 
+void timer_debug_print(struct debug_obj *obj)
+{
+	struct timer_list *timer = obj->object;
+	
+	if (timer == NULL)
+		return;
+
+	printk(KERN_ERR "ODEBUG timer_list: %p function: [<%p>] %s\n",
+	       timer, timer->function, debug_func_str(timer->function));
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -477,6 +488,7 @@ static int timer_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr timer_debug_descr = {
 	.name		= "timer_list",
+	.print		= timer_debug_print,
 	.fixup_init	= timer_fixup_init,
 	.fixup_activate	= timer_fixup_activate,
 	.fixup_free	= timer_fixup_free,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11869fa..7844fcc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -314,6 +314,17 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 
 static struct debug_obj_descr work_debug_descr;
 
+void work_debug_print(struct debug_obj *obj)
+{
+	struct work_struct *work = obj->object;
+
+	if (work == NULL)
+		return;
+
+	printk(KERN_ERR "ODEBUG work_struct: %p func: [<%p>] %s\n",
+	       work, work->func, debug_func_str(work->func));
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -385,6 +396,7 @@ static int work_fixup_free(void *addr, enum debug_obj_state state)
 
 static struct debug_obj_descr work_debug_descr = {
 	.name		= "work_struct",
+	.print		= work_debug_print,
 	.fixup_init	= work_fixup_init,
 	.fixup_activate	= work_fixup_activate,
 	.fixup_free	= work_fixup_free,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2b97418..1e901b0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -276,6 +276,7 @@ config TIMER_STATS
 config DEBUG_OBJECTS
 	bool "Debug object operations"
 	depends on DEBUG_KERNEL
+	select KALLSYMS
 	help
 	  If you say Y here, additional code will be inserted into the
 	  kernel to track the life time of various objects and validate
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index deebcc5..f5bf0f6 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/kallsyms.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
@@ -247,16 +248,27 @@ static struct debug_bucket *get_bucket(unsigned long addr)
 	return &obj_hash[hash];
 }
 
+char *debug_func_str(void *func_addr)
+{
+	static char func_str[KSYM_SYMBOL_LEN];
+	sprint_symbol(func_str, (unsigned long) func_addr);
+	
+	return func_str;
+}
+
 static void debug_print_object(struct debug_obj *obj, char *msg)
 {
 	static int limit;
 
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
+			obj->descr->print(obj);
 	}
 	debug_objects_warnings++;
 }
