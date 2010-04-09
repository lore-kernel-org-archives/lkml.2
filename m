Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0DIWdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:33:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:52270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab0DIWdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:33:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,179,1270450800"; 
   d="scan'208";a="507891376"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3/3] rtl8187se: Do not send NULL BSSID events when not associated
Date: Sat, 10 Apr 2010 00:33:19 +0200
Message-Id: <3fdd266bbfc9dc99b1b4e7a7488036f5d19151fd.1270851261.git.sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
References: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
In-Reply-To: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
References: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
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
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index be2d17f..f875425 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -2321,9 +2321,11 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 
 	if(IS_DOT11D_ENABLE(ieee))
 		Dot11d_Reset(ieee);
-	ieee->state = IEEE80211_NOLINK;
+
 	ieee->link_change(ieee->dev);
-	notify_wx_assoc_event(ieee);
+	if (ieee->state == IEEE80211_LINKED)
+		notify_wx_assoc_event(ieee);
+	ieee->state = IEEE80211_NOLINK;
 
 }
 void ieee80211_associate_retry_wq(struct work_struct *work)
-- 
1.7.0

