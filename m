Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0FHPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0FHPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:25:38 -0400
Date: Tue, 8 Jun 2010 11:25:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org, tony.camuso@hp.com,
       david.altobelli@hp.com, dzickus@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100608151923.10554.57721.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup [v2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix i386 PAE compile warning:

drivers/misc/hpilo.c: In function ‘ilo_ccb_setup’:
drivers/misc/hpilo.c:274: warning: cast to pointer from integer of different size

dma_addr_t is 64 on i386 PAE which causes a size mismatch.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 98ad012..557a8c2 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -256,7 +256,8 @@ static void ilo_ccb_close(struct pci_dev *pdev, struct ccb_data *data)
 
 static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 {
-	char *dma_va, *dma_pa;
+	char *dma_va;
+	dma_addr_t dma_pa;
 	struct ccb *driver_ccb, *ilo_ccb;
 
 	driver_ccb = &data->driver_ccb;
@@ -272,12 +273,12 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 		return -ENOMEM;
 
 	dma_va = (char *)data->dma_va;
-	dma_pa = (char *)data->dma_pa;
+	dma_pa = data->dma_pa;
 
 	memset(dma_va, 0, data->dma_size);
 
 	dma_va = (char *)roundup((unsigned long)dma_va, ILO_START_ALIGN);
-	dma_pa = (char *)roundup((unsigned long)dma_pa, ILO_START_ALIGN);
+	dma_pa = roundup(dma_pa, ILO_START_ALIGN);
 
 	/*
 	 * Create two ccb's, one with virt addrs, one with phys addrs.
@@ -288,26 +289,26 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 
 	fifo_setup(dma_va, NR_QENTRY);
 	driver_ccb->ccb_u1.send_fifobar = dma_va + FIFOHANDLESIZE;
-	ilo_ccb->ccb_u1.send_fifobar = dma_pa + FIFOHANDLESIZE;
+	ilo_ccb->ccb_u1.send_fifobar_pa = dma_pa + FIFOHANDLESIZE;
 	dma_va += fifo_sz(NR_QENTRY);
 	dma_pa += fifo_sz(NR_QENTRY);
 
 	dma_va = (char *)roundup((unsigned long)dma_va, ILO_CACHE_SZ);
-	dma_pa = (char *)roundup((unsigned long)dma_pa, ILO_CACHE_SZ);
+	dma_pa = roundup(dma_pa, ILO_CACHE_SZ);
 
 	fifo_setup(dma_va, NR_QENTRY);
 	driver_ccb->ccb_u3.recv_fifobar = dma_va + FIFOHANDLESIZE;
-	ilo_ccb->ccb_u3.recv_fifobar = dma_pa + FIFOHANDLESIZE;
+	ilo_ccb->ccb_u3.recv_fifobar_pa = dma_pa + FIFOHANDLESIZE;
 	dma_va += fifo_sz(NR_QENTRY);
 	dma_pa += fifo_sz(NR_QENTRY);
 
 	driver_ccb->ccb_u2.send_desc = dma_va;
-	ilo_ccb->ccb_u2.send_desc = dma_pa;
+	ilo_ccb->ccb_u2.send_desc_pa = dma_pa;
 	dma_pa += desc_mem_sz(NR_QENTRY);
 	dma_va += desc_mem_sz(NR_QENTRY);
 
 	driver_ccb->ccb_u4.recv_desc = dma_va;
-	ilo_ccb->ccb_u4.recv_desc = dma_pa;
+	ilo_ccb->ccb_u4.recv_desc_pa = dma_pa;
 
 	driver_ccb->channel = slot;
 	ilo_ccb->channel = slot;
diff --git a/drivers/misc/hpilo.h b/drivers/misc/hpilo.h
index 247eb38..54e43ad 100644
--- a/drivers/misc/hpilo.h
+++ b/drivers/misc/hpilo.h
@@ -79,21 +79,21 @@ struct ilo_hwinfo {
 struct ccb {
 	union {
 		char *send_fifobar;
-		u64 padding1;
+		u64 send_fifobar_pa;
 	} ccb_u1;
 	union {
 		char *send_desc;
-		u64 padding2;
+		u64 send_desc_pa;
 	} ccb_u2;
 	u64 send_ctrl;
 
 	union {
 		char *recv_fifobar;
-		u64 padding3;
+		u64 recv_fifobar_pa;
 	} ccb_u3;
 	union {
 		char *recv_desc;
-		u64 padding4;
+		u64 recv_desc_pa;
 	} ccb_u4;
 	u64 recv_ctrl;
 
