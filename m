Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031904Ab2I1Utq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:49:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37125 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945959Ab2I1UtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:49:01 -0400
X-Sasl-enc: hlTkKNVuu9B9W+CiXLnbgm5YipsSQpJMMZjavPTSsTP6 1348865340
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Cooper <acooper@gmail.com>, Arindam Nath <arindam.nath@amd.com>,
        Philip Rakity <prakity@marvell.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 120/127] mmc: Prevent 1.8V switch for SD hosts that dont support UHS modes.
Date: Fri, 28 Sep 2012 13:34:53 -0700
Message-Id: <20120928203059.932060482@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2515,8 +2515,9 @@ int sdhci_add_host(struct sdhci_host *ho
 	    mmc_card_is_removable(mmc))
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
-	/* UHS-I mode(s) supported by the host controller. */
-	if (host->version >= SDHCI_SPEC_300)
+	/* Any UHS-I mode in caps implies SDR12 and SDR25 support. */
+	if (caps[1] & (SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 |
+		       SDHCI_SUPPORT_DDR50))
 		mmc->caps |= MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
 
 	/* SDR104 supports also implies SDR50 support */


