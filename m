Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab1D2TEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:04:32 -0400
Received: from kroah.org ([198.145.64.141]:50323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab1D2S6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.570642374@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [31/55] ath9k_hw: partially revert "fix dma descriptor rx error bit parsing"
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 115dad7a7f42e68840392767323ceb9306dbdb36 upstream.

The rx error bit parsing was changed to consider PHY errors and various
decryption errors separately. While correct according to the documentation,
this is causing spurious decryption error reports in some situations.

Fix this by restoring the original order of the checks in those places,
where the errors are meant to be mutually exclusive.

If a CRC error is reported, then MIC failure and decryption errors
are irrelevant, and a PHY error is unlikely.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/mac.c        |   14 ++++++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -615,7 +615,7 @@ int ath9k_hw_process_rxdesc_edma(struct
 		 */
 		if (rxsp->status11 & AR_CRCErr)
 			rxs->rs_status |= ATH9K_RXERR_CRC;
-		if (rxsp->status11 & AR_PHYErr) {
+		else if (rxsp->status11 & AR_PHYErr) {
 			phyerr = MS(rxsp->status11, AR_PHYErrCode);
 			/*
 			 * If we reach a point here where AR_PostDelimCRCErr is
@@ -638,11 +638,11 @@ int ath9k_hw_process_rxdesc_edma(struct
 				rxs->rs_phyerr = phyerr;
 			}
 
-		}
-		if (rxsp->status11 & AR_DecryptCRCErr)
+		} else if (rxsp->status11 & AR_DecryptCRCErr)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
-		if (rxsp->status11 & AR_MichaelErr)
+		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
+
 		if (rxsp->status11 & AR_KeyMiss)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -690,17 +690,23 @@ int ath9k_hw_rxprocdesc(struct ath_hw *a
 		rs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
 
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
+		/*
+		 * Treat these errors as mutually exclusive to avoid spurious
+		 * extra error reports from the hardware. If a CRC error is
+		 * reported, then decryption and MIC errors are irrelevant,
+		 * the frame is going to be dropped either way
+		 */
 		if (ads.ds_rxstatus8 & AR_CRCErr)
 			rs->rs_status |= ATH9K_RXERR_CRC;
-		if (ads.ds_rxstatus8 & AR_PHYErr) {
+		else if (ads.ds_rxstatus8 & AR_PHYErr) {
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
-		}
-		if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
+		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
-		if (ads.ds_rxstatus8 & AR_MichaelErr)
+		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
+
 		if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}


