Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1AYARr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:17:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab1AYARN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:17:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/3] PM / Wakeup: Don't update events_check_enabled in pm_get_wakeup_count()
Date: Tue, 25 Jan 2011 01:16:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201101250112.40350.rjw@sisk.pl>
In-Reply-To: <201101250112.40350.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250116.27679.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since pm_save_wakeup_count() has just been changed to clear
events_check_enabled unconditionally before checking if there are
any new wakeup events registered since the last read from
/sys/power/wakeup_count, the detection of wakeup events during
suspend may be disabled, after it's been enabled, by writing a
"wrong" value back to /sys/power/wakeup_count.  For this reason,
it is not necessary to update events_check_enabled in
pm_get_wakeup_count() any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -616,17 +616,14 @@ bool pm_wakeup_pending(void)
  * Store the number of registered wakeup events at the address in @count.  Block
  * if the current number of wakeup events being processed is nonzero.
  *
- * Return false if the wait for the number of wakeup events being processed to
+ * Return 'false' if the wait for the number of wakeup events being processed to
  * drop down to zero has been interrupted by a signal (and the current number
- * of wakeup events being processed is still nonzero).  Otherwise return true.
+ * of wakeup events being processed is still nonzero).  Otherwise return 'true'.
  */
 bool pm_get_wakeup_count(unsigned int *count)
 {
 	bool ret;
 
-	if (capable(CAP_SYS_ADMIN))
-		events_check_enabled = false;
-
 	while (atomic_read(&events_in_progress) && !signal_pending(current)) {
 		pm_wakeup_update_hit_counts();
 		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));

