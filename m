Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1HVGRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 02:17:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1HVGRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 02:17:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [Replacement][PATCH 1/2 v2] PM: Use spinlock instead of mutex in clock management functions
Date: Mon, 22 Aug 2011 08:18:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201108202131.19479.rjw@sisk.pl> <201108212109.30399.rjw@sisk.pl> <201108212110.45316.rjw@sisk.pl>
In-Reply-To: <201108212110.45316.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108220818.48725.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The lock member of struct pm_clk_data is of type struct mutex,
which is a problem, because the suspend and resume routines
defined in drivers/base/power/clock_ops.c cannot be executed
with interrupts disabled for this reason.  Modify
struct pm_clk_data so that its lock member is a spinlock.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

The previous [1/2] in this series was on top of the branch at

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-domains

but what is needed now is a version on top of the current mainline tree, which
is this one.

Thanks,
Rafael

---
 drivers/base/power/clock_ops.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

Index: linux/drivers/base/power/clock_ops.c
===================================================================
--- linux.orig/drivers/base/power/clock_ops.c
+++ linux/drivers/base/power/clock_ops.c
@@ -19,7 +19,7 @@
 
 struct pm_clk_data {
 	struct list_head clock_list;
-	struct mutex lock;
+	spinlock_t lock;
 };
 
 enum pce_status {
@@ -73,9 +73,9 @@ int pm_clk_add(struct device *dev, const
 		}
 	}
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irq(&pcd->lock);
 	list_add_tail(&ce->node, &pcd->clock_list);
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irq(&pcd->lock);
 	return 0;
 }
 
@@ -83,8 +83,8 @@ int pm_clk_add(struct device *dev, const
  * __pm_clk_remove - Destroy PM clock entry.
  * @ce: PM clock entry to destroy.
  *
- * This routine must be called under the mutex protecting the PM list of clocks
- * corresponding the the @ce's device.
+ * This routine must be called under the spinlock protecting the PM list of
+ * clocks corresponding the the @ce's device.
  */
 static void __pm_clk_remove(struct pm_clock_entry *ce)
 {
@@ -123,7 +123,7 @@ void pm_clk_remove(struct device *dev, c
 	if (!pcd)
 		return;
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irq(&pcd->lock);
 
 	list_for_each_entry(ce, &pcd->clock_list, node) {
 		if (!con_id && !ce->con_id) {
@@ -137,7 +137,7 @@ void pm_clk_remove(struct device *dev, c
 		}
 	}
 
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irq(&pcd->lock);
 }
 
 /**
@@ -158,7 +158,7 @@ int pm_clk_init(struct device *dev)
 	}
 
 	INIT_LIST_HEAD(&pcd->clock_list);
-	mutex_init(&pcd->lock);
+	spin_lock_init(&pcd->lock);
 	dev->power.subsys_data = pcd;
 	return 0;
 }
@@ -181,12 +181,12 @@ void pm_clk_destroy(struct device *dev)
 
 	dev->power.subsys_data = NULL;
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irq(&pcd->lock);
 
 	list_for_each_entry_safe_reverse(ce, c, &pcd->clock_list, node)
 		__pm_clk_remove(ce);
 
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irq(&pcd->lock);
 
 	kfree(pcd);
 }
@@ -220,13 +220,14 @@ int pm_clk_suspend(struct device *dev)
 {
 	struct pm_clk_data *pcd = __to_pcd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
 	if (!pcd)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irqsave(&pcd->lock, flags);
 
 	list_for_each_entry_reverse(ce, &pcd->clock_list, node) {
 		if (ce->status == PCE_STATUS_NONE)
@@ -238,7 +239,7 @@ int pm_clk_suspend(struct device *dev)
 		}
 	}
 
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irqrestore(&pcd->lock, flags);
 
 	return 0;
 }
@@ -251,13 +252,14 @@ int pm_clk_resume(struct device *dev)
 {
 	struct pm_clk_data *pcd = __to_pcd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
 	if (!pcd)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irqsave(&pcd->lock, flags);
 
 	list_for_each_entry(ce, &pcd->clock_list, node) {
 		if (ce->status == PCE_STATUS_NONE)
@@ -269,7 +271,7 @@ int pm_clk_resume(struct device *dev)
 		}
 	}
 
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irqrestore(&pcd->lock, flags);
 
 	return 0;
 }
@@ -344,6 +346,7 @@ int pm_clk_suspend(struct device *dev)
 {
 	struct pm_clk_data *pcd = __to_pcd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -351,12 +354,12 @@ int pm_clk_suspend(struct device *dev)
 	if (!pcd || !dev->driver)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irqsave(&pcd->lock, flags);
 
 	list_for_each_entry_reverse(ce, &pcd->clock_list, node)
 		clk_disable(ce->clk);
 
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irqrestore(&pcd->lock, flags);
 
 	return 0;
 }
@@ -369,6 +372,7 @@ int pm_clk_resume(struct device *dev)
 {
 	struct pm_clk_data *pcd = __to_pcd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -376,12 +380,12 @@ int pm_clk_resume(struct device *dev)
 	if (!pcd || !dev->driver)
 		return 0;
 
-	mutex_lock(&pcd->lock);
+	spin_lock_irqsave(&pcd->lock, flags);
 
 	list_for_each_entry(ce, &pcd->clock_list, node)
 		clk_enable(ce->clk);
 
-	mutex_unlock(&pcd->lock);
+	spin_unlock_irqrestore(&pcd->lock, flags);
 
 	return 0;
 }

