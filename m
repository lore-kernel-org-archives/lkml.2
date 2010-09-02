Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0IBXAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:00:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0IBXAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:00:47 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: Colin Cross <ccross@android.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH v2] PM: Prevent waiting forever on asynchronous resume after abort
Date: Thu,  2 Sep 2010 15:59:19 -0700
Message-Id: <1283468359-6642-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <201009022340.41584.rjw@sisk.pl>
References: <201009022340.41584.rjw@sisk.pl>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend, the power.completion is expected to be set when a
device has not yet started suspending.  Set it on init to fix a
corner case where a device is resumed when its parent has never
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
 drivers/base/power/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index cb784a0..b1b4029 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -63,6 +63,7 @@ void device_pm_init(struct device *dev)
 {
 	dev->power.status = DPM_ON;
 	init_completion(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	pm_runtime_init(dev);
 }
 
-- 
1.7.1

