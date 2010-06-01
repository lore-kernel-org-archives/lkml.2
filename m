Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0FAPUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:20:23 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37298 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab0FAPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:20:22 -0400
Date: Tue, 1 Jun 2010 17:20:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: mingo@elte.hu, norsk5@yahoo.com
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Arthur Jones <ajones@riverbed.com>, hpa@zytor.com, tglx@linutronix.de,
       linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: [PATCH 8/8] edac, mc: Improve scrub rate handling
Message-ID: <20100601152036.GA13043@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fortify the interface to not accept negative values, remove
memctrl_int_store() as a result. Also, sanitize bandwidth setting by
making the argument a simple u32 instead of strange u32 pointer being
passed around for no obvious reason. Then, fix error handling and teach
it to return proper error values. Finally, make code more readable,
simplify debug messages.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c    |    6 +-
 drivers/edac/e752x_edac.c    |    4 +-
 drivers/edac/edac_core.h     |    2 +-
 drivers/edac/edac_mc_sysfs.c |   86 ++++++++++++++++++------------------------
 drivers/edac/i5100_edac.c    |    7 +--
 5 files changed, 46 insertions(+), 59 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 71f5ce1..c3b647d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -160,7 +160,7 @@ static int amd64_search_set_scrub_rate(struct pci_dev *ctl, u32 new_bw,
 	return 0;
 }
 
-static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 *bandwidth)
+static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bandwidth)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 min_scrubrate = 0x0;
@@ -180,8 +180,8 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 *bandwidth)
 		amd64_printk(KERN_ERR, "Unsupported family!\n");
 		return -EINVAL;
 	}
-	return amd64_search_set_scrub_rate(pvt->misc_f3_ctl, *bandwidth,
-			min_scrubrate);
+	return amd64_search_set_scrub_rate(pvt->misc_f3_ctl, bandwidth,
+					   min_scrubrate);
 }
 
 static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index ae3f80c..073f5a0 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -958,7 +958,7 @@ static void e752x_check(struct mem_ctl_info *mci)
 }
 
 /* Program byte/sec bandwidth scrub rate to hardware */
-static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *new_bw)
+static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
 {
 	const struct scrubrate *scrubrates;
 	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
@@ -975,7 +975,7 @@ static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *new_bw)
 	 * desired rate and program the cooresponding register value.
 	 */
 	for (i = 0; scrubrates[i].bandwidth != SDRATE_EOT; i++)
-		if (scrubrates[i].bandwidth >= *new_bw)
+		if (scrubrates[i].bandwidth >= new_bw)
 			break;
 
 	if (scrubrates[i].bandwidth == SDRATE_EOT)
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 2efd8f7..f560a9f 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -360,7 +360,7 @@ struct mem_ctl_info {
 	   internal representation and configures whatever else needs
 	   to be configured.
 	 */
-	int (*set_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 * bw);
+	int (*set_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 bw);
 
 	/* Get the current sdram memory scrub rate from the internal
 	   representation and converts it to the closest matching
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 418b65f..21449f0 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -124,19 +124,6 @@ static const char *edac_caps[] = {
 	[EDAC_S16ECD16ED] = "S16ECD16ED"
 };
 
-
-
-static ssize_t memctrl_int_store(void *ptr, const char *buffer, size_t count)
-{
-	int *value = (int *)ptr;
-
-	if (isdigit(*buffer))
-		*value = simple_strtoul(buffer, NULL, 0);
-
-	return count;
-}
-
-
 /* EDAC sysfs CSROW data structures and methods
  */
 
@@ -450,53 +437,54 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 
 /* memory scrubbing */
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					  const char *data, size_t count)
 {
-	u32 bandwidth = -1;
+	unsigned long bandwidth = 0;
+	int err;
 
-	if (mci->set_sdram_scrub_rate) {
+	if (!mci->set_sdram_scrub_rate) {
+		edac_printk(KERN_WARNING, EDAC_MC,
+			    "Memory scrub rate setting not implemented!\n");
+		return -EINVAL;
+	}
 
-		memctrl_int_store(&bandwidth, data, count);
+	if (strict_strtoul(data, 10, &bandwidth) < 0)
+		return -EINVAL;
 
-		if (!(*mci->set_sdram_scrub_rate) (mci, &bandwidth)) {
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate set successfully, applied: %d\n",
-				bandwidth);
-		} else {
-			/* FIXME: error codes maybe? */
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate set FAILED, could not apply: %d\n",
-				bandwidth);
-		}
-	} else {
-		/* FIXME: produce "not implemented" ERROR for user-side. */
-		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'set'control is not implemented!\n");
+	err = mci->set_sdram_scrub_rate(mci, (u32)bandwidth);
+	if (err) {
+		edac_printk(KERN_DEBUG, EDAC_MC,
+			    "Failed setting scrub rate to %lu\n", bandwidth);
+		return -EINVAL;
+	}
+	else {
+		edac_printk(KERN_DEBUG, EDAC_MC,
+			    "Scrub rate set to: %lu\n", bandwidth);
+		return count;
 	}
-	return count;
 }
 
 static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 {
-	u32 bandwidth = -1;
-
-	if (mci->get_sdram_scrub_rate) {
-		if (!(*mci->get_sdram_scrub_rate) (mci, &bandwidth)) {
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate successfully, fetched: %d\n",
-				bandwidth);
-		} else {
-			/* FIXME: error codes maybe? */
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate fetch FAILED, got: %d\n",
-				bandwidth);
-		}
-	} else {
-		/* FIXME: produce "not implemented" ERROR for user-side.  */
+	u32 bandwidth = 0;
+	int err;
+
+	if (!mci->get_sdram_scrub_rate) {
 		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'get' control is not implemented\n");
+			    "Memory scrub rate reading not implemented\n");
+		return -EINVAL;
+	}
+
+	err = mci->get_sdram_scrub_rate(mci, &bandwidth);
+	if (err) {
+		edac_printk(KERN_DEBUG, EDAC_MC, "Error reading scrub rate\n");
+		return err;
+	}
+	else {
+		edac_printk(KERN_DEBUG, EDAC_MC,
+			    "Read scrub rate: %d\n", bandwidth);
+		return sprintf(data, "%d\n", bandwidth);
 	}
-	return sprintf(data, "%d\n", bandwidth);
 }
 
 /* default attribute files for the MCI object */
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index ee9753c..f459a6c 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -589,14 +589,13 @@ static void i5100_refresh_scrubbing(struct work_struct *work)
 /*
  * The bandwidth is based on experimentation, feel free to refine it.
  */
-static int i5100_set_scrub_rate(struct mem_ctl_info *mci,
-				       u32 *bandwidth)
+static int i5100_set_scrub_rate(struct mem_ctl_info *mci, u32 bandwidth)
 {
 	struct i5100_priv *priv = mci->pvt_info;
 	u32 dw;
 
 	pci_read_config_dword(priv->mc, I5100_MC, &dw);
-	if (*bandwidth) {
+	if (bandwidth) {
 		priv->scrub_enable = 1;
 		dw |= I5100_MC_SCRBEN_MASK;
 		schedule_delayed_work(&(priv->i5100_scrubbing),
@@ -610,7 +609,7 @@ static int i5100_set_scrub_rate(struct mem_ctl_info *mci,
 
 	pci_read_config_dword(priv->mc, I5100_MC, &dw);
 
-	*bandwidth = 5900000 * i5100_mc_scrben(dw);
+	bandwidth = 5900000 * i5100_mc_scrben(dw);
 
 	return 0;
 }
-- 
1.7.1
