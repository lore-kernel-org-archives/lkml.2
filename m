Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936Ab2JaN60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:58:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2JaN6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:58:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC EDAC/GHES] edac: lock module owner to avoid error report conflicts
Date: Wed, 31 Oct 2012 11:58:15 -0200
Message-Id: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a know bug that happens when apei/ghes is loaded together
with an EDAC module: the same error is reported several times,
as ghes calls mcelog, with, in tune, calls edac.

On some cases, the error reported is even mangled by ghes, as it
reports both Nehalem and Sandy Bridge errors with the same format
to MCE log. However, the error decoding is different for each.

Fixing it requires some work, making both EDAC and GHES know
each other.

My idea is to make apei/ghes.c to register itself at edac, using
edac_mc_add_mc() call (or something similar to it), and report
errors using a light version of edac_mc_handle_error().

Assuming that ghes got registered at the EDAC core (if CONFIG_EDAC),
then all we need to do at EDAC core is to be sure that there will
be there just one module providing error reports for the system
memory.

The patch below is just the first step for it. On my better
undestanding at the EDAC subsystem, I don't think that there are
any systems where more than one different EDAC module could be
used, as hardware have just one memory controller type. However,
if this is ever used on any weird place, we may need to re-think
about this proposed solution. That's why I'm submitting this
RFC patch in such early stage.

-

APEI GHES and i7core_edac/sb_edac currently can be loaded at
the same time, but those are Highlander modules:
	"There can be only one".

So, we need to add an module owner's lock at the EDAC core,
in order to avoid having two different modules handling memory
errors at the same time.

A change is also needed at apei/ghes.c, in order to register
it as an EDAC module, in order to properly enable such lock.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c       |  2 +-
 drivers/edac/amd76x_edac.c      |  2 +-
 drivers/edac/cell_edac.c        |  2 +-
 drivers/edac/cpc925_edac.c      |  2 +-
 drivers/edac/e752x_edac.c       |  2 +-
 drivers/edac/e7xxx_edac.c       |  2 +-
 drivers/edac/edac_core.h        |  2 +-
 drivers/edac/edac_mc.c          | 30 +++++++++++++++++++++++++-----
 drivers/edac/highbank_mc_edac.c |  2 +-
 drivers/edac/i3000_edac.c       |  2 +-
 drivers/edac/i3200_edac.c       |  2 +-
 drivers/edac/i5000_edac.c       |  2 +-
 drivers/edac/i5100_edac.c       |  2 +-
 drivers/edac/i5400_edac.c       |  2 +-
 drivers/edac/i7300_edac.c       |  2 +-
 drivers/edac/i7core_edac.c      |  2 +-
 drivers/edac/i82443bxgx_edac.c  |  2 +-
 drivers/edac/i82860_edac.c      |  2 +-
 drivers/edac/i82875p_edac.c     |  2 +-
 drivers/edac/i82975x_edac.c     |  2 +-
 drivers/edac/mpc85xx_edac.c     |  2 +-
 drivers/edac/mv64x60_edac.c     |  2 +-
 drivers/edac/pasemi_edac.c      |  2 +-
 drivers/edac/ppc4xx_edac.c      |  2 +-
 drivers/edac/r82600_edac.c      |  2 +-
 drivers/edac/sb_edac.c          |  2 +-
 drivers/edac/tile_edac.c        |  2 +-
 drivers/edac/x38_edac.c         |  2 +-
 28 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5a297a2..6aeb7e1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2601,7 +2601,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		mci->edac_cap = EDAC_FLAG_NONE;
 
 	ret = -ENODEV;
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(1, "failed edac_mc_add_mc()\n");
 		goto err_add_mc;
 	}
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 29eeb68..b4bf72e 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -275,7 +275,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index a1bbd8e..738bd19 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -223,7 +223,7 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 	cell_edac_init_csrows(mci);
 
 	/* Register with EDAC core */
-	rc = edac_mc_add_mc(mci);
+	rc = edac_mc_add_mc(mci, THIS_MODULE);
 	if (rc) {
 		dev_err(&pdev->dev, "failed to register with EDAC core\n");
 		edac_mc_free(mci);
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index c2ef134..6afcc52 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -1016,7 +1016,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	/* Setup memory controller registers */
 	cpc925_mc_init(mci);
 
-	if (edac_mc_add_mc(mci) > 0) {
+	if (edac_mc_add_mc(mci, THIS_MODULE) > 0) {
 		cpc925_mc_printk(mci, KERN_ERR, "Failed edac_mc_add_mc()\n");
 		goto err3;
 	}
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index a5ed6b7..e63cd71 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1358,7 +1358,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 9ff57f3..6bdff5f 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -498,7 +498,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail1;
 	}
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 23bb99f..db30694 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -446,7 +446,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 				   unsigned n_layers,
 				   struct edac_mc_layer *layers,
 				   unsigned sz_pvt);
-extern int edac_mc_add_mc(struct mem_ctl_info *mci);
+extern int edac_mc_add_mc(struct mem_ctl_info *mci, struct module *owner);
 extern void edac_mc_free(struct mem_ctl_info *mci);
 extern struct mem_ctl_info *edac_mc_find(int idx);
 extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 8bb27f2..d4d891a 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -42,6 +42,12 @@
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
 
+/*
+ * Used to lock EDAC MC to just one module, avoiding two drivers e. g.
+ *	apei/ghes and i7core_edac to be used at the same time.
+ */
+static struct module *edac_mc_owner;
+
 unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
 			         unsigned len)
 {
@@ -674,9 +680,9 @@ fail1:
 	return 1;
 }
 
-static void del_mc_from_global_list(struct mem_ctl_info *mci)
+static int del_mc_from_global_list(struct mem_ctl_info *mci)
 {
-	atomic_dec(&edac_handlers);
+	int handlers = atomic_dec_return(&edac_handlers);
 	list_del_rcu(&mci->link);
 
 	/* these are for safe removal of devices from global list while
@@ -684,6 +690,8 @@ static void del_mc_from_global_list(struct mem_ctl_info *mci)
 	 */
 	synchronize_rcu();
 	INIT_LIST_HEAD(&mci->link);
+
+	return handlers;
 }
 
 /**
@@ -725,8 +733,9 @@ EXPORT_SYMBOL(edac_mc_find);
  */
 
 /* FIXME - should a warning be printed if no error detection? correction? */
-int edac_mc_add_mc(struct mem_ctl_info *mci)
+int edac_mc_add_mc(struct mem_ctl_info *mci, struct module *owner)
 {
+	int ret = -EINVAL;
 	edac_dbg(0, "\n");
 
 #ifdef CONFIG_EDAC_DEBUG
@@ -757,6 +766,11 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 #endif
 	mutex_lock(&mem_ctls_mutex);
 
+	if (edac_mc_owner && edac_mc_owner != owner) {
+		ret = -EPERM;
+		goto fail0;
+	}
+
 	if (add_mc_to_global_list(mci))
 		goto fail0;
 
@@ -783,6 +797,8 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to '%s' '%s':"
 		" DEV %s\n", mci->mod_name, mci->ctl_name, edac_dev_name(mci));
 
+	edac_mc_owner = owner;
+
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
@@ -791,7 +807,9 @@ fail1:
 
 fail0:
 	mutex_unlock(&mem_ctls_mutex);
-	return 1;
+	edac_mc_owner = owner;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
 
@@ -817,7 +835,9 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 		return NULL;
 	}
 
-	del_mc_from_global_list(mci);
+	if (!del_mc_from_global_list(mci)) {
+		edac_mc_owner = NULL;
+	}
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* flush workq processes */
diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index c769f47..ac92269 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -219,7 +219,7 @@ static int __devinit highbank_mc_probe(struct platform_device *pdev)
 	dimm->mtype = MEM_DDR3;
 	dimm->edac_mode = EDAC_SECDED;
 
-	res = edac_mc_add_mc(mci);
+	res = edac_mc_add_mc(mci, THIS_MODULE);
 	if (res < 0)
 		goto err;
 
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index d3d19cc..48005a7 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -427,7 +427,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 			 I3000_ERRSTS_BITS);
 
 	rc = -ENODEV;
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index b6653a6..de44881 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -402,7 +402,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	i3200_clear_error_info(mci);
 
 	rc = -ENODEV;
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 6a49dd0..d93d205 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1449,7 +1449,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index c4b5e5f..3df2042 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -989,7 +989,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		break;
 	}
 
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		ret = -ENODEV;
 		goto bail_scrub;
 	}
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 2772469..f77aa37 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1333,7 +1333,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index a09d066..f34c004 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1084,7 +1084,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 3672101..bccd429 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2258,7 +2258,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 		enable_sdram_scrub_setting(mci);
 
 	/* add this new MC control structure to EDAC's list of MCs */
-	if (unlikely(edac_mc_add_mc(mci))) {
+	if (unlikely(edac_mc_add_mc(mci, THIS_MODULE))) {
 		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 90f303d..761418a 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -326,7 +326,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->edac_check = i82443bxgx_edacmc_check;
 	mci->ctl_page_to_phys = NULL;
 
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 1faa749..18772e8 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -227,7 +227,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 3e416b1..f8a4b7f 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -446,7 +446,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail1;
 	}
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 082e91e..5993d5b 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -663,7 +663,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	i82975x_get_error_info(mci, &discard);  /* clear counters */
 
 	/* finalize this instance of memory controller with edac core */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail2;
 	}
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index a1e791e..97f7d1b 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -1063,7 +1063,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	/* clear all error bits */
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, ~0);
 
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto err;
 	}
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 2b315c2..80ba5a6 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -789,7 +789,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	ctl = (ctl & 0xff00ffff) | 0x10000;
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ECC_CNTL, ctl);
 
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto err;
 	}
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 2d35b78..d38c05a 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -255,7 +255,7 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 	 */
 	pasemi_edac_get_error_info(mci);
 
-	if (edac_mc_add_mc(mci))
+	if (edac_mc_add_mc(mci, THIS_MODULE))
 		goto fail;
 
 	/* get this far and it's successful */
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index bf09576..1188071 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1315,7 +1315,7 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	 * and, if necessary, register interrupts.
 	 */
 
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		ppc4xx_edac_mc_printk(KERN_ERR, mci,
 				      "Failed to add instance!\n");
 		status = -ENODEV;
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index f854deb..3515a01 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -327,7 +327,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 9ad2424..c61d281 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1669,7 +1669,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	mci->pdev = &sbridge_dev->pdev[0]->dev;
 
 	/* add this new MC control structure to EDAC's list of MCs */
-	if (unlikely(edac_mc_add_mc(mci))) {
+	if (unlikely(edac_mc_add_mc(mci, THIS_MODULE))) {
 		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		rc = -EINVAL;
 		goto fail0;
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 1e904b7..3f25408 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -176,7 +176,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, mci);
 
 	/* Register with EDAC core */
-	rc = edac_mc_add_mc(mci);
+	rc = edac_mc_add_mc(mci, THIS_MODULE);
 	if (rc) {
 		dev_err(&pdev->dev, "failed to register with EDAC core\n");
 		edac_mc_free(mci);
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 08a9926..dd12aab 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -401,7 +401,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	x38_clear_error_info(mci);
 
 	rc = -ENODEV;
-	if (edac_mc_add_mc(mci)) {
+	if (edac_mc_add_mc(mci, THIS_MODULE)) {
 		edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
-- 
1.7.11.7

