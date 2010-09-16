Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0IPHFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:05:38 -0400
Received: from pegase1.c-s.fr ([194.2.40.7]:53213 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab0IPHFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:05:37 -0400
Subject: [PATCH] spi_mpc8xxx: fix buffer overrun when sending only/receiving only more than PAGE_SIZE bytes
From: christophe leroy <christophe.leroy@c-s.fr>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-Id: <20100916070525.4882CC7391@messagerie.si.c-s.fr>
Date: Thu, 16 Sep 2010 09:05:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to 2.6.34.7 and 2.6.35.4
It fixes an issue when sending only or receiving only more than PAGE_SIZE bytes

Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

diff -urN c/drivers/spi/spi_mpc8xxx.c d/drivers/spi/spi_mpc8xxx.c
--- c/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:03.000000000 +0200
+++ d/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:14.000000000 +0200
@@ -393,11 +393,17 @@
 
 	xfer_ofs = mspi->xfer_in_progress->len - mspi->count;
 
-	out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
+	if (mspi->rx_dma == mspi->dma_dummy_rx)
+		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma);
+	else
+		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
 	out_be16(&rx_bd->cbd_datlen, 0);
 	out_be16(&rx_bd->cbd_sc, BD_SC_EMPTY | BD_SC_INTRPT | BD_SC_WRAP);
 
-	out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
+	if (mspi->tx_dma == mspi->dma_dummy_tx)
+		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma);
+	else
+		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
 	out_be16(&tx_bd->cbd_datlen, xfer_len);
 	out_be16(&tx_bd->cbd_sc, BD_SC_READY | BD_SC_INTRPT | BD_SC_WRAP |
 				 BD_SC_LAST);
