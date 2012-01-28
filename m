Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2A1PeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:34:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab2A1Pc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 09/16] i5400_edac: Convert it to report memory with the new location
Date: Sat, 28 Jan 2012 13:32:44 -0200
Message-Id: <1327764771-28649-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this driver, the memory controller supports only FBDIMMs.

There are two branches, each with two channels. Each channel
can address up to 4 DIMM's, via the AMB FBDIMM chip.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5400_edac.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 74d6ec34..92af805 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1137,6 +1137,7 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 	int csrow_megs;
 	int channel;
 	int csrow;
+	struct dimm_info *dimm;
 
 	pvt = mci->pvt_info;
 
@@ -1145,6 +1146,9 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 
 	empty = 1;		/* Assume NO memory */
 
+	dimm = mci->dimms;
+	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
+	mci->nr_dimms = 0;
 	for (csrow = 0; csrow < max_csrows; csrow++) {
 		p_csrow = &mci->csrows[csrow];
 
@@ -1163,6 +1167,9 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 		p_csrow->page_mask = 0xFFF;
 
 		p_csrow->grain = 8;
+		p_csrow->dtype = MTR_DRAM_WIDTH(mtr) ? DEV_X8 : DEV_X4;
+		p_csrow->mtype = MEM_RDDR2;
+		p_csrow->edac_mode = EDAC_SECDED;
 
 		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++)
@@ -1170,16 +1177,10 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 
 		p_csrow->nr_pages = csrow_megs << 8;
 
-		/* Assume DDR2 for now */
-		p_csrow->mtype = MEM_FB_DDR2;
-
-		/* ask what device type on this row */
-		if (MTR_DRAM_WIDTH(mtr))
-			p_csrow->dtype = DEV_X8;
-		else
-			p_csrow->dtype = DEV_X4;
-
-		p_csrow->edac_mode = EDAC_S8ECD8ED;
+		dimm->location.mc_channel = channel;
+		dimm->location.mc_dimm_number = csrow / pvt->maxch;
+		mci->nr_dimms++;
+		dimm++;
 
 		empty = 0;
 	}
-- 
1.7.8

