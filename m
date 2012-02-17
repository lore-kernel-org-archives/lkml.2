Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2BQBAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:46 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55672 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757074Ab2BQBAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:38 -0500
X-Sasl-enc: tBM6SXfyLUMnt6o90gfmDWiRnQjnQ1DooIZth0uZbfJQ 1329440437
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:37 2012
Message-Id: <20120217005537.481711015@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:56:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>
Subject: [26/28] mmc: atmel-mci: save and restore sdioirq when soft reset is performed
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit 18ee684b8ab666329e0a0a72d8b70f16fb0e2243 upstream.

Sometimes a software reset is needed. Then some registers are saved and
restored but the interrupt mask register is missing. It causes issues
with sdio devices whose interrupts are masked after reset.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -965,11 +965,14 @@ static void atmci_start_request(struct a
 	host->data_status = 0;
 
 	if (host->need_reset) {
+		iflags = atmci_readl(host, ATMCI_IMR);
+		iflags &= (ATMCI_SDIOIRQA | ATMCI_SDIOIRQB);
 		atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
 		atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIEN);
 		atmci_writel(host, ATMCI_MR, host->mode_reg);
 		if (host->caps.has_cfg_reg)
 			atmci_writel(host, ATMCI_CFG, host->cfg_reg);
+		atmci_writel(host, ATMCI_IER, iflags);
 		host->need_reset = false;
 	}
 	atmci_writel(host, ATMCI_SDCR, slot->sdc_reg);


