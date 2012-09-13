Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2IML3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:29:44 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:27826
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab2IML3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:29:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12bdh12e5h1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: <linux-edac@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <avorontsov@mvista.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
Date: Thu, 13 Sep 2012 18:55:29 +0800
Message-ID: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handle in case of DDR ECC off is wrong, sysfs entries have not been
created, so edac_mc_free which frees a mci instance should not be called.
Also, free mci's memory in this case.

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/edac/edac_core.h    |    1 +
 drivers/edac/edac_mc.c      |   53 ++++++++++++++++++++++++++++--------------
 drivers/edac/mpc85xx_edac.c |   14 +++++++----
 3 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 23bb99f..108c4e2 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -448,6 +448,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 				   unsigned sz_pvt);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci);
 extern void edac_mc_free(struct mem_ctl_info *mci);
+extern void edac_mc_free_mem(struct mem_ctl_info *mci);
 extern struct mem_ctl_info *edac_mc_find(int idx);
 extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
 extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 616d90b..a2488b2 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -199,6 +199,40 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
 	return (void *)(((unsigned long)ptr) + align - r);
 }
 
+/*
+ * edac_mc_free_mem
+ *	'Free' a previously allocated 'mci' memory
+ * @mci: pointer to a struct mem_ctl_info structure
+ */
+void edac_mc_free_mem(struct mem_ctl_info *mci)
+{
+	int i = 0, tot_dimms, chn, tot_channels;
+	struct csrow_info *csr;
+
+	tot_dimms = mci->tot_dimms;
+	tot_channels = mci->num_cschannel;
+
+	if (mci->dimms) {
+		for (i = 0; i < tot_dimms; i++)
+			kfree(mci->dimms[i]);
+		kfree(mci->dimms);
+	}
+	if (mci->csrows) {
+		for (chn = 0; chn < tot_channels; chn++) {
+			csr = mci->csrows[chn];
+			if (csr) {
+				for (chn = 0; chn < tot_channels; chn++)
+					kfree(csr->channels[chn]);
+				kfree(csr);
+			}
+			kfree(mci->csrows[i]);
+		}
+		kfree(mci->csrows);
+	}
+	kfree(mci);
+}
+EXPORT_SYMBOL_GPL(edac_mc_free_mem);
+
 /**
  * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
  * @mc_num:		Memory controller number
@@ -413,24 +447,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	return mci;
 
 error:
-	if (mci->dimms) {
-		for (i = 0; i < tot_dimms; i++)
-			kfree(mci->dimms[i]);
-		kfree(mci->dimms);
-	}
-	if (mci->csrows) {
-		for (chn = 0; chn < tot_channels; chn++) {
-			csr = mci->csrows[chn];
-			if (csr) {
-				for (chn = 0; chn < tot_channels; chn++)
-					kfree(csr->channels[chn]);
-				kfree(csr);
-			}
-			kfree(mci->csrows[i]);
-		}
-		kfree(mci->csrows);
-	}
-	kfree(mci);
+	edac_mc_free_mem(mci);
 
 	return NULL;
 }
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index a1e791e..402b3f5 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -1012,7 +1012,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	if (res) {
 		printk(KERN_ERR "%s: Unable to get resource for MC err regs\n",
 		       __func__);
-		goto err;
+		goto err1;
 	}
 
 	if (!devm_request_mem_region(&op->dev, r.start, resource_size(&r),
@@ -1020,14 +1020,14 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
-		goto err;
+		goto err1;
 	}
 
 	pdata->mc_vbase = devm_ioremap(&op->dev, r.start, resource_size(&r));
 	if (!pdata->mc_vbase) {
 		printk(KERN_ERR "%s: Unable to setup MC err regs\n", __func__);
 		res = -ENOMEM;
-		goto err;
+		goto err1;
 	}
 
 	sdram_ctl = in_be32(pdata->mc_vbase + MPC85XX_MC_DDR_SDRAM_CFG);
@@ -1035,7 +1035,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		/* no ECC */
 		printk(KERN_WARNING "%s: No ECC DIMMs discovered\n", __func__);
 		res = -ENODEV;
-		goto err;
+		goto err1;
 	}
 
 	edac_dbg(3, "init mci\n");
@@ -1065,7 +1065,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 
 	if (edac_mc_add_mc(mci)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
-		goto err;
+		goto err1;
 	}
 
 	if (mpc85xx_create_sysfs_attributes(mci)) {
@@ -1115,6 +1115,10 @@ err:
 	devres_release_group(&op->dev, mpc85xx_mc_err_probe);
 	edac_mc_free(mci);
 	return res;
+err1:
+	devres_release_group(&op->dev, mpc85xx_mc_err_probe);
+	edac_mc_free_mem(mci);
+	return res;
 }
 
 static int mpc85xx_mc_err_remove(struct platform_device *op)
-- 
1.6.4


