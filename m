Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2BOWVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:21:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab2BOWUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:20:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/3] PM / Sleep: Make __pm_stay_awake() delete wakeup source timers
Date: Wed, 15 Feb 2012 23:24:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202152318.04206.rjw@sisk.pl>
In-Reply-To: <201202152318.04206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202152324.08073.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If __pm_stay_awake() is called after __pm_wakeup_event() for the same
wakep source object before its timer expires, it won't cancel the
timer, so the wakeup source will be deactivated from the timer
function as scheduled by __pm_wakeup_event().  In that case
__pm_stay_awake() doesn't have any effect beyond incrementing
the wakeup source's event_count field, although it should cancel
the timer and make the wakeup source stay active until __pm_relax()
is called for it.

Conversely, if __pm_wakeup_event() is called for a wakeup source
that has been activated by __pm_stay_awake() before, it will set up
the timer to deactivate the wakeup source, although it should leave
it active until __pm_relax() is called for it.

To fix the first of these problems make __pm_stay_awake() delete the
wakeup source's timer and ensure that it won't be deactivated from
the timer funtion afterwards by clearing its timer_expires field.

To fix the second one, make __pm_wakeup_event() skip setting up the
timer if it sees that the wakeup source is active and its
timer_expires field is zero, which means that it has been activated
by __pm_stay_awake().

Reported-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -365,9 +365,15 @@ void __pm_stay_awake(struct wakeup_sourc
 		return;
 
 	spin_lock_irqsave(&ws->lock, flags);
+
+	del_timer(&ws->timer);
+	ws->timer_expires = 0;
+
 	ws->event_count++;
+
 	if (!ws->active)
 		wakeup_source_activate(ws);
+
 	spin_unlock_irqrestore(&ws->lock, flags);
 }
 EXPORT_SYMBOL_GPL(__pm_stay_awake);
@@ -529,8 +535,12 @@ void __pm_wakeup_event(struct wakeup_sou
 	spin_lock_irqsave(&ws->lock, flags);
 
 	ws->event_count++;
-	if (!ws->active)
+	if (ws->active) {
+		if (!ws->timer_expires)
+			goto unlock;
+	} else {
 		wakeup_source_activate(ws);
+	}
 
 	if (!msec) {
 		wakeup_source_deactivate(ws);

