Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2KZRie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:38:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47889 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601Ab2KZRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 184/270] mac80211: check if key has TKIP type before updating IV
Date: Mon, 26 Nov 2012 14:57:54 -0200
Message-Id: <1353949160-26803-185-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/wpa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index bdb53ab..e72562a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -106,7 +106,8 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
+		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key &&
+		    rx->key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
 			goto update_iv;
 
 		return RX_CONTINUE;
-- 
1.7.9.5

