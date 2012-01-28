Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2A1PeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:34:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab2A1Pc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 10/16] i7300_edac: Convert it to report memory with the new location
Date: Sat, 28 Jan 2012 13:32:45 -0200
Message-Id: <1327764771-28649-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this driver, the memory controller supports only FBDIMMs.

There are two branches, each with two channels. Each channel
can address up to 8 DIMM slots, via the AMB FBDIMM chip.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7300_edac.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 6104dba..ddd5842 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -779,6 +779,7 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 	int mtr;
 	int ch, branch, slot, channel;
 	u32 last_page = 0, nr_pages;
+	struct dimm_info *dimm;
 
 	pvt = mci->pvt_info;
 
@@ -803,6 +804,10 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 	}
 
 	/* Get the set of MTR[0-7] regs by each branch */
+	dimm = mci->dimms;
+	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
+	mci->nr_dimms = 0;
+	nr_pages = 0;
 	for (slot = 0; slot < MAX_SLOTS; slot++) {
 		int where = mtr_regs[slot];
 		for (branch = 0; branch < MAX_BRANCHES; branch++) {
@@ -815,6 +820,9 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 				dinfo = &pvt->dimm_info[slot][channel];
 				p_csrow = &mci->csrows[slot];
 
+				dimm->location.mc_channel = channel;
+				dimm->location.mc_dimm_number = slot;
+
 				mtr = decode_mtr(pvt, slot, ch, branch,
 						 dinfo, p_csrow, &nr_pages);
 				/* if no DIMMS on this row, continue */
@@ -828,6 +836,9 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 				p_csrow->last_page = last_page;
 
 				rc = 0;
+
+				mci->nr_dimms++;
+				dimm++;
 			}
 		}
 	}
-- 
1.7.8

