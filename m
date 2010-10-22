Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0JVX53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:57:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0JVXyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nRrC7E2b0uBttNg2chz1sAQO2hwmHtp9eMgTJeg0wuwpn+BOre2Sp/v7qKlO6TAev9
         1GZUcLXQAKd2gKXu0Rj559B4OKD0pAu0C8MYWPZfkqHmnlQKf2aljhNnVOQZ3wkhUBxV
         GLLuubd8tQ3Syk/RfAyDeyz3fytqTihmU9l6M=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 19/29] memstick: jmb38x_ms: add register read/write functions
Date: Sat, 23 Oct 2010 01:53:47 +0200
Message-Id: <1287791637-10329-20-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All over the code it is a bit easier to see the
register access with this patch. Also set/clear mask
helpers refactor code a bit, but the biggest reason
for this patch is to make it possible to trace register
read/writes with a flip of a module param.

Currently these functions are unused, but will be by later code

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  102 ++++++++++++++++++++++++++++++++++++-
 drivers/memstick/host/jmb38x_ms.h |    1 +
 2 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 295f755..bcdb785 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -22,8 +22,86 @@
 static int no_dma;
 static int debug;
 
+/* Read a register*/
+static inline u32 j38ms_read_reg(struct j38ms_host *host, int address)
+{
+	u32 value =  readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x == 0x%08x", address, value);
+	return value;
+}
+
+/* Write a register */
+static inline void j38ms_write_reg(struct j38ms_host *host,
+						int address, u32 value)
+{
+	dbg_reg(host, "reg 0x%02x <- 0x%08x", address, cpu_to_le32(value));
+	writel(value, host->addr + address);
+}
+
+/* Read a register without endiannes conversion*/
+static inline u32 j38ms_read_reg_raw(struct j38ms_host *host, int address)
+{
+	u32 value =  __raw_readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x == 0x%08x", address, cpu_to_le32(value));
+	return value;
+}
+
+/* Write a register without endiannes conversion */
+static inline void j38ms_write_reg_raw(struct j38ms_host *host,
+						int address, u32 value)
+{
+	dbg_reg(host, "reg 0x%02x <- 0x%08x", address, value);
+	__raw_writel(value, host->addr + address);
+}
+
+/* Set specific bits in a register*/
+static inline void j38ms_set_reg_mask(struct j38ms_host *host,
+						int address, u32 mask)
+{
+	u32 reg = readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x |= 0x%08x (old =0x%08x)", address, mask, reg);
+	writel(reg | mask , host->addr + address);
+}
+
+/* Clear specific bits in a register*/
+static inline void j38ms_clear_reg_mask(struct j38ms_host *host,
+						int address, u32 mask)
+{
+	u32 reg = readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x &= 0x%08x (old = 0x%08x, mask = 0x%08x)",
+						address, ~mask, reg, mask);
+	writel(reg & ~mask, host->addr + address);
+}
+
+/* Reads one DWORD via PIO. returns -EAGAIN if fifo is empty */
+static inline int j38ms_read_fifo_dword_pio(struct j38ms_host *host, u32 *dword)
+{
+	if (unlikely(j38ms_read_reg(host, STATUS) & STATUS_FIFO_EMPTY)) {
+		dbg(host, "PIO: FIFO empty");
+		return -EAGAIN;
+	}
+
+	*dword = j38ms_read_reg_raw(host, DATA);
+	dbg(host, "PIO: read: %08x", *dword);
+	return 0;
+}
+
+/* Writes one DWORD via PIO. returns -EAGAIN if fifo is full */
+static inline int j38ms_write_fifo_dword_pio(struct j38ms_host *host, u32 dword)
+{
+	if (unlikely(j38ms_read_reg(host, STATUS) & STATUS_FIFO_FULL)) {
+		dbg(host, "PIO: FIFO full");
+		return -EAGAIN;
+	}
+
+	dbg(host, "PIO: writing: %08x", dword);
+	j38ms_write_reg_raw(host, DATA, dword);
+	return 0;
+}
+
+/* Read TPC data using PIO */
 static unsigned int j38ms_read_fifo_pio(struct j38ms_host *host,
-					unsigned char *buf, unsigned int length)
+				unsigned char *buf, unsigned int length)
 {
 	unsigned int off = 0;
 
@@ -60,6 +138,7 @@ static unsigned int j38ms_read_fifo_pio(struct j38ms_host *host,
 	return off;
 }
 
+/* Write TPC data through normal PIO fifo */
 static unsigned int j38ms_write_fifo_pio(struct j38ms_host *host,
 					 unsigned char *buf,
 					 unsigned int length)
@@ -113,6 +192,7 @@ static unsigned int j38ms_write_fifo_pio(struct j38ms_host *host,
 	return off;
 }
 
+/* Transfer data between current request and FIFO */
 static int j38ms_transfer_data(struct j38ms_host *host)
 {
 	unsigned int length;
@@ -180,6 +260,7 @@ static int j38ms_transfer_data(struct j38ms_host *host)
 	return length;
 }
 
+/* Read short TPC data (up to 8 bytes) via 2 special registers*/
 static unsigned int j38ms_read_tpc_inline(struct j38ms_host *host,
 					    unsigned char *buf,
 					    unsigned int length)
@@ -206,6 +287,7 @@ static unsigned int j38ms_read_tpc_inline(struct j38ms_host *host,
 	return off;
 }
 
+/* Write short TPC data (up to 8 bytes) through 2 special registers */
 static unsigned int j38ms_write_tpc_inline(struct j38ms_host *host,
 					     unsigned char *buf,
 					     unsigned int length)
@@ -232,6 +314,19 @@ static unsigned int j38ms_write_tpc_inline(struct j38ms_host *host,
 	return off;
 }
 
+/*
+ * Start execution of a TPC:
+ * NOTES:
+ *
+ * PIO writes trigger wierd hardware bug that causes DMA writes
+ *  to fail.
+ *
+ * length alignmemt:
+ *	Short (<=8) TPC don't have any alignment problems.
+ *	DMA read/writes must be 4 aligned
+ *	PIO _reads_ must be aligned. Writes can be not aligned
+ *
+ */
 static int j38ms_execute_tpc(struct memstick_host *msh)
 {
 	struct j38ms_host *host = memstick_priv(msh);
@@ -330,6 +425,7 @@ static int j38ms_execute_tpc(struct memstick_host *msh)
 	return 0;
 }
 
+/* Cleanups execution of current TPC */
 static void j38ms_complete_tpc(struct memstick_host *msh, int last)
 {
 	struct j38ms_host *host = memstick_priv(msh);
@@ -380,6 +476,7 @@ static void j38ms_complete_tpc(struct memstick_host *msh, int last)
 	}
 }
 
+/* Interrupt handler */
 static irqreturn_t j38ms_isr(int irq, void *dev_id)
 {
 	struct memstick_host *msh = dev_id;
@@ -452,6 +549,7 @@ static irqreturn_t j38ms_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/* Timer that is executed in absense of the interrupt */
 static void j38ms_irq_timeout(unsigned long data)
 {
 	struct memstick_host *msh = (struct memstick_host *)data;
@@ -496,6 +594,7 @@ static void j38ms_submit_req(struct memstick_host *msh)
 	tasklet_schedule(&host->notify);
 }
 
+/* hardware reset */
 static int j38ms_reset(struct j38ms_host *host)
 {
 	int cnt;
@@ -700,6 +799,7 @@ static struct memstick_host *j38ms_alloc_host(struct j38ms *jm, int cnt)
 		return NULL;
 
 	host = memstick_priv(msh);
+	host->msh = msh;
 	host->chip = jm;
 	host->addr = ioremap(pci_resource_start(jm->pdev, cnt),
 			     pci_resource_len(jm->pdev, cnt));
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index 44e1fc1..35b8bca 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -144,6 +144,7 @@
 
 struct j38ms_host {
 	struct j38ms            *chip;
+	struct memstick_host    *msh;
 	void __iomem            *addr;
 	spinlock_t              lock;
 	struct tasklet_struct   notify;
-- 
1.7.1

