Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab0JHUAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:00:38 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:10865 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab0JHUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:00:18 -0400
Subject: [PATCH 13/13] hpsa: defend against zero sized buffers in passthru
	ioctls
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Oct 2010 15:07:08 -0500
Message-ID: <20101008200708.24279.8723.stgit@beardog.cce.hp.com>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c36427d..cba5bf4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2458,15 +2458,17 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
 		if (buff == NULL)
 			return -EFAULT;
-	}
-	if (iocommand.Request.Type.Direction == XFER_WRITE) {
-		/* Copy the data into the buffer we created */
-		if (copy_from_user(buff, iocommand.buf, iocommand.buf_size)) {
-			kfree(buff);
-			return -EFAULT;
+		if (iocommand.Request.Type.Direction == XFER_WRITE) {
+			/* Copy the data into the buffer we created */
+			if (copy_from_user(buff, iocommand.buf,
+				iocommand.buf_size)) {
+				kfree(buff);
+				return -EFAULT;
+			}
+		} else {
+			memset(buff, 0, iocommand.buf_size);
 		}
-	} else
-		memset(buff, 0, iocommand.buf_size);
+	}
 	c = cmd_special_alloc(h);
 	if (c == NULL) {
 		kfree(buff);
@@ -2512,8 +2514,8 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		cmd_special_free(h, c);
 		return -EFAULT;
 	}
-
-	if (iocommand.Request.Type.Direction == XFER_READ) {
+	if (iocommand.Request.Type.Direction == XFER_READ &&
+		iocommand.buf_size > 0) {
 		/* Copy the data out of the buffer we created */
 		if (copy_to_user(iocommand.buf, buff, iocommand.buf_size)) {
 			kfree(buff);
@@ -2606,14 +2608,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	}
 	c->cmd_type = CMD_IOCTL_PEND;
 	c->Header.ReplyQueue = 0;
-
-	if (ioc->buf_size > 0) {
-		c->Header.SGList = sg_used;
-		c->Header.SGTotal = sg_used;
-	} else {
-		c->Header.SGList = 0;
-		c->Header.SGTotal = 0;
-	}
+	c->Header.SGList = c->Header.SGTotal = sg_used;
 	memcpy(&c->Header.LUN, &ioc->LUN_info, sizeof(c->Header.LUN));
 	c->Header.Tag.lower = c->busaddr;
 	memcpy(&c->Request, &ioc->Request, sizeof(c->Request));
@@ -2630,7 +2625,8 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
-	hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
+	if (sg_used)
+		hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);
 	/* Copy the error information out */
 	memcpy(&ioc->error_info, c->err_info, sizeof(ioc->error_info));
@@ -2639,7 +2635,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		status = -EFAULT;
 		goto cleanup1;
 	}
-	if (ioc->Request.Type.Direction == XFER_READ) {
+	if (ioc->Request.Type.Direction == XFER_READ && ioc->buf_size > 0) {
 		/* Copy the data out of the buffer we created */
 		BYTE __user *ptr = ioc->buf;
 		for (i = 0; i < sg_used; i++) {

