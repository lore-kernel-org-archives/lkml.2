Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2KIOUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:44 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46835 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab2KIOUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:41 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 07/10] drivers/mfd/sta2x11-mfd: use one lock per device instead of one lock per mfd
Date: Fri,  9 Nov 2012 15:19:58 +0100
Message-Id: <1352470801-2418-8-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The lock is used to implement atomic operations on each platform
device's registers, so it looks reasonable having one lock per
device instead of one common lock for all the devices belonging
to the same sta2x11 instance.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 2c8d65e..da65839 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -46,7 +46,7 @@ static inline int __reg_within_range(unsigned int r,
 struct sta2x11_mfd {
 	struct sta2x11_instance *instance;
 	struct regmap *regmap[sta2x11_n_mfd_plat_devs];
-	spinlock_t lock;
+	spinlock_t lock[sta2x11_n_mfd_plat_devs];
 	struct list_head list;
 	void __iomem *regs[sta2x11_n_mfd_plat_devs];
 };
@@ -78,6 +78,7 @@ static struct sta2x11_mfd *sta2x11_mfd_find(struct pci_dev *pdev)
 
 static int __devinit sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
 {
+	int i;
 	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
 	struct sta2x11_instance *instance;
 
@@ -90,7 +91,8 @@ static int __devinit sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
 	if (!mfd)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&mfd->list);
-	spin_lock_init(&mfd->lock);
+	for (i = 0; i < ARRAY_SIZE(mfd->lock); i++)
+		spin_lock_init(&mfd->lock[i]);
 	mfd->instance = instance;
 	list_add(&mfd->list, &sta2x11_mfd_list);
 	return 0;
@@ -124,13 +126,13 @@ u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
 		dev_warn(&pdev->dev, ": system ctl not initialized\n");
 		return 0;
 	}
-	spin_lock_irqsave(&mfd->lock, flags);
+	spin_lock_irqsave(&mfd->lock[index], flags);
 	r = readl(regs + reg);
 	r &= ~mask;
 	r |= val;
 	if (mask)
 		writel(r, regs + reg);
-	spin_unlock_irqrestore(&mfd->lock, flags);
+	spin_unlock_irqrestore(&mfd->lock[index], flags);
 	return r;
 }
 EXPORT_SYMBOL(__sta2x11_mfd_mask);
-- 
1.7.10.4

