Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2DPUj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab2DPUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [EDAC ABI v13 10/25] mpc85xx_edac: convert sysfs logic to use struct device
Date: Mon, 16 Apr 2012 17:38:34 -0300
Message-Id: <1334608729-30803-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the EDAC core supports struct device, there's no sense on
having any logic at the EDAC core to simulate it. So, instead of adding
such logic there, change the logic at mpc85xx_edac to use it

compile-tested only.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/mpc85xx_edac.c |   93 +++++++++++++++++++++++++-----------------
 1 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 6146ab7..c67cca1 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -49,34 +49,45 @@ static u32 orig_hid1[2];
 
 /************************ MC SYSFS parts ***********************************/
 
-static ssize_t mpc85xx_mc_inject_data_hi_show(struct mem_ctl_info *mci,
+#define to_mci(k) container_of(k, struct mem_ctl_info, dev)
+
+static ssize_t mpc85xx_mc_inject_data_hi_show(struct device *dev,
+					      struct device_attribute *mattr,
 					      char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	return sprintf(data, "0x%08x",
 		       in_be32(pdata->mc_vbase +
 			       MPC85XX_MC_DATA_ERR_INJECT_HI));
 }
 
-static ssize_t mpc85xx_mc_inject_data_lo_show(struct mem_ctl_info *mci,
+static ssize_t mpc85xx_mc_inject_data_lo_show(struct device *dev,
+					      struct device_attribute *mattr,
 					      char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	return sprintf(data, "0x%08x",
 		       in_be32(pdata->mc_vbase +
 			       MPC85XX_MC_DATA_ERR_INJECT_LO));
 }
 
-static ssize_t mpc85xx_mc_inject_ctrl_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mpc85xx_mc_inject_ctrl_show(struct device *dev,
+					   struct device_attribute *mattr,
+					   char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	return sprintf(data, "0x%08x",
 		       in_be32(pdata->mc_vbase + MPC85XX_MC_ECC_ERR_INJECT));
 }
 
-static ssize_t mpc85xx_mc_inject_data_hi_store(struct mem_ctl_info *mci,
+static ssize_t mpc85xx_mc_inject_data_hi_store(struct device *dev,
+					       struct device_attribute *mattr,
 					       const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	if (isdigit(*data)) {
 		out_be32(pdata->mc_vbase + MPC85XX_MC_DATA_ERR_INJECT_HI,
@@ -86,9 +97,11 @@ static ssize_t mpc85xx_mc_inject_data_hi_store(struct mem_ctl_info *mci,
 	return 0;
 }
 
-static ssize_t mpc85xx_mc_inject_data_lo_store(struct mem_ctl_info *mci,
+static ssize_t mpc85xx_mc_inject_data_lo_store(struct device *dev,
+					       struct device_attribute *mattr,
 					       const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	if (isdigit(*data)) {
 		out_be32(pdata->mc_vbase + MPC85XX_MC_DATA_ERR_INJECT_LO,
@@ -98,9 +111,11 @@ static ssize_t mpc85xx_mc_inject_data_lo_store(struct mem_ctl_info *mci,
 	return 0;
 }
 
-static ssize_t mpc85xx_mc_inject_ctrl_store(struct mem_ctl_info *mci,
-					    const char *data, size_t count)
+static ssize_t mpc85xx_mc_inject_ctrl_store(struct device *dev,
+					       struct device_attribute *mattr,
+					       const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	if (isdigit(*data)) {
 		out_be32(pdata->mc_vbase + MPC85XX_MC_ECC_ERR_INJECT,
@@ -110,38 +125,35 @@ static ssize_t mpc85xx_mc_inject_ctrl_store(struct mem_ctl_info *mci,
 	return 0;
 }
 
-static struct mcidev_sysfs_attribute mpc85xx_mc_sysfs_attributes[] = {
-	{
-	 .attr = {
-		  .name = "inject_data_hi",
-		  .mode = (S_IRUGO | S_IWUSR)
-		  },
-	 .show = mpc85xx_mc_inject_data_hi_show,
-	 .store = mpc85xx_mc_inject_data_hi_store},
-	{
-	 .attr = {
-		  .name = "inject_data_lo",
-		  .mode = (S_IRUGO | S_IWUSR)
-		  },
-	 .show = mpc85xx_mc_inject_data_lo_show,
-	 .store = mpc85xx_mc_inject_data_lo_store},
-	{
-	 .attr = {
-		  .name = "inject_ctrl",
-		  .mode = (S_IRUGO | S_IWUSR)
-		  },
-	 .show = mpc85xx_mc_inject_ctrl_show,
-	 .store = mpc85xx_mc_inject_ctrl_store},
+DEVICE_ATTR(inject_data_hi, S_IRUGO | S_IWUSR,
+	    mpc85xx_mc_inject_data_hi_show, mpc85xx_mc_inject_data_hi_store);
+DEVICE_ATTR(inject_data_lo, S_IRUGO | S_IWUSR,
+	    mpc85xx_mc_inject_data_lo_show, mpc85xx_mc_inject_data_lo_store);
+DEVICE_ATTR(inject_ctrl, S_IRUGO | S_IWUSR,
+	    mpc85xx_mc_inject_ctrl_show, mpc85xx_mc_inject_ctrl_store);
 
-	/* End of list */
-	{
-	 .attr = {.name = NULL}
-	 }
-};
+static int mpc85xx_create_sysfs_attributes(struct mem_ctl_info *mci)
+{
+	int rc;
+
+	rc = device_create_file(&mci->dev, &dev_attr_inject_data_hi);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_data_lo);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_ctrl);
+	if (rc < 0)
+		return rc;
 
-static void mpc85xx_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
+	return 0;
+}
+
+static void mpc85xx_remove_sysfs_attributes(struct mem_ctl_info *mci)
 {
-	mci->mc_driver_sysfs_attributes = mpc85xx_mc_sysfs_attributes;
+	device_remove_file(&mci->dev, &dev_attr_inject_data_hi);
+	device_remove_file(&mci->dev, &dev_attr_inject_data_lo);
+	device_remove_file(&mci->dev, &dev_attr_inject_ctrl);
 }
 
 /**************************** PCI Err device ***************************/
@@ -1041,8 +1053,6 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 
 	mci->scrub_mode = SCRUB_SW_SRC;
 
-	mpc85xx_set_mc_sysfs_attributes(mci);
-
 	mpc85xx_init_csrows(mci);
 
 	/* store the original error disable bits */
@@ -1058,6 +1068,12 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		goto err;
 	}
 
+	if (mpc85xx_create_sysfs_attributes(mci)) {
+		edac_mc_del_mc(mci->pdev);
+		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		goto err;
+	}
+
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_INT_EN,
 			 DDR_EIE_MBEE | DDR_EIE_SBEE);
@@ -1117,6 +1133,7 @@ static int mpc85xx_mc_err_remove(struct platform_device *op)
 		 orig_ddr_err_disable);
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_SBE, orig_ddr_err_sbe);
 
+	mpc85xx_remove_sysfs_attributes(mci);
 	edac_mc_del_mc(&op->dev);
 	edac_mc_free(mci);
 	return 0;
-- 
1.7.8

