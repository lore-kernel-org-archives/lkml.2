Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2FTGTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:19:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39603 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2FTGTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:19:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6747"; a="202775415"
X-IronPort-AV: E=Sophos;i="4.77,440,1336374000"; 
   d="scan'208,223";a="159737512"
Date: Wed, 20 Jun 2012 11:50:49 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Michael Leun <lkml20120218@newton.leun.net>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: ath9k_htc: Every 2nd packet 1000ms delayed in recent kernels
Message-ID: <20120620062047.GB8738@vmraj-lnx.qca.qualcomm.com>
References: <20120619085137.337838c0@xenia.leun.net>
 <CAD2nsn1b6in_yA1b+o=SoXD3iJPddoF4PeCQ3qhFNWqfZxq8pQ@mail.gmail.com>
 <20120620003315.2eaf6460@xenia.leun.net>
 <20120620061303.GA8738@vmraj-lnx.qca.qualcomm.com>
 <20120620081553.040171f4@xenia.leun.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20120620081553.040171f4@xenia.leun.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Jun 20, 2012 at 08:15:53AM +0200, Michael Leun wrote:
> On Wed, 20 Jun 2012 11:43:05 +0530
> Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> 
> 
> > Thanks for the analysis. Can you please try with the attached patch
> > without reverting mac80211 change?
> 
> Radio Eriwan answers: In principle yes, but you forgot the
> attachment ;-)
> 
Oops. Sorry.  

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-ath9k_htc-configure-bssid-on-ASSOC-IBSS-change.patch"

>From 025f26a70c1f8bab443a49f0fe3e7c6627e6550c Mon Sep 17 00:00:00 2001
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Date: Wed, 20 Jun 2012 11:33:37 +0530
Subject: [PATCH] ath9k_htc: configure bssid on ASSOC/IBSS change

After the change "mac80211: remove spurious BSSID change flag",
BSS_CHANGED_BSSID will not be passed on association or IBSS
status changes. So it could be better to program bssid on ASSOC
or IBSS change notification. Not doing so, is affecting the
packet transmission.

Reported-by: Michael Leun <lkml20120218@newton.leun.net>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2b8f61c..abbd6ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1496,6 +1496,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			priv->num_sta_assoc_vif++ : priv->num_sta_assoc_vif--;
 
 		if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
+			ath9k_htc_choose_set_bssid(priv);
 			if (bss_conf->assoc && (priv->num_sta_assoc_vif == 1))
 				ath9k_htc_start_ani(priv);
 			else if (priv->num_sta_assoc_vif == 0)
@@ -1503,13 +1504,11 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
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
 
-- 
1.7.11


--d6Gm4EdcadzBjdND--
