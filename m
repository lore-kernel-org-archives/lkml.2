Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1ILQtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:49:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64825 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1ILQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:47:46 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 03/10] hwspinlock/omap: simplify allocation scheme
Date: Mon, 12 Sep 2011 19:46:58 +0300
Message-Id: <1315846025-11453-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allocating every hwspinlock separately, allocate
them all in one shot.

This both simplifies the driver and helps achieving better
slab utilization.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/hwspinlock/omap_hwspinlock.c |   51 +++++++++++----------------------
 1 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 1d19fe9..d058348 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -52,6 +52,7 @@ struct omap_hwspinlock {
 struct omap_hwspinlock_state {
 	int num_locks;			/* Total number of locks in system */
 	void __iomem *io_base;		/* Mapped base address */
+	struct omap_hwspinlock lock[0];	/* Array of 'num_locks' locks */
 };
 
 static int omap_hwspinlock_trylock(struct hwspinlock *lock)
@@ -95,7 +96,6 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 {
 	struct omap_hwspinlock *omap_lock;
 	struct omap_hwspinlock_state *state;
-	struct hwspinlock *lock;
 	struct resource *res;
 	void __iomem *io_base;
 	int i, ret;
@@ -104,15 +104,9 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-
 	io_base = ioremap(res->start, resource_size(res));
-	if (!io_base) {
-		ret = -ENOMEM;
-		goto free_state;
-	}
+	if (!io_base)
+		return -ENOMEM;
 
 	/* Determine number of locks */
 	i = readl(io_base + SYSSTATUS_OFFSET);
@@ -124,7 +118,15 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 		goto iounmap_base;
 	}
 
-	state->num_locks = i * 32;
+	i *= 32; /* actual number of locks in this device */
+
+	state = kzalloc(sizeof(*state) + i * sizeof(*omap_lock), GFP_KERNEL);
+	if (!state) {
+		ret = -ENOMEM;
+		goto iounmap_base;
+	}
+
+	state->num_locks = i;
 	state->io_base = io_base;
 
 	platform_set_drvdata(pdev, state);
@@ -136,11 +138,7 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	for (i = 0; i < state->num_locks; i++) {
-		omap_lock = kzalloc(sizeof(*omap_lock), GFP_KERNEL);
-		if (!omap_lock) {
-			ret = -ENOMEM;
-			goto free_locks;
-		}
+		omap_lock = &state->lock[i];
 
 		omap_lock->lock.dev = &pdev->dev;
 		omap_lock->lock.id = i;
@@ -148,30 +146,19 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 		omap_lock->addr = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
 		ret = hwspin_lock_register(&omap_lock->lock);
-		if (ret) {
-			kfree(omap_lock);
+		if (ret)
 			goto free_locks;
-		}
 	}
 
 	return 0;
 
 free_locks:
-	while (--i >= 0) {
-		lock = hwspin_lock_unregister(i);
-		/* this should't happen, but let's give our best effort */
-		if (!lock) {
-			dev_err(&pdev->dev, "%s: cleanups failed\n", __func__);
-			continue;
-		}
-		omap_lock = to_omap_hwspinlock(lock);
-		kfree(omap_lock);
-	}
+	while (--i >= 0)
+		hwspin_lock_unregister(i);
 	pm_runtime_disable(&pdev->dev);
+	kfree(state);
 iounmap_base:
 	iounmap(io_base);
-free_state:
-	kfree(state);
 	return ret;
 }
 
@@ -179,7 +166,6 @@ static int omap_hwspinlock_remove(struct platform_device *pdev)
 {
 	struct omap_hwspinlock_state *state = platform_get_drvdata(pdev);
 	struct hwspinlock *lock;
-	struct omap_hwspinlock *omap_lock;
 	int i;
 
 	for (i = 0; i < state->num_locks; i++) {
@@ -190,9 +176,6 @@ static int omap_hwspinlock_remove(struct platform_device *pdev)
 			dev_err(&pdev->dev, "%s: failed on %d\n", __func__, i);
 			return -EBUSY;
 		}
-
-		omap_lock = to_omap_hwspinlock(lock);
-		kfree(omap_lock);
 	}
 
 	pm_runtime_disable(&pdev->dev);
-- 
1.7.4.1

