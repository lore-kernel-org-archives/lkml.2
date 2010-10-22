Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0JVXyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0JVXya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hrPbcoxMqF9AfTQfTndgwKvcJ5p2llnpDuv9hK8E0Baa1sfOCC2u4RD3G68ZJHTsln
         NAhPGbCovtAdtrk4UQQoV07jCbMNmA2HBWUvHTH6yzouxURor6l9biASpCTsH39LFSsd
         I+BvCq1gk9bE+IuMXCkN+4YU+EZfYFnMtZu9w=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 12/29] memstick: mspro: rework interface switch
Date: Sat, 23 Oct 2010 01:53:40 +0200
Message-Id: <1287791637-10329-13-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now no old style state machine exist.
Thus this patch removes now unused code.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c    |   15 --
 drivers/memstick/core/mspro_block.c |  328 +++++++++++++++++------------------
 drivers/memstick/core/mspro_block.h |    4 +-
 include/linux/memstick.h            |    2 -
 4 files changed, 162 insertions(+), 187 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index e1aa089..5eea1b2 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -424,21 +424,6 @@ int memstick_set_rw_addr(struct memstick_dev *card)
 EXPORT_SYMBOL(memstick_set_rw_addr);
 
 
-/**
- * memstick_new_req - notify the host that some requests are pending
- * @host - host to use
- */
-void memstick_new_req(struct memstick_host *host)
-{
-	if (host->card) {
-		host->retries = cmd_retries;
-		INIT_COMPLETION(host->card->mrq_complete);
-		host->request(host);
-	}
-}
-EXPORT_SYMBOL(memstick_new_req);
-
-
 /*** state machine support code ***/
 
 /**
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index e54d467..85018ce 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -372,54 +372,6 @@ static sysfs_show_t mspro_block_attr_show(unsigned char tag)
  * finished (and request processor should come back some time later).
  */
 
-static int h_mspro_block_req_init(struct memstick_dev *card,
-				  struct memstick_request **mrq)
-{
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-
-	*mrq = &card->current_mrq;
-	card->next_request = msb->mrq_handler;
-	return 0;
-}
-
-static int h_mspro_block_default(struct memstick_dev *card,
-				 struct memstick_request **mrq)
-{
-	return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
-}
-
-
-static int h_mspro_block_get_ro(struct memstick_dev *card,
-				struct memstick_request **mrq)
-{
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-
-	if (!(*mrq)->error) {
-		if ((*mrq)->data[offsetof(struct ms_status_register, status0)]
-		    & MEMSTICK_STATUS0_WP)
-			msb->read_only = 1;
-		else
-			msb->read_only = 0;
-	}
-
-	return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
-}
-
-static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
-				      struct memstick_request **mrq)
-{
-	dev_dbg(&card->dev, "wait for ced: value %x\n", (*mrq)->data[0]);
-
-	if (!(*mrq)->error) {
-		if ((*mrq)->data[0] & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR))
-			(*mrq)->error = -EFAULT;
-		else if (!((*mrq)->data[0] & MEMSTICK_INT_CED))
-			return 0;
-	}
-
-	return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
-}
-
 static int h_mspro_block_transfer_data(struct memstick_dev *card,
 				       struct memstick_request **mrq)
 {
@@ -552,6 +504,109 @@ again:
 	return 0;
 }
 
+
+static int h_mspro_block_reset(struct memstick_dev *card,
+					struct memstick_request **mrq)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct ms_status_register *status;
+	u8 intreg;
+
+	memstick_allocate_request(card, mrq);
+	if ((*mrq)->error)
+		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+
+again:
+	switch (card->state) {
+
+	case 0: /* send request for INT reg */
+		if (memstick_read_int_reg(card, *mrq, 10000))
+			break;
+		card->state++;
+
+	case 1: /* process the INT reg and loop if nessesary */
+		intreg = (*mrq)->data[0];
+
+		if (intreg & MEMSTICK_INT_ERR) {
+			if ((intreg & MEMSTICK_INT_CMDNAK)) {
+				msb->read_only = true;
+				return memstick_exit_state_machine(card,
+								*mrq, 0);
+			}
+			return memstick_exit_state_machine(card, *mrq, -EIO);
+		}
+
+		if (intreg & MEMSTICK_INT_CMDNAK)
+			return memstick_exit_state_machine(card, *mrq, -EIO);
+
+
+		if (!(intreg & MEMSTICK_INT_CED)) {
+			card->state--;
+			goto again;
+		}
+
+		memstick_read_int_reg_cleanup(card);
+		card->state++;
+
+	case 2: /* read the R/O status */
+
+		if (!memstick_read_regs(card,
+			offsetof(struct mspro_register, status),
+			sizeof(struct ms_status_register),
+			*mrq))
+			return 0;
+		break;
+
+	case 3: /* process the result & done */
+		status = (struct ms_status_register *)(*mrq)->data;
+		msb->read_only = status->status0 & MEMSTICK_STATUS0_WP;
+		return memstick_exit_state_machine(card, *mrq, 0);
+	}
+
+	card->state++;
+	return 0;
+
+}
+
+static int h_mspro_block_switch_interface(struct memstick_dev *card,
+					struct memstick_request **mrq)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int error;
+	memstick_allocate_request(card, mrq);
+	if ((*mrq)->error)
+		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+
+	switch (card->state) {
+
+	case 0: /* send switch command to the device */
+		if (!memstick_write_regs(card,
+			offsetof(struct mspro_register, param),
+			1,
+			&msb->system,
+			*mrq))
+			return 0;
+		break;
+
+	case 1: /* switch the host intrface + send dummy read to verify that */
+		/* connection works */
+		error = card->host->set_param(card->host,
+				MEMSTICK_INTERFACE, msb->target_interface);
+		if (error)
+			return memstick_exit_state_machine(card, *mrq, -EFAULT);
+
+		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+		break;
+
+	case 2: /* done */
+		return memstick_exit_state_machine(card, *mrq, 0);
+
+	}
+
+	card->state++;
+	return 0;
+}
+
 /*** Data transfer ***/
 
 /* Common helper that prepares state for IO (read, write, read attributes) */
@@ -717,113 +772,77 @@ static void mspro_block_submit_req(struct request_queue *q)
 
 /*** Initialization ***/
 
-static int mspro_block_wait_for_ced(struct memstick_dev *card)
+/* Reset the card */
+static int mspro_block_reset(struct memstick_dev *card, bool full)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int error;
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_wait_for_ced;
-	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	return card->current_mrq.error;
-}
+	dbg(card, "resetting the card");
 
-static int mspro_block_set_interface(struct memstick_dev *card,
-				     unsigned char sys_reg)
-{
-	struct memstick_host *host = card->host;
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct mspro_param_register param = {
-		.system = sys_reg,
-		.data_count = 0,
-		.data_address = 0,
-		.tpc_param = 0
-	};
+	msb->system = MEMSTICK_SYS_SERIAL;
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_default;
-	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-			  sizeof(param));
-	memstick_new_req(host);
-	wait_for_completion(&card->mrq_complete);
-	return card->current_mrq.error;
+	if (full) {
+		error = memstick_reset(card->host);
+		if (error) {
+			dbg(card, "host controller reset failure");
+			return error;
+		}
+	}
+
+	msleep(150);
+
+	error = memstick_run_state_machine(card, h_mspro_block_reset, true);
+	if (error) {
+		dbg(card, "card reset failure");
+		return error;
+	}
+
+	return mspro_block_switch_interface(card);
 }
 
+/*
+ * Attempts to switch to faster interface.
+ * If switch fails it clears the card capability of this mode
+ * and calls reset which might call this function again but that
+ * time it won't attempt failed mode
+ */
 static int mspro_block_switch_interface(struct memstick_dev *card)
 {
 	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	int rc = 0;
+	int error = 0;
 
-try_again:
-	if (msb->caps & MEMSTICK_CAP_PAR4)
-		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR4);
-	else
+	if (!(card->caps & host->caps & MEMSTICK_CAP_PAR4))
 		return 0;
 
-	if (rc) {
-		printk(KERN_WARNING
-		       "%s: could not switch to 4-bit mode, error %d\n",
-		       dev_name(&card->dev), rc);
-		return 0;
-	}
+	dbg(card, "switching to parallel 4 bit inteface");
 
 	msb->system = MEMSTICK_SYS_PAR4;
-	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
-	printk(KERN_INFO "%s: switching to 4-bit parallel mode\n",
-	       dev_name(&card->dev));
-
-	if (msb->caps & MEMSTICK_CAP_PAR8) {
-		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR8);
-
-		if (!rc) {
-			msb->system = MEMSTICK_SYS_PAR8;
-			host->set_param(host, MEMSTICK_INTERFACE,
-					MEMSTICK_PAR8);
-			printk(KERN_INFO
-			       "%s: switching to 8-bit parallel mode\n",
-			       dev_name(&card->dev));
-		} else
-			printk(KERN_WARNING
-			       "%s: could not switch to 8-bit mode, error %d\n",
-			       dev_name(&card->dev), rc);
+	msb->target_interface = MEMSTICK_PAR4;
+	error = memstick_run_state_machine(card,
+				h_mspro_block_switch_interface, true);
+	if (error) {
+		dbg(card, "failure to switch to parallel 4 bit inteface");
+		card->caps &= ~MEMSTICK_CAP_PAR4;
+		return mspro_block_reset(card, true);
 	}
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_default;
-	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	rc = card->current_mrq.error;
+	if (!(card->caps & host->caps & MEMSTICK_CAP_PAR8))
+		return 0;
 
-	if (rc) {
-		printk(KERN_WARNING
-		       "%s: interface error, trying to fall back to serial\n",
-		       dev_name(&card->dev));
-		msb->system = MEMSTICK_SYS_SERIAL;
-		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
-		msleep(10);
-		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
-		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
-
-		rc = memstick_set_rw_addr(card);
-		if (!rc)
-			rc = mspro_block_set_interface(card, msb->system);
-
-		if (!rc) {
-			msleep(150);
-			rc = mspro_block_wait_for_ced(card);
-			if (rc)
-				return rc;
-
-			if (msb->caps & MEMSTICK_CAP_PAR8) {
-				msb->caps &= ~MEMSTICK_CAP_PAR8;
-				goto try_again;
-			}
-		}
+	msb->system = MEMSTICK_SYS_PAR8;
+	msb->target_interface = MEMSTICK_PAR8;
+	dbg(card, "switching to parallel 8 bit inteface");
+	error = memstick_run_state_machine(card,
+					h_mspro_block_switch_interface, true);
+	if (error) {
+		dbg(card, "failure to switch to parallel 8 bit inteface");
+		card->caps &= ~MEMSTICK_CAP_PAR8;
+		return mspro_block_reset(card, true);
 	}
-	return rc;
+
+	return error;
 }
 
 /* Read data from attribute space */
@@ -857,7 +876,7 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 
 	int cnt, error, attr_count;
 
-	/* Allocate initial buffer */
+	/* Allocate cache buffer */
 	buffer_size = msb->page_size;
 	buffer_address = 0;
 	buffer = kmalloc(buffer_size, GFP_KERNEL);
@@ -981,52 +1000,27 @@ out_free_buffer:
 static int mspro_block_init_card(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct memstick_host *host = card->host;
 	int rc = 0;
 
-	msb->system = MEMSTICK_SYS_SERIAL;
-	card->reg_addr.r_offset = offsetof(struct mspro_register, status);
-	card->reg_addr.r_length = sizeof(struct ms_status_register);
-	card->reg_addr.w_offset = offsetof(struct mspro_register, param);
-	card->reg_addr.w_length = sizeof(struct mspro_param_register);
-
-	if (memstick_set_rw_addr(card))
-		return -EIO;
+	card->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
-	msb->caps = host->caps;
-
-	msleep(150);
-	rc = mspro_block_wait_for_ced(card);
+	rc = mspro_block_reset(card, false);
 	if (rc)
 		return rc;
 
-	rc = mspro_block_switch_interface(card);
-	if (rc)
-		return rc;
-
-	dev_dbg(&card->dev, "card activated\n");
+	dbg(card, "card activated");
 	if (msb->system != MEMSTICK_SYS_SERIAL)
-		msb->caps |= MEMSTICK_CAP_AUTO_GET_INT;
-
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_get_ro;
-	memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
-			  sizeof(struct ms_status_register));
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	if (card->current_mrq.error)
-		return card->current_mrq.error;
+		card->caps |= MEMSTICK_CAP_AUTO_GET_INT;
 
-	dev_dbg(&card->dev, "card r/w status %d\n", msb->read_only ? 0 : 1);
+	dbg(card, "card r/w status %d", msb->read_only ? 0 : 1);
 
 	msb->page_size = 512;
 	rc = mspro_block_read_attributes(card);
 	if (rc)
 		return rc;
 
-	dev_dbg(&card->dev, "attributes loaded\n");
+	dbg(card, "attributes loaded");
 	return 0;
-
 }
 
 static int mspro_block_init_disk(struct memstick_dev *card)
diff --git a/drivers/memstick/core/mspro_block.h b/drivers/memstick/core/mspro_block.h
index 82ae2fe..a7ba42d 100644
--- a/drivers/memstick/core/mspro_block.h
+++ b/drivers/memstick/core/mspro_block.h
@@ -135,9 +135,6 @@ struct mspro_block_data {
 	spinlock_t                       q_lock;
 	struct scatterlist               req_sg[MSPRO_BLOCK_MAX_SEGS];
 
-	int                           (*mrq_handler)(struct memstick_dev *card,
-						struct memstick_request **mrq);
-
 	unsigned char                    read_only:1;
 	unsigned char                    eject:1;
 	unsigned char                    active:1;
@@ -157,6 +154,7 @@ struct mspro_block_data {
 	unsigned int                     current_sg_offset;
 	unsigned int	                 data_transferred;
 	unsigned char                    data_dir:1;
+	unsigned int                     target_interface;
 	int                              io_error;
 };
 
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 73586cb..4700543 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -366,8 +366,6 @@ int memstick_exit_state_machine(struct memstick_dev *card,
 void memstick_allocate_request(struct memstick_dev *card,
 					struct memstick_request **mrq);
 
-void memstick_new_req(struct memstick_host *host);
-
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 			  const struct scatterlist *sg);
 void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
-- 
1.7.1

