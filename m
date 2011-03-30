Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1C3M5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:57:46 -0400
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:55176 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1C3M5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:57:44 -0400
X-AuditID: c1b4fb39-b7c6dae0000023f2-f4-4d9328c62460
From: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
To: mchehab@redhat.com
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Subject: [PATCH 2/2] i7core_edac: Add scrubbing support
Date: Wed, 30 Mar 2011 15:21:23 +0200
Message-ID: <1301491283-14128-2-git-send-email-samuel.gabrielsson@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
References: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add scrubbing support to i7core_edac, tested on intel Xeon L5638.

Signed-off-by: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
---
 drivers/edac/i7core_edac.c |  126 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 1db6092..3afb187 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -78,6 +78,8 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
 	/* OFFSETS for Device 0 Function 0 */
 
 #define MC_CFG_CONTROL	0x90
+  #define MC_CFG_UNLOCK		0x02
+  #define MC_CFG_LOCK		0x00
 
 	/* OFFSETS for Device 3 Function 0 */
 
@@ -98,6 +100,14 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
   #define DIMM0_COR_ERR(r)			((r) & 0x7fff)
 
 /* OFFSETS for Device 3 Function 2, as inicated on Xeon 5500 datasheet */
+#define MC_SSRCONTROL		0x48
+  #define SSR_MODE_DISABLE	0x00
+  #define SSR_MODE_ENABLE	0x01
+  #define SSR_MODE_MASK		0x03
+
+#define MC_SCRUB_CONTROL	0x4c
+  #define STARTSCRUB		(1 << 24)
+
 #define MC_COR_ECC_CNT_0	0x80
 #define MC_COR_ECC_CNT_1	0x84
 #define MC_COR_ECC_CNT_2	0x88
@@ -1871,6 +1881,116 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 	return 1;
 }
 
+/*
+ * set_sdram_scrub_rate		This routine sets byte/sec bandwidth scrub rate
+ *				to hardware according to SCRUBINTERVAL formula
+ *				found in datasheet.
+ */
+static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+	struct pci_dev *pdev;
+	const u32 cache_line_size = 64;
+	const u32 freq_dclk = 800*1000000;
+	u32 dw_scrub;
+	u32 dw_ssr;
+
+	/* Get data from the MC register, function 2 */
+	pdev = pvt->pci_mcr[2];
+	if (!pdev)
+		return -ENODEV;
+
+	pci_read_config_dword(pdev, MC_SCRUB_CONTROL, &dw_scrub);
+
+	if (new_bw == 0) {
+		/* Prepare to disable petrol scrub */
+		dw_scrub &= ~STARTSCRUB;
+		/* Stop the patrol scrub engine */
+		write_and_test(pdev, MC_SCRUB_CONTROL, dw_scrub & ~0x00ffffff);
+
+		/* Get current status of scrub rate and set bit to disable */
+		pci_read_config_dword(pdev, MC_SSRCONTROL, &dw_ssr);
+		dw_ssr &= ~SSR_MODE_MASK;
+		dw_ssr |= SSR_MODE_DISABLE;
+	} else {
+		/*
+		 * Translate the desired scrub rate to a register value and
+		 * program the cooresponding register value.
+		 */
+		dw_scrub = 0x00ffffff & (cache_line_size * freq_dclk / new_bw);
+
+		/* Start the patrol scrub engine */
+		pci_write_config_dword(pdev, MC_SCRUB_CONTROL,
+				       STARTSCRUB | dw_scrub);
+
+		/* Get current status of scrub rate and set bit to enable */
+		pci_read_config_dword(pdev, MC_SSRCONTROL, &dw_ssr);
+		dw_ssr &= ~SSR_MODE_MASK;
+		dw_ssr |= SSR_MODE_ENABLE;
+	}
+	/* Disable or enable scrubbing */
+	pci_write_config_dword(pdev, MC_SSRCONTROL, dw_ssr);
+
+	return new_bw;
+}
+
+/*
+ * get_sdram_scrub_rate		This routine convert current scrub rate value
+ *				into byte/sec bandwidth accourding to
+ *				SCRUBINTERVAL formula found in datasheet.
+ */
+static int get_sdram_scrub_rate(struct mem_ctl_info *mci)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+	struct pci_dev *pdev;
+	const u32 cache_line_size = 64;
+	const u32 freq_dclk = 800*1000000;
+	u32 scrubval;
+
+	/* Get data from the MC register, function 2 */
+	pdev = pvt->pci_mcr[2];
+	if (!pdev)
+		return -ENODEV;
+
+	/* Get current scrub control data */
+	pci_read_config_dword(pdev, MC_SCRUB_CONTROL, &scrubval);
+
+	/* Mask highest 8-bits to 0 */
+	scrubval &=  0x00ffffff;
+	if (!scrubval)
+		return 0;
+
+	/* Calculate scrub rate value into byte/sec bandwidth */
+	return 0xffffffff & (cache_line_size * freq_dclk / (u64) scrubval);
+}
+
+static void enable_sdram_scrub_setting(struct mem_ctl_info *mci)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+	u32 pci_lock;
+
+	/* Unlock writes to pci registers */
+	pci_read_config_dword(pvt->pci_noncore, MC_CFG_CONTROL, &pci_lock);
+	pci_lock &= ~0x3;
+	pci_write_config_dword(pvt->pci_noncore, MC_CFG_CONTROL,
+			       pci_lock | MC_CFG_UNLOCK);
+
+	mci->set_sdram_scrub_rate = set_sdram_scrub_rate;
+	mci->get_sdram_scrub_rate = get_sdram_scrub_rate;
+}
+
+static void disable_sdram_scrub_setting(struct mem_ctl_info *mci)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+	u32 pci_lock;
+
+	/* Lock writes to pci registers */
+	pci_read_config_dword(pvt->pci_noncore, MC_CFG_CONTROL, &pci_lock);
+	pci_lock &= ~0x3;
+	pci_write_config_dword(pvt->pci_noncore, MC_CFG_CONTROL,
+			       pci_lock | MC_CFG_LOCK);
+}
+
 static void i7core_pci_ctl_create(struct i7core_pvt *pvt)
 {
 	pvt->i7core_pci = edac_pci_create_generic_ctl(
@@ -1909,6 +2029,9 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &i7core_dev->pdev[0]->dev);
 
+	/* Disable scrubrate setting */
+	disable_sdram_scrub_setting(mci);
+
 	/* Disable MCE NMI handler */
 	edac_mce_unregister(&pvt->edac_mce);
 
@@ -1982,6 +2105,9 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = i7core_check_error;
 
+	/* Enable scrubrate setting */
+	enable_sdram_scrub_setting(mci);
+
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
 		debugf0("MC: " __FILE__
-- 
1.7.1

