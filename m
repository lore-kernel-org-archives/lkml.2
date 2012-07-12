Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161674Ab2GLXi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:38:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161642Ab2GLWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Leun <lkml20120218@newton.leun.net>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 065/187] ath9k_htc: configure bssid on ASSOC/IBSS change
Date: Thu, 12 Jul 2012 15:33:41 -0700
Message-Id: <20120712191528.429299730@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 931cb03afed7b541392295f3afc4638da32f08a0 upstream.

After the change "mac80211: remove spurious BSSID change flag",
BSS_CHANGED_BSSID will not be passed on association or IBSS
status changes. So it could be better to program bssid on ASSOC
or IBSS change notification. Not doing so, is affecting the
packet transmission.

Reported-by: Michael Leun <lkml20120218@newton.leun.net>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1496,6 +1496,7 @@ static void ath9k_htc_bss_info_changed(s
 			priv->num_sta_assoc_vif++ : priv->num_sta_assoc_vif--;
 
 		if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
+			ath9k_htc_choose_set_bssid(priv);
 			if (bss_conf->assoc && (priv->num_sta_assoc_vif == 1))
 				ath9k_htc_start_ani(priv);
 			else if (priv->num_sta_assoc_vif == 0)
@@ -1503,13 +1504,11 @@ static void ath9k_htc_bss_info_changed(s
 		}
 	}
 
-	if (changed & BSS_CHANGED_BSSID) {
+	if (changed & BSS_CHANGED_IBSS) {
 		if (priv->ah->opmode == NL80211_IFTYPE_ADHOC) {
 			common->curaid = bss_conf->aid;
 			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 			ath9k_htc_set_bssid(priv);
-		} else if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
-			ath9k_htc_choose_set_bssid(priv);
 		}
 	}
 


