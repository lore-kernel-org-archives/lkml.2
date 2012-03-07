Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2CGML3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666Ab2CGMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] edac: Initialize the dimm label with the known information
Date: Wed,  7 Mar 2012 09:11:13 -0300
Message-Id: <1331122278-28458-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
References: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While userspace doesn't fill the dimm labels, add there the dimm location,
as described by the used memory model. This could eventually match what
is described at the dmidecode, making easier for people to identify the
memory.

For example, on an Intel motherboard, the memory is described as:

Memory Device
	Array Handle: 0x0029
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 1
	Locator: A1_DIMM0
	Bank Locator: A1_Node0_Channel0_Dimm0
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz
	Manufacturer: A1_Manufacturer0
	Serial Number: A1_SerNum0
	Asset Tag: A1_AssetTagNum0
	Part Number: A1_PartNum0

After this patch, the memory label will be filled with:
	/sys/devices/system/edac/mc/mc0/dimm0/dimm_label:mc#0channel#0slot#0

With somewhat matches what it is at the Bank Locator DMI information.
So, it is easier to associate the dimm labels, of course assuming that
the DMI has the Bank Locator filled, and the BIOS doesn't have any bugs.

Yet, even without it, several motherboards are provided with enough
info to map from channel/slot (or branch/channel/slot) into the DIMM
label. So, letting the EDAC core fill it, by default is a good thing.

It should noticed that, as the label filling happens at the
edac_mc_alloc(), drivers can override it to better describe the memories
(and some actually do it).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 4ff8d28..1651e7e 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -205,10 +205,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	struct errcount_attribute_data *ercd;
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
-	void *pvt;
+	void *pvt, *p;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
 	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
-	int i, j;
+	int i, j, n, len;
 	int err;
 	int row, chn;
 
@@ -324,9 +324,22 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 			i, (dimm - mci->dimms),
 			pos[0], pos[1], pos[2], row, chn);
 
-		/* Copy DIMM location */
-		for (j = 0; j < n_layers; j++)
+		/*
+		 * Copy DIMM location and initialize the memory location
+		 */
+		len = sizeof(dimm->label);
+		p = dimm->label;
+		n = snprintf(p, len, "mc#%u", edac_index);
+		p += n;
+		len -= n;
+		for (j = 0; j < n_layers; j++) {
+			n = snprintf(p, len, "%s#%u",
+				     edac_layer_name[layers[j].type],
+				     pos[j]);
+			p += n;
+			len -= n;
 			dimm->location[j] = pos[j];
+		}
 
 		/* Link it to the csrows old API data */
 		chan->dimm = dimm;
-- 
1.7.8

