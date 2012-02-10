Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab2BJADF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:03:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab2BJABk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 27/31] edac: Initialize the dimm label with the known information
Date: Thu,  9 Feb 2012 22:01:26 -0200
Message-Id: <1328832090-9166-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 5326b6b..91545a5 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -210,10 +210,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	struct errcount_attribute_data *ercd;
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
-	void *pvt;
+	void *pvt, *p;
 	unsigned size, tot_dimms, count, per_layer_count[EDAC_MAX_LAYERS];
 	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
-	int i, j;
+	int i, j, n, len;
 	int err;
 	int row, chn;
 
@@ -327,9 +327,22 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		dimm = &mci->dimms[i];
 		dimm->mci = mci;
 
-		/* Copy DIMM location */
-		for (j = 0; j < n_layers; j++)
+		/*
+		 * Copy DIMM location and initialize the memory location
+		 */
+		len = sizeof(dimm->label);
+		p = dimm->label;
+		n = snprintf(p, len,"mc#%u", edac_index);
+		p += n;
+		len -= n;
+		for (j = 0; j < n_layers; j++) {
+			n = snprintf(p, len,"%s#%u",
+				     edac_layer_name[layers[j].type],
+				     per_layer_count[j]);
+			p += n;
+			len -= n;
 			dimm->location[j] = per_layer_count[j];
+		}
 
 		/* Link it to the csrows old API data */
 		chan->dimm = dimm;
-- 
1.7.8

