Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2KVSvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:51:39 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:29676
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab2KVSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:51:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1de0h1202h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lauri.hintsala@bluegiga.com>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/2] serial: mxs-auart: unmap the scatter list before we copy the data
Date: Thu, 22 Nov 2012 15:06:30 +0800
Message-ID: <1353567990-19907-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1353567990-19907-1-git-send-email-b32955@freescale.com>
References: <1353567990-19907-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should first unmap the DMA scatter list for receiving data, and
then copy the data from the DMA buffer.

The old code misses unmap the scatter list for RX. This patch fixes it.

Signed-off-by: Huang Shijie <b32955@freescale.com>
Tested-by: Lauri Hintsala <lauri.hintsala@bluegiga.com> 
---
 drivers/tty/serial/mxs-auart.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 2342b0d..6b51448 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -461,6 +461,8 @@ static void dma_rx_callback(void *arg)
 	int count;
 	u32 stat;
 
+	dma_unmap_sg(s->dev, &s->rx_sgl, 1, DMA_FROM_DEVICE);
+
 	stat = readl(s->port.membase + AUART_STAT);
 	stat &= ~(AUART_STAT_OERR | AUART_STAT_BERR |
 			AUART_STAT_PERR | AUART_STAT_FERR);
-- 
1.7.0.4


