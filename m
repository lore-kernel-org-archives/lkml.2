Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2DPUaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:30:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 13/26] i7core_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:32 -0300
Message-Id: <1334607705-30320-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |  202 +++++++++++---------------------------------
 1 files changed, 50 insertions(+), 152 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index d566797..8bcee03 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -257,7 +257,6 @@ struct i7core_pvt {
 	struct i7core_channel	channel[NUM_CHANS];
 
 	int		ce_count_available;
-	int 		csrow_map[NUM_CHANS][MAX_DIMMS];
 
 			/* ECC corrected errors counts per udimm */
 	unsigned long	udimm_ce_count[MAX_DIMMS];
@@ -492,113 +491,12 @@ static void free_i7core_dev(struct i7core_dev *i7core_dev)
 /****************************************************************************
 			Memory check routines
  ****************************************************************************/
-static struct pci_dev *get_pdev_slot_func(u8 socket, unsigned slot,
-					  unsigned func)
-{
-	struct i7core_dev *i7core_dev = get_i7core_dev(socket);
-	int i;
-
-	if (!i7core_dev)
-		return NULL;
-
-	for (i = 0; i < i7core_dev->n_devs; i++) {
-		if (!i7core_dev->pdev[i])
-			continue;
-
-		if (PCI_SLOT(i7core_dev->pdev[i]->devfn) == slot &&
-		    PCI_FUNC(i7core_dev->pdev[i]->devfn) == func) {
-			return i7core_dev->pdev[i];
-		}
-	}
-
-	return NULL;
-}
-
-/**
- * i7core_get_active_channels() - gets the number of channels and csrows
- * @socket:	Quick Path Interconnect socket
- * @channels:	Number of channels that will be returned
- * @csrows:	Number of csrows found
- *
- * Since EDAC core needs to know in advance the number of available channels
- * and csrows, in order to allocate memory for csrows/channels, it is needed
- * to run two similar steps. At the first step, implemented on this function,
- * it checks the number of csrows/channels present at one socket.
- * this is used in order to properly allocate the size of mci components.
- *
- * It should be noticed that none of the current available datasheets explain
- * or even mention how csrows are seen by the memory controller. So, we need
- * to add a fake description for csrows.
- * So, this driver is attributing one DIMM memory for one csrow.
- */
-static int i7core_get_active_channels(const u8 socket, unsigned *channels,
-				      unsigned *csrows)
-{
-	struct pci_dev *pdev = NULL;
-	int i, j;
-	u32 status, control;
-
-	*channels = 0;
-	*csrows = 0;
-
-	pdev = get_pdev_slot_func(socket, 3, 0);
-	if (!pdev) {
-		i7core_printk(KERN_ERR, "Couldn't find socket %d fn 3.0!!!\n",
-			      socket);
-		return -ENODEV;
-	}
-
-	/* Device 3 function 0 reads */
-	pci_read_config_dword(pdev, MC_STATUS, &status);
-	pci_read_config_dword(pdev, MC_CONTROL, &control);
-
-	for (i = 0; i < NUM_CHANS; i++) {
-		u32 dimm_dod[3];
-		/* Check if the channel is active */
-		if (!(control & (1 << (8 + i))))
-			continue;
-
-		/* Check if the channel is disabled */
-		if (status & (1 << i))
-			continue;
-
-		pdev = get_pdev_slot_func(socket, i + 4, 1);
-		if (!pdev) {
-			i7core_printk(KERN_ERR, "Couldn't find socket %d "
-						"fn %d.%d!!!\n",
-						socket, i + 4, 1);
-			return -ENODEV;
-		}
-		/* Devices 4-6 function 1 */
-		pci_read_config_dword(pdev,
-				MC_DOD_CH_DIMM0, &dimm_dod[0]);
-		pci_read_config_dword(pdev,
-				MC_DOD_CH_DIMM1, &dimm_dod[1]);
-		pci_read_config_dword(pdev,
-				MC_DOD_CH_DIMM2, &dimm_dod[2]);
-
-		(*channels)++;
-
-		for (j = 0; j < 3; j++) {
-			if (!DIMM_PRESENT(dimm_dod[j]))
-				continue;
-			(*csrows)++;
-		}
-	}
-
-	debugf0("Number of active channels on socket %d: %d\n",
-		socket, *channels);
-
-	return 0;
-}
 
 static int get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	struct csrow_info *csr;
 	struct pci_dev *pdev;
 	int i, j;
-	int csrow = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
 	struct dimm_info *dimm;
@@ -696,6 +594,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			if (!DIMM_PRESENT(dimm_dod[j]))
 				continue;
 
+			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+				       i, j, 0);
 			banks = numbank(MC_DOD_NUMBANK(dimm_dod[j]));
 			ranks = numrank(MC_DOD_NUMRANK(dimm_dod[j]));
 			rows = numrow(MC_DOD_NUMROW(dimm_dod[j]));
@@ -704,8 +604,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			/* DDR3 has 8 I/O banks */
 			size = (rows * cols * banks * ranks) >> (20 - 3);
 
-			pvt->channel[i].dimms++;
-
 			debugf0("\tdimm %d %d Mb offset: %x, "
 				"bank: %d, rank: %d, row: %#x, col: %#x\n",
 				j, size,
@@ -714,11 +612,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 			npages = MiB_TO_PAGES(size);
 
-			csr = &mci->csrows[csrow];
-
-			pvt->csrow_map[i][j] = csrow;
-
-			dimm = csr->channels[0].dimm;
 			dimm->nr_pages = npages;
 
 			switch (banks) {
@@ -741,7 +634,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			dimm->grain = 8;
 			dimm->edac_mode = mode;
 			dimm->mtype = mtype;
-			csrow++;
 		}
 
 		pci_read_config_dword(pdev, MC_SAG_CH_0, &value[0]);
@@ -1557,22 +1449,16 @@ error:
 /****************************************************************************
 			Error check routines
  ****************************************************************************/
-static void i7core_rdimm_update_csrow(struct mem_ctl_info *mci,
+static void i7core_rdimm_update_errcount(struct mem_ctl_info *mci,
 				      const int chan,
 				      const int dimm,
 				      const int add)
 {
-	char *msg;
-	struct i7core_pvt *pvt = mci->pvt_info;
-	int row = pvt->csrow_map[chan][dimm], i;
+	int i;
 
 	for (i = 0; i < add; i++) {
-		msg = kasprintf(GFP_KERNEL, "Corrected error "
-				"(Socket=%d channel=%d dimm=%d)",
-				pvt->i7core_dev->socket, chan, dimm);
-
-		edac_mc_handle_fbd_ce(mci, row, 0, msg);
-		kfree (msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				     chan, dimm, -1, "error", "", NULL);
 	}
 }
 
@@ -1613,11 +1499,11 @@ static void i7core_rdimm_update_ce_count(struct mem_ctl_info *mci,
 
 	/*updated the edac core */
 	if (add0 != 0)
-		i7core_rdimm_update_csrow(mci, chan, 0, add0);
+		i7core_rdimm_update_errcount(mci, chan, 0, add0);
 	if (add1 != 0)
-		i7core_rdimm_update_csrow(mci, chan, 1, add1);
+		i7core_rdimm_update_errcount(mci, chan, 1, add1);
 	if (add2 != 0)
-		i7core_rdimm_update_csrow(mci, chan, 2, add2);
+		i7core_rdimm_update_errcount(mci, chan, 2, add2);
 
 }
 
@@ -1738,19 +1624,29 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	char *type, *optype, *err, *msg;
+	enum hw_event_mc_err_type tp_event;
 	unsigned long error = m->status & 0x1ff0000l;
+	bool uncorrected_error = m->mcgstatus & 1ll << 61;
+	bool ripv = m->mcgstatus & 1;
 	u32 optypenum = (m->status >> 4) & 0x07;
 	u32 core_err_cnt = (m->status >> 38) & 0x7fff;
 	u32 dimm = (m->misc >> 16) & 0x3;
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;
 	u32 errnum = find_first_bit(&error, 32);
-	int csrow;
 
-	if (m->mcgstatus & 1)
-		type = "FATAL";
-	else
-		type = "NON_FATAL";
+	if (uncorrected_error) {
+		if (ripv) {
+			type = "FATAL";
+			tp_event = HW_EVENT_ERR_FATAL;
+		} else {
+			type = "NON_FATAL";
+			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		}
+	} else {
+		type = "CORRECTED";
+		tp_event = HW_EVENT_ERR_CORRECTED;
+	}
 
 	switch (optypenum) {
 	case 0:
@@ -1805,25 +1701,23 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	/* FIXME: should convert addr into bank and rank information */
 	msg = kasprintf(GFP_ATOMIC,
-		"%s (addr = 0x%08llx, cpu=%d, Dimm=%d, Channel=%d, "
-		"syndrome=0x%08x, count=%d, Err=%08llx:%08llx (%s: %s))\n",
-		type, (long long) m->addr, m->cpu, dimm, channel,
-		syndrome, core_err_cnt, (long long)m->status,
-		(long long)m->misc, optype, err);
+		"addr=0x%08llx cpu=%d count=%d Err=%08llx:%08llx (%s: %s))\n",
+		(long long) m->addr, m->cpu, core_err_cnt,
+		(long long)m->status, (long long)m->misc, optype, err);
 
-	debugf0("%s", msg);
-
-	csrow = pvt->csrow_map[channel][dimm];
-
-	/* Call the helper to output message */
-	if (m->mcgstatus & 1)
-		edac_mc_handle_fbd_ue(mci, csrow, 0,
-				0 /* FIXME: should be channel here */, msg);
-	else if (!pvt->is_registered)
-		edac_mc_handle_fbd_ce(mci, csrow,
-				0 /* FIXME: should be channel here */, msg);
+	/*
+	 * Call the helper to output message
+	 * FIXME: what to do if core_err_cnt > 1? Currently, it generates
+	 * only one event
+	 */
+	if (uncorrected_error || !pvt->is_registered)
+		edac_mc_handle_error(tp_event, mci,
+				     m->addr >> PAGE_SHIFT,
+				     m->addr & ~PAGE_MASK,
+				     syndrome,
+				     channel, dimm, -1,
+				     err, msg, m);
 
 	kfree(msg);
 }
@@ -2242,15 +2136,19 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 {
 	struct mem_ctl_info *mci;
 	struct i7core_pvt *pvt;
-	int rc, channels, csrows;
-
-	/* Check the number of active and not disabled channels */
-	rc = i7core_get_active_channels(i7core_dev->socket, &channels, &csrows);
-	if (unlikely(rc < 0))
-		return rc;
+	int rc;
+	struct edac_mc_layer layers[2];
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), csrows, channels, i7core_dev->socket);
+
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = NUM_CHANS;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = MAX_DIMMS;
+	layers[1].is_csrow = true;
+	mci = new_edac_mc_alloc(i7core_dev->socket, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*pvt));
 	if (unlikely(!mci))
 		return -ENOMEM;
 
-- 
1.7.8

