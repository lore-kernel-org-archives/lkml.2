Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2DYWk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:40:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32788 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab2DYWkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:40:25 -0400
Date: Wed, 25 Apr 2012 17:39:59 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 23/62] brcm80211: smac: resume transmit fifo upon receiving
 frames
Message-ID: <20120425223959.GA6243@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.950806348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223243.950806348@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> 3.3-stable review patch.
[...]
> commit badc4f07622f0f7093a201638f45e85765f1b5e4 upstream.
>
> There have been reports about not being able to use access-points
> on channel 12 and 13 or having connectivity issues when these channels
> were part of the selected regulatory domain. Upon switching to these
> channels the brcmsmac driver suspends the transmit dma fifos. This
> patch resumes them upon handing over the first received beacon to
> mac80211.
>
> This patch is to be applied to the stable tree for kernel versions
> 3.2 and 3.3.

Here's a blind backport to 3.0.y for the next cycle.  Nothing scary
involved, though of course it's completely untested.  Sensible?

Thanks,
Jonathan

-- >8 --
From: Arend van Spriel <arend@broadcom.com>
Date: Wed, 11 Apr 2012 11:52:51 +0200

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
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    3 +--
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 453492610613..934e7f9a8673 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -143,7 +143,6 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw);
 static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw);
 static void wlc_mhfdef(struct wlc_info *wlc, u16 *mhfs, u16 mhf2_init);
 static void wlc_mctrl_write(struct wlc_hw_info *wlc_hw);
-static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool want, mbool flags);
 static void wlc_ucode_mute_override_set(struct wlc_hw_info *wlc_hw);
 static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw);
 static u32 wlc_wlintrsoff(struct wlc_info *wlc);
@@ -2725,7 +2724,7 @@ void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
-static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
+void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
index a5dccc273ac5..a2a4e7328ee4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
@@ -103,6 +103,7 @@ extern void wlc_bmac_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk);
 extern void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw);
 extern void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags);
 extern void wlc_bmac_reset(struct wlc_hw_info *wlc_hw);
+extern void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool want, mbool flags);
 extern void wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 			  bool mute);
 extern int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 4b4a31eff90c..99250e29461f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -6145,6 +6145,7 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
+	struct ieee80211_hdr *hdr;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	prep_mac80211_status(wlc, rxh, p, &rx_status);
@@ -6154,6 +6155,13 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 	skb_pull(p, D11_PHY_HDR_LEN);
 	__skb_trim(p, len_mpdu);
 
+	/* unmute transmit */
+	if (wlc->hw->suspended_fifos) {
+		hdr = (struct ieee80211_hdr *)p->data;
+		if (ieee80211_is_beacon(hdr->frame_control))
+			wlc_bmac_mute(wlc->hw, false, 0);
+	}
+
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 	return;
-- 
1.7.10

