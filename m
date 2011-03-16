Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab1CPVLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:11:35 -0400
Received: from kroah.org ([198.145.64.141]:42511 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1CPVLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/50] driver-core: document restrictions on device_rename()
Date: Wed, 16 Mar 2011 14:10:39 -0700
Message-Id: <1300309888-5028-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110316205204.GA2686@kroah.com>
References: <20110316205204.GA2686@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timur Tabi <timur@freescale.com>

Add text, courtesy of Kay Sievers, that provides some background on
device_rename() and why it shouldn't be used.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 080e9ca..9cd3b5c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1551,7 +1551,34 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * on the same device to ensure that new_name is valid and
  * won't conflict with other devices.
  *
- * "Never use this function, bad things will happen" - gregkh
+ * Note: Don't call this function.  Currently, the networking layer calls this
+ * function, but that will change.  The following text from Kay Sievers offers
+ * some insight:
+ *
+ * Renaming devices is racy at many levels, symlinks and other stuff are not
+ * replaced atomically, and you get a "move" uevent, but it's not easy to
+ * connect the event to the old and new device. Device nodes are not renamed at
+ * all, there isn't even support for that in the kernel now.
+ *
+ * In the meantime, during renaming, your target name might be taken by another
+ * driver, creating conflicts. Or the old name is taken directly after you
+ * renamed it -- then you get events for the same DEVPATH, before you even see
+ * the "move" event. It's just a mess, and nothing new should ever rely on
+ * kernel device renaming. Besides that, it's not even implemented now for
+ * other things than (driver-core wise very simple) network devices.
+ *
+ * We are currently about to change network renaming in udev to completely
+ * disallow renaming of devices in the same namespace as the kernel uses,
+ * because we can't solve the problems properly, that arise with swapping names
+ * of multiple interfaces without races. Means, renaming of eth[0-9]* will only
+ * be allowed to some other name than eth[0-9]*, for the aforementioned
+ * reasons.
+ *
+ * Make up a "real" name in the driver before you register anything, or add
+ * some other attributes for userspace to find the device, or use udev to add
+ * symlinks -- but never rename kernel devices later, it's a complete mess. We
+ * don't even want to get into that and try to implement the missing pieces in
+ * the core. We really have other pieces to fix in the driver core mess. :)
  */
 int device_rename(struct device *dev, const char *new_name)
 {
-- 
1.7.4.1

