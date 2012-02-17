Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2BQW6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:58:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2BQW6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:58:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Sleep: Add more wakeup source initialization routines
Date: Sat, 18 Feb 2012 00:02:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl> <201202162322.22105.rjw@sisk.pl> <CAMP5XgfNqRH_PWi6PR_aTfCwsb5tZRvhB=YtmB5YfngsCOE0DQ@mail.gmail.com>
In-Reply-To: <CAMP5XgfNqRH_PWi6PR_aTfCwsb5tZRvhB=YtmB5YfngsCOE0DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202180002.10297.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The existing wakeup source initialization routines are not
particularly useful for wakeup sources that aren't created by
wakeup_source_create(), because their users have to open code
filling the objects with zeros and setting their names.  For this
reason, introduce routines that can be used for initializing, for
example, static wakeup source objects.

Requested-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

This patch is on top of the linux-next branch of the linux-pm tree.

Thanks,
Rafael

---
 drivers/base/power/wakeup.c |   41 ++++++++++++++++++++++++++++++++++-------
 include/linux/pm_wakeup.h   |   20 ++++++++++++++++++++
 2 files changed, 54 insertions(+), 7 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -53,6 +53,23 @@ static void pm_wakeup_timer_fn(unsigned
 static LIST_HEAD(wakeup_sources);
 
 /**
+ * wakeup_source_prepare - Prepare a new wakeup source for initialization.
+ * @ws: Wakeup source to prepare.
+ * @name: Pointer to the name of the new wakeup source.
+ *
+ * Callers must ensure that the @name string won't be freed when @ws is still in
+ * use.
+ */
+void wakeup_source_prepare(struct wakeup_source *ws, const char *name)
+{
+	if (ws) {
+		memset(ws, 0, sizeof(*ws));
+		ws->name = name;
+	}
+}
+EXPORT_SYMBOL_GPL(wakeup_source_prepare);
+
+/**
  * wakeup_source_create - Create a struct wakeup_source object.
  * @name: Name of the new wakeup source.
  */
@@ -60,31 +77,41 @@ struct wakeup_source *wakeup_source_crea
 {
 	struct wakeup_source *ws;
 
-	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
+	ws = kmalloc(sizeof(*ws), GFP_KERNEL);
 	if (!ws)
 		return NULL;
 
-	if (name)
-		ws->name = kstrdup(name, GFP_KERNEL);
-
+	wakeup_source_prepare(ws, name ? kstrdup(name, GFP_KERNEL) : NULL);
 	return ws;
 }
 EXPORT_SYMBOL_GPL(wakeup_source_create);
 
 /**
- * wakeup_source_destroy - Destroy a struct wakeup_source object.
- * @ws: Wakeup source to destroy.
+ * wakeup_source_drop - Prepare a struct wakeup_source object for destruction.
+ * @ws: Wakeup source to prepare for destruction.
  *
  * Callers must ensure that __pm_stay_awake() or __pm_wakeup_event() will never
  * be run in parallel with this function for the same wakeup source object.
  */
-void wakeup_source_destroy(struct wakeup_source *ws)
+void wakeup_source_drop(struct wakeup_source *ws)
 {
 	if (!ws)
 		return;
 
 	del_timer_sync(&ws->timer);
 	__pm_relax(ws);
+}
+EXPORT_SYMBOL_GPL(wakeup_source_drop);
+
+/**
+ * wakeup_source_destroy - Destroy a struct wakeup_source object.
+ * @ws: Wakeup source to destroy.
+ *
+ * Use only for wakeup source objects created with wakeup_source_create().
+ */
+void wakeup_source_destroy(struct wakeup_source *ws)
+{
+	wakeup_source_drop(ws);
 	kfree(ws->name);
 	kfree(ws);
 }
Index: linux/include/linux/pm_wakeup.h
===================================================================
--- linux.orig/include/linux/pm_wakeup.h
+++ linux/include/linux/pm_wakeup.h
@@ -73,7 +73,9 @@ static inline bool device_may_wakeup(str
 }
 
 /* drivers/base/power/wakeup.c */
+extern void wakeup_source_prepare(struct wakeup_source *ws, const char *name);
 extern struct wakeup_source *wakeup_source_create(const char *name);
+extern void wakeup_source_drop(struct wakeup_source *ws);
 extern void wakeup_source_destroy(struct wakeup_source *ws);
 extern void wakeup_source_add(struct wakeup_source *ws);
 extern void wakeup_source_remove(struct wakeup_source *ws);
@@ -103,11 +105,16 @@ static inline bool device_can_wakeup(str
 	return dev->power.can_wakeup;
 }
 
+static inline void wakeup_source_prepare(struct wakeup_source *ws,
+					 const char *name) {}
+
 static inline struct wakeup_source *wakeup_source_create(const char *name)
 {
 	return NULL;
 }
 
+static inline void wakeup_source_drop(struct wakeup_source *ws) {}
+
 static inline void wakeup_source_destroy(struct wakeup_source *ws) {}
 
 static inline void wakeup_source_add(struct wakeup_source *ws) {}
@@ -165,4 +172,17 @@ static inline void pm_wakeup_event(struc
 
 #endif /* !CONFIG_PM_SLEEP */
 
+static inline void wakeup_source_init(struct wakeup_source *ws,
+				      const char *name)
+{
+	wakeup_source_prepare(ws, name);
+	wakeup_source_add(ws);
+}
+
+static inline void wakeup_source_trash(struct wakeup_source *ws)
+{
+	wakeup_source_remove(ws);
+	wakeup_source_drop(ws);
+}
+
 #endif /* _LINUX_PM_WAKEUP_H */

