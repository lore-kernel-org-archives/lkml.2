Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2BNXSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:18:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285Ab2BNXSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:18:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Date: Wed, 15 Feb 2012 00:22:25 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl> <CAMP5XgeqXJroKtHZO18SESFxg1iGP=wHAa+CU1zEEXQqUEQwTA@mail.gmail.com>
In-Reply-To: <CAMP5XgeqXJroKtHZO18SESFxg1iGP=wHAa+CU1zEEXQqUEQwTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202150022.26072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 14, 2012, Arve Hjønnevåg wrote:
> On Mon, Feb 6, 2012 at 5:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
> > All in all, it's not as much code as I thought it would be and it seems to be
> > relatively simple (which rises the question why the Android people didn't
> > even _try_ to do something like this instead of slapping the "real" wakelocks
> > onto the kernel FWIW).  IMHO it doesn't add anything really new to the kernel,
> > except for the user space interfaces that should be maintainable.  At least I
> > think I should be able to maintain them. :-)
> >
> 
> Replacing a working solution with an untested one takes time.

Sure, that's pretty obvious. :-)

> That said, I have recently tried replacing all our kernel wake-locks with a
> thin wrapper around wake-sources. This appears to mostly work,

Good!

> but the wake-source timeout feature has some bugs or incompatible apis. An
> init api would also be useful for embedding wake-sources in other data
> structures without adding another memory allocation. Your patch to
> move the spinlock init to wakeup_source_add still require the struct
> to be zero initialized and the name set manually.

That should be easy to fix.  What about the appended patch?

> I needed to use two wake-sources per wake-lock since calling
> __pm_stay_awake after __pm_wakeup_event on a wake-source does not
> cancel the timeout. Unless there is a reason to keep this behavior I
> would like __pm_stay_awake to cancel any active timeout.

That actually is a bug.  At least it's not consistent with
__pm_wakeup_event() that will replace the existing timeout with a new
one.

I'll post a patch to fix that in the next couple of days, stay tuned. :-)

> Destroying a wake-source also has some problems. If you call
> wakeup_source_destroy it will spin forever if the wake-source is
> active without a timeout. And, if you call __pm_relax then
> wakeup_source_destroy it could free the wake-source memory while the
> timer function is still running.

This also is a bug that needs fixing anyway.

> It also looks as if the wake_source can be immediately deactivated if
> you call __pm_wakeup_event at the same time as the previous timeout expired.

Yes, there is a race window if the timer function has already started.
It looks like I wanted to make it too simple. :-)  Will fix.

Thanks,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   44 +++++++++++++++++++++++++++++++++++++-------
 include/linux/pm_wakeup.h   |    9 +++++++++
 2 files changed, 46 insertions(+), 7 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -53,6 +53,28 @@ static void pm_wakeup_timer_fn(unsigned
 static LIST_HEAD(wakeup_sources);
 
 /**
+ * wakeup_source_init - Initialize a struct wakeup_source object.
+ * @ws: Wakeup source to initialize.
+ * @name: Name of the new wakeup source.
+ */
+int wakeup_source_init(struct wakeup_source *ws, const char *name)
+{
+	int ret = 0;
+
+	if (!ws)
+		return -EINVAL;
+
+	memset(ws, 0, sizeof(*ws));
+	if (name) {
+		ws->name = kstrdup(name, GFP_KERNEL);
+		if (!ws->name)
+			ret = -ENOMEM;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wakeup_source_init);
+
+/**
  * wakeup_source_create - Create a struct wakeup_source object.
  * @name: Name of the new wakeup source.
  */
@@ -60,22 +82,20 @@ struct wakeup_source *wakeup_source_crea
 {
 	struct wakeup_source *ws;
 
-	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
+	ws = kmalloc(sizeof(*ws), GFP_KERNEL);
 	if (!ws)
 		return NULL;
 
-	if (name)
-		ws->name = kstrdup(name, GFP_KERNEL);
-
+	wakeup_source_init(ws, name);
 	return ws;
 }
 EXPORT_SYMBOL_GPL(wakeup_source_create);
 
 /**
- * wakeup_source_destroy - Destroy a struct wakeup_source object.
- * @ws: Wakeup source to destroy.
+ * wakeup_source_drop - Prepare a struct wakeup_source object for destruction.
+ * @ws: Wakeup source to prepare for destruction.
  */
-void wakeup_source_destroy(struct wakeup_source *ws)
+void wakeup_source_drop(struct wakeup_source *ws)
 {
 	if (!ws)
 		return;
@@ -91,6 +111,16 @@ void wakeup_source_destroy(struct wakeup
 	spin_unlock_irq(&ws->lock);
 
 	kfree(ws->name);
+}
+EXPORT_SYMBOL_GPL(wakeup_source_drop);
+
+/**
+ * wakeup_source_destroy - Destroy a struct wakeup_source object.
+ * @ws: Wakeup source to destroy.
+ */
+void wakeup_source_destroy(struct wakeup_source *ws)
+{
+	wakeup_source_drop(ws);
 	kfree(ws);
 }
 EXPORT_SYMBOL_GPL(wakeup_source_destroy);
Index: linux/include/linux/pm_wakeup.h
===================================================================
--- linux.orig/include/linux/pm_wakeup.h
+++ linux/include/linux/pm_wakeup.h
@@ -73,7 +73,9 @@ static inline bool device_may_wakeup(str
 }
 
 /* drivers/base/power/wakeup.c */
+extern int wakeup_source_init(struct wakeup_source *ws, const char *name);
 extern struct wakeup_source *wakeup_source_create(const char *name);
+extern void wakeup_source_drop(struct wakeup_source *ws);
 extern void wakeup_source_destroy(struct wakeup_source *ws);
 extern void wakeup_source_add(struct wakeup_source *ws);
 extern void wakeup_source_remove(struct wakeup_source *ws);
@@ -103,11 +105,18 @@ static inline bool device_can_wakeup(str
 	return dev->power.can_wakeup;
 }
 
+static inline int wakeup_source_init(struct wakeup_source *ws, const char *name)
+{
+	return -ENOSYS;
+}
+
 static inline struct wakeup_source *wakeup_source_create(const char *name)
 {
 	return NULL;
 }
 
+static inline void wakeup_source_drop(struct wakeup_source *ws) {}
+
 static inline void wakeup_source_destroy(struct wakeup_source *ws) {}
 
 static inline void wakeup_source_add(struct wakeup_source *ws) {}

