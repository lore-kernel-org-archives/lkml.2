Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab1CRWMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:12:17 -0400
Received: from mail.atheros.com ([12.19.149.2]:44350 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890Ab1CRWMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:12:10 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <cjb@laptop.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vmehta@atheros.com>, <naveen.singh@atheros.com>, <kvalo@adurom.com>,
        <j@w1.fi>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Naveen Singh <nsingh@atheros.com>,
        Vipin Mehta <Vipin.Mehta@atheros.com>
Subject: [RFC 1/4] sdhci: allow for multiple delays when sending commands
Date: Fri, 18 Mar 2011 15:11:57 -0700
Message-ID: <1300486320-23607-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
In-Reply-To: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is at least known to be required for the ENE 714.

Cc: Chris Ball <cjb@laptop.org>
Cc: Kalle Valo <kvalo@adurom.com>
Cc: Naveen Singh <nsingh@atheros.com>
Cc: Vipin Mehta <Vipin.Mehta@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/mmc/host/sdhci.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9e15f41..c95dfc2 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -891,8 +891,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	WARN_ON(host->cmd);
 
-	/* Wait max 10 ms */
-	timeout = 10;
+	/* Wait max this amount of ms */
+	timeout = (10*256) + 255;
 
 	mask = SDHCI_CMD_INHIBIT;
 	if ((cmd->data != NULL) || (cmd->flags & MMC_RSP_BUSY))
@@ -913,7 +913,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 			return;
 		}
 		timeout--;
-		mdelay(1);
+		if (!(timeout & 0xFF))
+			mdelay(1);
 	}
 
 	mod_timer(&host->timer, jiffies + 10 * HZ);
-- 
1.7.4.15.g7811d

