Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0G3RSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:17 -0400
Received: from kroah.org ([198.145.64.141]:46248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab0G3RR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:01 2010
Message-Id: <20100730171501.460280154@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [020/165] ath5k: drop warning on jumbo frames
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1818,11 +1818,6 @@ ath5k_tasklet_rx(unsigned long data)
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
@@ -1852,6 +1847,8 @@ ath5k_tasklet_rx(unsigned long data)
 					sc->opmode != NL80211_IFTYPE_MONITOR)
 				goto next;
 		}
+		if (unlikely(rs.rs_more))
+			goto next;
 accept:
 		next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
 


