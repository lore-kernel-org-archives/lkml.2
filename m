Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab0GSSlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:41:37 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44310 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966387Ab0GSSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:41:13 -0400
Subject: [PATCH 24/26] cciss: separate cmd_alloc() and cmd_special_alloc()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:43 -0500
Message-ID: <20100719184643.7908.69801.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: separate cmd_alloc() and cmd_special_alloc()
cmd_alloc() took a parameter which caused it to either allocate
from a pre-allocated pool, or allocate using pci_alloc_consistent.
This parameter is always known at compile time, so this would
be better handled by breaking the function into two functions
and differentiating the cases by function names.  Same goes
for cmd_free().

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c      |  153 ++++++++++++++++++++++++--------------------
 drivers/block/cciss_scsi.c |   10 ++-
 2 files changed, 89 insertions(+), 74 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 70ad24f..1dc9574 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -907,60 +907,73 @@ static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index,
 /*
  * For operations that cannot sleep, a command block is allocated at init,
  * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
- * which ones are free or in use.  For operations that can wait for kmalloc
- * to possible sleep, this routine can be called with get_from_pool set to 0.
- * cmd_free() MUST be called with a got_from_pool set to 0 if cmd_alloc was.
+ * which ones are free or in use.
  */
-static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool)
+static CommandList_struct *cmd_alloc(ctlr_info_t *h)
 {
 	CommandList_struct *c;
 	int i;
 	u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 
-	if (!get_from_pool) {
-		c = (CommandList_struct *) pci_alloc_consistent(h->pdev,
-			sizeof(CommandList_struct), &cmd_dma_handle);
-		if (c == NULL)
+	do {
+		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
+		if (i == h->nr_cmds)
 			return NULL;
-		memset(c, 0, sizeof(CommandList_struct));
+	} while (test_and_set_bit(i & (BITS_PER_LONG - 1),
+		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+#ifdef CCISS_DEBUG
+	printk(KERN_DEBUG "cciss: using command buffer %d\n", i);
+#endif
+	c = h->cmd_pool + i;
+	memset(c, 0, sizeof(CommandList_struct));
+	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(CommandList_struct);
+	c->err_info = h->errinfo_pool + i;
+	memset(c->err_info, 0, sizeof(ErrorInfo_struct));
+	err_dma_handle = h->errinfo_pool_dhandle
+	    + i * sizeof(ErrorInfo_struct);
+	h->nr_allocs++;
 
-		c->cmdindex = -1;
+	c->cmdindex = i;
 
-		c->err_info = (ErrorInfo_struct *)
-		    pci_alloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
-			    &err_dma_handle);
+	INIT_HLIST_NODE(&c->list);
+	c->busaddr = (__u32) cmd_dma_handle;
+	temp64.val = (__u64) err_dma_handle;
+	c->ErrDesc.Addr.lower = temp64.val32.lower;
+	c->ErrDesc.Addr.upper = temp64.val32.upper;
+	c->ErrDesc.Len = sizeof(ErrorInfo_struct);
 
-		if (c->err_info == NULL) {
-			pci_free_consistent(h->pdev,
-				sizeof(CommandList_struct), c, cmd_dma_handle);
-			return NULL;
-		}
-		memset(c->err_info, 0, sizeof(ErrorInfo_struct));
-	} else {		/* get it out of the controllers pool */
-
-		do {
-			i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
-			if (i == h->nr_cmds)
-				return NULL;
-		} while (test_and_set_bit
-			 (i & (BITS_PER_LONG - 1),
-			  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
-#ifdef CCISS_DEBUG
-		printk(KERN_DEBUG "cciss: using command buffer %d\n", i);
-#endif
-		c = h->cmd_pool + i;
-		memset(c, 0, sizeof(CommandList_struct));
-		cmd_dma_handle = h->cmd_pool_dhandle
-		    + i * sizeof(CommandList_struct);
-		c->err_info = h->errinfo_pool + i;
-		memset(c->err_info, 0, sizeof(ErrorInfo_struct));
-		err_dma_handle = h->errinfo_pool_dhandle
-		    + i * sizeof(ErrorInfo_struct);
-		h->nr_allocs++;
+	c->ctlr = h->ctlr;
+	return c;
+}
+
+/* allocate a command using pci_alloc_consistent, used for ioctls,
+ * etc., not for the main i/o path.
+ */
+static CommandList_struct *cmd_special_alloc(ctlr_info_t *h)
+{
+	CommandList_struct *c;
+	u64bit temp64;
+	dma_addr_t cmd_dma_handle, err_dma_handle;
+
+	c = (CommandList_struct *) pci_alloc_consistent(h->pdev,
+		sizeof(CommandList_struct), &cmd_dma_handle);
+	if (c == NULL)
+		return NULL;
+	memset(c, 0, sizeof(CommandList_struct));
+
+	c->cmdindex = -1;
+
+	c->err_info = (ErrorInfo_struct *)
+	    pci_alloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
+		    &err_dma_handle);
 
-		c->cmdindex = i;
+	if (c->err_info == NULL) {
+		pci_free_consistent(h->pdev,
+			sizeof(CommandList_struct), c, cmd_dma_handle);
+		return NULL;
 	}
+	memset(c->err_info, 0, sizeof(ErrorInfo_struct));
 
 	INIT_HLIST_NODE(&c->list);
 	c->busaddr = (__u32) cmd_dma_handle;
@@ -973,27 +986,26 @@ static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool)
 	return c;
 }
 
-/*
- * Frees a command block that was previously allocated with cmd_alloc().
- */
-static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool)
+static void cmd_free(ctlr_info_t *h, CommandList_struct *c)
 {
 	int i;
+
+	i = c - h->cmd_pool;
+	clear_bit(i & (BITS_PER_LONG - 1),
+		  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	h->nr_frees++;
+}
+
+static void cmd_special_free(ctlr_info_t *h, CommandList_struct *c)
+{
 	u64bit temp64;
 
-	if (!got_from_pool) {
-		temp64.val32.lower = c->ErrDesc.Addr.lower;
-		temp64.val32.upper = c->ErrDesc.Addr.upper;
-		pci_free_consistent(h->pdev, sizeof(ErrorInfo_struct),
-				    c->err_info, (dma_addr_t) temp64.val);
-		pci_free_consistent(h->pdev, sizeof(CommandList_struct),
-				    c, (dma_addr_t) c->busaddr);
-	} else {
-		i = c - h->cmd_pool;
-		clear_bit(i & (BITS_PER_LONG - 1),
-			  h->cmd_pool_bits + (i / BITS_PER_LONG));
-		h->nr_frees++;
-	}
+	temp64.val32.lower = c->ErrDesc.Addr.lower;
+	temp64.val32.upper = c->ErrDesc.Addr.upper;
+	pci_free_consistent(h->pdev, sizeof(ErrorInfo_struct),
+			    c->err_info, (dma_addr_t) temp64.val);
+	pci_free_consistent(h->pdev, sizeof(CommandList_struct),
+			    c, (dma_addr_t) c->busaddr);
 }
 
 static inline ctlr_info_t *get_host(struct gendisk *disk)
@@ -1470,7 +1482,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			} else {
 				memset(buff, 0, iocommand.buf_size);
 			}
-			c = cmd_alloc(h, 0);
+			c = cmd_special_alloc(h);
 			if (!c) {
 				kfree(buff);
 				return -ENOMEM;
@@ -1524,7 +1536,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			if (copy_to_user
 			    (argp, &iocommand, sizeof(IOCTL_Command_struct))) {
 				kfree(buff);
-				cmd_free(h, c, 0);
+				cmd_special_free(h, c);
 				return -EFAULT;
 			}
 
@@ -1533,12 +1545,12 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				if (copy_to_user
 				    (iocommand.buf, buff, iocommand.buf_size)) {
 					kfree(buff);
-					cmd_free(h, c, 0);
+					cmd_special_free(h, c);
 					return -EFAULT;
 				}
 			}
 			kfree(buff);
-			cmd_free(h, c, 0);
+			cmd_special_free(h, c);
 			return 0;
 		}
 	case CCISS_BIG_PASSTHRU:{
@@ -1620,7 +1632,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				data_ptr += sz;
 				sg_used++;
 			}
-			c = cmd_alloc(h, 0);
+			c = cmd_special_alloc(h);
 			if (!c) {
 				status = -ENOMEM;
 				goto cleanup1;
@@ -1668,7 +1680,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			/* Copy the error information out */
 			ioc->error_info = *(c->err_info);
 			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
-				cmd_free(h, c, 0);
+				cmd_special_free(h, c);
 				status = -EFAULT;
 				goto cleanup1;
 			}
@@ -1678,14 +1690,14 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				for (i = 0; i < sg_used; i++) {
 					if (copy_to_user
 					    (ptr, buff[i], buff_size[i])) {
-						cmd_free(h, c, 0);
+						cmd_special_free(h, c);
 						status = -EFAULT;
 						goto cleanup1;
 					}
 					ptr += buff_size[i];
 				}
 			}
-			cmd_free(h, c, 0);
+			cmd_special_free(h, c);
 			status = 0;
 		      cleanup1:
 			if (buff) {
@@ -1813,7 +1825,7 @@ static void cciss_softirq_done(struct request *rq)
 	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
 
 	spin_lock_irqsave(&h->lock, flags);
-	cmd_free(h, c, 1);
+	cmd_free(h, c);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
@@ -2765,7 +2777,7 @@ static int sendcmd_withirq(ctlr_info_t *h, __u8 cmd, void *buff, size_t size,
 	CommandList_struct *c;
 	int return_status;
 
-	c = cmd_alloc(h, 0);
+	c = cmd_special_alloc(h);
 	if (!c)
 		return -ENOMEM;
 	return_status = fill_cmd(h, c, cmd, buff, size, page_code,
@@ -2773,7 +2785,7 @@ static int sendcmd_withirq(ctlr_info_t *h, __u8 cmd, void *buff, size_t size,
 	if (return_status == IO_OK)
 		return_status = sendcmd_withirq_core(h, c, 1);
 
-	cmd_free(h, c, 0);
+	cmd_special_free(h, c);
 	return return_status;
 }
 
@@ -3240,7 +3252,8 @@ static void do_cciss_request(struct request_queue *q)
 
 	BUG_ON(creq->nr_phys_segments > h->maxsgentries);
 
-	if ((c = cmd_alloc(h, 1)) == NULL)
+	c = cmd_alloc(h);
+	if (!c)
 		goto full;
 
 	blk_start_request(creq);
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 9133ad4..9fe0d8f 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -49,8 +49,10 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 	__u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
-static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool);
-static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool);
+static CommandList_struct *cmd_alloc(ctlr_info_t *h);
+static CommandList_struct *cmd_special_alloc(ctlr_info_t *h);
+static void cmd_free(ctlr_info_t *h, CommandList_struct *c);
+static void cmd_special_free(ctlr_info_t *h, CommandList_struct *c);
 
 static int cciss_scsi_proc_info(
 		struct Scsi_Host *sh,
@@ -1582,7 +1584,7 @@ static int wait_for_device_to_become_ready(ctlr_info_t *h,
 	int waittime = HZ;
 	CommandList_struct *c;
 
-	c = cmd_alloc(h, 1);
+	c = cmd_alloc(h);
 	if (!c) {
 		printk(KERN_WARNING "cciss%d: out of memory in "
 			"wait_for_device_to_become_ready.\n", h->ctlr);
@@ -1640,7 +1642,7 @@ retry_tur:
 	else
 		printk(KERN_WARNING "cciss%d: device is ready.\n", h->ctlr);
 
-	cmd_free(h, c, 1);
+	cmd_free(h, c);
 	return rc;
 }
 

