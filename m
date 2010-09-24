Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0IXQbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:31:47 -0400
Received: from kroah.org ([198.145.64.141]:38543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794Ab0IXQ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:20 2010
Message-Id: <20100924162620.762901868@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [67/80] PM: Prevent waiting forever on asynchronous resume after failing suspend
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Colin Cross <ccross@android.com>

commit 152e1d592071c8b312bb898bc1118b64e4aea535 upstream.

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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/power/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -59,6 +59,7 @@ void device_pm_init(struct device *dev)
 {
 	dev->power.status = DPM_ON;
 	init_completion(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	pm_runtime_init(dev);
 }
 


