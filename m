Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2AXCsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776Ab2AXCs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:34 2012
Message-Id: <20120124023934.361708356@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [117/129] ath9k_hw: fix interpretation of the rx KeyMiss flag
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1809
Lines: 53

From: Felix Fietkau <nbd@openwrt.org>

commit 7a532fe7131216a02c81a6c1b1f8632da1195a58 upstream.

Documentation states that the KeyMiss flag is only valid if RxFrameOK is
unset, however empirical evidence has shown that this is false.
When KeyMiss is set (and RxFrameOK is 1), the hardware passes a valid frame
which has not been decrypted. The driver then falsely marks the frame
as decrypted, and when using CCMP this corrupts the rx CCMP PN, leading
to connection hangs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +++--
 drivers/net/wireless/ath/ath9k/mac.c        |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -526,10 +526,11 @@ int ath9k_hw_process_rxdesc_edma(struct
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-		if (rxsp->status11 & AR_KeyMiss)
-			rxs->rs_status |= ATH9K_RXERR_KEYMISS;
 	}
 
+	if (rxsp->status11 & AR_KeyMiss)
+		rxs->rs_status |= ATH9K_RXERR_KEYMISS;
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_process_rxdesc_edma);
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -621,10 +621,11 @@ int ath9k_hw_rxprocdesc(struct ath_hw *a
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-		if (ads.ds_rxstatus8 & AR_KeyMiss)
-			rs->rs_status |= ATH9K_RXERR_KEYMISS;
 	}
 
+	if (ads.ds_rxstatus8 & AR_KeyMiss)
+		rs->rs_status |= ATH9K_RXERR_KEYMISS;
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_rxprocdesc);


