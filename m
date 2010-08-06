Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab0HFSfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:35:53 -0400
Received: from kroah.org ([198.145.64.141]:48629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964898Ab0HFSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:45 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.481645134@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [16/38] ath9k_hw: prevent a fast channel change after a rx DMA stuck issue
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 9cc2f3e881dcda5466c55ffe8dd0a9d1433469cb upstream.

If the receive path gets stuck, a full hardware reset is necessary to
recover from it. If this happens during a scan, the whole scan might fail,
as each channel change bypasses the full reset sequence.
Fix this by resetting the fast channel change flag if stopping the
receive path fails.

This will reduce the number of error messages that look like this:
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1233,9 +1233,11 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 
 	if (!ah->chip_fullsleep) {
 		ath9k_hw_abortpcurecv(ah);
-		if (!ath9k_hw_stopdmarecv(ah))
+		if (!ath9k_hw_stopdmarecv(ah)) {
 			ath_print(common, ATH_DBG_XMIT,
 				"Failed to stop receive dma\n");
+			bChannelChange = false;
+		}
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))


