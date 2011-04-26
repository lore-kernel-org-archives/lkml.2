Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1DZVWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:22:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143Ab1DZVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483751"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: nbd@openwrt.org, ak@linux.intel.com, stable@kernel.org,
        linville@tuxdriver.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [81/106] ath9k: fix a chip wakeup related crash in ath9k_start
Message-Id: <20110426211403.01A533E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Felix Fietkau <nbd@openwrt.org>

[ upstream commit f62d816fc4324afbb7cf90110c70b6a14139b225 ]

When the chip is still asleep when ath9k_start is called,
ath9k_hw_configpcipowersave can trigger a data bus error.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>

Index: linux-2.6.35.y/drivers/net/wireless/ath/ath9k/main.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/ath9k/main.c
+++ linux-2.6.35.y/drivers/net/wireless/ath/ath9k/main.c
@@ -1124,6 +1124,8 @@ static int ath9k_start(struct ieee80211_
 		  "Starting driver with initial channel: %d MHz\n",
 		  curchan->center_freq);
 
+	ath9k_ps_wakeup(sc);
+
 	mutex_lock(&sc->mutex);
 
 	if (ath9k_wiphy_started(sc)) {
@@ -1238,6 +1240,8 @@ static int ath9k_start(struct ieee80211_
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
+	ath9k_ps_restore(sc);
+
 	return r;
 }
 
