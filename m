Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0LAXlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:41:07 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:54879 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab0LAXlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:41:05 -0500
X-SpamScore: 1
X-BigFish: VS1(zz15bfM26b7nzz1202hzz8275bhz2dh2a8h691h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <greg@kroah.com>, <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] driver-core: document restrictions on device_rename()
Date: Wed, 1 Dec 2010 17:40:54 -0600
Message-ID: <1291246854-19283-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add text, courtesy of Kay Sievers, that provides some background on
device_rename() and why it shouldn't be used.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/base/core.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..8ff1531 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1513,6 +1513,34 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * exclusion between two different calls of device_rename
  * on the same device to ensure that new_name is valid and
  * won't conflict with other devices.
+ *
+ * Note: Don't call this function.  Currently, the networking layer calls this
+ * function, but that will change.  The following text from Kay Sievers offer
+ * some insight:
+ *
+ * Renaming devices is racy at many levels, symlinks and other stuff are not
+ * replaced atomically, you get a "move" uevent", but it's not easy to connect
+ * the event to the old and new device. Device nodes are not renamed at all,
+ * there isn't even support for that in the kernel now.
+ *
+ * In the meantime during renaming, your target name might be taken by another
+ * driver, creating conflicts. Or the old name is taken directly after you
+ * renamed it -- then you get events for the same DEVPATH, before you even seet
+ * the "move" event. It's just a mess, and nothing new should ever rely on
+ * kernel device renaming. Besides that it's not even implemented now for other
+ * things than (driver-core wise very simple) network devices.
+ *
+ * We are currently about to change network renaming in udev to completely
+ * disallow renaming of devices in the same namespace as the kernel uses,
+ * because we can't solve the problems properly, that arise with swapping names
+ * of multiple interfaces without races. Means, renaming of eth[0-9]* will only
+ * be allowed to some other name than eth[0-9]*, for the mentioned reasons.
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
1.7.2.3


