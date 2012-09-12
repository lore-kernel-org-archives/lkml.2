Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2ILKXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:23:30 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:49717 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab2ILKXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:23:21 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 2/8] sta2x11-mfd : add sta2x11_mfd_get_regs_data() function
Date: Wed, 12 Sep 2012 12:22:48 +0200
Message-Id: <1347445374-32140-3-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

A couple of predefined clocks (mux and gated) need to be
initialized with the virtual address of the clock's controlling
register and the address of a spinlock used to protect against
races.
This function exports such data for all the mfd cells.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c       |   22 ++++++++++++++++++++++
 include/linux/mfd/sta2x11-mfd.h |    5 +++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 5fbd044..905b184 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -127,6 +127,28 @@ u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
 }
 EXPORT_SYMBOL(__sta2x11_mfd_mask);
 
+int sta2x11_mfd_get_regs_data(struct platform_device *dev,
+			      enum sta2x11_mfd_plat_dev index,
+			      void __iomem **regs,
+			      spinlock_t **lock)
+{
+	struct pci_dev *pdev = *(struct pci_dev **)(dev->dev.platform_data);
+	struct sta2x11_mfd *mfd;
+
+	if (!pdev)
+		return -ENODEV;
+	mfd = sta2x11_mfd_find(pdev);
+	if (!mfd)
+		return -ENODEV;
+	if (index >= sta2x11_n_mfd_plat_devs)
+		return -ENODEV;
+	*regs = mfd->regs[index];
+	*lock = &mfd->lock[index];
+	pr_debug("%s %d *regs = %p\n", __func__, __LINE__, *regs);
+	return *regs ? 0 : -ENODEV;
+}
+EXPORT_SYMBOL(sta2x11_mfd_get_regs_data);
+
 /* Two debugfs files, for our registers (FIXME: one instance only) */
 #define REG(regname) {.name = #regname, .offset = SCTL_ ## regname}
 static struct debugfs_reg32 sta2x11_sctl_regs[] = {
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 4d85879..9ba6127 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -473,4 +473,9 @@ u32 sta2x11_apb_soc_regs_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 #define COMPENSATION_REG3		0x3cc
 #define TEST_CTL_REG			0x3d0
 
+extern int sta2x11_mfd_get_regs_data(struct platform_device *pdev,
+				     enum sta2x11_mfd_plat_dev index,
+				     void __iomem **regs,
+				     spinlock_t **lock);
+
 #endif /* __STA2X11_MFD_H */
-- 
1.7.9.1

