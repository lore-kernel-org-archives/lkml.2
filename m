Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1CRWMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:12:53 -0400
Received: from mail.atheros.com ([12.19.149.2]:44359 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab1CRWMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:12:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <cjb@laptop.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vmehta@atheros.com>, <naveen.singh@atheros.com>, <kvalo@adurom.com>,
        <j@w1.fi>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Naveen Singh <nsingh@atheros.com>,
        Vipin Mehta <Vipin.Mehta@atheros.com>
Subject: [RFC 3/4] sdhci: cache when the MMC bus width is 4 bits wide
Date: Fri, 18 Mar 2011 15:11:59 -0700
Message-ID: <1300486320-23607-4-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
In-Reply-To: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can later be used when we send commands.

Cc: Chris Ball <cjb@laptop.org>
Cc: Kalle Valo <kvalo@adurom.com>
Cc: Naveen Singh <nsingh@atheros.com>
Cc: Vipin Mehta <Vipin.Mehta@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/mmc/host/sdhci.c  |    7 +++++--
 include/linux/mmc/sdhci.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7074870..a4cf0c0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1206,10 +1206,13 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		} else {
 			if (host->version >= SDHCI_SPEC_300)
 				ctrl &= ~SDHCI_CTRL_8BITBUS;
-			if (ios->bus_width == MMC_BUS_WIDTH_4)
+			if (ios->bus_width == MMC_BUS_WIDTH_4) {
 				ctrl |= SDHCI_CTRL_4BITBUS;
-			else
+				host->flags |= SDHCI_IN_4BIT_MODE;
+			} else {
 				ctrl &= ~SDHCI_CTRL_4BITBUS;
+				host->flags &= ~SDHCI_IN_4BIT_MODE;
+			}
 		}
 		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
 	}
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 83bd9f7..266f796 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -109,6 +109,7 @@ struct sdhci_host {
 #define SDHCI_USE_ADMA		(1<<1)	/* Host is ADMA capable */
 #define SDHCI_REQ_USE_DMA	(1<<2)	/* Use DMA for this req. */
 #define SDHCI_DEVICE_DEAD	(1<<3)	/* Device unresponsive */
+#define SDHCI_IN_4BIT_MODE	(1<<4)  /* bus is in 4-bit mode */
 
 	unsigned int version;	/* SDHCI spec. version */
 
-- 
1.7.4.15.g7811d

