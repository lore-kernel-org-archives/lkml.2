Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1BTTFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:05:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1BTTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=O7i+DqopjsQIfjwfSR6jQW6cULdnJtXLWy4/EKA4FMBXw+Rl1VjLuqhWFL3kPOqJKk
         ileU5MwBkrz2d1kXQm723kKn5gCleeKZJs6k+tcU1LzVbVUg7TmDijcMonJwzOEXmgMl
         wyCnFOYha1T5u5vxBkRrboSyZUAXpr9hL/tHQ=
Date: Sun, 20 Feb 2011 20:03:34 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/et131x: fix et131x_rx_dma_disable halt_status usage
Message-ID: <20110220190334.GA3825@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1bd751c1abc1029e8a0ae63ef4f19357c735a2a3
("Staging: et131x: Clean up rxdma_csr") changed csr from bitfield to
u32, but failed to convert 2 uses of halt_status bit. It did:

- if (csr.bits.halt_status != 1)
+ if ((csr & 0x00020000) != 1)

which is wrong, because second version is always true.
Fix it.

This bug was found by coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/et131x/et1310_rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 8e04bdd..a414830 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -717,10 +717,10 @@ void et131x_rx_dma_disable(struct et131x_adapter *etdev)
 	/* Setup the receive dma configuration register */
 	writel(0x00002001, &etdev->regs->rxdma.csr);
 	csr = readl(&etdev->regs->rxdma.csr);
-	if ((csr & 0x00020000) != 1) {	/* Check halt status (bit 17) */
+	if ((csr & 0x00020000) == 0) {	/* Check halt status (bit 17) */
 		udelay(5);
 		csr = readl(&etdev->regs->rxdma.csr);
-		if ((csr & 0x00020000) != 1)
+		if ((csr & 0x00020000) == 0)
 			dev_err(&etdev->pdev->dev,
 			"RX Dma failed to enter halt state. CSR 0x%08x\n",
 				csr);
-- 
1.7.4.rc3

