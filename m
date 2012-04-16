Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2DPUkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab2DPUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>, Doug Thompson <norsk5@yahoo.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [EDAC ABI v13 18/25] edac: Move grain/dtype/edac_type calculus to be out of channel loop
Date: Mon, 16 Apr 2012 17:38:42 -0300
Message-Id: <1334608729-30803-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3e7bddc changeset (edac: move dimm properties to struct memset_info)
moved the calculus inside a loop. However, at those stuff are common to
all channels, on several drivers, it is better to put the calculus
outside the loop, to optimize the code.

Reported-by: Aristeu Rozanski Filho <arozansk@redhat.com>
Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Mark Gross <mark.gross@intel.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/cpc925_edac.c |   54 ++++++++++++++++++++++----------------------
 drivers/edac/e752x_edac.c  |   31 +++++++++++++------------
 drivers/edac/e7xxx_edac.c  |   32 +++++++++++++------------
 3 files changed, 60 insertions(+), 57 deletions(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 78881b1..1b26ced 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -330,8 +330,9 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 	struct cpc925_mc_pdata *pdata = mci->pvt_info;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
+	enum dev_type dtype;
 	int index, j;
-	u32 mbmr, mbbar, bba;
+	u32 mbmr, mbbar, bba, grain;
 	unsigned long row_size, nr_pages, last_nr_pages = 0;
 
 	get_total_mem(pdata);
@@ -355,37 +356,36 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 		csrow->last_page = csrow->first_page + nr_pages - 1;
 		last_nr_pages = csrow->last_page + 1;
 
+		switch (csrow->nr_channels) {
+		case 1: /* Single channel */
+			grain = 32; /* four-beat burst of 32 bytes */
+			break;
+		case 2: /* Dual channel */
+		default:
+			grain = 64; /* four-beat burst of 64 bytes */
+			break;
+		}
+		switch ((mbmr & MBMR_MODE_MASK) >> MBMR_MODE_SHIFT) {
+		case 6: /* 0110, no way to differentiate X8 VS X16 */
+		case 5:	/* 0101 */
+		case 8: /* 1000 */
+			dtype = DEV_X16;
+			break;
+		case 7: /* 0111 */
+		case 9: /* 1001 */
+			dtype = DEV_X8;
+			break;
+		default:
+			dtype = DEV_UNKNOWN;
+		break;
+		}
 		for (j = 0; j < csrow->nr_channels; j++) {
 			dimm = csrow->channels[j].dimm;
-
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			dimm->mtype = MEM_RDDR;
 			dimm->edac_mode = EDAC_SECDED;
-
-			switch (csrow->nr_channels) {
-			case 1: /* Single channel */
-				dimm->grain = 32; /* four-beat burst of 32 bytes */
-				break;
-			case 2: /* Dual channel */
-			default:
-				dimm->grain = 64; /* four-beat burst of 64 bytes */
-				break;
-			}
-
-			switch ((mbmr & MBMR_MODE_MASK) >> MBMR_MODE_SHIFT) {
-			case 6: /* 0110, no way to differentiate X8 VS X16 */
-			case 5:	/* 0101 */
-			case 8: /* 1000 */
-				dimm->dtype = DEV_X16;
-				break;
-			case 7: /* 0111 */
-			case 9: /* 1001 */
-				dimm->dtype = DEV_X8;
-				break;
-			default:
-				dimm->dtype = DEV_UNKNOWN;
-				break;
-			}
+			dimm->grain = grain;
+			dimm->dtype = dtype;
 		}
 	}
 }
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 9b252dd..84bb8f6 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1069,6 +1069,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			u16 ddrcsr)
 {
 	struct csrow_info *csrow;
+	enum edac_type edac_mode;
 	unsigned long last_cumul_size;
 	int index, mem_dev, drc_chan;
 	int drc_drbg;		/* DRB granularity 0=64mb, 1=128mb */
@@ -1111,6 +1112,20 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
+		/*
+		* if single channel or x8 devices then SECDED
+		* if dual channel and x4 then S4ECD4ED
+		*/
+		if (drc_ddim) {
+			if (drc_chan && mem_dev) {
+				edac_mode = EDAC_S4ECD4ED;
+				mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
+			} else {
+				edac_mode = EDAC_SECDED;
+				mci->edac_cap |= EDAC_FLAG_SECDED;
+			}
+		} else
+			edac_mode = EDAC_NONE;
 		for (i = 0; i < csrow->nr_channels; i++) {
 			struct dimm_info *dimm = csrow->channels[i].dimm;
 
@@ -1119,21 +1134,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
 			dimm->mtype = MEM_RDDR;	/* only one type supported */
 			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
-
-			/*
-			* if single channel or x8 devices then SECDED
-			* if dual channel and x4 then S4ECD4ED
-			*/
-			if (drc_ddim) {
-				if (drc_chan && mem_dev) {
-					dimm->edac_mode = EDAC_S4ECD4ED;
-					mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
-				} else {
-					dimm->edac_mode = EDAC_SECDED;
-					mci->edac_cap |= EDAC_FLAG_SECDED;
-				}
-			} else
-				dimm->edac_mode = EDAC_NONE;
+			dimm->edac_mode = edac_mode;
 		}
 	}
 }
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index dba87a7..e930dd1 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -362,6 +362,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	int drc_chan, drc_drbg, drc_ddim, mem_dev;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
+	enum edac_type edac_mode;
 
 	pci_read_config_dword(pdev, E7XXX_DRA, &dra);
 	drc_chan = dual_channel_active(drc, dev_idx);
@@ -392,6 +393,21 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
+		/*
+		* if single channel or x8 devices then SECDED
+		* if dual channel and x4 then S4ECD4ED
+		*/
+		if (drc_ddim) {
+			if (drc_chan && mem_dev) {
+				edac_mode = EDAC_S4ECD4ED;
+				mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
+			} else {
+				edac_mode = EDAC_SECDED;
+				mci->edac_cap |= EDAC_FLAG_SECDED;
+			}
+		} else
+			edac_mode = EDAC_NONE;
+
 		for (j = 0; j < drc_chan + 1; j++) {
 			dimm = csrow->channels[j].dimm;
 
@@ -399,21 +415,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
 			dimm->mtype = MEM_RDDR;	/* only one type supported */
 			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
-
-			/*
-			* if single channel or x8 devices then SECDED
-			* if dual channel and x4 then S4ECD4ED
-			*/
-			if (drc_ddim) {
-				if (drc_chan && mem_dev) {
-					dimm->edac_mode = EDAC_S4ECD4ED;
-					mci->edac_cap |= EDAC_FLAG_S4ECD4ED;
-				} else {
-					dimm->edac_mode = EDAC_SECDED;
-					mci->edac_cap |= EDAC_FLAG_SECDED;
-				}
-			} else
-				dimm->edac_mode = EDAC_NONE;
+			dimm->edac_mode = edac_mode;
 		}
 	}
 }
-- 
1.7.8

