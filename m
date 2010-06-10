Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab0FJOyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:54:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:9340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832Ab0FJOyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:54:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,398,1272870000"; 
   d="scan'208";a="629219527"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/3] Staging: rtl8192e: Do not mess with carrier settings while scanning
Date: Thu, 10 Jun 2010 16:54:16 +0200
Message-Id: <1276181658-20379-1-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toggling the link carrier is a non sense and is the grossest locking I can
think of. Moreover, it's giving a completely inaccurate status to userspace
who could for example decide to turn the interface down on carrier off
detection.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 .../rtl8192e/ieee80211/ieee80211_softmac_wx.c      |    3 ---
 drivers/staging/rtl8192e/r8192E_core.c             |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
index 1bbd49f..1ce3df2 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
@@ -337,8 +337,6 @@ void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee)
 	ieee80211_sta_ps_send_null_frame(ieee, 1);
 #endif
 
-	netif_carrier_off(ieee->dev);
-
 	if (ieee->data_hard_stop)
 		ieee->data_hard_stop(ieee->dev);
 
@@ -389,7 +387,6 @@ void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee)
 	if(ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
 		ieee80211_start_send_beacons(ieee);
 
-	netif_carrier_on(ieee->dev);
 	count = 0;
 	up(&ieee->wx_sem);
 
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index eb41402..ef0adad 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -4318,7 +4318,6 @@ RESET_START:
 			del_timer_sync(&ieee->associate_timer);
                         cancel_delayed_work(&ieee->associate_retry_wq);
 			ieee80211_stop_scan(ieee);
-			netif_carrier_off(dev);
 			up(&ieee->wx_sem);
 		}
 		else{
-- 
1.7.0

