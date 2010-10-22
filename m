Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0JVXyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0JVXyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NEpEz5MgSzIX0Q6poYAlPHvmXF7DdJ/c7X7+0fnkM5yzP7vbjhnV8pPbyJimF+RpTz
         t4IEmPU9Fbms4tE4OdlecfYLp15Z6D4LsEMYhs3LoXE2TFpqi1vxLKH2pB56lm3m8aCC
         1qvNDktA7Jnbsm+gmiH6095rPklBeuePdlAso=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 21/29] memstick: jmb38x_ms: rework TPC execution
Date: Sat, 23 Oct 2010 01:53:49 +0200
Message-Id: <1287791637-10329-22-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code rewritten to make it simplier.
A lot of debug output is added to help
diagnose bugs.

No major functional changes

Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  199 +++++++++++++++++++++----------------
 drivers/memstick/host/jmb38x_ms.h |    3 +-
 2 files changed, 114 insertions(+), 88 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 5af0a52..d15118a 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -254,94 +254,121 @@ static void j38ms_write_tpc_inline(struct j38ms_host *host)
  *	PIO _reads_ must be aligned. Writes can be not aligned
  *
  */
-static int j38ms_execute_tpc(struct memstick_host *msh)
+
+static int j38ms_execute_tpc(struct j38ms_host *host)
 {
-	struct j38ms_host *host = memstick_priv(msh);
-	unsigned char *data;
-	unsigned int data_len, cmd, t_val;
+	u32 cmd = 0, t_val;
+	unsigned int data_len = host->req->long_data ?
+		host->req->sg.length : host->req->data_len;
+	bool is_read = host->req->data_dir == READ;
+
+	if (!(j38ms_read_reg(host, STATUS) & STATUS_HAS_MEDIA)) {
+		dbg(host, "IO: card removed, refusing to send TPC");
+		host->req->error = -ENODEV;
+		return host->req->error;
+	}
 
-	if (!(STATUS_HAS_MEDIA & readl(host->addr + STATUS))) {
-		dev_dbg(&msh->dev, "no media status\n");
-		host->req->error = -ETIME;
+	if (data_len > BLOCK_SIZE_MASK) {
+		dbg(host, "IO: too long TPC (len: %d)", data_len);
+		host->req->error = -ENOSYS;
 		return host->req->error;
 	}
 
-	dev_dbg(&msh->dev, "control %08x\n", readl(host->addr + HOST_CONTROL));
-	dev_dbg(&msh->dev, "status %08x\n", readl(host->addr + INT_STATUS));
-	dev_dbg(&msh->dev, "hstatus %08x\n", readl(host->addr + STATUS));
+	dbg(host, "IO: Start execution of %s",
+		memstick_debug_get_tpc_name(host->req->tpc));
+
+
+	dbg_v(host, "host control: %08x", j38ms_read_reg(host, HOST_CONTROL));
+	dbg_v(host, "int status: %08x", j38ms_read_reg(host, INT_STATUS));
+	dbg_v(host, "card status: %08x", j38ms_read_reg(host, STATUS));
 
+	host->req->error = 0;
 	host->cmd_flags = 0;
 
 	cmd = host->req->tpc << 16;
-	cmd |= TPC_DATA_SEL;
-
-	if (host->req->data_dir == READ)
+	if (is_read)
 		cmd |= TPC_DIR;
-	if (host->req->need_card_int)
-		cmd |= TPC_WAIT_INT;
-
-	data = host->req->data;
-
-	if (!no_dma)
-		host->cmd_flags |= DMA_DATA;
 
-	if (host->req->long_data) {
-		data_len = host->req->sg.length;
-	} else {
-		data_len = host->req->data_len;
-		host->cmd_flags &= ~DMA_DATA;
+	if (host->req->need_card_int) {
+		dbg_v(host, "IO: Will wait for card interrupt");
+		cmd |= TPC_WAIT_INT;
+		/* No, the TPC_GET_INT doesn't work.... */
 	}
 
-	if (data_len <= 8) {
-		cmd &= ~(TPC_DATA_SEL | 0xf);
+	/* Special case for short TPCs */
+	if (!host->req->long_data && data_len <= 8) {
+		dbg(host, "IO: Using 8 byte register window");
 		host->cmd_flags |= REG_DATA;
 		cmd |= data_len & 0xf;
-		host->cmd_flags &= ~DMA_DATA;
+
+		if (!is_read)
+			j38ms_write_tpc_inline(host);
+		goto exec;
 	}
 
-	if (host->cmd_flags & DMA_DATA) {
-		if (1 != pci_map_sg(host->chip->pdev, &host->req->sg, 1,
-				    host->req->data_dir == READ
-				    ? PCI_DMA_FROMDEVICE
-				    : PCI_DMA_TODEVICE)) {
+	/* Otherwise use internal fifo*/
+	cmd |= TPC_DATA_SEL;
+
+	if (data_len & 0x03) {
+		dbg(host, "Hardware doesn't support not-aligned len TPCs!");
+		host->req->error = -ENOSYS;
+		return host->req->error;
+	}
+
+	/* DMA */
+	if (!no_dma && host->req->long_data) {
+
+		dbg(host, "IO: Using DMA");
+		host->cmd_flags |= DMA_DATA;
+
+		if (pci_map_sg(host->chip->pdev,
+			&host->req->sg, 1, is_read
+			? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE) != 1) {
+
+			dbg(host, "IO: DMA map failed");
 			host->req->error = -ENOMEM;
 			return host->req->error;
 		}
-		data_len = sg_dma_len(&host->req->sg);
-		writel(sg_dma_address(&host->req->sg),
-		       host->addr + DMA_ADDRESS);
-		writel(((1 << 16) & BLOCK_COUNT_MASK)
-		       | (data_len & BLOCK_SIZE_MASK),
-		       host->addr + BLOCK);
-		writel(DMA_CONTROL_ENABLE, host->addr + DMA_CONTROL);
-	} else if (!(host->cmd_flags & REG_DATA)) {
-		writel(((1 << 16) & BLOCK_COUNT_MASK)
-		       | (data_len & BLOCK_SIZE_MASK),
-		       host->addr + BLOCK);
-			t_val = readl(host->addr + INT_STATUS_ENABLE);
-			t_val |= host->req->data_dir == READ
-				 ? INT_STATUS_FIFO_RRDY
-				 : INT_STATUS_FIFO_WRDY;
-
-			writel(t_val, host->addr + INT_STATUS_ENABLE);
-			writel(t_val, host->addr + INT_SIGNAL_ENABLE);
+
+		/* We really shouldn't pretend we support that case */
+		if (sg_dma_len(&host->req->sg) != data_len) {
+			dbg(host, "IO: DMA len mismatch");
+			host->req->error = -EFAULT;
+			return host->req->error;
+		}
+
+		j38ms_write_reg(host, BLOCK, data_len | BLOCK_COUNT_1BLOCK);
+		j38ms_write_reg(host, DMA_ADDRESS,
+					sg_dma_address(&host->req->sg));
+		j38ms_write_reg(host, DMA_CONTROL, DMA_CONTROL_ENABLE);
+	/* PIO */
 	} else {
-		cmd &= ~(TPC_DATA_SEL | 0xf);
-		host->cmd_flags |= REG_DATA;
-		cmd |= data_len & 0xf;
 
-		if (host->req->data_dir == WRITE)
-			j38ms_write_tpc_inline(host);
-	}
+		dbg(host, "IO: Using PIO");
+		host->cmd_flags |= PIO_DATA;
 
-	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
-	writel(HOST_CONTROL_LED | readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
-	host->req->error = 0;
+		host->pio_offset = 0;
+		host->pio_tmp_buf_len = 0;
+		memset(host->pio_tmp_buf, 0, 4);
 
-	writel(cmd, host->addr + TPC);
-	dev_dbg(&msh->dev, "executing TPC %08x, len %x\n", cmd, data_len);
+		if (host->req->long_data)
+			sg_miter_start(&host->pio_sg_iter,
+				&host->req->sg, 1, SG_MITER_ATOMIC |
+				(is_read ? SG_MITER_FROM_SG : SG_MITER_TO_SG));
+
+		/* Enable FIFO empty interrupts */
+		t_val = is_read ? INT_STATUS_FIFO_RRDY : INT_STATUS_FIFO_WRDY;
 
+		j38ms_write_reg(host, BLOCK, data_len | BLOCK_COUNT_1BLOCK);
+		j38ms_set_reg_mask(host, INT_SIGNAL_ENABLE, t_val);
+		j38ms_set_reg_mask(host, INT_STATUS_ENABLE, t_val);
+	}
+exec:
+	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
+
+	/* Let the TPC fly... */
+	j38ms_write_reg(host, TPC, cmd);
+	j38ms_set_reg_mask(host, HOST_CONTROL, HOST_CONTROL_LED);
 	return 0;
 }
 
@@ -349,44 +376,42 @@ static int j38ms_execute_tpc(struct memstick_host *msh)
 static void j38ms_complete_tpc(struct memstick_host *msh, int last)
 {
 	struct j38ms_host *host = memstick_priv(msh);
-	unsigned int t_val = 0;
 	int rc;
-
 	del_timer(&host->timer);
 
-	dev_dbg(&msh->dev, "c control %08x\n",
-		readl(host->addr + HOST_CONTROL));
-	dev_dbg(&msh->dev, "c status %08x\n",
-		readl(host->addr + INT_STATUS));
-	dev_dbg(&msh->dev, "c hstatus %08x\n", readl(host->addr + STATUS));
+	dbg(host, "IO: TPC complete (error : %d)", host->req->error);
 
-	host->req->int_reg = readl(host->addr + STATUS) & 0xff;
+	j38ms_write_reg(host, BLOCK, 0);
+	j38ms_write_reg(host, DMA_CONTROL, 0);
 
-	writel(0, host->addr + BLOCK);
-	writel(0, host->addr + DMA_CONTROL);
+	dbg_v(host, "host control: %08x", j38ms_read_reg(host, HOST_CONTROL));
+	dbg_v(host, "int status: %08x", j38ms_read_reg(host, INT_STATUS));
+	dbg_v(host, "card status: %08x", j38ms_read_reg(host, STATUS));
+
+	if (host->req->need_card_int)
+		host->req->int_reg = j38ms_read_reg(host, STATUS) & 0xFF;
 
 	if (host->cmd_flags & DMA_DATA) {
 		pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
-			     host->req->data_dir == READ
-			     ? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
-	} else {
-		t_val = readl(host->addr + INT_STATUS_ENABLE);
-		if (host->req->data_dir == READ)
-			t_val &= ~INT_STATUS_FIFO_RRDY;
-		else
-			t_val &= ~INT_STATUS_FIFO_WRDY;
+			host->req->data_dir == READ
+			? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
 
-		writel(t_val, host->addr + INT_STATUS_ENABLE);
-		writel(t_val, host->addr + INT_SIGNAL_ENABLE);
+	} else if (host->cmd_flags & PIO_DATA) {
+		u32 t_val = INT_STATUS_FIFO_RRDY | INT_STATUS_FIFO_WRDY;
+
+		/* This is not known well */
+		j38ms_clear_reg_mask(host, INT_STATUS_ENABLE, t_val);
+
+		/* This disables the IRQ to host, really */
+		j38ms_clear_reg_mask(host, INT_SIGNAL_ENABLE, t_val);
 	}
 
-	writel((~HOST_CONTROL_LED) & readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
+	j38ms_clear_reg_mask(host, HOST_CONTROL, HOST_CONTROL_LED);
 
 	if (!last) {
 		do {
 			rc = memstick_next_req(msh, &host->req);
-		} while (!rc && j38ms_execute_tpc(msh));
+		} while (!rc && j38ms_execute_tpc(host));
 	} else {
 		do {
 			rc = memstick_next_req(msh, &host->req);
@@ -488,7 +513,7 @@ static void j38ms_submit_tasklet(unsigned long data)
 		do {
 			rc = memstick_next_req(msh, &host->req);
 			dev_dbg(&host->chip->pdev->dev, "tasklet req %d\n", rc);
-		} while (!rc && j38ms_execute_tpc(msh));
+		} while (!rc && j38ms_execute_tpc(host));
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 }
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index d7dffb6..429ed49 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -173,7 +173,8 @@ enum {
 	CMD_READY    = 0x01,
 	FIFO_READY   = 0x02,
 	REG_DATA     = 0x04,
-	DMA_DATA     = 0x08
+	DMA_DATA     = 0x08,
+	PIO_DATA     = 0x10
 };
 
 
-- 
1.7.1

