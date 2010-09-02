Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0IBCz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:55:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8542 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0IBCzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:55:25 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: Colin Cross <ccross@android.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
Date: Wed,  1 Sep 2010 19:54:12 -0700
Message-Id: <1283396052-3620-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only wait on a parent device during resume if the parent device is
suspended.

Consider three drivers, A, B, and C.  The parent of A is C, and C
has async_suspend set.  On boot, C->power.completion is initialized
to 0.

During the first suspend:
suspend_devices_and_enter(...)
 dpm_resume(...)
  device_suspend(A)
  device_suspend(B) returns error, aborts suspend
 dpm_resume_end(...)
   dpm_resume(...)
    device_resume(A)
     dpm_wait(A->parent == C)
      wait_for_completion(C->power.completion)

The wait_for_completion will never complete, because
complete_all(C->power.completion) will only be called from
device_suspend(C) or device_resume(C), neither of which is called
if suspend is aborted before C.

After a successful suspend->resume cycle, where B doesn't abort
suspend, C->power.completion is left in the completed state by the
call to device_resume(C), and the same call path will work if B
aborts suspend.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/base/power/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index cb784a0..e159910 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -526,7 +526,8 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	dpm_wait(dev->parent, async);
+	if (dev->parent && dev->parent->power.status >= DPM_OFF)
+		dpm_wait(dev->parent, async);
 	device_lock(dev);
 
 	dev->power.status = DPM_RESUMING;
-- 
1.7.1

