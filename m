Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1HUTLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 15:11:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab1HUTKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 15:10:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [PATCH 1/2 v2] PM: Change PM subsys_data lock type into spinlock
Date: Sun, 21 Aug 2011 21:10:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201108202131.19479.rjw@sisk.pl> <201108212109.30399.rjw@sisk.pl>
In-Reply-To: <201108212109.30399.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212110.45316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The lock member of struct pm_subsys_data is of type struct mutex,
which is a problem, because the suspend and resume routines
defined in drivers/base/power/clock_ops.c cannot be executed
with interrupts disabled for this reason.  Modify
struct pm_subsys_data so that its lock member is a spinlock.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/clock_ops.c |   35 +++++++++++++++++++++--------------
 drivers/base/power/common.c    |    2 +-
 include/linux/pm.h             |    2 +-
 3 files changed, 23 insertions(+), 16 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -438,7 +438,7 @@ struct pm_domain_data {
 };
 
 struct pm_subsys_data {
-	struct mutex lock;
+	spinlock_t lock;
 	unsigned int refcount;
 #ifdef CONFIG_PM_CLK
 	struct list_head clock_list;
Index: linux/drivers/base/power/clock_ops.c
===================================================================
--- linux.orig/drivers/base/power/clock_ops.c
+++ linux/drivers/base/power/clock_ops.c
@@ -43,6 +43,7 @@ int pm_clk_add(struct device *dev, const
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	if (!psd)
 		return -EINVAL;
@@ -63,9 +64,9 @@ int pm_clk_add(struct device *dev, const
 		}
 	}
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 	list_add_tail(&ce->node, &psd->clock_list);
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 	return 0;
 }
 
@@ -109,11 +110,12 @@ void pm_clk_remove(struct device *dev, c
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	if (!psd)
 		return;
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (!con_id && !ce->con_id) {
@@ -127,7 +129,7 @@ void pm_clk_remove(struct device *dev, c
 		}
 	}
 
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 }
 
 /**
@@ -169,16 +171,17 @@ void pm_clk_destroy(struct device *dev)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce, *c;
+	unsigned long flags;
 
 	if (!psd)
 		return;
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry_safe_reverse(ce, c, &psd->clock_list, node)
 		__pm_clk_remove(ce);
 
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 
 	dev_pm_put_subsys_data(dev);
 }
@@ -212,13 +215,14 @@ int pm_clk_suspend(struct device *dev)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
 	if (!psd)
 		return 0;
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
 		if (ce->status == PCE_STATUS_NONE)
@@ -230,7 +234,7 @@ int pm_clk_suspend(struct device *dev)
 		}
 	}
 
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 
 	return 0;
 }
@@ -243,13 +247,14 @@ int pm_clk_resume(struct device *dev)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
 	if (!psd)
 		return 0;
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (ce->status == PCE_STATUS_NONE)
@@ -261,7 +266,7 @@ int pm_clk_resume(struct device *dev)
 		}
 	}
 
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 
 	return 0;
 }
@@ -336,6 +341,7 @@ int pm_clk_suspend(struct device *dev)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -343,12 +349,12 @@ int pm_clk_suspend(struct device *dev)
 	if (!psd || !dev->driver)
 		return 0;
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry_reverse(ce, &psd->clock_list, node)
 		clk_disable(ce->clk);
 
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 
 	return 0;
 }
@@ -361,6 +367,7 @@ int pm_clk_resume(struct device *dev)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
+	unsigned long flags;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -368,12 +375,12 @@ int pm_clk_resume(struct device *dev)
 	if (!psd || !dev->driver)
 		return 0;
 
-	mutex_lock(&psd->lock);
+	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry(ce, &psd->clock_list, node)
 		clk_enable(ce->clk);
 
-	mutex_unlock(&psd->lock);
+	spin_unlock_irqrestore(&psd->lock, flags);
 
 	return 0;
 }
Index: linux/drivers/base/power/common.c
===================================================================
--- linux.orig/drivers/base/power/common.c
+++ linux/drivers/base/power/common.c
@@ -34,7 +34,7 @@ int dev_pm_get_subsys_data(struct device
 	if (dev->power.subsys_data) {
 		dev->power.subsys_data->refcount++;
 	} else {
-		mutex_init(&psd->lock);
+		spin_lock_init(&psd->lock);
 		psd->refcount = 1;
 		dev->power.subsys_data = psd;
 		pm_clk_init(dev);

