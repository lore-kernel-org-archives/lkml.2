Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0JVX6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:58:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0JVXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O3Lt3sJsFxhPdJ6K9tMd1rxPmbTk148UJSEqS/hugQQ0UDoGluXGSGcLlii0m8gKI6
         dPsKkwroT6H/jhkxY2lzcBLwxdPY5DYeMPFmHlt6StKn/wnRv0dzlAyOPZYU7uk7xPJv
         9eCvFlrNvvu1US5GznBuS2U9WiQLEjkaQqpgk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 11/29] memstick: mspro: use MS_TPC_EX_SET_CMD
Date: Sat, 23 Oct 2010 01:53:39 +0200
Message-Id: <1287791637-10329-12-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little optimization done by Sony for
PRO variant of the cards allows to bundle the param register
with the command and therefore send one TPC less.

This increases IO throughput somewhat.
(4.4 -> 4.8 MB/s on Jmicron for example)

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |   35 +++++++++++++----------------------
 drivers/memstick/core/mspro_block.h |    3 +--
 2 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 0d8b30b..e54d467 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -438,35 +438,28 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 
 		if (!msb->io_error) {
 			msb->io_error = (*mrq)->error;
-			card->state = 6;
+			card->state = 5;
 		}
 	}
 again:
 	switch (card->state) {
 
 	case 0: /* send read/write command + args */
-		if (!memstick_write_regs(card,
-			offsetof(struct mspro_register, param),
-			sizeof(struct mspro_param_register),
-			(unsigned char *)&msb->arg, *mrq))
-			return 0;
-		break;
-	case 1:
-		memstick_init_req(*mrq, MS_TPC_SET_CMD,
-					&msb->transfer_cmd, 1);
+		memstick_init_req(*mrq, MS_TPC_EX_SET_CMD,
+					&msb->arg, sizeof(msb->arg));
 		break;
 
-	case 2: /* read the INT register */
+	case 1: /* read the INT register */
 		if (memstick_read_int_reg(card, *mrq, -1))
 			break;
 		card->state++;
 
-	case 3: /* process the int register */
+	case 2: /* process the int register */
 		intreg = (*mrq)->data[0];
 
 		if (intreg & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
 			dbg(card, "IO: card I/O error");
-			card->state = 6;
+			card->state = 5;
 			msb->io_error = -EIO;
 			goto again;
 		}
@@ -479,7 +472,7 @@ again:
 			}
 
 			memstick_read_int_reg_cleanup(card);
-			card->state = 7;
+			card->state = 6;
 			goto again;
 		}
 
@@ -492,7 +485,7 @@ again:
 		memstick_read_int_reg_cleanup(card);
 		card->state++;
 
-	case 4: /* init transfer of the data */
+	case 3: /* init transfer of the data */
 		t_offset = msb->current_sg->offset + msb->current_sg_offset;
 
 		sg_init_table(&t_sg, 1);
@@ -505,7 +498,7 @@ again:
 		(*mrq)->need_card_int = 1;
 		break;
 
-	case 5: /* switch to next page */
+	case 4: /* switch to next page */
 		msb->current_sg_offset += msb->page_size;
 		msb->data_transferred += msb->page_size;
 
@@ -514,15 +507,15 @@ again:
 			msb->current_sg = sg_next(msb->current_sg);
 		}
 
-		card->state = 2;
+		card->state = 1;
 		goto again;
 
-	case 6: /* after a error send STOP command */
+	case 5: /* after a error send STOP command */
 		command = MSPRO_CMD_STOP;
 		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
 		break;
 
-	case 7: /* request complete - get next one*/
+	case 6: /* request complete - get next one*/
 		spin_lock_irqsave(&msb->q_lock, flags);
 
 		if (msb->io_error)
@@ -572,9 +565,7 @@ static int mspro_block_setup_io(struct memstick_dev *card, int direction,
 	msb->data_transferred = 0;
 	msb->io_error = 0;
 
-	msb->transfer_cmd = command;
-
-	msb->arg.system = msb->system;
+	msb->arg.command = command;
 	msb->arg.data_count = cpu_to_be16(pages);
 	msb->arg.data_address = cpu_to_be32(sector);
 	msb->data_dir = direction;
diff --git a/drivers/memstick/core/mspro_block.h b/drivers/memstick/core/mspro_block.h
index ba9f78c..82ae2fe 100644
--- a/drivers/memstick/core/mspro_block.h
+++ b/drivers/memstick/core/mspro_block.h
@@ -151,8 +151,7 @@ struct mspro_block_data {
 
 	/* Handlers state */
 	unsigned char                    system;
-	unsigned char                    transfer_cmd;
-	struct mspro_param_register      arg;
+	struct mspro_cmdex_argument      arg;
 
 	struct scatterlist               *current_sg;
 	unsigned int                     current_sg_offset;
-- 
1.7.1

