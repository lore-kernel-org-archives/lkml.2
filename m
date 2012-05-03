Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab2ECT3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:29:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306Ab2ECT32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:29:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: [PATCH 2/2] PM / Sleep: User space wakeup sources garbage collector Kconfig option
Date: Thu, 3 May 2012 21:34:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, John Stultz <johnstul@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201204272334.04387.rjw@sisk.pl> <201205032129.41611.rjw@sisk.pl>
In-Reply-To: <201205032129.41611.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205032134.05843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to configure out the user space wakeup sources
garbage collector for debugging and default Android builds.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig    |    5 ++
 kernel/power/wakelock.c |  101 +++++++++++++++++++++++++++++-------------------
 2 files changed, 67 insertions(+), 39 deletions(-)

Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -125,6 +125,11 @@ config PM_WAKELOCKS_LIMIT
 	default 100
 	depends on PM_WAKELOCKS
 
+config PM_WAKELOCKS_GC
+	bool "Garbage collector for user space wakeup sources"
+	depends on PM_WAKELOCKS
+	default y
+
 config PM_RUNTIME
 	bool "Run-time PM core functionality"
 	depends on !IA64_HP_SIM
Index: linux/kernel/power/wakelock.c
===================================================================
--- linux.orig/kernel/power/wakelock.c
+++ linux/kernel/power/wakelock.c
@@ -17,21 +17,18 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 
-#define WL_GC_COUNT_MAX	100
-#define WL_GC_TIME_SEC	300
-
 static DEFINE_MUTEX(wakelocks_lock);
 
 struct wakelock {
 	char			*name;
 	struct rb_node		node;
 	struct wakeup_source	ws;
+#ifdef CONFIG_PM_WAKELOCKS_GC
 	struct list_head	lru;
+#endif
 };
 
 static struct rb_root wakelocks_tree = RB_ROOT;
-static LIST_HEAD(wakelocks_lru_list);
-static unsigned int wakelocks_gc_count;
 
 ssize_t pm_show_wakelocks(char *buf, bool show_active)
 {
@@ -79,6 +76,61 @@ static inline void increment_wakelocks_n
 static inline void decrement_wakelocks_number(void) {}
 #endif /* CONFIG_PM_WAKELOCKS_LIMIT */
 
+#ifdef CONFIG_PM_WAKELOCKS_GC
+#define WL_GC_COUNT_MAX	100
+#define WL_GC_TIME_SEC	300
+
+static LIST_HEAD(wakelocks_lru_list);
+static unsigned int wakelocks_gc_count;
+
+static inline void wakelocks_lru_add(struct wakelock *wl)
+{
+	list_add(&wl->lru, &wakelocks_lru_list);
+}
+
+static inline void wakelocks_lru_most_recent(struct wakelock *wl)
+{
+	list_move(&wl->lru, &wakelocks_lru_list);
+}
+
+static void wakelocks_gc(void)
+{
+	struct wakelock *wl, *aux;
+	ktime_t now;
+
+	if (++wakelocks_gc_count <= WL_GC_COUNT_MAX)
+		return;
+
+	now = ktime_get();
+	list_for_each_entry_safe_reverse(wl, aux, &wakelocks_lru_list, lru) {
+		u64 idle_time_ns;
+		bool active;
+
+		spin_lock_irq(&wl->ws.lock);
+		idle_time_ns = ktime_to_ns(ktime_sub(now, wl->ws.last_time));
+		active = wl->ws.active;
+		spin_unlock_irq(&wl->ws.lock);
+
+		if (idle_time_ns < ((u64)WL_GC_TIME_SEC * NSEC_PER_SEC))
+			break;
+
+		if (!active) {
+			wakeup_source_remove(&wl->ws);
+			rb_erase(&wl->node, &wakelocks_tree);
+			list_del(&wl->lru);
+			kfree(wl->name);
+			kfree(wl);
+			decrement_wakelocks_number();
+		}
+	}
+	wakelocks_gc_count = 0;
+}
+#else /* !CONFIG_PM_WAKELOCKS_GC */
+static inline void wakelocks_lru_add(struct wakelock *wl) {}
+static inline void wakelocks_lru_most_recent(struct wakelock *wl) {}
+static inline void wakelocks_gc(void) {}
+#endif /* !CONFIG_PM_WAKELOCKS_GC */
+
 static struct wakelock *wakelock_lookup_add(const char *name, size_t len,
 					    bool add_if_not_found)
 {
@@ -123,7 +175,7 @@ static struct wakelock *wakelock_lookup_
 	wakeup_source_add(&wl->ws);
 	rb_link_node(&wl->node, parent, node);
 	rb_insert_color(&wl->node, &wakelocks_tree);
-	list_add(&wl->lru, &wakelocks_lru_list);
+	wakelocks_lru_add(wl);
 	increment_wakelocks_number();
 	return wl;
 }
@@ -166,42 +218,13 @@ int pm_wake_lock(const char *buf)
 		__pm_stay_awake(&wl->ws);
 	}
 
-	list_move(&wl->lru, &wakelocks_lru_list);
+	wakelocks_lru_most_recent(wl);
 
  out:
 	mutex_unlock(&wakelocks_lock);
 	return ret;
 }
 
-static void wakelocks_gc(void)
-{
-	struct wakelock *wl, *aux;
-	ktime_t now = ktime_get();
-
-	list_for_each_entry_safe_reverse(wl, aux, &wakelocks_lru_list, lru) {
-		u64 idle_time_ns;
-		bool active;
-
-		spin_lock_irq(&wl->ws.lock);
-		idle_time_ns = ktime_to_ns(ktime_sub(now, wl->ws.last_time));
-		active = wl->ws.active;
-		spin_unlock_irq(&wl->ws.lock);
-
-		if (idle_time_ns < ((u64)WL_GC_TIME_SEC * NSEC_PER_SEC))
-			break;
-
-		if (!active) {
-			wakeup_source_remove(&wl->ws);
-			rb_erase(&wl->node, &wakelocks_tree);
-			list_del(&wl->lru);
-			kfree(wl->name);
-			kfree(wl);
-			decrement_wakelocks_number();
-		}
-	}
-	wakelocks_gc_count = 0;
-}
-
 int pm_wake_unlock(const char *buf)
 {
 	struct wakelock *wl;
@@ -226,9 +249,9 @@ int pm_wake_unlock(const char *buf)
 		goto out;
 	}
 	__pm_relax(&wl->ws);
-	list_move(&wl->lru, &wakelocks_lru_list);
-	if (++wakelocks_gc_count > WL_GC_COUNT_MAX)
-		wakelocks_gc();
+
+	wakelocks_lru_most_recent(wl);
+	wakelocks_gc();
 
  out:
 	mutex_unlock(&wakelocks_lock);

