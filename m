Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0LPHLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:11:11 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:3924 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825Ab0LPHLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:11:06 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next] pch_uart : fix warnings for 64bit compile
Date: Thu, 16 Dec 2010 16:13:29 +0900
Message-Id: <1292483609-18492-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings
drivers/serial/pch_uart.c: In function ‘dma_handle_rx’:
drivers/serial/pch_uart.c:685:24: warning: cast from pointer to integer of different size
drivers/serial/pch_uart.c: In function ‘dma_handle_tx’:
drivers/serial/pch_uart.c:778:23: warning: cast from pointer to integer of different size
drivers/serial/pch_uart.c: In function ‘pch_uart_init_port’:
drivers/serial/pch_uart.c:1289:20: warning: cast to pointer from integer of different size
drivers/serial/pch_uart.c: In function ‘pch_uart_exit_port’:
drivers/serial/pch_uart.c:1328:2: warning: cast from pointer to integer of different size

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Reported-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/pch_uart.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/pch_uart.c b/drivers/serial/pch_uart.c
index b94d1fa..70a6145 100644
--- a/drivers/serial/pch_uart.c
+++ b/drivers/serial/pch_uart.c
@@ -682,7 +682,8 @@ static int dma_handle_rx(struct eg20t_port *priv)
 	sg_dma_len(sg) = priv->fifo_size;
 
 	sg_set_page(&priv->sg_rx, virt_to_page(priv->rx_buf_virt),
-		     sg_dma_len(sg), (int)priv->rx_buf_virt & ~PAGE_MASK);
+		     sg_dma_len(sg), (unsigned long)priv->rx_buf_virt &
+		     ~PAGE_MASK);
 
 	sg_dma_address(sg) = priv->rx_buf_dma;
 
@@ -1254,7 +1255,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	int ret;
 	unsigned int iobase;
 	unsigned int mapbase;
-	unsigned int rxbuf;
+	unsigned char *rxbuf;
 	int fifosize, base_baud;
 	static int num;
 
@@ -1262,7 +1263,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (priv == NULL)
 		goto init_port_alloc_err;
 
-	rxbuf = __get_free_page(GFP_KERNEL);
+	rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
@@ -1286,7 +1287,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	priv->iobase = iobase;
 	priv->pdev = pdev;
 	priv->tx_empty = 1;
-	priv->rxbuf.buf = (unsigned char *)rxbuf;
+	priv->rxbuf.buf = rxbuf;
 	priv->rxbuf.size = PAGE_SIZE;
 
 	priv->fifo_size = fifosize;
@@ -1313,7 +1314,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	return priv;
 
 init_port_hal_free:
-	free_page(rxbuf);
+	free_page((unsigned long)rxbuf);
 init_port_free_txbuf:
 	kfree(priv);
 init_port_alloc_err:
@@ -1325,7 +1326,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 {
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
 	pci_set_drvdata(priv->pdev, NULL);
-	free_page((unsigned int)priv->rxbuf.buf);
+	free_page((unsigned long)priv->rxbuf.buf);
 }
 
 static void pch_uart_pci_remove(struct pci_dev *pdev)
-- 
1.6.0.6

