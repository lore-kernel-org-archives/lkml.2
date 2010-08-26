Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0HZSuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:21 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:35376 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0HZSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:50:17 -0400
Subject: [PATCH 11/13] cciss: factor out cciss_passthru
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:25 -0500
Message-ID: <20100826185625.9067.18256.stgit@beardog.cce.hp.com>
In-Reply-To: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
References: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |  212 +++++++++++++++++++++++--------------------------
 1 files changed, 101 insertions(+), 111 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 3f24450..5a84080 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1400,6 +1400,106 @@ static int cciss_getluninfo(ctlr_info_t *h,
 	return 0;
 }
 
+static int cciss_passthru(ctlr_info_t *h, void __user *argp)
+{
+	IOCTL_Command_struct iocommand;
+	CommandList_struct *c;
+	char *buff = NULL;
+	u64bit temp64;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	if (!argp)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	if (copy_from_user
+	    (&iocommand, argp, sizeof(IOCTL_Command_struct)))
+		return -EFAULT;
+	if ((iocommand.buf_size < 1) &&
+	    (iocommand.Request.Type.Direction != XFER_NONE)) {
+		return -EINVAL;
+	}
+	if (iocommand.buf_size > 0) {
+		buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
+		if (buff == NULL)
+			return -EFAULT;
+	}
+	if (iocommand.Request.Type.Direction == XFER_WRITE) {
+		/* Copy the data into the buffer we created */
+		if (copy_from_user(buff, iocommand.buf, iocommand.buf_size)) {
+			kfree(buff);
+			return -EFAULT;
+		}
+	} else {
+		memset(buff, 0, iocommand.buf_size);
+	}
+	c = cmd_special_alloc(h);
+	if (!c) {
+		kfree(buff);
+		return -ENOMEM;
+	}
+	/* Fill in the command type */
+	c->cmd_type = CMD_IOCTL_PEND;
+	/* Fill in Command Header */
+	c->Header.ReplyQueue = 0;   /* unused in simple mode */
+	if (iocommand.buf_size > 0) { /* buffer to fill */
+		c->Header.SGList = 1;
+		c->Header.SGTotal = 1;
+	} else { /* no buffers to fill */
+		c->Header.SGList = 0;
+		c->Header.SGTotal = 0;
+	}
+	c->Header.LUN = iocommand.LUN_info;
+	/* use the kernel address the cmd block for tag */
+	c->Header.Tag.lower = c->busaddr;
+
+	/* Fill in Request block */
+	c->Request = iocommand.Request;
+
+	/* Fill in the scatter gather information */
+	if (iocommand.buf_size > 0) {
+		temp64.val = pci_map_single(h->pdev, buff,
+			iocommand.buf_size, PCI_DMA_BIDIRECTIONAL);
+		c->SG[0].Addr.lower = temp64.val32.lower;
+		c->SG[0].Addr.upper = temp64.val32.upper;
+		c->SG[0].Len = iocommand.buf_size;
+		c->SG[0].Ext = 0;  /* we are not chaining */
+	}
+	c->waiting = &wait;
+
+	enqueue_cmd_and_start_io(h, c);
+	wait_for_completion(&wait);
+
+	/* unlock the buffers from DMA */
+	temp64.val32.lower = c->SG[0].Addr.lower;
+	temp64.val32.upper = c->SG[0].Addr.upper;
+	pci_unmap_single(h->pdev, (dma_addr_t) temp64.val, iocommand.buf_size,
+			 PCI_DMA_BIDIRECTIONAL);
+	check_ioctl_unit_attention(h, c);
+
+	/* Copy the error information out */
+	iocommand.error_info = *(c->err_info);
+	if (copy_to_user(argp, &iocommand, sizeof(IOCTL_Command_struct))) {
+		kfree(buff);
+		cmd_special_free(h, c);
+		return -EFAULT;
+	}
+
+	if (iocommand.Request.Type.Direction == XFER_READ) {
+		/* Copy the data out of the buffer we created */
+		if (copy_to_user(iocommand.buf, buff, iocommand.buf_size)) {
+			kfree(buff);
+			cmd_special_free(h, c);
+			return -EFAULT;
+		}
+	}
+	kfree(buff);
+	cmd_special_free(h, c);
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
@@ -1435,117 +1535,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETLUNINFO:
 		return cciss_getluninfo(h, disk, argp);
 	case CCISS_PASSTHRU:
-		{
-			IOCTL_Command_struct iocommand;
-			CommandList_struct *c;
-			char *buff = NULL;
-			u64bit temp64;
-			DECLARE_COMPLETION_ONSTACK(wait);
-
-			if (!arg)
-				return -EINVAL;
-
-			if (!capable(CAP_SYS_RAWIO))
-				return -EPERM;
-
-			if (copy_from_user
-			    (&iocommand, argp, sizeof(IOCTL_Command_struct)))
-				return -EFAULT;
-			if ((iocommand.buf_size < 1) &&
-			    (iocommand.Request.Type.Direction != XFER_NONE)) {
-				return -EINVAL;
-			}
-#if 0				/* 'buf_size' member is 16-bits, and always smaller than kmalloc limit */
-			/* Check kmalloc limits */
-			if (iocommand.buf_size > 128000)
-				return -EINVAL;
-#endif
-			if (iocommand.buf_size > 0) {
-				buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
-				if (buff == NULL)
-					return -EFAULT;
-			}
-			if (iocommand.Request.Type.Direction == XFER_WRITE) {
-				/* Copy the data into the buffer we created */
-				if (copy_from_user
-				    (buff, iocommand.buf, iocommand.buf_size)) {
-					kfree(buff);
-					return -EFAULT;
-				}
-			} else {
-				memset(buff, 0, iocommand.buf_size);
-			}
-			c = cmd_special_alloc(h);
-			if (!c) {
-				kfree(buff);
-				return -ENOMEM;
-			}
-			/* Fill in the command type */
-			c->cmd_type = CMD_IOCTL_PEND;
-			/* Fill in Command Header */
-			c->Header.ReplyQueue = 0;   /* unused in simple mode */
-			if (iocommand.buf_size > 0) /* buffer to fill */
-			{
-				c->Header.SGList = 1;
-				c->Header.SGTotal = 1;
-			} else /* no buffers to fill */
-			{
-				c->Header.SGList = 0;
-				c->Header.SGTotal = 0;
-			}
-			c->Header.LUN = iocommand.LUN_info;
-			/* use the kernel address the cmd block for tag */
-			c->Header.Tag.lower = c->busaddr;
-
-			/* Fill in Request block */
-			c->Request = iocommand.Request;
-
-			/* Fill in the scatter gather information */
-			if (iocommand.buf_size > 0) {
-				temp64.val = pci_map_single(h->pdev, buff,
-					iocommand.buf_size,
-					PCI_DMA_BIDIRECTIONAL);
-				c->SG[0].Addr.lower = temp64.val32.lower;
-				c->SG[0].Addr.upper = temp64.val32.upper;
-				c->SG[0].Len = iocommand.buf_size;
-				c->SG[0].Ext = 0;  /* we are not chaining */
-			}
-			c->waiting = &wait;
-
-			enqueue_cmd_and_start_io(h, c);
-			wait_for_completion(&wait);
-
-			/* unlock the buffers from DMA */
-			temp64.val32.lower = c->SG[0].Addr.lower;
-			temp64.val32.upper = c->SG[0].Addr.upper;
-			pci_unmap_single(h->pdev, (dma_addr_t) temp64.val,
-					 iocommand.buf_size,
-					 PCI_DMA_BIDIRECTIONAL);
-
-			check_ioctl_unit_attention(h, c);
-
-			/* Copy the error information out */
-			iocommand.error_info = *(c->err_info);
-			if (copy_to_user
-			    (argp, &iocommand, sizeof(IOCTL_Command_struct))) {
-				kfree(buff);
-				cmd_special_free(h, c);
-				return -EFAULT;
-			}
-
-			if (iocommand.Request.Type.Direction == XFER_READ) {
-				/* Copy the data out of the buffer we created */
-				if (copy_to_user
-				    (iocommand.buf, buff, iocommand.buf_size)) {
-					kfree(buff);
-					cmd_special_free(h, c);
-					return -EFAULT;
-				}
-			}
-			kfree(buff);
-			cmd_special_free(h, c);
-			return 0;
-		}
+		return cciss_passthru(h, argp);
 	case CCISS_BIG_PASSTHRU:{
 			BIG_IOCTL_Command_struct *ioc;
 			CommandList_struct *c;

