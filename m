Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1ILQrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:47:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42725 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1ILQrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:47:43 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 02/10] hwspinlock/core: simplify 'owner' handling
Date: Mon, 12 Sep 2011 19:46:57 +0300
Message-Id: <1315846025-11453-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct device_driver's owner member instead of asking drivers to
explicitly pass the owner again.

This simplifies drivers and also save some memory, since there's no
point now in maintaining a separate owner pointer per hwspinlock.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 Documentation/hwspinlock.txt             |    6 ++----
 drivers/hwspinlock/hwspinlock_core.c     |    4 ++--
 drivers/hwspinlock/hwspinlock_internal.h |    4 +---
 drivers/hwspinlock/omap_hwspinlock.c     |    2 +-
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index 7dcd1a4..bbaa464 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -256,18 +256,16 @@ underlying hwspinlock implementation using the hwspin_lock_register() API.
  * @ops: vendor-specific hwspinlock handlers
  * @id: a global, unique, system-wide, index of the lock.
  * @lock: initialized and used by hwspinlock core
- * @owner: underlying implementation module, used to maintain module ref count
  */
 struct hwspinlock {
 	struct device *dev;
 	const struct hwspinlock_ops *ops;
 	int id;
 	spinlock_t lock;
-	struct module *owner;
 };
 
-The underlying implementation is responsible to assign the dev, ops, id and
-owner members. The lock member, OTOH, is initialized and used by the hwspinlock
+The underlying implementation is responsible to assign the dev, ops and id
+members. The lock member, OTOH, is initialized and used by the hwspinlock
 core.
 
 6. Implementation callbacks
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 43a6271..af5175c 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -352,7 +352,7 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 	int ret;
 
 	/* prevent underlying implementation from being removed */
-	if (!try_module_get(hwlock->owner)) {
+	if (!try_module_get(hwlock->dev->driver->owner)) {
 		dev_err(hwlock->dev, "%s: can't get owner\n", __func__);
 		return -EINVAL;
 	}
@@ -535,7 +535,7 @@ int hwspin_lock_free(struct hwspinlock *hwlock)
 	/* sanity check (this shouldn't happen) */
 	WARN_ON(tmp != hwlock);
 
-	module_put(hwlock->owner);
+	module_put(hwlock->dev->driver->owner);
 
 out:
 	spin_unlock(&hwspinlock_tree_lock);
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index 69935e6..fb25830 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -44,10 +44,9 @@ struct hwspinlock_ops {
  * @ops: platform-specific hwspinlock handlers
  * @id: a global, unique, system-wide, index of the lock.
  * @lock: initialized and used by hwspinlock core
- * @owner: underlying implementation module, used to maintain module ref count
  *
  * Note: currently simplicity was opted for, but later we can squeeze some
- * memory bytes by grouping the dev, ops and owner members in a single
+ * memory bytes by grouping dev, ops in a single
  * per-platform struct, and have all hwspinlocks point at it.
  */
 struct hwspinlock {
@@ -55,7 +54,6 @@ struct hwspinlock {
 	const struct hwspinlock_ops *ops;
 	int id;
 	spinlock_t lock;
-	struct module *owner;
 };
 
 #endif /* __HWSPINLOCK_HWSPINLOCK_H */
diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index a8f0273..1d19fe9 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -143,7 +143,6 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 		}
 
 		omap_lock->lock.dev = &pdev->dev;
-		omap_lock->lock.owner = THIS_MODULE;
 		omap_lock->lock.id = i;
 		omap_lock->lock.ops = &omap_hwspinlock_ops;
 		omap_lock->addr = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
@@ -208,6 +207,7 @@ static struct platform_driver omap_hwspinlock_driver = {
 	.remove		= omap_hwspinlock_remove,
 	.driver		= {
 		.name	= "omap_hwspinlock",
+		.owner	= THIS_MODULE,
 	},
 };
 
-- 
1.7.4.1

