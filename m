Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1HCXkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:40:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab1HCX1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:46 2011
Message-Id: <20110803221246.522708182@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [025/102] ath9k_hw: Fix incorrect key_miss handling
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>

commit 0472ade031b5c0c69c21cf96acf64c50eb9ba3c2 upstream.

Decryping frames on key_miss handling shouldn't be done for Michael
MIC failed frames as h/w would have already decrypted such frames
successfully anyway.

Also leaving CRC and PHY error(where the frame is going to be dropped
anyway), we are left to prcoess Decrypt error for which s/w decrypt is
selected anway and so having key_miss as a separate check doesn't serve
anything. So making key_miss handling mutually exlusive with other RX
status handling makes much more sense.

This patch addresses an issue with STA not reporting MIC failure events
resulting in STA being disconnected immediately.

Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 +--
 drivers/net/wireless/ath/ath9k/mac.c        |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -629,8 +629,7 @@ int ath9k_hw_process_rxdesc_edma(struct
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-
-		if (rxsp->status11 & AR_KeyMiss)
+		else if (rxsp->status11 & AR_KeyMiss)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -645,8 +645,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *a
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-
-		if (ads.ds_rxstatus8 & AR_KeyMiss)
+		else if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 


