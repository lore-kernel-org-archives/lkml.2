Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2DPUk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab2DPUkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:40:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>, linuxppc-dev@lists.ozlabs.org
Subject: [EDAC ABI v13 24/25] edac: change the mem allocation scheme to make Documentation/kobject.txt happy
Date: Mon, 16 Apr 2012 17:38:48 -0300
Message-Id: <1334608729-30803-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel kobjects have rigid rules: each container object should be
dynamically allocated, and can't be allocated into a single kmalloc.

EDAC never obeyed this rule: it has a single malloc function that
allocates all needed data into a single kzalloc.

As this is not accepted anymore, change the allocation schema of the
EDAC *_info structs to enforce this Kernel standard.

Cc: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mark Gross <mark.gross@intel.com>
Cc: Jason Uhlenkott <juhlenko@akamai.com>
Cc: Tim Small <tim@buttersideup.com>
Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: "Arvind R." <arvino55@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Egor Martovetsky <egor@pasemi.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |    8 +-
 drivers/edac/amd76x_edac.c     |    8 +-
 drivers/edac/cell_edac.c       |    8 +-
 drivers/edac/cpc925_edac.c     |    8 +-
 drivers/edac/e752x_edac.c      |    4 +-
 drivers/edac/e7xxx_edac.c      |    4 +-
 drivers/edac/edac_mc.c         |  105 +++++++++++++++++++++------------
 drivers/edac/edac_mc_sysfs.c   |  126 +++++++++++++++++++++++-----------------
 drivers/edac/i3000_edac.c      |    6 +-
 drivers/edac/i3200_edac.c      |    4 +-
 drivers/edac/i5400_edac.c      |    6 +-
 drivers/edac/i82443bxgx_edac.c |    4 +-
 drivers/edac/i82860_edac.c     |    6 +-
 drivers/edac/i82875p_edac.c    |    6 +-
 drivers/edac/i82975x_edac.c    |   10 ++--
 drivers/edac/mpc85xx_edac.c    |    6 +-
 drivers/edac/mv64x60_edac.c    |    4 +-
 drivers/edac/pasemi_edac.c     |    8 +-
 drivers/edac/r82600_edac.c     |    4 +-
 drivers/edac/tile_edac.c       |    4 +-
 drivers/edac/x38_edac.c        |    4 +-
 include/linux/edac.h           |   31 ++++++----
 22 files changed, 216 insertions(+), 158 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 321b838..ee7c060 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2197,7 +2197,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		!!(val & NBCFG_CHIPKILL), !!(val & NBCFG_ECC_ENABLE));
 
 	for_each_chip_select(i, 0, pvt) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 
 		if (!csrow_enabled(i, 0, pvt)) {
 			debugf1("----CSROW %d EMPTY for node %d\n", i,
@@ -2228,9 +2228,9 @@ static int init_csrows(struct mem_ctl_info *mci)
 			edac_mode = EDAC_NONE;
 
 		for (j = 0; j < pvt->channel_count; j++) {
-			csrow->channels[j].dimm->mtype = mtype;
-			csrow->channels[j].dimm->edac_mode = edac_mode;
-			csrow->channels[j].dimm->nr_pages = nr_pages;
+			csrow->channels[j]->dimm->mtype = mtype;
+			csrow->channels[j]->dimm->edac_mode = edac_mode;
+			csrow->channels[j]->dimm->nr_pages = nr_pages;
 		}
 	}
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 9a34c5f..99d8d56 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -146,7 +146,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
 			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-					     mci->csrows[row].first_page, 0, 0,
+					     mci->csrows[row]->first_page, 0, 0,
 					     row, 0, -1,
 					     mci->ctl_name, "", NULL);
 		}
@@ -161,7 +161,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
-					     mci->csrows[row].first_page, 0, 0,
+					     mci->csrows[row]->first_page, 0, 0,
 					     row, 0, -1,
 					     mci->ctl_name, "", NULL);
 		}
@@ -194,8 +194,8 @@ static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	int index;
 
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
-		dimm = csrow->channels[0].dimm;
+		csrow = mci->csrows[index];
+		dimm = csrow->channels[0]->dimm;
 
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_dword(pdev,
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 9e53917..ee61f0d 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -33,7 +33,7 @@ struct cell_edac_priv
 static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 {
 	struct cell_edac_priv		*priv = mci->pvt_info;
-	struct csrow_info		*csrow = &mci->csrows[0];
+	struct csrow_info		*csrow = mci->csrows[0];
 	unsigned long			address, pfn, offset, syndrome;
 
 	dev_dbg(mci->pdev, "ECC CE err on node %d, channel %d, ar = 0x%016llx\n",
@@ -56,7 +56,7 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 {
 	struct cell_edac_priv		*priv = mci->pvt_info;
-	struct csrow_info		*csrow = &mci->csrows[0];
+	struct csrow_info		*csrow = mci->csrows[0];
 	unsigned long			address, pfn, offset;
 
 	dev_dbg(mci->pdev, "ECC UE err on node %d, channel %d, ar = 0x%016llx\n",
@@ -126,7 +126,7 @@ static void cell_edac_check(struct mem_ctl_info *mci)
 
 static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 {
-	struct csrow_info		*csrow = &mci->csrows[0];
+	struct csrow_info		*csrow = mci->csrows[0];
 	struct dimm_info		*dimm;
 	struct cell_edac_priv		*priv = mci->pvt_info;
 	struct device_node		*np;
@@ -150,7 +150,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 		csrow->last_page = csrow->first_page + nr_pages - 1;
 
 		for (j = 0; j < csrow->nr_channels; j++) {
-			dimm = csrow->channels[j].dimm;
+			dimm = csrow->channels[j]->dimm;
 			dimm->mtype = MEM_XDR;
 			dimm->edac_mode = EDAC_SECDED;
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 1b26ced..0203089 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -348,7 +348,7 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 		if (bba == 0)
 			continue; /* not populated */
 
-		csrow = &mci->csrows[index];
+		csrow = mci->csrows[index];
 
 		row_size = bba * (1UL << 28);	/* 256M */
 		csrow->first_page = last_nr_pages;
@@ -380,7 +380,7 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 		break;
 		}
 		for (j = 0; j < csrow->nr_channels; j++) {
-			dimm = csrow->channels[j].dimm;
+			dimm = csrow->channels[j]->dimm;
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			dimm->mtype = MEM_RDDR;
 			dimm->edac_mode = EDAC_SECDED;
@@ -463,7 +463,7 @@ static void cpc925_mc_get_pfn(struct mem_ctl_info *mci, u32 mear,
 	*csrow = rank;
 
 #ifdef CONFIG_EDAC_DEBUG
-	if (mci->csrows[rank].first_page == 0) {
+	if (mci->csrows[rank]->first_page == 0) {
 		cpc925_mc_printk(mci, KERN_ERR, "ECC occurs in a "
 			"non-populated csrow, broken hardware?\n");
 		return;
@@ -471,7 +471,7 @@ static void cpc925_mc_get_pfn(struct mem_ctl_info *mci, u32 mear,
 #endif
 
 	/* Revert csrow number */
-	pa = mci->csrows[rank].first_page << PAGE_SHIFT;
+	pa = mci->csrows[rank]->first_page << PAGE_SHIFT;
 
 	/* Revert column address */
 	col += bcnt;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 84bb8f6..35f282e 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1096,7 +1096,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	for (last_cumul_size = index = 0; index < mci->nr_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 2)) & 0x3;
-		csrow = &mci->csrows[remap_csrow_index(mci, index)];
+		csrow = mci->csrows[remap_csrow_index(mci, index)];
 
 		mem_dev = (mem_dev == 2);
 		pci_read_config_byte(pdev, E752X_DRB + index, &value);
@@ -1127,7 +1127,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		} else
 			edac_mode = EDAC_NONE;
 		for (i = 0; i < csrow->nr_channels; i++) {
-			struct dimm_info *dimm = csrow->channels[i].dimm;
+			struct dimm_info *dimm = csrow->channels[i]->dimm;
 
 			debugf3("Initializing rank at (%i,%i)\n", index, i);
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index e930dd1..93695e4 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -378,7 +378,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	for (index = 0; index < mci->nr_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 3)) & 0x1;
-		csrow = &mci->csrows[index];
+		csrow = mci->csrows[index];
 
 		pci_read_config_byte(pdev, E7XXX_DRB + index, &value);
 		/* convert a 64 or 32 MiB DRB to a page size. */
@@ -409,7 +409,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			edac_mode = EDAC_NONE;
 
 		for (j = 0; j < drc_chan + 1; j++) {
-			dimm = csrow->channels[j].dimm;
+			dimm = csrow->channels[j]->dimm;
 
 			dimm->nr_pages = nr_pages / (drc_chan + 1);
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index bb96fac..69b1ee4 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -203,14 +203,14 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	void *ptr;
 	struct mem_ctl_info *mci;
 	struct edac_mc_layer *lay;
-	struct csrow_info *csi, *csr;
-	struct rank_info *chi, *chp, *chan;
+	struct csrow_info *csr;
+	struct rank_info *chan;
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt, *p;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
 	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
-	int i, j, n, len;
+	int i, j, n, len, off;
 	int row, chn;
 	bool per_rank = false;
 
@@ -241,9 +241,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	ptr = 0;
 	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
 	lay = edac_align_ptr(&ptr, sizeof(*lay), n_layers);
-	csi = edac_align_ptr(&ptr, sizeof(*csi), tot_csrows);
-	chi = edac_align_ptr(&ptr, sizeof(*chi), tot_csrows * tot_cschannels);
-	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
 	count = 1;
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
@@ -262,6 +259,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		tot_dimms,
 		per_rank ? "ranks" : "dimms",
 		tot_csrows * tot_cschannels);
+
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -270,9 +268,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
 	lay = (struct edac_mc_layer *)(((char *)mci) + ((unsigned long)lay));
-	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
-	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
-	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
 	for (i = 0; i < n_layers; i++) {
 		mci->ce_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ce_per_layer[i]));
 		mci->ue_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ue_per_layer[i]));
@@ -281,8 +276,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 
 	/* setup index and various internal pointers */
 	mci->mc_idx = edac_index;
-	mci->csrows = csi;
-	mci->dimms  = dimm;
 	mci->tot_dimms = tot_dimms;
 	mci->pvt_info = pvt;
 	mci->n_layers = n_layers;
@@ -293,39 +286,56 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	mci->mem_is_per_rank = per_rank;
 
 	/*
-	 * Fills the csrow struct
+	 * Alocate and fill the csrow/channels structs
 	 */
+	mci->csrows = kzalloc(sizeof(*mci->csrows) * tot_csrows, GFP_KERNEL);
+	if (!mci->csrows)
+		goto error;
 	for (row = 0; row < tot_csrows; row++) {
-		csr = &csi[row];
+		csr = kzalloc(sizeof(**mci->csrows), GFP_KERNEL);
+		if (!csr)
+			goto error;
+		mci->csrows[row] = csr;
 		csr->csrow_idx = row;
 		csr->mci = mci;
 		csr->nr_channels = tot_cschannels;
-		chp = &chi[row * tot_cschannels];
-		csr->channels = chp;
+		csr->channels = kzalloc(sizeof(*csr->channels) * tot_cschannels,
+					GFP_KERNEL);
 
 		for (chn = 0; chn < tot_cschannels; chn++) {
-			chan = &chp[chn];
+			chan = kzalloc(sizeof(**csr->channels), GFP_KERNEL);
+			if (!chan)
+				goto error;
+			csr->channels[chn] = chan;
 			chan->chan_idx = chn;
 			chan->csrow = csr;
 		}
 	}
 
 	/*
-	 * Fills the dimm struct
+	 * Allocate and fill the dimm structs
 	 */
+	mci->dimms  = kzalloc(sizeof(*mci->dimms) * tot_dimms, GFP_KERNEL);
+	if (!mci->dimms)
+		goto error;
+
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
 	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
 		per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
-		chan = &csi[row].channels[chn];
-		dimm = GET_POS(lay, mci->dimms, n_layers,
-			       pos[0], pos[1], pos[2]);
+		chan = mci->csrows[row]->channels[chn];
+		off = GET_OFFSET(lay, n_layers, pos[0], pos[1], pos[2]);
+		if (off < 0 || off >= tot_dimms)
+			goto error;
+
+		dimm = kzalloc(sizeof(**mci->dimms), GFP_KERNEL);
+		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		debugf2("%s: %d: %s%zd (%d:%d:%d): row %d, chan %d\n", __func__,
-			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
+		debugf2("%s: %d: %s%i (%d:%d:%d): row %d, chan %d\n", __func__,
+			i, per_rank ? "rank" : "dimm", off,
 			pos[0], pos[1], pos[2], row, chn);
 
 		/*
@@ -391,7 +401,31 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 
 	trace_hw_event_init("edac", (unsigned)edac_index);
 
+	debugf1("EDAC MCI allocated\n");
 	return mci;
+
+error:
+	debugf1("Failed to allocate one or more EDAC MCI structs\n");
+	if (mci->dimms) {
+		for (i = 0; i < tot_dimms; i++)
+			kfree(mci->dimms[i]);
+		kfree(mci->dimms);
+	}
+	if (mci->csrows) {
+		for (chn = 0; chn < tot_cschannels; chn++) {
+			csr = mci->csrows[chn];
+			if (csr) {
+				for (chn = 0; chn < tot_cschannels; chn++)
+					kfree(csr->channels[chn]);
+				kfree(csr);
+			}
+			kfree(mci->csrows[i]);
+		}
+		kfree(mci->csrows);
+	}
+	kfree(mci);
+
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
 
@@ -404,10 +438,8 @@ void edac_mc_free(struct mem_ctl_info *mci)
 {
 	debugf1("%s()\n", __func__);
 
+	/* the mci instance is freed here, when the sysfs object is dropped */
 	edac_unregister_sysfs(mci);
-
-	/* free the mci instance memory here */
-	kfree(mci);
 }
 EXPORT_SYMBOL_GPL(edac_mc_free);
 
@@ -679,13 +711,12 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		for (i = 0; i < mci->nr_csrows; i++) {
 			int j;
 
-			edac_mc_dump_csrow(&mci->csrows[i]);
-			for (j = 0; j < mci->csrows[i].nr_channels; j++)
-				edac_mc_dump_channel(&mci->csrows[i].
-						channels[j]);
+			edac_mc_dump_csrow(mci->csrows[i]);
+			for (j = 0; j < mci->csrows[i]->nr_channels; j++)
+				edac_mc_dump_channel(mci->csrows[i]->channels[j]);
 		}
 		for (i = 0; i < mci->tot_dimms; i++)
-			edac_mc_dump_dimm(&mci->dimms[i]);
+			edac_mc_dump_dimm(mci->dimms[i]);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
@@ -804,17 +835,17 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 /* FIXME - should return -1 */
 int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 {
-	struct csrow_info *csrows = mci->csrows;
+	struct csrow_info **csrows = mci->csrows;
 	int row, i, j, n;
 
 	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
 	row = -1;
 
 	for (i = 0; i < mci->nr_csrows; i++) {
-		struct csrow_info *csrow = &csrows[i];
+		struct csrow_info *csrow = csrows[i];
 		n = 0;
 		for (j = 0; j < csrow->nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 			n += dimm->nr_pages;
 		}
 		if (n == 0)
@@ -967,7 +998,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	p = label;
 	*p = '\0';
 	for (i = 0; i < mci->tot_dimms; i++) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 
 		if (layer0 >= 0 && layer0 != dimm->location[0])
 			continue;
@@ -1020,13 +1051,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			strcpy(label, "unknown memory");
 		if (type == HW_EVENT_ERR_CORRECTED) {
 			if (row >= 0) {
-				mci->csrows[row].ce_count++;
+				mci->csrows[row]->ce_count++;
 				if (chan >= 0)
-					mci->csrows[row].channels[chan].ce_count++;
+					mci->csrows[row]->channels[chan]->ce_count++;
 			}
 		} else
 			if (row >= 0)
-				mci->csrows[row].ue_count++;
+				mci->csrows[row]->ue_count++;
 	}
 
 	/* Fill the RAM location data */
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 022f50a..81ca073 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -82,7 +82,7 @@ module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_int,
 		  &edac_mc_poll_msec, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
-static struct device mci_pdev;
+static struct device *mci_pdev;
 
 /*
  * various constants for Memory Controllers
@@ -181,7 +181,7 @@ static ssize_t csrow_size_show(struct device *dev,
 	u32 nr_pages = 0;
 
 	for (i = 0; i < csrow->nr_channels; i++)
-		nr_pages += csrow->channels[i].dimm->nr_pages;
+		nr_pages += csrow->channels[i]->dimm->nr_pages;
 	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
 }
 
@@ -190,7 +190,7 @@ static ssize_t csrow_mem_type_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", mem_types[csrow->channels[0].dimm->mtype]);
+	return sprintf(data, "%s\n", mem_types[csrow->channels[0]->dimm->mtype]);
 }
 
 static ssize_t csrow_dev_type_show(struct device *dev,
@@ -198,7 +198,7 @@ static ssize_t csrow_dev_type_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", dev_types[csrow->channels[0].dimm->dtype]);
+	return sprintf(data, "%s\n", dev_types[csrow->channels[0]->dimm->dtype]);
 }
 
 static ssize_t csrow_edac_mode_show(struct device *dev,
@@ -207,7 +207,7 @@ static ssize_t csrow_edac_mode_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", edac_caps[csrow->channels[0].dimm->edac_mode]);
+	return sprintf(data, "%s\n", edac_caps[csrow->channels[0]->dimm->edac_mode]);
 }
 
 /* show/store functions for DIMM Label attributes */
@@ -217,7 +217,7 @@ static ssize_t channel_dimm_label_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 	unsigned chan = to_channel(mattr);
-	struct rank_info *rank = &csrow->channels[chan];
+	struct rank_info *rank = csrow->channels[chan];
 
 	/* if field has not been initialized, there is nothing to send */
 	if (!rank->dimm->label[0])
@@ -233,7 +233,7 @@ static ssize_t channel_dimm_label_store(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 	unsigned chan = to_channel(mattr);
-	struct rank_info *rank = &csrow->channels[chan];
+	struct rank_info *rank = csrow->channels[chan];
 
 	ssize_t max_size = 0;
 
@@ -250,7 +250,7 @@ static ssize_t channel_ce_count_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 	unsigned chan = to_channel(mattr);
-	struct rank_info *rank = &csrow->channels[chan];
+	struct rank_info *rank = csrow->channels[chan];
 
 	return sprintf(data, "%u\n", rank->ce_count);
 }
@@ -283,9 +283,12 @@ static const struct attribute_group *csrow_attr_groups[] = {
 	NULL
 };
 
-static void csrow_attr_release(struct device *device)
+static void csrow_attr_release(struct device *dev)
 {
-	debugf1("Releasing csrow device %s\n", dev_name(device));
+	struct csrow_info *csrow = container_of(dev, struct csrow_info, dev);
+
+	debugf1("Releasing csrow device %s\n", dev_name(dev));
+	kfree(csrow);
 }
 
 static struct device_type csrow_attr_type = {
@@ -352,7 +355,7 @@ static inline int nr_pages_per_csrow(struct csrow_info *csrow)
 	int chan, nr_pages = 0;
 
 	for (chan = 0; chan < csrow->nr_channels; chan++)
-		nr_pages += csrow->channels[chan].dimm->nr_pages;
+		nr_pages += csrow->channels[chan]->dimm->nr_pages;
 
 	return nr_pages;
 }
@@ -382,7 +385,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 
 	for (chan = 0; chan < csrow->nr_channels; chan++) {
 		/* Only expose populated DIMMs */
-		if (!csrow->channels[chan].dimm->nr_pages)
+		if (!csrow->channels[chan]->dimm->nr_pages)
 			continue;
 		err = device_create_file(&csrow->dev,
 					 dynamic_csrow_dimm_attr[chan]);
@@ -418,10 +421,10 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 
 	for (i = 0; i < mci->nr_csrows; i++) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
-		err = edac_create_csrow_object(mci, &mci->csrows[i], i);
+		err = edac_create_csrow_object(mci, mci->csrows[i], i);
 		if (err < 0)
 			goto error;
 	}
@@ -429,18 +432,18 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 
 error:
 	for (--i; i >= 0; i--) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
-			if (!csrow->channels[chan].dimm->nr_pages)
+			if (!csrow->channels[chan]->dimm->nr_pages)
 				continue;
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_dimm_attr[chan]);
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_ce_count_attr[chan]);
 		}
-		put_device(&mci->csrows[i].dev);
+		put_device(&mci->csrows[i]->dev);
 	}
 
 	return err;
@@ -452,11 +455,11 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 
 	for (i = mci->nr_csrows - 1; i >= 0; i--) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
-			if (!csrow->channels[chan].dimm->nr_pages)
+			if (!csrow->channels[chan]->dimm->nr_pages)
 				continue;
 			debugf1("Removing csrow %d channel %d sysfs nodes\n",
 				i, chan);
@@ -465,8 +468,8 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_ce_count_attr[chan]);
 		}
-		put_device(&mci->csrows[i].dev);
-		device_del(&mci->csrows[i].dev);
+		put_device(&mci->csrows[i]->dev);
+		device_del(&mci->csrows[i]->dev);
 	}
 }
 #endif
@@ -585,9 +588,12 @@ static const struct attribute_group *dimm_attr_groups[] = {
 	NULL
 };
 
-static void dimm_attr_release(struct device *device)
+static void dimm_attr_release(struct device *dev)
 {
-	debugf1("Releasing dimm device %s\n", dev_name(device));
+	struct dimm_info *dimm = container_of(dev, struct dimm_info, dev);
+
+	debugf1("Releasing dimm device %s\n", dev_name(dev));
+	kfree(dimm);
 }
 
 static struct device_type dimm_attr_type = {
@@ -641,13 +647,13 @@ static ssize_t mci_reset_counters_store(struct device *dev,
 	mci->ce_noinfo_count = 0;
 
 	for (row = 0; row < mci->nr_csrows; row++) {
-		struct csrow_info *ri = &mci->csrows[row];
+		struct csrow_info *ri = mci->csrows[row];
 
 		ri->ue_count = 0;
 		ri->ce_count = 0;
 
 		for (chan = 0; chan < ri->nr_channels; chan++)
-			ri->channels[chan].ce_count = 0;
+			ri->channels[chan]->ce_count = 0;
 	}
 
 	cnt = 1;
@@ -779,10 +785,10 @@ static ssize_t mci_size_mb_show(struct device *dev,
 	int total_pages = 0, csrow_idx, j;
 
 	for (csrow_idx = 0; csrow_idx < mci->nr_csrows; csrow_idx++) {
-		struct csrow_info *csrow = &mci->csrows[csrow_idx];
+		struct csrow_info *csrow = mci->csrows[csrow_idx];
 
 		for (j = 0; j < csrow->nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 
 			total_pages += dimm->nr_pages;
 		}
@@ -889,9 +895,12 @@ static const struct attribute_group *mci_attr_groups[] = {
 	NULL
 };
 
-static void mci_attr_release(struct device *device)
+static void mci_attr_release(struct device *dev)
 {
-	debugf1("Releasing mci device %s\n", dev_name(device));
+	struct mem_ctl_info *mci = container_of(dev, struct mem_ctl_info, dev);
+
+	debugf1("Releasing csrow device %s\n", dev_name(dev));
+	kfree(mci);
 }
 
 static struct device_type mci_attr_type = {
@@ -950,29 +959,28 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 {
 	int i, err;
 
-	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
+	/*
+	 * The memory controller needs its own bus, in order to avoid
+	 * namespace conflicts at /sys/bus/edac.
+	 */
+	mci->bus.name = kasprintf(GFP_KERNEL, "mc%d", mci->mc_idx);
+	if (!mci->bus.name)
+		return -ENOMEM;
+	debugf0("creating bus %s\n",mci->bus.name);
+	err = bus_register(&mci->bus);
+	if (err < 0)
+		return err;
 
 	/* get the /sys/devices/system/edac subsys reference */
-
 	mci->dev.type = &mci_attr_type;
 	device_initialize(&mci->dev);
 
-	mci->dev.parent = &mci_pdev;
+	mci->dev.parent = mci_pdev;
 	mci->dev.bus = &mci->bus;
 	dev_set_name(&mci->dev, "mc%d", mci->mc_idx);
 	dev_set_drvdata(&mci->dev, mci);
 	pm_runtime_forbid(&mci->dev);
 
-	/*
-	 * The memory controller needs its own bus, in order to avoid
-	 * namespace conflicts at /sys/bus/edac.
-	 */
-	debugf0("creating bus %s\n",mci->bus.name);
-	mci->bus.name = kstrdup(dev_name(&mci->dev), GFP_KERNEL);
-	err = bus_register(&mci->bus);
-	if (err < 0)
-		return err;
-
 	debugf0("%s(): creating device %s\n", __func__,
 		dev_name(&mci->dev));
 	err = device_add(&mci->dev);
@@ -986,7 +994,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	 * Create the dimm/rank devices
 	 */
 	for (i = 0; i < mci->tot_dimms; i++) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 		/* Only expose populated DIMMs */
 		if (dimm->nr_pages == 0)
 			continue;
@@ -1023,7 +1031,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 
 fail:
 	for (i--; i >= 0; i--) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
 		put_device(&dimm->dev);
@@ -1053,7 +1061,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 #endif
 
 	for (i = 0; i < mci->tot_dimms; i++) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
 		debugf0("%s(): removing device %s\n", __func__,
@@ -1072,9 +1080,15 @@ void edac_unregister_sysfs(struct mem_ctl_info *mci)
 	kfree(mci->bus.name);
 }
 
-static void mc_attr_release(struct device *device)
+static void mc_attr_release(struct device *dev)
 {
-	debugf1("Releasing device %s\n", dev_name(device));
+	/*
+	 * There's no container structure here, as this is just the mci
+	 * parent device, used to create the /sys/devices/mc sysfs node.
+	 * So, there are no attributes on it.
+	 */
+	debugf1("Releasing device %s\n", dev_name(dev));
+	kfree(dev);
 }
 
 static struct device_type mc_attr_type = {
@@ -1095,21 +1109,25 @@ int __init edac_mc_sysfs_init(void)
 		return -EINVAL;
 	}
 
-	mci_pdev.bus = edac_subsys;
-	mci_pdev.type = &mc_attr_type;
-	device_initialize(&mci_pdev);
-	dev_set_name(&mci_pdev, "mc");
+	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
+
+	mci_pdev->bus = edac_subsys;
+	mci_pdev->type = &mc_attr_type;
+	device_initialize(mci_pdev);
+	dev_set_name(mci_pdev, "mc");
 
-	err = device_add(&mci_pdev);
+	err = device_add(mci_pdev);
 	if (err < 0)
 		return err;
 
+	debugf0("device %s created\n", dev_name(mci_pdev));
+
 	return 0;
 }
 
 void __exit edac_mc_sysfs_exit(void)
 {
-	put_device(&mci_pdev);
-	device_del(&mci_pdev);
+	put_device(mci_pdev);
+	device_del(mci_pdev);
 	edac_put_sysfs_subsys();
 }
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 2ee50ab..15df2bc 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -236,7 +236,7 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	int row, multi_chan, channel;
 	unsigned long pfn, offset;
 
-	multi_chan = mci->csrows[0].nr_channels - 1;
+	multi_chan = mci->csrows[0]->nr_channels - 1;
 
 	if (!(info->errsts & I3000_ERRSTS_BITS))
 		return 0;
@@ -393,7 +393,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	for (last_cumul_size = i = 0; i < mci->nr_csrows; i++) {
 		u8 value;
 		u32 cumul_size;
-		struct csrow_info *csrow = &mci->csrows[i];
+		struct csrow_info *csrow = mci->csrows[i];
 
 		value = drb[i];
 		cumul_size = value << (I3000_DRB_SHIFT - PAGE_SHIFT);
@@ -410,7 +410,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 		last_cumul_size = cumul_size;
 
 		for (j = 0; j < nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 
 			dimm->nr_pages = nr_pages / nr_channels;
 			dimm->grain = I3000_DEAP_GRAIN;
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 798fb65..acb5d39 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -379,7 +379,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	for (i = 0; i < mci->nr_csrows; i++) {
 		unsigned long nr_pages;
-		struct csrow_info *csrow = &mci->csrows[i];
+		struct csrow_info *csrow = mci->csrows[i];
 
 		nr_pages = drb_to_nr_pages(drbs, stacked,
 			i / I3200_RANKS_PER_CHANNEL,
@@ -389,7 +389,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 			continue;
 
 		for (j = 0; j < nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 
 			dimm->nr_pages = nr_pages / nr_channels;
 			dimm->grain = nr_pages << PAGE_SHIFT;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index a16a2b5..74b64c6 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1203,8 +1203,8 @@ static int i5400_init_dimms(struct mem_ctl_info *mci)
 
 			size_mb =  pvt->dimm_info[slot][channel].megabytes;
 
-			debugf2("%s: dimm%zd (branch %d channel %d slot %d): %d.%03d GB\n",
-				__func__, dimm - mci->dimms,
+			debugf2("%s: dimm (branch %d channel %d slot %d): %d.%03d GB\n",
+				__func__,
 				channel / 2, channel % 2, slot,
 				size_mb / 1000, size_mb % 1000);
 
@@ -1227,7 +1227,7 @@ static int i5400_init_dimms(struct mem_ctl_info *mci)
 	 * With such single-DIMM mode, the SDCC algorithm degrades to SECDEC+.
 	 */
 	if (ndimms == 1)
-		mci->dimms[0].edac_mode = EDAC_SECDED;
+		mci->dimms[0]->edac_mode = EDAC_SECDED;
 
 	return (ndimms == 0);
 }
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 4c572545..877ba54 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -197,8 +197,8 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 	pci_read_config_byte(pdev, I82443BXGX_DRAMC, &dramc);
 	row_high_limit_last = 0;
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
-		dimm = csrow->channels[0].dimm;
+		csrow = mci->csrows[index];
+		dimm = csrow->channels[0]->dimm;
 
 		pci_read_config_byte(pdev, I82443BXGX_DRB + index, &drbar);
 		debugf1("MC%d: %s: %s() Row=%d DRB = %#0x\n",
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 16a54bb..f493758 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -116,7 +116,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 
 	info->eap >>= PAGE_SHIFT;
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
-	dimm = mci->csrows[row].channels[0].dimm;
+	dimm = mci->csrows[row]->channels[0]->dimm;
 
 	if (info->errsts & 0x0002)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
@@ -161,8 +161,8 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 	 * in all eight rows.
 	 */
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
-		dimm = csrow->channels[0].dimm;
+		csrow = mci->csrows[index];
+		dimm = csrow->channels[0]->dimm;
 
 		pci_read_config_word(pdev, I82860_GBA + index * 2, &value);
 		cumul_size = (value & I82860_GBA_MASK) <<
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 9691449..a42a5bd 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -227,7 +227,7 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 {
 	int row, multi_chan;
 
-	multi_chan = mci->csrows[0].nr_channels - 1;
+	multi_chan = mci->csrows[0]->nr_channels - 1;
 
 	if (!(info->errsts & 0x0081))
 		return 0;
@@ -367,7 +367,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 	 */
 
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
+		csrow = mci->csrows[index];
 
 		value = readb(ovrfl_window + I82875P_DRB + index);
 		cumul_size = value << (I82875P_DRB_SHIFT - PAGE_SHIFT);
@@ -382,7 +382,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 		last_cumul_size = cumul_size;
 
 		for (j = 0; j < nr_chans; j++) {
-			dimm = csrow->channels[j].dimm;
+			dimm = csrow->channels[j]->dimm;
 
 			dimm->nr_pages = nr_pages / nr_chans;
 			dimm->grain = 1 << 12;	/* I82875P_EAP has 4KiB reolution */
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index df99606..717f208 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -308,10 +308,10 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned int) page);
 		return 0;
 	}
-	chan = (mci->csrows[row].nr_channels == 1) ? 0 : info->eap & 1;
+	chan = (mci->csrows[row]->nr_channels == 1) ? 0 : info->eap & 1;
 	offst = info->eap
 			& ((1 << PAGE_SHIFT) -
-			   (1 << mci->csrows[row].channels[chan].dimm->grain));
+			   (1 << mci->csrows[row]->channels[chan]->dimm->grain));
 
 	if (info->errsts & 0x0002)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
@@ -394,7 +394,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	 */
 
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
+		csrow = mci->csrows[index];
 
 		value = readb(mch_window + I82975X_DRB + index +
 					((index >= 4) ? 0x80 : 0));
@@ -421,10 +421,10 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 */
 		dtype = i82975x_dram_type(mch_window, index);
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			dimm = mci->csrows[index].channels[chan].dimm;
+			dimm = mci->csrows[index]->channels[chan]->dimm;
 
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
-			strncpy(csrow->channels[chan].dimm->label,
+			strncpy(csrow->channels[chan]->dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
 			dimm->grain = 1 << 7;	/* 128Byte cache-line resolution */
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index c67cca1..42e209c 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -825,7 +825,7 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 	pfn = err_addr >> PAGE_SHIFT;
 
 	for (row_index = 0; row_index < mci->nr_csrows; row_index++) {
-		csrow = &mci->csrows[row_index];
+		csrow = mci->csrows[row_index];
 		if ((pfn >= csrow->first_page) && (pfn <= csrow->last_page))
 			break;
 	}
@@ -945,8 +945,8 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 		u32 start;
 		u32 end;
 
-		csrow = &mci->csrows[index];
-		dimm = csrow->channels[0].dimm;
+		csrow = mci->csrows[index];
+		dimm = csrow->channels[0]->dimm;
 
 		cs_bnds = in_be32(pdata->mc_vbase + MPC85XX_MC_CS_BNDS_0 +
 				  (index * MPC85XX_MC_CS_BNDS_OFS));
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index ef0e710..87139ca 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -670,8 +670,8 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 
 	ctl = in_le32(pdata->mc_vbase + MV64X60_SDRAM_CONFIG);
 
-	csrow = &mci->csrows[0];
-	dimm = csrow->channels[0].dimm;
+	csrow = mci->csrows[0];
+	dimm = csrow->channels[0]->dimm;
 
 	dimm->nr_pages = pdata->total_mem >> PAGE_SHIFT;
 	dimm->grain = 8;
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 47542e7..634b919 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -111,14 +111,14 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 	if (errsta & (MCDEBUG_ERRSTA_MBE_STATUS |
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-				     mci->csrows[cs].first_page, 0, 0,
+				     mci->csrows[cs]->first_page, 0, 0,
 				     cs, 0, -1, mci->ctl_name, "", NULL);
 	}
 
 	/* correctable/single-bit errors */
 	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
-				     mci->csrows[cs].first_page, 0, 0,
+				     mci->csrows[cs]->first_page, 0, 0,
 				     cs, 0, -1, mci->ctl_name, "", NULL);
 }
 
@@ -141,8 +141,8 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 	int index;
 
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
-		dimm = csrow->channels[0].dimm;
+		csrow = mci->csrows[index];
+		dimm = csrow->channels[0]->dimm;
 
 		pci_read_config_dword(pdev,
 				      MCDRAM_RANKCFG + (index * 12),
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 10464c5..6a7a2ce 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -230,8 +230,8 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	row_high_limit_last = 0;
 
 	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = &mci->csrows[index];
-		dimm = csrow->channels[0].dimm;
+		csrow = mci->csrows[index];
+		dimm = csrow->channels[0]->dimm;
 
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_byte(pdev, R82600_DRBA + index, &drbar);
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 32cb2c7..4aecb06 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -84,10 +84,10 @@ static void tile_edac_check(struct mem_ctl_info *mci)
  */
 static int __devinit tile_edac_init_csrows(struct mem_ctl_info *mci)
 {
-	struct csrow_info	*csrow = &mci->csrows[0];
+	struct csrow_info	*csrow = mci->csrows[0];
 	struct tile_edac_priv	*priv = mci->pvt_info;
 	struct mshim_mem_info	mem_info;
-	struct dimm_info *dimm = csrow->channels[0].dimm;
+	struct dimm_info *dimm = csrow->channels[0]->dimm;
 
 	if (hv_dev_pread(priv->hv_devhdl, 0, (HV_VirtAddr)&mem_info,
 		sizeof(struct mshim_mem_info), MSHIM_MEM_INFO_OFF) !=
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index dde47e9..c5e54ef 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -378,7 +378,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	for (i = 0; i < mci->nr_csrows; i++) {
 		unsigned long nr_pages;
-		struct csrow_info *csrow = &mci->csrows[i];
+		struct csrow_info *csrow = mci->csrows[i];
 
 		nr_pages = drb_to_nr_pages(drbs, stacked,
 			i / X38_RANKS_PER_CHANNEL,
@@ -388,7 +388,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 			continue;
 
 		for (j = 0; j < x38_channel_num; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 
 			dimm->nr_pages = nr_pages / x38_channel_num;
 			dimm->grain = nr_pages << PAGE_SHIFT;
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 22c3fca..bec5bff 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -409,17 +409,28 @@ struct edac_mc_layer {
  * during the memory allocation routine, with would point to the developer
  * that he's doing something wrong.
  */
-#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
-	typeof(var) __p;						\
+
+#define GET_OFFSET(layers, nlayers, lay0, lay1, lay2) ({		\
+	int __i;								\
 	if ((nlayers) == 1)						\
-		__p = &var[lay0];					\
+		__i = lay0;						\
 	else if ((nlayers) == 2)					\
-		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
+		__i = (lay1) + ((layers[1]).size * (lay0));		\
 	else if ((nlayers) == 3)					\
-		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
-			    ((layers[1]).size * (lay0))))];		\
+		__i = (lay2) + ((layers[2]).size * ((lay1) +		\
+			    ((layers[1]).size * (lay0))));		\
 	else								\
+		__i = -EINVAL;						\
+	__i;								\
+})
+
+#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
+	typeof(*var) __p;						\
+	int ___i = GET_OFFSET(layers, nlayers, lay0, lay1, lay2);	\
+	if (___i < 0)							\
 		__p = NULL;						\
+	else								\
+		__p = (var)[___i];					\
 	__p;								\
 })
 
@@ -459,8 +470,6 @@ struct dimm_info {
  *	  patches in this series will fix this issue.
  */
 struct rank_info {
-	struct device dev;
-
 	int chan_idx;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
@@ -486,7 +495,7 @@ struct csrow_info {
 
 	/* channel information for this csrow */
 	u32 nr_channels;
-	struct rank_info *channels;
+	struct rank_info **channels;
 };
 
 /*
@@ -550,7 +559,7 @@ struct mem_ctl_info {
 	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
 					   unsigned long page);
 	int mc_idx;
-	struct csrow_info *csrows;
+	struct csrow_info **csrows;
 	unsigned nr_csrows, num_cschannel;
 
 	/*
@@ -570,7 +579,7 @@ struct mem_ctl_info {
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
 	unsigned tot_dimms;
-	struct dimm_info *dimms;
+	struct dimm_info **dimms;
 
 	/*
 	 * FIXME - what about controllers on other busses? - IDs must be
-- 
1.7.8

