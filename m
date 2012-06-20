Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2FTCI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:08:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2FTCI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:08:26 -0400
From: Mandeep Singh Baines <mandeep.baines@gmail.com>
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-pm@vger.kernel.org,
        stable@kernel.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Colin Cross <ccross@android.com>, Sameer Nanda <snanda@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [PATCH] PM: Prevent waiting forever on asynchronous suspend after abort
Date: Tue, 19 Jun 2012 19:08:12 -0700
Message-Id: <1340158092-7530-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__device_suspend() must always send a completion. Otherwise, parent
devices will wait forever.

Commit 1e2ef05b, "PM: Limit race conditions between runtime PM and
system sleep (v2)", introduced a regression by short-circuiting the
complete_all() for certain error cases.

This patch fixes the bug by always signalling a completion.

Addresses http://crosbug.com/31972

Tested by injecting an abort via the following patch:

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index a004db3..e5a6fce 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -21,6 +21,7 @@
 #include <linux/pci.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/string.h>

 #include <asm/io.h>
 #include <asm/irq.h>
@@ -477,6 +478,8 @@ static int resume_common(struct device *dev, int event)

 static int hcd_pci_suspend(struct device *dev)
 {
+       if (!strcmp("0000:00:1d.3", dev_name(dev)))
+               return -EBUSY;
        return suspend_common(dev, device_may_wakeup(dev));
 }

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org
Cc: stable@kernel.org
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Colin Cross <ccross@android.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
---
 drivers/base/power/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e0fb5b0..9cb845e 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1031,7 +1031,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	dpm_wait_for_children(dev, async);
 
 	if (async_error)
-		return 0;
+		goto Complete;
 
 	pm_runtime_get_noresume(dev);
 	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
@@ -1040,7 +1040,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	if (pm_wakeup_pending()) {
 		pm_runtime_put_sync(dev);
 		async_error = -EBUSY;
-		return 0;
+		goto Complete;
 	}
 
 	device_lock(dev);
@@ -1097,6 +1097,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	}
 
 	device_unlock(dev);
+
+ Complete:
 	complete_all(&dev->power.completion);
 
 	if (error) {
-- 
1.7.3.4

