Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab1HHIpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:45:31 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:59208 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHIp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:45:28 -0400
X-AuditID: c1b4fb3d-b7c17ae00000262e-5b-4e3fa2264d82
From: Nils Carlson <nils.carlson@ericsson.com>
To: <mchehab@redhat.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nils Carlson <nils.carlson@ericsson.com>
Subject: [PATCH] i7core_edac: scrubbing fixups
Date: Mon, 8 Aug 2011 11:21:26 +0200
Message-ID: <1312795286-16409-1-git-send-email-nils.carlson@ericsson.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get a more reliable DCLK value from DMI, name the SCRUBINTERVAL mask
and guard against potential overflow in the scrub rate computations.

Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
---
 drivers/edac/i7core_edac.c |  141 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 133 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index aeb01f4..31e0be3 100644
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
@@ -107,6 +108,7 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
 
 #define MC_SCRUB_CONTROL	0x4c
   #define STARTSCRUB		(1 << 24)
+  #define SCRUBINTERVAL_MASK    0xffffff
 
 #define MC_COR_ECC_CNT_0	0x80
 #define MC_COR_ECC_CNT_1	0x84
@@ -278,6 +280,9 @@ struct i7core_pvt {
 	/* Count indicator to show errors not got */
 	unsigned		mce_overrun;
 
+	/* DCLK Frequency used for computing scrub rate */
+	int			dclk_freq;
+
 	/* Struct to control EDAC polling */
 	struct edac_pci_ctl_info *i7core_pci;
 };
@@ -1941,6 +1946,112 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
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
 /*
  * set_sdram_scrub_rate		This routine sets byte/sec bandwidth scrub rate
  *				to hardware according to SCRUBINTERVAL formula
@@ -1950,8 +2061,6 @@ static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	struct pci_dev *pdev;
-	const u32 cache_line_size = 64;
-	const u32 freq_dclk = 800*1000000;
 	u32 dw_scrub;
 	u32 dw_ssr;
 
@@ -1966,18 +2075,28 @@ static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
 		/* Prepare to disable petrol scrub */
 		dw_scrub &= ~STARTSCRUB;
 		/* Stop the patrol scrub engine */
-		write_and_test(pdev, MC_SCRUB_CONTROL, dw_scrub & ~0x00ffffff);
+		write_and_test(pdev, MC_SCRUB_CONTROL,
+			       dw_scrub & ~SCRUBINTERVAL_MASK);
 
 		/* Get current status of scrub rate and set bit to disable */
 		pci_read_config_dword(pdev, MC_SSRCONTROL, &dw_ssr);
 		dw_ssr &= ~SSR_MODE_MASK;
 		dw_ssr |= SSR_MODE_DISABLE;
 	} else {
+		const int cache_line_size = 64;
+		const u32 freq_dclk_mhz = pvt->dclk_freq;
+		unsigned long long scrub_interval;
 		/*
 		 * Translate the desired scrub rate to a register value and
-		 * program the cooresponding register value.
+		 * program the corresponding register value.
 		 */
-		dw_scrub = 0x00ffffff & (cache_line_size * freq_dclk / new_bw);
+		scrub_interval = (unsigned long long)freq_dclk_mhz *
+			cache_line_size * 1000000 / new_bw;
+
+		if (!scrub_interval || scrub_interval > SCRUBINTERVAL_MASK)
+			return -EINVAL;
+
+		dw_scrub = SCRUBINTERVAL_MASK & scrub_interval;
 
 		/* Start the patrol scrub engine */
 		pci_write_config_dword(pdev, MC_SCRUB_CONTROL,
@@ -2004,7 +2123,8 @@ static int get_sdram_scrub_rate(struct mem_ctl_info *mci)
 	struct i7core_pvt *pvt = mci->pvt_info;
 	struct pci_dev *pdev;
 	const u32 cache_line_size = 64;
-	const u32 freq_dclk = 800*1000000;
+	const u32 freq_dclk_mhz = pvt->dclk_freq;
+	unsigned long long scrub_rate;
 	u32 scrubval;
 
 	/* Get data from the MC register, function 2 */
@@ -2016,12 +2136,14 @@ static int get_sdram_scrub_rate(struct mem_ctl_info *mci)
 	pci_read_config_dword(pdev, MC_SCRUB_CONTROL, &scrubval);
 
 	/* Mask highest 8-bits to 0 */
-	scrubval &=  0x00ffffff;
+	scrubval &=  SCRUBINTERVAL_MASK;
 	if (!scrubval)
 		return 0;
 
 	/* Calculate scrub rate value into byte/sec bandwidth */
-	return 0xffffffff & (cache_line_size * freq_dclk / (u64) scrubval);
+	scrub_rate =  (unsigned long long)freq_dclk_mhz *
+		1000000 * cache_line_size / scrubval;
+	return (int)scrub_rate;
 }
 
 static void enable_sdram_scrub_setting(struct mem_ctl_info *mci)
@@ -2193,6 +2315,9 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* allocating generic PCI control info */
 	i7core_pci_ctl_create(pvt);
 
+	/* DCLK for scrub rate setting */
+	pvt->dclk_freq = get_dclk_freq();
+
 	/* Registers on edac_mce in order to receive memory errors */
 	pvt->edac_mce.priv = mci;
 	pvt->edac_mce.check_error = i7core_mce_check_error;
-- 
1.7.1

