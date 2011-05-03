Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1ECUCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:02:54 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4693 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1ECUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:02:51 -0400
Subject: [PATCH 12/16] cciss: do soft reset if hard reset is broken
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:52 -0500
Message-ID: <20110503195352.5154.5183.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

on driver load, if reset_devices is set, and the hard reset
attempts fail, try to bring up the controller to the point that
a command can be sent, and send it a soft reset command, then
after the reset undo whatever driver initialization was done to get
it to the point to take a command, and re-do it after the reset.

This is to get kdump to work on all the "non-resettable" controllers
(except 64xx controllers which can't be reset due to the potentially
shared cache module.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |  236 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 221 insertions(+), 15 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index df58c59..23b0ba4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2477,6 +2477,31 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	return 0;
 }
 
+static int __devinit cciss_send_reset(ctlr_info_t *h, unsigned char *scsi3addr,
+	u8 reset_type)
+{
+	CommandList_struct *c;
+	int return_status;
+
+	c = cmd_alloc(h);
+	if (!c)
+		return -ENOMEM;
+	return_status = fill_cmd(h, c, CCISS_RESET_MSG, NULL, 0, 0,
+		CTLR_LUNID, TYPE_MSG);
+	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to target reset */
+	if (return_status != IO_OK) {
+		cmd_special_free(h, c);
+		return return_status;
+	}
+	c->waiting = NULL;
+	enqueue_cmd_and_start_io(h, c);
+	/* Don't wait for completion, the reset won't complete.  Don't free
+	 * the command either.  This is the last command we will send before
+	 * re-initializing everything, so it doesn't matter and won't leak.
+	 */
+	return 0;
+}
+
 static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 		size_t size, __u8 page_code, unsigned char *scsi3addr,
 		int cmd_type)
@@ -3463,6 +3488,63 @@ static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
 	return next_command(h);
 }
 
+/* Some controllers, like p400, will give us one interrupt
+ * after a soft reset, even if we turned interrupts off.
+ * Only need to check for this in the cciss_xxx_discard_completions
+ * functions.
+ */
+static int ignore_bogus_interrupt(ctlr_info_t *h)
+{
+	if (likely(!reset_devices))
+		return 0;
+
+	if (likely(h->interrupts_enabled))
+		return 0;
+
+	dev_info(&h->pdev->dev, "Received interrupt while interrupts disabled "
+		"(known firmware bug.)  Ignoring.\n");
+
+	return 1;
+}
+
+static irqreturn_t cciss_intx_discard_completions(int irq, void *dev_id)
+{
+	ctlr_info_t *h = dev_id;
+	unsigned long flags;
+	u32 raw_tag;
+
+	if (ignore_bogus_interrupt(h))
+		return IRQ_NONE;
+
+	if (interrupt_not_for_us(h))
+		return IRQ_NONE;
+	spin_lock_irqsave(&h->lock, flags);
+	while (interrupt_pending(h)) {
+		raw_tag = get_next_completion(h);
+		while (raw_tag != FIFO_EMPTY)
+			raw_tag = next_command(h);
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cciss_msix_discard_completions(int irq, void *dev_id)
+{
+	ctlr_info_t *h = dev_id;
+	unsigned long flags;
+	u32 raw_tag;
+
+	if (ignore_bogus_interrupt(h))
+		return IRQ_NONE;
+
+	spin_lock_irqsave(&h->lock, flags);
+	raw_tag = get_next_completion(h);
+	while (raw_tag != FIFO_EMPTY)
+		raw_tag = next_command(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t do_cciss_intx(int irq, void *dev_id)
 {
 	ctlr_info_t *h = dev_id;
@@ -4380,7 +4462,6 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 	return 0;
 }
 
-#define cciss_soft_reset_controller(p) cciss_message(p, 1, 0)
 #define cciss_noop(p) cciss_message(p, 3, 0)
 
 static int cciss_controller_hard_reset(struct pci_dev *pdev,
@@ -4591,13 +4672,17 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	/* Wait for board to become not ready, then ready. */
 	dev_info(&pdev->dev, "Waiting for board to reset.\n");
 	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
-	if (rc) /* Don't bail, might be E500, etc. which can't be reset */
-		dev_warn(&pdev->dev,
-			"failed waiting for board to reset\n");
+	if (rc) {
+		dev_warn(&pdev->dev, "Failed waiting for board to hard reset."
+				"  Will try soft reset.\n");
+		rc = -ENOTSUPP; /* Not expected, but try soft reset later */
+		goto unmap_cfgtable;
+	}
 	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_READY);
 	if (rc) {
 		dev_warn(&pdev->dev,
-			"failed waiting for board to become ready\n");
+			"failed waiting for board to become ready "
+			"after hard reset\n");
 		goto unmap_cfgtable;
 	}
 
@@ -4605,16 +4690,13 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	if (rc < 0)
 		goto unmap_cfgtable;
 	if (rc) {
-		dev_warn(&pdev->dev, "Unable to successfully reset controller,"
-			" Ignoring controller.\n");
-		rc = -ENODEV;
-		goto unmap_cfgtable;
+		dev_warn(&pdev->dev, "Unable to successfully hard reset "
+			"controller. Will try soft reset.\n");
+		rc = -ENOTSUPP; /* Not expected, but try soft reset later */
 	} else {
-		dev_info(&pdev->dev, "board ready.\n");
+		dev_info(&pdev->dev, "Board ready after hard reset.\n");
 	}
 
-	dev_info(&pdev->dev, "board ready.\n");
-
 unmap_cfgtable:
 	iounmap(cfgtable);
 
@@ -4639,7 +4721,7 @@ static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 	 * due to concerns about shared bbwc between 6402/6404 pair.
 	 */
 	if (rc == -ENOTSUPP)
-		return 0; /* just try to do the kdump anyhow. */
+		return rc; /* just try to do the kdump anyhow. */
 	if (rc)
 		return -ENODEV;
 
@@ -4745,6 +4827,60 @@ static int cciss_request_irq(ctlr_info_t *h,
 	return -1;
 }
 
+static int __devinit cciss_kdump_soft_reset(ctlr_info_t *h)
+{
+	if (cciss_send_reset(h, CTLR_LUNID, CCISS_RESET_TYPE_CONTROLLER)) {
+		dev_warn(&h->pdev->dev, "Resetting array controller failed.\n");
+		return -EIO;
+	}
+
+	dev_info(&h->pdev->dev, "Waiting for board to soft reset.\n");
+	if (cciss_wait_for_board_state(h->pdev, h->vaddr, BOARD_NOT_READY)) {
+		dev_warn(&h->pdev->dev, "Soft reset had no effect.\n");
+		return -1;
+	}
+
+	dev_info(&h->pdev->dev, "Board reset, awaiting READY status.\n");
+	if (cciss_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY)) {
+		dev_warn(&h->pdev->dev, "Board failed to become ready "
+			"after soft reset.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void cciss_undo_allocations_after_kdump_soft_reset(ctlr_info_t *h)
+{
+	int ctlr = h->ctlr;
+
+	free_irq(h->intr[PERF_MODE_INT], h);
+#ifdef CONFIG_PCI_MSI
+	if (h->msix_vector)
+		pci_disable_msix(h->pdev);
+	else if (h->msi_vector)
+		pci_disable_msi(h->pdev);
+#endif /* CONFIG_PCI_MSI */
+	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
+	cciss_free_scatterlists(h);
+	cciss_free_cmd_pool(h);
+	kfree(h->blockFetchTable);
+	if (h->reply_pool)
+		pci_free_consistent(h->pdev, h->max_commands * sizeof(__u64),
+				h->reply_pool, h->reply_pool_dhandle);
+	if (h->transtable)
+		iounmap(h->transtable);
+	if (h->cfgtable)
+		iounmap(h->cfgtable);
+	if (h->vaddr)
+		iounmap(h->vaddr);
+	unregister_blkdev(h->major, h->devname);
+	cciss_destroy_hba_sysfs_entry(h);
+	pci_release_regions(h->pdev);
+	kfree(h);
+	hba[ctlr] = NULL;
+}
+
 /*
  *  This is it.  Find all the controllers and register them.  I really hate
  *  stealing all these major device numbers.
@@ -4756,13 +4892,27 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int i;
 	int j = 0;
 	int rc;
+	int try_soft_reset = 0;
 	int dac, return_code;
 	InquiryData_struct *inq_buff;
 	ctlr_info_t *h;
+	unsigned long flags;
 
 	rc = cciss_init_reset_devices(pdev);
-	if (rc)
-		return rc;
+	if (rc) {
+		if (rc != -ENOTSUPP)
+			return rc;
+		/* If the reset fails in a particular way (it has no way to do
+		 * a proper hard reset, so returns -ENOTSUPP) we can try to do
+		 * a soft reset once we get the controller configured up to the
+		 * point that it can accept a command.
+		 */
+		try_soft_reset = 1;
+		rc = 0;
+	}
+
+reinit_after_soft_reset:
+
 	i = alloc_cciss_hba(pdev);
 	if (i < 0)
 		return -1;
@@ -4852,6 +5002,62 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		h->gendisk[j] = NULL;
 	}
 
+	/* At this point, the controller is ready to take commands.
+	 * Now, if reset_devices and the hard reset didn't work, try
+	 * the soft reset and see if that works.
+	 */
+	if (try_soft_reset) {
+
+		/* This is kind of gross.  We may or may not get a completion
+		 * from the soft reset command, and if we do, then the value
+		 * from the fifo may or may not be valid.  So, we wait 10 secs
+		 * after the reset throwing away any completions we get during
+		 * that time.  Unregister the interrupt handler and register
+		 * fake ones to scoop up any residual completions.
+		 */
+		spin_lock_irqsave(&h->lock, flags);
+		h->access.set_intr_mask(h, CCISS_INTR_OFF);
+		spin_unlock_irqrestore(&h->lock, flags);
+		free_irq(h->intr[PERF_MODE_INT], h);
+		rc = cciss_request_irq(h, cciss_msix_discard_completions,
+					cciss_intx_discard_completions);
+		if (rc) {
+			dev_warn(&h->pdev->dev, "Failed to request_irq after "
+				"soft reset.\n");
+			goto clean4;
+		}
+
+		rc = cciss_kdump_soft_reset(h);
+		if (rc) {
+			dev_warn(&h->pdev->dev, "Soft reset failed.\n");
+			goto clean4;
+		}
+
+		dev_info(&h->pdev->dev, "Board READY.\n");
+		dev_info(&h->pdev->dev,
+			"Waiting for stale completions to drain.\n");
+		h->access.set_intr_mask(h, CCISS_INTR_ON);
+		msleep(10000);
+		h->access.set_intr_mask(h, CCISS_INTR_OFF);
+
+		rc = controller_reset_failed(h->cfgtable);
+		if (rc)
+			dev_info(&h->pdev->dev,
+				"Soft reset appears to have failed.\n");
+
+		/* since the controller's reset, we have to go back and re-init
+		 * everything.  Easiest to just forget what we've done and do it
+		 * all over again.
+		 */
+		cciss_undo_allocations_after_kdump_soft_reset(h);
+		try_soft_reset = 0;
+		if (rc)
+			/* don't go to clean4, we already unallocated */
+			return -ENODEV;
+
+		goto reinit_after_soft_reset;
+	}
+
 	cciss_scsi_setup(h);
 
 	/* Turn the interrupts on so we can service requests */

