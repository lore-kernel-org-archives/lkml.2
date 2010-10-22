Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab0JVXy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0JVXyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WLH+cZpQHX57SpKr5A1Gw1Q0Oz8hMlwb+2KYB1aZV7EetLpGXd6Oul7ZegcF+gNJF7
         LfltohXqZ8UbDUE72e4fdM/wxDlvvE2GsfGGcKk0fJJXz+zy7d4JbsEPTXypjusS7baH
         Cvmygx8SRkzlPUtnSGxBbo/Hyk9tQl8G7ZlmQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 23/29] memstick: jmb38x_ms: use DMA for all TPCs with len greater that 8 by default
Date: Sat, 23 Oct 2010 01:53:51 +0200
Message-Id: <1287791637-10329-24-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to workaround a wierd hardware bug:

If PIO write is used, and then after it DMA write is used, DMA
engine stops doing writes.
That condition even persists after device reset.

To be maxumum safe, we do dma to a scratch page
and memcpy from/to it.

Besides this change should just improve performance.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |   65 ++++++++++++++++++++++++++----------
 drivers/memstick/host/jmb38x_ms.h |    5 +++
 2 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 6b87e23..77e4971 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -261,6 +261,7 @@ static int j38ms_execute_tpc(struct j38ms_host *host)
 	unsigned int data_len = host->req->long_data ?
 		host->req->sg.length : host->req->data_len;
 	bool is_read = host->req->data_dir == READ;
+	dma_addr_t dma_address;
 
 	if (!(j38ms_read_reg(host, STATUS) & STATUS_HAS_MEDIA)) {
 		dbg(host, "IO: card removed, refusing to send TPC");
@@ -316,30 +317,40 @@ static int j38ms_execute_tpc(struct j38ms_host *host)
 	}
 
 	/* DMA */
-	if (!no_dma && host->req->long_data) {
+	if (!no_dma) {
 
 		dbg(host, "IO: Using DMA");
 		host->cmd_flags |= DMA_DATA;
 
-		if (pci_map_sg(host->chip->pdev,
-			&host->req->sg, 1, is_read
-			? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE) != 1) {
+		if (host->req->long_data) {
 
-			dbg(host, "IO: DMA map failed");
-			host->req->error = -ENOMEM;
-			return host->req->error;
-		}
+			if (pci_map_sg(host->chip->pdev,
+				&host->req->sg, 1, is_read
+				? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE) != 1) {
+
+				dbg(host, "IO: DMA map failed");
+				host->req->error = -ENOMEM;
+				return host->req->error;
+			}
+
+			/* We really shouldn't pretend we support that case */
+			if (sg_dma_len(&host->req->sg) != data_len) {
+				dbg(host, "IO: DMA len mismatch");
+				host->req->error = -EFAULT;
+				return host->req->error;
+			}
 
-		/* We really shouldn't pretend we support that case */
-		if (sg_dma_len(&host->req->sg) != data_len) {
-			dbg(host, "IO: DMA len mismatch");
-			host->req->error = -EFAULT;
-			return host->req->error;
+			dma_address = sg_dma_address(&host->req->sg);
+
+		} else {
+			if (!is_read)
+				memcpy(host->dma_bounce_page,
+					host->req->data, data_len);
+			dma_address = host->dma_bus_address;
 		}
 
 		j38ms_write_reg(host, BLOCK, data_len | BLOCK_COUNT_1BLOCK);
-		j38ms_write_reg(host, DMA_ADDRESS,
-					sg_dma_address(&host->req->sg));
+		j38ms_write_reg(host, DMA_ADDRESS, dma_address);
 		j38ms_write_reg(host, DMA_CONTROL, DMA_CONTROL_ENABLE);
 	/* PIO */
 	} else {
@@ -392,9 +403,13 @@ static void j38ms_complete_tpc(struct memstick_host *msh, int last)
 		host->req->int_reg = j38ms_read_reg(host, STATUS) & 0xFF;
 
 	if (host->cmd_flags & DMA_DATA) {
-		pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
-			host->req->data_dir == READ
-			? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
+		if (host->req->long_data)
+			pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
+				host->req->data_dir == READ
+				? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
+		else if (host->req->data_dir == READ)
+			memcpy(host->req->data,
+				host->dma_bounce_page, host->req->data_len);
 
 	} else if (host->cmd_flags & PIO_DATA) {
 		u32 t_val = INT_STATUS_FIFO_RRDY | INT_STATUS_FIFO_WRDY;
@@ -771,12 +786,23 @@ static struct memstick_host *j38ms_alloc_host(struct j38ms *jm, int cnt)
 
 	setup_timer(&host->timer, j38ms_irq_timeout, (unsigned long)msh);
 
+	host->dma_bounce_page = pci_alloc_consistent(
+				jm->pdev, PAGE_SIZE, &host->dma_bus_address);
+
+	if (!host->dma_bounce_page)
+		goto err_out_free;
+
 	if (!request_irq(host->irq, j38ms_isr, IRQF_SHARED, host->host_id,
 			 msh))
 		return msh;
 
 	iounmap(host->addr);
 err_out_free:
+
+	if (host->dma_bounce_page)
+		pci_free_consistent(jm->pdev, PAGE_SIZE,
+			host->dma_bounce_page, host->dma_bus_address);
+
 	kfree(msh);
 	return NULL;
 }
@@ -787,6 +813,9 @@ static void j38ms_free_host(struct memstick_host *msh)
 
 	free_irq(host->irq, msh);
 	iounmap(host->addr);
+
+	pci_free_consistent(host->chip->pdev, PAGE_SIZE,
+		host->dma_bounce_page, host->dma_bus_address);
 	memstick_free_host(msh);
 }
 
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index 429ed49..5599803 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -161,6 +161,11 @@ struct j38ms_host {
 	unsigned char		pio_offset;
 	unsigned char           pio_tmp_buf[4];
 	unsigned int            pio_tmp_buf_len;
+
+	/* DMA bounce buffer */
+	void			*dma_bounce_page;
+	dma_addr_t		dma_bus_address;
+
 };
 
 struct j38ms {
-- 
1.7.1

