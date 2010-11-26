Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0KZTFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:48 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46360 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0KZTFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:45 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 15/16] EDAC: Fixup scrubrate manipulation
Date: Fri, 26 Nov 2010 20:04:22 +0100
Message-Id: <1290798263-13074-16-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Make the ->{get|set}_sdram_scrub_rate return the actual scrub rate
bandwidth it succeded setting and remove superfluous arg pointer used
for that. A negative value returned still means that an error occurred
while setting the scrubrate. Document this for future reference.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c    |   24 +++++++++---------
 drivers/edac/amd64_edac.h    |    6 ----
 drivers/edac/cpc925_edac.c   |    9 +++---
 drivers/edac/e752x_edac.c    |    8 ++---
 drivers/edac/edac_core.h     |    2 +-
 drivers/edac/edac_mc_sysfs.c |   57 ++++++++++++++++++++---------------------
 drivers/edac/i5100_edac.c    |    9 ++----
 7 files changed, 52 insertions(+), 63 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4dcad97..f19c34e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -77,7 +77,11 @@ static int ddr3_dbam[] = { [0]		= -1,
  *FIXME: Produce a better mapping/linearisation.
  */
 
-struct scrubrate scrubrates[] = {
+
+struct scrubrate {
+       u32 scrubval;           /* bit pattern for scrub rate */
+       u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
+} scrubrates[] = {
 	{ 0x01, 1600000000UL},
 	{ 0x02, 800000000UL},
 	{ 0x03, 400000000UL},
@@ -151,14 +155,12 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 	}
 
 	scrubval = scrubrates[i].scrubval;
-	if (scrubval)
-		amd64_info("Setting scrub rate bandwidth: %u\n",
-			   scrubrates[i].bandwidth);
-	else
-		amd64_info("Turning scrubbing off.\n");
 
 	pci_write_bits32(ctl, K8_SCRCTRL, scrubval, 0x001F);
 
+	if (scrubval)
+		return scrubrates[i].bandwidth;
+
 	return 0;
 }
 
@@ -169,11 +171,11 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 	return __amd64_set_scrub_rate(pvt->F3, bw, pvt->min_scrubrate);
 }
 
-static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
+static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 scrubval = 0;
-	int status = -1, i;
+	int i, retval = -EINVAL;
 
 	amd64_read_pci_cfg(pvt->F3, K8_SCRCTRL, &scrubval);
 
@@ -183,13 +185,11 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 
 	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
 		if (scrubrates[i].scrubval == scrubval) {
-			*bw = scrubrates[i].bandwidth;
-			status = 0;
+			retval = scrubrates[i].bandwidth;
 			break;
 		}
 	}
-
-	return status;
+	return retval;
 }
 
 /* Map from a CSROW entry to the mask entry that operates on it */
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index b76dce9..613ec72 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -482,12 +482,6 @@ struct ecc_settings {
 	} flags;
 };
 
-struct scrubrate {
-       u32 scrubval;           /* bit pattern for scrub rate */
-       u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
-};
-
-extern struct scrubrate scrubrates[23];
 extern const char *tt_msgs[4];
 extern const char *ll_msgs[4];
 extern const char *rrrr_msgs[16];
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 1609a19..b9a781c 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -818,9 +818,10 @@ static void cpc925_del_edac_devices(void)
 }
 
 /* Convert current back-ground scrub rate into byte/sec bandwith */
-static int cpc925_get_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
+static int cpc925_get_sdram_scrub_rate(struct mem_ctl_info *mci)
 {
 	struct cpc925_mc_pdata *pdata = mci->pvt_info;
+	int bw;
 	u32 mscr;
 	u8 si;
 
@@ -832,11 +833,11 @@ static int cpc925_get_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 	if (((mscr & MSCR_SCRUB_MOD_MASK) != MSCR_BACKGR_SCRUB) ||
 	    (si == 0)) {
 		cpc925_mc_printk(mci, KERN_INFO, "Scrub mode not enabled\n");
-		*bw = 0;
+		bw = 0;
 	} else
-		*bw = CPC925_SCRUB_BLOCK_SIZE * 0xFA67 / si;
+		bw = CPC925_SCRUB_BLOCK_SIZE * 0xFA67 / si;
 
-	return 0;
+	return bw;
 }
 
 /* Return 0 for single channel; 1 for dual channel */
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 073f5a0..ec302d4 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -983,11 +983,11 @@ static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
 
 	pci_write_config_word(pdev, E752X_MCHSCRB, scrubrates[i].scrubval);
 
-	return 0;
+	return scrubrates[i].bandwidth;
 }
 
 /* Convert current scrub rate value into byte/sec bandwidth */
-static int get_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
+static int get_sdram_scrub_rate(struct mem_ctl_info *mci)
 {
 	const struct scrubrate *scrubrates;
 	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
@@ -1013,10 +1013,8 @@ static int get_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 			"Invalid sdram scrub control value: 0x%x\n", scrubval);
 		return -1;
 	}
+	return scrubrates[i].bandwidth;
 
-	*bw = scrubrates[i].bandwidth;
-
-	return 0;
 }
 
 /* Return 1 if dual channel mode is active.  Else return 0. */
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 050f9ee..25d8f97 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -387,7 +387,7 @@ struct mem_ctl_info {
 	   representation and converts it to the closest matching
 	   bandwith in bytes/sec.
 	 */
-	int (*get_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 * bw);
+	int (*get_sdram_scrub_rate) (struct mem_ctl_info * mci);
 
 
 	/* pointer to edac checking routine */
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index dce61f7..39d97cf 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -436,56 +436,55 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 	return count;
 }
 
-/* memory scrubbing */
+/* Memory scrubbing interface:
+ *
+ * A MC driver can limit the scrubbing bandwidth based on the CPU type.
+ * Therefore, ->set_sdram_scrub_rate should be made to return the actual
+ * bandwidth that is accepted or 0 when scrubbing is to be disabled.
+ *
+ * Negative value still means that an error has occurred while setting
+ * the scrub rate.
+ */
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 					  const char *data, size_t count)
 {
 	unsigned long bandwidth = 0;
-	int err;
+	int new_bw = 0;
 
-	if (!mci->set_sdram_scrub_rate) {
-		edac_printk(KERN_WARNING, EDAC_MC,
-			    "Memory scrub rate setting not implemented!\n");
+	if (!mci->set_sdram_scrub_rate)
 		return -EINVAL;
-	}
 
 	if (strict_strtoul(data, 10, &bandwidth) < 0)
 		return -EINVAL;
 
-	err = mci->set_sdram_scrub_rate(mci, (u32)bandwidth);
-	if (err) {
-		edac_printk(KERN_DEBUG, EDAC_MC,
-			    "Failed setting scrub rate to %lu\n", bandwidth);
-		return -EINVAL;
-	}
-	else {
-		edac_printk(KERN_DEBUG, EDAC_MC,
-			    "Scrub rate set to: %lu\n", bandwidth);
+	new_bw = mci->set_sdram_scrub_rate(mci, bandwidth);
+	if (new_bw >= 0) {
+		edac_printk(KERN_DEBUG, EDAC_MC, "Scrub rate set to %d\n", new_bw);
 		return count;
 	}
+
+	edac_printk(KERN_DEBUG, EDAC_MC, "Error setting scrub rate to: %lu\n", bandwidth);
+	return -EINVAL;
 }
 
+/*
+ * ->get_sdram_scrub_rate() return value semantics same as above.
+ */
 static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 {
-	u32 bandwidth = 0;
-	int err;
+	int bandwidth = 0;
 
-	if (!mci->get_sdram_scrub_rate) {
-		edac_printk(KERN_WARNING, EDAC_MC,
-			    "Memory scrub rate reading not implemented\n");
+	if (!mci->get_sdram_scrub_rate)
 		return -EINVAL;
-	}
 
-	err = mci->get_sdram_scrub_rate(mci, &bandwidth);
-	if (err) {
+	bandwidth = mci->get_sdram_scrub_rate(mci);
+	if (bandwidth < 0) {
 		edac_printk(KERN_DEBUG, EDAC_MC, "Error reading scrub rate\n");
-		return err;
-	}
-	else {
-		edac_printk(KERN_DEBUG, EDAC_MC,
-			    "Read scrub rate: %d\n", bandwidth);
-		return sprintf(data, "%d\n", bandwidth);
+		return bandwidth;
 	}
+
+	edac_printk(KERN_DEBUG, EDAC_MC, "Read scrub rate: %d\n", bandwidth);
+	return sprintf(data, "%d\n", bandwidth);
 }
 
 /* default attribute files for the MCI object */
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index f459a6c..0448da0 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -611,20 +611,17 @@ static int i5100_set_scrub_rate(struct mem_ctl_info *mci, u32 bandwidth)
 
 	bandwidth = 5900000 * i5100_mc_scrben(dw);
 
-	return 0;
+	return bandwidth;
 }
 
-static int i5100_get_scrub_rate(struct mem_ctl_info *mci,
-				u32 *bandwidth)
+static int i5100_get_scrub_rate(struct mem_ctl_info *mci)
 {
 	struct i5100_priv *priv = mci->pvt_info;
 	u32 dw;
 
 	pci_read_config_dword(priv->mc, I5100_MC, &dw);
 
-	*bandwidth = 5900000 * i5100_mc_scrben(dw);
-
-	return 0;
+	return 5900000 * i5100_mc_scrben(dw);
 }
 
 static struct pci_dev *pci_get_device_func(unsigned vendor,
-- 
1.7.3.1.50.g1e633

