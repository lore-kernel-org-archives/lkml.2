Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2BQBDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:03:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58970 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756943Ab2BQBAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:22 -0500
X-Sasl-enc: 7vs5JpDpG0M9SogrQVzuMBBJzvAQ3WRauU0VX75el2CE 1329440421
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:35 2012
Message-Id: <20120217005535.079957995@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        Laurent Bonnans <bonnans.l@gmail.com>,
        Jurica Vukadin <u.ra604@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [08/28] ath9k: fix a WEP crypto related regression
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit f88373fa47f3ce6590fdfaa742d0ddacc2ae017f upstream.

commit b4a82a0 "ath9k_hw: fix interpretation of the rx KeyMiss flag"
fixed the interpretation of the KeyMiss flag for keycache based lookups,
however WEP encryption uses a static index, so KeyMiss is always asserted
for it, even though frames are decrypted properly.
Fix this by clearing the ATH9K_RXERR_KEYMISS flag if no keycache based
lookup was performed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Laurent Bonnans <bonnans.l@gmail.com>
Reported-by: Jurica Vukadin <u.ra604@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/recv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -824,6 +824,14 @@ static bool ath9k_rx_accept(struct ath_c
 		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
 		 ATH9K_RXERR_KEYMISS));
 
+	/*
+	 * Key miss events are only relevant for pairwise keys where the
+	 * descriptor does contain a valid key index. This has been observed
+	 * mostly with CCMP encryption.
+	 */
+	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
+		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
+
 	if (!rx_stats->rs_datalen)
 		return false;
         /*


