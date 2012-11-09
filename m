Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2KIOUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:35 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46808 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab2KIOUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:31 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 03/10] drivers/mfd/sta2x11-mfd: add sta2x11_mfd_get_regs_data() function
Date: Fri,  9 Nov 2012 15:19:54 +0100
Message-Id: <1352470801-2418-4-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
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
 2 files changed, 27 insertions(+)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 0cac201..6d12ab4 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -135,6 +135,28 @@ u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
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
 /*
  * Special sta2x11-mfd regmap lock/unlock functions
  */
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 8334430..e813e5e 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -474,4 +474,9 @@ u32 sta2x11_apb_soc_regs_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 #define COMPENSATION_REG3		0x3cc
 #define TEST_CTL_REG			0x3d0
 
+extern int sta2x11_mfd_get_regs_data(struct platform_device *pdev,
+				     enum sta2x11_mfd_plat_dev index,
+				     void __iomem **regs,
+				     spinlock_t **lock);
+
 #endif /* __STA2X11_MFD_H */
-- 
1.7.10.4

