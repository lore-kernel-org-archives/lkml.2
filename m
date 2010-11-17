Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab0KQObP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:31:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:36746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615Ab0KQObN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:31:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,211,1288594800"; 
   d="scan'208";a="678372935"
Date: Wed, 17 Nov 2010 22:08:28 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: chuanxiao.dong@intel.com, yunpeng.gao@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: spectra: move all init logic into nand_pci_probe
Message-ID: <20101117140828.GA5790@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are some driver initialization logic that
is not part of nand_pci_probe function. This will result in
that part of driver initialization code executing even on
platforms without the corresponding hardware which is always
dangerous.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/staging/spectra/ffsport.c  |   56 ++++++-----
 drivers/staging/spectra/ffsport.h  |    1 +
 drivers/staging/spectra/flash.c    |    4 +-
 drivers/staging/spectra/lld_nand.c |  177 +++++++++++++++++++-----------------
 4 files changed, 127 insertions(+), 111 deletions(-)

diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index 63a9d0a..ae101a2 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -729,34 +729,16 @@ static void create_sysfs_entry(struct device *dev)
 }
 */
 
-static int GLOB_SBD_init(void)
+int register_spectra_ftl()
 {
 	int i;
 
-	/* Set debug output level (0~3) here. 3 is most verbose */
-	printk(KERN_ALERT "Spectra: %s\n", GLOB_version);
-
-	mutex_init(&spectra_lock);
-
-	GLOB_SBD_majornum = register_blkdev(0, GLOB_SBD_NAME);
-	if (GLOB_SBD_majornum <= 0) {
-		printk(KERN_ERR "Unable to get the major %d for Spectra",
-		       GLOB_SBD_majornum);
-		return -EBUSY;
-	}
-
-	if (PASS != GLOB_FTL_Flash_Init()) {
-		printk(KERN_ERR "Spectra: Unable to Initialize Flash Device. "
-		       "Aborting\n");
-		goto out_flash_register;
-	}
-
 	/* create_sysfs_entry(&dev->dev); */
 
 	if (PASS != GLOB_FTL_IdentifyDevice(&IdentifyDeviceData)) {
 		printk(KERN_ERR "Spectra: Unable to Read Flash Device. "
 		       "Aborting\n");
-		goto out_flash_register;
+		return -ENOMEM;
 	} else {
 		nand_dbg_print(NAND_DBG_WARN, "In GLOB_SBD_init: "
 			       "Num blocks=%d, pagesperblock=%d, "
@@ -775,24 +757,46 @@ static int GLOB_SBD_init(void)
 	}
 	printk(KERN_ALERT "Spectra: block table has been found.\n");
 
+	GLOB_SBD_majornum = register_blkdev(0, GLOB_SBD_NAME);
+	if (GLOB_SBD_majornum <= 0) {
+		printk(KERN_ERR "Unable to get the major %d for Spectra",
+		       GLOB_SBD_majornum);
+		goto out_ftl_flash_register;
+	}
+
 	for (i = 0; i < NUM_DEVICES; i++)
 		if (SBD_setup_device(&nand_device[i], i) == -ENOMEM)
-			goto out_ftl_flash_register;
+			goto out_blk_register;
 
 	nand_dbg_print(NAND_DBG_DEBUG,
 		       "Spectra: module loaded with major number %d\n",
 		       GLOB_SBD_majornum);
 
-	return 0;
+	return PASS;
 
+out_blk_register:
+	unregister_blkdev(GLOB_SBD_majornum, GLOB_SBD_NAME);
 out_ftl_flash_register:
 	GLOB_FTL_Cache_Release();
-out_flash_register:
-	GLOB_FTL_Flash_Release();
-	unregister_blkdev(GLOB_SBD_majornum, GLOB_SBD_NAME);
 	printk(KERN_ERR "Spectra: Module load failed.\n");
 
-	return -ENOMEM;
+	return FAIL;
+}
+EXPORT_SYMBOL_GPL(register_spectra_ftl);
+
+static int GLOB_SBD_init(void)
+{
+	/* Set debug output level (0~3) here. 3 is most verbose */
+	printk(KERN_ALERT "Spectra: %s\n", GLOB_version);
+
+	mutex_init(&spectra_lock);
+
+	if (PASS != GLOB_FTL_Flash_Init()) {
+		printk(KERN_ERR "Spectra: Unable to Initialize Flash Device. "
+		       "Aborting\n");
+		return -ENODEV;
+	}
+	return 0;
 }
 
 static void __exit GLOB_SBD_exit(void)
diff --git a/drivers/staging/spectra/ffsport.h b/drivers/staging/spectra/ffsport.h
index 6c5d90c..85c0750 100644
--- a/drivers/staging/spectra/ffsport.h
+++ b/drivers/staging/spectra/ffsport.h
@@ -80,5 +80,6 @@ extern int nand_debug_level;
 extern int GLOB_Calc_Used_Bits(u32 n);
 extern u64 GLOB_u64_Div(u64 addr, u32 divisor);
 extern u64 GLOB_u64_Remainder(u64 addr, u32 divisor_type);
+extern int register_spectra_ftl(void);
 
 #endif /* _FFSPORT_ */
diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
index 4e6e451..fb39c8e 100644
--- a/drivers/staging/spectra/flash.c
+++ b/drivers/staging/spectra/flash.c
@@ -1258,9 +1258,7 @@ int GLOB_FTL_Flash_Init(void)
 
 	g_SBDCmdIndex = 0;
 
-	GLOB_LLD_Flash_Init();
-
-	status = GLOB_LLD_Read_Device_ID();
+	status = GLOB_LLD_Flash_Init();
 
 	return status;
 }
diff --git a/drivers/staging/spectra/lld_nand.c b/drivers/staging/spectra/lld_nand.c
index 0d647a8..2263d3e 100644
--- a/drivers/staging/spectra/lld_nand.c
+++ b/drivers/staging/spectra/lld_nand.c
@@ -2395,14 +2395,94 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	unsigned long csr_base;
 	unsigned long csr_len;
 	struct mrst_nand_info *pndev = &info;
+	u32 int_mask;
 
 	nand_dbg_print(NAND_DBG_WARN, "%s, Line %d, Function: %s\n",
 		       __FILE__, __LINE__, __func__);
 
+	FlashReg = ioremap_nocache(GLOB_HWCTL_REG_BASE,
+			GLOB_HWCTL_REG_SIZE);
+	if (!FlashReg) {
+		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
+		return -ENOMEM;
+	}
+	nand_dbg_print(NAND_DBG_WARN,
+		"Spectra: Remapped reg base address: "
+		"0x%p, len: %d\n",
+		FlashReg, GLOB_HWCTL_REG_SIZE);
+
+	FlashMem = ioremap_nocache(GLOB_HWCTL_MEM_BASE,
+			GLOB_HWCTL_MEM_SIZE);
+	if (!FlashMem) {
+		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
+		iounmap(FlashReg);
+		return -ENOMEM;
+	}
+	nand_dbg_print(NAND_DBG_WARN,
+		"Spectra: Remapped flash base address: "
+		"0x%p, len: %d\n",
+		(void *)FlashMem, GLOB_HWCTL_MEM_SIZE);
+
+	nand_dbg_print(NAND_DBG_DEBUG, "Dump timing register values:"
+			"acc_clks: %d, re_2_we: %d, we_2_re: %d,"
+			"addr_2_data: %d, rdwr_en_lo_cnt: %d, "
+			"rdwr_en_hi_cnt: %d, cs_setup_cnt: %d\n",
+			ioread32(FlashReg + ACC_CLKS),
+			ioread32(FlashReg + RE_2_WE),
+			ioread32(FlashReg + WE_2_RE),
+			ioread32(FlashReg + ADDR_2_DATA),
+			ioread32(FlashReg + RDWR_EN_LO_CNT),
+			ioread32(FlashReg + RDWR_EN_HI_CNT),
+			ioread32(FlashReg + CS_SETUP_CNT));
+
+	NAND_Flash_Reset();
+
+	iowrite32(0, FlashReg + GLOBAL_INT_ENABLE);
+
+#if CMD_DMA
+	info.pcmds_num = 0;
+	info.flash_bank = 0;
+	info.cdma_num = 0;
+	int_mask = (DMA_INTR__DESC_COMP_CHANNEL0 |
+		DMA_INTR__DESC_COMP_CHANNEL1 |
+		DMA_INTR__DESC_COMP_CHANNEL2 |
+		DMA_INTR__DESC_COMP_CHANNEL3 |
+		DMA_INTR__MEMCOPY_DESC_COMP);
+	iowrite32(int_mask, FlashReg + DMA_INTR_EN);
+	iowrite32(0xFFFF, FlashReg + DMA_INTR);
+
+	int_mask = (INTR_STATUS0__ECC_ERR |
+		INTR_STATUS0__PROGRAM_FAIL |
+		INTR_STATUS0__ERASE_FAIL);
+#else
+	int_mask = INTR_STATUS0__DMA_CMD_COMP |
+		INTR_STATUS0__ECC_TRANSACTION_DONE |
+		INTR_STATUS0__ECC_ERR |
+		INTR_STATUS0__PROGRAM_FAIL |
+		INTR_STATUS0__ERASE_FAIL;
+#endif
+	iowrite32(int_mask, FlashReg + INTR_EN0);
+	iowrite32(int_mask, FlashReg + INTR_EN1);
+	iowrite32(int_mask, FlashReg + INTR_EN2);
+	iowrite32(int_mask, FlashReg + INTR_EN3);
+
+	/* Clear all status bits */
+	iowrite32(0xFFFF, FlashReg + INTR_STATUS0);
+	iowrite32(0xFFFF, FlashReg + INTR_STATUS1);
+	iowrite32(0xFFFF, FlashReg + INTR_STATUS2);
+	iowrite32(0xFFFF, FlashReg + INTR_STATUS3);
+
+	iowrite32(0x0F, FlashReg + RB_PIN_ENABLED);
+	iowrite32(CHIP_EN_DONT_CARE__FLAG, FlashReg + CHIP_ENABLE_DONT_CARE);
+
+	/* Should set value for these registers when init */
+	iowrite32(0, FlashReg + TWO_ROW_ADDR_CYCLES);
+	iowrite32(1, FlashReg + ECC_ENABLE);
+	enable_ecc = 1;
 	ret = pci_enable_device(dev);
 	if (ret) {
 		printk(KERN_ERR "Spectra: pci_enable_device failed.\n");
-		return ret;
+		goto failed_req_csr;
 	}
 
 	pci_set_master(dev);
@@ -2461,12 +2541,26 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_drvdata(dev, pndev);
 
+	ret = GLOB_LLD_Read_Device_ID();
+	if (ret) {
+		iounmap(pndev->ioaddr);
+		goto failed_remap_csr;
+	}
+
+	ret = register_spectra_ftl();
+	if (ret) {
+		iounmap(pndev->ioaddr);
+		goto failed_remap_csr;
+	}
+
 	return 0;
 
 failed_remap_csr:
 	pci_release_regions(dev);
 failed_req_csr:
 	pci_disable_device(dev);
+	iounmap(FlashMem);
+	iounmap(FlashReg);
 
 	return ret;
 }
@@ -2498,91 +2592,10 @@ static struct pci_driver nand_pci_driver = {
 int NAND_Flash_Init(void)
 {
 	int retval;
-	u32 int_mask;
 
 	nand_dbg_print(NAND_DBG_TRACE, "%s, Line %d, Function: %s\n",
 		       __FILE__, __LINE__, __func__);
 
-	FlashReg = ioremap_nocache(GLOB_HWCTL_REG_BASE,
-			GLOB_HWCTL_REG_SIZE);
-	if (!FlashReg) {
-		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
-		return -ENOMEM;
-	}
-	nand_dbg_print(NAND_DBG_WARN,
-		"Spectra: Remapped reg base address: "
-		"0x%p, len: %d\n",
-		FlashReg, GLOB_HWCTL_REG_SIZE);
-
-	FlashMem = ioremap_nocache(GLOB_HWCTL_MEM_BASE,
-			GLOB_HWCTL_MEM_SIZE);
-	if (!FlashMem) {
-		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
-		iounmap(FlashReg);
-		return -ENOMEM;
-	}
-	nand_dbg_print(NAND_DBG_WARN,
-		"Spectra: Remapped flash base address: "
-		"0x%p, len: %d\n",
-		(void *)FlashMem, GLOB_HWCTL_MEM_SIZE);
-
-	nand_dbg_print(NAND_DBG_DEBUG, "Dump timing register values:"
-			"acc_clks: %d, re_2_we: %d, we_2_re: %d,"
-			"addr_2_data: %d, rdwr_en_lo_cnt: %d, "
-			"rdwr_en_hi_cnt: %d, cs_setup_cnt: %d\n",
-			ioread32(FlashReg + ACC_CLKS),
-			ioread32(FlashReg + RE_2_WE),
-			ioread32(FlashReg + WE_2_RE),
-			ioread32(FlashReg + ADDR_2_DATA),
-			ioread32(FlashReg + RDWR_EN_LO_CNT),
-			ioread32(FlashReg + RDWR_EN_HI_CNT),
-			ioread32(FlashReg + CS_SETUP_CNT));
-
-	NAND_Flash_Reset();
-
-	iowrite32(0, FlashReg + GLOBAL_INT_ENABLE);
-
-#if CMD_DMA
-	info.pcmds_num = 0;
-	info.flash_bank = 0;
-	info.cdma_num = 0;
-	int_mask = (DMA_INTR__DESC_COMP_CHANNEL0 |
-		DMA_INTR__DESC_COMP_CHANNEL1 |
-		DMA_INTR__DESC_COMP_CHANNEL2 |
-		DMA_INTR__DESC_COMP_CHANNEL3 |
-		DMA_INTR__MEMCOPY_DESC_COMP);
-	iowrite32(int_mask, FlashReg + DMA_INTR_EN);
-	iowrite32(0xFFFF, FlashReg + DMA_INTR);
-
-	int_mask = (INTR_STATUS0__ECC_ERR |
-		INTR_STATUS0__PROGRAM_FAIL |
-		INTR_STATUS0__ERASE_FAIL);
-#else
-	int_mask = INTR_STATUS0__DMA_CMD_COMP |
-		INTR_STATUS0__ECC_TRANSACTION_DONE |
-		INTR_STATUS0__ECC_ERR |
-		INTR_STATUS0__PROGRAM_FAIL |
-		INTR_STATUS0__ERASE_FAIL;
-#endif
-	iowrite32(int_mask, FlashReg + INTR_EN0);
-	iowrite32(int_mask, FlashReg + INTR_EN1);
-	iowrite32(int_mask, FlashReg + INTR_EN2);
-	iowrite32(int_mask, FlashReg + INTR_EN3);
-
-	/* Clear all status bits */
-	iowrite32(0xFFFF, FlashReg + INTR_STATUS0);
-	iowrite32(0xFFFF, FlashReg + INTR_STATUS1);
-	iowrite32(0xFFFF, FlashReg + INTR_STATUS2);
-	iowrite32(0xFFFF, FlashReg + INTR_STATUS3);
-
-	iowrite32(0x0F, FlashReg + RB_PIN_ENABLED);
-	iowrite32(CHIP_EN_DONT_CARE__FLAG, FlashReg + CHIP_ENABLE_DONT_CARE);
-
-	/* Should set value for these registers when init */
-	iowrite32(0, FlashReg + TWO_ROW_ADDR_CYCLES);
-	iowrite32(1, FlashReg + ECC_ENABLE);
-	enable_ecc = 1;
-
 	retval = pci_register_driver(&nand_pci_driver);
 	if (retval)
 		return -ENOMEM;
-- 
1.5.5.1

