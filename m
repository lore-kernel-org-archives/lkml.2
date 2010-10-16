Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0JPXNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 19:13:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63462 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0JPXNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 19:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XRhh1HyF0GxVh/jSZDQtCw9/tuFqX7uU1OI5q7T65JkLP0fwHkpsmG3lxg222JN/Xa
         IZ6B8GeDnujlvthjcC6JI1plXjZI5hTMg0Z7I3mKb3wkMfm61z+JRDaYc1hMk+ri9LXw
         P9Jc56NXEJfQyBooSTNN0Nl0CPpg1/lB6tvPE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 5/6] memstick: mspro_block: refactoring.
Date: Sun, 17 Oct 2010 01:12:53 +0200
Message-Id: <1287270774-18796-6-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287270774-18796-1-git-send-email-maximlevitsky@gmail.com>
References: <1287270774-18796-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a result of my attempt to make mspro_block to use the
new helpers I wrote for my ms_block

Among the way, I added support for CMDEX, a new feature of PRO sticks,
and that gives nice speed improvments.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c | 1097 +++++++++++++++--------------------
 drivers/memstick/core/mspro_block.h |  176 ++++++
 2 files changed, 653 insertions(+), 620 deletions(-)
 create mode 100644 drivers/memstick/core/mspro_block.h

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index d3f1a08..c589d26 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -2,6 +2,7 @@
  *  Sony MemoryStick Pro storage support
  *
  *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,7 +12,6 @@
  * that made this driver possible.
  *
  */
-
 #include <linux/blkdev.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
@@ -20,158 +20,14 @@
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/memstick.h>
-
-#define DRIVER_NAME "mspro_block"
+#include "mspro_block.h"
 
 static int major;
-module_param(major, int, 0644);
-
-#define MSPRO_BLOCK_MAX_SEGS  32
-#define MSPRO_BLOCK_MAX_PAGES ((2 << 16) - 1)
-
-#define MSPRO_BLOCK_SIGNATURE        0xa5c3
-#define MSPRO_BLOCK_MAX_ATTRIBUTES   41
-
-#define MSPRO_BLOCK_PART_SHIFT 3
-
-enum {
-	MSPRO_BLOCK_ID_SYSINFO         = 0x10,
-	MSPRO_BLOCK_ID_MODELNAME       = 0x15,
-	MSPRO_BLOCK_ID_MBR             = 0x20,
-	MSPRO_BLOCK_ID_PBR16           = 0x21,
-	MSPRO_BLOCK_ID_PBR32           = 0x22,
-	MSPRO_BLOCK_ID_SPECFILEVALUES1 = 0x25,
-	MSPRO_BLOCK_ID_SPECFILEVALUES2 = 0x26,
-	MSPRO_BLOCK_ID_DEVINFO         = 0x30
-};
-
-struct mspro_sys_attr {
-	size_t                  size;
-	void                    *data;
-	unsigned char           id;
-	char                    name[32];
-	struct device_attribute dev_attr;
-};
-
-struct mspro_attr_entry {
-	__be32 address;
-	__be32 size;
-	unsigned char id;
-	unsigned char reserved[3];
-} __attribute__((packed));
-
-struct mspro_attribute {
-	__be16 signature;
-	unsigned short          version;
-	unsigned char           count;
-	unsigned char           reserved[11];
-	struct mspro_attr_entry entries[];
-} __attribute__((packed));
-
-struct mspro_sys_info {
-	unsigned char  class;
-	unsigned char  reserved0;
-	__be16 block_size;
-	__be16 block_count;
-	__be16 user_block_count;
-	__be16 page_size;
-	unsigned char  reserved1[2];
-	unsigned char  assembly_date[8];
-	__be32 serial_number;
-	unsigned char  assembly_maker_code;
-	unsigned char  assembly_model_code[3];
-	__be16 memory_maker_code;
-	__be16 memory_model_code;
-	unsigned char  reserved2[4];
-	unsigned char  vcc;
-	unsigned char  vpp;
-	__be16 controller_number;
-	__be16 controller_function;
-	__be16 start_sector;
-	__be16 unit_size;
-	unsigned char  ms_sub_class;
-	unsigned char  reserved3[4];
-	unsigned char  interface_type;
-	__be16 controller_code;
-	unsigned char  format_type;
-	unsigned char  reserved4;
-	unsigned char  device_type;
-	unsigned char  reserved5[7];
-	unsigned char  mspro_id[16];
-	unsigned char  reserved6[16];
-} __attribute__((packed));
-
-struct mspro_mbr {
-	unsigned char boot_partition;
-	unsigned char start_head;
-	unsigned char start_sector;
-	unsigned char start_cylinder;
-	unsigned char partition_type;
-	unsigned char end_head;
-	unsigned char end_sector;
-	unsigned char end_cylinder;
-	unsigned int  start_sectors;
-	unsigned int  sectors_per_partition;
-} __attribute__((packed));
-
-struct mspro_specfile {
-	char           name[8];
-	char           ext[3];
-	unsigned char  attr;
-	unsigned char  reserved[10];
-	unsigned short time;
-	unsigned short date;
-	unsigned short cluster;
-	unsigned int   size;
-} __attribute__((packed));
-
-struct mspro_devinfo {
-	__be16 cylinders;
-	__be16 heads;
-	__be16 bytes_per_track;
-	__be16 bytes_per_sector;
-	__be16 sectors_per_track;
-	unsigned char  reserved[6];
-} __attribute__((packed));
-
-struct mspro_block_data {
-	struct memstick_dev   *card;
-	unsigned int          usage_count;
-	unsigned int          caps;
-	struct gendisk        *disk;
-	struct request_queue  *queue;
-	struct request        *block_req;
-	spinlock_t            q_lock;
-
-	unsigned short        page_size;
-	unsigned short        cylinders;
-	unsigned short        heads;
-	unsigned short        sectors_per_track;
-
-	unsigned char         system;
-	unsigned char         read_only:1,
-			      eject:1,
-			      has_request:1,
-			      data_dir:1,
-			      active:1;
-	unsigned char         transfer_cmd;
-
-	int                   (*mrq_handler)(struct memstick_dev *card,
-					     struct memstick_request **mrq);
-
-	struct attribute_group attr_group;
-
-	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
-	unsigned int          seg_count;
-	unsigned int          current_seg;
-	unsigned int          current_page;
-};
+static int debug;
 
 static DEFINE_IDR(mspro_block_disk_idr);
 static DEFINE_MUTEX(mspro_block_disk_lock);
 
-static int mspro_block_complete_req(struct memstick_dev *card, int error);
-
 /*** Block device ***/
 
 static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
@@ -180,7 +36,6 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	struct mspro_block_data *msb = disk->private_data;
 	int rc = -ENXIO;
 
-	lock_kernel();
 	mutex_lock(&mspro_block_disk_lock);
 
 	if (msb && msb->card) {
@@ -192,8 +47,6 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-	unlock_kernel();
-
 	return rc;
 }
 
@@ -218,16 +71,13 @@ static int mspro_block_disk_release(struct gendisk *disk)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-
 	return 0;
 }
 
 static int mspro_block_bd_release(struct gendisk *disk, fmode_t mode)
 {
 	int ret;
-	lock_kernel();
 	ret = mspro_block_disk_release(disk);
-	unlock_kernel();
 	return ret;
 }
 
@@ -522,263 +372,483 @@ static sysfs_show_t mspro_block_attr_show(unsigned char tag)
  * finished (and request processor should come back some time later).
  */
 
-static int h_mspro_block_req_init(struct memstick_dev *card,
-				  struct memstick_request **mrq)
+static int h_mspro_block_reset(struct memstick_dev *card,
+					struct memstick_request **mrq)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct ms_status_register *status;
+	u8 intreg;
 
-	*mrq = &card->current_mrq;
-	card->next_request = msb->mrq_handler;
-	return 0;
-}
+	memstick_allocate_request(card, mrq);
+	if ((*mrq)->error) {
+		dbg(card, "Error here");
+		return memstick_complete_request(card, *mrq, 0);
+	}
 
-static int h_mspro_block_default(struct memstick_dev *card,
-				 struct memstick_request **mrq)
-{
-	return mspro_block_complete_req(card, (*mrq)->error);
-}
+again:
+	switch (card->state) {
 
-static int h_mspro_block_default_bad(struct memstick_dev *card,
-				     struct memstick_request **mrq)
-{
-	return -ENXIO;
-}
+	case 0: /* send request for INT reg */
+		if (memstick_read_int_reg(card, *mrq, 10000))
+			break;
+		card->state++;
 
-static int h_mspro_block_get_ro(struct memstick_dev *card,
-				struct memstick_request **mrq)
-{
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	case 1: /* process the INT reg and loop if nessesary */
+		intreg = (*mrq)->data[0];
 
-	if (!(*mrq)->error) {
-		if ((*mrq)->data[offsetof(struct ms_status_register, status0)]
-		    & MEMSTICK_STATUS0_WP)
-			msb->read_only = 1;
-		else
-			msb->read_only = 0;
+		if (intreg & MEMSTICK_INT_ERR) {
+			if ((intreg & MEMSTICK_INT_CMDNAK)) {
+				msb->read_only = true;
+				return memstick_complete_request(card, *mrq, 0);
+			}
+			return memstick_complete_request(card, *mrq, -EIO);
+		}
+
+		if (intreg & MEMSTICK_INT_CMDNAK)
+			return memstick_complete_request(card, *mrq, -EIO);
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
+		return memstick_complete_request(card, *mrq, 0);
 	}
 
-	return mspro_block_complete_req(card, (*mrq)->error);
+	card->state++;
+	return 0;
+
 }
 
-static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
-				      struct memstick_request **mrq)
+static int h_mspro_block_switch_interface(struct memstick_dev *card,
+					struct memstick_request **mrq)
 {
-	dev_dbg(&card->dev, "wait for ced: value %x\n", (*mrq)->data[0]);
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int error;
+	memstick_allocate_request(card, mrq);
+	if ((*mrq)->error)
+		return memstick_complete_request(card, *mrq, 0);
+
+	switch (card->state) {
 
-	if (!(*mrq)->error) {
-		if ((*mrq)->data[0] & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR))
-			(*mrq)->error = -EFAULT;
-		else if (!((*mrq)->data[0] & MEMSTICK_INT_CED))
+	case 0: /* send switch command to the device */
+		if (!memstick_write_regs(card,
+			offsetof(struct mspro_register, param),
+			1,
+			&msb->system,
+			*mrq))
 			return 0;
+		break;
+
+	case 1: /* switch the host intrface + send dummy read to verify that */
+		/* connection works */
+		error = card->host->set_param(card->host,
+				MEMSTICK_INTERFACE, msb->target_interface);
+		if (error)
+			return memstick_complete_request(card, *mrq, -EFAULT);
+
+		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+		break;
+
+	case 2: /* done */
+		return memstick_complete_request(card, *mrq, 0);
+
 	}
 
-	return mspro_block_complete_req(card, (*mrq)->error);
+	card->state++;
+	return 0;
 }
 
+/* State machine that handles the IO. Heart of the driver */
 static int h_mspro_block_transfer_data(struct memstick_dev *card,
 				       struct memstick_request **mrq)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	unsigned char t_val = 0;
+	unsigned char intreg = 0, command;
 	struct scatterlist t_sg = { 0 };
+	unsigned long flags;
+	int error;
 	size_t t_offset;
 
-	if ((*mrq)->error)
-		return mspro_block_complete_req(card, (*mrq)->error);
+	memstick_allocate_request(card, mrq);
 
-	switch ((*mrq)->tpc) {
-	case MS_TPC_WRITE_REG:
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
-		(*mrq)->need_card_int = 1;
-		return 0;
-	case MS_TPC_SET_CMD:
-		t_val = (*mrq)->int_reg;
-		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT)
-			goto has_int_reg;
-		return 0;
-	case MS_TPC_GET_INT:
-		t_val = (*mrq)->data[0];
-has_int_reg:
-		if (t_val & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
-			t_val = MSPRO_CMD_STOP;
-			memstick_init_req(*mrq, MS_TPC_SET_CMD, &t_val, 1);
-			card->next_request = h_mspro_block_default;
-			return 0;
+	if ((*mrq)->error) {
+		dbg(card, "IO: error (%d) executing %s", (*mrq)->error,
+			memstick_debug_get_tpc_name((*mrq)->tpc));
+		msb->io_error = true;
+		card->state = 5;
+	}
+again:
+	switch (card->state) {
+
+	case 0: /* send read/write command + args */
+		memstick_init_req(*mrq, MS_TPC_EX_SET_CMD,
+					&msb->arg, sizeof(msb->arg));
+		break;
+
+	case 1: /* read the INT register */
+		if (memstick_read_int_reg(card, *mrq, -1))
+			break;
+		card->state++;
+
+	case 2: /* process the int register */
+		intreg = (*mrq)->data[0];
+
+		if (intreg & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
+			dbg(card, "IO: card I/O error");
+			card->state = 5;
+			msb->io_error = true;
+			goto again;
 		}
 
-		if (msb->current_page
-		    == (msb->req_sg[msb->current_seg].length
-			/ msb->page_size)) {
-			msb->current_page = 0;
-			msb->current_seg++;
-
-			if (msb->current_seg == msb->seg_count) {
-				if (t_val & MEMSTICK_INT_CED) {
-					return mspro_block_complete_req(card,
-									0);
-				} else {
-					card->next_request
-						= h_mspro_block_wait_for_ced;
-					memstick_init_req(*mrq, MS_TPC_GET_INT,
-							  NULL, 1);
-					return 0;
-				}
+		/* we need CED for last page */
+		if (!msb->current_sg) {
+			if (!(intreg & MEMSTICK_INT_CED)) {
+				card->state--;
+				goto again;
 			}
+
+			memstick_read_int_reg_cleanup(card);
+			card->state = 6;
+			goto again;
 		}
 
-		if (!(t_val & MEMSTICK_INT_BREQ)) {
-			memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-			return 0;
+		/* And BREQ for non last... */
+		if (!(intreg & MEMSTICK_INT_BREQ)) {
+			card->state--;
+			goto again;
 		}
 
-		t_offset = msb->req_sg[msb->current_seg].offset;
-		t_offset += msb->current_page * msb->page_size;
+		memstick_read_int_reg_cleanup(card);
+		card->state++;
+
+	case 3: /* init transfer of the data */
+		t_offset = msb->current_sg->offset;
+		t_offset += msb->current_sg_offset;
 
+		sg_init_table(&t_sg, 1);
 		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
-			    msb->page_size, offset_in_page(t_offset));
+			nth_page(sg_page(msb->current_sg),
+			t_offset >> PAGE_SHIFT),
+			msb->page_size,
+			offset_in_page(t_offset));
 
 		memstick_init_req_sg(*mrq, msb->data_dir == READ
 					   ? MS_TPC_READ_LONG_DATA
 					   : MS_TPC_WRITE_LONG_DATA,
 				     &t_sg);
 		(*mrq)->need_card_int = 1;
-		return 0;
-	case MS_TPC_READ_LONG_DATA:
-	case MS_TPC_WRITE_LONG_DATA:
-		msb->current_page++;
-		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT) {
-			t_val = (*mrq)->int_reg;
-			goto has_int_reg;
-		} else {
-			memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-			return 0;
+		break;
+
+	case 4: /* switch to next page */
+		msb->current_sg_offset += msb->page_size;
+		msb->data_transferred += msb->page_size;
+
+		if (msb->current_sg_offset == msb->current_sg->length) {
+			msb->current_sg_offset = 0;
+			msb->current_sg = sg_next(msb->current_sg);
 		}
 
+		card->state = 1;
+		goto again;
+
+	case 5: /* after a error send STOP command */
+		command = MSPRO_CMD_STOP;
+		memstick_init_req(*mrq, MS_TPC_SET_CMD, &command, 1);
+		break;
+
+	case 6: /* request complete - get next one*/
+		spin_lock_irqsave(&msb->q_lock, flags);
+
+		if (msb->io_error)
+			(*mrq)->error = -EIO;
+
+		if (msb->block_req) {
+			mspro_block_complete_req(card, (*mrq)->error);
+			error = mspro_block_issue_req(card);
+
+			if (!msb->block_req) {
+				dbg_v(card, "IO: out of requests");
+				memstick_complete_request(card, *mrq, 0);
+				spin_unlock_irqrestore(&msb->q_lock, flags);
+				return -EAGAIN;
+			}
+
+			spin_unlock_irqrestore(&msb->q_lock, flags);
+			(*mrq)->error = 0;
+			card->state = 0;
+			goto again;
+
+		} else {
+			spin_unlock_irqrestore(&msb->q_lock, flags);
+			return memstick_complete_request(card, *mrq, 0);
+		}
 	default:
 		BUG();
 	}
+
+	card->state++;
+	return 0;
 }
 
-/*** Data transfer ***/
+/* Common helper that prepares state for IO (read, write, read attributes) */
+static int mspro_block_setup_io(struct memstick_dev *card, int direction,
+				int sector, int pages, unsigned char command)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	msb->current_sg_offset = 0;
+	msb->current_sg = msb->req_sg;
+	msb->data_transferred = 0;
+	msb->io_error = false;
+
+	msb->arg.command = command;
+	msb->arg.data_count = cpu_to_be16(pages);
+	msb->arg.data_address = cpu_to_be32(sector);
+	msb->data_dir = direction;
+	return 0;
+}
 
-static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
+/*
+ * Start execution of next block request,
+ * or continue execution of the current one
+ */
+static int mspro_block_issue_req(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	sector_t t_sec;
-	unsigned int count;
-	struct mspro_param_register param;
-
-try_again:
-	while (chunk) {
-		msb->current_page = 0;
-		msb->current_seg = 0;
-		msb->seg_count = blk_rq_map_sg(msb->block_req->q,
-					       msb->block_req,
-					       msb->req_sg);
-
-		if (!msb->seg_count) {
-			chunk = __blk_end_request_cur(msb->block_req, -ENOMEM);
-			continue;
+	sector_t sec;
+	bool is_read;
+	unsigned int pages;
+again:
+	/* get next request from block core if we don't have one */
+	if (!msb->block_req) {
+		dbg(card, "IO: fetching new request from block queue");
+		msb->block_req = blk_fetch_request(msb->queue);
+		if (!msb->block_req) {
+			dbg(card, "IO: failed, because queue is empty");
+			return -EAGAIN;
 		}
+	}
 
-		t_sec = blk_rq_pos(msb->block_req) << 9;
-		sector_div(t_sec, msb->page_size);
+	sec = blk_rq_pos(msb->block_req) << 9;
+	sector_div(sec, msb->page_size);
+	pages = blk_rq_bytes(msb->block_req) / msb->page_size;
 
-		count = blk_rq_bytes(msb->block_req);
-		count /= msb->page_size;
+	if (!blk_rq_map_sg(msb->block_req->q, msb->block_req, msb->req_sg)) {
+		dbg(card, "IO: out of memory");
+		if (!__blk_end_request_cur(msb->block_req, -ENOMEM))
+			msb->block_req = NULL;
+		goto again;
+	}
 
-		param.system = msb->system;
-		param.data_count = cpu_to_be16(count);
-		param.data_address = cpu_to_be32((uint32_t)t_sec);
-		param.tpc_param = 0;
+	is_read = rq_data_dir(msb->block_req) == READ;
 
-		msb->data_dir = rq_data_dir(msb->block_req);
-		msb->transfer_cmd = msb->data_dir == READ
-				    ? MSPRO_CMD_READ_DATA
-				    : MSPRO_CMD_WRITE_DATA;
+	mspro_block_setup_io(card, rq_data_dir(msb->block_req), sec, pages,
+		is_read ? MSPRO_CMD_READ_DATA : MSPRO_CMD_WRITE_DATA);
 
-		dev_dbg(&card->dev, "data transfer: cmd %x, "
-			"lba %x, count %x\n", msb->transfer_cmd,
-			be32_to_cpu(param.data_address), count);
+	dbg(card, "IO: %s: lba %x, pages %x", is_read ? "read" : "write",
+					(unsigned int)sec, pages);
 
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_transfer_data;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-				  &param, sizeof(param));
-		memstick_new_req(card->host);
-		return 0;
+	/* can't use memstick_run_state_machine because we don't block */
+	card->next_request = h_mspro_block_transfer_data;
+	return 0;
+}
+
+/*
+ * Completes execution of current block request.
+ *  After execution of this function, the msb->block_req might or might not
+ *  be NULL. If it is, it means we don't have any more requests to process
+ */
+static void mspro_block_complete_req(struct memstick_dev *card, int error)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	dbg(card, "IO: transferred %d bytes ", msb->data_transferred);
+
+	if (msb->data_transferred) {
+		if (!__blk_end_request(msb->block_req, 0,
+						msb->data_transferred))
+			msb->block_req = NULL;
 	}
 
-	dev_dbg(&card->dev, "blk_fetch\n");
-	msb->block_req = blk_fetch_request(msb->queue);
-	if (!msb->block_req) {
-		dev_dbg(&card->dev, "issue end\n");
-		return -EAGAIN;
+	if (error && msb->block_req) {
+		dbg(card, "IO: failure (%d) of transfter of one sector", error);
+		if (!__blk_end_request(msb->block_req, 0, msb->page_size))
+			msb->block_req = NULL;
 	}
+}
+
+/* Read data from attribute space */
+static int mspro_block_read_attribute(struct memstick_dev *card,
+					int offset, void *buffer, int len)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
 
-	dev_dbg(&card->dev, "trying again\n");
-	chunk = 1;
-	goto try_again;
+	dbg(card, "reading attribute space at offset %08x, size %d",
+								offset, len);
+	sg_init_one(&msb->req_sg[0], buffer, len);
+	mspro_block_setup_io(card, READ, offset / msb->page_size,
+				len / msb->page_size, MSPRO_CMD_READ_ATRB);
+	return memstick_run_state_machine(card, h_mspro_block_transfer_data);
 }
 
-static int mspro_block_complete_req(struct memstick_dev *card, int error)
+/* Memory allocated for attributes by this function should be freed by
+ * mspro_block_data_clear, no matter if the initialization process succeded
+ * or failed.
+ */
+static int mspro_block_read_attributes(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	int chunk, cnt;
-	unsigned int t_len = 0;
-	unsigned long flags;
+	struct mspro_attribute *attr = NULL;
+	struct mspro_sys_attr *s_attr = NULL;
 
-	spin_lock_irqsave(&msb->q_lock, flags);
-	dev_dbg(&card->dev, "complete %d, %d\n", msb->has_request ? 1 : 0,
-		error);
+	unsigned char *buffer = NULL;
+	unsigned int buffer_size, new_buffer_size, buffer_address = 0;
+	unsigned int attr_size, attr_addr, attr_page_offset;
 
-	if (msb->has_request) {
-		/* Nothing to do - not really an error */
-		if (error == -EAGAIN)
-			error = 0;
+	int cnt, error, attr_count;
 
-		if (error || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
-			if (msb->data_dir == READ) {
-				for (cnt = 0; cnt < msb->current_seg; cnt++)
-					t_len += msb->req_sg[cnt].length
-						 / msb->page_size;
+	/* Allocate initial buffer */
+	buffer_size = msb->page_size;
+	buffer_address = 0;
+	buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
-					if (msb->current_page)
-						t_len += msb->current_page - 1;
+	/* Read the attribute list */
+	error = mspro_block_read_attribute(card, 0, buffer, buffer_size);
+	if (error)
+		goto out_free_buffer;
 
-					t_len *= msb->page_size;
-			}
-		} else
-			t_len = blk_rq_bytes(msb->block_req);
+	attr = kmalloc(buffer_size, GFP_KERNEL);
+	if (!attr)
+		goto out_free_buffer;
+	memcpy(attr, buffer, buffer_size);
+
+
+	/* Test it for sanity */
+	if (be16_to_cpu(attr->signature) != MSPRO_BLOCK_SIGNATURE) {
+		printk(KERN_ERR "%s: unrecognized device signature %x\n",
+		       dev_name(&card->dev), be16_to_cpu(attr->signature));
+		error = -ENODEV;
+		goto out_free_buffer;
+	}
 
-		dev_dbg(&card->dev, "transferred %x (%d)\n", t_len, error);
+	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES)
+		printk(KERN_WARNING "%s: way too many attribute entries\n",
+		       dev_name(&card->dev));
 
-		if (error && !t_len)
-			t_len = blk_rq_cur_bytes(msb->block_req);
+	attr_count = min((int)attr->count, (int)MSPRO_BLOCK_MAX_ATTRIBUTES);
 
-		chunk = __blk_end_request(msb->block_req, error, t_len);
+	/* Allocate attribute group */
+	error = -ENOMEM;
+	msb->attr_group.attrs = kzalloc((attr_count + 1) *
+					sizeof(struct attribute), GFP_KERNEL);
+	if (!msb->attr_group.attrs)
+		goto out_free_buffer;
+
+	msb->attr_group.name = "media_attributes";
+
+	/* Read all other attributes */
+	for (cnt = 0; cnt < attr_count; ++cnt) {
+
+		/* Create new sysfs attribute */
+		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
+		error = -ENOMEM;
+		if (!s_attr)
+			goto out_free_buffer;
 
-		error = mspro_block_issue_req(card, chunk);
+		sysfs_attr_init(&s_attr->dev_attr.attr);
+		s_attr->dev_attr.attr.name = s_attr->name;
+		s_attr->dev_attr.attr.mode = S_IRUGO;
+		s_attr->id = attr->entries[cnt].id;
+		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
 
-		if (!error)
-			goto out;
+		if (mspro_block_attr_name(s_attr->id))
+			snprintf(s_attr->name, sizeof(s_attr->name), "%s",
+				 mspro_block_attr_name(attr->entries[cnt].id));
 		else
-			msb->has_request = 0;
-	} else {
-		if (!error)
-			error = -EAGAIN;
+			snprintf(s_attr->name, sizeof(s_attr->name),
+				 "attr_x%02x", attr->entries[cnt].id);
+
+		msb->attr_group.attrs[cnt] = &s_attr->dev_attr.attr;
+
+
+		attr_addr = be32_to_cpu(attr->entries[cnt].address);
+		attr_size = be32_to_cpu(attr->entries[cnt].size);
+		attr_page_offset = attr_addr % msb->page_size;
+
+		if (!attr_size)
+			continue;
+
+		dbg(card, "adding attribute %d: id %x, address %x, size %x",
+			cnt, s_attr->id, attr_addr, attr_size);
+
+		s_attr->size = attr_size;
+		s_attr->data = kmalloc(attr_size, GFP_KERNEL);
+		if (!s_attr->data) {
+			error = -ENOMEM;
+			goto out_free_buffer;
+		}
+
+		/* If we already read that attribute as part of last one,
+								use that */
+		if (round_down(attr_addr, msb->page_size) == buffer_address &&
+		    attr_addr + attr_size <= buffer_address + buffer_size) {
+
+			memcpy(s_attr->data, buffer + attr_page_offset,
+								attr_size);
+			continue;
+		}
+
+		/* Reallocate buffer if nessesary */
+		new_buffer_size = roundup(attr_page_offset + attr_size,
+								msb->page_size);
+		buffer_address = round_down(attr_addr, msb->page_size);
+
+		if (new_buffer_size > buffer_size) {
+			kfree(buffer);
+			buffer_size = new_buffer_size;
+			buffer = kmalloc(buffer_size, GFP_KERNEL);
+			if (!buffer)
+				goto out_free_buffer;
+
+		}
+
+		/* Finaly read and save the attrubute */
+		error = mspro_block_read_attribute(card,
+			buffer_address,
+			buffer, new_buffer_size);
+		memcpy(s_attr->data, buffer + attr_page_offset, attr_size);
 	}
 
-	card->next_request = h_mspro_block_default_bad;
-	complete_all(&card->mrq_complete);
-out:
-	spin_unlock_irqrestore(&msb->q_lock, flags);
+	error = 0;
+out_free_buffer:
+	kfree(buffer);
+	kfree(attr);
 	return error;
 }
 
+/*
+ * This pauses driver.
+ * Makes sure that driver won't send any commands to the device
+ */
 static void mspro_block_stop(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
@@ -787,7 +857,7 @@ static void mspro_block_stop(struct memstick_dev *card)
 
 	while (1) {
 		spin_lock_irqsave(&msb->q_lock, flags);
-		if (!msb->has_request) {
+		if (!msb->block_req) {
 			blk_stop_queue(msb->queue);
 			rc = 1;
 		}
@@ -800,6 +870,7 @@ static void mspro_block_stop(struct memstick_dev *card)
 	}
 }
 
+/* This undoes effects of mspro_block_stop */
 static void mspro_block_start(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
@@ -829,348 +900,129 @@ static void mspro_block_submit_req(struct request_queue *q)
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct request *req = NULL;
 
-	if (msb->has_request)
+	dbg(card, "IO: block layer submits us new request");
+
+	if (msb->block_req) {
+		dbg(card, "IO: Already have an request");
 		return;
+	}
 
 	if (msb->eject) {
+		dbg(card, "IO: Refusing requests on removed card");
 		while ((req = blk_fetch_request(q)) != NULL)
 			__blk_end_request_all(req, -ENODEV);
-
 		return;
 	}
 
-	msb->has_request = 1;
-	if (mspro_block_issue_req(card, 0))
-		msb->has_request = 0;
-}
-
-/*** Initialization ***/
-
-static int mspro_block_wait_for_ced(struct memstick_dev *card)
-{
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_wait_for_ced;
-	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	return card->current_mrq.error;
+	if (mspro_block_issue_req(card)) {
+		dbg(card, "IO: Falure to issue request");
+		msb->block_req = NULL;
+	} else
+		memstick_new_req(card->host);
 }
 
-static int mspro_block_set_interface(struct memstick_dev *card,
-				     unsigned char sys_reg)
+/* Reset the card */
+static int mspro_block_reset(struct memstick_dev *card, bool full)
 {
 	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct mspro_param_register param = {
-		.system = sys_reg,
-		.data_count = 0,
-		.data_address = 0,
-		.tpc_param = 0
-	};
+	int error;
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_default;
-	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-			  sizeof(param));
-	memstick_new_req(host);
-	wait_for_completion(&card->mrq_complete);
-	return card->current_mrq.error;
-}
+	dbg(card, "resetting the card");
 
-static int mspro_block_switch_interface(struct memstick_dev *card)
-{
-	struct memstick_host *host = card->host;
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	int rc = 0;
+	msb->system = MEMSTICK_SYS_SERIAL;
 
-try_again:
-	if (msb->caps & MEMSTICK_CAP_PAR4)
-		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR4);
-	else
-		return 0;
+	error = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	if (error)
+		return error;
+	msleep(50);
 
-	if (rc) {
-		printk(KERN_WARNING
-		       "%s: could not switch to 4-bit mode, error %d\n",
-		       dev_name(&card->dev), rc);
-		return 0;
-	}
+	error = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	if (error)
+		return error;
 
-	msb->system = MEMSTICK_SYS_PAR4;
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
-	}
+	error = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+	if (error)
+		return error;
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_default;
-	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	rc = card->current_mrq.error;
+	msleep(150);
 
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
+	/* Invalidate the register window */
+	memstick_invalidate_reg_window(card);
+
+	error = memstick_run_state_machine(card, h_mspro_block_reset);
+	if (error) {
+		dbg(card, "card reset failure");
+		return error;
 	}
-	return rc;
+
+	return mspro_block_switch_interface(card);
 }
 
-/* Memory allocated for attributes by this function should be freed by
- * mspro_block_data_clear, no matter if the initialization process succeded
- * or failed.
- */
-static int mspro_block_read_attributes(struct memstick_dev *card)
+/* Attempts to switch to faster interface. Clears capablity flags if fails */
+static int mspro_block_switch_interface(struct memstick_dev *card)
 {
+	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct mspro_param_register param = {
-		.system = msb->system,
-		.data_count = cpu_to_be16(1),
-		.data_address = 0,
-		.tpc_param = 0
-	};
-	struct mspro_attribute *attr = NULL;
-	struct mspro_sys_attr *s_attr = NULL;
-	unsigned char *buffer = NULL;
-	int cnt, rc, attr_count;
-	unsigned int addr;
-	unsigned short page_count;
+	int error = 0;
 
-	attr = kmalloc(msb->page_size, GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
-	sg_init_one(&msb->req_sg[0], attr, msb->page_size);
-	msb->seg_count = 1;
-	msb->current_seg = 0;
-	msb->current_page = 0;
-	msb->data_dir = READ;
-	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
-
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_transfer_data;
-	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-			  sizeof(param));
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-	if (card->current_mrq.error) {
-		rc = card->current_mrq.error;
-		goto out_free_attr;
-	}
-
-	if (be16_to_cpu(attr->signature) != MSPRO_BLOCK_SIGNATURE) {
-		printk(KERN_ERR "%s: unrecognized device signature %x\n",
-		       dev_name(&card->dev), be16_to_cpu(attr->signature));
-		rc = -ENODEV;
-		goto out_free_attr;
-	}
-
-	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES) {
-		printk(KERN_WARNING "%s: way too many attribute entries\n",
-		       dev_name(&card->dev));
-		attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
-	} else
-		attr_count = attr->count;
+	if (!(card->caps & host->caps & MEMSTICK_CAP_PAR4))
+		return 0;
 
-	msb->attr_group.attrs = kzalloc((attr_count + 1)
-					* sizeof(struct attribute),
-					GFP_KERNEL);
-	if (!msb->attr_group.attrs) {
-		rc = -ENOMEM;
-		goto out_free_attr;
-	}
-	msb->attr_group.name = "media_attributes";
+	dbg(card, "trying to switch to parallel 4 bit inteface");
 
-	buffer = kmalloc(msb->page_size, GFP_KERNEL);
-	if (!buffer) {
-		rc = -ENOMEM;
-		goto out_free_attr;
+	msb->system = MEMSTICK_SYS_PAR4;
+	msb->target_interface = MEMSTICK_PAR4;
+	error = memstick_run_state_machine(card,
+						h_mspro_block_switch_interface);
+	if (error) {
+		dbg(card, "failure to switch to parallel 4 bit inteface");
+		card->caps &= ~MEMSTICK_CAP_PAR4;
+		return mspro_block_reset(card, true);
 	}
-	memcpy(buffer, (char *)attr, msb->page_size);
-	page_count = 1;
-
-	for (cnt = 0; cnt < attr_count; ++cnt) {
-		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
-		if (!s_attr) {
-			rc = -ENOMEM;
-			goto out_free_buffer;
-		}
-
-		msb->attr_group.attrs[cnt] = &s_attr->dev_attr.attr;
-		addr = be32_to_cpu(attr->entries[cnt].address);
-		rc = be32_to_cpu(attr->entries[cnt].size);
-		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
-			"size %x\n", cnt, attr->entries[cnt].id, addr, rc);
-		s_attr->id = attr->entries[cnt].id;
-		if (mspro_block_attr_name(s_attr->id))
-			snprintf(s_attr->name, sizeof(s_attr->name), "%s",
-				 mspro_block_attr_name(attr->entries[cnt].id));
-		else
-			snprintf(s_attr->name, sizeof(s_attr->name),
-				 "attr_x%02x", attr->entries[cnt].id);
-
-		sysfs_attr_init(&s_attr->dev_attr.attr);
-		s_attr->dev_attr.attr.name = s_attr->name;
-		s_attr->dev_attr.attr.mode = S_IRUGO;
-		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
 
-		if (!rc)
-			continue;
-
-		s_attr->size = rc;
-		s_attr->data = kmalloc(rc, GFP_KERNEL);
-		if (!s_attr->data) {
-			rc = -ENOMEM;
-			goto out_free_buffer;
-		}
-
-		if (((addr / msb->page_size)
-		     == be32_to_cpu(param.data_address))
-		    && (((addr + rc - 1) / msb->page_size)
-			== be32_to_cpu(param.data_address))) {
-			memcpy(s_attr->data, buffer + addr % msb->page_size,
-			       rc);
-			continue;
-		}
-
-		if (page_count <= (rc / msb->page_size)) {
-			kfree(buffer);
-			page_count = (rc / msb->page_size) + 1;
-			buffer = kmalloc(page_count * msb->page_size,
-					 GFP_KERNEL);
-			if (!buffer) {
-				rc = -ENOMEM;
-				goto out_free_attr;
-			}
-		}
-
-		param.system = msb->system;
-		param.data_count = cpu_to_be16((rc / msb->page_size) + 1);
-		param.data_address = cpu_to_be32(addr / msb->page_size);
-		param.tpc_param = 0;
-
-		sg_init_one(&msb->req_sg[0], buffer,
-			    be16_to_cpu(param.data_count) * msb->page_size);
-		msb->seg_count = 1;
-		msb->current_seg = 0;
-		msb->current_page = 0;
-		msb->data_dir = READ;
-		msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
-
-		dev_dbg(&card->dev, "reading attribute pages %x, %x\n",
-			be32_to_cpu(param.data_address),
-			be16_to_cpu(param.data_count));
-
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_transfer_data;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-				  (char *)&param, sizeof(param));
-		memstick_new_req(card->host);
-		wait_for_completion(&card->mrq_complete);
-		if (card->current_mrq.error) {
-			rc = card->current_mrq.error;
-			goto out_free_buffer;
-		}
+	if (!(card->caps & host->caps & MEMSTICK_CAP_PAR8))
+		return 0;
 
-		memcpy(s_attr->data, buffer + addr % msb->page_size, rc);
+	msb->system = MEMSTICK_SYS_PAR8;
+	msb->target_interface = MEMSTICK_PAR8;
+	dbg(card, "trying to switch to parallel 8 bit inteface");
+	error = memstick_run_state_machine(card,
+					h_mspro_block_switch_interface);
+	if (error) {
+		dbg(card, "failure to switch to parallel 8 bit inteface");
+		card->caps &= ~MEMSTICK_CAP_PAR8;
+		return mspro_block_reset(card, true);
 	}
 
-	rc = 0;
-out_free_buffer:
-	kfree(buffer);
-out_free_attr:
-	kfree(attr);
-	return rc;
+	return error;
 }
 
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
-
-	msb->caps = host->caps;
+	/* TODO: can't we know what card supports from attributes? */
+	card->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
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
@@ -1202,6 +1054,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	msb->cylinders = be16_to_cpu(dev_info->cylinders);
 	msb->heads = be16_to_cpu(dev_info->heads);
 	msb->sectors_per_track = be16_to_cpu(dev_info->sectors_per_track);
+	sg_init_table(msb->req_sg, MSPRO_BLOCK_MAX_SEGS);
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
@@ -1257,7 +1110,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	capacity *= be16_to_cpu(sys_info->block_size);
 	capacity *= msb->page_size >> 9;
 	set_capacity(msb->disk, capacity);
-	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
+	dbg(card, "capacity set %ld", capacity);
 
 	add_disk(msb->disk);
 	msb->active = 1;
@@ -1345,7 +1198,7 @@ static void mspro_block_remove(struct memstick_dev *card)
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 
 	del_gendisk(msb->disk);
-	dev_dbg(&card->dev, "mspro block remove\n");
+	dbg(card, "mspro block remove");
 
 	blk_cleanup_queue(msb->queue);
 	msb->queue = NULL;
@@ -1485,6 +1338,10 @@ static void __exit mspro_block_exit(void)
 module_init(mspro_block_init);
 module_exit(mspro_block_exit);
 
+module_param(major, int, 0644);
+module_param(debug, int, 0644);
+
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("Sony MemoryStickPro block device driver");
diff --git a/drivers/memstick/core/mspro_block.h b/drivers/memstick/core/mspro_block.h
new file mode 100644
index 0000000..86a340d
--- /dev/null
+++ b/drivers/memstick/core/mspro_block.h
@@ -0,0 +1,176 @@
+/*
+ *  Sony MemoryStick Pro storage support
+ *
+ *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Special thanks to Carlos Corbacho for providing various MemoryStick cards
+ * that made this driver possible.
+ *
+ */
+
+#define DRIVER_NAME "mspro_block"
+
+#define MSPRO_BLOCK_MAX_SEGS  32
+#define MSPRO_BLOCK_MAX_PAGES ((2 << 16) - 1)
+
+#define MSPRO_BLOCK_SIGNATURE        0xa5c3
+#define MSPRO_BLOCK_MAX_ATTRIBUTES   41
+
+#define MSPRO_BLOCK_PART_SHIFT 3
+
+enum {
+	MSPRO_BLOCK_ID_SYSINFO         = 0x10,
+	MSPRO_BLOCK_ID_MODELNAME       = 0x15,
+	MSPRO_BLOCK_ID_MBR             = 0x20,
+	MSPRO_BLOCK_ID_PBR16           = 0x21,
+	MSPRO_BLOCK_ID_PBR32           = 0x22,
+	MSPRO_BLOCK_ID_SPECFILEVALUES1 = 0x25,
+	MSPRO_BLOCK_ID_SPECFILEVALUES2 = 0x26,
+	MSPRO_BLOCK_ID_DEVINFO         = 0x30
+};
+
+struct mspro_sys_attr {
+	size_t                  size;
+	void                    *data;
+	unsigned char           id;
+	char                    name[32];
+	struct device_attribute dev_attr;
+};
+
+struct mspro_attr_entry {
+	__be32 address;
+	__be32 size;
+	unsigned char id;
+	unsigned char reserved[3];
+} __packed;
+
+struct mspro_attribute {
+	__be16 signature;
+	unsigned short          version;
+	unsigned char           count;
+	unsigned char           reserved[11];
+	struct mspro_attr_entry entries[];
+} __packed;
+
+struct mspro_sys_info {
+	unsigned char  class;
+	unsigned char  reserved0;
+	__be16 block_size;
+	__be16 block_count;
+	__be16 user_block_count;
+	__be16 page_size;
+	unsigned char  reserved1[2];
+	unsigned char  assembly_date[8];
+	__be32 serial_number;
+	unsigned char  assembly_maker_code;
+	unsigned char  assembly_model_code[3];
+	__be16 memory_maker_code;
+	__be16 memory_model_code;
+	unsigned char  reserved2[4];
+	unsigned char  vcc;
+	unsigned char  vpp;
+	__be16 controller_number;
+	__be16 controller_function;
+	__be16 start_sector;
+	__be16 unit_size;
+	unsigned char  ms_sub_class;
+	unsigned char  reserved3[4];
+	unsigned char  interface_type;
+	__be16 controller_code;
+	unsigned char  format_type;
+	unsigned char  reserved4;
+	unsigned char  device_type;
+	unsigned char  reserved5[7];
+	unsigned char  mspro_id[16];
+	unsigned char  reserved6[16];
+} __packed;
+
+struct mspro_mbr {
+	unsigned char boot_partition;
+	unsigned char start_head;
+	unsigned char start_sector;
+	unsigned char start_cylinder;
+	unsigned char partition_type;
+	unsigned char end_head;
+	unsigned char end_sector;
+	unsigned char end_cylinder;
+	unsigned int  start_sectors;
+	unsigned int  sectors_per_partition;
+} __packed;
+
+struct mspro_specfile {
+	char           name[8];
+	char           ext[3];
+	unsigned char  attr;
+	unsigned char  reserved[10];
+	unsigned short time;
+	unsigned short date;
+	unsigned short cluster;
+	unsigned int   size;
+} __packed;
+
+struct mspro_devinfo {
+	__be16 cylinders;
+	__be16 heads;
+	__be16 bytes_per_track;
+	__be16 bytes_per_sector;
+	__be16 sectors_per_track;
+	unsigned char  reserved[6];
+} __packed;
+
+
+
+struct mspro_block_data {
+	struct memstick_dev              *card;
+	unsigned int                     usage_count;
+	unsigned int                     caps;
+	struct gendisk                   *disk;
+	struct request_queue             *queue;
+	struct request                   *block_req;
+	spinlock_t                       q_lock;
+	struct scatterlist               req_sg[MSPRO_BLOCK_MAX_SEGS];
+
+	unsigned char                    read_only:1;
+	unsigned char                    eject:1;
+	unsigned char                    active:1;
+
+	/* Media info */
+	struct attribute_group           attr_group;
+	unsigned short                   page_size;
+	unsigned short                   cylinders;
+	unsigned short                   heads;
+	unsigned short                   sectors_per_track;
+
+	/* Handlers state */
+	unsigned char                    system;
+	struct mspro_cmdex_argument      arg;
+
+	struct scatterlist               *current_sg;
+	unsigned int                     current_sg_offset;
+	unsigned int	                 data_transferred;
+	unsigned char                    data_dir:1;
+	unsigned int                     target_interface;
+	bool                             io_error;
+};
+
+static void mspro_block_complete_req(struct memstick_dev *card, int error);
+static int mspro_block_switch_interface(struct memstick_dev *card);
+static int mspro_block_issue_req(struct memstick_dev *card);
+
+#define __dbg(card, level, format, ...) \
+	do { \
+		if (debug >= level) \
+			printk(KERN_DEBUG \
+				"%s: " format "\n", dev_name(&card->dev) \
+					 , ## __VA_ARGS__); \
+		else \
+			dev_dbg(&card->dev, format, ## __VA_ARGS__); \
+	} while (0)
+
+#define dbg(card, format, ...)		__dbg(card, 1, format, ## __VA_ARGS__)
+#define dbg_v(card, format, ...)	__dbg(card, 2, format, ## __VA_ARGS__)
-- 
1.7.1

