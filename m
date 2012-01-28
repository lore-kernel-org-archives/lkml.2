Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2A1Pd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab2A1Pc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 11/16] edac: move dimm properties to struct dimm_info
Date: Sat, 28 Jan 2012 13:32:46 -0200
Message-Id: <1327764771-28649-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While inside a csrow, the properties should be equal, some
memory controllers aren't able to access csrows, as they're
ridden by other chips.

So, we need to get rid of the per-csrow data. The first
step is to move grain, mtype, dtype and edac_mode to the
per-dimm struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |   30 +++++++++++-------
 drivers/edac/amd76x_edac.c     |   10 ++++--
 drivers/edac/cell_edac.c       |   10 +++++-
 drivers/edac/cpc925_edac.c     |   62 ++++++++++++++++++++-----------------
 drivers/edac/e752x_edac.c      |   44 ++++++++++++++------------
 drivers/edac/e7xxx_edac.c      |   44 +++++++++++++++-----------
 drivers/edac/edac_mc.c         |   66 ++++++++++++++++++----------------------
 drivers/edac/edac_mc_sysfs.c   |    6 ++--
 drivers/edac/i3000_edac.c      |   18 ++++++-----
 drivers/edac/i3200_edac.c      |   18 ++++++-----
 drivers/edac/i5000_edac.c      |   24 +++++++--------
 drivers/edac/i5100_edac.c      |   16 +++-------
 drivers/edac/i5400_edac.c      |    9 ++---
 drivers/edac/i7300_edac.c      |   19 ++++++-----
 drivers/edac/i7core_edac.c     |   18 +++++-----
 drivers/edac/i82443bxgx_edac.c |   13 +++++---
 drivers/edac/i82860_edac.c     |   11 ++++--
 drivers/edac/i82875p_edac.c    |   17 +++++++---
 drivers/edac/i82975x_edac.c    |   10 ++++--
 drivers/edac/mpc85xx_edac.c    |   13 +++++---
 drivers/edac/mv64x60_edac.c    |   18 ++++++-----
 drivers/edac/pasemi_edac.c     |   10 ++++--
 drivers/edac/ppc4xx_edac.c     |   13 +++++---
 drivers/edac/r82600_edac.c     |   10 ++++--
 drivers/edac/sb_edac.c         |   18 +++++-----
 drivers/edac/tile_edac.c       |   13 ++++----
 drivers/edac/x38_edac.c        |   17 +++++-----
 include/linux/edac.h           |   21 ++++++++-----
 28 files changed, 315 insertions(+), 263 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c9eee6d..3e7bddc 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2168,7 +2168,9 @@ static int init_csrows(struct mem_ctl_info *mci)
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 input_addr_min, input_addr_max, sys_addr, base, mask;
 	u32 val;
-	int i, empty = 1;
+	int i, j, empty = 1;
+	enum mem_type mtype;
+	enum edac_type edac_mode;
 
 	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
 
@@ -2202,7 +2204,21 @@ static int init_csrows(struct mem_ctl_info *mci)
 		csrow->page_mask = ~mask;
 		/* 8 bytes of resolution */
 
-		csrow->mtype = amd64_determine_memory_type(pvt, i);
+		mtype = amd64_determine_memory_type(pvt, i);
+
+		/*
+		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
+		 */
+		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
+			edac_mode = (pvt->nbcfg & NBCFG_CHIPKILL) ?
+				    EDAC_S4ECD4ED : EDAC_SECDED;
+		else
+			edac_mode = EDAC_NONE;
+
+		for (j = 0; j < pvt->channel_count; j++) {
+			csrow->channels[j].dimm->mtype = mtype;
+			csrow->channels[j].dimm->edac_mode = edac_mode;
+		}
 
 		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
 		debugf1("    input_addr_min: 0x%lx input_addr_max: 0x%lx\n",
@@ -2214,16 +2230,6 @@ static int init_csrows(struct mem_ctl_info *mci)
 			"last_page: 0x%lx\n",
 			(unsigned)csrow->nr_pages,
 			csrow->first_page, csrow->last_page);
-
-		/*
-		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
-		 */
-		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
-			csrow->edac_mode =
-			    (pvt->nbcfg & NBCFG_CHIPKILL) ?
-			    EDAC_S4ECD4ED : EDAC_SECDED;
-		else
-			csrow->edac_mode = EDAC_NONE;
 	}
 
 	return empty;
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index e47e73b..2a63ed0 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -186,11 +186,13 @@ static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			enum edac_type edac_mode)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	u32 mba, mba_base, mba_mask, dms;
 	int index;
 
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
+		dimm = csrow->channels[0].dimm;
 
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_dword(pdev,
@@ -206,10 +208,10 @@ static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		csrow->nr_pages = (mba_mask + 1) >> PAGE_SHIFT;
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 		csrow->page_mask = mba_mask >> PAGE_SHIFT;
-		csrow->grain = csrow->nr_pages << PAGE_SHIFT;
-		csrow->mtype = MEM_RDDR;
-		csrow->dtype = ((dms >> index) & 0x1) ? DEV_X4 : DEV_UNKNOWN;
-		csrow->edac_mode = edac_mode;
+		dimm->grain = csrow->nr_pages << PAGE_SHIFT;
+		dimm->mtype = MEM_RDDR;
+		dimm->dtype = ((dms >> index) & 0x1) ? DEV_X4 : DEV_UNKNOWN;
+		dimm->edac_mode = edac_mode;
 	}
 }
 
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 9a6a274..94fbb12 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -124,8 +124,10 @@ static void cell_edac_check(struct mem_ctl_info *mci)
 static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 {
 	struct csrow_info		*csrow = &mci->csrows[0];
+	struct dimm_info		*dimm;
 	struct cell_edac_priv		*priv = mci->pvt_info;
 	struct device_node		*np;
+	int				j;
 
 	for (np = NULL;
 	     (np = of_find_node_by_name(np, "memory")) != NULL;) {
@@ -142,8 +144,12 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 		csrow->first_page = r.start >> PAGE_SHIFT;
 		csrow->nr_pages = resource_size(&r) >> PAGE_SHIFT;
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
-		csrow->mtype = MEM_XDR;
-		csrow->edac_mode = EDAC_SECDED;
+
+		for (j = 0; j < csrow->nr_channels; j++) {
+			dimm = csrow->channels[j].dimm;
+			dimm->mtype = MEM_XDR;
+			dimm->edac_mode = EDAC_SECDED;
+		}
 		dev_dbg(mci->dev,
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index a774c0d..ee90f3d 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -329,7 +329,8 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 {
 	struct cpc925_mc_pdata *pdata = mci->pvt_info;
 	struct csrow_info *csrow;
-	int index;
+	struct dimm_info *dimm;
+	int index, j;
 	u32 mbmr, mbbar, bba;
 	unsigned long row_size, last_nr_pages = 0;
 
@@ -354,32 +355,35 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 		last_nr_pages = csrow->last_page + 1;
 
-		csrow->mtype = MEM_RDDR;
-		csrow->edac_mode = EDAC_SECDED;
-
-		switch (csrow->nr_channels) {
-		case 1: /* Single channel */
-			csrow->grain = 32; /* four-beat burst of 32 bytes */
-			break;
-		case 2: /* Dual channel */
-		default:
-			csrow->grain = 64; /* four-beat burst of 64 bytes */
-			break;
-		}
-
-		switch ((mbmr & MBMR_MODE_MASK) >> MBMR_MODE_SHIFT) {
-		case 6: /* 0110, no way to differentiate X8 VS X16 */
-		case 5:	/* 0101 */
-		case 8: /* 1000 */
-			csrow->dtype = DEV_X16;
-			break;
-		case 7: /* 0111 */
-		case 9: /* 1001 */
-			csrow->dtype = DEV_X8;
-			break;
-		default:
-			csrow->dtype = DEV_UNKNOWN;
-			break;
+		for (j = 0; j < csrow->nr_channels; j++) {
+			dimm = csrow->channels[j].dimm;
+			dimm->mtype = MEM_RDDR;
+			dimm->edac_mode = EDAC_SECDED;
+
+			switch (csrow->nr_channels) {
+			case 1: /* Single channel */
+				dimm->grain = 32; /* four-beat burst of 32 bytes */
+				break;
+			case 2: /* Dual channel */
+			default:
+				dimm->grain = 64; /* four-beat burst of 64 bytes */
+				break;
+			}
+
+			switch ((mbmr & MBMR_MODE_MASK) >> MBMR_MODE_SHIFT) {
+			case 6: /* 0110, no way to differentiate X8 VS X16 */
+			case 5:	/* 0101 */
+			case 8: /* 1000 */
+				dimm->dtype = DEV_X16;
+				break;
+			case 7: /* 0111 */
+			case 9: /* 1001 */
+				dimm->dtype = DEV_X8;
+				break;
+			default:
+				dimm->dtype = DEV_UNKNOWN;
+				break;
+			}
 		}
 	}
 }
@@ -962,9 +966,9 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	nr_channels = cpc925_mc_get_channels(vbase);
+	nr_channels = cpc925_mc_get_channels(vbase) + 1;
 	mci = edac_mc_alloc(sizeof(struct cpc925_mc_pdata),
-			CPC925_NR_CSROWS, nr_channels + 1, edac_mc_idx);
+			CPC925_NR_CSROWS, nr_channels, edac_mc_idx);
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
 		res = -ENOMEM;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 1af531a..db291ea 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1044,7 +1044,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	int drc_drbg;		/* DRB granularity 0=64mb, 1=128mb */
 	int drc_ddim;		/* DRAM Data Integrity Mode 0=none, 2=edac */
 	u8 value;
-	u32 dra, drc, cumul_size;
+	u32 dra, drc, cumul_size, i;
 
 	dra = 0;
 	for (index = 0; index < 4; index++) {
@@ -1053,7 +1053,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		dra |= dra_reg << (index * 8);
 	}
 	pci_read_config_dword(pdev, E752X_DRC, &drc);
-	drc_chan = dual_channel_active(ddrcsr);
+	drc_chan = dual_channel_active(ddrcsr) ? 1 : 0;
 	drc_drbg = drc_chan + 1;	/* 128 in dual mode, 64 in single */
 	drc_ddim = (drc >> 20) & 0x3;
 
@@ -1080,24 +1080,28 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
-		csrow->mtype = MEM_RDDR;	/* only one type supported */
-		csrow->dtype = mem_dev ? DEV_X4 : DEV_X8;
-
-		/*
-		 * if single channel or x8 devices then SECDED
-		 * if dual channel and x4 then S4ECD4ED
-		 */
-		if (drc_ddim) {
-			if (drc_chan && mem_dev) {
-				csrow->edac_mode = EDAC_S4ECD4ED;
-				mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
-			} else {
-				csrow->edac_mode = EDAC_SECDED;
-				mci->edac_cap |= EDAC_FLAG_SECDED;
-			}
-		} else
-			csrow->edac_mode = EDAC_NONE;
+
+		for (i = 0; i < drc_chan + 1; i++) {
+			struct dimm_info *dimm = csrow->channels[i].dimm;
+			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
+			dimm->mtype = MEM_RDDR;	/* only one type supported */
+			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
+
+			/*
+			* if single channel or x8 devices then SECDED
+			* if dual channel and x4 then S4ECD4ED
+			*/
+			if (drc_ddim) {
+				if (drc_chan && mem_dev) {
+					dimm->edac_mode = EDAC_S4ECD4ED;
+					mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
+				} else {
+					dimm->edac_mode = EDAC_SECDED;
+					mci->edac_cap |= EDAC_FLAG_SECDED;
+				}
+			} else
+				dimm->edac_mode = EDAC_NONE;
+		}
 	}
 }
 
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 6ffb6d2..178d2af 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -347,11 +347,12 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			int dev_idx, u32 drc)
 {
 	unsigned long last_cumul_size;
-	int index;
+	int index, j;
 	u8 value;
 	u32 dra, cumul_size;
 	int drc_chan, drc_drbg, drc_ddim, mem_dev;
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 
 	pci_read_config_dword(pdev, E7XXX_DRA, &dra);
 	drc_chan = dual_channel_active(drc, dev_idx);
@@ -381,24 +382,29 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
-		csrow->mtype = MEM_RDDR;	/* only one type supported */
-		csrow->dtype = mem_dev ? DEV_X4 : DEV_X8;
-
-		/*
-		 * if single channel or x8 devices then SECDED
-		 * if dual channel and x4 then S4ECD4ED
-		 */
-		if (drc_ddim) {
-			if (drc_chan && mem_dev) {
-				csrow->edac_mode = EDAC_S4ECD4ED;
-				mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
-			} else {
-				csrow->edac_mode = EDAC_SECDED;
-				mci->edac_cap |= EDAC_FLAG_SECDED;
-			}
-		} else
-			csrow->edac_mode = EDAC_NONE;
+
+		for (j = 0; j < drc_chan + 1; j++) {
+			dimm = csrow->channels[j].dimm;
+
+			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
+			dimm->mtype = MEM_RDDR;	/* only one type supported */
+			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
+
+			/*
+			* if single channel or x8 devices then SECDED
+			* if dual channel and x4 then S4ECD4ED
+			*/
+			if (drc_ddim) {
+				if (drc_chan && mem_dev) {
+					dimm->edac_mode = EDAC_S4ECD4ED;
+					mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
+				} else {
+					dimm->edac_mode = EDAC_SECDED;
+					mci->edac_cap |= EDAC_FLAG_SECDED;
+				}
+			} else
+				dimm->edac_mode = EDAC_NONE;
+		}
 	}
 }
 
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 37dca79..3ceddae 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -47,8 +47,7 @@ static void edac_mc_dump_channel(struct csrow_channel_info *chan)
 {
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
-	debugf4("\tchannel->ce_count = %d\n", chan->ce_count);
-	if (chan->dimm)
+	debugf4("\tchannel->ce_count = %d\n", chan->dimm->ce_count);
 		debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
 }
@@ -707,6 +706,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 {
 	unsigned long remapped_page;
 	char detail[80], *label = NULL;
+	u32 grain;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -733,15 +733,15 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	if (mci->csrows[row].channels[channel].dimm)
-		label = mci->csrows[row].channels[channel].dimm->label;
+	label = mci->csrows[row].channels[channel].dimm->label;
+	grain = mci->csrows[row].channels[channel].dimm->grain;
 
 	/* Memory type dependent details about the error */
 	snprintf(detail, sizeof(detail),
 		 " (page 0x%lx, offset 0x%lx, grain %d, "
 		 "syndrome 0x%lx, row %d, channel %d)\n",
 		 page_frame_number, offset_in_page,
-		 mci->csrows[row].grain, syndrome, row, channel);
+		 grain, syndrome, row, channel);
 	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
 		       label, msg, detail);
 
@@ -751,11 +751,12 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
 			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
 			page_frame_number, offset_in_page,
-			mci->csrows[row].grain, syndrome, row, channel,
+			grain, syndrome, row, channel,
 			label, msg);
 
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
+	mci->csrows[row].channels[channel].dimm->ce_count++;
 	mci->csrows[row].channels[channel].ce_count++;
 
 	if (mci->scrub_mode & SCRUB_SW_SRC) {
@@ -772,8 +773,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 			mci->ctl_page_to_phys(mci, page_frame_number) :
 			page_frame_number;
 
-		edac_mc_scrub_block(remapped_page, offset_in_page,
-				mci->csrows[row].grain);
+		edac_mc_scrub_block(remapped_page, offset_in_page, grain);
 	}
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
@@ -801,6 +801,7 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 	int chan;
 	int chars;
 	char detail[80], *label = NULL;
+	u32 grain;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -816,28 +817,24 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 		return;
 	}
 
-	if (mci->csrows[row].channels[0].dimm) {
-		label = mci->csrows[row].channels[0].dimm->label;
-		chars = snprintf(pos, len + 1, "%s", label);
-		len -= chars;
-		pos += chars;
-	}
+	grain = mci->csrows[row].channels[0].dimm->grain;
+	label = mci->csrows[row].channels[0].dimm->label;
+	chars = snprintf(pos, len + 1, "%s", label);
+	len -= chars;
+	pos += chars;
 
 	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
 		chan++) {
-		if (mci->csrows[row].channels[chan].dimm) {
-			label = mci->csrows[row].channels[chan].dimm->label;
-			chars = snprintf(pos, len + 1, ":%s", label);
-			len -= chars;
-			pos += chars;
-		}
+		label = mci->csrows[row].channels[chan].dimm->label;
+		chars = snprintf(pos, len + 1, ":%s", label);
+		len -= chars;
+		pos += chars;
 	}
 
 	/* Memory type dependent details about the error */
 	snprintf(detail, sizeof(detail),
 		 "page 0x%lx, offset 0x%lx, grain %d, row %d ",
-		 page_frame_number, offset_in_page,
-	         mci->csrows[row].grain, row);
+		 page_frame_number, offset_in_page, grain, row);
 	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
 		       labels,
 		       msg, detail);
@@ -846,14 +843,13 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
 			"labels \"%s\": %s\n", page_frame_number,
-			offset_in_page, mci->csrows[row].grain, row,
-			labels, msg);
+			offset_in_page, grain, row, labels, msg);
 
 	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
 			"row %d, labels \"%s\": %s\n", mci->mc_idx,
 			page_frame_number, offset_in_page,
-			mci->csrows[row].grain, row, labels, msg);
+			grain, row, labels, msg);
 
 	mci->ue_count++;
 	mci->csrows[row].ue_count++;
@@ -930,15 +926,13 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	mci->csrows[csrow].ue_count++;
 
 	/* Generate the DIMM labels from the specified channels */
-	if (mci->csrows[csrow].channels[channela].dimm) {
-		label = mci->csrows[csrow].channels[channela].dimm->label;
-		chars = snprintf(pos, len + 1, "%s", label);
-		len -= chars;
-		pos += chars;
-	}
-	if (mci->csrows[csrow].channels[channela].dimm)
-		chars = snprintf(pos, len + 1, "-%s",
-				mci->csrows[csrow].channels[channelb].dimm->label);
+	label = mci->csrows[csrow].channels[channela].dimm->label;
+	chars = snprintf(pos, len + 1, "%s", label);
+	len -= chars;
+	pos += chars;
+
+	chars = snprintf(pos, len + 1, "-%s",
+			mci->csrows[csrow].channels[channelb].dimm->label);
 
 	/* Memory type dependent details about the error */
 	snprintf(detail, sizeof(detail),
@@ -995,8 +989,7 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 		 "(row %d, channel %d)\n",
 		 csrow, channel);
 
-	if (mci->csrows[csrow].channels[channel].dimm)
-		label = mci->csrows[csrow].channels[channel].dimm->label;
+	label = mci->csrows[csrow].channels[channel].dimm->label;
 
 	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
 		       label, msg, detail);
@@ -1009,6 +1002,7 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 
 	mci->ce_count++;
 	mci->csrows[csrow].ce_count++;
+	mci->csrows[csrow].channels[channel].dimm->ce_count++;
 	mci->csrows[csrow].channels[channel].ce_count++;
 }
 EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 54b24cb..1571d99 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -150,19 +150,19 @@ static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
 static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%s\n", mem_types[csrow->mtype]);
+	return sprintf(data, "%s\n", mem_types[csrow->channels[0].dimm->mtype]);
 }
 
 static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%s\n", dev_types[csrow->dtype]);
+	return sprintf(data, "%s\n", dev_types[csrow->channels[0].dimm->dtype]);
 }
 
 static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%s\n", edac_caps[csrow->edac_mode]);
+	return sprintf(data, "%s\n", edac_caps[csrow->channels[0].dimm->edac_mode]);
 }
 
 /* show/store functions for DIMM Label attributes */
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index c0510b3..1498c5f 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -304,7 +304,7 @@ static int i3000_is_interleaved(const unsigned char *c0dra,
 static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc;
-	int i;
+	int i, j;
 	struct mem_ctl_info *mci = NULL;
 	unsigned long last_cumul_size;
 	int interleaved, nr_channels;
@@ -386,19 +386,21 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 			cumul_size <<= 1;
 		debugf3("MC: %s(): (%d) cumul_size 0x%x\n",
 			__func__, i, cumul_size);
-		if (cumul_size == last_cumul_size) {
-			csrow->mtype = MEM_EMPTY;
+		if (cumul_size == last_cumul_size)
 			continue;
-		}
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = I3000_DEAP_GRAIN;
-		csrow->mtype = MEM_DDR2;
-		csrow->dtype = DEV_UNKNOWN;
-		csrow->edac_mode = EDAC_UNKNOWN;
+
+		for (j = 0; j < nr_channels; j++) {
+			struct dimm_info *dimm = csrow->channels[j].dimm;
+			dimm->grain = I3000_DEAP_GRAIN;
+			dimm->mtype = MEM_DDR2;
+			dimm->dtype = DEV_UNKNOWN;
+			dimm->edac_mode = EDAC_UNKNOWN;
+		}
 	}
 
 	/*
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index aa08497..38d1e87 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -330,7 +330,7 @@ static unsigned long drb_to_nr_pages(
 static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc;
-	int i;
+	int i, j;
 	struct mem_ctl_info *mci = NULL;
 	unsigned long last_page;
 	u16 drbs[I3200_CHANNELS][I3200_RANKS_PER_CHANNEL];
@@ -386,20 +386,22 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 			i / I3200_RANKS_PER_CHANNEL,
 			i % I3200_RANKS_PER_CHANNEL);
 
-		if (nr_pages == 0) {
-			csrow->mtype = MEM_EMPTY;
+		if (nr_pages == 0)
 			continue;
-		}
 
 		csrow->first_page = last_page + 1;
 		last_page += nr_pages;
 		csrow->last_page = last_page;
 		csrow->nr_pages = nr_pages;
 
-		csrow->grain = nr_pages << PAGE_SHIFT;
-		csrow->mtype = MEM_DDR2;
-		csrow->dtype = DEV_UNKNOWN;
-		csrow->edac_mode = EDAC_UNKNOWN;
+		for (j = 0; j < nr_channels; j++) {
+			struct dimm_info *dimm = csrow->channels[j].dimm;
+
+			dimm->grain = nr_pages << PAGE_SHIFT;
+			dimm->mtype = MEM_DDR2;
+			dimm->dtype = DEV_UNKNOWN;
+			dimm->edac_mode = EDAC_UNKNOWN;
+		}
 	}
 
 	i3200_clear_error_info(mci);
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4dc3ac2..e612f1e 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1268,25 +1268,23 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 		p_csrow->last_page = 9 + csrow * 20;
 		p_csrow->page_mask = 0xFFF;
 
-		p_csrow->grain = 8;
-
 		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++) {
 			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
-		}
+			p_csrow->channels[channel].dimm->grain = 8;
 
-		p_csrow->nr_pages = csrow_megs << 8;
+			/* Assume DDR2 for now */
+			p_csrow->channels[channel].dimm->mtype = MEM_FB_DDR2;
 
-		/* Assume DDR2 for now */
-		p_csrow->mtype = MEM_FB_DDR2;
+			/* ask what device type on this row */
+			if (MTR_DRAM_WIDTH(mtr))
+				p_csrow->channels[channel].dimm->dtype = DEV_X8;
+			else
+				p_csrow->channels[channel].dimm->dtype = DEV_X4;
 
-		/* ask what device type on this row */
-		if (MTR_DRAM_WIDTH(mtr))
-			p_csrow->dtype = DEV_X8;
-		else
-			p_csrow->dtype = DEV_X4;
-
-		p_csrow->edac_mode = EDAC_S8ECD8ED;
+			p_csrow->channels[channel].dimm->edac_mode = EDAC_S8ECD8ED;
+		}
+		p_csrow->nr_pages = csrow_megs << 8;
 
 		empty = 0;
 	}
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 52939ca..1884c36 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -867,27 +867,21 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		 */
 		mci->csrows[i].first_page = total_pages;
 		mci->csrows[i].last_page = total_pages + npages - 1;
-		mci->csrows[i].page_mask = 0UL;
-
 		mci->csrows[i].nr_pages = npages;
-		mci->csrows[i].grain = 32;
 		mci->csrows[i].csrow_idx = i;
-		mci->csrows[i].dtype =
-			(priv->mtr[chan][rank].width == 4) ? DEV_X4 : DEV_X8;
-		mci->csrows[i].ue_count = 0;
-		mci->csrows[i].ce_count = 0;
-		mci->csrows[i].mtype = MEM_RDDR2;
-		mci->csrows[i].edac_mode = EDAC_SECDED;
 		mci->csrows[i].mci = mci;
 		mci->csrows[i].nr_channels = 1;
-		mci->csrows[i].channels[0].chan_idx = 0;
-		mci->csrows[i].channels[0].ce_count = 0;
 		mci->csrows[i].channels[0].csrow = mci->csrows + i;
 		total_pages += npages;
 
 		mci->csrows[i].channels[0].dimm = dimm;
 		dimm->location.mc_channel = chan;
 		dimm->location.mc_dimm_number = rank;
+		dimm->grain = 32;
+		dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
+			      DEV_X4 : DEV_X8;
+		dimm->mtype = MEM_RDDR2;
+		dimm->edac_mode = EDAC_SECDED;
 		snprintf(dimm->label, sizeof(dimm->label),
 			 "DIMM%u",
 			 i5100_rank_to_slot(mci, chan, rank));
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 92af805..35784f2 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1166,11 +1166,6 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 		p_csrow->last_page = 9 + csrow * 20;
 		p_csrow->page_mask = 0xFFF;
 
-		p_csrow->grain = 8;
-		p_csrow->dtype = MTR_DRAM_WIDTH(mtr) ? DEV_X8 : DEV_X4;
-		p_csrow->mtype = MEM_RDDR2;
-		p_csrow->edac_mode = EDAC_SECDED;
-
 		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++)
 			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
@@ -1179,6 +1174,10 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 
 		dimm->location.mc_channel = channel;
 		dimm->location.mc_dimm_number = csrow / pvt->maxch;
+		dimm->grain = 8;
+		dimm->dtype = MTR_DRAM_WIDTH(mtr) ? DEV_X8 : DEV_X4;
+		dimm->mtype = MEM_RDDR2;
+		dimm->edac_mode = EDAC_SECDED;
 		mci->nr_dimms++;
 		dimm++;
 
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index ddd5842..21a8c35 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -618,6 +618,7 @@ static int decode_mtr(struct i7300_pvt *pvt,
 		      int slot, int ch, int branch,
 		      struct i7300_dimm_info *dinfo,
 		      struct csrow_info *p_csrow,
+		      struct dimm_info *dimm,
 		      u32 *nr_pages)
 {
 	int mtr, ans, addrBits, channel;
@@ -663,10 +664,7 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
 	debugf2("\t\tSIZE: %d MB\n", dinfo->megabytes);
 
-	p_csrow->grain = 8;
-	p_csrow->mtype = MEM_FB_DDR2;
 	p_csrow->csrow_idx = slot;
-	p_csrow->page_mask = 0;
 
 	/*
 	 * The type of error detection actually depends of the
@@ -677,15 +675,17 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	 * See datasheet Sections 7.3.6 to 7.3.8
 	 */
 
+	dimm->grain = 8;
+	dimm->mtype = MEM_FB_DDR2;
 	if (IS_SINGLE_MODE(pvt->mc_settings_a)) {
-		p_csrow->edac_mode = EDAC_SECDED;
+		dimm->edac_mode = EDAC_SECDED;
 		debugf2("\t\tECC code is 8-byte-over-32-byte SECDED+ code\n");
 	} else {
 		debugf2("\t\tECC code is on Lockstep mode\n");
 		if (MTR_DRAM_WIDTH(mtr) == 8)
-			p_csrow->edac_mode = EDAC_S8ECD8ED;
+			dimm->edac_mode = EDAC_S8ECD8ED;
 		else
-			p_csrow->edac_mode = EDAC_S4ECD4ED;
+			dimm->edac_mode = EDAC_S4ECD4ED;
 	}
 
 	/* ask what device type on this row */
@@ -694,9 +694,9 @@ static int decode_mtr(struct i7300_pvt *pvt,
 			IS_SCRBALGO_ENHANCED(pvt->mc_settings) ?
 					    "enhanced" : "normal");
 
-		p_csrow->dtype = DEV_X8;
+		dimm->dtype = DEV_X8;
 	} else
-		p_csrow->dtype = DEV_X4;
+		dimm->dtype = DEV_X4;
 
 	return mtr;
 }
@@ -824,7 +824,8 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 				dimm->location.mc_dimm_number = slot;
 
 				mtr = decode_mtr(pvt, slot, ch, branch,
-						 dinfo, p_csrow, &nr_pages);
+						 dinfo, p_csrow, dimm,
+						 &nr_pages);
 				/* if no DIMMS on this row, continue */
 				if (!MTR_DIMMS_PRESENT(mtr))
 					continue;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index d6dd9bf..66879e6 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -725,7 +725,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			csr->nr_pages = npages;
 
 			csr->page_mask = 0;
-			csr->grain = 8;
 			csr->csrow_idx = csrow;
 			csr->nr_channels = 1;
 
@@ -736,30 +735,31 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 			switch (banks) {
 			case 4:
-				csr->dtype = DEV_X4;
+				dimm->dtype = DEV_X4;
 				break;
 			case 8:
-				csr->dtype = DEV_X8;
+				dimm->dtype = DEV_X8;
 				break;
 			case 16:
-				csr->dtype = DEV_X16;
+				dimm->dtype = DEV_X16;
 				break;
 			default:
-				csr->dtype = DEV_UNKNOWN;
+				dimm->dtype = DEV_UNKNOWN;
 			}
 
 			csr->channels[0].dimm = dimm;
+
 			dimm->location.mc_channel = i;
 			dimm->location.mc_dimm_number = j;
 			snprintf(dimm->label, sizeof(dimm->label),
 				 "CPU#%uChannel#%u_DIMM#%u",
 				 pvt->i7core_dev->socket, i, j);
+			dimm->grain = 8;
+			dimm->edac_mode = mode;
+			dimm->mtype = mtype;
+
 			mci->nr_dimms++;
 			dimm++;
-
-			csr->edac_mode = mode;
-			csr->mtype = mtype;
-
 			csrow++;
 		}
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 4329d39..1e19492 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -12,7 +12,7 @@
  * 440GX fix by Jason Uhlenkott <juhlenko@akamai.com>.
  *
  * Written with reference to 82443BX Host Bridge Datasheet:
- * http://download.intel.com/design/chipsets/datashts/29063301.pdf 
+ * http://download.intel.com/design/chipsets/datashts/29063301.pdf
  * references to this document given in [].
  *
  * This module doesn't support the 440LX, but it may be possible to
@@ -189,6 +189,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 				enum mem_type mtype)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	int index;
 	u8 drbar, dramc;
 	u32 row_base, row_high_limit, row_high_limit_last;
@@ -197,6 +198,8 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 	row_high_limit_last = 0;
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
+		dimm = csrow->channels[0].dimm;
+
 		pci_read_config_byte(pdev, I82443BXGX_DRB + index, &drbar);
 		debugf1("MC%d: %s: %s() Row=%d DRB = %#0x\n",
 			mci->mc_idx, __FILE__, __func__, index, drbar);
@@ -219,12 +222,12 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 		csrow->last_page = (row_high_limit >> PAGE_SHIFT) - 1;
 		csrow->nr_pages = csrow->last_page - csrow->first_page + 1;
 		/* EAP reports in 4kilobyte granularity [61] */
-		csrow->grain = 1 << 12;
-		csrow->mtype = mtype;
+		dimm->grain = 1 << 12;
+		dimm->mtype = mtype;
 		/* I don't think 440BX can tell you device type? FIXME? */
-		csrow->dtype = DEV_UNKNOWN;
+		dimm->dtype = DEV_UNKNOWN;
 		/* Mode is global to all rows on 440BX */
-		csrow->edac_mode = edac_mode;
+		dimm->edac_mode = edac_mode;
 		row_high_limit_last = row_high_limit;
 	}
 }
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 931a057..acbd924 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -140,6 +140,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 	u16 value;
 	u32 cumul_size;
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	int index;
 
 	pci_read_config_word(pdev, I82860_MCHCFG, &mchcfg_ddim);
@@ -153,6 +154,8 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 	 */
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
+		dimm = csrow->channels[0].dimm;
+
 		pci_read_config_word(pdev, I82860_GBA + index * 2, &value);
 		cumul_size = (value & I82860_GBA_MASK) <<
 			(I82860_GBA_SHIFT - PAGE_SHIFT);
@@ -166,10 +169,10 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = 1 << 12;	/* I82860_EAP has 4KiB reolution */
-		csrow->mtype = MEM_RMBS;
-		csrow->dtype = DEV_UNKNOWN;
-		csrow->edac_mode = mchcfg_ddim ? EDAC_SECDED : EDAC_NONE;
+		dimm->grain = 1 << 12;	/* I82860_EAP has 4KiB reolution */
+		dimm->mtype = MEM_RMBS;
+		dimm->dtype = DEV_UNKNOWN;
+		dimm->edac_mode = mchcfg_ddim ? EDAC_SECDED : EDAC_NONE;
 	}
 }
 
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 33864c6..81f79e2 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -342,11 +342,13 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 				void __iomem * ovrfl_window, u32 drc)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
+	unsigned nr_chans = dual_channel_active(drc) + 1;
 	unsigned long last_cumul_size;
 	u8 value;
 	u32 drc_ddim;		/* DRAM Data Integrity Mode 0=none,2=edac */
 	u32 cumul_size;
-	int index;
+	int index, j;
 
 	drc_ddim = (drc >> 18) & 0x1;
 	last_cumul_size = 0;
@@ -371,10 +373,15 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = 1 << 12;	/* I82875P_EAP has 4KiB reolution */
-		csrow->mtype = MEM_DDR;
-		csrow->dtype = DEV_UNKNOWN;
-		csrow->edac_mode = drc_ddim ? EDAC_SECDED : EDAC_NONE;
+
+		for (j = 0; j < nr_chans; j++) {
+			dimm = csrow->channels[j].dimm;
+
+			dimm->grain = 1 << 12;	/* I82875P_EAP has 4KiB reolution */
+			dimm->mtype = MEM_DDR;
+			dimm->dtype = DEV_UNKNOWN;
+			dimm->edac_mode = drc_ddim ? EDAC_SECDED : EDAC_NONE;
+		}
 	}
 }
 
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 47f023e..9e1bca5 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -365,6 +365,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	u32 cumul_size;
 	int index, chan;
 	struct dimm_info *dimm;
+	enum dev_type dtype;
 
 	last_cumul_size = 0;
 
@@ -402,6 +403,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
 		 */
+		dtype = i82975x_dram_type(mch_window, index);
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
 			mci->csrows[index].channels[chan].dimm = dimm;
 			dimm->location.csrow = index;
@@ -409,6 +411,10 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 			strncpy(csrow->channels[chan].dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
+			dimm->grain = 1 << 6;	/* I82975X_EAP has 64B resolution */
+			dimm->dtype = dtype;
+			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
+			dimm->edac_mode = EDAC_SECDED; /* only supported */
 			dimm++;
 			mci->nr_dimms++;
 		}
@@ -420,10 +426,6 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = 1 << 6;	/* I82975X_EAP has 64B resolution */
-		csrow->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
-		csrow->dtype = i82975x_dram_type(mch_window, index);
-		csrow->edac_mode = EDAC_SECDED; /* only supported */
 	}
 }
 
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 73464a6..fb92916 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -883,6 +883,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 {
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	u32 sdram_ctl;
 	u32 sdtype;
 	enum mem_type mtype;
@@ -929,6 +930,8 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 		u32 end;
 
 		csrow = &mci->csrows[index];
+		dimm = csrow->channels[0].dimm;
+
 		cs_bnds = in_be32(pdata->mc_vbase + MPC85XX_MC_CS_BNDS_0 +
 				  (index * MPC85XX_MC_CS_BNDS_OFS));
 
@@ -945,12 +948,12 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 		csrow->first_page = start;
 		csrow->last_page = end;
 		csrow->nr_pages = end + 1 - start;
-		csrow->grain = 8;
-		csrow->mtype = mtype;
-		csrow->dtype = DEV_UNKNOWN;
+		dimm->grain = 8;
+		dimm->mtype = mtype;
+		dimm->dtype = DEV_UNKNOWN;
 		if (sdram_ctl & DSC_X32_EN)
-			csrow->dtype = DEV_X32;
-		csrow->edac_mode = EDAC_SECDED;
+			dimm->dtype = DEV_X32;
+		dimm->edac_mode = EDAC_SECDED;
 	}
 }
 
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 7e5ff36..12d7fe0 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -656,6 +656,8 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 				struct mv64x60_mc_pdata *pdata)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
+
 	u32 devtype;
 	u32 ctl;
 
@@ -664,30 +666,30 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 	ctl = in_le32(pdata->mc_vbase + MV64X60_SDRAM_CONFIG);
 
 	csrow = &mci->csrows[0];
-	csrow->first_page = 0;
+	dimm = csrow->channels[0].dimm;
 	csrow->nr_pages = pdata->total_mem >> PAGE_SHIFT;
 	csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
-	csrow->grain = 8;
+	dimm->grain = 8;
 
-	csrow->mtype = (ctl & MV64X60_SDRAM_REGISTERED) ? MEM_RDDR : MEM_DDR;
+	dimm->mtype = (ctl & MV64X60_SDRAM_REGISTERED) ? MEM_RDDR : MEM_DDR;
 
 	devtype = (ctl >> 20) & 0x3;
 	switch (devtype) {
 	case 0x0:
-		csrow->dtype = DEV_X32;
+		dimm->dtype = DEV_X32;
 		break;
 	case 0x2:		/* could be X8 too, but no way to tell */
-		csrow->dtype = DEV_X16;
+		dimm->dtype = DEV_X16;
 		break;
 	case 0x3:
-		csrow->dtype = DEV_X4;
+		dimm->dtype = DEV_X4;
 		break;
 	default:
-		csrow->dtype = DEV_UNKNOWN;
+		dimm->dtype = DEV_UNKNOWN;
 		break;
 	}
 
-	csrow->edac_mode = EDAC_SECDED;
+	dimm->edac_mode = EDAC_SECDED;
 }
 
 static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 7f71ee4..4e53270 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -135,11 +135,13 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 				   enum edac_type edac_mode)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	u32 rankcfg;
 	int index;
 
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
+		dimm = csrow->channels[0].dimm;
 
 		pci_read_config_dword(pdev,
 				      MCDRAM_RANKCFG + (index * 12),
@@ -177,10 +179,10 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 		last_page_in_mmc += csrow->nr_pages;
 		csrow->page_mask = 0;
-		csrow->grain = PASEMI_EDAC_ERROR_GRAIN;
-		csrow->mtype = MEM_DDR;
-		csrow->dtype = DEV_UNKNOWN;
-		csrow->edac_mode = edac_mode;
+		dimm->grain = PASEMI_EDAC_ERROR_GRAIN;
+		dimm->mtype = MEM_DDR;
+		dimm->dtype = DEV_UNKNOWN;
+		dimm->edac_mode = edac_mode;
 	}
 	return 0;
 }
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 3840096..7c98f66 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -895,7 +895,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 	enum mem_type mtype;
 	enum dev_type dtype;
 	enum edac_type edac_mode;
-	int row;
+	int row, j;
 	u32 mbxcf, size;
 	static u32 ppc4xx_last_page;
 
@@ -975,15 +975,18 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 		 * possible values would be the PLB width (16), the
 		 * page size (PAGE_SIZE) or the memory width (2 or 4).
 		 */
+		for (j = 0; j < csi->nr_channels; j++) {
+			struct dimm_info *dimm = csi->channels[j].dimm;
 
-		csi->grain	= 1;
+			dimm->grain	= 1;
 
-		csi->mtype	= mtype;
-		csi->dtype	= dtype;
+			dimm->mtype	= mtype;
+			dimm->dtype	= dtype;
 
-		csi->edac_mode	= edac_mode;
+			dimm->edac_mode	= edac_mode;
 
 		ppc4xx_last_page += csi->nr_pages;
+		}
 	}
 
  done:
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index b153674..c8b774d 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -216,6 +216,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			u8 dramcr)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	int index;
 	u8 drbar;		/* SDRAM Row Boundary Address Register */
 	u32 row_high_limit, row_high_limit_last;
@@ -227,6 +228,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
+		dimm = csrow->channels[0].dimm;
 
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_byte(pdev, R82600_DRBA + index, &drbar);
@@ -250,13 +252,13 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		csrow->nr_pages = csrow->last_page - csrow->first_page + 1;
 		/* Error address is top 19 bits - so granularity is      *
 		 * 14 bits                                               */
-		csrow->grain = 1 << 14;
-		csrow->mtype = reg_sdram ? MEM_RDDR : MEM_DDR;
+		dimm->grain = 1 << 14;
+		dimm->mtype = reg_sdram ? MEM_RDDR : MEM_DDR;
 		/* FIXME - check that this is unknowable with this chipset */
-		csrow->dtype = DEV_UNKNOWN;
+		dimm->dtype = DEV_UNKNOWN;
 
 		/* Mode is global on 82600 */
-		csrow->edac_mode = ecc_on ? EDAC_SECDED : EDAC_NONE;
+		dimm->edac_mode = ecc_on ? EDAC_SECDED : EDAC_NONE;
 		row_high_limit_last = row_high_limit;
 	}
 }
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 43fc65e..537a06e 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -637,22 +637,18 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 					pvt->sbridge_dev->mc, i, j,
 					size, npages,
 					banks, ranks, rows, cols);
-				csr = &mci->csrows[csrow];
 
+				/*
+				 * Fake stuff. This controller doesn't see
+				 * csrows.
+				 */
+				csr = &mci->csrows[csrow];
 				csr->first_page = last_page;
 				csr->last_page = last_page + npages - 1;
-				csr->page_mask = 0UL;	/* Unused */
 				csr->nr_pages = npages;
-				csr->grain = 32;
 				csr->csrow_idx = csrow;
-				csr->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
-				csr->ce_count = 0;
-				csr->ue_count = 0;
-				csr->mtype = mtype;
-				csr->edac_mode = mode;
 				csr->nr_channels = 1;
 				csr->channels[0].chan_idx = i;
-				csr->channels[0].ce_count = 0;
 				pvt->csrow_map[i][j] = csrow;
 				last_page += npages;
 				csrow++;
@@ -660,6 +656,10 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				csr->channels[0].dimm = dimm;
 				dimm->location.mc_channel = i;
 				dimm->location.mc_dimm_number = j;
+				dimm->grain = 32;
+				dimm->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
+				dimm->mtype = mtype;
+				dimm->edac_mode = mode;
 				snprintf(dimm->label, sizeof(dimm->label),
 					 "CPU_SrcID#%u_Channel#%u_DIMM#%u",
 					 pvt->sbridge_dev->source_id, i, j);
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 1d5cf06..db7d2ae 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -84,6 +84,7 @@ static int __devinit tile_edac_init_csrows(struct mem_ctl_info *mci)
 	struct csrow_info	*csrow = &mci->csrows[0];
 	struct tile_edac_priv	*priv = mci->pvt_info;
 	struct mshim_mem_info	mem_info;
+	struct dimm_info *dimm = csrow->channels[0].dimm;
 
 	if (hv_dev_pread(priv->hv_devhdl, 0, (HV_VirtAddr)&mem_info,
 		sizeof(struct mshim_mem_info), MSHIM_MEM_INFO_OFF) !=
@@ -93,16 +94,16 @@ static int __devinit tile_edac_init_csrows(struct mem_ctl_info *mci)
 	}
 
 	if (mem_info.mem_ecc)
-		csrow->edac_mode = EDAC_SECDED;
+		dimm->edac_mode = EDAC_SECDED;
 	else
-		csrow->edac_mode = EDAC_NONE;
+		dimm->edac_mode = EDAC_NONE;
 	switch (mem_info.mem_type) {
 	case DDR2:
-		csrow->mtype = MEM_DDR2;
+		dimm->mtype = MEM_DDR2;
 		break;
 
 	case DDR3:
-		csrow->mtype = MEM_DDR3;
+		dimm->mtype = MEM_DDR3;
 		break;
 
 	default:
@@ -112,8 +113,8 @@ static int __devinit tile_edac_init_csrows(struct mem_ctl_info *mci)
 	csrow->first_page = 0;
 	csrow->nr_pages = mem_info.mem_size >> PAGE_SHIFT;
 	csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
-	csrow->grain = TILE_EDAC_ERROR_GRAIN;
-	csrow->dtype = DEV_UNKNOWN;
+	dimm->grain = TILE_EDAC_ERROR_GRAIN;
+	dimm->dtype = DEV_UNKNOWN;
 
 	return 0;
 }
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index b6f47de..52c8d69 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -317,7 +317,7 @@ static unsigned long drb_to_nr_pages(
 static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc;
-	int i;
+	int i, j;
 	struct mem_ctl_info *mci = NULL;
 	unsigned long last_page;
 	u16 drbs[X38_CHANNELS][X38_RANKS_PER_CHANNEL];
@@ -372,20 +372,21 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 			i / X38_RANKS_PER_CHANNEL,
 			i % X38_RANKS_PER_CHANNEL);
 
-		if (nr_pages == 0) {
-			csrow->mtype = MEM_EMPTY;
+		if (nr_pages == 0)
 			continue;
-		}
 
 		csrow->first_page = last_page + 1;
 		last_page += nr_pages;
 		csrow->last_page = last_page;
 		csrow->nr_pages = nr_pages;
 
-		csrow->grain = nr_pages << PAGE_SHIFT;
-		csrow->mtype = MEM_DDR2;
-		csrow->dtype = DEV_UNKNOWN;
-		csrow->edac_mode = EDAC_UNKNOWN;
+		for (j = 0; j < x38_channel_num; j++) {
+			struct dimm_info *dimm = csrow->channels[j].dimm;
+			dimm->grain = nr_pages << PAGE_SHIFT;
+			dimm->mtype = MEM_DDR2;
+			dimm->dtype = DEV_UNKNOWN;
+			dimm->edac_mode = EDAC_UNKNOWN;
+		}
 	}
 
 	x38_clear_error_info(mci);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 027e478..afa6426 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -270,6 +270,13 @@ struct dimm_info {
 	} location;
 	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
+
+	u32 grain;		/* granularity of reported error in bytes */
+	enum dev_type dtype;	/* memory device type */
+	enum mem_type mtype;	/* memory dimm type */
+	enum edac_type edac_mode;	/* EDAC mode for this dimm */
+
+	u32 ce_count;		/* Correctable Errors for this dimm */
 };
 
 struct csrow_channel_info {
@@ -280,19 +287,17 @@ struct csrow_channel_info {
 };
 
 struct csrow_info {
-	unsigned long first_page;	/* first page number in dimm */
-	unsigned long last_page;	/* last page number in dimm */
+	unsigned long first_page;	/* first page number in csrow */
+	unsigned long last_page;	/* last page number in csrow */
+	u32 nr_pages;			/* number of pages in csrow */
 	unsigned long page_mask;	/* used for interleaving -
 					 * 0UL for non intlv
 					 */
-	u32 nr_pages;		/* number of pages in csrow */
-	u32 grain;		/* granularity of reported error in bytes */
-	int csrow_idx;		/* the chip-select row */
-	enum dev_type dtype;	/* memory device type */
+	int csrow_idx;			/* the chip-select row */
+
 	u32 ue_count;		/* Uncorrectable Errors for this csrow */
 	u32 ce_count;		/* Correctable Errors for this csrow */
-	enum mem_type mtype;	/* memory csrow type */
-	enum edac_type edac_mode;	/* EDAC mode for this csrow */
+
 	struct mem_ctl_info *mci;	/* the parent */
 
 	struct kobject kobj;	/* sysfs kobject for this csrow */
-- 
1.7.8

