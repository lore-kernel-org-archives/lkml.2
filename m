Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2JGXcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:32:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38556 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520Ab2JGXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:02 -0400
Message-Id: <20121007225842.722868544@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Cooper <acooper@gmail.com>, Arindam Nath <arindam.nath@amd.com>,
        Philip Rakity <prakity@marvell.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 058/108] mmc: Prevent 1.8V switch for SD hosts that dont support UHS modes.
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Cooper <acooper@gmail.com>

commit 4188bba0e9e7ba58d231b528df495666f2742b74 upstream.

The driver should not try to switch to 1.8V when the SD 3.0 host
controller does not have any UHS capabilities bits set (SDR50, DDR50
or SDR104). See page 72 of "SD Specifications Part A2 SD Host
Controller Simplified Specification Version 3.00" under
"1.8V Signaling Enable". Instead of setting SDR12 and SDR25 in the host
capabilities data structure for all V3.0 host controllers, only set them
if SDR104, SDR50 or DDR50 is set in the host capabilities register. This
will prevent the switch to 1.8V later.

Signed-off-by: Al Cooper <acooper@gmail.com>
Acked-by: Arindam Nath <arindam.nath@amd.com>
Acked-by: Philip Rakity <prakity@marvell.com>
Acked-by: Girish K S <girish.shivananjappa@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sdhci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8262cad..9aa77f3 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2782,8 +2782,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	    mmc_card_is_removable(mmc))
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
-	/* UHS-I mode(s) supported by the host controller. */
-	if (host->version >= SDHCI_SPEC_300)
+	/* Any UHS-I mode in caps implies SDR12 and SDR25 support. */
+	if (caps[1] & (SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 |
+		       SDHCI_SUPPORT_DDR50))
 		mmc->caps |= MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
 
 	/* SDR104 supports also implies SDR50 support */


