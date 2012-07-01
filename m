Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2GASRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:17:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932532Ab2GASQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:53 -0400
Message-Id: <20120701172009.936644790@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 23/48] ath9k: Fix a WARNING on suspend/resume with IBSS
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit 2031b4c2b4904f7448ab9e4bc6b9bf16e32709f5 upstream.

this patch is dependent on the patch "cfg80211: fix interface
combinations"

In ath9k currently we have ADHOC interface as a single incompatible
interface. when drv_add_interface is called during resume we got to
consider number of vifs already present in addition to checking the
drivers 'opmode' information about ADHOC.  we incorrectly assume
an ADHOC interface is already present. Then we may miss some driver
specific data for the ADHOC interface after resume.

The above mentioned checks can be removed from the driver,
as the patch 'cfg80211: fix interface combinations' ensures that
if an interface type is not advertised by the driver in any of the
interface combinations(via ieee80211_iface_combination) then it shall
be treated as a single incompatible interface. Fixes the following
warning on suspend/resume with ibss interface.

        ath: phy0: Cannot create ADHOC interface when other
        interfaces already exist.
        WARNING: at net/mac80211/driver-ops.h:12
        ieee80211_reconfig+0x1882/0x1ca0 [mac80211]()
        Hardware name: 2842RK1
        wlan2:  Failed check-sdata-in-driver check, flags: 0x0

        Call Trace:
        [<c01361b2>] warn_slowpath_common+0x72/0xa0
        [<f8aaa7c2>] ? ieee80211_reconfig+0x1882/0x1ca0
        [mac80211]
        [<f8aaa7c2>] ? ieee80211_reconfig+0x1882/0x1ca0
        [mac80211]
        [<c0136283>] warn_slowpath_fmt+0x33/0x40
        [<f8aaa7c2>] ieee80211_reconfig+0x1882/0x1ca0 [mac80211]
        [<c06c1d1a>] ? mutex_lock_nested+0x23a/0x2f0
        [<f8a95097>] ieee80211_resume+0x27/0x70 [mac80211]
        [<fd177edf>] wiphy_resume+0x8f/0xa0 [cfg80211]

Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1486,15 +1486,6 @@
 		}
 	}
 
-	if ((ah->opmode == NL80211_IFTYPE_ADHOC) ||
-	    ((vif->type == NL80211_IFTYPE_ADHOC) &&
-	     sc->nvifs > 0)) {
-		ath_err(common, "Cannot create ADHOC interface when other"
-			" interfaces already exist.\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d\n", vif->type);
 


