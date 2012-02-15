Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2BOWUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:20:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab2BOWUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:20:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / Sleep: Fix race conditions related to wakeup source timer function
Date: Wed, 15 Feb 2012 23:21:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202152318.04206.rjw@sisk.pl>
In-Reply-To: <201202152318.04206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202152321.57853.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If __pm_wakeup_event() has been used (with a nonzero timeout) to
report a wakeup event and then __pm_relax() immediately followed by
__pm_stay_awake() is called or __pm_wakeup_event() is called once
again for the same wakeup source object before its timer expires, the
timer function pm_wakeup_timer_fn() may still be run as a result of
the previous __pm_wakeup_event() call.  In either of those cases it
may mistakenly deactivate the wakeup source that has just been
activated.

To prevent that from happening, make wakeup_source_deactivate()
clear the wakeup source's timer_expires field and make
pm_wakeup_timer_fn() check if timer_expires is different from zero
and if it's not in future before calling wakeup_source_deactivate()
(if timer_expires is 0, it means that the timer has just been
deleted and if timer_expires is in future, it means that the timer
has just been rescheduled to a different time).

Reported-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -433,6 +433,7 @@ static void wakeup_source_deactivate(str
 		ws->max_time = duration;
 
 	del_timer(&ws->timer);
+	ws->timer_expires = 0;
 
 	/*
 	 * Increment the counter of registered wakeup events and decrement the
@@ -487,11 +488,22 @@ EXPORT_SYMBOL_GPL(pm_relax);
  * pm_wakeup_timer_fn - Delayed finalization of a wakeup event.
  * @data: Address of the wakeup source object associated with the event source.
  *
- * Call __pm_relax() for the wakeup source whose address is stored in @data.
+ * Call wakeup_source_deactivate() for the wakeup source whose address is stored
+ * in @data if it is currently active and its timer has not been canceled and
+ * the expiration time of the timer is not in future.
  */
 static void pm_wakeup_timer_fn(unsigned long data)
 {
-	__pm_relax((struct wakeup_source *)data);
+	struct wakeup_source *ws = (struct wakeup_source *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ws->lock, flags);
+
+	if (ws->active && ws->timer_expires
+	    && time_after_eq(jiffies, ws->timer_expires))
+		wakeup_source_deactivate(ws);
+
+	spin_unlock_irqrestore(&ws->lock, flags);
 }
 
 /**

