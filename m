Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0HZSu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:27 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:37374 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0HZSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:50:22 -0400
Subject: [PATCH 12/13] cciss: factor out cciss_big_passthru
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:30 -0500
Message-ID: <20100826185630.9067.22734.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |  307 ++++++++++++++++++++++++-------------------------
 1 files changed, 151 insertions(+), 156 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5a84080..a7ec339 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1500,6 +1500,155 @@ static int cciss_passthru(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
+{
+	BIG_IOCTL_Command_struct *ioc;
+	CommandList_struct *c;
+	unsigned char **buff = NULL;
+	int *buff_size = NULL;
+	u64bit temp64;
+	BYTE sg_used = 0;
+	int status = 0;
+	int i;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	__u32 left;
+	__u32 sz;
+	BYTE __user *data_ptr;
+
+	if (!argp)
+		return -EINVAL;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	ioc = (BIG_IOCTL_Command_struct *)
+	    kmalloc(sizeof(*ioc), GFP_KERNEL);
+	if (!ioc) {
+		status = -ENOMEM;
+		goto cleanup1;
+	}
+	if (copy_from_user(ioc, argp, sizeof(*ioc))) {
+		status = -EFAULT;
+		goto cleanup1;
+	}
+	if ((ioc->buf_size < 1) &&
+	    (ioc->Request.Type.Direction != XFER_NONE)) {
+		status = -EINVAL;
+		goto cleanup1;
+	}
+	/* Check kmalloc limits  using all SGs */
+	if (ioc->malloc_size > MAX_KMALLOC_SIZE) {
+		status = -EINVAL;
+		goto cleanup1;
+	}
+	if (ioc->buf_size > ioc->malloc_size * MAXSGENTRIES) {
+		status = -EINVAL;
+		goto cleanup1;
+	}
+	buff = kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
+	if (!buff) {
+		status = -ENOMEM;
+		goto cleanup1;
+	}
+	buff_size = kmalloc(MAXSGENTRIES * sizeof(int), GFP_KERNEL);
+	if (!buff_size) {
+		status = -ENOMEM;
+		goto cleanup1;
+	}
+	left = ioc->buf_size;
+	data_ptr = ioc->buf;
+	while (left) {
+		sz = (left > ioc->malloc_size) ? ioc->malloc_size : left;
+		buff_size[sg_used] = sz;
+		buff[sg_used] = kmalloc(sz, GFP_KERNEL);
+		if (buff[sg_used] == NULL) {
+			status = -ENOMEM;
+			goto cleanup1;
+		}
+		if (ioc->Request.Type.Direction == XFER_WRITE) {
+			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
+				status = -EFAULT;
+				goto cleanup1;
+			}
+		} else {
+			memset(buff[sg_used], 0, sz);
+		}
+		left -= sz;
+		data_ptr += sz;
+		sg_used++;
+	}
+	c = cmd_special_alloc(h);
+	if (!c) {
+		status = -ENOMEM;
+		goto cleanup1;
+	}
+	c->cmd_type = CMD_IOCTL_PEND;
+	c->Header.ReplyQueue = 0;
+
+	if (ioc->buf_size > 0) {
+		c->Header.SGList = sg_used;
+		c->Header.SGTotal = sg_used;
+	} else {
+		c->Header.SGList = 0;
+		c->Header.SGTotal = 0;
+	}
+	c->Header.LUN = ioc->LUN_info;
+	c->Header.Tag.lower = c->busaddr;
+
+	c->Request = ioc->Request;
+	if (ioc->buf_size > 0) {
+		for (i = 0; i < sg_used; i++) {
+			temp64.val =
+			    pci_map_single(h->pdev, buff[i], buff_size[i],
+				    PCI_DMA_BIDIRECTIONAL);
+			c->SG[i].Addr.lower = temp64.val32.lower;
+			c->SG[i].Addr.upper = temp64.val32.upper;
+			c->SG[i].Len = buff_size[i];
+			c->SG[i].Ext = 0;	/* we are not chaining */
+		}
+	}
+	c->waiting = &wait;
+	enqueue_cmd_and_start_io(h, c);
+	wait_for_completion(&wait);
+	/* unlock the buffers from DMA */
+	for (i = 0; i < sg_used; i++) {
+		temp64.val32.lower = c->SG[i].Addr.lower;
+		temp64.val32.upper = c->SG[i].Addr.upper;
+		pci_unmap_single(h->pdev,
+			(dma_addr_t) temp64.val, buff_size[i],
+			PCI_DMA_BIDIRECTIONAL);
+	}
+	check_ioctl_unit_attention(h, c);
+	/* Copy the error information out */
+	ioc->error_info = *(c->err_info);
+	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
+		cmd_special_free(h, c);
+		status = -EFAULT;
+		goto cleanup1;
+	}
+	if (ioc->Request.Type.Direction == XFER_READ) {
+		/* Copy the data out of the buffer we created */
+		BYTE __user *ptr = ioc->buf;
+		for (i = 0; i < sg_used; i++) {
+			if (copy_to_user(ptr, buff[i], buff_size[i])) {
+				cmd_special_free(h, c);
+				status = -EFAULT;
+				goto cleanup1;
+			}
+			ptr += buff_size[i];
+		}
+	}
+	cmd_special_free(h, c);
+	status = 0;
+cleanup1:
+	if (buff) {
+		for (i = 0; i < sg_used; i++)
+			kfree(buff[i]);
+		kfree(buff);
+	}
+	kfree(buff_size);
+	kfree(ioc);
+	return status;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
@@ -1536,162 +1685,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		return cciss_getluninfo(h, disk, argp);
 	case CCISS_PASSTHRU:
 		return cciss_passthru(h, argp);
-	case CCISS_BIG_PASSTHRU:{
-			BIG_IOCTL_Command_struct *ioc;
-			CommandList_struct *c;
-			unsigned char **buff = NULL;
-			int *buff_size = NULL;
-			u64bit temp64;
-			BYTE sg_used = 0;
-			int status = 0;
-			int i;
-			DECLARE_COMPLETION_ONSTACK(wait);
-			__u32 left;
-			__u32 sz;
-			BYTE __user *data_ptr;
-
-			if (!arg)
-				return -EINVAL;
-			if (!capable(CAP_SYS_RAWIO))
-				return -EPERM;
-			ioc = (BIG_IOCTL_Command_struct *)
-			    kmalloc(sizeof(*ioc), GFP_KERNEL);
-			if (!ioc) {
-				status = -ENOMEM;
-				goto cleanup1;
-			}
-			if (copy_from_user(ioc, argp, sizeof(*ioc))) {
-				status = -EFAULT;
-				goto cleanup1;
-			}
-			if ((ioc->buf_size < 1) &&
-			    (ioc->Request.Type.Direction != XFER_NONE)) {
-				status = -EINVAL;
-				goto cleanup1;
-			}
-			/* Check kmalloc limits  using all SGs */
-			if (ioc->malloc_size > MAX_KMALLOC_SIZE) {
-				status = -EINVAL;
-				goto cleanup1;
-			}
-			if (ioc->buf_size > ioc->malloc_size * MAXSGENTRIES) {
-				status = -EINVAL;
-				goto cleanup1;
-			}
-			buff =
-			    kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
-			if (!buff) {
-				status = -ENOMEM;
-				goto cleanup1;
-			}
-			buff_size = kmalloc(MAXSGENTRIES * sizeof(int),
-						   GFP_KERNEL);
-			if (!buff_size) {
-				status = -ENOMEM;
-				goto cleanup1;
-			}
-			left = ioc->buf_size;
-			data_ptr = ioc->buf;
-			while (left) {
-				sz = (left >
-				      ioc->malloc_size) ? ioc->
-				    malloc_size : left;
-				buff_size[sg_used] = sz;
-				buff[sg_used] = kmalloc(sz, GFP_KERNEL);
-				if (buff[sg_used] == NULL) {
-					status = -ENOMEM;
-					goto cleanup1;
-				}
-				if (ioc->Request.Type.Direction == XFER_WRITE) {
-					if (copy_from_user
-					    (buff[sg_used], data_ptr, sz)) {
-						status = -EFAULT;
-						goto cleanup1;
-					}
-				} else {
-					memset(buff[sg_used], 0, sz);
-				}
-				left -= sz;
-				data_ptr += sz;
-				sg_used++;
-			}
-			c = cmd_special_alloc(h);
-			if (!c) {
-				status = -ENOMEM;
-				goto cleanup1;
-			}
-			c->cmd_type = CMD_IOCTL_PEND;
-			c->Header.ReplyQueue = 0;
-
-			if (ioc->buf_size > 0) {
-				c->Header.SGList = sg_used;
-				c->Header.SGTotal = sg_used;
-			} else {
-				c->Header.SGList = 0;
-				c->Header.SGTotal = 0;
-			}
-			c->Header.LUN = ioc->LUN_info;
-			c->Header.Tag.lower = c->busaddr;
-
-			c->Request = ioc->Request;
-			if (ioc->buf_size > 0) {
-				for (i = 0; i < sg_used; i++) {
-					temp64.val =
-					    pci_map_single(h->pdev, buff[i],
-						    buff_size[i],
-						    PCI_DMA_BIDIRECTIONAL);
-					c->SG[i].Addr.lower =
-					    temp64.val32.lower;
-					c->SG[i].Addr.upper =
-					    temp64.val32.upper;
-					c->SG[i].Len = buff_size[i];
-					c->SG[i].Ext = 0;	/* we are not chaining */
-				}
-			}
-			c->waiting = &wait;
-			enqueue_cmd_and_start_io(h, c);
-			wait_for_completion(&wait);
-			/* unlock the buffers from DMA */
-			for (i = 0; i < sg_used; i++) {
-				temp64.val32.lower = c->SG[i].Addr.lower;
-				temp64.val32.upper = c->SG[i].Addr.upper;
-				pci_unmap_single(h->pdev,
-					(dma_addr_t) temp64.val, buff_size[i],
-					PCI_DMA_BIDIRECTIONAL);
-			}
-			check_ioctl_unit_attention(h, c);
-			/* Copy the error information out */
-			ioc->error_info = *(c->err_info);
-			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
-				cmd_special_free(h, c);
-				status = -EFAULT;
-				goto cleanup1;
-			}
-			if (ioc->Request.Type.Direction == XFER_READ) {
-				/* Copy the data out of the buffer we created */
-				BYTE __user *ptr = ioc->buf;
-				for (i = 0; i < sg_used; i++) {
-					if (copy_to_user
-					    (ptr, buff[i], buff_size[i])) {
-						cmd_special_free(h, c);
-						status = -EFAULT;
-						goto cleanup1;
-					}
-					ptr += buff_size[i];
-				}
-			}
-			cmd_special_free(h, c);
-			status = 0;
-		      cleanup1:
-			if (buff) {
-				for (i = 0; i < sg_used; i++)
-					kfree(buff[i]);
-				kfree(buff);
-			}
-			kfree(buff_size);
-			kfree(ioc);
-			return status;
-		}
+	case CCISS_BIG_PASSTHRU:
+		return cciss_bigpassthru(h, argp);
 
 	/* scsi_cmd_ioctl handles these, below, though some are not */
 	/* very meaningful for cciss.  SG_IO is the main one people want. */

