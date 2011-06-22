Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1FVJup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:50:45 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:47661 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab1FVJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:50:43 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] pch_uart: Add MSI support
Date: Wed, 22 Jun 2011 11:50:19 +0200
Message-Id: <1308736219-19975-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/tty/serial/pch_uart.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4652109..9db9773 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -234,6 +234,7 @@ struct eg20t_port {
 	int				tx_dma_use;
 	void				*rx_buf_virt;
 	dma_addr_t			rx_buf_dma;
+	int				use_msi;
 };
 
 /**
@@ -1429,6 +1430,12 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 		goto init_port_hal_free;
 	}
 
+	ret = pci_enable_msi(pdev);
+	if (ret)
+		priv->use_msi = 0;
+	else
+		priv->use_msi = 1;
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;
@@ -1485,6 +1492,9 @@ static void pch_uart_pci_remove(struct pci_dev *pdev)
 	struct eg20t_port *priv;
 
 	priv = (struct eg20t_port *)pci_get_drvdata(pdev);
+
+	if (priv->use_msi)
+		pci_disable_msi(pdev);
 	pch_uart_exit_port(priv);
 	pci_disable_device(pdev);
 	kfree(priv);
@@ -1568,6 +1578,8 @@ static int __devinit pch_uart_pci_probe(struct pci_dev *pdev,
 	return ret;
 
 probe_disable_device:
+	if (priv->use_msi)
+		pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 probe_error:
 	return ret;
-- 
1.7.3.4

