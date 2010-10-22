Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0JVXy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0JVXyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xUVV5eILlQXPD/UUk8C4mxv8B5iovhMwJ3Pelbc1A6viWfVEzBFSXbMU1RtmjknlV9
         9dZiPazxE/ya3a1ThvnDNKnBhC2es1cZzAlUcF1llfI1MYSPZIdY03sa/sOEA+goHKVK
         GrTcI4uuz5C+K76u5j8lG2rNFOv9IQt4CyehA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 10/29] memstick: mspro: create _setup_io helper.
Date: Sat, 23 Oct 2010 01:53:38 +0200
Message-Id: <1287791637-10329-11-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function contains common parts of IO setup
for the state machine, thus reduces the risk
of using the state machine in wrong way.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |   46 ++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index cf98fa8..0d8b30b 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -561,6 +561,26 @@ again:
 
 /*** Data transfer ***/
 
+/* Common helper that prepares state for IO (read, write, read attributes) */
+static int mspro_block_setup_io(struct memstick_dev *card, int direction,
+				int sector, int pages, unsigned char command)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	msb->current_sg_offset = 0;
+	msb->current_sg = msb->req_sg;
+	msb->data_transferred = 0;
+	msb->io_error = 0;
+
+	msb->transfer_cmd = command;
+
+	msb->arg.system = msb->system;
+	msb->arg.data_count = cpu_to_be16(pages);
+	msb->arg.data_address = cpu_to_be32(sector);
+	msb->data_dir = direction;
+	return 0;
+}
+
 /*
  * Start execution of next block request,
  * or continue execution of the current one
@@ -602,18 +622,8 @@ again:
 
 	is_read = rq_data_dir(msb->block_req) == READ;
 
-	msb->current_sg_offset = 0;
-	msb->current_sg = msb->req_sg;
-	msb->data_transferred = 0;
-	msb->io_error = 0;
-
-	msb->transfer_cmd = is_read ?
-				MSPRO_CMD_READ_DATA :MSPRO_CMD_WRITE_DATA;
-
-	msb->arg.system = msb->system;
-	msb->arg.data_count = cpu_to_be16(pages);
-	msb->arg.data_address = cpu_to_be32(sec);
-	msb->data_dir = rq_data_dir(msb->block_req);
+	mspro_block_setup_io(card, rq_data_dir(msb->block_req), sec, pages,
+		is_read ? MSPRO_CMD_READ_DATA : MSPRO_CMD_WRITE_DATA);
 
 	dbg(card, "IO: %s: lba %x, pages %x", is_read ? "read" : "write",
 					(unsigned int)sec, pages);
@@ -834,16 +844,8 @@ static int mspro_block_read_attribute(struct memstick_dev *card,
 	dbg(card, "reading attribute space at offset %08x, size %d",
 								offset, len);
 	sg_init_one(&msb->req_sg[0], buffer, len);
-	msb->current_sg_offset = 0;
-	msb->current_sg = msb->req_sg;
-	msb->data_transferred = 0;
-	msb->io_error = 0;
-	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
-	msb->arg.system = msb->system;
-	msb->arg.data_count = cpu_to_be16(len / msb->page_size);
-	msb->arg.data_address = cpu_to_be32(offset / msb->page_size);
-	msb->data_dir = READ;
-
+	mspro_block_setup_io(card, READ, offset / msb->page_size,
+				len / msb->page_size, MSPRO_CMD_READ_ATRB);
 	return memstick_run_state_machine(card,
 					h_mspro_block_transfer_data, true);
 }
-- 
1.7.1

