Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1HEHtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:49:36 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:49571 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab1HEHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:49:33 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 03:49:32 EDT
X-AuditID: c1b4fb3d-b7c17ae00000262e-2f-4e3b9d06dd43
From: Nils Carlson <nils.carlson@ericsson.com>
To: <mchehab@redhat.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Samuel Gabrielsson <samuel.gabrielsson@gmail.com>,
        Nils Carlson <nils.carlson@ericsson.com>
Subject: [PATCH] i7core_edac: Add scrubbing support v2
Date: Fri, 5 Aug 2011 10:09:09 +0200
Message-ID: <1312531750-14933-1-git-send-email-nils.carlson@ericsson.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>

Changes since v1:
Get the DCLK value from DMI, use the datasheet 800Mhz as
a default if a good value can't be found.
Make sure computations can't overflow.

Add scrubbing support for i7core Xeon's.

Signed-off-by: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
---
 drivers/edac/i7core_edac.c |  252 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 252 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index b1f6889..52ada92 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -31,6 +31,7 @@
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/edac.h>
 #include <linux/mmzone.h>
 #include <linux/edac_mce.h>
@@ -78,6 +79,8 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
 	/* OFFSETS for Device 0 Function 0 */
 
 #define MC_CFG_CONTROL	0x90
+  #define MC_CFG_UNLOCK		0x02
+  #define MC_CFG_LOCK		0x00
 
 	/* OFFSETS for Device 3 Function 0 */
 
@@ -98,6 +101,15 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
   #define DIMM0_COR_ERR(r)			((r) & 0x7fff)
 
 /* OFFSETS for Device 3 Function 2, as inicated on Xeon 5500 datasheet */
+#define MC_SSRCONTROL		0x48
+  #define SSR_MODE_DISABLE	0x00
+  #define SSR_MODE_ENABLE	0x01
+  #define SSR_MODE_MASK		0x03
+
+#define MC_SCRUB_CONTROL	0x4c
+  #define STARTSCRUB		(1 << 24)
+  #define SCRUBINTERVAL_MASK     0xffffff
+
 #define MC_COR_ECC_CNT_0	0x80
 #define MC_COR_ECC_CNT_1	0x84
 #define MC_COR_ECC_CNT_2	0x88
@@ -268,6 +280,9 @@ struct i7core_pvt {
 	/* Count indicator to show errors not got */
 	unsigned		mce_overrun;
 
+	/* DCLK Frequency used for computing scrub rate */
+	int			dclk_freq;
+
 	/* Struct to control EDAC polling */
 	struct edac_pci_ctl_info *i7core_pci;
 };
@@ -1871,6 +1886,234 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 	return 1;
 }
 
+struct memdev_dmi_entry {
+	u8 type;
+	u8 length;
+	u16 handle;
+	u16 phys_mem_array_handle;
+	u16 mem_err_info_handle;
+	u16 total_width;
+	u16 data_width;
+	u16 size;
+	u8 form;
+	u8 device_set;
+	u8 device_locator;
+	u8 bank_locator;
+	u8 memory_type;
+	u16 type_detail;
+	u16 speed;
+	u8 manufacturer;
+	u8 serial_number;
+	u8 asset_tag;
+	u8 part_number;
+	u8 attributes;
+	u32 extended_size;
+	u16 conf_mem_clk_speed;
+} __attribute__((__packed__));
+
+
+/*
+ * Decode the DRAM Clock Frequency, be paranoid, make sure that all
+ * memory devices show the same speed, and if they don't then consider
+ * all speeds to be invalid.
+ */
+static void decode_dclk(const struct dmi_header *dh, void *_dclk_freq)
+{
+	int *dclk_freq = _dclk_freq;
+	u16 dmi_mem_clk_speed;
+
+	if (*dclk_freq == -1)
+		return;
+
+	if (dh->type == DMI_ENTRY_MEM_DEVICE) {
+		struct memdev_dmi_entry *memdev_dmi_entry =
+			(struct memdev_dmi_entry *)dh;
+		unsigned long conf_mem_clk_speed_offset =
+			(unsigned long)&memdev_dmi_entry->conf_mem_clk_speed -
+			(unsigned long)&memdev_dmi_entry->type;
+		unsigned long speed_offset =
+			(unsigned long)&memdev_dmi_entry->speed -
+			(unsigned long)&memdev_dmi_entry->type;
+
+		/* Check that a DIMM is present */
+		if (memdev_dmi_entry->size == 0)
+			return;
+
+		/*
+		 * Pick the configured speed if it's available, otherwise
+		 * pick the DIMM speed, or we don't have a speed.
+		 */
+		if (memdev_dmi_entry->length > conf_mem_clk_speed_offset) {
+			dmi_mem_clk_speed =
+				memdev_dmi_entry->conf_mem_clk_speed;
+		} else if (memdev_dmi_entry->length > speed_offset) {
+			dmi_mem_clk_speed = memdev_dmi_entry->speed;
+		} else {
+			*dclk_freq = -1;
+			return;
+		}
+
+		if (*dclk_freq == 0) {
+			/* First pass, speed was 0 */
+			if (dmi_mem_clk_speed > 0) {
+				/* Set speed if a valid speed is read */
+				*dclk_freq = dmi_mem_clk_speed;
+			} else {
+				/* Otherwise we don't have a valid speed */
+				*dclk_freq = -1;
+			}
+		} else if (*dclk_freq > 0 &&
+			   *dclk_freq != dmi_mem_clk_speed) {
+			/*
+			 * If we have a speed, check that all DIMMS are the same
+			 * speed, otherwise set the speed as invalid.
+			 */
+			*dclk_freq = -1;
+		}
+	}
+}
+
+/*
+ * The default DCLK frequency is used as a fallback if we
+ * fail to find anything reliable in the DMI. The value
+ * is taken straight from the datasheet.
+ */
+#define DEFAULT_DCLK_FREQ 800
+
+static int get_dclk_freq(void)
+{
+	int dclk_freq = 0;
+
+	dmi_walk(decode_dclk, (void *)&dclk_freq);
+
+	if (dclk_freq < 1)
+		return DEFAULT_DCLK_FREQ;
+
+	return dclk_freq;
+}
+
+/*
+ * set_sdram_scrub_rate		This routine sets byte/sec bandwidth scrub rate
+ *				to hardware according to SCRUBINTERVAL formula
+ *				found in datasheet.
+ */
+static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+	struct pci_dev *pdev;
+	u32 dw_scrub;
+	u32 dw_ssr;
+
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
+		write_and_test(pdev, MC_SCRUB_CONTROL,
+			       dw_scrub & ~SCRUBINTERVAL_MASK);
+
+		/* Get current status of scrub rate and set bit to disable */
+		pci_read_config_dword(pdev, MC_SSRCONTROL, &dw_ssr);
+		dw_ssr &= ~SSR_MODE_MASK;
+		dw_ssr |= SSR_MODE_DISABLE;
+	} else {
+		const int cache_line_size = 64;
+		const u32 freq_dclk_mhz = pvt->dclk_freq;
+		unsigned long long scrub_interval;
+		/*
+		 * Translate the desired scrub rate to a register value and
+		 * program the corresponding register value.
+		 */
+		scrub_interval = (unsigned long long)freq_dclk_mhz *
+			cache_line_size * 1000000 / new_bw;
+
+		if (!scrub_interval || scrub_interval > SCRUBINTERVAL_MASK)
+			return -EINVAL;
+
+		dw_scrub = SCRUBINTERVAL_MASK & scrub_interval;
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
+	const u32 freq_dclk_mhz = pvt->dclk_freq;
+	unsigned long long scrub_rate;
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
+	scrubval &=  SCRUBINTERVAL_MASK;
+	if (!scrubval)
+		return 0;
+
+	/* Calculate scrub rate value into byte/sec bandwidth */
+	scrub_rate =  (unsigned long long)freq_dclk_mhz *
+		1000000 * cache_line_size / scrubval;
+	return (int)scrub_rate;
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
@@ -1909,6 +2152,9 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &i7core_dev->pdev[0]->dev);
 
+	/* Disable scrubrate setting */
+	disable_sdram_scrub_setting(mci);
+
 	/* Disable MCE NMI handler */
 	edac_mce_unregister(&pvt->edac_mce);
 
@@ -1982,6 +2228,9 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = i7core_check_error;
 
+	/* Enable scrubrate setting */
+	enable_sdram_scrub_setting(mci);
+
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
 		debugf0("MC: " __FILE__
@@ -2005,6 +2254,9 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* allocating generic PCI control info */
 	i7core_pci_ctl_create(pvt);
 
+	/* DCLK for scrub rate setting */
+	pvt->dclk_freq = get_dclk_freq();
+
 	/* Registers on edac_mce in order to receive memory errors */
 	pvt->edac_mce.priv = mci;
 	pvt->edac_mce.check_error = i7core_mce_check_error;
-- 
1.6.0.2

