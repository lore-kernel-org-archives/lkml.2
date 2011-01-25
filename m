Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1AYARN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:17:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1AYARM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:17:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] PM / Wakeup: Make pm_save_wakeup_count() work as documented
Date: Tue, 25 Jan 2011 01:15:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201101250112.40350.rjw@sisk.pl>
In-Reply-To: <201101250112.40350.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250115.34088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

According to Documentation/ABI/testing/sysfs-power, the
/sys/power/wakeup_count interface should only make the kernel react
to wakeup events during suspend if the last write to it has been
successful.  However, if /sys/power/wakeup_count is written to two
times in a row, where the first write is successful and the second
is not, the kernel will still react to wakeup events during suspend
due to a bug in pm_save_wakeup_count().

Fix the bug by making pm_save_wakeup_count() clear
events_check_enabled unconditionally before checking if there are
any new wakeup events registered since the previous read from
/sys/power/wakeup_count.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -644,23 +644,22 @@ bool pm_get_wakeup_count(unsigned int *c
  *
  * If @count is equal to the current number of registered wakeup events and the
  * current number of wakeup events being processed is zero, store @count as the
- * old number of registered wakeup events to be used by pm_check_wakeup_events()
- * and return true.  Otherwise return false.
+ * old number of registered wakeup events for pm_check_wakeup_events(), enable
+ * wakeup events detection and return 'true'.  Otherwise disable wakeup events
+ * detection and return 'false'.
  */
 bool pm_save_wakeup_count(unsigned int count)
 {
-	bool ret = false;
-
+	events_check_enabled = false;
 	spin_lock_irq(&events_lock);
 	if (!__pm_wakeup_pending(count)) {
 		saved_count = count;
 		events_check_enabled = true;
-		ret = true;
 	}
 	spin_unlock_irq(&events_lock);
-	if (!ret)
+	if (!events_check_enabled)
 		pm_wakeup_update_hit_counts();
-	return ret;
+	return events_check_enabled;
 }
 
 static struct dentry *wakeup_sources_stats_dentry;

