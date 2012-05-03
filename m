Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab2ECT3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:29:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab2ECT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:29:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: [PATCH 1/2] PM / Sleep: Make the limit of user space wakeup sources configurable
Date: Thu, 3 May 2012 21:30:41 +0200
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
Message-Id: <201205032130.41519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to configure out the check against the limit of
user space wakeup sources for debugging and default Android builds.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig    |    6 ++++++
 kernel/power/wakelock.c |   31 ++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -119,6 +119,12 @@ config PM_WAKELOCKS
 	Allow user space to create, activate and deactivate wakeup source
 	objects with the help of a sysfs-based interface.
 
+config PM_WAKELOCKS_LIMIT
+	int "Maximum number of user space wakeup sources (0 = no limit)"
+	range 0 100000
+	default 100
+	depends on PM_WAKELOCKS
+
 config PM_RUNTIME
 	bool "Run-time PM core functionality"
 	depends on !IA64_HP_SIM
Index: linux/kernel/power/wakelock.c
===================================================================
--- linux.orig/kernel/power/wakelock.c
+++ linux/kernel/power/wakelock.c
@@ -17,7 +17,6 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 
-#define WL_NUMBER_LIMIT	100
 #define WL_GC_COUNT_MAX	100
 #define WL_GC_TIME_SEC	300
 
@@ -32,7 +31,6 @@ struct wakelock {
 
 static struct rb_root wakelocks_tree = RB_ROOT;
 static LIST_HEAD(wakelocks_lru_list);
-static unsigned int number_of_wakelocks;
 static unsigned int wakelocks_gc_count;
 
 ssize_t pm_show_wakelocks(char *buf, bool show_active)
@@ -58,6 +56,29 @@ ssize_t pm_show_wakelocks(char *buf, boo
 	return (str - buf);
 }
 
+#if CONFIG_PM_WAKELOCKS_LIMIT > 0
+static unsigned int number_of_wakelocks;
+
+static inline bool wakelocks_limit_exceeded(void)
+{
+	return number_of_wakelocks > CONFIG_PM_WAKELOCKS_LIMIT;
+}
+
+static inline void increment_wakelocks_number(void)
+{
+	number_of_wakelocks++;
+}
+
+static inline void decrement_wakelocks_number(void)
+{
+	number_of_wakelocks--;
+}
+#else /* CONFIG_PM_WAKELOCKS_LIMIT = 0 */
+static inline bool wakelocks_limit_exceeded(void) { return false; }
+static inline void increment_wakelocks_number(void) {}
+static inline void decrement_wakelocks_number(void) {}
+#endif /* CONFIG_PM_WAKELOCKS_LIMIT */
+
 static struct wakelock *wakelock_lookup_add(const char *name, size_t len,
 					    bool add_if_not_found)
 {
@@ -85,7 +106,7 @@ static struct wakelock *wakelock_lookup_
 	if (!add_if_not_found)
 		return ERR_PTR(-EINVAL);
 
-	if (number_of_wakelocks > WL_NUMBER_LIMIT)
+	if (wakelocks_limit_exceeded())
 		return ERR_PTR(-ENOSPC);
 
 	/* Not found, we have to add a new one. */
@@ -103,7 +124,7 @@ static struct wakelock *wakelock_lookup_
 	rb_link_node(&wl->node, parent, node);
 	rb_insert_color(&wl->node, &wakelocks_tree);
 	list_add(&wl->lru, &wakelocks_lru_list);
-	number_of_wakelocks++;
+	increment_wakelocks_number();
 	return wl;
 }
 
@@ -175,7 +196,7 @@ static void wakelocks_gc(void)
 			list_del(&wl->lru);
 			kfree(wl->name);
 			kfree(wl);
-			number_of_wakelocks--;
+			decrement_wakelocks_number();
 		}
 	}
 	wakelocks_gc_count = 0;

