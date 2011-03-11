Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1CKU4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:56:43 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30211 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1CKU4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:56:39 -0500
Subject: [PATCH 6/7] cciss: add cciss_tape_cmds module paramter
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 11 Mar 2011 14:56:01 -0600
Message-ID: <20110311205601.2211.5931.stgit@beardog.cce.hp.com>
In-Reply-To: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
References: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to allow number of commands reserved for use by SCSI tape drives
and medium changers to be adjusted at driver load time via the kernel
parameter cciss_tape_cmds, with a default value of 6, and a range
of 2 - 16 inclusive.  Previously, the driver limited the number of
commands which could be queued to the SCSI half of the the driver
to only 2.  This is to fix the problem that if you had more than
two tape drives, you couldn't, for example, erase or rewind them all
at the same time.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/blockdev/cciss.txt |   15 ++++++++++++++
 drivers/block/cciss.c            |   11 +++++++++-
 drivers/block/cciss_scsi.c       |   41 +++++++++++++++++++++-----------------
 drivers/block/cciss_scsi.h       |    4 ----
 4 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/Documentation/blockdev/cciss.txt b/Documentation/blockdev/cciss.txt
index 89698e8..c00c6a5 100644
--- a/Documentation/blockdev/cciss.txt
+++ b/Documentation/blockdev/cciss.txt
@@ -169,3 +169,18 @@ is issued which positions the tape to a known position.  Typically you
 must rewind the tape (by issuing "mt -f /dev/st0 rewind" for example)
 before i/o can proceed again to a tape drive which was reset.
 
+There is a cciss_tape_cmds module parameter which can be used to make cciss
+allocate more commands for use by tape drives.  Ordinarily only a few commands
+(6) are allocated for tape drives because tape drives are slow and
+infrequently used and the primary purpose of Smart Array controllers is to
+act as a RAID controller for disk drives, so the vast majority of commands
+are allocated for disk devices.  However, if you have more than a few tape
+drives attached to a smart array, the default number of commands may not be
+enought (for example, if you have 8 tape drives, you could only rewind 6
+at one time with the default number of commands.)  The cciss_tape_cmds module
+parameter allows more commands (up to 16 more) to be allocated for use by
+tape drives.  For example:
+
+        insmod cciss.ko cciss_tape_cmds=16
+
+Or, as a kernel boot parameter passed in via grub:  cciss.cciss_tape_cmds=8
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6d2464e..0cc089a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -64,6 +64,10 @@ MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
 MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
 MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
+static int cciss_tape_cmds = 6;
+module_param(cciss_tape_cmds, int, 0644);
+MODULE_PARM_DESC(cciss_tape_cmds,
+	"number of commands to allocate for tape devices (default: 6)");
 
 static DEFINE_MUTEX(cciss_mutex);
 static struct proc_dir_entry *proc_cciss;
@@ -4073,7 +4077,7 @@ static void __devinit cciss_get_max_perf_mode_cmds(struct ctlr_info *h)
 static void __devinit cciss_find_board_params(ctlr_info_t *h)
 {
 	cciss_get_max_perf_mode_cmds(h);
-	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
+	h->nr_cmds = h->max_commands - 4 - cciss_tape_cmds;
 	h->maxsgentries = readl(&(h->cfgtable->MaxSGElements));
 	/*
 	 * Limit in-command s/g elements to 32 save dma'able memory.
@@ -4588,6 +4592,11 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	sprintf(h->devname, "cciss%d", i);
 	h->ctlr = i;
 
+	if (cciss_tape_cmds < 2)
+		cciss_tape_cmds = 2;
+	if (cciss_tape_cmds > 16)
+		cciss_tape_cmds = 16;
+
 	init_completion(&h->scan_wait);
 
 	if (cciss_create_hba_sysfs_entry(h))
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index df79380..6961002 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -84,7 +84,6 @@ static struct scsi_host_template cciss_driver_template = {
 	.proc_name		= "cciss",
 	.proc_info		= cciss_scsi_proc_info,
 	.queuecommand		= cciss_scsi_queue_command,
-	.can_queue		= SCSI_CCISS_CAN_QUEUE,
 	.this_id		= 7,
 	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
@@ -108,16 +107,13 @@ struct cciss_scsi_cmd_stack_elem_t {
 
 #pragma pack()
 
-#define CMD_STACK_SIZE (SCSI_CCISS_CAN_QUEUE * \
-		CCISS_MAX_SCSI_DEVS_PER_HBA + 2)
-			// plus two for init time usage
-
 #pragma pack(1)
 struct cciss_scsi_cmd_stack_t {
 	struct cciss_scsi_cmd_stack_elem_t *pool;
-	struct cciss_scsi_cmd_stack_elem_t *elem[CMD_STACK_SIZE];
+	struct cciss_scsi_cmd_stack_elem_t **elem;
 	dma_addr_t cmd_pool_handle;
 	int top;
+	int nelems;
 };
 #pragma pack()
 
@@ -191,7 +187,7 @@ scsi_cmd_free(ctlr_info_t *h, CommandList_struct *c)
 	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 	stk->top++;
-	if (stk->top >= CMD_STACK_SIZE) {
+	if (stk->top >= stk->nelems) {
 		dev_err(&h->pdev->dev,
 			"scsi_cmd_free called too many times.\n");
 		BUG();
@@ -206,13 +202,14 @@ scsi_cmd_stack_setup(ctlr_info_t *h, struct cciss_scsi_adapter_data_t *sa)
 	struct cciss_scsi_cmd_stack_t *stk;
 	size_t size;
 
+	stk = &sa->cmd_stack;
+	stk->nelems = cciss_tape_cmds + 2;
 	sa->cmd_sg_list = cciss_allocate_sg_chain_blocks(h,
-		h->chainsize, CMD_STACK_SIZE);
+		h->chainsize, stk->nelems);
 	if (!sa->cmd_sg_list && h->chainsize > 0)
 		return -ENOMEM;
 
-	stk = &sa->cmd_stack; 
-	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
+	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * stk->nelems;
 
 	/* Check alignment, see cciss_cmd.h near CommandList_struct def. */
 	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
@@ -221,18 +218,23 @@ scsi_cmd_stack_setup(ctlr_info_t *h, struct cciss_scsi_adapter_data_t *sa)
 		pci_alloc_consistent(h->pdev, size, &stk->cmd_pool_handle);
 
 	if (stk->pool == NULL) {
-		cciss_free_sg_chain_blocks(sa->cmd_sg_list, CMD_STACK_SIZE);
+		cciss_free_sg_chain_blocks(sa->cmd_sg_list, stk->nelems);
 		sa->cmd_sg_list = NULL;
 		return -ENOMEM;
 	}
-
-	for (i=0; i<CMD_STACK_SIZE; i++) {
+	stk->elem = kmalloc(sizeof(stk->elem[0]) * stk->nelems, GFP_KERNEL);
+	if (!stk->elem) {
+		pci_free_consistent(h->pdev, size, stk->pool,
+		stk->cmd_pool_handle);
+		return -1;
+	}
+	for (i = 0; i < stk->nelems; i++) {
 		stk->elem[i] = &stk->pool[i];
 		stk->elem[i]->busaddr = (__u32) (stk->cmd_pool_handle + 
 			(sizeof(struct cciss_scsi_cmd_stack_elem_t) * i));
 		stk->elem[i]->cmdindex = i;
 	}
-	stk->top = CMD_STACK_SIZE-1;
+	stk->top = stk->nelems-1;
 	return 0;
 }
 
@@ -245,16 +247,18 @@ scsi_cmd_stack_free(ctlr_info_t *h)
 
 	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
-	if (stk->top != CMD_STACK_SIZE-1) {
+	if (stk->top != stk->nelems-1) {
 		dev_warn(&h->pdev->dev,
 			"bug: %d scsi commands are still outstanding.\n",
-			CMD_STACK_SIZE - stk->top);
+			stk->nelems - stk->top);
 	}
-	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
+	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * stk->nelems;
 
 	pci_free_consistent(h->pdev, size, stk->pool, stk->cmd_pool_handle);
 	stk->pool = NULL;
-	cciss_free_sg_chain_blocks(sa->cmd_sg_list, CMD_STACK_SIZE);
+	cciss_free_sg_chain_blocks(sa->cmd_sg_list, stk->nelems);
+	kfree(stk->elem);
+	stk->elem = NULL;
 }
 
 #if 0
@@ -859,6 +863,7 @@ cciss_scsi_detect(ctlr_info_t *h)
 	sh->io_port = 0;	// good enough?  FIXME, 
 	sh->n_io_port = 0;	// I don't think we use these two...
 	sh->this_id = SELF_SCSI_ID;  
+	sh->can_queue = cciss_tape_cmds;
 	sh->sg_tablesize = h->maxsgentries;
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
 
diff --git a/drivers/block/cciss_scsi.h b/drivers/block/cciss_scsi.h
index 6d5822f..e71d986 100644
--- a/drivers/block/cciss_scsi.h
+++ b/drivers/block/cciss_scsi.h
@@ -36,13 +36,9 @@
 		   addressible natively, and may in fact turn
 		   out to be not scsi at all. */
 
-#define SCSI_CCISS_CAN_QUEUE 2
 
 /* 
 
-Note, cmd_per_lun could give us some trouble, so I'm setting it very low.
-Likewise, SCSI_CCISS_CAN_QUEUE is set very conservatively.
-
 If the upper scsi layer tries to track how many commands we have 
 outstanding, it will be operating under the misapprehension that it is
 the only one sending us requests.  We also have the block interface,

