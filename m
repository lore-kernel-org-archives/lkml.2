Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0GTHxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:53:50 -0400
Received: from mail.renesas.com ([202.234.163.13]:38899 "EHLO
	mail03.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194Ab0GTHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:53:48 -0400
X-AuditID: ac140386-0000000800003037-4a-4c45559c1388
Date: Tue, 20 Jul 2010 16:51:51 +0900
From: Yusuke Goda <yusuke.goda.sx@renesas.com>
Subject: [PATCH] tmio_mmc: Make ack_mmc_irqs() write-only
To: ian@mnementh.co.uk, damm@opensource.se, sameo@linux.intel.com,
        Paul Mundt <lethal@linux-sh.org>, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-id: <4C455597.2020200@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates ack_mmc_irqs() to acknowledge using write instead
of read-modify-write. Without this fix the old read-modify-write
implementation may acknowledge interrupt sources by mistake. The
driver may if so lock-up waiting forever for an interrupt that will
never come. Observed with the TMIO_STAT_RXRDY bit together with CMD53
on AR6002 and BCM4318 SDIO cards in polled mode.

Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
---
 drivers/mmc/host/tmio_mmc.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 64f7d5d..7944604 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -82,10 +82,7 @@

 #define ack_mmc_irqs(host, i) \
 	do { \
-		u32 mask;\
-		mask  = sd_ctrl_read32((host), CTL_STATUS); \
-		mask &= ~((i) & TMIO_MASK_IRQ); \
-		sd_ctrl_write32((host), CTL_STATUS, mask); \
+		sd_ctrl_write32((host), CTL_STATUS, ~(i)); \
 	} while (0)


-- 
1.7.0



