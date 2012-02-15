Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2BOWUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:20:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2BOWUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:20:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/3] PM / Sleep: Fix possible infinite loop during wakeup source destruction
Date: Wed, 15 Feb 2012 23:19:59 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202152318.04206.rjw@sisk.pl>
In-Reply-To: <201202152318.04206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202152319.59859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If wakeup_source_destroy() is called for an active wakeup source that
is never deactivated, it will spin forever.  To prevent that from
happening, make wakeup_source_destroy() call __pm_relax() for the
wakeup source object it is about to free instead of waiting until
it will be deactivated by someone else.  However, for this to work
it also needs to make sure that the timer function will not be
executed after the final __pm_relax(), so make it run
del_timer_sync() on the wakeup source's timer beforehand.

Additionally, update the kerneldoc comment to document the
requirement that __pm_stay_awake() and __pm_wakeup_event() must not
be run in parallel with wakeup_source_destroy().

Reported-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -74,22 +74,17 @@ EXPORT_SYMBOL_GPL(wakeup_source_create);
 /**
  * wakeup_source_destroy - Destroy a struct wakeup_source object.
  * @ws: Wakeup source to destroy.
+ *
+ * Callers must ensure that __pm_stay_awake() or __pm_wakeup_event() will never
+ * be run in parallel with this function for the same wakeup source object.
  */
 void wakeup_source_destroy(struct wakeup_source *ws)
 {
 	if (!ws)
 		return;
 
-	spin_lock_irq(&ws->lock);
-	while (ws->active) {
-		spin_unlock_irq(&ws->lock);
-
-		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
-
-		spin_lock_irq(&ws->lock);
-	}
-	spin_unlock_irq(&ws->lock);
-
+	del_timer_sync(&ws->timer);
+	__pm_relax(ws);
 	kfree(ws->name);
 	kfree(ws);
 }

