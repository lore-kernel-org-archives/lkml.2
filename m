Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0DSPgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:36:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:20089 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0DSPgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e5Gd7eANC0KgTZM0BvKn77FKpFyv3jAtTJ5ZYRk7kdNOYfNFQyaFT9UhPN3p2sEtF4
         OsWjAzNwF5VXs/m5J3lDMCkVnjss1giOQw0MGo6C4xgD/sGcIsAB79xI94l2udnTkEQ2
         nYJnY48LKje0rxqZBbgUQHyu9D1G0QyA10r0k=
MIME-Version: 1.0
In-Reply-To: <003601cad73c$98c3aa50$544ff780@am.dhcp.ti.com>
References: <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com>
	 <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com>
	 <20100406163211.GA29117@nokia.com> <4BBB6767.7010202@ti.com>
	 <20100406165720.GA17916@nokia.com>
	 <00b401cad5e0$1d1868d0$544ff780@am.dhcp.ti.com>
	 <4BBBC628.9030207@ti.com>
	 <00c901cad5e7$9de54350$544ff780@am.dhcp.ti.com>
	 <4BBBD87C.1040307@ti.com>
	 <003601cad73c$98c3aa50$544ff780@am.dhcp.ti.com>
Date: Mon, 19 Apr 2010 21:06:36 +0530
Message-ID: <s2l7f9d1ffb1004190836l9ba703c5lab13638d968a5c55@mail.gmail.com>
Subject: [PATCH v4] OMAP: Fix for bus width which improves SD card's 
	peformance.
From: kishore kadiyala <kishorek.kadiyala@gmail.com>
To: Madhusudhan <madhu.cr@ti.com>
Cc: Nishanth Menon <nm@ti.com>, felipe.balbi@nokia.com, me@felipebalbi.com,
       Vimal Singh <vimal.newwork@gmail.com>, tony@atomide.com,
       "S, Venkatraman" <svenkatr@ti.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishore Kadiyala <kishore.kadiyala@ti.com>

This patch improves low speeds for SD cards.
OMAP-MMC controller's can support maximum bus width of '8'.
when bus width is mentioned as "8" in controller data,the SD
stack will check whether bus width is "4" and if not it will
set bus width to "1" and there by degrading performance.
This patch fixes the issue and improves the performance of
SD cards.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Nishant Menon <nm@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Tested-by: Jarkko Nikula <jhnikula@gmail.com>
---
In V4 : Updated with Nishant's comments and appened his Signed-off
In V3 : Updated  with Madhu's comments  and appended Tested by Nikula
In V2 : Appended Signed-off by Venkat and Ack by Madhu

 Here are my experiment numbers, on a Class 6 SDHC card:
 Read peformance is increased by 220%
 Write Performance is increased by 52%

 drivers/mmc/host/omap_hsmmc.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 8c97c22..9c1a60e 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2091,10 +2091,23 @@ static int __init omap_hsmmc_probe(struct
platform_device *pdev)
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
 		     MMC_CAP_WAIT_WHILE_BUSY;

-	if (mmc_slot(host).wires >= 8)
-		mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
-	else if (mmc_slot(host).wires >= 4)
+	switch (mmc_slot(host).wires) {
+	case 8:
+		mmc->caps |= MMC_CAP_8_BIT_DATA;
+		/* Fall through */
+	case 4:
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
+		break;
+	case 1:
+		/* Nothing to crib here */
+	case 0:
+		/* Assuming nothing was given by board, Core use's 1-Bit */
+		 break;
+	default:
+		/* Completely unexpected.. Core goes with 1-Bit Width */
+		dev_crit(mmc_dev(host->mmc), "Invalid width %d\n used!"
+			"using 1 instead\n", mmc_slot(host).wires);
+	}

 	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
-- 
1.6.3.3
