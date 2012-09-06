Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2IFSHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:07:55 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41496 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab2IFSHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:07:54 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Android Team <kernel-team@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>
Subject: [PATCH] wakeup: Use irqsave/irqrestore for events_lock
Date: Thu,  6 Sep 2012 14:07:37 -0400
Message-Id: <1346954857-52669-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090618-7182-0000-0000-000002864E1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Medhurst (Tixy) recently noticed a problem with the
events_lock usage. One of the Android patches that uses
wakeup_sources calls wakeup_source_add() with irqs disabled.
However, the event_lock usage in wakeup_source_add() uses
spin_lock_irq()/spin_unlock_irq(), which reenables interrupts.
This results in lockdep warnings.

The fix is to use spin_lock_irqsave()/spin_lock_irqrestore()
instead for the events_lock.

Full bug report here:
https://bugs.launchpad.net/linaro-landing-team-arm/+bug/1037565

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Android Team <kernel-team@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
Reported-and-debugged-by: Jon Medhurst (Tixy) <tixy@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/base/power/wakeup.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index cbb463b..0e4b093 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -127,6 +127,8 @@ EXPORT_SYMBOL_GPL(wakeup_source_destroy);
  */
 void wakeup_source_add(struct wakeup_source *ws)
 {
+	unsigned long flags;
+
 	if (WARN_ON(!ws))
 		return;
 
@@ -135,9 +137,9 @@ void wakeup_source_add(struct wakeup_source *ws)
 	ws->active = false;
 	ws->last_time = ktime_get();
 
-	spin_lock_irq(&events_lock);
+	spin_lock_irqsave(&events_lock, flags);
 	list_add_rcu(&ws->entry, &wakeup_sources);
-	spin_unlock_irq(&events_lock);
+	spin_unlock_irqrestore(&events_lock, flags);
 }
 EXPORT_SYMBOL_GPL(wakeup_source_add);
 
@@ -147,12 +149,14 @@ EXPORT_SYMBOL_GPL(wakeup_source_add);
  */
 void wakeup_source_remove(struct wakeup_source *ws)
 {
+	unsigned long flags;
+
 	if (WARN_ON(!ws))
 		return;
 
-	spin_lock_irq(&events_lock);
+	spin_lock_irqsave(&events_lock, flags);
 	list_del_rcu(&ws->entry);
-	spin_unlock_irq(&events_lock);
+	spin_unlock_irqrestore(&events_lock, flags);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(wakeup_source_remove);
@@ -723,15 +727,16 @@ bool pm_get_wakeup_count(unsigned int *count, bool block)
 bool pm_save_wakeup_count(unsigned int count)
 {
 	unsigned int cnt, inpr;
+	unsigned long flags;
 
 	events_check_enabled = false;
-	spin_lock_irq(&events_lock);
+	spin_lock_irqsave(&events_lock, flags);
 	split_counters(&cnt, &inpr);
 	if (cnt == count && inpr == 0) {
 		saved_count = count;
 		events_check_enabled = true;
 	}
-	spin_unlock_irq(&events_lock);
+	spin_unlock_irqrestore(&events_lock, flags);
 	return events_check_enabled;
 }
 
-- 
1.7.9.5

