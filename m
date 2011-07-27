Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1G0Vie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:38:34 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23399 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1G0Vic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:38:32 -0400
Subject: [PATCH 1/2] cciss: Adds simple mode functionality
To: axboe@kernel.dk
From: Joe Handzik <joseph.t.handzik@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        scameron@beardog.cce.hp.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, thenzl@redhat.com
Date: Wed, 27 Jul 2011 16:38:30 -0500
Message-ID: <20110727213830.13453.15208.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Handzik <joseph.t.handzik@beardog.cce.hp.com>

Signed-off-by: Joseph Handzik <joseph.t.handzik@beardog.cce.hp.com>
---
 Documentation/blockdev/cciss.txt |   10 +++++++
 drivers/block/cciss.c            |   56 +++++++++++++++++++++++++++++++-------
 drivers/block/cciss.h            |    1 +
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/Documentation/blockdev/cciss.txt b/Documentation/blockdev/cciss.txt
index c00c6a5..71464e0 100644
--- a/Documentation/blockdev/cciss.txt
+++ b/Documentation/blockdev/cciss.txt
@@ -78,6 +78,16 @@ The device naming scheme is:
 /dev/cciss/c1d1p2		Controller 1, disk 1, partition 2
 /dev/cciss/c1d1p3		Controller 1, disk 1, partition 3
 
+CCISS simple mode support
+-------------------------
+
+The "cciss_simple_mode=1" boot parameter may be used to prevent the driver
+from putting the controller into "performant" mode. The difference is that
+with simple mode, each command completion requires an interrupt, while with
+"performant mode" (the default, and ordinarily better performing) it is
+possible to have multiple command completions indicated by a single
+interrupt.
+
 SCSI tape drive and medium changer support
 ------------------------------------------
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..61f0b5b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -68,6 +68,10 @@ static int cciss_tape_cmds = 6;
 module_param(cciss_tape_cmds, int, 0644);
 MODULE_PARM_DESC(cciss_tape_cmds,
 	"number of commands to allocate for tape devices (default: 6)");
+static int cciss_simple_mode;
+module_param(cciss_simple_mode, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(cciss_simple_mode,
+	"Use 'simple mode' rather than 'performant mode'");
 
 static DEFINE_MUTEX(cciss_mutex);
 static struct proc_dir_entry *proc_cciss;
@@ -176,6 +180,7 @@ static void cciss_geometry_inquiry(ctlr_info_t *h, int logvol,
 			unsigned int block_size, InquiryData_struct *inq_buff,
 				   drive_info_struct *drv);
 static void __devinit cciss_interrupt_mode(ctlr_info_t *);
+static int __devinit cciss_enter_simple_mode(struct ctlr_info *h);
 static void start_io(ctlr_info_t *h);
 static int sendcmd_withirq(ctlr_info_t *h, __u8 cmd, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
@@ -388,7 +393,7 @@ static void cciss_seq_show_header(struct seq_file *seq)
 		h->product_name,
 		(unsigned long)h->board_id,
 		h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
-		h->firm_ver[3], (unsigned int)h->intr[PERF_MODE_INT],
+		h->firm_ver[3], (unsigned int)h->intr[h->intr_mode],
 		h->num_luns,
 		h->Qdepth, h->commands_outstanding,
 		h->maxQsinceinit, h->max_outstanding, h->maxSG);
@@ -3984,6 +3989,9 @@ static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 {
 	__u32 trans_support;
 
+	if (cciss_simple_mode)
+		return;
+
 	dev_dbg(&h->pdev->dev, "Trying to put board into Performant mode\n");
 	/* Attempt to put controller into performant mode if supported */
 	/* Does board support performant mode? */
@@ -4081,7 +4089,7 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *h)
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	h->intr[PERF_MODE_INT] = h->pdev->irq;
+	h->intr[h->intr_mode] = h->pdev->irq;
 	return;
 }
 
@@ -4341,6 +4349,9 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
 	}
 	cciss_enable_scsi_prefetch(h);
 	cciss_p600_dma_prefetch_quirk(h);
+	err = cciss_enter_simple_mode(h);
+	if (err)
+		goto err_out_free_res;
 	cciss_put_controller_into_performant_mode(h);
 	return 0;
 
@@ -4843,20 +4854,20 @@ static int cciss_request_irq(ctlr_info_t *h,
 	irqreturn_t (*intxhandler)(int, void *))
 {
 	if (h->msix_vector || h->msi_vector) {
-		if (!request_irq(h->intr[PERF_MODE_INT], msixhandler,
+		if (!request_irq(h->intr[h->intr_mode], msixhandler,
 				IRQF_DISABLED, h->devname, h))
 			return 0;
 		dev_err(&h->pdev->dev, "Unable to get msi irq %d"
-			" for %s\n", h->intr[PERF_MODE_INT],
+			" for %s\n", h->intr[h->intr_mode],
 			h->devname);
 		return -1;
 	}
 
-	if (!request_irq(h->intr[PERF_MODE_INT], intxhandler,
+	if (!request_irq(h->intr[h->intr_mode], intxhandler,
 			IRQF_DISABLED, h->devname, h))
 		return 0;
 	dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
-		h->intr[PERF_MODE_INT], h->devname);
+		h->intr[h->intr_mode], h->devname);
 	return -1;
 }
 
@@ -4887,7 +4898,7 @@ static void cciss_undo_allocations_after_kdump_soft_reset(ctlr_info_t *h)
 {
 	int ctlr = h->ctlr;
 
-	free_irq(h->intr[PERF_MODE_INT], h);
+	free_irq(h->intr[h->intr_mode], h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector)
 		pci_disable_msix(h->pdev);
@@ -4953,6 +4964,7 @@ reinit_after_soft_reset:
 	h = hba[i];
 	h->pdev = pdev;
 	h->busy_initializing = 1;
+	h->intr_mode = cciss_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
 	INIT_LIST_HEAD(&h->cmpQ);
 	INIT_LIST_HEAD(&h->reqQ);
 	mutex_init(&h->busy_shutting_down);
@@ -5009,7 +5021,7 @@ reinit_after_soft_reset:
 
 	dev_info(&h->pdev->dev, "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
 	       h->devname, pdev->device, pci_name(pdev),
-	       h->intr[PERF_MODE_INT], dac ? "" : " not");
+	       h->intr[h->intr_mode], dac ? "" : " not");
 
 	if (cciss_allocate_cmd_pool(h))
 		goto clean4;
@@ -5056,7 +5068,7 @@ reinit_after_soft_reset:
 		spin_lock_irqsave(&h->lock, flags);
 		h->access.set_intr_mask(h, CCISS_INTR_OFF);
 		spin_unlock_irqrestore(&h->lock, flags);
-		free_irq(h->intr[PERF_MODE_INT], h);
+		free_irq(h->intr[h->intr_mode], h);
 		rc = cciss_request_irq(h, cciss_msix_discard_completions,
 					cciss_intx_discard_completions);
 		if (rc) {
@@ -5133,7 +5145,7 @@ clean4:
 	cciss_free_cmd_pool(h);
 	cciss_free_scatterlists(h);
 	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
-	free_irq(h->intr[PERF_MODE_INT], h);
+	free_irq(h->intr[h->intr_mode], h);
 clean2:
 	unregister_blkdev(h->major, h->devname);
 clean1:
@@ -5172,9 +5184,31 @@ static void cciss_shutdown(struct pci_dev *pdev)
 	if (return_code != IO_OK)
 		dev_warn(&h->pdev->dev, "Error flushing cache\n");
 	h->access.set_intr_mask(h, CCISS_INTR_OFF);
-	free_irq(h->intr[PERF_MODE_INT], h);
+	free_irq(h->intr[h->intr_mode], h);
 }
 
+static int __devinit cciss_enter_simple_mode(struct ctlr_info *h)
+{
+	u32 trans_support;
+
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & SIMPLE_MODE))
+		return -ENOTSUPP;
+
+	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
+	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+	cciss_wait_for_mode_change_ack(h);
+	print_cfg_table(h);
+	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
+		dev_warn(&h->pdev->dev, "unable to get board into simple mode\n");
+		return -ENODEV;
+	}
+	h->transMethod = CFGTBL_Trans_Simple;
+	return 0;
+}
+
+
 static void __devexit cciss_remove_one(struct pci_dev *pdev)
 {
 	ctlr_info_t *h;
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 16b4d58..166fcd0 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -92,6 +92,7 @@ struct ctlr_info
 	unsigned int intr[4];
 	unsigned int msix_vector;
 	unsigned int msi_vector;
+	int	intr_mode;
 	int 	cciss_max_sectors;
 	BYTE	cciss_read;
 	BYTE	cciss_write;

