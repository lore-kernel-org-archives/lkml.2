Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0LHA7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:18 -0500
Received: from kroah.org ([198.145.64.141]:48398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab0LHA7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:15 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.394192539@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [020/289] ath9k_hw: handle rx key miss
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 3ae74c33c4f799f6bf6d67240a94a0814a8f1944 upstream.

If AR_KeyMiss is set in the rx descriptor and AR_RxFrameOK is unset,
the hardware could not locate a valid key during a decryption attempt.

In this case, the frame must not be reported as decrypted, otherwise
mac80211 sees only random garbage.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 ++-
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -616,7 +616,8 @@ int ath9k_hw_process_rxdesc_edma(struct
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		} else if (rxsp->status11 & AR_MichaelErr) {
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-		}
+		} else if (rxsp->status11 & AR_KeyMiss)
+			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
 	return 0;
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -713,6 +713,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *a
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
+		else if (ads.ds_rxstatus8 & AR_KeyMiss)
+			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
 	return 0;


