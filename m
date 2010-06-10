Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab0FJOzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:55:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:28063 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759345Ab0FJOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,398,1272870000"; 
   d="scan'208";a="575149506"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3/3] Staging: rtl8192e: Do not send NULL BSSID events when not associated
Date: Thu, 10 Jun 2010 16:54:18 +0200
Message-Id: <1276181658-20379-3-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1276181658-20379-1-git-send-email-sameo@linux.intel.com>
References: <1276181658-20379-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're not associated, we should not send wireless events to let userspace
know that we just left an ESSID, simply because we havent yet joined it.
If we keep on doing that, wpa_supplicant could receive such events while
actually trying to join an ESSID, and thus decide to stop trying. This leads
to a lot of connection failures as this driver seems to be sending GIWAP
events quite a lot.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index 46b6e8c..d2a243a 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -2873,11 +2873,16 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 	if(IS_DOT11D_ENABLE(ieee))
 		Dot11d_Reset(ieee);
 #endif
-	ieee->state = IEEE80211_NOLINK;
 	ieee->is_set_key = false;
 	ieee->link_change(ieee->dev);
 	//HTSetConnectBwMode(ieee, HT_CHANNEL_WIDTH_20, HT_EXTCHNL_OFFSET_NO_EXT);
-	notify_wx_assoc_event(ieee);
+	if (ieee->state == IEEE80211_LINKED ||
+	    ieee->state == IEEE80211_ASSOCIATING) {
+		ieee->state = IEEE80211_NOLINK;
+		notify_wx_assoc_event(ieee);
+	}
+
+	ieee->state = IEEE80211_NOLINK;
 
 }
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
-- 
1.7.0

