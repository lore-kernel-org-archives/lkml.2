Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2DWUHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:07:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab2DWUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:07:27 -0400
Message-ID: <4F95B671.2070003@redhat.com>
Date: Mon, 23 Apr 2012 20:07:13 +0000
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac.h: Add generic layers for describing a memory location
References: <4F95A5CE.7010804@redhat.com> <1335208746-15223-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1335208746-15223-1-git-send-email-mchehab@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-04-2012 19:19, Mauro Carvalho Chehab escreveu:
> The edac core were written with the idea that memory controllers
> are able to directly access csrows, and that the channels are
> used inside a csrows select.
> 
> This is not true for FB-DIMM and RAMBUS memory controllers.
> 
> Also, some recent advanced memory controllers don't present a per-csrows
> view. Instead, they view memories as DIMMs, instead of ranks, accessed
> via csrow/channel.
> 
> So, changes are needed in order to allow the EDAC core to
> work with all types of architectures.
> 
> In preparation for handling non-csrows based memory controllers,
> add some memory structs and a macro:
> 
> enum hw_event_mc_err_type: describes the type of error
> 			   (corrected, uncorrected, fatal)
> 
> To be used by the new edac_mc_handle_error function;
> 
> enum edac_mc_layer: describes the type of a given memory
> architecture layer (branch, channel, slot, csrow).
> 
> struct edac_mc_layer: describes the properties of a memory
> 		      layer (type, size, and if the layer
> 		      will be used on a virtual csrow.
> 
> EDAC_DIMM_PTR() - as the number of layers can vary from 1 to 3,
> this macro converts from an address with up to 3 layers into
> a linear address.
> 
> Cc: Doug Thompson <norsk5@yahoo.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> v15: Fixed some comments, is_csrow renamed to is_virt_csrow,
>      GET_POS renamed to EDAC_DIMM_PTR

There are 55 patches affected by this change. Applying them locally
was as simple as running this small script to the submitted patches:

$ for i in `quilt series`; do sed s,is_csrow,is_virt_csrow,g $i|sed s,GET_POS,EDAC_DIMM_PTR,g| >a && mv a $i; done

However, mailbombing 55 patches just because of the above rename
is probably not very welcome by the people at the ML. Also, at least
for me, it seems more logical to add a patch like that at the end of
the patch series, than to force people to re-analyze the entire patchset.

Due to that, I won't resend the entire patchbomb to the ML.
They'll be there, anyway, on my tree, at:

	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v15

After Kernel.org mirror sync. The previous tree, with the enclosed
renamed patch at the end is at:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v14

PS.: I'm also storing the very latest version of this patch series at:
	git://git.infradead.org/users/mchehab/edac.git experimental

The only difference is that the experimental branch there will be rebased
every time I need to modify a patch on this series, while I'll create a new
branch at the kernel.org tree with the changes, instead of rebasing an
existing one.

-

[PATCH] edac: rename is_csrows and GET_POS

Those names don't represent well the meaning for those fields.
So, rename them to be meaningful.

As "is_csrows" is used to indicate that a layer is part of the
virtual csrow, let's name it as is_virt_csrows.

As "GET_POS" is used to get the EDAC mci dimm_info pointer for
a given layer address, let's call it as "EDAC_DIMM_PTR".

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 08af66c..50467a0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2568,10 +2568,10 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	ret = -ENOMEM;
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = pvt->csels[0].b_cnt;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = pvt->channel_count;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		goto err_siblings;
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 99d8d56..be6c225 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -247,10 +247,10 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = AMD76X_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 
 	if (mci == NULL)
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index ee61f0d..d28167b 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -200,10 +200,10 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = 1;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = num_chans;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct cell_edac_priv));
 	if (mci == NULL)
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 0203089..31b3c91 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -978,10 +978,10 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = CPC925_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct cpc925_mc_pdata));
 	if (!mci) {
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 35f282e..7e601c1 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1293,10 +1293,10 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = E752X_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = drc_chan + 1;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*pvt));
 	if (mci == NULL)
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 93695e4..2defa96 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -445,10 +445,10 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = E7XXX_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = drc_chan + 1;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d3dd0dd..6853935 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -240,7 +240,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	tot_csrows = 1;
 	for (i = 0; i < n_layers; i++) {
 		tot_dimms *= layers[i].size;
-		if (layers[i].is_csrow)
+		if (layers[i].is_virt_csrow)
 			tot_csrows *= layers[i].size;
 		else
 			tot_cschannels *= layers[i].size;
@@ -380,7 +380,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		/* Increment csrow location */
 		if (!rev_order) {
 			for (j = n_layers - 1; j >= 0; j--)
-				if (!layers[j].is_csrow)
+				if (!layers[j].is_virt_csrow)
 					break;
 			chn++;
 			if (chn == tot_cschannels) {
@@ -389,7 +389,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 			}
 		} else {
 			for (j = n_layers - 1; j >= 0; j--)
-				if (layers[j].is_csrow)
+				if (layers[j].is_virt_csrow)
 					break;
 			row++;
 			if (row == tot_csrows) {
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 15df2bc..55eff02 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -358,10 +358,10 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I3000_RANKS / nr_channels;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index acb5d39..818ee6f 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -343,10 +343,10 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I3200_DIMMS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
 			    false, sizeof(struct i3200_priv));
 	if (!mci)
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 3626225..fda19b4 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1280,7 +1280,7 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 			if (!MTR_DIMMS_PRESENT(mtr))
 				continue;
 
-			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+			dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms, mci->n_layers,
 				       channel / MAX_BRANCHES,
 				       channel % MAX_BRANCHES, slot);
 
@@ -1397,13 +1397,13 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_BRANCH;
 	layers[0].size = MAX_BRANCHES;
-	layers[0].is_csrow = false;
+	layers[0].is_virt_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = num_channels / MAX_BRANCHES;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = num_dimms_per_channel;
-	layers[2].is_csrow = true;
+	layers[2].is_virt_csrow = true;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index dd260c8..a5a7ca4 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -844,7 +844,7 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		if (!npages)
 			continue;
 
-		dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+		dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms, mci->n_layers,
 			       chan, rank, 0);
 
 		dimm->nr_pages = npages;
@@ -932,10 +932,10 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 
 	layers[0].type = EDAC_MC_LAYER_CHANNEL;
 	layers[0].size = 2;
-	layers[0].is_csrow = false;
+	layers[0].is_virt_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = ranksperch;
-	layers[1].is_csrow = true;
+	layers[1].is_virt_csrow = true;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*priv));
 	if (!mci) {
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 74b64c6..676591e 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1198,7 +1198,7 @@ static int i5400_init_dimms(struct mem_ctl_info *mci)
 			if (!MTR_DIMMS_PRESENT(mtr))
 				continue;
 
-			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+			dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms, mci->n_layers,
 				       channel / 2, channel % 2, slot);
 
 			size_mb =  pvt->dimm_info[slot][channel].megabytes;
@@ -1286,13 +1286,13 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	layers[0].type = EDAC_MC_LAYER_BRANCH;
 	layers[0].size = MAX_BRANCHES;
-	layers[0].is_csrow = false;
+	layers[0].is_virt_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = CHANNELS_PER_BRANCH;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = DIMMS_PER_CHANNEL;
-	layers[2].is_csrow = true;
+	layers[2].is_virt_csrow = true;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index f9a4fa4..7425f17 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -795,7 +795,7 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 			for (ch = 0; ch < MAX_CH_PER_BRANCH; ch++) {
 				int channel = to_channel(ch, branch);
 
-				dimm = GET_POS(mci->layers, mci->dimms,
+				dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
 					       mci->n_layers, branch, ch, slot);
 
 				dinfo = &pvt->dimm_info[slot][channel];
@@ -1044,13 +1044,13 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	/* allocate a new MC control structure */
 	layers[0].type = EDAC_MC_LAYER_BRANCH;
 	layers[0].size = MAX_BRANCHES;
-	layers[0].is_csrow = false;
+	layers[0].is_virt_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = MAX_CH_PER_BRANCH;
-	layers[1].is_csrow = true;
+	layers[1].is_virt_csrow = true;
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = MAX_SLOTS;
-	layers[2].is_csrow = true;
+	layers[2].is_virt_csrow = true;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index cf27af8..dfdee48 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -596,7 +596,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			if (!DIMM_PRESENT(dimm_dod[j]))
 				continue;
 
-			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+			dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms, mci->n_layers,
 				       i, j, 0);
 			banks = numbank(MC_DOD_NUMBANK(dimm_dod[j]));
 			ranks = numrank(MC_DOD_NUMRANK(dimm_dod[j]));
@@ -2229,10 +2229,10 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 
 	layers[0].type = EDAC_MC_LAYER_CHANNEL;
 	layers[0].size = NUM_CHANS;
-	layers[0].is_csrow = false;
+	layers[0].is_virt_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = MAX_DIMMS;
-	layers[1].is_csrow = true;
+	layers[1].is_virt_csrow = true;
 	mci = edac_mc_alloc(i7core_dev->socket, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*pvt));
 	if (unlikely(!mci))
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 877ba54..c0249f3 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -251,10 +251,10 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I82443BXGX_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = I82443BXGX_NR_CHANS;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index f493758..6ff59b0 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -202,10 +202,10 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	layers[0].type = EDAC_MC_LAYER_CHANNEL;
 	layers[0].size = 2;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = 8;
-	layers[1].is_csrow = true;
+	layers[1].is_virt_csrow = true;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index a42a5bd..c943904 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -416,10 +416,10 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I82875P_NR_CSROWS(nr_chans);
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_chans;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 717f208..a4a6768 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -548,10 +548,10 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* assuming only one controller, index thus is 0 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I82975X_NR_DIMMS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = I82975X_NR_CSROWS(chans);
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 42e209c..1640d54 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -988,10 +988,10 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = 4;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(*pdata));
 	if (!mci) {
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 87139ca..59c399a 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -711,10 +711,10 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = 1;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct mv64x60_mc_pdata));
 	if (!mci) {
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 634b919..267e9cc 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -211,10 +211,10 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = PASEMI_EDAC_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = PASEMI_EDAC_NR_CHANS;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(system_mmc_id++, ARRAY_SIZE(layers), layers, false,
 			    0);
 	if (mci == NULL)
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 3917b0f..77908cd 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1287,10 +1287,10 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = ppc4xx_edac_nr_csrows;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = ppc4xx_edac_nr_chans;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(ppc4xx_edac_instance, ARRAY_SIZE(layers), layers,
 			    false, sizeof(struct ppc4xx_edac_pdata));
 	if (mci == NULL) {
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 6a7a2ce..7b7eaf2 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -287,10 +287,10 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = R82600_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = R82600_NR_CHANS;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index ff07f34..bb7e95f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -572,7 +572,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		u32 mtr;
 
 		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
-			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+			dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms, mci->n_layers,
 				       i, j, 0);
 			pci_read_config_dword(pvt->pci_tad[i],
 					      mtr_regs[j], &mtr);
@@ -1635,10 +1635,10 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	/* allocate a new MC control structure */
 	layers[0].type = EDAC_MC_LAYER_CHANNEL;
 	layers[0].size = NUM_CHANNELS;
-	layers[0].is_csrow = false;
+	layers[0].is_virt_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_SLOT;
 	layers[1].size = MAX_DIMMS;
-	layers[1].is_csrow = true;
+	layers[1].is_virt_csrow = true;
 	mci = edac_mc_alloc(sbridge_dev->mc, ARRAY_SIZE(layers), layers,
 			    false, sizeof(*pvt));
 
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 4aecb06..56b0ab0 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -137,10 +137,10 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	/* A TILE MC has a single channel and one chip-select row. */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = TILE_EDAC_NR_CSROWS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = TILE_EDAC_NR_CHANS;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index c5e54ef..219530b 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -344,10 +344,10 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	/* FIXME: unconventional pvt_info usage */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = X38_RANKS;
-	layers[0].is_csrow = true;
+	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = x38_channel_num;
-	layers[1].is_csrow = false;
+	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 062a1a7..e348afb 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -384,14 +384,14 @@ enum edac_mc_layer_type {
  * struct edac_mc_layer - describes the memory controller hierarchy
  * @layer:		layer type
  * @size:maximum size of the layer
- * @is_csrow:		This layer is part of the "csrow" when old API
+ * @is_virt_csrow:	This layer is part of the "csrow" when old API
  *			compatibility mode is enabled. Otherwise, it is
  *			a channel
  */
 struct edac_mc_layer {
 	enum edac_mc_layer_type	type;
 	unsigned		size;
-	bool			is_csrow;
+	bool			is_virt_csrow;
 };
 
 /*
@@ -424,7 +424,7 @@ struct edac_mc_layer {
 	__i;								\
 })
 
-#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
+#define EDAC_DIMM_PTR(layers, var, nlayers, lay0, lay1, lay2) ({		\
 	typeof(*var) __p;						\
 	int ___i = GET_OFFSET(layers, nlayers, lay0, lay1, lay2);	\
 	if (___i < 0)							\
