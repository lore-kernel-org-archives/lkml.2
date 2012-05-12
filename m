Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554Ab2ELAfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:35:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63290 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2ELAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:35:41 -0400
Date: Fri, 11 May 2012 19:35:33 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Arend van Spriel <arend@broadcom.com>, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 018/167] [PATCH] brcm80211: smac: resume transmit fifo upon
 receiving frames
Message-ID: <20120512003533.GA2931@burratino>
References: <20120509055032.096457048@decadent.org.uk>
 <1336779723.8274.473.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336779723.8274.473.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> brcms_b_mute() takes three arguments in 3.2.  Can you send me a patch to
> fix this up in 3.2.y, or should I revert the change?

Sorry to have missed this.  Here's the fixup used when backporting to
3.0.y.

-- >8 --
Subject: brcm80211: smac: pass missing argument to 'brcms_b_mute'

[Not needed upstream --- this bug is specific to 3.2.y.]

Commit c6c44893c864, which removes the flag argument from brcms_b_mute,
is not part of 3.2.y, and we forgot to adjust a new call accordingly
when applying commit badc4f07622f ("brcm80211: smac: resume transmit
fifo upon receiving frames").

 drivers/net/wireless/brcm80211/brcmsmac/main.c: In function 'brcms_c_recvctl':
 drivers/net/wireless/brcm80211/brcmsmac/main.c:7882:4: error: too few arguments to function 'brcms_b_mute'
 drivers/net/wireless/brcm80211/brcmsmac/main.c:2538:13: note: declared here

Earlier build tests missed this because they didn't include this driver
due to 'depends on BCMA=n'.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f98becc9e169..833cbefcbfd2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7879,7 +7879,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	if (wlc->hw->suspended_fifos) {
 		hdr = (struct ieee80211_hdr *)p->data;
 		if (ieee80211_is_beacon(hdr->frame_control))
-			brcms_b_mute(wlc->hw, false);
+			brcms_b_mute(wlc->hw, false, 0);
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
-- 
1.7.10.1

