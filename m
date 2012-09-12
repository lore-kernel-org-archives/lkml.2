Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2ILKLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:11:52 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39829 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab2ILKLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:11:50 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 6/8] sta2x11-mfd : use one lock per device instead of one lock per mfd.
Date: Wed, 12 Sep 2012 12:11:17 +0200
Message-Id: <1347444680-31479-7-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347444680-31479-1-git-send-email-ciminaghi@gnudd.com>
References: <1347444680-31479-1-git-send-email-ciminaghi@gnudd.com>
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
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 88bc8d5..2c6f777 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -38,7 +38,7 @@
 /* This describes STA2X11 MFD chip for us, we may have several */
 struct sta2x11_mfd {
 	struct sta2x11_instance *instance;
-	spinlock_t lock;
+	spinlock_t lock[sta2x11_n_mfd_plat_devs];
 	struct list_head list;
 	void __iomem *regs[sta2x11_n_mfd_plat_devs];
 };
@@ -70,6 +70,7 @@ static struct sta2x11_mfd *sta2x11_mfd_find(struct pci_dev *pdev)
 
 static int __devinit sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
 {
+	int i;
 	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
 	struct sta2x11_instance *instance;
 
@@ -82,7 +83,8 @@ static int __devinit sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
 	if (!mfd)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&mfd->list);
-	spin_lock_init(&mfd->lock);
+	for (i = 0; i < ARRAY_SIZE(mfd->lock); i++)
+		spin_lock_init(&mfd->lock[i]);
 	mfd->instance = instance;
 	list_add(&mfd->list, &sta2x11_mfd_list);
 	return 0;
@@ -116,13 +118,13 @@ u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
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
1.7.9.1

