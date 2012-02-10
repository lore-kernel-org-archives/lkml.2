Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2BJAHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:07:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669Ab2BJABh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 09/31] i5400_edac: Convert it to report memory with the new location
Date: Thu,  9 Feb 2012 22:01:08 -0200
Message-Id: <1328832090-9166-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this driver, the memory controller supports only FB-DIMMs.

The memory controller hierarchy here has 3 layers bellow the
memory controller:
	- two branches;
	- each branch has two channels;
	- each channel can select up to 4 DIMM's via the
FB-DIMM AMB (Advanced Memory Buffer) chip.

As EDAC currently limits memory controllers to 2 hierarchy
levels, on this patch, both branches and channels are grouped
together.

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

