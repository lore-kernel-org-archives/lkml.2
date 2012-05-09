Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab2EIG15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:27:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab2EIFw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:56 -0400
Message-Id: <20120509055032.096457048@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arend van Spriel <arend@broadcom.com>,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 018/167] [PATCH] brcm80211: smac: resume transmit fifo upon receiving frames
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend@broadcom.com>

commit badc4f07622f0f7093a201638f45e85765f1b5e4 upstream.

There have been reports about not being able to use access-points
on channel 12 and 13 or having connectivity issues when these channels
were part of the selected regulatory domain. Upon switching to these
channels the brcmsmac driver suspends the transmit dma fifos. This
patch resumes them upon handing over the first received beacon to
mac80211.

This patch is to be applied to the stable tree for kernel versions
3.2 and 3.3.

Tested-by: Francesco Saverio Schiavarelli <fschiava@libero.it>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 231ddf4..7083db7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7614,6 +7614,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
+	struct ieee80211_hdr *hdr;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	prep_mac80211_status(wlc, rxh, p, &rx_status);
@@ -7623,6 +7624,13 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	skb_pull(p, D11_PHY_HDR_LEN);
 	__skb_trim(p, len_mpdu);
 
+	/* unmute transmit */
+	if (wlc->hw->suspended_fifos) {
+		hdr = (struct ieee80211_hdr *)p->data;
+		if (ieee80211_is_beacon(hdr->frame_control))
+			brcms_b_mute(wlc->hw, false);
+	}
+
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 }
-- 
1.7.10



