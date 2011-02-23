Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1BWBFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:05:21 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17350 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781Ab1BWBEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:04:50 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next 8/8] pch_uart: Fix DMA channel miss-setting issue.
Date: Wed, 23 Feb 2011 10:03:19 +0900
Message-Id: <1298422999-4050-8-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |   59 ++++++++++++++++++++++++++++++++--------
 1 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c525178..7aba41f 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -234,6 +234,36 @@ struct eg20t_port {
 	dma_addr_t			rx_buf_dma;
 };
 
+/**
+ * struct pch_uart_driver_data - private data structure for UART-DMA
+ * @port_type:			The number of DMA channel
+ * @line_no:			UART port line number (0, 1, 2...)
+ */
+struct pch_uart_driver_data {
+	int port_type;
+	int line_no;
+};
+
+enum pch_uart_num_t {
+	pch_et20t_uart0 = 0,
+	pch_et20t_uart1,
+	pch_et20t_uart2,
+	pch_et20t_uart3,
+	pch_ml7213_uart0,
+	pch_ml7213_uart1,
+	pch_ml7213_uart2,
+};
+
+static struct pch_uart_driver_data drv_dat[] = {
+	[pch_et20t_uart0] = {PCH_UART_8LINE, 0},
+	[pch_et20t_uart1] = {PCH_UART_2LINE, 1},
+	[pch_et20t_uart2] = {PCH_UART_2LINE, 2},
+	[pch_et20t_uart3] = {PCH_UART_2LINE, 3},
+	[pch_ml7213_uart0] = {PCH_UART_8LINE, 0},
+	[pch_ml7213_uart1] = {PCH_UART_2LINE, 1},
+	[pch_ml7213_uart2] = {PCH_UART_2LINE, 2},
+};
+
 static unsigned int default_baud = 9600;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
@@ -567,7 +597,8 @@ static void pch_request_dma(struct uart_port *port)
 	/* Set Tx DMA */
 	param = &priv->param_tx;
 	param->dma_dev = &dma_dev->dev;
-	param->chan_id = priv->port.line;
+	param->chan_id = priv->port.line * 2; /* Tx = 0, 2, 4, ... */
+
 	param->tx_reg = port->mapbase + UART_TX;
 	chan = dma_request_channel(mask, filter, param);
 	if (!chan) {
@@ -580,7 +611,8 @@ static void pch_request_dma(struct uart_port *port)
 	/* Set Rx DMA */
 	param = &priv->param_rx;
 	param->dma_dev = &dma_dev->dev;
-	param->chan_id = priv->port.line + 1; /* Rx = Tx + 1 */
+	param->chan_id = priv->port.line * 2 + 1; /* Rx = Tx + 1 */
+
 	param->rx_reg = port->mapbase + UART_RX;
 	chan = dma_request_channel(mask, filter, param);
 	if (!chan) {
@@ -1357,8 +1389,11 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	unsigned int mapbase;
 	unsigned char *rxbuf;
 	int fifosize, base_baud;
-	static int num;
-	int port_type = id->driver_data;
+	int port_type;
+	struct pch_uart_driver_data *board;
+
+	board = &drv_dat[id->driver_data];
+	port_type = board->port_type;
 
 	priv = kzalloc(sizeof(struct eg20t_port), GFP_KERNEL);
 	if (priv == NULL)
@@ -1403,7 +1438,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	priv->port.ops = &pch_uart_ops;
 	priv->port.flags = UPF_BOOT_AUTOCONF;
 	priv->port.fifosize = fifosize;
-	priv->port.line = num++;
+	priv->port.line = board->line_no;
 	priv->trigger = PCH_UART_HAL_TRIGGER_M;
 
 	spin_lock_init(&priv->port.lock);
@@ -1481,19 +1516,19 @@ static int pch_uart_pci_resume(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(pch_uart_pci_id) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8811),
-	 .driver_data = PCH_UART_8LINE},
+	 .driver_data = pch_et20t_uart0},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8812),
-	 .driver_data = PCH_UART_2LINE},
+	 .driver_data = pch_et20t_uart1},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8813),
-	 .driver_data = PCH_UART_2LINE},
+	 .driver_data = pch_et20t_uart2},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8814),
-	 .driver_data = PCH_UART_2LINE},
+	 .driver_data = pch_et20t_uart3},
 	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8027),
-	 .driver_data = PCH_UART_8LINE},
+	 .driver_data = pch_ml7213_uart0},
 	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8028),
-	 .driver_data = PCH_UART_2LINE},
+	 .driver_data = pch_ml7213_uart1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8029),
-	 .driver_data = PCH_UART_2LINE},
+	 .driver_data = pch_ml7213_uart2},
 	{0,},
 };
 
-- 
1.7.3.4

