Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab1ABIOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:14:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:33989 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1ABHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 003/260] ath5k: drop warning on jumbo frames
Date: Sun,  2 Jan 2011 02:14:59 -0500
Message-Id: <1293952756-15010-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:10.0162 (UTC) FILETIME=[7D4D6920:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 9637e516d16a58b13f6098cfe899e22963132be3 upstream.

Jumbo frames are not supported, and if they are seen it is likely
a bogus frame so just silently discard them instead of warning on
them all time. Also, instead of dropping them immediately though
move the check *after* we check for all sort of frame errors. This
should enable us to discard these frames if the hardware picks
other bogus items first. Lets see if we still get those jumbo
counters increasing still with this.

Jumbo frames would happen if we tell hardware we can support
a small 802.11 chunks of DMA'd frame, hardware would split RX'd
frames into parts and we'd have to reconstruct them in software.
This is done with USB due to the bulk size but with ath5k we
already provide a good limit to hardware and this should not be
happening.

This is reported quite often and if it fills the logs then this
needs to be addressed and to avoid spurious reports.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a350147..db84169 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1871,11 +1871,6 @@ ath5k_tasklet_rx(unsigned long data)
 			return;
 		}
 
-		if (unlikely(rs.rs_more)) {
-			ATH5K_WARN(sc, "unsupported jumbo\n");
-			goto next;
-		}
-
 		if (unlikely(rs.rs_status)) {
 			if (rs.rs_status & AR5K_RXERR_PHY)
 				goto next;
@@ -1905,6 +1900,8 @@ ath5k_tasklet_rx(unsigned long data)
 					sc->opmode != NL80211_IFTYPE_MONITOR)
 				goto next;
 		}
+		if (unlikely(rs.rs_more))
+			goto next;
 accept:
 		next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
 
-- 
1.7.3.3

