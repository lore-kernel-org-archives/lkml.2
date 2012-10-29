Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2J2VqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:46:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:48847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094Ab2J2Vlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 39/54] mac80211: check if key has TKIP type before updating IV
Date: Mon, 29 Oct 2012 14:40:40 -0700
Message-Id: <20121029213807.089774569@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 4045f72bcf3c293c7c5932ef001742d8bb5ded76 upstream.

This patch fix corruption which can manifest itself by following crash
when switching on rfkill switch with rt2x00 driver:
https://bugzilla.redhat.com/attachment.cgi?id=615362

Pointer key->u.ccmp.tfm of group key get corrupted in:

ieee80211_rx_h_michael_mic_verify():

        /* update IV in key information to be able to detect replays */
        rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
        rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;

because rt2x00 always set RX_FLAG_MMIC_STRIPPED, even if key is not TKIP.

We already check type of the key in different path in
ieee80211_rx_h_michael_mic_verify() function, so adding additional
check here is reasonable.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/wpa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -106,7 +106,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
+		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key &&
+		    rx->key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
 			goto update_iv;
 
 		return RX_CONTINUE;


