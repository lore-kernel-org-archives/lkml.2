Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab2ERQsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560Ab2ERQdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 60/66] i7core: fix ranks information at the per-channel struct
Date: Fri, 18 May 2012 13:32:47 -0300
Message-Id: <1337358773-6919-61-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a flag at the per-channel struct that indicates if there are
any 4R dimm on it. The way the presence of this flag were reported
is not ok, as it might give the false idea that the channel were filled
with 2R memories:

[  580.588701] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f7431): 2 ranks, UDIMMs
[  580.588704] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400

(in this case, just one 1R memory is filled on channel 1)

So, use a better way to represent the per-channel ranks information.
After the patch, it will show:

[ 2002.233978] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f7431): UDIMMs
[ 2002.233982] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
[ 2002.233988] EDAC DEBUG: get_dimm_config: 	dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400

(in this case, there isn't any 4R memories)

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index d888120..c29944f 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -221,7 +221,9 @@ struct i7core_inject {
 };
 
 struct i7core_channel {
-	u32		ranks;
+	bool		is_3dimms_present;
+	bool		is_single_4rank;
+	bool		has_4rank;
 	u32		dimms;
 };
 
@@ -557,21 +559,20 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		pci_read_config_dword(pvt->pci_ch[i][0],
 				MC_CHANNEL_DIMM_INIT_PARAMS, &data);
 
-		pvt->channel[i].ranks = (data & QUAD_RANK_PRESENT) ?
-						4 : 2;
+
+		if (data & THREE_DIMMS_PRESENT)
+			pvt->channel[i].is_3dimms_present = true;
+
+		if (data & SINGLE_QUAD_RANK_PRESENT)
+			pvt->channel[i].is_single_4rank = true;
+
+		if (data & QUAD_RANK_PRESENT)
+			pvt->channel[i].has_4rank = true;
 
 		if (data & REGISTERED_DIMM)
 			mtype = MEM_RDDR3;
 		else
 			mtype = MEM_DDR3;
-#if 0
-		if (data & THREE_DIMMS_PRESENT)
-			pvt->channel[i].dimms = 3;
-		else if (data & SINGLE_QUAD_RANK_PRESENT)
-			pvt->channel[i].dimms = 1;
-		else
-			pvt->channel[i].dimms = 2;
-#endif
 
 		/* Devices 4-6 function 1 */
 		pci_read_config_dword(pvt->pci_ch[i][1],
@@ -582,11 +583,13 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				MC_DOD_CH_DIMM2, &dimm_dod[2]);
 
 		debugf0("Ch%d phy rd%d, wr%d (0x%08x): "
-			"%d ranks, %cDIMMs\n",
+			"%s%s%s%cDIMMs\n",
 			i,
 			RDLCH(pvt->info.ch_map, i), WRLCH(pvt->info.ch_map, i),
 			data,
-			pvt->channel[i].ranks,
+			pvt->channel[i].is_3dimms_present ? "3DIMMS " : "",
+			pvt->channel[i].is_3dimms_present ? "SINGLE_4R " : "",
+			pvt->channel[i].has_4rank ? "HAS_4R " : "",
 			(data & REGISTERED_DIMM) ? 'R' : 'U');
 
 		for (j = 0; j < 3; j++) {
-- 
1.7.8

