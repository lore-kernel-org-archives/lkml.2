Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab0JZSEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:04:38 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:45458 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933225Ab0JZSEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:04:37 -0400
From: "Alex Dubov" <oakad@yahoo.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 4/4] memstick: add support for MSPro specific data transfer method
Date: Wed, 27 Oct 2010 04:41:11 +1100
Message-Id: <1288114871-805-5-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1288114871-805-4-git-send-email-oakad@yahoo.com>
References: <1288114871-805-1-git-send-email-oakad@yahoo.com>
 <1288114871-805-2-git-send-email-oakad@yahoo.com>
 <1288114871-805-3-git-send-email-oakad@yahoo.com>
 <1288114871-805-4-git-send-email-oakad@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

This patch enables faster data transfer to/from MSPro media for enabled hosts
(currently only jmb38x_ms). Other supported hosts and transfer methods (HG,
XC) to follow.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |   63 +++++++++++++++++++++++++++++++----
 drivers/memstick/host/jmb38x_ms.c   |    2 +-
 include/linux/memstick.h            |    7 ++++
 3 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index ef7679b..ae66634 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -588,12 +588,10 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 		return mspro_block_complete_req(card, (*mrq)->error);
 
 	switch ((*mrq)->tpc) {
-	case MS_TPC_WRITE_REG:
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
-		(*mrq)->need_card_int = 1;
-		return 0;
+	case MS_TPC_EX_SET_CMD:
 	case MS_TPC_SET_CMD:
 		t_val = (*mrq)->int_reg;
+		msb->mrq_handler = h_mspro_block_transfer_data;
 		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
 		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT)
 			goto has_int_reg;
@@ -663,6 +661,20 @@ has_int_reg:
 	}
 }
 
+static int h_mspro_block_invoke_cmd(struct memstick_dev *card,
+				    struct memstick_request **mrq)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	if ((*mrq)->error)
+		return mspro_block_complete_req(card, (*mrq)->error);
+
+	card->next_request = h_mspro_block_transfer_data;
+	memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
+	(*mrq)->need_card_int = 1;
+	return 0;
+}
+
 /*** Transfer setup functions for different access methods. ***/
 
 /** Setup data transfer request for SET_CMD TPC with arguments in card
@@ -688,11 +700,37 @@ static void h_mspro_block_setup_cmd(struct memstick_dev *card, u64 offset,
 	param.data_address = cpu_to_be32((uint32_t)offset);
 
 	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_transfer_data;
+	msb->mrq_handler = h_mspro_block_invoke_cmd;
 	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
 			  &param, sizeof(param));
 }
 
+/** Setup data transfer request for EX_SET_CMD TPC with arguments in TPC packet.
+ *
+ *  @card    Current media instance
+ *  @offset  Target data offset in bytes
+ *  @length  Required transfer length in bytes.
+ */
+static void h_mspro_block_ex_setup_cmd(struct memstick_dev *card, u64 offset,
+				       size_t length)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct mspro_ex_cmd_param param = {
+		.command = msb->transfer_cmd,
+		.data_count = cpu_to_be16((uint16_t)(length / msb->page_size)),
+		/* ISO C90 warning precludes direct initialization for now. */
+		.data_address = 0
+	};
+
+	do_div(offset, msb->page_size);
+	param.data_address = cpu_to_be32((uint32_t)offset);
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_transfer_data;
+	memstick_init_req(&card->current_mrq, MS_TPC_EX_SET_CMD,
+			  &param, sizeof(param));
+}
+
 /*** Data transfer ***/
 
 static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
@@ -718,13 +756,12 @@ try_again:
 		t_off <<= 9;
 		count = blk_rq_bytes(msb->block_req);
 
-		msb->setup_transfer(card, t_off, count);
-
 		msb->data_dir = rq_data_dir(msb->block_req);
 		msb->transfer_cmd = msb->data_dir == READ
 				    ? MSPRO_CMD_READ_DATA
 				    : MSPRO_CMD_WRITE_DATA;
 
+		msb->setup_transfer(card, t_off, count);
 		memstick_new_req(card->host);
 		return 0;
 	}
@@ -1170,6 +1207,18 @@ static int mspro_block_init_card(struct memstick_dev *card)
 	dev_dbg(&card->dev, "card r/w status %d\n", msb->read_only ? 0 : 1);
 
 	msb->page_size = 512;
+
+	/* All MSPro media devices are expected to support extended command
+	 * transfer mode. Faulty or old adapters may chose not to advertise
+	 * this capability and rely on somewhat slower default mode.
+	 *
+	 * Even more advanced HG and XC modes of operation, when implemented,
+	 * will have to be selected after media attribute parsing, to ensure
+	 * full compatibility.
+	 */
+	if (msb->caps & MEMSTICK_CAP_EX_CMD)
+		msb->setup_transfer = h_mspro_block_ex_setup_cmd;
+
 	rc = mspro_block_read_attributes(card);
 	if (rc)
 		return rc;
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index f2b894c..cc67726 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -848,7 +848,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 	msh->request = jmb38x_ms_submit_req;
 	msh->set_param = jmb38x_ms_set_param;
 
-	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
+	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8 | MEMSTICK_CAP_EX_CMD;
 
 	setup_timer(&host->timer, jmb38x_ms_abort, (unsigned long)msh);
 
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 690c35a..ad75e17 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -105,6 +105,12 @@ struct mspro_param_register {
 	unsigned char  tpc_param;
 } __attribute__((packed));
 
+struct mspro_ex_cmd_param {
+	unsigned char command;
+	__be16        data_count;
+	__be32        data_address;
+} __packed;
+
 struct mspro_io_info_register {
 	unsigned char version;
 	unsigned char io_category;
@@ -279,6 +285,7 @@ struct memstick_host {
 #define MEMSTICK_CAP_AUTO_GET_INT  1
 #define MEMSTICK_CAP_PAR4          2
 #define MEMSTICK_CAP_PAR8          4
+#define MEMSTICK_CAP_EX_CMD        8
 
 	struct work_struct  media_checker;
 	struct device       dev;
-- 
1.6.5.1

